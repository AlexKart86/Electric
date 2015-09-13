inherited frmMain: TfrmMain
  Caption = 'frmMain'
  ClientHeight = 772
  ClientWidth = 802
  ExplicitWidth = 818
  ExplicitHeight = 810
  PixelsPerInch = 96
  TextHeight = 13
  inherited pcMain: TPageControl
    Width = 802
    Height = 737
    ActivePage = tsFirst
    ExplicitWidth = 802
    ExplicitHeight = 737
    inherited tsResults: TTabSheet
      ExplicitWidth = 794
      ExplicitHeight = 727
      inherited rvMain: TRichViewEdit
        Width = 794
        Height = 702
        ExplicitWidth = 794
        ExplicitHeight = 702
      end
      inherited RVRuler1: TRVRuler
        Width = 794
        ExplicitWidth = 794
      end
    end
    inherited tsFirst: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 6
      ExplicitWidth = 794
      ExplicitHeight = 727
      inherited rgLanguage: TRadioGroup
        Left = 178
        Top = 0
        ExplicitLeft = 178
        ExplicitTop = 0
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 40
        Width = 778
        Height = 684
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 1
        object dbgParams: TDBGridEh
          Left = 2
          Top = 15
          Width = 774
          Height = 667
          Align = alClient
          AllowedOperations = [alopUpdateEh]
          ColumnDefValues.AlwaysShowEditButton = True
          DataSource = dmMain.dsItems
          DrawGraphicData = True
          DynProps = <>
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Courier New'
          Font.Style = []
          IndicatorOptions = [gioShowRowIndicatorEh]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghFitRowHeightToText, dghDialogFind, dghColumnResize, dghColumnMove, dghAutoFitRowHeight, dghExtendVertLines]
          ParentFont = False
          ParentShowHint = False
          RowHeight = 4
          RowLines = 1
          ShowHint = True
          TabOrder = 0
          OnDataHintShow = dbgParamsDataHintShow
          OnGetCellParams = dbgParamsGetCellParams
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ITEM_IMG'
              Footers = <>
              ReadOnly = True
              Title.Caption = #1055#1072#1088#1072#1084#1077#1090#1088
              Width = 104
            end
            item
              LookupParams.LookupCache = False
              DynProps = <>
              DropDownBox.Columns = <
                item
                  FieldName = 'LABEL_UKR'
                end>
              DropDownBox.ListSource = dmMain.dsCurMeasList
              EditButtons = <>
              FieldName = 'MEASURE_ID_LOOKUP'
              Footers = <>
              Width = 163
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'VALUE'
              Footers = <>
              Width = 156
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'CALC_VALUE'
              Footers = <>
              ReadOnly = True
              Width = 194
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'VALUE_CORRECT'
              Footers = <>
            end>
          object RowDetailData: TRowDetailPanelControlEh
            object CRDBGrid1: TCRDBGrid
              Left = -160
              Top = -56
              Width = 320
              Height = 120
              TabOrder = 0
              TitleFont.Charset = RUSSIAN_CHARSET
              TitleFont.Color = clBlack
              TitleFont.Height = -15
              TitleFont.Name = 'Courier New'
              TitleFont.Style = []
            end
          end
        end
      end
      object btnRecalc: TButton
        Left = 5
        Top = 3
        Width = 163
        Height = 25
        Caption = #1056#1086#1079#1088#1072#1093#1091#1074#1072#1090#1080' '#1087#1072#1088#1072#1084#1077#1090#1088#1080
        TabOrder = 2
        OnClick = btnRecalcClick
      end
    end
    inherited tsHidden: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 6
      ExplicitWidth = 794
      ExplicitHeight = 727
    end
  end
  inherited pnlFooter: TPanel
    Top = 737
    Width = 802
    Height = 35
    ExplicitTop = 737
    ExplicitWidth = 802
    ExplicitHeight = 35
    inherited btnCalc: TButton
      Left = 620
      Top = 3
      ExplicitLeft = 620
      ExplicitTop = 3
    end
    inherited btnCancel: TButton
      Left = 720
      Top = 4
      ExplicitLeft = 720
      ExplicitTop = 4
    end
    inherited btnSaveToFile: TButton
      Left = 510
      Top = 4
      ExplicitLeft = 510
      ExplicitTop = 4
    end
    inherited btnPrev: TButton
      Left = 620
      Top = 4
      ExplicitLeft = 620
      ExplicitTop = 4
    end
  end
  inherited RVStyle1: TRVStyle
    ParaStyles = <
      item
        StyleName = 'Paragraph Style'
        FirstIndent = 20
        Alignment = rvaJustify
        LineSpacing = 150
        Tabs = <>
      end
      item
        StyleName = 'Centered'
        Alignment = rvaCenter
        Tabs = <>
      end
      item
        StyleName = 'Paragraph Style'
        Standard = False
        Alignment = rvaJustify
        LineSpacing = 150
        Tabs = <>
      end>
    Left = 384
    Top = 128
  end
end
