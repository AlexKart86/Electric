inherited frmMain: TfrmMain
  ActiveControl = cbW
  Caption = #1056#1086#1079#1088#1072#1093#1091#1085#1086#1082' '#1090#1088#1100#1086#1093#1092#1072#1079#1085#1080#1093' '#1082#1110#1083' ['#1042#1077#1088#1089#1110#1103' 1.0.3.0]'
  ClientHeight = 548
  ClientWidth = 848
  ExplicitWidth = 864
  ExplicitHeight = 586
  PixelsPerInch = 96
  TextHeight = 13
  inherited pcMain: TPageControl
    Width = 848
    Height = 507
    ActivePage = tsFirst
    ExplicitWidth = 848
    ExplicitHeight = 507
    inherited tsResults: TTabSheet
      ExplicitWidth = 840
      ExplicitHeight = 497
      inherited rvMain: TRichViewEdit
        Width = 840
        Height = 472
        TabOrder = 1
        DocParameters.PageWidth = 29.700000000000000000
        DocParameters.PageHeight = 21.000000000000000000
        DocParameters.Units = rvuCentimeters
        DocParameters.LeftMargin = 0.500000000000000000
        DocParameters.BottomMargin = 0.100000000000000000
        DocParameters.HeaderY = 0.100000000000000000
        DocParameters.FooterY = 0.100000000000000000
        DocParameters.ZoomPercent = 80
        Options = [rvoAllowSelection, rvoScrollToEnd, rvoClientTextWidth, rvoShowPageBreaks, rvoAutoCopyUnicodeText, rvoAutoCopyRVF, rvoAutoCopyImage, rvoAutoCopyRTF, rvoFormatInvalidate, rvoDblClickSelectsWord, rvoRClickDeselects]
        RTFOptions = [rvrtfSaveStyleSheet, rvrtfSavePicturesBinary, rvrtfSaveDocParameters, rvrtfSaveHeaderFooter]
        ExplicitWidth = 840
        ExplicitHeight = 472
      end
      inherited RVRuler1: TRVRuler
        Width = 840
        ExplicitWidth = 840
      end
    end
    inherited tsFirst: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 6
      ExplicitWidth = 840
      ExplicitHeight = 497
      object lblSR0: TLabel [0]
        Left = 14
        Top = 115
        Width = 27
        Height = 13
        Caption = 'R0 = '
      end
      inherited rgLanguage: TRadioGroup
        Left = 400
        Top = 8
        Width = 364
        TabOrder = 2
        ExplicitLeft = 400
        ExplicitTop = 8
        ExplicitWidth = 364
      end
      object gbStar: TGroupBox
        Left = 14
        Top = 149
        Width = 388
        Height = 222
        TabOrder = 5
        object gbSU: TGroupBox
          Left = 12
          Top = 39
          Width = 364
          Height = 52
          Caption = #1050#1091#1090#1080' '#1085#1072#1087#1088#1091#1075#1080
          TabOrder = 0
          object Label4: TLabel
            Left = 262
            Top = 27
            Width = 22
            Height = 13
            Caption = 'ejc='
          end
          object Label5: TLabel
            Left = 131
            Top = 27
            Width = 23
            Height = 13
            Caption = 'ejb='
          end
          object Label6: TLabel
            Left = 11
            Top = 27
            Width = 23
            Height = 13
            Caption = 'eja='
          end
          object cbSejc: TComboBox
            Left = 286
            Top = 22
            Width = 62
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = 4
            ParentFont = False
            TabOrder = 2
            Text = '120'
            Items.Strings = (
              '-120'
              '-30'
              '0'
              '30'
              '120')
          end
          object cbSejb: TComboBox
            Left = 155
            Top = 22
            Width = 62
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = 0
            ParentFont = False
            TabOrder = 1
            Text = '-120'
            Items.Strings = (
              '-120'
              '-30'
              '0'
              '30'
              '120')
          end
          object cbSEja: TComboBox
            Left = 35
            Top = 22
            Width = 62
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = 2
            ParentFont = False
            TabOrder = 0
            Text = '0'
            Items.Strings = (
              '-120'
              '-30'
              '0'
              '30'
              '120')
          end
        end
        object gbSR: TGroupBox
          Left = 13
          Top = 97
          Width = 372
          Height = 111
          Caption = #1054#1087#1086#1088#1080
          TabOrder = 1
          object lblRa: TLabel
            Left = 8
            Top = 24
            Width = 21
            Height = 13
            Caption = 'Ra='
          end
          object lblRb: TLabel
            Left = 8
            Top = 52
            Width = 21
            Height = 13
            Caption = 'Rb='
          end
          object lblRc: TLabel
            Left = 8
            Top = 80
            Width = 20
            Height = 13
            Caption = 'Rc='
          end
          object lblSXla: TLabel
            Left = 93
            Top = 24
            Width = 22
            Height = 13
            Caption = 'Xla='
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lblSXCa: TLabel
            Left = 234
            Top = 24
            Width = 27
            Height = 13
            Caption = 'X'#1057'a='
          end
          object lblSXCb: TLabel
            Left = 234
            Top = 52
            Width = 27
            Height = 13
            Caption = 'X'#1057'b='
          end
          object lblSXlb: TLabel
            Left = 93
            Top = 52
            Width = 22
            Height = 13
            Caption = 'Xlb='
          end
          object lblSXCc: TLabel
            Left = 234
            Top = 80
            Width = 26
            Height = 13
            Caption = 'X'#1057'c='
          end
          object lblSXlc: TLabel
            Left = 93
            Top = 80
            Width = 21
            Height = 13
            Caption = 'Xlc='
          end
          object dbnSRa: TDBNumberEditEh
            Left = 35
            Top = 19
            Width = 52
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Visible = True
          end
          object dbnSRb: TDBNumberEditEh
            Left = 35
            Top = 47
            Width = 52
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            Visible = True
          end
          object dbnSRc: TDBNumberEditEh
            Left = 35
            Top = 75
            Width = 52
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 10
            Visible = True
          end
          object dbnSXla: TDBNumberEditEh
            Left = 120
            Top = 19
            Width = 46
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Visible = True
          end
          object dbnSXCa: TDBNumberEditEh
            Left = 267
            Top = 19
            Width = 45
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            Visible = True
          end
          object cbSLa: TDBComboBoxEh
            Left = 170
            Top = 19
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1043#1085
              #1084#1043#1085
              #1084#1082#1043#1085)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000')
            ParentShowHint = False
            TabOrder = 2
            Visible = True
          end
          object cbSCa: TDBComboBoxEh
            Left = 318
            Top = 19
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1060
              #1084#1060
              #1084#1082#1060
              #1085#1060)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000'
              '1000000000')
            TabOrder = 4
            Visible = True
          end
          object cbSCb: TDBComboBoxEh
            Left = 317
            Top = 47
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1060
              #1084#1060
              #1084#1082#1060
              #1085#1060)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000'
              '1000000000')
            TabOrder = 9
            Visible = True
          end
          object dbnSXCb: TDBNumberEditEh
            Left = 267
            Top = 47
            Width = 45
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 8
            Visible = True
          end
          object cbSlb: TDBComboBoxEh
            Left = 170
            Top = 47
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1043#1085
              #1084#1043#1085
              #1084#1082#1043#1085)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000')
            TabOrder = 7
            Visible = True
          end
          object dbnSXlb: TDBNumberEditEh
            Left = 120
            Top = 47
            Width = 46
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 6
            Visible = True
          end
          object cbSCc: TDBComboBoxEh
            Left = 317
            Top = 76
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1060
              #1084#1060
              #1084#1082#1060
              #1085#1060)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000'
              '1000000000')
            TabOrder = 14
            Visible = True
          end
          object dbnSXCc: TDBNumberEditEh
            Left = 267
            Top = 75
            Width = 45
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 13
            Visible = True
          end
          object cbSlc: TDBComboBoxEh
            Left = 170
            Top = 75
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1043#1085
              #1084#1043#1085
              #1084#1082#1043#1085)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000')
            TabOrder = 12
            Visible = True
          end
          object dbnSxlc: TDBNumberEditEh
            Left = 120
            Top = 75
            Width = 46
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 11
            Visible = True
          end
        end
      end
      object chbStar: TCheckBox
        Left = 25
        Top = 142
        Width = 88
        Height = 17
        Caption = #1057#1093#1077#1084#1072' "'#1047#1110#1088#1082#1072'"'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = chbStarClick
      end
      object gbTriangle: TGroupBox
        Left = 423
        Top = 149
        Width = 388
        Height = 222
        TabOrder = 6
        object gbTu: TGroupBox
          Left = 13
          Top = 39
          Width = 364
          Height = 53
          Caption = #1050#1091#1090#1080' '#1085#1072#1087#1088#1091#1075#1080
          TabOrder = 0
          object Label18: TLabel
            Left = 266
            Top = 25
            Width = 22
            Height = 13
            Caption = 'ejc='
          end
          object Label19: TLabel
            Left = 122
            Top = 25
            Width = 23
            Height = 13
            Caption = 'ejb='
          end
          object Label20: TLabel
            Left = 12
            Top = 25
            Width = 23
            Height = 13
            Caption = 'eja='
          end
          object cbTejc: TComboBox
            Left = 290
            Top = 20
            Width = 62
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = 8
            ParentFont = False
            TabOrder = 2
            Text = '150'
            Items.Strings = (
              '-150'
              '-120'
              '-90'
              '-30'
              '0'
              '30'
              '90'
              '120'
              '150')
          end
          object cbTejb: TComboBox
            Left = 146
            Top = 20
            Width = 62
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = 2
            ParentFont = False
            TabOrder = 1
            Text = '-90'
            Items.Strings = (
              '-150'
              '-120'
              '-90'
              '-30'
              '0'
              '30'
              '90'
              '120'
              '150')
          end
          object cbTeja: TComboBox
            Left = 36
            Top = 20
            Width = 62
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = 5
            ParentFont = False
            TabOrder = 0
            Text = '30'
            Items.Strings = (
              '-150'
              '-120'
              '-90'
              '-30'
              '0'
              '30'
              '90'
              '120'
              '150')
          end
        end
        object gbTR: TGroupBox
          Left = 13
          Top = 97
          Width = 372
          Height = 111
          Caption = #1054#1087#1086#1088#1080
          TabOrder = 1
          object lblRab: TLabel
            Left = 8
            Top = 25
            Width = 27
            Height = 13
            Caption = 'Rab='
          end
          object lblRbc: TLabel
            Left = 8
            Top = 51
            Width = 26
            Height = 13
            Caption = 'Rbc='
          end
          object lblRac: TLabel
            Left = 8
            Top = 80
            Width = 26
            Height = 13
            Caption = 'Rac='
          end
          object lblTXLa: TLabel
            Left = 95
            Top = 25
            Width = 31
            Height = 13
            Caption = 'XLab='
          end
          object lblTXCa: TLabel
            Left = 232
            Top = 25
            Width = 33
            Height = 13
            Caption = 'X'#1057'ab='
          end
          object lblTXCb: TLabel
            Left = 232
            Top = 53
            Width = 32
            Height = 13
            Caption = 'X'#1057'bc='
          end
          object lblTXLb: TLabel
            Left = 95
            Top = 53
            Width = 30
            Height = 13
            Caption = 'XLbc='
          end
          object lblTXCc: TLabel
            Left = 232
            Top = 79
            Width = 32
            Height = 13
            Caption = 'X'#1057'ac='
          end
          object lblTXLc: TLabel
            Left = 95
            Top = 79
            Width = 30
            Height = 13
            Caption = 'XLac='
          end
          object dbnTRa: TDBNumberEditEh
            Left = 35
            Top = 21
            Width = 52
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Visible = True
          end
          object dbnTRb: TDBNumberEditEh
            Left = 35
            Top = 47
            Width = 52
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            Visible = True
          end
          object dbnTRc: TDBNumberEditEh
            Left = 35
            Top = 76
            Width = 52
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 10
            Visible = True
          end
          object dbnTXla: TDBNumberEditEh
            Left = 126
            Top = 21
            Width = 46
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Visible = True
          end
          object dbnTXCa: TDBNumberEditEh
            Left = 267
            Top = 21
            Width = 45
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            Visible = True
          end
          object cbTLa: TDBComboBoxEh
            Left = 176
            Top = 21
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1043#1085
              #1084#1043#1085
              #1084#1082#1043#1085)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000')
            TabOrder = 2
            Visible = True
          end
          object cbTCa: TDBComboBoxEh
            Left = 318
            Top = 21
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1060
              #1084#1060
              #1084#1082#1060
              #1085#1060)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000'
              '1000000000')
            TabOrder = 4
            Visible = True
          end
          object cbTCb: TDBComboBoxEh
            Left = 317
            Top = 49
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1060
              #1084#1060
              #1084#1082#1060
              #1085#1060)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000'
              '1000000000')
            TabOrder = 9
            Visible = True
          end
          object dbnTXCb: TDBNumberEditEh
            Left = 267
            Top = 49
            Width = 45
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 8
            Visible = True
          end
          object cbTLb: TDBComboBoxEh
            Left = 176
            Top = 49
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1043#1085
              #1084#1043#1085
              #1084#1082#1043#1085)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000')
            TabOrder = 7
            Visible = True
          end
          object dbnTXlb: TDBNumberEditEh
            Left = 126
            Top = 49
            Width = 46
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 6
            Visible = True
          end
          object cbTCc: TDBComboBoxEh
            Left = 317
            Top = 75
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1060
              #1084#1060
              #1084#1082#1060
              #1085#1060)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000'
              '1000000000')
            TabOrder = 14
            Visible = True
          end
          object dbnTXcc: TDBNumberEditEh
            Left = 267
            Top = 75
            Width = 45
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 13
            Visible = True
          end
          object cbTLc: TDBComboBoxEh
            Left = 176
            Top = 75
            Width = 47
            Height = 21
            DynProps = <>
            EditButtons = <>
            Items.Strings = (
              #1043#1085
              #1084#1043#1085
              #1084#1082#1043#1085)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000')
            TabOrder = 12
            Visible = True
          end
          object dbnTXlc: TDBNumberEditEh
            Left = 126
            Top = 75
            Width = 46
            Height = 22
            Alignment = taCenter
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 11
            Visible = True
          end
        end
      end
      object chbTriangle: TCheckBox
        Left = 436
        Top = 142
        Width = 117
        Height = 17
        Caption = #1057#1093#1077#1084#1072' "'#1058#1088#1080#1082#1091#1090#1085#1080#1082'"'
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = chbTriangleClick
      end
      object gbW: TGroupBox
        Left = 13
        Top = 8
        Width = 170
        Height = 89
        Caption = #1063#1072#1089#1090#1086#1090#1072
        TabOrder = 0
        object cbF: TCheckBox
          Left = 13
          Top = 38
          Width = 118
          Height = 17
          Caption = #1063#1072#1089#1090#1086#1090#1072' (f)'
          TabOrder = 1
          OnClick = cbFClick
        end
        object dbnW: TDBNumberEditEh
          Left = 13
          Top = 56
          Width = 140
          Height = 22
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Visible = True
        end
        object cbW: TCheckBox
          Left = 13
          Top = 15
          Width = 140
          Height = 17
          Caption = #1062#1080#1082#1083#1110#1095#1085#1072' '#1095#1072#1089#1090#1086#1090#1072' (W)'
          TabOrder = 0
          OnClick = cbWClick
        end
      end
      object gbU: TGroupBox
        Left = 189
        Top = 8
        Width = 181
        Height = 89
        Caption = #1053#1072#1087#1088#1091#1075#1072
        TabOrder = 1
        object rgUType: TRadioGroup
          Left = 9
          Top = 14
          Width = 164
          Height = 34
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            #1060#1072#1079#1085#1072
            #1051#1110#1085#1110#1081#1085#1072)
          TabOrder = 0
          OnClick = rgUTypeClick
        end
        object cbU: TComboBox
          Left = 14
          Top = 56
          Width = 155
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = 2
          ParentFont = False
          TabOrder = 1
          Text = '380'
          Items.Strings = (
            '127'
            '220'
            '380')
        end
      end
      object grp1: TGroupBox
        Left = 400
        Top = 49
        Width = 364
        Height = 45
        Caption = #1056#1086#1079#1084#1110#1088#1080' '#1076#1110#1075#1088#1072#1084#1080' ('#1087#1110#1082#1089#1077#1083#1110')'
        TabOrder = 7
        object dbnDiagramSize: TDBNumberEditEh
          Left = 12
          Top = 16
          Width = 121
          Height = 21
          Alignment = taLeftJustify
          DynProps = <>
          EditButtons = <>
          TabOrder = 0
          Value = 650.000000000000000000
          Visible = True
        end
      end
      object chkIsR0Infty: TCheckBox
        Left = 146
        Top = 113
        Width = 97
        Height = 17
        Caption = #1053#1077#1089#1082#1110#1085#1095#1077#1085#1085#1110#1089#1090#1100
        TabOrder = 8
        OnClick = chkIsR0InftyClick
      end
      object dbnSR0: TDBNumberEditEh
        Left = 47
        Top = 110
        Width = 72
        Height = 22
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        Value = 0.000000000000000000
        Visible = True
      end
      object chkIsSimpleMode: TCheckBox
        Left = 265
        Top = 113
        Width = 184
        Height = 17
        Caption = #1057#1087#1088#1086#1097#1077#1085#1080#1081' '#1088#1077#1078#1080#1084' '#1088#1086#1079#1088#1072#1093#1091#1085#1082#1091
        TabOrder = 10
        OnClick = chkIsSimpleModeClick
      end
      object grpAvaria: TGroupBox
        Left = 14
        Top = 377
        Width = 403
        Height = 105
        Caption = #1040#1074#1072#1088#1110#1081#1085#1080#1081' '#1088#1077#1078#1080#1084' '#1088#1086#1073#1086#1090#1080
        TabOrder = 11
        object grpFaza: TGroupBox
          Left = 10
          Top = 14
          Width = 185
          Height = 86
          Caption = #1050#1047' '#1092#1072#1079#1080
          TabOrder = 0
          object chkFazaA: TCheckBox
            Left = 11
            Top = 16
            Width = 97
            Height = 17
            Caption = #1092#1072#1079#1072' "'#1040'"'
            TabOrder = 0
            OnClick = RefreshAvariaCheckBoxes
          end
          object chkFazaB: TCheckBox
            Left = 11
            Top = 39
            Width = 97
            Height = 17
            Caption = #1092#1072#1079#1072' "'#1042'"'
            TabOrder = 1
            OnClick = RefreshAvariaCheckBoxes
          end
          object chkFazaC: TCheckBox
            Left = 11
            Top = 61
            Width = 97
            Height = 17
            Caption = #1092#1072#1079#1072' "'#1057'"'
            TabOrder = 2
            OnClick = RefreshAvariaCheckBoxes
          end
        end
        object grpLin: TGroupBox
          Left = 203
          Top = 14
          Width = 185
          Height = 86
          Caption = #1054#1073#1088#1080#1074' '#1083#1110#1085#1110#1081#1085#1086#1075#1086' '#1087#1088#1086#1074#1086#1076#1072
          TabOrder = 1
          object chkLinA: TCheckBox
            Left = 11
            Top = 16
            Width = 97
            Height = 17
            Caption = #1092#1072#1079#1072' "'#1040'"'
            TabOrder = 0
            OnClick = RefreshAvariaCheckBoxes
          end
          object chkLinB: TCheckBox
            Left = 11
            Top = 39
            Width = 97
            Height = 17
            Caption = #1092#1072#1079#1072' "'#1042'"'
            TabOrder = 1
            OnClick = RefreshAvariaCheckBoxes
          end
          object chkLinC: TCheckBox
            Left = 11
            Top = 61
            Width = 97
            Height = 17
            Caption = #1092#1072#1079#1072' "'#1057'"'
            TabOrder = 2
            OnClick = RefreshAvariaCheckBoxes
          end
        end
      end
    end
    inherited tsHidden: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 6
      ExplicitWidth = 840
      ExplicitHeight = 497
    end
  end
  inherited pnlFooter: TPanel
    Top = 507
    Width = 848
    ExplicitTop = 507
    ExplicitWidth = 848
    inherited btnCalc: TButton
      Left = 678
      TabOrder = 2
      ExplicitLeft = 678
    end
    inherited btnCancel: TButton
      Left = 766
      TabOrder = 3
      ExplicitLeft = 766
    end
    inherited btnSaveToFile: TButton
      Left = 568
      TabOrder = 0
      ExplicitLeft = 568
    end
    inherited btnPrev: TButton
      Left = 677
      TabOrder = 1
      ExplicitLeft = 677
    end
    object btnRounds: TButton
      Left = 433
      Top = 6
      Width = 104
      Height = 25
      Caption = #1058#1086#1095#1085#1110#1089#1090#1100'...'
      TabOrder = 4
      OnClick = btnRoundsClick
    end
    object btnEditDiagram: TButton
      Left = 404
      Top = 6
      Width = 132
      Height = 25
      Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1090#1080' '#1076#1110#1072#1075#1088#1072#1084#1091
      TabOrder = 5
      OnClick = btnEditDiagramClick
    end
  end
  inherited dlgSave: TSaveDialog
    Left = 544
    Top = 72
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
        StyleName = 'Font Style'
        Charset = RUSSIAN_CHARSET
        FontName = 'Times New Roman'
        Size = 14
        Style = [fsUnderline]
        Unicode = True
        ModifiedProperties = [rvfiFontName, rvfiSize]
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
    Left = 720
    Top = 64
  end
  object MemTableEh1: TMemTableEh
    Params = <>
    Left = 624
    Top = 128
  end
end
