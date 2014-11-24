object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 668
  ClientWidth = 860
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Ribbon1: TRibbon
    Left = 0
    Top = 0
    Width = 860
    Height = 143
    ActionManager = amMain
    Caption = #1050#1086#1085#1089#1090#1088#1091#1082#1090#1086#1088' '#1089#1093#1077#1084#1099
    ShowHelpButton = False
    Tabs = <
      item
        Caption = #1060#1072#1081#1083
        Page = RibbonPage2
      end
      item
        Caption = #1050#1086#1085#1089#1090#1088#1091#1082#1094#1080#1103
        Page = rbStructure
      end
      item
        Caption = #1053#1072#1075#1088#1091#1079#1082#1072
        Page = RibbonPage3
      end>
    TabIndex = 1
    DesignSize = (
      860
      143)
    StyleName = 'Ribbon - Luna'
    object RibbonPage3: TRibbonPage
      Left = 0
      Top = 50
      Width = 859
      Height = 93
      Caption = #1060#1072#1081#1083
      Index = 2
    end
    object RibbonPage2: TRibbonPage
      Left = 0
      Top = 50
      Width = 859
      Height = 93
      Caption = #1053#1072#1075#1088#1091#1079#1082#1072
      Index = 0
      object RibbonGroup3: TRibbonGroup
        Left = 4
        Top = 3
        Width = 101
        Height = 86
        ActionManager = amMain
        Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077
        GroupIndex = 0
      end
    end
    object rbStructure: TRibbonPage
      Left = 0
      Top = 50
      Width = 859
      Height = 93
      Caption = #1050#1086#1085#1089#1090#1088#1091#1082#1094#1080#1103
      Index = 1
      object RibbonGroup1: TRibbonGroup
        Left = 4
        Top = 3
        Width = 76
        Height = 86
        ActionManager = amMain
        Caption = #1057#1090#1077#1088#1078#1077#1085#1100
        GroupIndex = 0
      end
      object RibbonGroup2: TRibbonGroup
        Left = 82
        Top = 3
        Width = 202
        Height = 86
        ActionManager = amMain
        Caption = #1054#1087#1086#1088#1099
        GroupIndex = 1
      end
    end
  end
  object pnl1: TPanel
    Left = 605
    Top = 143
    Width = 255
    Height = 525
    Align = alRight
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object spl1: TSplitter
      Left = 0
      Top = 233
      Width = 255
      Height = 5
      Cursor = crVSplit
      Align = alTop
      Color = clHighlight
      ParentColor = False
      ExplicitTop = 169
    end
    object grp1: TGroupBox
      Left = 0
      Top = 0
      Width = 255
      Height = 233
      Align = alTop
      BiDiMode = bdRightToLeftNoAlign
      Caption = #1057#1087#1080#1089#1086#1082' '#1086#1073#1098#1077#1082#1090#1086#1074
      ParentBiDiMode = False
      TabOrder = 0
      object dbgrdh1: TDBGridEh
        Left = 2
        Top = 18
        Width = 251
        Height = 213
        Align = alClient
        DataSource = dsObjectList
        DynProps = <>
        IndicatorOptions = [gioShowRowIndicatorEh]
        TabOrder = 0
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object grp2: TGroupBox
      Left = 0
      Top = 238
      Width = 255
      Height = 287
      Align = alClient
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1086#1073#1098#1077#1082#1090#1072
      TabOrder = 1
      ExplicitTop = 174
      ExplicitHeight = 351
    end
  end
  object sbMain: TScrollBox
    Left = 0
    Top = 143
    Width = 605
    Height = 525
    Align = alClient
    TabOrder = 2
    OnClick = sbMainClick
    object pbMain: TPaintBox
      Left = 0
      Top = 0
      Width = 601
      Height = 521
      Align = alClient
      OnMouseDown = pbMainMouseDown
      OnPaint = pbMainPaint
      ExplicitLeft = -32
      ExplicitTop = -16
    end
  end
  object amMain: TActionManager
    ActionBars = <
      item
        Visible = False
      end
      item
        Items = <
          item
            Action = act1
          end>
        ActionBar = RibbonGroup1
      end
      item
        Items = <
          item
            Action = act2
          end
          item
            Action = act3
          end>
        ActionBar = RibbonGroup2
      end>
    Left = 256
    Top = 328
    StyleName = 'Ribbon - Luna'
    object act1: TAction
      Caption = #1057#1090#1077#1088#1078#1077#1085#1100
      OnExecute = act1Execute
    end
    object act2: TAction
      Caption = #1055#1088#1086#1089#1090#1086#1081' '#1091#1079#1077#1083
      OnExecute = act2Execute
    end
    object act3: TAction
      Caption = #1064#1072#1088#1085#1080#1088#1085#1086'-'#1085#1077#1087#1086#1076#1074#1080#1078#1085#1072#1103' '#1086#1087#1086#1088#1072
    end
  end
  object dsObjectList: TDataSource
    DataSet = memObjectList
    Left = 200
    Top = 408
  end
  object memObjectList: TMemTableEh
    Params = <>
    Left = 696
    Top = 448
  end
end
