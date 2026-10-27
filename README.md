# C4D Conn

Biblioteca Delphi para conexão com banco de dados e execução de consultas usando **FireDAC**, com interface fluente (*fluent interface*) e gerenciamento automático de memória via interfaces.

Com ela você configura a conexão em poucas linhas, cria queries sem precisar instanciar ou liberar componentes manualmente e monta SQLs dinâmicos (filtros, agrupamento, ordenação e limite) de forma simples.

## Recursos

- Conexão via FireDAC com os drivers **MySQL** e **SQLite**
- Interface fluente para configurar a conexão e montar as consultas
- Conexão global pronta para uso através da função `C4DConn` (singleton)
- Criação de conexões independentes com `TC4DConn.New` (vários bancos ao mesmo tempo)
- Reaproveitamento de um `TFDConnection` já existente (ex.: de um DataModule)
- Queries baseadas em interface (`IC4DConnQuery`), liberadas automaticamente
- Montagem dinâmica de condições (`where`), `group by`, `order by` e `limit`
- Controle de transações (`StartTransaction`, `Commit` e `Rollback`)
- Teste de conexão com validação dos dados obrigatórios
- Ligação direta com `TDataSource` (grids, master/detail)

## Requisitos

- Delphi 10 Seattle ou superior
- FireDAC
- atualmente pode ser usado com MySQL e SQLite

> Os exemplos deste README usam variáveis inline (`var LQuery := ...`), recurso disponível a partir do Delphi 10.3 Rio. Em versões anteriores, declare as variáveis na seção `var` do método.

## Instalação

### Via Boss

```bash
boss install github.com/Code4Delphi/c4d-conn
```

### Manual

1. Faça o clone ou download do repositório
2. Adicione a pasta `Src` ao *Search Path* do seu projeto (ou ao *Library Path* do Delphi)
3. Adicione a unit `C4D.Conn` na cláusula `uses`

```delphi
uses
  C4D.Conn;
```

> A unit `C4D.Conn` já expõe os tipos `IC4DConn` e `IC4DConnQuery`. Caso precise declarar variáveis explicitamente do tipo `IC4DConnection`, adicione também a unit `C4D.Conn.Interfaces`.

## Uso rápido

```delphi
uses
  C4D.Conn;

procedure TViewMain.FormCreate(Sender: TObject);
begin
  C4DConn
    .Configs
    .ComponentConnectionFireDac
    .DriverConnectionMySQL
    .Host('127.0.0.1')
    .Port(3306)
    .UserName('root')
    .Password('minha_senha')
    .Database('meu_banco');

  C4DConn.Connection.TestConnection;

  var LQuery := C4DConn.Query;
  LQuery.Open('select id, nome from clientes');
  while not LQuery.Eof do
  begin
    mmLog.Lines.Add(LQuery.FieldByName('id').AsString + ' - ' + LQuery.FieldByName('nome').AsString);
    LQuery.Next;
  end;
end;
```

Não é necessário liberar a query: como ela é uma interface, é destruída automaticamente ao sair do escopo.

## Configuração da conexão

A configuração é feita através de `Configs`. O método `ComponentConnectionFireDac` é **obrigatório** e deve ser chamado apenas uma vez por instância (chamá-lo novamente gera a exceção *"Componente para conexão já foi informado"*). Por isso, faça a configuração em um único ponto do sistema, como no `OnCreate` do form principal ou do DataModule.

### MySQL

O driver MySQL é o padrão.

```delphi
C4DConn
  .Configs
  .ComponentConnectionFireDac
  .DriverConnectionMySQL
  .Host('127.0.0.1')
  .Port(3306)
  .UserName('root')
  .Password('minha_senha')
  .Database('meu_banco');
```

### SQLite

Para o SQLite basta informar o caminho do arquivo do banco em `Database`.

```delphi
var LDatabase := ExtractFilePath(Application.ExeName) + 'dados.db';

C4DConn
  .Configs
  .ComponentConnectionFireDac
  .DriverConnectionSQLite
  .Database(LDatabase);
```

### Usando um TFDConnection já existente

Se o projeto já possui um `TFDConnection` configurado (por exemplo em um DataModule), ele pode ser reaproveitado. Nesse caso a biblioteca não altera os parâmetros do componente e também não o libera da memória.

```delphi
C4DConn
  .Configs
  .ComponentConnectionFireDac
  .ComponentOfConnectionExisting(DM.FDConnection1);
```

> Como a validação de `TestConnection` usa os dados informados em `Configs`, nesse cenário prefira usar `TestConnectionOnly`.

### Conexão única (singleton) ou uma conexão por query

Por padrão (`ConnectionSingletonON`) todas as queries de uma instância compartilham a mesma conexão. Com `ConnectionSingletonOFF`, cada chamada a `Connection` cria uma nova conexão, ou seja, cada query terá a sua própria conexão com o banco.

```delphi
C4DConn
  .Configs
  .ConnectionSingletonOFF
  .ComponentConnectionFireDac
  ...
```

> Para usar transações envolvendo várias queries, mantenha o modo singleton (padrão).

### Alterando a configuração após conectar

Os dados de `Configs` são carregados no `TFDConnection` no momento em que a conexão é criada (na primeira chamada de `Connection` ou `Query`). Se a configuração for alterada depois disso, recarregue-a:

```delphi
C4DConn.Configs.Database('outro_banco');
C4DConn.Connection.LoadConnectionConfig;
```

### Várias conexões ao mesmo tempo

A função `C4DConn` retorna sempre a mesma instância global. Para trabalhar com outro banco em paralelo, crie uma instância independente com `TC4DConn.New`:

```delphi
FConnRelatorios := TC4DConn.New;
FConnRelatorios
  .Configs
  .ComponentConnectionFireDac
  .Host('192.168.0.10')
  .Port(3306)
  .UserName('relatorios')
  .Password('senha')
  .Database('banco_relatorios');

var LQuery := FConnRelatorios.Query;
LQuery.Open('select id, descricao from parametros');
```

> Mantenha a instância de `IC4DConn` viva (por exemplo, como campo do form ou DataModule) enquanto estiver usando as queries criadas a partir dela.

## Testando a conexão

| Método | Descrição |
| --- | --- |
| `TestConnection` | Valida os dados obrigatórios e tenta conectar. Retorna `True` se conectou; em caso de falha gera uma exceção com o motivo. |
| `TestConnectionOnly` | Apenas tenta conectar, sem validar os dados e sem gerar exceção. Retorna `True` ou `False`. |

Em ambos os casos o estado anterior da conexão (conectado/desconectado) é restaurado após o teste.

Dados obrigatórios validados por `TestConnection` e `Open`:

- **MySQL**: `Host`, `UserName`, `Password` e `Database`
- **SQLite**: `Database`

```delphi
try
  C4DConn.Connection.TestConnection;
except
  on E: Exception do
    ShowMessage(E.Message);
end;

if not C4DConn.Connection.TestConnectionOnly then
  ShowMessage('Servidor indisponível');
```

## Queries

Cada chamada a `C4DConn.Query` cria uma nova query (`IC4DConnQuery`) ligada à conexão. As queries recebem nomes automáticos (`Query1`, `Query2`...), mas é possível informar um nome: `C4DConn.Query('QClientes')`.

### Consultas (select)

```delphi
//SQL DIRETO NO OPEN
var LQuery := C4DConn.Query;
LQuery.Open('select * from clientes');

//MONTANDO O SQL EM PARTES
LQuery
  .CloseClear
  .Add('select id, nome')
  .Add('from clientes')
  .Add('where id = :id')
  .AddParam('id', 10)
  .Open;

//SUBSTITUINDO TODO O SQL
LQuery
  .Text('select * from clientes')
  .Open;
```

> `AddParam` deve ser chamado depois que o SQL com o parâmetro já foi adicionado.

### Execução de comandos (insert, update, delete)

```delphi
C4DConn.Query.ExecSQL('delete from clientes where id = 10');

var LQuery := C4DConn.Query;
LQuery
  .Add('insert into clientes(nome, dh_cadastro)')
  .Add('values(:nome, :dh_cadastro)')
  .AddParam('nome', 'Fulano de Tal')
  .AddParam('dh_cadastro', Now)
  .ExecSQL;

var LId := LQuery.GetLastAutoGenValue('id');
var LLinhasAfetadas := LQuery.RowsAffected;
```

### Montagem dinâmica de filtros, agrupamento, ordenação e limite

Os métodos `AddCond`, `AddCondParam`, `AddGroup`, `AddOrder` e `AddLimit` guardam as partes do SQL, que são adicionadas ao final do SQL principal ao chamar `Open` (sem parâmetros). Isso facilita montar filtros opcionais, como em telas de pesquisa:

```delphi
var LQuery := C4DConn.Query;
LQuery.Add('select id, nome, ano_nascimento from clientes');

if not Trim(edtNome.Text).IsEmpty then
  LQuery
    .AddCond('and nome like :nome')
    .AddCondParam('nome', '%' + Trim(edtNome.Text) + '%');

if not Trim(edtAno.Text).IsEmpty then
  LQuery
    .AddCond('and ano_nascimento >= :ano')
    .AddCondParam('ano', Trim(edtAno.Text).ToInteger);

LQuery
  .AddOrder('nome')
  .AddLimit('limit 100')
  .Open;
```

SQL gerado quando os dois filtros são informados:

```sql
select id, nome, ano_nascimento from clientes
where nome like :nome
and ano_nascimento >= :ano
order by nome
limit 100
```

Regras da montagem:

- **`AddCond`**: as condições são concatenadas na ordem em que foram adicionadas. Se a primeira começar com `and` ou `or`, esse operador é trocado por `where`; se não começar com `where`, o `where` é adicionado automaticamente. Escreva os operadores (`and`, `or`, `where`) em **minúsculo**
- **`AddCondParam`**: os valores dos parâmetros das condições, aplicados após a montagem do `where`
- **`AddGroup`** e **`AddOrder`**: informe apenas os campos (ex.: `AddOrder('nome')`, `AddOrder('id desc')`); os itens são separados por vírgula e o `group by`/`order by` é adicionado automaticamente
- **`AddLimit`**: informe a cláusula completa (ex.: `AddLimit('limit 10')`)
- Por segurança, os comandos `ALTER` e `DROP` são neutralizados nas condições. Ainda assim, use sempre parâmetros para valores informados pelo usuário
- Para reutilizar a mesma query com outro SQL, chame `CloseClear` antes, limpando o SQL e todas as listas acima. `Open('...')` com SQL direto não processa essas listas

### Ligando a um TDataSource (grid)

```delphi
private
  FQueryClientes: IC4DConnQuery;

procedure TViewClientes.FormCreate(Sender: TObject);
begin
  FQueryClientes := C4DConn.Query.DataSource(DS_Clientes);
  FQueryClientes.Open('select * from clientes');
end;
```

> Guarde a query em um campo do form. Se ela for apenas uma variável local, será destruída ao final do método e o grid ficará sem dados.

### Master/Detail

```delphi
FQueryItens := C4DConn.Query.DataSourceMasterDetail(DS_Pedidos).DataSource(DS_Itens);
FQueryItens
  .Add('select * from pedidos_itens')
  .Add('where id_pedido = :id')
  .Open;
```

O parâmetro `:id` é preenchido automaticamente com o campo `id` do dataset mestre.

### Inserindo e editando registros pelo dataset

```delphi
var LQuery := C4DConn.Query;
LQuery
  .Add('select * from clientes where id = :id')
  .AddParam('id', LIdCliente)
  .Open;

if LQuery.IsEmpty then
  LQuery.Append
else
  LQuery.Edit;

LQuery.FieldByName('nome').AsString := 'Fulano de Tal';
LQuery.FieldByName('fone').AsString := '(11) 99999-9999';
LQuery.Post;
```

### Transações

```delphi
var LConnection := C4DConn.Connection;
LConnection.StartTransaction;
try
  C4DConn.Query.ExecSQL('update estoque set quantidade = quantidade - 1 where id_produto = 1');
  C4DConn.Query.ExecSQL('insert into movimentacoes(id_produto, quantidade) values(1, -1)');
  LConnection.Commit;
except
  LConnection.Rollback;
  raise;
end;
```

## Referência da API

### Configs (`TC4DConnConfigs`)

| Método | Descrição |
| --- | --- |
| `ComponentConnectionFireDac` | Define o FireDAC como componente de conexão (obrigatório) |
| `DriverConnectionMySQL` | Usa o driver MySQL (padrão) |
| `DriverConnectionSQLite` | Usa o driver SQLite |
| `Host(AValue)` | Servidor do banco |
| `Port(AValue)` | Porta do servidor |
| `UserName(AValue)` | Usuário |
| `Password(AValue)` | Senha |
| `Database(AValue)` | Nome do banco (MySQL) ou caminho do arquivo (SQLite) |
| `ComponentOfConnectionExisting(AValue)` | Reaproveita um `TFDConnection` existente |
| `ConnectionSingletonON` | Todas as queries compartilham a mesma conexão (padrão) |
| `ConnectionSingletonOFF` | Cria uma nova conexão a cada chamada de `Connection` |
| `TestFieldFilling` | Gera exceção caso algum dado obrigatório não tenha sido informado |

Os métodos sem parâmetro (`Host`, `Port`, `UserName`, `Password`, `Database`, `DriverConnection`, `ConnectionSingleton`...) retornam o valor configurado.

### Connection (`IC4DConnection`)

| Método | Descrição |
| --- | --- |
| `Open` | Valida os dados obrigatórios e conecta |
| `Close` | Desconecta |
| `StartTransaction` | Inicia uma transação |
| `Commit` | Confirma a transação |
| `Rollback` | Desfaz a transação |
| `TestConnection` | Valida os dados e testa a conexão (gera exceção em caso de falha) |
| `TestConnectionOnly` | Testa a conexão sem validar dados e sem gerar exceção |
| `LoadConnectionConfig` | Recarrega no componente os dados de `Configs` |
| `Component` | Retorna o componente de conexão (`TFDConnection`) |

### Query (`IC4DConnQuery`)

| Método | Descrição |
| --- | --- |
| `Add(AValue)` | Adiciona uma linha ao SQL |
| `Text(AValue)` | Substitui todo o SQL |
| `SQL` | Retorna o `TStrings` com o SQL atual |
| `AddParam(AParam, AValue)` | Define o valor de um parâmetro |
| `AddCond(ACond)` / `AddCondParam(AParam, AValue)` | Adiciona condições do `where` e seus parâmetros |
| `AddGroup(ACond)` | Adiciona campos ao `group by` |
| `AddOrder(ACond)` | Adiciona campos ao `order by` |
| `AddLimit(ACond)` | Adiciona a cláusula `limit` |
| `Open` / `Open(ASQL)` | Abre a consulta (montando as condições) / abre o SQL informado |
| `ExecSQL` / `ExecSQL(ASQL)` | Executa o SQL atual / executa o SQL informado |
| `Close` | Fecha a query |
| `Clear` | Limpa o SQL, condições, parâmetros, agrupamento, ordenação e limite |
| `CloseClear` | Executa `Close` e `Clear` |
| `DataSet` | Retorna o `TDataSet` interno |
| `DataSource(AValue)` | Liga a query ao `TDataSource` informado |
| `DataSourceMasterDetail(AValue)` | Define o `TDataSource` mestre (master/detail) |
| `Append` / `Edit` / `Post` / `Delete` | Inclusão, edição, gravação e exclusão de registros |
| `First` / `Prior` / `Next` / `Last` | Navegação entre os registros |
| `Eof` / `Bof` / `IsEmpty` | Estado do dataset |
| `FieldByName(AValue)` | Retorna o campo pelo nome |
| `RecNo` / `RecordCount` | Registro atual / quantidade de registros |
| `RecordCountStr(ANumZerosLeft)` | Quantidade de registros com zeros à esquerda (padrão 6, ex.: `000042`) |
| `RowsAffected` | Quantidade de linhas afetadas pelo último comando |
| `GetLastAutoGenValue(AName)` | Último valor de autoincremento gerado (ex.: id inserido) |

## Demo

O repositório possui um projeto de exemplo em `Samples/Demo01` (abra o grupo `Samples/C4DConnGroup.groupproj`), que demonstra:

- Configuração da conexão global com SQLite, usando o banco `Samples/Data/base_test.db`
- Cadastro de clientes (incluir, alterar, excluir e listar) com grid ligado a um `TDataSource`
- Inserts com `Add`, `Text` e `ExecSQL` direto
- Criação de uma conexão independente com MySQL usando `TC4DConn.New`

> O demo utiliza o componente `TPngBitBtn` (PngComponents) e o executável é gerado em `Samples/Demo01/Bin`, de onde o banco SQLite é localizado pelo caminho relativo `..\..\Data\base_test.db`.

## Estrutura do projeto

| Unit | Descrição |
| --- | --- |
| `C4D.Conn` | Ponto de entrada: função `C4DConn` e classe `TC4DConn` |
| `C4D.Conn.Interfaces` | Interfaces `IC4DConn`, `IC4DConnection` e `IC4DConnQuery` |
| `C4D.Conn.Configs` | Configurações da conexão (`TC4DConnConfigs`) |
| `C4D.Conn.Firedac` | Implementação da conexão com FireDAC |
| `C4D.Conn.Firedac.Query` | Implementação da query com FireDAC |
| `C4D.Conn.Types` | Enumeradores de componente e driver de conexão |
| `C4D.Conn.Utils` | Funções auxiliares para tratamento do SQL |
