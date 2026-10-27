unit C4DConnDemo01.View.Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ExtCtrls,
  Vcl.Mask,
  Vcl.Buttons,
  Vcl.ComCtrls,
  C4D.Conn,
  PngBitBtn;

type
  TC4DConnDemo01ViewMain = class(TForm)
    DataSource1: TDataSource;
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    pnGrid: TPanel;
    DBGrid1: TDBGrid;
    bBoxDadosCadastrais: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtCodigo: TEdit;
    edtNome: TEdit;
    edtCPF: TMaskEdit;
    edtCEP: TMaskEdit;
    edtFone: TMaskEdit;
    edtAnoNascimento: TEdit;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    btnSelectDiretoNoOpen: TButton;
    btnInsertDiretoNoExecSQL: TButton;
    Button3: TButton;
    Panel2: TPanel;
    sbtnFechar: TSpeedButton;
    sbtnExcluir: TSpeedButton;
    sbtnAlterar: TSpeedButton;
    sbtnCancelar: TSpeedButton;
    sbtnGravar: TSpeedButton;
    sbtnNovo: TSpeedButton;
    sbtnAtualizar: TSpeedButton;
    TabSheet2: TTabSheet;
    pnBackupRestaurar: TPanel;
    lbRestauraBackupDatabase: TLabel;
    lbRestauraBackupPassword: TLabel;
    lbRestauraBackupHost: TLabel;
    lbRestauraBackupPort: TLabel;
    lbRestauraBackupUser: TLabel;
    edtDatabase: TEdit;
    edtPassword: TEdit;
    btnCriarNovaConexao: TPngBitBtn;
    edtHost: TEdit;
    edtPort: TEdit;
    edtUser: TEdit;
    mmLog: TMemo;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    Button4: TButton;
    sbtnAtualizar2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure sbtnFecharClick(Sender: TObject);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
    procedure sbtnAlterarClick(Sender: TObject);
    procedure sbtnGravarClick(Sender: TObject);
    procedure sbtnCancelarClick(Sender: TObject);
    procedure btnSelectDiretoNoOpenClick(Sender: TObject);
    procedure btnInsertDiretoNoExecSQLClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnCriarNovaConexaoClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure sbtnAtualizar2Click(Sender: TObject);
  private
    FQueryConsulta: IC4DConnQuery;

    procedure AtivarCadastro;
    procedure DesativarCadastro;
  public
  end;

var
  C4DConnDemo01ViewMain: TC4DConnDemo01ViewMain;

implementation

{$R *.dfm}


procedure TC4DConnDemo01ViewMain.FormCreate(Sender: TObject);
var
  LDatabase: string;
begin
  ReportMemoryLeaksOnShutdown := True;

  //BANCO SQLITE EM Samples\Data, CAMINHO RELATIVO AO EXE (Samples\Demo01\Bin)
  LDatabase := ExpandFileName(ExtractFilePath(Application.ExeName) + '..\..\Data\base_test.db');
  if not FileExists(LDatabase) then
    raise Exception.Create('Banco de dados não encontrado: ' + LDatabase);

  C4DConn
    .Configs
    //.GetInstance
    //.ConnectionSingletonON  //DEFAULT: True
    .ComponentConnectionFireDac
    .DriverConnectionSQLite
    .Database(LDatabase);

  //CONFIGURACAO PARA MYSQL
  //.DriverConnectionMySQL  //DEFAULT
  //.Host('127.0.0.1')
  //.UserName('root')
  //.Password('')
  //.Database('')
  //.Port(0);

  if not C4DConn.Connection.TestConnection then
    ShowMessage('Conexão OFF');

  FQueryConsulta := C4DConn.Query.DataSource(DataSource1);
  sbtnAtualizar.Click;
end;

procedure TC4DConnDemo01ViewMain.FormShow(Sender: TObject);
begin
  Self.DesativarCadastro;
  TabSheet1.Show;
end;

procedure TC4DConnDemo01ViewMain.AtivarCadastro;
begin
  sbtnNovo.Enabled := False;
  sbtnGravar.Enabled := True;
  sbtnCancelar.Enabled := True;
  sbtnAlterar.Enabled := False;
  sbtnExcluir.Enabled := False;
  sbtnAtualizar.Enabled := False;
  sbtnFechar.Enabled := False;

  bBoxDadosCadastrais.Enabled := True;
  pnGrid.Enabled := False;

  DataSource1.DataSet.DisableControls;

  edtNome.SetFocus;
end;

procedure TC4DConnDemo01ViewMain.DesativarCadastro;
begin
  edtCodigo.Clear;
  edtNome.Clear;
  edtCPF.Clear;
  edtCEP.Clear;
  edtFone.Clear;
  edtAnoNascimento.Clear;

  sbtnNovo.Enabled := True;
  sbtnGravar.Enabled := False;
  sbtnCancelar.Enabled := False;
  sbtnAlterar.Enabled := True;
  sbtnExcluir.Enabled := True;
  sbtnAtualizar.Enabled := True;
  sbtnFechar.Enabled := True;

  bBoxDadosCadastrais.Enabled := False;
  pnGrid.Enabled := True;

  DataSource1.DataSet.EnableControls;
end;

procedure TC4DConnDemo01ViewMain.sbtnAlterarClick(Sender: TObject);
begin
  if FQueryConsulta.IsEmpty then
  begin
    ShowMessage('Selecione um registro para ser alterado');
    Exit;
  end;

  edtCodigo.Text := FQueryConsulta.FieldByName('id').AsString;
  edtNome.Text := FQueryConsulta.FieldByName('nome').AsString;
  edtCPF.Text := FQueryConsulta.FieldByName('cpf').AsString;
  edtFone.Text := FQueryConsulta.FieldByName('fone').AsString;
  edtCEP.Text := FQueryConsulta.FieldByName('cep').AsString;
  edtAnoNascimento.Text := FQueryConsulta.FieldByName('ano_nascimento').AsString;

  Self.AtivarCadastro;
end;

procedure TC4DConnDemo01ViewMain.sbtnAtualizar2Click(Sender: TObject);
begin
  FQueryConsulta
    .Clear
    .Add('select id, nome, ano_nascimento')
    .Add('from clientes')
    .AddCond('and nome like :nome')
    .AddCondParam('nome', '%' + Trim(edtNome.Text) + '%');

  FQueryConsulta
    .AddCond('and ano_nascimento >= :ano')
    .AddCondParam('ano', 2000);

  FQueryConsulta
    .AddOrder('nome')
    .AddLimit('limit 10')
    .Open;

  StatusBar1.Panels[1].Text := 'Total de registros: ' + FQueryConsulta.RecordCountStr;
end;

procedure TC4DConnDemo01ViewMain.sbtnAtualizarClick(Sender: TObject);
begin
  FQueryConsulta.Text('select *from clientes').Open;
  FQueryConsulta.Open('select *from clientes').Last;
  StatusBar1.Panels[1].Text := 'Total de registros: ' + FQueryConsulta.RecordCountStr;

  {FQueryConsulta.Clear.Add('select *from clientes');





   FQueryConsulta.DataSet.FieldDefs.Update;
   for i := 0 to FQueryConsulta.DataSet.FieldDefs.Count - 1 do
   FQueryConsulta.DataSet.FieldDefs[i].CreateField(FQueryConsulta.DataSet);

   Field := TIntegerField.Create(FQueryConsulta.DataSet);
   Field.FieldName  := 'campo_calculado';
   Field.Calculated := True;
   Field.DataSet    := FQueryConsulta.DataSet;
   FQueryConsulta.Open.Last;

   StatusBar1.Panels[1].Text := 'Total de registros: ' + FQueryConsulta.RecordCountStr;  }
end;

procedure TC4DConnDemo01ViewMain.Button4Click(Sender: TObject);
begin
  //   FQueryConsulta.First;
  //   while(not FQueryConsulta.Eof)do
  //   begin
  //      FQueryConsulta.Edit;
  //      FQueryConsulta.FieldByName('campo_calculado').AsInteger :=  FQueryConsulta.FieldByName('id').AsInteger * 2;
  //      FQueryConsulta.Post;
  //      FQueryConsulta.Next;
  //   end;
end;

procedure TC4DConnDemo01ViewMain.sbtnCancelarClick(Sender: TObject);
begin
  Self.DesativarCadastro;
end;

procedure TC4DConnDemo01ViewMain.sbtnExcluirClick(Sender: TObject);
begin
  if FQueryConsulta.IsEmpty then //if(DataSource1.DataSet.IsEmpty)then
  begin
    ShowMessage('Selecione um registro para ser excluído');
    Exit;
  end;

  if Application.MessageBox(PChar('Confirma exclusão do cliente: ' + FQueryConsulta.FieldByName('nome').AsString + '?'),
    'Confirma exclusão?', MB_YESNO) = idNo then
    Exit;

  //TC4DConnFactory.New.Query.Add('delete from teste where(id = "'+ FQueryConsulta.Query.FieldByName('Id').AsString +'") limit 1').ExecSQL;
  FQueryConsulta.Delete;

  sbtnAtualizar.Click;
end;

procedure TC4DConnDemo01ViewMain.sbtnFecharClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TC4DConnDemo01ViewMain.sbtnGravarClick(Sender: TObject);
var
  LCond: string;
  LQuery: IC4DConnQuery;
begin
  if Trim(edtNome.Text).IsEmpty then
  begin
    ShowMessage('Preencha o campo nome');
    edtNome.SetFocus;
    Exit;
  end;

  if Trim(edtCodigo.Text).IsEmpty then
    LCond := 'limit 0'
  else
    LCond := 'where(id = ' + Trim(edtCodigo.Text) + ')limit 1';

  LQuery := C4DConn.Query;
  LQuery
    .Text('select *from clientes ' + LCond)
    .Open;

  if Trim(edtCodigo.Text).IsEmpty then
  begin
    LQuery.Append;
    LQuery.FieldByName('dh_cadastro').AsDateTime := Now;
  end
  else
    LQuery.Edit;

  LQuery.FieldByName('nome').AsString := edtNome.Text;
  LQuery.FieldByName('cpf').AsString := edtCPF.Text;
  LQuery.FieldByName('fone').AsString := edtFone.Text;
  LQuery.FieldByName('cep').AsString := edtCEP.Text;
  LQuery.FieldByName('ano_nascimento').AsString := edtAnoNascimento.Text;
  LQuery.Post;

  Self.DesativarCadastro;
  sbtnAtualizar.Click;

  FQueryConsulta.DataSet.Locate('id', LQuery.FieldByName('id').AsInteger, []);
end;

procedure TC4DConnDemo01ViewMain.sbtnNovoClick(Sender: TObject);
begin
  Self.AtivarCadastro;
end;

procedure TC4DConnDemo01ViewMain.Button1Click(Sender: TObject);
begin
  C4DConn.Query.Add('insert into clientes(nome, dh_cadastro)values(''Nome teste: '' || time(''now'', ''localtime''), datetime(''now'', ''localtime''))').ExecSQL;
  sbtnAtualizar.Click;
end;

procedure TC4DConnDemo01ViewMain.Button2Click(Sender: TObject);
var
  LQuery: IC4DConnQuery;
begin
  LQuery := C4DConn.Query;
  LQuery
    .Add('insert into clientes(nome, dh_cadastro)values(''Nome teste: '' || time(''now'', ''localtime''), datetime(''now'', ''localtime''))')
    .ExecSQL;

  LQuery
    .Text('insert into clientes(nome, dh_cadastro)values(''Nome teste: '' || time(''now'', ''localtime''), datetime(''now'', ''localtime''))')
    .ExecSQL;

  LQuery
    .Clear
    .Add('insert into clientes(nome, dh_cadastro)values(''Nome teste: '' || time(''now'', ''localtime''), datetime(''now'', ''localtime''))')
    .ExecSQL;

  sbtnAtualizar.Click;
end;

procedure TC4DConnDemo01ViewMain.Button3Click(Sender: TObject);
begin
  ShowMessage(FQueryConsulta.SQL.Text);
end;

procedure TC4DConnDemo01ViewMain.btnInsertDiretoNoExecSQLClick(Sender: TObject);
begin
  C4DConn.Query.ExecSQL('insert into clientes(nome, dh_cadastro)values(''Nome teste direto pelo ExecSQL: '' || time(''now'', ''localtime''), datetime(''now'', ''localtime''))');
  sbtnAtualizar.Click;
end;

procedure TC4DConnDemo01ViewMain.btnSelectDiretoNoOpenClick(Sender: TObject);
begin
  FQueryConsulta.Open('select *from clientes');
end;

procedure TC4DConnDemo01ViewMain.btnCriarNovaConexaoClick(Sender: TObject);
var
  LC4DConn: IC4DConn;
  LQueryConsulta: IC4DConnQuery;
begin
  mmLog.Lines.Clear;

  LC4DConn := TC4DConn.New;
  LC4DConn
    .Configs
    //.ConnectionSingletonOFF  //DEFAULT: True
    .ComponentConnectionFireDac
    .Host(edtHost.Text)
    .UserName(edtUser.Text)
    .Password(edtPassword.Text)
    .Database(edtDatabase.Text)
    .Port(0);

  if not LC4DConn.Connection.TestConnection then
    mmLog.Lines.Add('Conexão OFF');

  LQueryConsulta := LC4DConn.Query;
  LQueryConsulta.Open('select Id, Nome_empre from parametros');
  while not LQueryConsulta.Eof do
  begin
    mmLog.Lines.Add(LQueryConsulta.FieldByName('Id').AsString + ' - ' +
      LQueryConsulta.FieldByName('Nome_empre').AsString);
    LQueryConsulta.Next;
  end;
end;

end.
