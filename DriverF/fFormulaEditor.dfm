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
    object DBGridEh1: TDBGridEh
      Left = 1
      Top = 1
      Width = 816
      Height = 183
      Align = alClient
      DataSource = DataSource1
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
          FieldName = 'F_TEX'
          Footers = <>
          Width = 68
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ITEM_ID'
          Footers = <>
          Width = 103
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object Button1: TButton
    Left = 576
    Top = 400
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DBMemo1: TDBMemo
    Left = 40
    Top = 216
    Width = 185
    Height = 89
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 191
    Width = 305
    Height = 122
    Caption = 'GroupBox1'
    TabOrder = 3
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
    Params = <>
    StoreDefs = True
    Database = dmMain.dbMain
    UpdateSQL = updFormulas
    Left = 592
    Top = 72
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
  object DataSource1: TDataSource
    DataSet = ldsFormulas
    Left = 488
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
    Top = 200
  end
end
