object frmEditGraphic: TfrmEditGraphic
  Left = 0
  Top = 0
  Caption = 'frmEditGraphic'
  ClientHeight = 822
  ClientWidth = 1079
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object spl1: TSplitter
    Left = 788
    Top = 0
    Width = 4
    Height = 776
    Align = alRight
    Color = clHighlight
    ParentColor = False
    ExplicitLeft = 800
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 788
    Height = 776
    Align = alClient
    TabOrder = 0
    object imgMain: TImage
      Left = 1
      Top = 1
      Width = 786
      Height = 774
      Align = alClient
      Proportional = True
      Stretch = True
      ExplicitTop = 7
    end
  end
  object pnl2: TPanel
    Left = 792
    Top = 0
    Width = 287
    Height = 776
    Align = alRight
    TabOrder = 1
    object dbgrdhMain: TDBGridEh
      Left = 1
      Top = 1
      Width = 285
      Height = 567
      Align = alClient
      DataGrouping.GroupLevels = <>
      DataSource = dsMain
      Flat = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      IndicatorOptions = [gioShowRowIndicatorEh]
      ParentFont = False
      RowHeight = 30
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawColumnCell = dbgrdhMainDrawColumnCell
      Columns = <
        item
          EditButtons = <>
          FieldName = 'IMG'
          Footers = <>
          Width = 112
        end
        item
          AlwaysShowEditButton = True
          EditButtons = <
            item
              Style = ebsAltUpDownEh
            end>
          FieldName = 'val_x'
          Footers = <>
        end
        item
          AlwaysShowEditButton = True
          EditButtons = <
            item
              Style = ebsAltUpDownEh
            end>
          FieldName = 'val_y'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object pnl4: TPanel
      Left = 1
      Top = 568
      Width = 285
      Height = 207
      Align = alBottom
      TabOrder = 1
      object grp1: TGroupBox
        Left = 5
        Top = 6
        Width = 260
        Height = 107
        Caption = #1050#1086#1077#1092#1110#1094#1110#1108#1085#1090#1080' '#1088#1086#1079#1090#1103#1075#1085#1077#1085#1085#1103
        TabOrder = 0
        object lbl1: TLabel
          Left = 11
          Top = 21
          Width = 110
          Height = 13
          Caption = #1042#1077#1082#1090#1086#1088#1080' '#1087#1088#1080#1089#1082#1086#1088#1077#1085#1085#1103
        end
        object lbl2: TLabel
          Left = 12
          Top = 50
          Width = 97
          Height = 13
          Caption = #1042#1077#1082#1090#1086#1088#1080' '#1096#1074#1080#1076#1082#1086#1089#1090#1110
        end
        object lbl3: TLabel
          Left = 11
          Top = 77
          Width = 82
          Height = 13
          Caption = #1056#1072#1076#1110#1091#1089' '#1082#1088#1080#1074#1080#1079#1085#1080
        end
        object dbnWkoeff: TDBNumberEditEh
          Left = 134
          Top = 17
          Width = 121
          Height = 21
          EditButtons = <>
          TabOrder = 0
          Visible = True
        end
        object dbnVKoeff: TDBNumberEditEh
          Left = 134
          Top = 46
          Width = 121
          Height = 21
          EditButtons = <>
          TabOrder = 1
          Visible = True
        end
        object dbnRKoeff: TDBNumberEditEh
          Left = 134
          Top = 73
          Width = 121
          Height = 21
          EditButtons = <>
          TabOrder = 2
          Visible = True
        end
      end
      object chkWnKoeff: TCheckBox
        Left = 13
        Top = 136
        Width = 185
        Height = 17
        Caption = #1030#1085#1074#1077#1088#1089#1110#1103' '#1074#1077#1082#1090#1086#1088#1091' '#1085#1086#1088#1084#1072#1083#1110
        TabOrder = 1
      end
    end
  end
  object pnl3: TPanel
    Left = 0
    Top = 776
    Width = 1079
    Height = 46
    Align = alBottom
    TabOrder = 2
    object btnRecalc: TBitBtn
      Left = 712
      Top = 9
      Width = 123
      Height = 25
      Caption = #1055#1077#1088#1077#1089#1090#1088#1086#1111#1090#1080' '#1075#1088#1072#1092#1110#1082
      TabOrder = 0
      OnClick = btnRecalcClick
    end
    object btn1: TButton
      Left = 856
      Top = 9
      Width = 113
      Height = 25
      Caption = #1047#1072#1082#1088#1080#1090#1080
      ModalResult = 1
      TabOrder = 1
    end
  end
  object memMain: TMemTableEh
    Active = True
    Params = <>
    Left = 144
    Top = 272
    object strngfldMainFORMULA: TStringField
      DisplayWidth = 33
      FieldName = 'FORMULA'
      Size = 100
    end
    object strngfldMainstr_x: TStringField
      DisplayWidth = 10
      FieldName = 'str_x'
      Size = 10
    end
    object strngfldMainstr_y: TStringField
      DisplayWidth = 10
      FieldName = 'str_y'
      Size = 10
    end
    object memMainval_x: TIntegerField
      DisplayLabel = 'X'
      DisplayWidth = 10
      FieldName = 'val_x'
    end
    object memMainval_y: TIntegerField
      DisplayLabel = 'Y'
      DisplayWidth = 10
      FieldName = 'val_y'
    end
    object memMainIMG: TGraphicField
      DisplayLabel = #1069#1083#1077#1084#1077#1085#1090
      DisplayWidth = 10
      FieldName = 'IMG'
      BlobType = ftGraphic
    end
    object MemTableData: TMemTableDataEh
      object DataStruct: TMTDataStructEh
        object FORMULA: TMTStringDataFieldEh
          FieldName = 'FORMULA'
          StringDataType = fdtStringEh
          Size = 100
        end
        object str_x: TMTStringDataFieldEh
          FieldName = 'str_x'
          StringDataType = fdtStringEh
          Size = 10
        end
        object str_y: TMTStringDataFieldEh
          FieldName = 'str_y'
          StringDataType = fdtStringEh
          Size = 10
        end
        object val_x: TMTNumericDataFieldEh
          FieldName = 'val_x'
          NumericDataType = fdtIntegerEh
          AutoIncrement = False
          currency = False
          Precision = 15
        end
        object val_y: TMTNumericDataFieldEh
          FieldName = 'val_y'
          NumericDataType = fdtIntegerEh
          AutoIncrement = False
          currency = False
          Precision = 15
        end
        object IMG: TMTBlobDataFieldEh
          FieldName = 'IMG'
          BlobType = ftGraphic
          GraphicHeader = False
          Transliterate = False
        end
      end
      object RecordsList: TRecordsListEh
        Data = (
          (
            '\overrightarrow{v_{0x}}'
            'vx0'
            'vy0'
            nil
            nil
            {})
          (
            '\overrightarrow{v_{0y}}'
            'x0'
            'y0'
            nil
            nil
            {})
          (
            '\overrightarrow{v_1}'
            'vx1'
            'vy1'
            nil
            nil
            {})
          (
            '\overrightarrow{W_1}'
            'wx1'
            'wy1'
            nil
            nil
            {})
          (
            '\overrightarrow{W_1^{\tau}}'
            'wtx1'
            'wty1'
            nil
            nil
            {})
          (
            '\overrightarrow{W_1^n}'
            'wnx1'
            'wny1'
            nil
            nil
            {})
          (
            'O'
            'ox'
            'oy'
            nil
            nil
            {})
          (
            '\rho_1'
            'rx0'
            'ry0'
            nil
            nil
            {})
          (
            'M_0'
            'x'
            'y'
            nil
            nil
            {})
          (
            'M_1'
            'x1'
            'y1'
            nil
            nil
            {}))
      end
    end
  end
  object dsMain: TDataSource
    DataSet = memMain
    Left = 64
    Top = 488
  end
end
