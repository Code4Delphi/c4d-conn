unit C4D.Conn.Firedac.Query;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.Generics.Collections,
  Firedac.Stan.Intf,
  Firedac.Stan.Option,
  Firedac.Stan.Param,
  Firedac.Stan.Error,
  Firedac.DatS,
  Firedac.Phys.Intf,
  Firedac.DApt.Intf,
  Firedac.Stan.Async,
  Firedac.DApt,
  Data.DB,
  Firedac.Comp.DataSet,
  Firedac.Comp.Client,
  Firedac.Stan.Def,
  C4D.Conn.Interfaces,
  C4D.Conn.Firedac,
  C4D.Conn.Utils;

type
  TC4DConnFiredacQuery = class(TInterfacedObject, IC4DConnQuery)
  private
    FC4DConnection: IC4DConnection;
    FQuery: TFDQuery;
    FListCond: TStringList;
    FListCondParam: TDictionary<string, Variant>;
    FListGroup: TStringList;
    FListOrder: TStringList;
    FListLimit: TStringList;
    procedure ProcessaListCond;
    procedure ProcessaListGroup;
    procedure ProcessaListOrder;
    procedure ProcessaListLimit;
    procedure CriaCamposDaQuery;
  protected
    function Close: IC4DConnQuery;
    function Clear: IC4DConnQuery;
    function CloseClear: IC4DConnQuery;
    function Add(AValue: string): IC4DConnQuery;
    function AddParam(AParam: string; AValue: Variant): IC4DConnQuery;
    function AddCond(ACond: string): IC4DConnQuery;
    function AddCondParam(AParam: string; AValue: Variant): IC4DConnQuery;
    function AddGroup(ACond: string): IC4DConnQuery;
    function AddOrder(ACond: string): IC4DConnQuery;
    function AddLimit(ACond: string): IC4DConnQuery;
    function Text(AValue: string): IC4DConnQuery;
    function SQL: TStrings;
    function ExecSQL: IC4DConnQuery; overload;
    function ExecSQL(const ASQL: string): IC4DConnQuery; overload;
    function Open: IC4DConnQuery; overload;
    function Open(const ASQL: string): IC4DConnQuery; overload;

    function DataSet: TDataSet;
    function DataSource(AValue: TDataSource): IC4DConnQuery;
    function DataSourceMasterDetail(AValue: TDataSource): IC4DConnQuery;

    function Append: IC4DConnQuery;
    function Edit: IC4DConnQuery;
    function Post: IC4DConnQuery;
    function Delete: IC4DConnQuery;

    function Eof: Boolean;
    function Bof: Boolean;
    function Prior: IC4DConnQuery;
    function Next: IC4DConnQuery;
    function First: IC4DConnQuery;
    function Last: IC4DConnQuery;
    function IsEmpty: Boolean;
    function RowsAffected: Integer;
    function FieldByName(AValue: string): TField;
    function RecNo: Integer;
    function RecordCount: Integer;
    function RecordCountStr(ANumZerosLeft: Integer = 6): string;
    function GetLastAutoGenValue(const AName: string): Variant;
  public
    class function New(AC4DConnection: IC4DConnection; ANameQuery: string): IC4DConnQuery;
    constructor Create(AC4DConnection: IC4DConnection; ANameQuery: string);
    destructor Destroy; override;
  end;

implementation

class function TC4DConnFiredacQuery.New(AC4DConnection: IC4DConnection; ANameQuery: string): IC4DConnQuery;
begin
  Result := Self.Create(AC4DConnection, ANameQuery);
end;

constructor TC4DConnFiredacQuery.Create(AC4DConnection: IC4DConnection; ANameQuery: string);
begin
  FC4DConnection := AC4DConnection;

  FQuery := TFDQuery.Create(nil);
  FQuery.Name := ANameQuery;
  FQuery.FetchOptions.Mode := fmAll;
  FQuery.Connection := TFDConnection(FC4DConnection.Component);
  FQuery.Close;
  FQuery.SQL.Clear;

  FListCond := TStringList.Create;
  FListCondParam := TDictionary<string, Variant>.Create;
  FListGroup := TStringList.Create;
  FListOrder := TStringList.Create;
  FListLimit := TStringList.Create;
end;

destructor TC4DConnFiredacQuery.Destroy;
begin
  FListLimit.Free;
  FListOrder.Free;
  FListGroup.Free;
  FListCondParam.Free;
  FListCond.Free;
  FreeAndNil(FQuery);
  inherited;
end;

function TC4DConnFiredacQuery.Close: IC4DConnQuery;
begin
  Result := Self;
  FQuery.Close;
end;

function TC4DConnFiredacQuery.Clear: IC4DConnQuery;
begin
  Result := Self;
  FQuery.SQL.Clear;
  FListCond.Clear;
  FListCondParam.Clear;
  FListLimit.Clear;
  FListGroup.Clear;
  FListOrder.Clear;
end;

function TC4DConnFiredacQuery.CloseClear: IC4DConnQuery;
begin
  Result := Self;
  Self.Close;
  Self.Clear;
end;

function TC4DConnFiredacQuery.Add(AValue: string): IC4DConnQuery;
begin
  Result := Self;
  FQuery.SQL.Add(AValue);
end;

function TC4DConnFiredacQuery.AddParam(AParam: string; AValue: Variant): IC4DConnQuery;
begin
  Result := Self;
  FQuery.ParamByName(AParam).Value := AValue;
end;

function TC4DConnFiredacQuery.AddCond(ACond: string): IC4DConnQuery;
begin
  Result := Self;
  FListCond.Add(ACond);
end;

function TC4DConnFiredacQuery.AddCondParam(AParam: string; AValue: Variant): IC4DConnQuery;
begin
  Result := Self;
  FListCondParam.Add(AParam, AValue);
end;

function TC4DConnFiredacQuery.AddGroup(ACond: string): IC4DConnQuery;
begin
  Result := Self;
  FListGroup.Add(ACond);
end;

function TC4DConnFiredacQuery.AddOrder(ACond: string): IC4DConnQuery;
begin
  Result := Self;
  FListOrder.Add(ACond);
end;

function TC4DConnFiredacQuery.AddLimit(ACond: string): IC4DConnQuery;
begin
  Result := Self;
  FListLimit.Add(ACond);
end;

function TC4DConnFiredacQuery.Text(AValue: string): IC4DConnQuery;
begin
  Result := Self;
  FQuery.SQL.Text := AValue;
end;

function TC4DConnFiredacQuery.ExecSQL: IC4DConnQuery;
begin
  Result := Self;
  FQuery.ExecSQL;
end;

function TC4DConnFiredacQuery.ExecSQL(const ASQL: string): IC4DConnQuery;
begin
  Result := Self;
  FQuery.ExecSQL(ASQL);
end;

function TC4DConnFiredacQuery.Open: IC4DConnQuery;
begin
  Result := Self;
  Self.ProcessaListCond;
  Self.ProcessaListGroup;
  Self.ProcessaListOrder;
  Self.ProcessaListLimit;
  Self.CriaCamposDaQuery;
  FQuery.Open;
end;

function TC4DConnFiredacQuery.Open(const ASQL: string): IC4DConnQuery;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(ASQL);
  Self.CriaCamposDaQuery;
  FQuery.Open;
  //FQuery.Open(ASQL);
end;

procedure TC4DConnFiredacQuery.ProcessaListCond;
var
  LCond: string;
  i: Integer;
  LKey: string;
  LValue: Variant;
begin
  if FListCond.Count <= 0 then
    Exit;

  LCond := '';
  for i := 0 to Pred(FListCond.Count) do
    LCond := LCond + FListCond.Strings[i] + sLineBreak;

  LCond := TC4DConnUtils.SQLConfBusca(LCond);
  FQuery.SQL.Add(LCond);

  for LKey in FListCondParam.Keys do
    if FListCondParam.TryGetValue(LKey, LValue) then
      Self.AddParam(LKey, LValue);
end;

procedure TC4DConnFiredacQuery.ProcessaListGroup;
var
  LGroup: string;
  i: Integer;
begin
  if FListGroup.Count <= 0 then
    Exit;

  LGroup := '';
  for i := 0 to Pred(FListGroup.Count) do
    LGroup := LGroup + FListGroup.Strings[i].Trim + ', ';

  if Pos('group by', LGroup) <= 0 then
    LGroup := 'group by ' + LGroup;

  LGroup := LGroup.Trim;
  System.Delete(LGroup, LGroup.Length, 1);
  FQuery.SQL.Add(LGroup);
end;

procedure TC4DConnFiredacQuery.ProcessaListOrder;
var
  LOrdem: string;
  i: Integer;
begin
  if FListOrder.Count <= 0 then
    Exit;

  LOrdem := '';
  for i := 0 to Pred(FListOrder.Count) do
    LOrdem := LOrdem + FListOrder.Strings[i].Trim + ', ';

  if Pos(LOrdem, 'order by') <= 0 then
    LOrdem := 'order by ' + LOrdem;

  LOrdem := LOrdem.Trim;
  System.Delete(LOrdem, LOrdem.Length, 1);
  FQuery.SQL.Add(LOrdem);
end;

procedure TC4DConnFiredacQuery.ProcessaListLimit;
var
  i: Integer;
begin
  for i := 0 to Pred(FListLimit.Count) do
    FQuery.SQL.Add(FListLimit.Strings[i]);
end;

procedure TC4DConnFiredacQuery.CriaCamposDaQuery;
var
  i: Integer;
begin
  Exit;
  FQuery.FieldDefs.Update;
  for i := 0 to Pred(FQuery.FieldDefs.Count) do
    FQuery.FieldDefs[i].CreateField(FQuery);
end;

function TC4DConnFiredacQuery.DataSet: TDataSet;
begin
  Result := FQuery;
end;

function TC4DConnFiredacQuery.DataSource(AValue: TDataSource): IC4DConnQuery;
begin
  Result := Self;
  AValue.DataSet := FQuery;
end;

function TC4DConnFiredacQuery.DataSourceMasterDetail(AValue: TDataSource): IC4DConnQuery;
begin
  Result := Self;
  FQuery.MasterSource := AValue;
end;

function TC4DConnFiredacQuery.Append: IC4DConnQuery;
begin
  Result := Self;
  FQuery.Append;
end;

function TC4DConnFiredacQuery.Edit: IC4DConnQuery;
begin
  Result := Self;
  FQuery.Edit;
end;

function TC4DConnFiredacQuery.Post: IC4DConnQuery;
begin
  Result := Self;
  FQuery.Post;
end;

function TC4DConnFiredacQuery.Delete: IC4DConnQuery;
begin
  Result := Self;
  FQuery.Delete;
end;

function TC4DConnFiredacQuery.Eof: Boolean;
begin
  Result := FQuery.Eof;
end;

function TC4DConnFiredacQuery.Bof: Boolean;
begin
  Result := FQuery.Bof;
end;

function TC4DConnFiredacQuery.Prior: IC4DConnQuery;
begin
  Result := Self;
  FQuery.Prior;
end;

function TC4DConnFiredacQuery.Next: IC4DConnQuery;
begin
  Result := Self;
  FQuery.Next;
end;

function TC4DConnFiredacQuery.First: IC4DConnQuery;
begin
  Result := Self;
  FQuery.First;
end;

function TC4DConnFiredacQuery.Last: IC4DConnQuery;
begin
  Result := Self;
  FQuery.Last;
end;

function TC4DConnFiredacQuery.IsEmpty: Boolean;
begin
  Result := FQuery.IsEmpty;
end;

function TC4DConnFiredacQuery.RowsAffected: Integer;
begin
  Result := FQuery.RowsAffected;
end;

function TC4DConnFiredacQuery.SQL: TStrings;
begin
  Result := FQuery.SQL;
end;

function TC4DConnFiredacQuery.FieldByName(AValue: string): TField;
begin
  Result := FQuery.FieldByName(AValue);
end;

function TC4DConnFiredacQuery.RecNo: Integer;
begin
  Result := FQuery.RecNo;
end;

function TC4DConnFiredacQuery.RecordCount: Integer;
begin
  Result := FQuery.RecordCount;
end;

function TC4DConnFiredacQuery.RecordCountStr(ANumZerosLeft: Integer = 6): string;
begin
  Result := FQuery.RecordCount.ToString.PadLeft(ANumZerosLeft, '0');
end;

//AName = PARA MYSQL E FIREDAC NOME DO CAMPO
function TC4DConnFiredacQuery.GetLastAutoGenValue(const AName: string): Variant;
begin
  try
    Result := FQuery.Connection.GetLastAutoGenValue(AName);
  except on E: Exception do
    raise Exception.Create('Não foi possível recuperar o último código/id inserido no banco de dados: ' + E.Message);
  end;
end;

end.
