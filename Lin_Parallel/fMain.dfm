object frmMain: TfrmMain
  Left = 0
  Top = 0
  ActiveControl = cbbL
  Caption = #1056#1086#1079#1088#1072#1093#1091#1085#1086#1082' '#1079#1084#1110#1096#1072#1085#1086#1075#1086' '#1079#39#1108#1076#1085#1072#1085#1085#1103' '#1087#1088#1086#1074#1110#1076#1085#1080#1082#1110#1074' ['#1042#1077#1088#1089#1110#1103' 1.0.0.2]'
  ClientHeight = 534
  ClientWidth = 788
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poPrintToFit
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 788
    Height = 493
    ActivePage = tsFirst
    Align = alClient
    TabOrder = 0
    OnChange = pcMainChange
    object tsResults: TTabSheet
      Caption = 'tsResults'
      ImageIndex = 2
      TabVisible = False
      object rvMain: TRichViewEdit
        Left = 0
        Top = 25
        Width = 780
        Height = 458
        ReadOnly = False
        Align = alClient
        TabOrder = 0
        DoInPaletteMode = rvpaCreateCopiesEx
        MaxTextWidth = 783
        MinTextWidth = 783
        RTFOptions = [rvrtfSavePicturesBinary, rvrtfSaveDocParameters, rvrtfSaveHeaderFooter]
        RTFReadProperties.TextStyleMode = rvrsAddIfNeeded
        RTFReadProperties.ParaStyleMode = rvrsAddIfNeeded
        RVFOptions = [rvfoSavePicturesBody, rvfoSaveControlsBody, rvfoSaveBinary, rvfoSaveTextStyles, rvfoSaveParaStyles, rvfoSaveDocProperties, rvfoLoadDocProperties]
        Style = RVStyle1
      end
      object RVRuler1: TRVRuler
        Left = 0
        Top = 0
        Width = 780
        Height = 25
        Align = alTop
        BottomMargin = 2.540000000000000000
        DefaultTabWidth = 1.000000000000000000
        Flat = False
        LeftMargin = 0.132291666666666700
        RightMargin = 0.132291666666666700
        RulerTexts.HintColumnMove = 'Resize table column'
        RulerTexts.HintIndentFirst = 'First Indent'
        RulerTexts.HintIndentLeft = 'Left Indent'
        RulerTexts.HintIndentHanging = 'Hanging Indent'
        RulerTexts.HintIndentRight = 'Right Indent'
        RulerTexts.HintLevelDec = 'Decrease level'
        RulerTexts.HintLevelInc = 'Increase level'
        RulerTexts.HintMarginBottom = 'Bottom margin'
        RulerTexts.HintMarginLeft = 'Left margin'
        RulerTexts.HintMarginRight = 'Right margin'
        RulerTexts.HintMarginTop = 'Top margin'
        RulerTexts.HintRowMove = 'Resize table row'
        RulerTexts.HintTabCenter = 'Center aligned tab'
        RulerTexts.HintTabDecimal = 'Decimal aligned tab'
        RulerTexts.HintTabLeft = 'Left aligned tab'
        RulerTexts.HintTabRight = 'Right aligned tab'
        RulerTexts.HintTabWordBar = 'Word Bar aligned tab'
        RulerTexts.MenuTabCenter = 'Center align'
        RulerTexts.MenuTabDecimal = 'Decimal align'
        RulerTexts.MenuTabLeft = 'Left align'
        RulerTexts.MenuTabRight = 'Right align'
        RulerTexts.MenuTabWordBar = 'Word Bar align'
        Tabs = <>
        TabSettings.DeleteCursor = crDrag
        TopMargin = 2.540000000000000000
        RichViewEdit = rvMain
        TableEditor.Active = False
        TableEditor.CellIndex = 0
        TableEditor.Cells = <>
        TableEditor.RowIndex = 0
        TableEditor.Rows = <>
        TableEditor.TableOffset = 0
      end
    end
    object tsFirst: TTabSheet
      Caption = #1042#1074#1077#1076#1077#1085#1085#1103' '#1087#1072#1088#1072#1084#1077#1090#1088#1110#1074
      TabVisible = False
      DesignSize = (
        780
        483)
      object Label1: TLabel
        Left = 3
        Top = 13
        Width = 117
        Height = 13
        Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1075#1110#1083#1086#1082' '#1089#1080#1089#1090#1077#1084#1080
      end
      object rgElemtTypes: TRadioGroup
        Left = 3
        Top = 42
        Width = 774
        Height = 62
        Anchors = [akLeft, akTop, akRight]
        Caption = #1058#1080#1087' '#1079#1072#1076#1072#1085#1085#1103' '#1087#1072#1088#1072#1084#1077#1090#1088#1110#1074' '#1082#1072#1090#1091#1096#1086#1082' '#1090#1072' '#1082#1086#1085#1076#1077#1085#1089#1072#1090#1086#1088#1110#1074
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          #1047#1072#1076#1072#1085#1110' '#1086#1087#1086#1088#1080' '#1074#1089#1110#1093' '#1077#1083#1077#1084#1077#1085#1090#1110#1074
          #1047#1072#1076#1072#1085#1072' '#1095#1072#1089#1090#1086#1090#1072' + '#1110#1085#1076#1091#1082#1090#1080#1074#1085#1110#1089#1090#1100' ('#1108#1084#1085#1110#1089#1090#1100')')
        TabOrder = 0
        OnClick = rgElemtTypesClick
      end
      object cbNodeCount: TComboBox
        Left = 152
        Top = 8
        Width = 119
        Height = 22
        Style = csOwnerDrawFixed
        ItemIndex = 0
        TabOrder = 1
        Text = '3'
        OnChange = cbNodeCountChange
        Items.Strings = (
          '3'
          '4'
          '5'
          '6'
          '7')
      end
      object gbOtherParams: TGroupBox
        Left = 5
        Top = 110
        Width = 772
        Height = 156
        Anchors = [akLeft, akTop, akRight]
        Caption = #1030#1085#1096#1110' '#1087#1072#1088#1072#1084#1077#1090#1088#1080
        TabOrder = 2
        DesignSize = (
          772
          156)
        object rgUType: TRadioGroup
          Left = 599
          Top = 19
          Width = 138
          Height = 76
          Anchors = [akTop, akRight]
          Caption = #1047#1072#1082#1086#1085' '#1079#1084#1110#1085#1080' '#1085#1072#1087#1088#1091#1075#1080
          ItemIndex = 0
          Items.Strings = (
            'sin'
            'cos')
          TabOrder = 0
        end
        object gbAddParameter: TGroupBox
          Left = 207
          Top = 19
          Width = 386
          Height = 134
          Anchors = [akTop, akRight]
          Caption = #1044#1086#1076#1072#1090#1082#1086#1074#1080#1081' '#1087#1072#1088#1072#1084#1077#1090#1088
          TabOrder = 1
          object lblNode: TLabel
            Left = 126
            Top = 24
            Width = 59
            Height = 13
            Caption = #1053#1086#1084#1077#1088' '#1075#1110#1083#1082#1080
          end
          object Label2: TLabel
            Left = 14
            Top = 24
            Width = 18
            Height = 13
            Caption = #1058#1080#1087
          end
          object Label3: TLabel
            Left = 14
            Top = 51
            Width = 48
            Height = 13
            Caption = #1047#1085#1072#1095#1077#1085#1085#1103
          end
          object lbl1: TLabel
            Left = 256
            Top = 24
            Width = 42
            Height = 13
            Caption = #1045#1083#1077#1084#1077#1085#1090
          end
          object lblW0: TLabel
            Left = 183
            Top = 51
            Width = 83
            Height = 13
            Caption = #1055#1086#1095#1072#1090#1082#1086#1074#1072' '#1092#1072#1079#1072
          end
          object imgAddParam: TImage
            Left = 14
            Top = 89
            Width = 347
            Height = 42
            Transparent = True
          end
          object edtAddParamValue: TEdit
            Left = 68
            Top = 47
            Width = 97
            Height = 21
            TabOrder = 0
            Text = '5'
            OnChange = edtAddParamValueChange
          end
          object cbAddParameter: TComboBox
            Left = 38
            Top = 19
            Width = 67
            Height = 22
            Style = csOwnerDrawFixed
            TabOrder = 1
            OnChange = cbAddParameterChange
          end
          object cbNodes: TComboBox
            Left = 191
            Top = 19
            Width = 52
            Height = 22
            Style = csOwnerDrawFixed
            ItemIndex = 1
            TabOrder = 2
            Text = '2'
            OnChange = cbNodesChange
            Items.Strings = (
              '1'
              '2'
              '3'
              '4'
              '5'
              '6'
              '7'
              '8'
              '9'
              '10')
          end
          object cbAddParamElement: TComboBox
            Left = 304
            Top = 19
            Width = 67
            Height = 22
            Style = csOwnerDrawFixed
            TabOrder = 3
            OnChange = cbAddParameterChange
          end
          object edtW0: TEdit
            Left = 272
            Top = 47
            Width = 99
            Height = 21
            TabOrder = 4
            Text = '0'
            OnChange = edtW0Change
          end
        end
        object grpW: TGroupBox
          Left = 6
          Top = 19
          Width = 195
          Height = 130
          Caption = #1063#1072#1089#1090#1086#1090#1072
          TabOrder = 2
          object rgF: TRadioGroup
            Left = 10
            Top = 16
            Width = 159
            Height = 63
            Caption = #1058#1080#1087' '#1095#1072#1089#1090#1086#1090#1080
            ItemIndex = 0
            Items.Strings = (
              #1062#1080#1082#1083#1110#1095#1085#1072' '#1095#1072#1089#1090#1086#1090#1072' (w)'
              #1063#1072#1089#1090#1086#1090#1072' (f)')
            TabOrder = 0
            OnClick = rgFClick
          end
          object edtF: TEdit
            Left = 12
            Top = 92
            Width = 157
            Height = 21
            TabOrder = 1
            Text = '1'
          end
        end
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 272
        Width = 774
        Height = 208
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080' '#1089#1093#1077#1084#1080
        TabOrder = 3
        object sgElements: TStringGrid
          Left = 2
          Top = 15
          Width = 770
          Height = 191
          Align = alClient
          ColCount = 4
          DrawingStyle = gdsGradient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          GradientEndColor = cl3DLight
          GradientStartColor = clWindow
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor]
          ParentFont = False
          TabOrder = 0
          OnMouseUp = sgElementsMouseUp
          OnMouseWheelDown = sgElementsMouseWheelDown
          ColWidths = (
            64
            147
            165
            158)
          RowHeights = (
            24
            24
            24
            24
            24)
        end
        object cbbL: TDBComboBoxEh
          Left = 316
          Top = 19
          Width = 58
          Height = 21
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Items.Strings = (
            #1043#1085
            #1084#1043#1085
            #1084#1082#1043#1085)
          KeyItems.Strings = (
            '1'
            '0.001'
            '0.000001')
          ParentFont = False
          TabOrder = 1
          Text = #1084#1043#1085
          Visible = True
        end
        object cbbC: TDBComboBoxEh
          Left = 481
          Top = 19
          Width = 58
          Height = 21
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Items.Strings = (
            #1060
            #1084#1060
            #1084#1082#1060
            #1085#1060)
          KeyItems.Strings = (
            '1'
            '0.001'
            '0.000001'
            '0.000000001')
          ParentFont = False
          TabOrder = 2
          Text = #1084#1082#1060
          Visible = True
        end
      end
      object rgLanguage: TRadioGroup
        Left = 293
        Top = -2
        Width = 318
        Height = 38
        Caption = #1052#1086#1074#1072' '#1074#1080#1074#1086#1076#1091' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1091
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          #1059#1082#1088#1072#1111#1085#1089#1100#1082#1072
          #1056#1086#1089#1110#1081#1089#1100#1082#1072)
        TabOrder = 4
        OnClick = rgLanguageClick
      end
    end
    object tsHidden: TTabSheet
      Caption = 'tsHidden'
      ImageIndex = 2
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object crtU: TChart
        Left = 10
        Top = 3
        Width = 680
        Height = 400
        Legend.CheckBoxesStyle = cbsRadio
        Legend.CustomPosition = True
        Legend.Left = 540
        Legend.ResizeChart = False
        Legend.Title.Text.Strings = (
          #1055#1086#1079#1085#1072#1095#1077#1085#1085#1103':')
        Legend.Top = 40
        Title.Text.Strings = (
          #1047#1072#1083#1077#1078#1085#1110#1089#1090#1100' '#1089#1090#1088#1091#1084#1091' '#1090#1072' '#1085#1072#1087#1088#1091#1075#1080' '#1074#1110#1076' '#969#8729't')
        BottomAxis.Title.Caption = #969#8729't, c'
        DepthAxis.Visible = True
        DepthTopAxis.Visible = True
        LeftAxis.Title.Caption = 'U, '#1042
        RightAxis.Grid.Color = clSilver
        RightAxis.Grid.Style = psSolid
        RightAxis.Grid.DrawEvery = 2
        RightAxis.Grid.ZZero = True
        RightAxis.GridCentered = True
        RightAxis.Title.Angle = 90
        RightAxis.Title.Caption = 'I, A'
        RightAxis.ZPosition = 0.010000000000000000
        View3D = False
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 0
        ColorPaletteIndex = 13
        object serU: TLineSeries
          LegendTitle = #1053#1072#1087#1088#1091#1075#1072
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Title = #1053#1072#1087#1088#1091#1075#1072
          LinePen.Width = 2
          Pointer.Brush.Gradient.EndColor = 10708548
          Pointer.Gradient.EndColor = 10708548
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object serI: TLineSeries
          LegendTitle = #1057#1090#1088#1091#1084
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Title = #1057#1090#1088#1091#1084
          VertAxis = aRightAxis
          LinePen.Style = psDot
          LinePen.Width = 3
          LinePen.EndStyle = esFlat
          Pointer.Brush.Gradient.EndColor = 3513587
          Pointer.Gradient.EndColor = 3513587
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
      object crtI: TChart
        Left = 99
        Top = 22
        Width = 620
        Height = 400
        Legend.Alignment = laBottom
        Legend.CustomPosition = True
        Legend.Left = 115
        Legend.ResizeChart = False
        Legend.Top = 325
        Title.Text.Strings = (
          #1047#1072#1083#1077#1078#1085#1110#1089#1090#1100' '#1089#1090#1088#1091#1084#1110#1074' '#1074' '#1075#1110#1083#1082#1072#1093' '#1089#1093#1077#1084#1080'  '#1074#1110#1076' '#969#8729't')
        BottomAxis.Title.Caption = #969#8729't, c'
        DepthAxis.Visible = True
        DepthTopAxis.Visible = True
        LeftAxis.Title.Caption = 'I, A'
        RightAxis.Title.Caption = 'j'
        RightAxis.Title.Visible = False
        View3D = False
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 1
        ColorPaletteIndex = 13
        object LineSeries1: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Title = #1057#1090#1088#1091#1084' I1'
          LinePen.Width = 2
          Pointer.Brush.Gradient.EndColor = 10708548
          Pointer.Gradient.EndColor = 10708548
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
          object TSmoothingFunction
            CalcByValue = False
            Period = 1.000000000000000000
            Factor = 8
          end
        end
        object LineSeries2: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Title = #1057#1090#1088#1091#1084'  I2'
          LinePen.Style = psDot
          LinePen.Width = 3
          LinePen.EndStyle = esFlat
          Pointer.Brush.Gradient.EndColor = 3513587
          Pointer.Gradient.EndColor = 3513587
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
          object TSmoothingFunction
            CalcByValue = False
            Period = 1.000000000000000000
            Factor = 8
          end
        end
        object Series1: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Title = #1057#1090#1088#1091#1084'  I3'
          LinePen.Style = psDash
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
          object TSmoothingFunction
            CalcByValue = False
            Period = 1.000000000000000000
            Factor = 8
          end
        end
        object Series2: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Title = #1057#1090#1088#1091#1084'  I4'
          LinePen.Width = 4
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
          object TSmoothingFunction
            CalcByValue = False
            Period = 1.000000000000000000
            Factor = 8
          end
        end
        object Series3: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Title = #1057#1090#1088#1091#1084' I5'
          LinePen.Style = psDashDotDot
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
          object TSmoothingFunction
            CalcByValue = False
            Period = 1.000000000000000000
            Factor = 8
          end
        end
        object Series4: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          SeriesColor = clBlack
          Title = #1047#1072#1075#1072#1083#1100#1085#1080#1081' '#1089#1090#1088#1091#1084
          LinePen.Width = 2
          LinePen.SmallDots = True
          Pointer.Brush.Gradient.EndColor = 10708548
          Pointer.Gradient.EndColor = 10708548
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
          object TeeFunction1: TSmoothingFunction
            CalcByValue = False
            Period = 1.000000000000000000
          end
        end
      end
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 493
    Width = 788
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      788
      41)
    object btnCalc: TButton
      Left = 606
      Top = 6
      Width = 83
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1056#1086#1079#1088#1072#1093#1091#1074#1072#1090#1080
      TabOrder = 0
      OnClick = btnCalcClick
    end
    object btnCancel: TButton
      Left = 706
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1042#1110#1076#1084#1110#1085#1072
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnSaveToFile: TButton
      Left = 496
      Top = 6
      Width = 104
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080' '#1074' '#1092#1072#1081#1083
      TabOrder = 2
      OnClick = btnSaveToFileClick
    end
    object btnPrev: TButton
      Left = 606
      Top = 6
      Width = 83
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1057#1087#1086#1095#1072#1090#1082#1091
      TabOrder = 3
      OnClick = btnPrevClick
    end
    object btn1: TButton
      Left = 366
      Top = 6
      Width = 124
      Height = 25
      Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1090#1080' '#1090#1086#1095#1085#1110#1089#1090#1100
      TabOrder = 4
      OnClick = btn1Click
    end
    object btnEditDiagram: TButton
      Left = 228
      Top = 6
      Width = 132
      Height = 25
      Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1090#1080' '#1076#1110#1072#1075#1088#1072#1084#1091
      TabOrder = 5
      OnClick = btnEditDiagramClick
    end
  end
  object dlgSave: TSaveDialog
    DefaultExt = 'rtf'
    Filter = 'RichTextFiles|*.RTF'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 208
    Top = 312
  end
  object RVStyle1: TRVStyle
    TextStyles = <
      item
        StyleName = 'Normal text'
        Charset = RUSSIAN_CHARSET
        FontName = 'Times New Roman'
        Size = 14
        Unicode = True
        ModifiedProperties = [rvfiFontName, rvfiSize]
      end
      item
        StyleName = 'Bold'
        FontName = 'Times New Roman'
        Size = 14
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
      end>
    ListStyles = <>
    InvalidPicture.Data = {
      07544269746D617036100000424D361000000000000036000000280000002000
      0000200000000100200000000000001000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF000000FF000000FF00FFFF
      FF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF000000FF000000FF00FFFF
      FF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800080808000808080008080800080808000808080008080
      800080808000808080008080800080808000808080008080800080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000}
    StyleTemplates = <>
    Left = 272
    Top = 72
  end
  object ilAddParam: TImageList
    Left = 648
    Top = 48
  end
end
