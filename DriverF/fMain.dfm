inherited frmMain: TfrmMain
  Caption = 'frmMain'
  ClientHeight = 436
  ExplicitWidth = 798
  ExplicitHeight = 474
  PixelsPerInch = 96
  TextHeight = 13
  inherited pcMain: TPageControl
    Height = 395
    ActivePage = tsFirst
    ExplicitHeight = 395
    inherited tsResults: TTabSheet
      ExplicitHeight = 385
      inherited rvMain: TRichViewEdit
        Height = 360
        ExplicitHeight = 360
      end
    end
    inherited tsFirst: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 6
      ExplicitWidth = 774
      ExplicitHeight = 385
      object GroupBox1: TGroupBox
        Left = 3
        Top = 47
        Width = 758
        Height = 336
        TabOrder = 1
        object DBGridEh1: TDBGridEh
          Left = 2
          Top = 15
          Width = 754
          Height = 319
          Align = alClient
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
          RowHeight = 4
          RowLines = 1
          TabOrder = 0
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
        Width = 180
        Height = 25
        Caption = #1056#1086#1079#1088#1072#1093#1091#1074#1072#1090#1080
        TabOrder = 2
      end
    end
    inherited tsHidden: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 6
      ExplicitWidth = 774
      ExplicitHeight = 385
    end
  end
  inherited pnlFooter: TPanel
    Top = 395
    ExplicitTop = 395
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
