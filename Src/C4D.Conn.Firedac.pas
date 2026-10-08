unit C4D.Conn.Firedac;

interface

uses
  {$IFNDEF CONSOLE}
  Firedac.VCLUI.Wait,
  {$ENDIF}
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  Firedac.Stan.Intf,
  Firedac.Stan.Option,
  Firedac.Stan.Error,
  Firedac.UI.Intf,
  Firedac.Phys.Intf,
  Firedac.Stan.Def,
  Firedac.Stan.Pool,
  Firedac.Stan.Async,
  Firedac.Phys,
  Data.DB,
  Firedac.Comp.Client,
  Firedac.DApt,
  Firedac.Comp.UI,
  Firedac.Phys.MySQLDef,
  Firedac.Phys.MySQL,
  Firedac.Phys.SQLiteDef,
  Firedac.Phys.SQLite,
  {$IFDEF MSWINDOWS}
  Firedac.Phys.SQLiteWrapper.Stat,
  {$ENDIF}
  Firedac.Stan.ExprFuncs,
  C4D.Conn.Interfaces,
  C4D.Conn.Configs,
  C4D.Conn.Types;

type
  TC4DConnFiredac = class(TInterfacedObject, IC4DConnection)
  private
    [weak]
    FC4DConnConfigs: TC4DConnConfigs;
    FConnection: TFDConnection;
    function TestFieldsComponentConnection: IC4DConnection;
  protected
    function Component: TComponent;
    function Open: IC4DConnection;
    function Close: IC4DConnection;
    function StartTransaction: IC4DConnection;
    function Commit: IC4DConnection;
    function Rollback: IC4DConnection;
    function TestConnection: Boolean;
    function TestConnectionOnly: Boolean;
    function LoadConnectionConfig: IC4DConnection;
  public
    class function New(AC4DConnConfigs: TC4DConnConfigs): IC4DConnection;
    constructor Create(AC4DConnConfigs: TC4DConnConfigs);
    destructor Destroy; override;
  end;

implementation

class function TC4DConnFiredac.New(AC4DConnConfigs: TC4DConnConfigs): IC4DConnection;
begin
  Result := Self.Create(AC4DConnConfigs);
end;

constructor TC4DConnFiredac.Create(AC4DConnConfigs: TC4DConnConfigs);
begin
  FC4DConnConfigs := AC4DConnConfigs;
  if(FC4DConnConfigs.ComponentOfConnectionExisting <> nil)then //(TC4DConnConfigs.GetInstance.ComponentOfConnectionExisting <> nil)then
    FConnection := TFDConnection(FC4DConnConfigs.ComponentOfConnectionExisting)
  else
  begin
    FConnection := TFDConnection.Create(nil);
    Self.LoadConnectionConfig;
  end;
end;

destructor TC4DConnFiredac.Destroy;
begin
  if(FC4DConnConfigs.ComponentOfConnectionExisting = nil)then
  begin
    FConnection.Connected := False;
    FreeAndNil(FConnection);
  end;
  inherited;
end;

function TC4DConnFiredac.LoadConnectionConfig: IC4DConnection;
begin
  Result := Self;
  FConnection.Connected := False;
  FConnection.Params.Clear;
  case(FC4DConnConfigs.DriverConnection)of
    TDriverConnection.MySQL:
    begin
      FConnection.Params.DriverID := 'MySQL';
      FConnection.Params.Database := FC4DConnConfigs.Database;
      FConnection.Params.UserName := FC4DConnConfigs.UserName;
      FConnection.Params.Password := FC4DConnConfigs.Password;
      FConnection.Params.Add('Server=' + FC4DConnConfigs.Host);
      FConnection.Params.Add('Port=' + FC4DConnConfigs.Port.ToString);
    end;
    TDriverConnection.SQLite:
    begin
      FConnection.Params.DriverID := 'SQLite';
      FConnection.Params.Database := FC4DConnConfigs.Database;
      FConnection.Params.Add('LockingMode=Normal');
      FConnection.Params.Add('StringFormat=Unicode');
    end;
  end;
end;

{FConnection.TXOptions.AutoStart  := True;
 FConnection.TXOptions.AutoStop   := True;
 FConnection.TXOptions.AutoCommit := True;
 FConnection.TxOptions.StopOptions := [xoIfAutoStarted, xoFinishRetaining];
 FConnection.UpdateOptions.AutoCommitUpdates := True;
 FConnection.UpdateOptions.RefreshMode       := rmAll;  }

function TC4DConnFiredac.Component: TComponent;
begin
  Result := FConnection;
end;

function TC4DConnFiredac.Open: IC4DConnection;
begin
  Result := Self;
  Self.TestFieldsComponentConnection;
  FConnection.Connected := True;
end;

function TC4DConnFiredac.Close: IC4DConnection;
begin
  Result := Self;
  FConnection.Connected := False;
end;

function TC4DConnFiredac.StartTransaction: IC4DConnection;
begin
  FConnection.StartTransaction;
end;

function TC4DConnFiredac.Commit: IC4DConnection;
begin
  FConnection.Commit;
end;

function TC4DConnFiredac.Rollback: IC4DConnection;
begin
  FConnection.Rollback;
end;

function TC4DConnFiredac.TestConnection: Boolean;
var
  LConnectedOld: Boolean;
begin
  Self.TestFieldsComponentConnection;
  try
    LConnectedOld := FConnection.Connected;
    FConnection.Connected := True;
    Result := FConnection.Connected;
    if(FConnection.Connected <> LConnectedOld)then
      FConnection.Connected := LConnectedOld;
  except
    on E: exception do
      raise exception.Create('Conexão não pode ser realizada: ' + E.Message);
  end;
end;

function TC4DConnFiredac.TestConnectionOnly: Boolean;
var
  LConnectedOld: Boolean;
begin
  Result := False;
  try
    LConnectedOld := FConnection.Connected;
    FConnection.Connected := True;
    Result := FConnection.Connected;
    if(FConnection.Connected <> LConnectedOld)then
      FConnection.Connected := LConnectedOld;
  except
  end;
end;

function TC4DConnFiredac.TestFieldsComponentConnection: IC4DConnection;
var
  LCamposSemPreenchar: string;
begin
  Result := Self;
  LCamposSemPreenchar := '';
  if(FC4DConnConfigs.DriverConnection <> TDriverConnection.SQLite)then
  begin
    if(FC4DConnConfigs.Database.Trim.IsEmpty)then
      LCamposSemPreenchar := LCamposSemPreenchar + 'Host. ';
    if(FConnection.Params.UserName.Trim.IsEmpty)then
      LCamposSemPreenchar := LCamposSemPreenchar + 'Usuário. ';
    if(FConnection.Params.Password.Trim.IsEmpty)then
      LCamposSemPreenchar := LCamposSemPreenchar + 'Senha. ';
  end;
  if(Trim(FConnection.Params.Database).IsEmpty)then
    LCamposSemPreenchar := LCamposSemPreenchar + 'Nome banco.';

  if(not LCamposSemPreenchar.Trim.IsEmpty)then
    raise exception.Create('Para realizar a conexão com o banco de dados, os seguintes dados devem ser preenchidos: ' + LCamposSemPreenchar);
end;

end.
