unit C4D.Conn.Configs;

interface

uses
  System.SysUtils,
  System.Classes,
  IniFiles,
  C4D.Conn.Types;

type
  TC4DConnConfigs = class
  private
    FComponentOfConnectionExisting: TComponent;
    FComponentConnection: TComponentConnection;
    FDriverConnection: TDriverConnection;
    FConnectionSingleton: Boolean;
    FHost: string;
    FUserName: string;
    FPassword: string;
    FDatabase: string;
    FPort: Integer;
    function DesCriptografaSenha(pStr: string): string;
  public
    class function New: TC4DConnConfigs;
    constructor Create;
    destructor Destroy; override;
    function ComponentOfConnectionExisting(Value: TComponent): TC4DConnConfigs; overload;
    function ComponentOfConnectionExisting: TComponent; overload;
    function ComponentConnection: TComponentConnection;
    function ComponentConnectionFireDac: TC4DConnConfigs;
    function DriverConnection: TDriverConnection;
    function DriverConnectionMySQL: TC4DConnConfigs;
    function DriverConnectionSQLite: TC4DConnConfigs;
    function ConnectionSingleton: Boolean;
    function ConnectionSingletonON: TC4DConnConfigs;
    function ConnectionSingletonOFF: TC4DConnConfigs;
    function Host: string; overload;
    function Host(Value: string): TC4DConnConfigs; overload;
    function UserName: string; overload;
    function UserName(Value: string): TC4DConnConfigs; overload;
    function Password: string; overload;
    function Password(Value: string): TC4DConnConfigs; overload;
    function PasswordCript(Value: string): TC4DConnConfigs; overload;
    function Database: string; overload;
    function Database(Value: string): TC4DConnConfigs; overload;
    function Port: Integer; overload;
    function Port(Value: Integer): TC4DConnConfigs; overload;
    function TestFieldFilling: TC4DConnConfigs;
    procedure CarregaDadosDeArqIni(pCaminhoArqIni: string);
  end;

implementation

class function TC4DConnConfigs.New: TC4DConnConfigs;
begin
  Result := Self.Create;
end;

constructor TC4DConnConfigs.Create;
begin
  FComponentOfConnectionExisting := nil;
  FConnectionSingleton := True;
  FComponentConnection := TComponentConnection.Empty;
  FDriverConnection := TDriverConnection.MySQL;
end;

destructor TC4DConnConfigs.Destroy;
begin
  inherited;
end;

function TC4DConnConfigs.ComponentOfConnectionExisting: TComponent;
begin
  Result := FComponentOfConnectionExisting;
end;

function TC4DConnConfigs.ComponentOfConnectionExisting(Value: TComponent): TC4DConnConfigs;
begin
  Result := Self;
  FComponentOfConnectionExisting := Value;
end;

function TC4DConnConfigs.ComponentConnection: TComponentConnection;
begin
  if FComponentConnection = TComponentConnection.Empty then
    raise Exception.Create('Componente para conexão com o banco não informado');
  Result := FComponentConnection;
end;

function TC4DConnConfigs.ComponentConnectionFireDac: TC4DConnConfigs;
begin
  Result := Self;
  if(FComponentConnection <> TComponentConnection.Empty)then
    raise Exception.Create('Componente para conexão já foi informado');
  FComponentConnection := TComponentConnection.FireDac;
end;

function TC4DConnConfigs.DriverConnection: TDriverConnection;
begin
  Result := FDriverConnection;
end;

function TC4DConnConfigs.DriverConnectionMySQL: TC4DConnConfigs;
begin
  Result := Self;
  FDriverConnection := TDriverConnection.MySQL;
end;

function TC4DConnConfigs.DriverConnectionSQLite: TC4DConnConfigs;
begin
  Result := Self;
  FDriverConnection := TDriverConnection.SQLite;
end;

function TC4DConnConfigs.ConnectionSingleton: Boolean;
begin
  Result := FConnectionSingleton;
end;

function TC4DConnConfigs.ConnectionSingletonON: TC4DConnConfigs;
begin
  Result := Self;
  FConnectionSingleton := True;
end;

function TC4DConnConfigs.ConnectionSingletonOFF: TC4DConnConfigs;
begin
  Result := Self;
  FConnectionSingleton := False;
end;

function TC4DConnConfigs.Host: string;
begin
  Result := FHost;
end;

function TC4DConnConfigs.Host(Value: string): TC4DConnConfigs;
begin
  Result := Self;
  FHost := Value;
end;

function TC4DConnConfigs.UserName: string;
begin
  Result := FUserName;
end;

function TC4DConnConfigs.UserName(Value: string): TC4DConnConfigs;
begin
  Result := Self;
  FUserName := Value;
end;

function TC4DConnConfigs.Password: string;
begin
  Result := FPassword;
end;

function TC4DConnConfigs.Password(Value: string): TC4DConnConfigs;
begin
  Result := Self;
  FPassword := Value;
end;

function TC4DConnConfigs.PasswordCript(Value: string): TC4DConnConfigs;
begin
  Result := Self;
  FPassword := Self.DesCriptografaSenha(Value);
end;

function TC4DConnConfigs.Database: string;
begin
  Result := FDatabase;
end;

function TC4DConnConfigs.Database(Value: string): TC4DConnConfigs;
begin
  Result := Self;
  FDatabase := Value;
end;

function TC4DConnConfigs.Port: Integer;
begin
  Result := FPort;
end;

function TC4DConnConfigs.Port(Value: Integer): TC4DConnConfigs;
begin
  Result := Self;
  FPort := Value;
end;

function TC4DConnConfigs.DesCriptografaSenha(pStr: string): string;
begin
  Result := pStr;
end;

function TC4DConnConfigs.TestFieldFilling: TC4DConnConfigs;
var
  LTemp: string;
begin
  Result := Self;
  LTemp := '';
  if(FDriverConnection <> TDriverConnection.SQLite)then
  begin
    if(Trim(FHost) = '')then
      LTemp := LTemp + 'Host. ';
    if(Trim(FUserName) = '')then
      LTemp := LTemp + 'Usuário. ';
    if(Trim(FPassword) = '')then
      LTemp := LTemp + 'Senha. ';
  end;
  if(Trim(FDatabase) = '')then
    LTemp := LTemp + 'Nome banco.';

  if(LTemp <> '')then
    raise Exception.Create('Para realizar a conexão com o banco de dados, os seguintes dados devem ser preenchidos: ' + LTemp);
end;

procedure TC4DConnConfigs.CarregaDadosDeArqIni(pCaminhoArqIni: string);
var
  LIniFile: TIniFile;
begin
  if(Trim(pCaminhoArqIni) = EmptyStr)then
    raise Exception.Create('Arquivo com configurações para acesso ao banco não informado');

  if(FileExists(pCaminhoArqIni) = False)then
    raise Exception.Create('Arquivo com configurações para acesso ao banco não encontrado: ' + pCaminhoArqIni);

  try
    LIniFile := TIniFile.Create(pCaminhoArqIni);
    try
      FHost := LIniFile.ReadString('ListaDeHost1', 'Host', FHost);
      FUserName := LIniFile.ReadString('ListaDeHost1', 'Usuario', FUserName);
      FPassword := Self.DesCriptografaSenha(LIniFile.ReadString('ListaDeHost1', 'Senha', FPassword));
      FDatabase := LIniFile.ReadString('ListaDeHost1', 'Banco', FDatabase);
      FPort := LIniFile.ReadInteger('ListaDeHost1', 'Porta', FPort);
    finally
      LIniFile.Free;
    end;

    if(Trim(FHost) = '')or(Trim(FUserName) = '')or(Trim(FDatabase) = '')then
      raise Exception.Create('Dados não foram encontrados no arquivo ini (host, usuário e nome do banco)');

  except
    on E: Exception do
      raise Exception.Create('Ocorreu uma exceção ao pegar dados para conexão com o banco de dados ' + sLineBreak +
        'Arquivo: ' + pCaminhoArqIni + sLineBreak +
        'Mensagem: ' + E.Message);
  end;
end;

end.
