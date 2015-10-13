inherited frmMain: TfrmMain
  Caption = #1058#1088#1077#1093#1092#1072#1079#1085#1099#1081' '#1072#1089#1080#1085#1093#1088#1086#1085#1085#1099#1081' '#1076#1074#1080#1075#1072#1090#1077#1083#1100
  ClientHeight = 481
  ClientWidth = 775
  PixelsPerInch = 96
  TextHeight = 13
  inherited pcMain: TPageControl
    Width = 775
    Height = 446
    ActivePage = tsHidden
    inherited tsResults: TTabSheet
      inherited rvMain: TRichViewEdit
        Width = 767
        Height = 411
        RVFOptions = [rvfoSavePicturesBody, rvfoSaveControlsBody, rvfoSaveBinary, rvfoSaveTextStyles, rvfoSaveParaStyles, rvfoSaveLayout, rvfoSaveDocProperties, rvfoLoadDocProperties]
      end
      inherited RVRuler1: TRVRuler
        Width = 767
      end
    end
    inherited tsFirst: TTabSheet
      inherited rgLanguage: TRadioGroup
        Left = 178
        Top = 0
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 40
        Width = 751
        Height = 393
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 1
        object dbgParams: TDBGridEh
          Left = 2
          Top = 15
          Width = 747
          Height = 376
          Align = alClient
          AllowedOperations = [alopUpdateEh]
          AutoFitColWidths = True
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
          TitleParams.MultiTitle = True
          OnDataHintShow = dbgParamsDataHintShow
          OnGetCellParams = dbgParamsGetCellParams
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ITEM_ID'
              Footers = <>
              Visible = False
              Width = 69
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'NAME'
              Footers = <>
              Visible = False
              Width = 48
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'DESC_RU'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Courier New'
              Font.Style = []
              Footers = <>
              Width = 314
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ITEM_IMG'
              Footers = <>
              ReadOnly = True
              Title.Caption = #1055#1072#1088#1072#1084#1077#1090#1088
              Width = 100
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
              Width = 97
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'VALUE'
              Footers = <>
              Width = 99
            end
            item
              DisplayFormat = '####0.0##'
              DynProps = <>
              EditButtons = <>
              FieldName = 'CALC_VALUE'
              Footers = <>
              ReadOnly = True
              Width = 101
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
      object btnRecalc: TButton
        Left = 9
        Top = 9
        Width = 163
        Height = 25
        Caption = #1055#1077#1088#1077#1088#1072#1093#1091#1074#1072#1090#1080' '#1087#1072#1088#1072#1084#1077#1090#1088#1080
        TabOrder = 2
        OnClick = btnRecalcClick
      end
      object Button1: TButton
        Left = 512
        Top = 9
        Width = 75
        Height = 25
        Caption = 'MagicButton'
        TabOrder = 3
        OnClick = Button1Click
      end
    end
    inherited tsHidden: TTabSheet
      object crtMain: TChart
        Left = 24
        Top = 24
        Width = 465
        Height = 289
        Legend.Visible = False
        LeftAxis.Title.Angle = 0
        LeftAxis.Title.Caption = 'M'
        View3D = False
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Color = clWhite
        TabOrder = 0
        ColorPaletteIndex = 4
        object serP: TLineSeries
          Marks.Angle = 360
          Marks.Arrow.Visible = False
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Style = psCircle
          Marks.Callout.Visible = True
          Marks.Callout.Arrow.Visible = False
          Marks.DrawEvery = 2
          Marks.Emboss.Color = 8487297
          Marks.Font.Height = -12
          Marks.Font.Style = [fsBold]
          Marks.Shadow.Color = 8750469
          Marks.Transparent = True
          Marks.Visible = True
          LinePen.Width = 2
          Pointer.Brush.Gradient.EndColor = clBlue
          Pointer.Gradient.EndColor = clBlue
          Pointer.InflateMargins = True
          Pointer.Style = psCircle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
          Data = {
            00050000000000000000E0604000000000004055400000000000006940000000
            00008071400000000000B87040}
        end
      end
    end
  end
  inherited pnlFooter: TPanel
    Top = 446
    Width = 775
    Height = 35
    inherited btnCalc: TButton
      Left = 593
      Top = 3
    end
    inherited btnCancel: TButton
      Left = 693
      Top = 4
    end
    inherited btnSaveToFile: TButton
      Left = 483
      Top = 4
    end
    inherited btnPrev: TButton
      Left = 593
      Top = 4
    end
  end
  inherited RVStyle1: TRVStyle
    TextStyles = <
      item
        StyleName = 'Normal text'
        Charset = RUSSIAN_CHARSET
        FontName = 'Courier New'
        Size = 12
        Unicode = True
        ModifiedProperties = [rvfiFontName, rvfiSize]
      end
      item
        StyleName = 'Bold'
        FontName = 'Courier New'
        Size = 12
        Style = [fsBold]
        NextStyleNo = 0
        Unicode = True
      end
      item
        StyleName = 'Heading'
        FontName = 'Arial'
        Style = [fsBold]
        Color = clBlue
        Unicode = True
      end
      item
        StyleName = 'Subheading'
        FontName = 'Arial'
        Style = [fsBold]
        Color = clNavy
        Unicode = True
      end
      item
        StyleName = 'Keywords'
        FontName = 'Arial'
        Style = [fsItalic]
        Color = clMaroon
        Unicode = True
      end
      item
        StyleName = 'Jump 1'
        FontName = 'Arial'
        Style = [fsUnderline]
        Color = clGreen
        Jump = True
        Unicode = True
      end
      item
        StyleName = 'Jump 2'
        FontName = 'Arial'
        Style = [fsUnderline]
        Color = clGreen
        Jump = True
        BiDiMode = rvbdLeftToRight
        Unicode = True
      end>
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
