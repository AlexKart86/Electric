object ObjInspectForm: TObjInspectForm
  Left = 555
  Top = 182
  BorderStyle = bsNone
  Caption = 'Object Inspector'
  ClientHeight = 639
  ClientWidth = 260
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 15
  object vle: TValueListEditor
    Left = 0
    Top = 0
    Width = 260
    Height = 632
    Align = alClient
    Color = clBtnFace
    DefaultColWidth = 120
    DefaultRowHeight = 19
    DisplayOptions = [doAutoColResize, doKeyColFixed]
    FixedCols = 1
    TabOrder = 0
    OnDrawCell = vleDrawCell
    OnEditButtonClick = vleEditButtonClick
    OnKeyPress = vleKeyPress
    OnSetEditText = vleSetEditText
    OnValidate = vleValidate
    ColWidths = (
      120
      134)
    RowHeights = (
      20)
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 632
    Width = 260
    Height = 7
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 24
    Top = 80
  end
  object ColorDialog1: TColorDialog
    Left = 24
    Top = 112
  end
end
