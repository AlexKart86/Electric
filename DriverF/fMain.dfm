inherited frmMain: TfrmMain
  Caption = 'frmMain'
  ExplicitWidth = 798
  ExplicitHeight = 476
  PixelsPerInch = 96
  TextHeight = 13
  inherited pcMain: TPageControl
    ActivePage = tsFirst
    inherited tsFirst: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 6
      ExplicitWidth = 774
      ExplicitHeight = 386
      object DBGridEh1: TDBGridEh
        Left = 24
        Top = 48
        Width = 625
        Height = 265
        DataSource = dmMain.DataSource1
        DynProps = <>
        IndicatorOptions = [gioShowRowIndicatorEh]
        TabOrder = 1
        object RowDetailData: TRowDetailPanelControlEh
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
