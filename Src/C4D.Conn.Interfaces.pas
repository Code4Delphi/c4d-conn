unit C4D.Conn.Interfaces;

interface

uses
  Data.DB,
  System.Classes,
  C4D.Conn.Configs;

type
  IC4DConnection = interface
    ['{1495345D-9D24-4BA6-B9F5-830514B06DBD}']
    function Component: TComponent;
    function Open: IC4DConnection;
    function Close: IC4DConnection;
    function StartTransaction: IC4DConnection;
    function Commit: IC4DConnection;
    function Rollback: IC4DConnection;

    function TestConnection: Boolean;
    function TestConnectionOnly: Boolean;
    function LoadConnectionConfig: IC4DConnection;
  end;

  IC4DConnQuery = interface
    ['{4510C139-4A3F-4602-9B17-F93D00C5825F}']
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

    //AName = PARA MYSQL E FIREDAC NOME DO CAMPO
    function GetLastAutoGenValue(const AName: string): Variant;
  end;

  IC4DConn = interface
    ['{89324C16-161B-449E-AD00-2F1AACC30CA3}']
    function Configs: TC4DConnConfigs;
    function Connection: IC4DConnection;
    function Query: IC4DConnQuery; overload;
    function Query(ANameQuery: string): IC4DConnQuery; overload;
  end;

implementation

end.
