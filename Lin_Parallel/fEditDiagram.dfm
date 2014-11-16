object frmEditDiagram: TfrmEditDiagram
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1085#1085#1103' '#1076#1110#1072#1075#1088#1072#1084#1080
  ClientHeight = 833
  ClientWidth = 1014
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object img1: TImage
    Left = 0
    Top = 0
    Width = 784
    Height = 731
    Align = alClient
    Center = True
    Proportional = True
    Stretch = True
    ExplicitLeft = -1
    ExplicitTop = -6
    ExplicitWidth = 692
    ExplicitHeight = 722
  end
  object spl1: TSplitter
    Left = 784
    Top = 0
    Width = 5
    Height = 731
    Align = alRight
    Color = clHighlight
    ParentColor = False
    ExplicitLeft = 720
    ExplicitTop = 8
    ExplicitHeight = 722
  end
  object dbgrdh1: TDBGridEh
    Left = 789
    Top = 0
    Width = 225
    Height = 731
    Align = alRight
    ColumnDefValues.AlwaysShowEditButton = True
    Ctl3D = True
    DataGrouping.GroupLevels = <>
    DataSource = ds1
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    IndicatorOptions = [gioShowRowIndicatorEh]
    ParentCtl3D = False
    RowHeight = 25
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = dbgrdh1DrawColumnCell
    Columns = <
      item
        EditButtons = <>
        FieldName = 'IMG'
        Footers = <>
        Title.Caption = #1060#1086#1088#1084#1091#1083#1072
        Width = 123
      end
      item
        EditButtons = <
          item
            Style = ebsUpDownEh
          end>
        FieldName = 'X'
        Footers = <>
        Width = 45
      end
      item
        EditButtons = <
          item
            Style = ebsUpDownEh
          end>
        FieldName = 'Y'
        Footers = <>
        Width = 39
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 731
    Width = 1014
    Height = 102
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 737
    object btn1: TButton
      Left = 774
      Top = 53
      Width = 201
      Height = 25
      Caption = #1047#1072#1082#1088#1080#1090#1080
      ModalResult = 1
      TabOrder = 0
    end
    object btn2: TButton
      Left = 774
      Top = 22
      Width = 201
      Height = 25
      Caption = #1055#1077#1088#1077#1089#1090#1088#1086#1111#1090#1080' '#1076#1110#1072#1075#1088#1072#1084#1091
      TabOrder = 1
      OnClick = btn2Click
    end
    object grp1: TGroupBox
      Left = 16
      Top = 6
      Width = 289
      Height = 83
      Caption = #1052#1072#1096#1090#1072#1073
      TabOrder = 2
      object lbl1: TLabel
        Left = 10
        Top = 54
        Width = 31
        Height = 13
        Caption = #1057#1090#1088#1091#1084
      end
      object lbl2: TLabel
        Left = 10
        Top = 21
        Width = 42
        Height = 13
        Caption = #1053#1072#1087#1088#1091#1075#1072
      end
      object dbnScaleI: TDBNumberEditEh
        Left = 93
        Top = 51
        Width = 180
        Height = 21
        EditButtons = <>
        TabOrder = 0
        Visible = True
      end
      object dbnScaleU: TDBNumberEditEh
        Left = 93
        Top = 18
        Width = 180
        Height = 21
        EditButtons = <>
        TabOrder = 1
        Visible = True
      end
    end
    object grp2: TGroupBox
      Left = 328
      Top = 6
      Width = 233
      Height = 83
      Caption = #1055#1086#1095#1072#1090#1086#1082' '#1082#1086#1086#1088#1076#1080#1085#1072#1090' ('#1087#1110#1082#1089#1077#1083#1110')'
      TabOrder = 3
      object lbl3: TLabel
        Left = 16
        Top = 22
        Width = 17
        Height = 13
        Caption = #1061
      end
      object lbl4: TLabel
        Left = 16
        Top = 55
        Width = 6
        Height = 13
        Caption = 'Y'
      end
      object dbnX0: TDBNumberEditEh
        Left = 29
        Top = 19
        Width = 180
        Height = 21
        EditButtons = <>
        TabOrder = 0
        Visible = True
        OnEnter = dbnX0Enter
        OnExit = dbnX0Exit
      end
      object dbnY0: TDBNumberEditEh
        Left = 28
        Top = 46
        Width = 180
        Height = 21
        EditButtons = <>
        TabOrder = 1
        Visible = True
        OnEnter = dbnY0Enter
        OnExit = dbnY0Exit
      end
    end
  end
  object ds1: TDataSource
    Left = 960
    Top = 568
  end
end
