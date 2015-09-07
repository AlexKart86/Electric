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
    inherited tsResults: TTabSheet
      inherited rvMain: TRichViewEdit
        Height = 360
      end
    end
    inherited tsFirst: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 6
      ExplicitWidth = 774
      ExplicitHeight = 386
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
          DataSource = dmMain.dsItems
          DrawGraphicData = True
          DynProps = <>
          IndicatorOptions = [gioShowRowIndicatorEh]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghFitRowHeightToText, dghDialogFind, dghColumnResize, dghColumnMove, dghAutoFitRowHeight, dghExtendVertLines]
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
            end>
          object RowDetailData: TRowDetailPanelControlEh
            object CRDBGrid1: TCRDBGrid
              Left = -160
              Top = -56
              Width = 320
              Height = 120
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Tahoma'
              TitleFont.Style = []
            end
          end
        end
      end
    end
    inherited tsHidden: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 6
      ExplicitWidth = 774
      ExplicitHeight = 386
    end
  end
  inherited pnlFooter: TPanel
    Top = 395
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
  end
end
