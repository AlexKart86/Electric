unit fMain;

interface

{ TODO : Эту форму следует отнаследовать от frmMainTemplate }

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Grids, RVStyle, RVScroll, RichView, uCalc, RVEdit,
  uConsts, uElements, Ruler, RVRuler, VCLTee.TeEngine, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.Series, VCLTee.TeeSpline, Vcl.Mask, DBCtrlsEh;

type
  TfrmMain = class(TForm)
    pcMain: TPageControl;
    tsFirst: TTabSheet;
    tsResults: TTabSheet;
    rgElemtTypes: TRadioGroup;
    Label1: TLabel;
    cbNodeCount: TComboBox;
    gbOtherParams: TGroupBox;
    edtW0: TEdit;
    cbAddParameter: TComboBox;
    pnlFooter: TPanel;
    btnCalc: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    sgElements: TStringGrid;
    cbNodes: TComboBox;
    lblNode: TLabel;
    rgLanguage: TRadioGroup;
    rgUType: TRadioGroup;
    edtAddParamValue: TEdit;
    gbAddParameter: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    btnSaveToFile: TButton;
    btnPrev: TButton;
    dlgSave: TSaveDialog;
    RVStyle1: TRVStyle;
    rvMain: TRichViewEdit;
    RVRuler1: TRVRuler;
    tsHidden: TTabSheet;
    crtU: TChart;
    serU: TLineSeries;
    serI: TLineSeries;
    grpTime: TGroupBox;
    edtT0: TLabeledEdit;
    crtI: TChart;
    LineSeries1: TLineSeries;
    LineSeries2: TLineSeries;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    TeeFunction1: TSmoothingFunction;
    grpW: TGroupBox;
    rgF: TRadioGroup;
    edtF: TEdit;
    grpW0: TGroupBox;
    edtT: TDBNumberEditEh;
    Label4: TLabel;
    btnEditDiagram: TButton;
    procedure chbFClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chbW0Click(Sender: TObject);
    procedure cbNodeCountChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbAddParameterChange(Sender: TObject);
    procedure rgElemtTypesClick(Sender: TObject);
    procedure btnCalcClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure rgLanguageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgFClick(Sender: TObject);
    procedure edtTEditButtons0Click(Sender: TObject; var Handled: Boolean);
  private
    procedure RefreshToolbar;
    procedure RecalcAddParameters;
    procedure RefreshBtnsVisible;
    procedure RefreshLanguage;
    // ініціалізація
    procedure InitDefaultValues;
    // Оновлює доступність комбобоксу з номером гілки для додаткового
    // параметру
    procedure RefreshAddNodesVisible;
    function GetNodesCount: Integer;
    function GetCalcType: TCalcType;
    function GetFreqType: TFreqType;
    function GetAddParamType: TAddParamType;
    function GetUChangeRule: TUChangeRule;
  protected
    function CheckInputParams: Boolean;
  public
    property NodesCount: Integer read GetNodesCount;
    property CalcType: TCalcType read GetCalcType;
    property FreqType: TFreqType read GetFreqType;
    property UChangeRule: TUChangeRule read GetUChangeRule;
    property AddParamType: TAddParamType read GetAddParamType;
  end;

var
  frmMain: TfrmMain;

implementation

uses uLocalizeShared, uFormulaUtils, uConstsShared, Math;

{$R *.dfm}
{ TfrmMain }

procedure TfrmMain.btnCalcClick(Sender: TObject);
var
  vSchemaInfo: TSchemaInfo;
  vElementList: TRLCList;
  vSolver: TSolver;
  i: Integer;
  vC: Double;
begin
  // Проверяем корректность введенных параметров
  if not CheckInputParams then
    Exit;
  vSchemaInfo.CalcType := CalcType;
  vSchemaInfo.FreqType := FreqType;
  vSchemaInfo.ChangeRule := UChangeRule;
  vSchemaInfo.AddParamType := AddParamType;
  if AddParamType in TNeedNodeParamSet then
    vSchemaInfo.AddParamNodeNum := StrToInt(cbNodes.Text)
  else
    vSchemaInfo.AddParamNodeNum := cnstNotSetValue;
  vSchemaInfo.AddParamValue := StrToFloat(edtAddParamValue.Text);
  if vSchemaInfo.CalcType = ctRLC then
  begin
    // Устанавливаем частоту / циклическую частоту
    if rgF.ItemIndex = 0 then
    begin
      vSchemaInfo.W := StrToFloat(edtF.Text);
      vSchemaInfo.F := cnstNotSetValue;
    end;
    if rgF.ItemIndex = 1 then
    begin
      vSchemaInfo.W := cnstNotSetValue;
      vSchemaInfo.F := StrToFloat(edtF.Text)
    end;
  end;

  vSchemaInfo.W0 := StrToFloatDef(edtW0.Text, 0);
  vSchemaInfo.t0 := StrToFloatDef(edtT0.Text, 0);
  vSchemaInfo.t := edtT.Value; // StrToFloat(edtT.Text);
  vElementList := TRLCList.Create(vSchemaInfo);
  try
    for i := 1 to NodesCount do
    begin
      vC := StrToFloatDef(sgElements.Cells[3, i], cnstNotSetValue);
      // В случае когда вводят емкость, ее вводят в микрофарадах, поэтому результат делим на 10^6;
      if (vSchemaInfo.CalcType = ctRLC) and (vC <> cnstNotSetValue) then
      begin
        vC := vC / 1000000;
      end;

      vElementList.Add(StrToFloatDef(sgElements.Cells[1, i], cnstNotSetValue),
        StrToFloatDef(sgElements.Cells[2, i], cnstNotSetValue), vC);
    end;

    vSolver := TSolver.Create(vElementList, rvMain, serU, serI, crtU, crtI);
    vSolver.RunSolve;
    pcMain.ActivePage := tsResults;
    RefreshBtnsVisible;
  finally
    FreeAndNil(vElementList);
    FreeAndNil(vSolver);
  end;
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnPrevClick(Sender: TObject);
begin
  pcMain.ActivePage := tsFirst;
  RefreshBtnsVisible;
end;

procedure TfrmMain.btnSaveToFileClick(Sender: TObject);
begin
  if dlgSave.Execute then
    rvMain.SaveRTF(dlgSave.FileName, False);
end;

procedure TfrmMain.cbAddParameterChange(Sender: TObject);
begin
  RefreshAddNodesVisible;
end;

procedure TfrmMain.cbNodeCountChange(Sender: TObject);
begin
  RecalcAddParameters;
end;

procedure TfrmMain.chbFClick(Sender: TObject);
begin
  RefreshToolbar;
  if edtF.CanFocus then
    edtF.SetFocus;
end;

procedure TfrmMain.chbW0Click(Sender: TObject);
begin
  RefreshToolbar;
  if edtW0.CanFocus then
    edtW0.SetFocus;
end;

function TfrmMain.CheckInputParams: Boolean;
begin
  // TO Do
  Result := True;
end;

procedure TfrmMain.edtTEditButtons0Click(Sender: TObject; var Handled: Boolean);
begin
  case GetFreqType of
    frtF:
      edtT.Value := RoundTo(3 / StrToFloatDef(edtF.Text, 0), -3);
    frtW:
      edtT.Value := RoundTo(6 * pi / StrToFloatDef(edtF.Text, 0), -3);
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator := '.';
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  pcMain.ActivePage := tsFirst;
  RefreshBtnsVisible;
  InitDefaultValues;
  RefreshToolbar;
  RecalcAddParameters;
  RefreshAddNodesVisible;
  RefreshLanguage;
end;

function TfrmMain.GetAddParamType: TAddParamType;
begin
  if cbAddParameter.ItemIndex > -1 then
    Result := TAddParamType(cbAddParameter.ItemIndex);
end;

function TfrmMain.GetCalcType: TCalcType;
begin
  if rgElemtTypes.ItemIndex = 0 then
    Result := ctRXX;
  if rgElemtTypes.ItemIndex = 1 then
    Result := ctRLC;
end;

function TfrmMain.GetFreqType: TFreqType;
begin
  case rgF.ItemIndex of
    0:
      Result := frtW;
    1:
      Result := frtF;
  else
    Result := frtNone;
  end;
end;

function TfrmMain.GetNodesCount: Integer;
begin
  if cbNodeCount.ItemIndex = -1 then
    Result := -1
  else
    Result := StrToInt(cbNodeCount.Text);
end;

function TfrmMain.GetUChangeRule: TUChangeRule;
begin
  if rgUType.ItemIndex = 0 then
    Result := uSin;
  if rgUType.ItemIndex = 1 then
    Result := uCos;
end;

procedure TfrmMain.InitDefaultValues;
var
  i: String;
begin
  cbAddParameter.Clear;
  for i in TAppParamNames do
    cbAddParameter.Items.Add(i);
  if cbAddParameter.Items.Count > 0 then
    cbAddParameter.ItemIndex := 0;
end;

procedure TfrmMain.pcMainChange(Sender: TObject);
begin
  RefreshBtnsVisible;
end;

procedure TfrmMain.RecalcAddParameters;
var
  i: Integer;
begin
  // Вычисление кол-ва элементов в таблице
  if NodesCount < 0 then
    Exit;
  sgElements.RowCount := NodesCount + 1;
  for i := 1 to NodesCount do
    sgElements.Cells[0, i] := 'Гілка ' + Chr(ord('A') + 2 * (i - 1)) +
      Chr(ord('A') + 2 * i - 1);
  case CalcType of
    ctRLC:
      begin
        sgElements.Cells[1, 0] := 'R (ом)';
        sgElements.Cells[2, 0] := 'L (Гн)';
        sgElements.Cells[3, 0] := 'C (мкФ)';
      end;
    ctRXX:
      begin
        sgElements.Cells[1, 0] := 'R (ом)';
        sgElements.Cells[2, 0] := 'Xl (ом)';
        sgElements.Cells[3, 0] := 'Xc (ом)';
      end;
  end;
  // Обновляем количество веток в комбобоксе номера ветки
  cbNodes.Clear;
  for i := 1 to NodesCount do
    cbNodes.Items.Add(IntToStr(i));
  grpW.Visible := CalcType = ctRLC;
  grpW0.Visible := CalcType = ctRLC;
  grpTime.Visible := CalcType = ctRLC;
  rgUType.Visible := CalcType = ctRLC;
end;

procedure TfrmMain.RefreshAddNodesVisible;
begin
  lblNode.Visible := AddParamType in TNeedNodeParamSet;
  cbNodes.Visible := AddParamType in TNeedNodeParamSet;
end;

procedure TfrmMain.RefreshBtnsVisible;
begin
  btnSaveToFile.Visible := pcMain.ActivePage = tsResults;
  btnCalc.Visible := pcMain.ActivePage = tsFirst;
  btnPrev.Visible := pcMain.ActivePage = tsResults;
end;

procedure TfrmMain.RefreshLanguage;
begin
  if rgLanguage.ItemIndex = 0 then
    CurrentLang := lngUkr;
  if rgLanguage.ItemIndex = 1 then
    CurrentLang := lngRus;
end;

procedure TfrmMain.RefreshToolbar;
begin

end;

procedure TfrmMain.rgElemtTypesClick(Sender: TObject);
begin
  RecalcAddParameters;
end;

procedure TfrmMain.rgFClick(Sender: TObject);
begin
  if edtF.CanFocus then
    edtF.SetFocus;
end;

procedure TfrmMain.rgLanguageClick(Sender: TObject);
begin
  RefreshLanguage;
end;

end.
