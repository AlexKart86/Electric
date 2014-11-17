object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 760
  ClientWidth = 887
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
    Width = 887
    Height = 143
    ActionManager = amMain
    Caption = #1050#1086#1085#1089#1090#1088#1091#1082#1090#1086#1088' '#1089#1093#1077#1084#1099
    ShowHelpButton = False
    Tabs = <
      item
        Caption = #1050#1086#1085#1089#1090#1088#1091#1082#1094#1080#1103
        Page = RibbonPage1
      end
      item
        Caption = #1053#1072#1075#1088#1091#1079#1082#1072
        Page = RibbonPage2
      end>
    TabIndex = 1
    DesignSize = (
      887
      143)
    StyleName = 'Ribbon - Luna'
    object RibbonPage1: TRibbonPage
      Left = 0
      Top = 50
      Width = 886
      Height = 93
      Caption = #1050#1086#1085#1089#1090#1088#1091#1082#1094#1080#1103
      Index = 0
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
        Width = 100
        Height = 86
        ActionManager = amMain
        Caption = 'RibbonGroup2'
        GroupIndex = 1
      end
    end
    object RibbonPage2: TRibbonPage
      Left = 0
      Top = 50
      Width = 886
      Height = 93
      Caption = #1053#1072#1075#1088#1091#1079#1082#1072
      Index = 1
    end
  end
  object pnl1: TPanel
    Left = 632
    Top = 143
    Width = 255
    Height = 617
    Align = alRight
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object spl1: TSplitter
      Left = 0
      Top = 169
      Width = 255
      Height = 5
      Cursor = crVSplit
      Align = alTop
      Color = clHighlight
      ParentColor = False
    end
    object grp1: TGroupBox
      Left = 0
      Top = 0
      Width = 255
      Height = 169
      Align = alTop
      BiDiMode = bdRightToLeftNoAlign
      Caption = #1057#1087#1080#1089#1086#1082' '#1086#1073#1098#1077#1082#1090#1086#1074
      ParentBiDiMode = False
      TabOrder = 0
    end
    object grp2: TGroupBox
      Left = 0
      Top = 174
      Width = 255
      Height = 443
      Align = alClient
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1086#1073#1098#1077#1082#1090#1072
      TabOrder = 1
    end
  end
  object sbMain: TScrollBox
    Left = 0
    Top = 143
    Width = 632
    Height = 617
    Align = alClient
    TabOrder = 2
    OnClick = sbMainClick
    object pbMain: TPaintBox
      Left = 0
      Top = 0
      Width = 628
      Height = 613
      Align = alClient
      Color = clBtnFace
      ParentColor = False
      OnPaint = pbMainPaint
      ExplicitLeft = -3
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
      end>
    Left = 256
    Top = 328
    StyleName = 'Ribbon - Luna'
    object act1: TAction
      Caption = #1057#1090#1077#1088#1078#1077#1085#1100
      OnExecute = act1Execute
    end
  end
end
