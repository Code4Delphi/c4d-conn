unit C4D.Conn.Configs;

interface

uses
  System.SysUtils,
  System.Classes,
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
  public
    class function New: TC4DConnConfigs;
    constructor Create;
    destructor Destroy; override;
    function ComponentOfConnectionExisting(AValue: TComponent): TC4DConnConfigs; overload;
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
    function Host(AValue: string): TC4DConnConfigs; overload;
    function UserName: string; overload;
    function UserName(AValue: string): TC4DConnConfigs; overload;
    function Password: string; overload;
    function Password(AValue: string): TC4DConnConfigs; overload;
    function Database: string; overload;
    function Database(AValue: string): TC4DConnConfigs; overload;
    function Port: Integer; overload;
    function Port(AValue: Integer): TC4DConnConfigs; overload;
    function TestFieldFilling: TC4DConnConfigs;
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

function TC4DConnConfigs.ComponentOfConnectionExisting(AValue: TComponent): TC4DConnConfigs;
begin
  Result := Self;
  FComponentOfConnectionExisting := AValue;
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
  if FComponentConnection <> TComponentConnection.Empty then
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

function TC4DConnConfigs.Host(AValue: string): TC4DConnConfigs;
begin
  Result := Self;
  FHost := AValue;
end;

function TC4DConnConfigs.UserName: string;
begin
  Result := FUserName;
end;

function TC4DConnConfigs.UserName(AValue: string): TC4DConnConfigs;
begin
  Result := Self;
  FUserName := AValue;
end;

function TC4DConnConfigs.Password: string;
begin
  Result := FPassword;
end;

function TC4DConnConfigs.Password(AValue: string): TC4DConnConfigs;
begin
  Result := Self;
  FPassword := AValue;
end;

function TC4DConnConfigs.Database: string;
begin
  Result := FDatabase;
end;

function TC4DConnConfigs.Database(AValue: string): TC4DConnConfigs;
begin
  Result := Self;
  FDatabase := AValue;
end;

function TC4DConnConfigs.Port: Integer;
begin
  Result := FPort;
end;

function TC4DConnConfigs.Port(AValue: Integer): TC4DConnConfigs;
begin
  Result := Self;
  FPort := AValue;
end;

function TC4DConnConfigs.TestFieldFilling: TC4DConnConfigs;
var
  LTemp: string;
begin
  Result := Self;
  LTemp := '';
  if FDriverConnection <> TDriverConnection.SQLite then
  begin
    if FHost.Trim.IsEmpty then
      LTemp := LTemp + 'Host. ';

    if FUserName.Trim.IsEmpty then
      LTemp := LTemp + 'Usuário. ';

    if FPassword.Trim.IsEmpty then
      LTemp := LTemp + 'Senha. ';
  end;

  if FDatabase.Trim.IsEmpty then
    LTemp := LTemp + 'Nome banco.';

  if not LTemp.IsEmpty then
    raise Exception.Create('Para realizar a conexão com o banco de dados, os seguintes dados devem ser preenchidos: ' + LTemp);
end;

end.
