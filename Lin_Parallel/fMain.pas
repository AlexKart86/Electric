unit fMain;

interface

{ TODO : Эту форму следует отнаследовать от frmMainTemplate }

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Grids, RVStyle, RVScroll, RichView, uCalc, RVEdit,
  uConsts, uElements, Ruler, RVRuler, VCLTee.TeEngine, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.Series, VCLTee.TeeSpline, Vcl.Mask, DBCtrlsEh,
  Vcl.ImgList;

type
  TfrmMain = class(TForm)
    pcMain: TPageControl;
    tsFirst: TTabSheet;
    tsResults: TTabSheet;
    rgElemtTypes: TRadioGroup;
    Label1: TLabel;
    cbNodeCount: TComboBox;
    gbOtherParams: TGroupBox;
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
    btn1: TButton;
    ilAddParam: TImageList;
    lbl1: TLabel;
    cbAddParamElement: TComboBox;
    edtW0: TEdit;
    lblW0: TLabel;
    imgAddParam: TImage;
    btnEditDiagram: TButton;
    cbbL: TDBComboBoxEh;
    cbbC: TDBComboBoxEh;
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
    procedure btn1Click(Sender: TObject);
    procedure cbNodesChange(Sender: TObject);
    procedure edtAddParamValueChange(Sender: TObject);
    procedure edtW0Change(Sender: TObject);
    procedure btnEditDiagramClick(Sender: TObject);
    procedure sgElementsMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sgElementsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    vElementList: TRLCList;
    vSolver: TSolver;
    FAddParamCalculating: Boolean;
    FAddParam: TAddParam;
    procedure RefreshToolbar;
    procedure RecalcAddParameters;
    procedure RefreshBtnsVisible;
    procedure RefreshLanguage;
    // ініціалізація
    procedure InitDefaultValues;
    function GetNodesCount: Integer;
    function GetCalcType: TCalcType;
    function GetFreqType: TFreqType;
    function GetUChangeRule: TUChangeRule;
    procedure InitRounds;
  protected
    function CheckInputParams: Boolean;
    procedure RefreshCalcType;
    procedure RefreshNodesCount;
  public
    property NodesCount: Integer read GetNodesCount;
    property CalcType: TCalcType read GetCalcType;
    property FreqType: TFreqType read GetFreqType;
    property UChangeRule: TUChangeRule read GetUChangeRule;
    procedure RefreshLCKoeff;
  end;

var
  frmMain: TfrmMain;

implementation

uses uLocalizeShared, uFormulaUtils, uConstsShared, Math, uRounding, fEditRounding, fEditDiagram;

{$R *.dfm}
{ TfrmMain }

procedure TfrmMain.btn1Click(Sender: TObject);
begin
  EditRounding;
end;

procedure TfrmMain.btnCalcClick(Sender: TObject);
var
  vSchemaInfo: TSchemaInfo;

  i: Integer;
  vC: Double;
  vL: Double;
begin
  // Проверяем корректность введенных параметров
  if not CheckInputParams then
    Exit;
  vSchemaInfo.CalcType := CalcType;
  vSchemaInfo.FreqType := FreqType;
  vSchemaInfo.ChangeRule := UChangeRule;

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
  end
  else
  begin
    vSchemaInfo.F := cnstNotSetValue;
    vSchemaInfo.W := cnstNotSetValue;
  end;

  vSchemaInfo.W0 := StrToFloatDef(edtW0.Text, 0);
  vElementList := TRLCList.Create(vSchemaInfo);
  vElementList.AddParam := FAddParam;
  try
    for i := 1 to NodesCount do
    begin
      vC := StrToFloatDef(sgElements.Cells[3, i], cnstNotSetValue);
      vL := StrToFloatDef(sgElements.Cells[2, i], cnstNotSetValue);
      // В случае когда вводят емкость, учитываем выбранный масштабный коэффциент
      if (vSchemaInfo.CalcType = ctRLC) then
      begin
        if vC <> cnstNotSetValue then
          vC := vC * cbbC.Value;
        if vL <> cnstNotSetValue then
          vL := vL * cbbL.Value;
      end;

      vElementList.Add(StrToFloatDef(sgElements.Cells[1, i], cnstNotSetValue),
        vL, vC);
    end;

    rvMain.Clear;
    if Assigned(vSolver) then
      FreeAndNil(vSolver);
    vSolver := TSolver.Create(vElementList, rvMain, serU, serI, crtU, crtI);
    vSolver.IsScaleInit := False;
    fCoordsCache.EmptyTable;
    vSolver.RunSolve;
    pcMain.ActivePage := tsResults;
    RefreshBtnsVisible;
  finally
    //FreeAndNil(vElementList);
    //FreeAndNil(vSolver);
  end;
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnEditDiagramClick(Sender: TObject);
begin
  EditDiagramExecute(vSolver);
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
  RecalcAddParameters;
end;

procedure TfrmMain.cbNodeCountChange(Sender: TObject);
begin
  RecalcAddParameters;
  RefreshNodesCount;
end;

procedure TfrmMain.cbNodesChange(Sender: TObject);
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
  Result := FAddParam.IsDataCorrect;
  if not Result then
  begin
    MessageDlg('Некоректно визначений додатковий параметр', mtError, [mbOK], 0);
  end;
end;

procedure TfrmMain.edtAddParamValueChange(Sender: TObject);
begin
  RecalcAddParameters;
end;

procedure TfrmMain.edtW0Change(Sender: TObject);
begin
  RecalcAddParameters;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  vSolver := nil;
  imgAddParam.Picture.Bitmap := TBitmap.Create;
  FAddParamCalculating := False;
  FormatSettings.DecimalSeparator := '.';
  RefreshCalcType;
  RefreshNodesCount;
  RefreshCalcType;
  InitRounds;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  pcMain.ActivePage := tsFirst;
  RefreshBtnsVisible;
  InitDefaultValues;
  RefreshToolbar;
  RecalcAddParameters;
  RefreshLanguage;
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
  for i in TAddParamNames do
    cbAddParameter.Items.Add(i);
  if cbAddParameter.Items.Count > 0 then
    cbAddParameter.ItemIndex := 0;

 for i in TAddParamElementNames do
    cbAddParamElement.Items.Add(i);
  if cbAddParamElement.Items.Count > 0 then
    cbAddParamElement.ItemIndex := 0;
end;

procedure TfrmMain.InitRounds;
begin
   RndArr.AddType('Напруга', cU);
  RndArr.AddType('Сила струму', cI);
  RndArr.AddType('Опір', cR);
  RndArr.AddType('Кут', cPhi, 1);
  RndArr.AddType('Потужність', cP);
  RndArr.AddType('Частота', cW);
  RndArr.AddType('Ємність', cC, 6);
  RndArr.AddType('Індуктивність', cL, 3);
end;

procedure TfrmMain.pcMainChange(Sender: TObject);
begin
  RefreshBtnsVisible;
end;

procedure TfrmMain.RecalcAddParameters;
var
  i: Integer;
  vBitmap: TBitmap;
begin
  if FAddParamCalculating then
   Exit;
  FAddParamCalculating := True;
  try
    if cbAddParameter.ItemIndex >= 0 then
    begin
      FAddParam.AddParamType := TAddParamType(cbAddParameter.ItemIndex);
      if cbNodes.ItemIndex >= 0 then
        FAddParam.NodeNo := cbNodes.ItemIndex-1
      else
        FAddParam.NodeNo := cnstNotSetValue;
      FAddParam.W0 := StrToFloatDef(edtW0.Text, 0);
      FAddParam.Value := StrToFloatDef(edtAddParamValue.Text, cnstNotSetValue);
      if cbAddParameter.ItemIndex >= 0 then
        FAddParam.AddParamElement := TAddParamElement(cbAddParamElement.ItemIndex)
      else
        FAddParam.AddParamElement := apeNone;

      if not FAddParam.IsAllowNodeNo then
      begin
        FAddParam.NodeNo := cnstNotSetValue;
        cbNodes.Visible := False;
        lblNode.Visible := False;
      end
      else
      begin
        cbNodes.Visible := True;
        lblNode.Visible := True;
      end;

      if not FAddParam.IsAllowW0 then
      begin
        FAddParam.W0 := cnstNotSetValue;
        lblW0.Visible := False;
        edtW0.Visible := False;
      end
      else
      begin
        lblW0.Visible := True;
        edtW0.Visible := True;
      end;

      vBitmap := TBitmap.Create;
      vBitmap.Width := 100;
      vBitmap.Height := 40;
      if not FAddParam.IsDataCorrect then
      begin
        vBitmap.Canvas.Font.Size := 12;
        vBitmap.Canvas.Font.Color := clRed;
        vBitmap.Canvas.TextOut(3,3,'Помилка');
      end
      else
      begin
        InsertFormulaIntoPicture(vBitmap, 3,3, FAddParam.GetElementFormula);
      end;
      imgAddParam.Picture.Assign(vBitmap);
      vBitmap.Free;

    end;
  finally
    FAddParamCalculating := False;
  end;
end;

procedure TfrmMain.RefreshBtnsVisible;
begin
  btnSaveToFile.Visible := pcMain.ActivePage = tsResults;
  btnCalc.Visible := pcMain.ActivePage = tsFirst;
  btnPrev.Visible := pcMain.ActivePage = tsResults;
  btnEditDiagram.Visible := pcMain.ActivePage = tsResults;
end;

procedure TfrmMain.RefreshCalcType;
begin
  grpW.Visible := CalcType = ctRLC;
  rgUType.Visible := CalcType = ctRLC;
  case CalcType of
      ctRLC:
        begin
          sgElements.Cells[1, 0] := 'R (ом)';
          sgElements.Cells[2, 0] := 'L ';
          sgElements.Cells[3, 0] := 'C ';
        end;
      ctRXX:
        begin
          sgElements.Cells[1, 0] := 'R (ом)';
          sgElements.Cells[2, 0] := 'Xl (ом)';
          sgElements.Cells[3, 0] := 'Xc (ом)';
        end;
    end;
  RefreshLCKoeff;
end;

procedure TfrmMain.RefreshLanguage;
begin
  if rgLanguage.ItemIndex = 0 then
    CurrentLang := lngUkr;
  if rgLanguage.ItemIndex = 1 then
    CurrentLang := lngRus;
end;

procedure TfrmMain.RefreshLCKoeff;
var
  vIsVisible: Boolean;
begin
  vIsVisible := CalcType = ctRLC;
  cbbL.Visible := vIsVisible;
  cbbC.Visible := vIsVisible;
  if vIsVisible  then
  begin
    cbbL.Top := sgElements.Top + 5;
    cbbC.Top := sgElements.Top + 5;
    cbbL.Left := sgElements.ColWidths[0]+sgElements.ColWidths[1]+25;
    cbbC.Left := sgElements.ColWidths[0]+sgElements.ColWidths[1]+sgElements.ColWidths[2]+25;
  end;
end;

procedure TfrmMain.RefreshNodesCount;
var i: Integer;
begin
   // Вычисление кол-ва элементов в таблице
    if NodesCount < 0 then
      Exit;
    sgElements.RowCount := NodesCount + 1;
    for i := 1 to NodesCount do
      sgElements.Cells[0, i] := 'Гілка #'+ IntToStr(i);
    // Обновляем количество веток в комбобоксе номера ветки
    cbNodes.Clear;
    cbNodes.Items.Add('');
    for i := 1 to NodesCount do
      cbNodes.Items.Add(IntToStr(i));
end;

procedure TfrmMain.RefreshToolbar;
begin

end;

procedure TfrmMain.rgElemtTypesClick(Sender: TObject);
begin
  RecalcAddParameters;
  RefreshCalcType;

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

procedure TfrmMain.sgElementsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 RefreshLCKoeff;
end;

procedure TfrmMain.sgElementsMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  RefreshLCKoeff;
end;

end.
