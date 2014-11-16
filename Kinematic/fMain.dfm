inherited frmMain: TfrmMain
  Caption = #1050#1080#1085#1077#1084#1072#1090#1080#1082#1072' '#1090#1086#1095#1082#1080' [v 1.0.1.0]'
  ClientHeight = 534
  ExplicitHeight = 572
  PixelsPerInch = 96
  TextHeight = 13
  inherited pcMain: TPageControl
    Height = 493
    ActivePage = tsFirst
    ExplicitHeight = 493
    inherited tsResults: TTabSheet
      ExplicitHeight = 483
      inherited rvMain: TRichViewEdit
        Height = 458
        ExplicitHeight = 458
      end
    end
    inherited tsFirst: TTabSheet
      ExplicitHeight = 483
      object edtXt: TLabeledEdit
        Left = 48
        Top = 20
        Width = 121
        Height = 21
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = 'X(t)='
        LabelPosition = lpLeft
        TabOrder = 1
      end
      object edtYt: TLabeledEdit
        Left = 48
        Top = 56
        Width = 121
        Height = 21
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = 'Y(t)='
        LabelPosition = lpLeft
        TabOrder = 2
      end
      object edtt1: TLabeledEdit
        Left = 48
        Top = 90
        Width = 121
        Height = 21
        EditLabel.Width = 18
        EditLabel.Height = 13
        EditLabel.Caption = 't1='
        LabelPosition = lpLeft
        TabOrder = 3
      end
      object edtDigits: TLabeledEdit
        Left = 112
        Top = 120
        Width = 57
        Height = 21
        EditLabel.Width = 87
        EditLabel.Height = 13
        EditLabel.Caption = #1047#1085#1072#1082#1110#1074' '#1087#1110#1089#1083#1103' '#1082#1086#1084#1080
        LabelPosition = lpLeft
        TabOrder = 4
        Text = '3'
      end
      object grp1: TGroupBox
        Left = 11
        Top = 156
        Width = 209
        Height = 193
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080' '#1087#1086#1073#1091#1076#1086#1074#1080' '#1075#1088#1072#1092#1110#1082#1072' '#1092#1091#1085#1082#1094#1110#1111
        TabOrder = 5
        object edtMint: TLabeledEdit
          Left = 48
          Top = 22
          Width = 121
          Height = 21
          EditLabel.Width = 23
          EditLabel.Height = 13
          EditLabel.Caption = #1052#1110#1085' t'
          LabelPosition = lpLeft
          TabOrder = 0
          Text = '0'
        end
        object edtMaxt: TLabeledEdit
          Left = 48
          Top = 49
          Width = 121
          Height = 21
          EditLabel.Width = 32
          EditLabel.Height = 13
          EditLabel.Caption = #1052#1072#1082#1089' t'
          LabelPosition = lpLeft
          TabOrder = 1
        end
        object edtMinx: TLabeledEdit
          Left = 48
          Top = 76
          Width = 121
          Height = 21
          EditLabel.Width = 25
          EditLabel.Height = 13
          EditLabel.Caption = #1052#1110#1085' x'
          LabelPosition = lpLeft
          TabOrder = 2
        end
        object edtMaxx: TLabeledEdit
          Left = 48
          Top = 103
          Width = 121
          Height = 21
          EditLabel.Width = 34
          EditLabel.Height = 13
          EditLabel.Caption = #1052#1072#1082#1089' x'
          LabelPosition = lpLeft
          TabOrder = 3
        end
        object edtMaxy: TLabeledEdit
          Left = 48
          Top = 157
          Width = 121
          Height = 21
          EditLabel.Width = 34
          EditLabel.Height = 13
          EditLabel.Caption = #1052#1072#1082#1089' y'
          LabelPosition = lpLeft
          TabOrder = 5
        end
        object edtMiny: TLabeledEdit
          Left = 48
          Top = 130
          Width = 121
          Height = 21
          EditLabel.Width = 25
          EditLabel.Height = 13
          EditLabel.Caption = #1052#1110#1085' y'
          LabelPosition = lpLeft
          TabOrder = 4
        end
      end
    end
    inherited tsHidden: TTabSheet
      ExplicitHeight = 483
    end
  end
  inherited pnlFooter: TPanel
    Top = 493
    ExplicitTop = 493
    object btnDrawGraph: TButton
      Left = 352
      Top = 6
      Width = 121
      Height = 25
      Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1090#1080' '#1075#1088#1072#1092#1110#1082
      TabOrder = 4
      OnClick = btnDrawGraphClick
    end
  end
  inherited dlgSave: TSaveDialog
    Left = 304
    Top = 304
  end
  inherited RVStyle1: TRVStyle
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
      end
      item
        StyleName = 'Upper'
        FontName = 'Arial'
        VShift = 15
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
        SpaceBefore = 1
        SpaceAfter = 1
        Alignment = rvaJustify
        Border.Width = 2
        Border.Color = clRed
        Border.Style = rvbSingle
        Border.BorderOffsets.Left = 1
        Border.BorderOffsets.Right = 1
        Border.BorderOffsets.Top = 1
        Border.BorderOffsets.Bottom = 1
        LineSpacing = 150
        Tabs = <>
      end
      item
        StyleName = 'Paragraph Style'
        Standard = False
        Alignment = rvaJustify
        LineSpacing = 150
        Tabs = <>
      end>
    Left = 656
    Top = 80
  end
end
