object frmEditRounding: TfrmEditRounding
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1085#1085#1103' '#1090#1086#1095#1085#1086#1089#1090#1110
  ClientHeight = 337
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 280
    Width = 527
    Height = 57
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnSave: TButton
      Left = 384
      Top = 16
      Width = 131
      Height = 25
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080
      ModalResult = 1
      TabOrder = 0
    end
  end
  object dbgrdhMain: TDBGridEh
    Left = 0
    Top = 0
    Width = 527
    Height = 280
    Align = alClient
    AllowedOperations = [alopUpdateEh]
    AutoFitColWidths = True
    DataGrouping.GroupLevels = <>
    DataSource = dsMain
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    IndicatorOptions = [gioShowRowIndicatorEh]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object dsMain: TDataSource
    Left = 160
    Top = 176
  end
end
