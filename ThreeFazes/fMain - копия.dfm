inherited frmMain: TfrmMain
  Caption = #1056#1086#1079#1088#1072#1093#1091#1085#1086#1082' '#1090#1088#1100#1086#1093#1092#1072#1079#1085#1080#1093' '#1082#1110#1083
  ClientHeight = 408
  ClientWidth = 822
  ExplicitWidth = 838
  ExplicitHeight = 446
  PixelsPerInch = 96
  TextHeight = 13
  inherited pcMain: TPageControl
    Width = 822
    Height = 367
    ActivePage = tsFirst
    ExplicitWidth = 822
    ExplicitHeight = 367
    inherited tsResults: TTabSheet
      ExplicitWidth = 814
      ExplicitHeight = 357
      inherited rvMain: TRichViewEdit
        Width = 814
        Height = 332
        ExplicitWidth = 814
        ExplicitHeight = 332
      end
      inherited RVRuler1: TRVRuler
        Width = 814
        LeftMargin = 0.132291666666666700
        RightMargin = 0.132291666666666700
        ExplicitWidth = 814
      end
    end
    inherited tsFirst: TTabSheet
      ExplicitLeft = 8
      ExplicitTop = 4
      ExplicitWidth = 814
      ExplicitHeight = 357
      inherited rgLanguage: TRadioGroup
        Left = 13
        Width = 364
        ExplicitLeft = 13
        ExplicitWidth = 364
      end
      object gbStar: TGroupBox
        Left = 13
        Top = 47
        Width = 388
        Height = 271
        TabOrder = 1
        object lblSR0: TLabel
          Left = 221
          Top = 120
          Width = 27
          Height = 13
          Caption = 'R0 = '
        end
        object gbSU: TGroupBox
          Left = 13
          Top = 13
          Width = 194
          Height = 136
          Caption = #1053#1072#1087#1088#1091#1075#1072
          TabOrder = 0
          object Label4: TLabel
            Left = 98
            Top = 107
            Width = 22
            Height = 13
            Caption = 'ejc='
          end
          object Label5: TLabel
            Left = 98
            Top = 81
            Width = 23
            Height = 13
            Caption = 'ejb='
          end
          object Label6: TLabel
            Left = 98
            Top = 54
            Width = 23
            Height = 13
            Caption = 'eja='
          end
          object rgSU: TRadioGroup
            Left = 5
            Top = 15
            Width = 164
            Height = 29
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              #1060#1072#1079#1085#1072
              #1051#1110#1085#1110#1081#1085#1072)
            TabOrder = 0
            OnClick = rgSUClick
          end
          object pnlSUl: TPanel
            Left = 3
            Top = 50
            Width = 79
            Height = 83
            BevelOuter = bvNone
            TabOrder = 2
            object lblUl: TLabel
              Left = 4
              Top = 28
              Width = 23
              Height = 13
              Caption = 'Ul = '
            end
            object dbnSUl: TDBNumberEditEh
              Left = 33
              Top = 24
              Width = 45
              Height = 21
              EditButtons = <>
              TabOrder = 0
              Visible = True
            end
          end
          object pnlSUf: TPanel
            Left = 3
            Top = 50
            Width = 84
            Height = 83
            BevelOuter = bvNone
            TabOrder = 1
            object Label1: TLabel
              Left = 6
              Top = 5
              Width = 21
              Height = 13
              Caption = 'Ua='
            end
            object Label2: TLabel
              Left = 6
              Top = 32
              Width = 21
              Height = 13
              Caption = 'Ub='
            end
            object Label3: TLabel
              Left = 6
              Top = 58
              Width = 20
              Height = 13
              Caption = 'Uc='
            end
            object cbSUa: TComboBox
              Left = 30
              Top = 1
              Width = 54
              Height = 22
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 2
              ParentFont = False
              TabOrder = 0
              Text = '380'
              Items.Strings = (
                '127'
                '220'
                '380')
            end
            object cbSUb: TComboBox
              Left = 30
              Top = 28
              Width = 54
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
            object cbSUc: TComboBox
              Left = 30
              Top = 54
              Width = 54
              Height = 22
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 2
              ParentFont = False
              TabOrder = 2
              Text = '380'
              Items.Strings = (
                '127'
                '220'
                '380')
            end
          end
          object cbSejc: TComboBox
            Left = 122
            Top = 103
            Width = 62
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = 4
            ParentFont = False
            TabOrder = 3
            Text = '120'
            Items.Strings = (
              '-120'
              '-30'
              '0'
              '30'
              '120')
          end
          object cbSejb: TComboBox
            Left = 122
            Top = 77
            Width = 62
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = 0
            ParentFont = False
            TabOrder = 4
            Text = '-120'
            Items.Strings = (
              '-120'
              '-30'
              '0'
              '30'
              '120')
          end
          object cbSEja: TComboBox
            Left = 122
            Top = 50
            Width = 62
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = 2
            ParentFont = False
            TabOrder = 5
            Text = '0'
            Items.Strings = (
              '-120'
              '-30'
              '0'
              '30'
              '120')
          end
        end
        object gbSW: TGroupBox
          Left = 213
          Top = 14
          Width = 151
          Height = 85
          Caption = #1063#1072#1089#1090#1086#1090#1072
          TabOrder = 1
          object dbnSF: TDBNumberEditEh
            Left = 55
            Top = 21
            Width = 72
            Height = 22
            Alignment = taCenter
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
          object cbSF: TCheckBox
            Left = 10
            Top = 23
            Width = 31
            Height = 17
            Caption = 'f'
            TabOrder = 1
            OnClick = cbSFClick
          end
          object dbnSW: TDBNumberEditEh
            Left = 55
            Top = 48
            Width = 72
            Height = 22
            Alignment = taCenter
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
          object cbSW: TCheckBox
            Left = 10
            Top = 50
            Width = 39
            Height = 17
            Caption = 'W'
            TabOrder = 3
            OnClick = cbSWClick
          end
        end
        object gbSR: TGroupBox
          Left = 13
          Top = 152
          Width = 372
          Height = 111
          Caption = #1054#1087#1086#1088#1080
          TabOrder = 2
          object Label7: TLabel
            Left = 8
            Top = 25
            Width = 21
            Height = 13
            Caption = 'Ra='
          end
          object Label8: TLabel
            Left = 8
            Top = 51
            Width = 21
            Height = 13
            Caption = 'Rb='
          end
          object Label9: TLabel
            Left = 8
            Top = 80
            Width = 20
            Height = 13
            Caption = 'Rc='
          end
          object lblSXla: TLabel
            Left = 93
            Top = 25
            Width = 22
            Height = 14
            Caption = 'Xla='
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
          end
          object lblSXCa: TLabel
            Left = 234
            Top = 25
            Width = 27
            Height = 13
            Caption = 'X'#1057'a='
          end
          object lblSXCb: TLabel
            Left = 234
            Top = 53
            Width = 27
            Height = 13
            Caption = 'X'#1057'b='
          end
          object lblSXlb: TLabel
            Left = 93
            Top = 53
            Width = 22
            Height = 13
            Caption = 'Xlb='
          end
          object lblSXCc: TLabel
            Left = 234
            Top = 79
            Width = 26
            Height = 13
            Caption = 'X'#1057'c='
          end
          object lblSXlc: TLabel
            Left = 93
            Top = 77
            Width = 21
            Height = 13
            Caption = 'Xlc='
          end
          object dbnSRa: TDBNumberEditEh
            Left = 35
            Top = 21
            Width = 52
            Height = 22
            Alignment = taCenter
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
          object dbnSRc: TDBNumberEditEh
            Left = 35
            Top = 75
            Width = 52
            Height = 22
            Alignment = taCenter
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
          object dbnSXla: TDBNumberEditEh
            Left = 120
            Top = 21
            Width = 46
            Height = 22
            Alignment = taCenter
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
          object dbnSXCa: TDBNumberEditEh
            Left = 267
            Top = 21
            Width = 45
            Height = 22
            Alignment = taCenter
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            Visible = True
          end
          object cbSLa: TDBComboBoxEh
            Left = 170
            Top = 20
            Width = 47
            Height = 21
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
            TabOrder = 5
            Visible = True
          end
          object cbSCa: TDBComboBoxEh
            Left = 318
            Top = 20
            Width = 47
            Height = 21
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
            TabOrder = 6
            Visible = True
          end
          object cbSCb: TDBComboBoxEh
            Left = 317
            Top = 48
            Width = 47
            Height = 21
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
            TabOrder = 7
            Visible = True
          end
          object dbnSXCb: TDBNumberEditEh
            Left = 267
            Top = 49
            Width = 45
            Height = 22
            Alignment = taCenter
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
            Top = 48
            Width = 47
            Height = 21
            EditButtons = <>
            Items.Strings = (
              #1043#1085
              #1084#1043#1085
              #1084#1082#1043#1085)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000')
            TabOrder = 9
            Visible = True
          end
          object dbnSXlb: TDBNumberEditEh
            Left = 120
            Top = 49
            Width = 46
            Height = 22
            Alignment = taCenter
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
          object cbSCc: TDBComboBoxEh
            Left = 317
            Top = 74
            Width = 47
            Height = 21
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
            TabOrder = 11
            Visible = True
          end
          object dbnSXCc: TDBNumberEditEh
            Left = 267
            Top = 75
            Width = 45
            Height = 22
            Alignment = taCenter
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 12
            Visible = True
          end
          object cbSlc: TDBComboBoxEh
            Left = 170
            Top = 74
            Width = 47
            Height = 21
            EditButtons = <>
            Items.Strings = (
              #1043#1085
              #1084#1043#1085
              #1084#1082#1043#1085)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000')
            TabOrder = 13
            Visible = True
          end
          object dbnSxlc: TDBNumberEditEh
            Left = 120
            Top = 75
            Width = 46
            Height = 22
            Alignment = taCenter
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 14
            Visible = True
          end
        end
        object dbnSR0: TDBNumberEditEh
          Left = 268
          Top = 116
          Width = 72
          Height = 22
          Alignment = taCenter
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Value = 0.000000000000000000
          Visible = True
        end
      end
      object chbStar: TCheckBox
        Left = 26
        Top = 39
        Width = 88
        Height = 17
        Caption = #1057#1093#1077#1084#1072' "'#1047#1110#1088#1082#1072'"'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = chbStarClick
      end
      object gbTriangle: TGroupBox
        Left = 407
        Top = 47
        Width = 388
        Height = 271
        TabOrder = 3
        object gbTu: TGroupBox
          Left = 13
          Top = 13
          Width = 194
          Height = 136
          Caption = #1053#1072#1087#1088#1091#1075#1072
          TabOrder = 0
          object Label18: TLabel
            Left = 98
            Top = 107
            Width = 22
            Height = 13
            Caption = 'ejc='
          end
          object Label19: TLabel
            Left = 98
            Top = 81
            Width = 23
            Height = 13
            Caption = 'ejb='
          end
          object Label20: TLabel
            Left = 98
            Top = 54
            Width = 23
            Height = 13
            Caption = 'eja='
          end
          object Panel1: TPanel
            Left = 3
            Top = 50
            Width = 79
            Height = 83
            BevelOuter = bvNone
            TabOrder = 1
            object Label21: TLabel
              Left = 4
              Top = 28
              Width = 23
              Height = 13
              Caption = 'Ul = '
            end
            object DBNumberEditEh3: TDBNumberEditEh
              Left = 33
              Top = 24
              Width = 45
              Height = 21
              EditButtons = <>
              TabOrder = 0
              Visible = True
            end
          end
          object Panel2: TPanel
            Left = 3
            Top = 50
            Width = 84
            Height = 83
            BevelOuter = bvNone
            TabOrder = 0
            object Label22: TLabel
              Left = 4
              Top = 5
              Width = 27
              Height = 13
              Caption = 'Uab='
            end
            object Label23: TLabel
              Left = 4
              Top = 32
              Width = 26
              Height = 13
              Caption = 'Ubc='
            end
            object Label24: TLabel
              Left = 4
              Top = 58
              Width = 26
              Height = 13
              Caption = 'Uac='
            end
            object cbTUa: TComboBox
              Left = 30
              Top = 1
              Width = 54
              Height = 22
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 2
              ParentFont = False
              TabOrder = 0
              Text = '380'
              Items.Strings = (
                '127'
                '220'
                '380')
            end
            object cbTUb: TComboBox
              Left = 30
              Top = 28
              Width = 54
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
            object cbTUc: TComboBox
              Left = 30
              Top = 54
              Width = 54
              Height = 22
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 2
              ParentFont = False
              TabOrder = 2
              Text = '380'
              Items.Strings = (
                '127'
                '220'
                '380')
            end
          end
          object cbTejc: TComboBox
            Left = 122
            Top = 103
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
            Left = 122
            Top = 77
            Width = 62
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = 2
            ParentFont = False
            TabOrder = 3
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
            Left = 122
            Top = 50
            Width = 62
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = 5
            ParentFont = False
            TabOrder = 4
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
        object gbTW: TGroupBox
          Left = 213
          Top = 14
          Width = 151
          Height = 85
          Caption = #1063#1072#1089#1090#1086#1090#1072
          TabOrder = 1
          object dbnTf: TDBNumberEditEh
            Left = 55
            Top = 21
            Width = 72
            Height = 22
            Alignment = taCenter
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
          object cbTf: TCheckBox
            Left = 10
            Top = 23
            Width = 31
            Height = 17
            Caption = 'f'
            TabOrder = 1
            OnClick = cbTfClick
          end
          object dbnTW: TDBNumberEditEh
            Left = 55
            Top = 48
            Width = 72
            Height = 22
            Alignment = taCenter
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
          object cbTw: TCheckBox
            Left = 10
            Top = 50
            Width = 39
            Height = 17
            Caption = 'W'
            TabOrder = 3
            OnClick = cbTwClick
          end
        end
        object gbTR: TGroupBox
          Left = 13
          Top = 152
          Width = 372
          Height = 111
          Caption = #1054#1087#1086#1088#1080
          TabOrder = 2
          object Label25: TLabel
            Left = 8
            Top = 25
            Width = 27
            Height = 13
            Caption = 'Rab='
          end
          object Label26: TLabel
            Left = 8
            Top = 51
            Width = 26
            Height = 13
            Caption = 'Rbc='
          end
          object Label27: TLabel
            Left = 8
            Top = 80
            Width = 26
            Height = 13
            Caption = 'Rac='
          end
          object lblTXLa: TLabel
            Left = 93
            Top = 25
            Width = 22
            Height = 13
            Caption = 'Xla='
          end
          object lblTXCa: TLabel
            Left = 234
            Top = 25
            Width = 27
            Height = 13
            Caption = 'X'#1057'a='
          end
          object lblTXCb: TLabel
            Left = 234
            Top = 53
            Width = 27
            Height = 13
            Caption = 'X'#1057'b='
          end
          object lblTXLb: TLabel
            Left = 93
            Top = 53
            Width = 22
            Height = 13
            Caption = 'Xlb='
          end
          object lblTXCc: TLabel
            Left = 234
            Top = 79
            Width = 26
            Height = 13
            Caption = 'X'#1057'c='
          end
          object lblTXLc: TLabel
            Left = 93
            Top = 79
            Width = 21
            Height = 13
            Caption = 'Xlc='
          end
          object dbnTRa: TDBNumberEditEh
            Left = 35
            Top = 21
            Width = 52
            Height = 22
            Alignment = taCenter
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
          object dbnTRc: TDBNumberEditEh
            Left = 35
            Top = 76
            Width = 52
            Height = 22
            Alignment = taCenter
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
          object dbnTXla: TDBNumberEditEh
            Left = 120
            Top = 21
            Width = 46
            Height = 22
            Alignment = taCenter
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
          object dbnTXCa: TDBNumberEditEh
            Left = 267
            Top = 21
            Width = 45
            Height = 22
            Alignment = taCenter
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            Visible = True
          end
          object cbTLa: TDBComboBoxEh
            Left = 170
            Top = 21
            Width = 47
            Height = 21
            EditButtons = <>
            Items.Strings = (
              #1043#1085
              #1084#1043#1085
              #1084#1082#1043#1085)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000')
            TabOrder = 5
            Visible = True
          end
          object cbTCa: TDBComboBoxEh
            Left = 318
            Top = 21
            Width = 47
            Height = 21
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
            TabOrder = 6
            Visible = True
          end
          object cbTCb: TDBComboBoxEh
            Left = 317
            Top = 49
            Width = 47
            Height = 21
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
            TabOrder = 7
            Visible = True
          end
          object dbnTXCb: TDBNumberEditEh
            Left = 267
            Top = 49
            Width = 45
            Height = 22
            Alignment = taCenter
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
            Left = 170
            Top = 49
            Width = 47
            Height = 21
            EditButtons = <>
            Items.Strings = (
              #1043#1085
              #1084#1043#1085
              #1084#1082#1043#1085)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000')
            TabOrder = 9
            Visible = True
          end
          object dbnTXlb: TDBNumberEditEh
            Left = 120
            Top = 49
            Width = 46
            Height = 22
            Alignment = taCenter
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
          object cbTCc: TDBComboBoxEh
            Left = 317
            Top = 75
            Width = 47
            Height = 21
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
            TabOrder = 11
            Visible = True
          end
          object dbnTXcc: TDBNumberEditEh
            Left = 267
            Top = 75
            Width = 45
            Height = 22
            Alignment = taCenter
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 12
            Visible = True
          end
          object cbTLc: TDBComboBoxEh
            Left = 170
            Top = 75
            Width = 47
            Height = 21
            EditButtons = <>
            Items.Strings = (
              #1043#1085
              #1084#1043#1085
              #1084#1082#1043#1085)
            KeyItems.Strings = (
              '1'
              '1000'
              '1000000')
            TabOrder = 13
            Visible = True
          end
          object dbnTXlc: TDBNumberEditEh
            Left = 120
            Top = 75
            Width = 46
            Height = 22
            Alignment = taCenter
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 14
            Visible = True
          end
        end
      end
      object chbTriangle: TCheckBox
        Left = 424
        Top = 40
        Width = 117
        Height = 17
        Caption = #1057#1093#1077#1084#1072' "'#1058#1088#1080#1082#1091#1090#1085#1080#1082'"'
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = chbTriangleClick
      end
    end
    inherited tsHidden: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 6
      ExplicitWidth = 814
      ExplicitHeight = 357
    end
  end
  inherited pnlFooter: TPanel
    Top = 367
    Width = 822
    ExplicitTop = 367
    ExplicitWidth = 822
    inherited btnCalc: TButton
      Left = 640
      ExplicitLeft = 640
    end
    inherited btnCancel: TButton
      Left = 740
      ExplicitLeft = 740
    end
    inherited btnSaveToFile: TButton
      Left = 530
      ExplicitLeft = 530
    end
    inherited btnPrev: TButton
      Left = 640
      ExplicitLeft = 640
    end
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
    Left = 480
    Top = 152
  end
end
