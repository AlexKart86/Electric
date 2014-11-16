object frmEditDiagram: TfrmEditDiagram
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1085#1085#1103' '#1076#1110#1072#1075#1088#1072#1084#1080
  ClientHeight = 763
  ClientWidth = 922
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object img1: TImage
    Left = 0
    Top = 0
    Width = 692
    Height = 722
    Align = alClient
    Center = True
    Proportional = True
    Stretch = True
    ExplicitLeft = -1
    ExplicitTop = -6
  end
  object spl1: TSplitter
    Left = 692
    Top = 0
    Width = 5
    Height = 722
    Align = alRight
    Color = clHighlight
    ParentColor = False
    ExplicitLeft = 720
    ExplicitTop = 8
  end
  object dbgrdh1: TDBGridEh
    Left = 697
    Top = 0
    Width = 225
    Height = 722
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
    Top = 722
    Width = 922
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      922
      41)
    object btn1: TButton
      Left = 744
      Top = 6
      Width = 153
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1082#1088#1080#1090#1080
      ModalResult = 1
      TabOrder = 0
    end
    object btn2: TButton
      Left = 520
      Top = 6
      Width = 201
      Height = 25
      Caption = #1055#1077#1088#1077#1089#1090#1088#1086#1111#1090#1080' '#1076#1110#1072#1075#1088#1072#1084#1091
      TabOrder = 1
      OnClick = btn2Click
    end
  end
  object ds1: TDataSource
    Left = 960
    Top = 568
  end
end
