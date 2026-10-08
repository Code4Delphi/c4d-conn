object C4DConnDemo01ViewMain: TC4DConnDemo01ViewMain
  Left = 0
  Top = 0
  Caption = 'C4DConnDemo01ViewMain'
  ClientHeight = 466
  ClientWidth = 884
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 447
    Width = 884
    Height = 19
    Panels = <
      item
        Width = 700
      end
      item
        Alignment = taCenter
        Text = 'Total registros: 0'
        Width = 50
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 884
    Height = 447
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Crud com C4DConn'
      object pnGrid: TPanel
        Left = 0
        Top = 111
        Width = 876
        Height = 258
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object DBGrid1: TDBGrid
          Left = 0
          Top = 0
          Width = 876
          Height = 258
          Align = alClient
          DataSource = DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = [fsBold]
        end
      end
      object bBoxDadosCadastrais: TGroupBox
        Left = 0
        Top = 30
        Width = 876
        Height = 81
        Align = alTop
        Caption = ' Dados cadastrais '
        TabOrder = 1
        object Label1: TLabel
          Left = 16
          Top = 24
          Width = 38
          Height = 13
          Caption = 'C'#243'digo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label2: TLabel
          Left = 91
          Top = 24
          Width = 32
          Height = 13
          Caption = 'Nome'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label4: TLabel
          Left = 411
          Top = 24
          Width = 19
          Height = 13
          Caption = 'CPF'
        end
        object Label3: TLabel
          Left = 533
          Top = 24
          Width = 19
          Height = 13
          Caption = 'CEP'
        end
        object Label5: TLabel
          Left = 653
          Top = 24
          Width = 42
          Height = 13
          Caption = 'Telefone'
        end
        object Label6: TLabel
          Left = 770
          Top = 24
          Width = 76
          Height = 13
          Caption = 'Ano nascimento'
        end
        object edtCodigo: TEdit
          Left = 16
          Top = 39
          Width = 73
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
          Text = 'edtCodigo'
        end
        object edtNome: TEdit
          Left = 91
          Top = 39
          Width = 318
          Height = 21
          TabOrder = 1
          Text = 'edtNome'
        end
        object edtCPF: TMaskEdit
          Left = 411
          Top = 39
          Width = 120
          Height = 21
          EditMask = '999.999.999-99'
          MaxLength = 14
          TabOrder = 2
          Text = '   .   .   -  '
        end
        object edtCEP: TMaskEdit
          Left = 533
          Top = 39
          Width = 118
          Height = 21
          EditMask = '99999-99'
          MaxLength = 8
          TabOrder = 3
          Text = '     -  '
        end
        object edtFone: TMaskEdit
          Left = 653
          Top = 39
          Width = 115
          Height = 21
          EditMask = '(99)9999:99999'
          MaxLength = 14
          TabOrder = 4
          Text = '(  )    :     '
        end
        object edtAnoNascimento: TEdit
          Left = 770
          Top = 39
          Width = 90
          Height = 21
          NumbersOnly = True
          TabOrder = 5
        end
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 876
        Height = 30
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Padding.Left = 3
        Padding.Top = 3
        Padding.Right = 3
        Padding.Bottom = 3
        TabOrder = 2
        object Button1: TButton
          Left = 4
          Top = 4
          Width = 75
          Height = 22
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          Caption = 'Inserir 1'
          TabOrder = 0
          OnClick = Button1Click
          ExplicitTop = 5
        end
        object Button2: TButton
          Left = 79
          Top = 4
          Width = 75
          Height = 22
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          Caption = 'Inserir 3'
          TabOrder = 1
          OnClick = Button2Click
        end
        object btnSelectDiretoNoOpen: TButton
          Left = 289
          Top = 4
          Width = 135
          Height = 22
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          Caption = 'Select direto no Open'
          TabOrder = 2
          OnClick = btnSelectDiretoNoOpenClick
        end
        object btnInsertDiretoNoExecSQL: TButton
          Left = 154
          Top = 4
          Width = 135
          Height = 22
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          Caption = 'Insert direto no ExecSQL'
          TabOrder = 3
          OnClick = btnInsertDiretoNoExecSQLClick
        end
        object Button3: TButton
          Left = 424
          Top = 4
          Width = 107
          Height = 22
          Align = alLeft
          Caption = 'Ver SQL query'
          TabOrder = 4
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 531
          Top = 4
          Width = 206
          Height = 22
          Align = alLeft
          Caption = 'Inserir valores nos campos calculados'
          TabOrder = 5
          OnClick = Button4Click
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 369
        Width = 876
        Height = 50
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 3
        object sbtnFechar: TSpeedButton
          AlignWithMargins = True
          Left = 751
          Top = 3
          Width = 124
          Height = 44
          Cursor = crHandPoint
          Margins.Left = 1
          Margins.Right = 0
          Align = alLeft
          Caption = 'Fechar - Esc'
          OnClick = sbtnFecharClick
          ExplicitLeft = 745
        end
        object sbtnExcluir: TSpeedButton
          AlignWithMargins = True
          Left = 501
          Top = 3
          Width = 124
          Height = 44
          Cursor = crHandPoint
          Margins.Left = 1
          Margins.Right = 0
          Align = alLeft
          Caption = 'Excluir - Del'
          OnClick = sbtnExcluirClick
          ExplicitLeft = 497
        end
        object sbtnAlterar: TSpeedButton
          AlignWithMargins = True
          Left = 376
          Top = 3
          Width = 124
          Height = 44
          Cursor = crHandPoint
          Margins.Left = 1
          Margins.Right = 0
          Align = alLeft
          Caption = 'Alterar  - F3'
          OnClick = sbtnAlterarClick
          ExplicitLeft = 373
        end
        object sbtnCancelar: TSpeedButton
          AlignWithMargins = True
          Left = 251
          Top = 3
          Width = 124
          Height = 44
          Cursor = crHandPoint
          Margins.Left = 1
          Margins.Right = 0
          Align = alLeft
          Caption = 'Cancelar - Esc'
          OnClick = sbtnCancelarClick
          ExplicitLeft = 249
        end
        object sbtnGravar: TSpeedButton
          AlignWithMargins = True
          Left = 126
          Top = 3
          Width = 124
          Height = 44
          Cursor = crHandPoint
          Margins.Left = 1
          Margins.Right = 0
          Align = alLeft
          Caption = 'Gravar - F3'
          OnClick = sbtnGravarClick
          ExplicitLeft = 125
        end
        object sbtnNovo: TSpeedButton
          AlignWithMargins = True
          Left = 1
          Top = 3
          Width = 124
          Height = 44
          Cursor = crHandPoint
          Margins.Left = 1
          Margins.Right = 0
          Align = alLeft
          Caption = 'Novo - F2'
          OnClick = sbtnNovoClick
          ExplicitTop = 4
        end
        object sbtnAtualizar: TSpeedButton
          AlignWithMargins = True
          Left = 626
          Top = 3
          Width = 124
          Height = 44
          Cursor = crHandPoint
          Margins.Left = 1
          Margins.Right = 0
          Align = alLeft
          Caption = 'Atualizar - F5'
          OnClick = sbtnAtualizarClick
          ExplicitTop = 0
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Outra conex'#227'o simult'#226'nea'
      ImageIndex = 1
      object pnBackupRestaurar: TPanel
        Left = 0
        Top = 0
        Width = 876
        Height = 57
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object lbRestauraBackupDatabase: TLabel
          Left = 396
          Top = 6
          Width = 100
          Height = 14
          Caption = 'Nova base de dados'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object lbRestauraBackupPassword: TLabel
          Left = 212
          Top = 6
          Width = 31
          Height = 14
          Caption = 'Senha'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object lbRestauraBackupHost: TLabel
          Left = 7
          Top = 6
          Width = 101
          Height = 14
          Caption = 'IP / nome do servidor'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object lbRestauraBackupPort: TLabel
          Left = 314
          Top = 6
          Width = 25
          Height = 14
          Caption = 'Porta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object lbRestauraBackupUser: TLabel
          Left = 130
          Top = 6
          Width = 37
          Height = 14
          Caption = 'Usu'#225'rio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object edtDatabase: TEdit
          Left = 396
          Top = 21
          Width = 157
          Height = 22
          CharCase = ecLowerCase
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 4
          Text = ''
        end
        object edtPassword: TEdit
          Left = 212
          Top = 21
          Width = 100
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PasswordChar = '*'
          TabOrder = 2
        end
        object btnCriarNovaConexao: TPngBitBtn
          Left = 559
          Top = 16
          Width = 157
          Height = 30
          Cursor = crHandPoint
          Caption = 'Criar nova conex'#227'o'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          OnClick = btnCriarNovaConexaoClick
        end
        object edtHost: TEdit
          Left = 7
          Top = 21
          Width = 120
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = '127.0.0.1'
        end
        object edtPort: TEdit
          Left = 314
          Top = 21
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          NumbersOnly = True
          ParentFont = False
          TabOrder = 3
          Text = '3306'
        end
        object edtUser: TEdit
          Left = 130
          Top = 21
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = 'root'
        end
      end
      object mmLog: TMemo
        Left = 0
        Top = 57
        Width = 876
        Height = 362
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Estrutura Zeos e FireDac'
      ImageIndex = 2
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 876
        Height = 419
        Align = alClient
        Lines.Strings = (
          
            ' TZQuery > TZAbstractDataSet > TZAbstractRODataset              ' +
            '                                           > TDataSet > TCompone' +
            'nt'
          ''
          
            ' TFDQuery > TFDCustomQuery > TFDRdbmsDataSet > TFDAdaptedDataSet' +
            ' > TFDDataSet > TDataSet > TComponent')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object DataSource1: TDataSource
    Left = 816
    Top = 304
  end
end
