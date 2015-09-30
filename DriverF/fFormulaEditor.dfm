object frmFormulaEditor: TfrmFormulaEditor
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1092#1086#1088#1084#1091#1083
  ClientHeight = 571
  ClientWidth = 818
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 818
    Height = 185
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object dbgFormulas: TDBGridEh
      Left = 1
      Top = 1
      Width = 816
      Height = 183
      Align = alClient
      DataSource = dsFormulas
      DynProps = <>
      IndicatorOptions = [gioShowRowIndicatorEh]
      TabOrder = 0
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'FORMULA_ID'
          Footers = <>
          Width = 114
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'F_STR'
          Footers = <>
          Width = 240
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ITEM_ID'
          Footers = <>
          Width = 107
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object Button1: TButton
    Left = 344
    Top = 191
    Width = 466
    Height = 34
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 191
    Width = 328
    Height = 178
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1059#1050#1056
    TabOrder = 2
    object DBMemo1: TDBMemo
      Left = 2
      Top = 15
      Width = 324
      Height = 161
      Align = alClient
      DataField = 'TEXT_UKR'
      DataSource = dsFormulas
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 373
    Width = 328
    Height = 180
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1056#1059#1057
    TabOrder = 3
    object DBMemo2: TDBMemo
      Left = 2
      Top = 15
      Width = 324
      Height = 163
      Align = alClient
      DataField = 'TEXT_RUS'
      DataSource = dsFormulas
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object DBGridEh2: TDBGridEh
    Left = 344
    Top = 231
    Width = 466
    Height = 320
    ColumnDefValues.Title.TitleButton = True
    DataSource = dsFormulaDetail
    DynProps = <>
    IndicatorOptions = [gioShowRowIndicatorEh]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghDialogFind, dghColumnResize, dghColumnMove, dghExtendVertLines]
    SortLocal = True
    TabOrder = 4
    Columns = <
      item
        Checkboxes = True
        DynProps = <>
        EditButtons = <>
        FieldName = 'IS_ITEM_EXISTS'
        Footers = <>
        KeyList.Strings = (
          '1'
          '0')
        Title.Caption = ' '
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'NAME'
        Footers = <>
        Width = 100
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ID'
        Footers = <>
        Visible = False
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object ldsFormulas: TSQLiteDataset
    Aggregates = <>
    CommandText = 'select * from formulas'
    FieldDefs = <
      item
        Name = 'FORMULA_ID'
        DataType = ftInteger
      end
      item
        Name = 'F_STR'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'F_TEX'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'ITEM_ID'
        DataType = ftInteger
      end
      item
        Name = 'NAME_UKR'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'NAME_RUS'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'TEXT_UKR'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'TEXT_RUS'
        DataType = ftWideString
        Size = 4000
      end>
    IndexDefs = <>
    FetchOnDemand = False
    Params = <>
    StoreDefs = True
    AfterPost = ldsFormulasAfterPost
    BeforeScroll = ldsFormulasBeforeScroll
    AfterScroll = ldsFormulasAfterScroll
    Database = dmMain.dbMain
    UpdateSQL = updFormulas
    Left = 456
    Top = 64
    object ldsFormulasFORMULA_ID: TIntegerField
      FieldName = 'FORMULA_ID'
    end
    object ldsFormulasF_STR: TWideStringField
      FieldName = 'F_STR'
      Size = 4000
    end
    object ldsFormulasF_TEX: TWideStringField
      FieldName = 'F_TEX'
      Size = 4000
    end
    object ldsFormulasITEM_ID: TIntegerField
      FieldName = 'ITEM_ID'
    end
    object ldsFormulasNAME_UKR: TWideStringField
      FieldName = 'NAME_UKR'
      Size = 4000
    end
    object ldsFormulasNAME_RUS: TWideStringField
      FieldName = 'NAME_RUS'
      Size = 4000
    end
    object ldsFormulasTEXT_UKR: TWideStringField
      FieldName = 'TEXT_UKR'
      Size = 4000
    end
    object ldsFormulasTEXT_RUS: TWideStringField
      FieldName = 'TEXT_RUS'
      Size = 4000
    end
  end
  object dsFormulas: TDataSource
    DataSet = ldsFormulas
    Left = 248
    Top = 208
  end
  object updFormulas: TSQLiteUpdateSQL
    DeleteSQL.Strings = (
      'delete from formulas'
      'where formula_id = :formula_id')
    InsertSQL.Strings = (
      'insert into formulas'
      
        '(formula_id, f_str, f_tex, item_id, name_ukr, name_rus, text_ukr' +
        ', text_rus)'
      'values'
      
        '(:formula_id, :f_str, :f_tex, :item_id, :name_ukr, :name_rus, :t' +
        'ext_ukr, :text_rus)')
    ModifySQL.Strings = (
      'update formulas'
      'set f_str = :f_str,'
      '    F_TEX  = :f_tex,'
      '    item_id = :item_id,'
      '    name_ukr = :name_ukr,'
      '    name_rus = :name_rus,'
      '    text_ukr = :text_ukr,'
      '    text_rus = :text_rus'
      'where formula_id = :formula_id')
    Left = 624
    Top = 120
  end
  object dsFormulaDetail: TDataSource
    DataSet = memItems
    Left = 232
    Top = 264
  end
  object ldsSelecteditems: TSQLiteDataset
    Aggregates = <>
    CommandText = 
      'select it.ID, it.NAME,'#13#10'       coalesce((select 1'#13#10'        from ' +
      'formula_detail fd'#13#10'        where fd.FORMULA_ID = :formula_id and' +
      #13#10'           fd.ITEM_ID = it.ID), 0) is_item_exists'#13#10'from items ' +
      'it'
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'NAME'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'IS_ITEM_EXISTS'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <
      item
        DataType = ftString
        Name = 'formula_id'
        ParamType = ptUnknown
      end>
    StoreDefs = True
    Database = dmMain.dbMain
    Left = 384
    Top = 120
    object ldsSelecteditemsID: TIntegerField
      FieldName = 'ID'
    end
    object ldsSelecteditemsNAME: TWideStringField
      FieldName = 'NAME'
      Size = 4000
    end
    object ldsSelecteditemsIS_ITEM_EXISTS: TIntegerField
      FieldName = 'IS_ITEM_EXISTS'
    end
  end
  object memItems: TMemTableEh
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
        Precision = 15
      end
      item
        Name = 'NAME'
        DataType = ftWideString
        Size = 4000
      end
      item
        Name = 'IS_ITEM_EXISTS'
        DataType = ftInteger
        Precision = 15
      end>
    IndexDefs = <>
    Params = <>
    DataDriver = dsd
    StoreDefs = True
    AfterPost = memItemsAfterPost
    Left = 640
    Top = 432
    object memItemsID: TIntegerField
      FieldName = 'ID'
    end
    object memItemsNAME: TWideStringField
      FieldName = 'NAME'
      Size = 4000
    end
    object memItemsIS_ITEM_EXISTS: TIntegerField
      FieldName = 'IS_ITEM_EXISTS'
    end
  end
  object dsd: TDataSetDriverEh
    ProviderDataSet = ldsSelecteditems
    Left = 552
    Top = 424
  end
end
