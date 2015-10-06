unit uCalc;

interface
uses dataMain, RVEdit, Graphics, RegularExpressions, RVTable, ParseExpr;

type
  TSolver = class
  private
    Fs: Double;
    FMParse: TExpressionParser;
    FN1Parse: TExpressionParser;
    FN2Parse: TExpressionParser;
    FStage: Integer;
    FTaskTable: TRVTableItemInfo;
    FRichView: TRichViewEdit;
    fDmMain: TdmMain;
    function M(S: Double): Double;
    function N1(S: Double): Double;
    function  N2(S:double): Double;
    procedure PrintTask;
    procedure ParseFormulaAndText(AStr: String; AIsUseNumerator: Boolean = True);
    function Evaluator(const Match: TMatch): string;
    procedure OnCalcCallBack(AStrUkr, AStrRus: String);
    procedure PrintCloss;
  public
    constructor Create(ARichView: TRichViewEdit; AdmMain: TdmMain);
    destructor Destroy; override;
    procedure RunSolve;
  end;

implementation
uses  uFormulaUtils, SysUtils, uRounding, uLocalizeShared;

{ TSolver }

constructor TSolver.Create(ARichView: TRichViewEdit; AdmMain: TdmMain);
begin
  FRichView := ARichView;
  fDmMain := AdmMain;
  FMParse := TExpressionParser.Create;
  FMParse.DefineVariable('s', @Fs);
  FN1Parse := TExpressionParser.Create;
  FN1Parse.DefineVariable('s', @Fs);
  FN2Parse := TExpressionParser.Create;
  FN2Parse.DefineVariable('s', @Fs);
end;

destructor TSolver.Destroy;
begin
  FreeAndNil(FMParse);
  FreeAndNil(FN1Parse);
  FreeAndNil(FN2Parse);
  inherited;
end;

function TSolver.Evaluator(const Match: TMatch): string;
var
  vItemName: String;
  vStr: String;
  vKoeff: Double;
  i: Integer;
begin
  Assert(Match.Groups.Count >=2, 'Щось не так пішло в процесі заміни зразка '+Match.Value);
  vItemName := Match.Groups.Item[2].Value;

  vKoeff := 1;
  vStr := '';
  //Возможно, вначале есть коэффициент, на который следует умножать
  for i := 1 to Length(vItemName) do
  begin
    if not (vitemName[i] in ['0'..'9','.']) then
      break;
     vStr := vStr + vItemName[i];
  end;
  if vStr <> '' then
  begin
    vItemName := Copy(vItemName, Length(vStr)+1, Length(vItemName)-Length(vStr));
    vKoeff :=  StrToFloat(vStr);
  end;

  {Assert(dmMain.memItems.Locate('NAME', vItemName, []), 'Змінної '+vItemName+' не має в переліку змінних');
  Result := RndArr.FormatDoubleStr(fDmMain.memItemsRESULT_VALUE.Value*vKoeff);}
  Result := RndArr.FormatDoubleStr(dmMain.GetItemValue(vItemName)*vKoeff);
end;

function TSolver.M(S: Double): Double;
begin

end;

function TSolver.N1(S: Double): Double;
begin

end;

function TSolver.N2(S: double): Double;
begin

end;

procedure TSolver.OnCalcCallBack(AStrUkr, AStrRus: String);
begin
  case CurrentLang of
    lngUkr: ParseFormulaAndText(AStrUkr);
    lngRus: ParseFormulaAndText(AStrRus);
  end;
end;

procedure TSolver.ParseFormulaAndText(AStr: String; AIsUseNumerator: Boolean = True);
const
  stages_tbl = 3;
var
  vText: TArray<string>;
  vFormulas: TArray<String>;
  i: integer;
  vParaNo: Integer;


  procedure BindFormulas;
  var
    i: Integer;
  begin
    for i := Low(vFormulas) to High(vFormulas) do
      vFormulas[i] := TRegEx.Replace(vFormulas[i], '(\[)(.+?)(\])', Evaluator);
  end;


  procedure AddText(AText:  String);
  begin
    if FStage <= stages_tbl then
        FTaskTable.Cells[0,1].AddTextNL(AText, 0, -1, 0)
    else
      FRichView.InsertTextW(AText);
  end;

begin
  if AStr = '' then
    Exit;
  ParseText(AStr, vText, vFormulas);
  BindFormulas;

  if AIsUseNumerator then
  begin
    Inc(FStage);
    AddText(IntToStr(FStage)+') ');
  end;

  for i := Low(vText) to High(vText) do
  begin
    AddText(vText[i]);

   if i<=High(vFormulas) then
    begin
      if FStage <= stages_tbl then
        RVAddFormulaTex(vFormulas[i], FTaskTable.Cells[0,1])
      else
        RVAddFormulaTex(vFormulas[i], FRichView);
    end;
  end;
  //Отступы
  if AIsUseNumerator then
  begin
    AddText(#13#10);
    AddText(#13#10);
  end;
end;

procedure TSolver.PrintCloss;
begin
  if not dmMain.IsItemCalced('Mmax') or
     not dmMain.IsItemCalced('skr') then
   Exit;
  ParseFormulaAndText(lc('Fs'), False);
  ParseFormulaAndText('Формулу Клосса: {tex}M=\frac{2M_{\cyr{maks}}}{\frac{S}{s_{\cyr{kr}}}+\frac{s_{\cyr{kr}}}{S}}=\frac{2 \cdot [Mmax]}{\frac{S}{[skr]}+\frac{[skr]}{S}} {\tex}',
                      False);
end;

procedure TSolver.PrintTask;
var
  i: Integer;
const
  cnstFormulaPatt = '%s = %s \quad \cyr{%s}';

  procedure AddText(AText: String; IsCR: Boolean = false);
  var
    vParaNo: Integer;
  begin
    if IsCR then
      vParaNo := 0
    else
      vParaNo := -1;
    FTaskTable.Cells[0, 0].AddTextNL(AText, 0, vParaNo, 0);
  end;

begin
    // Создаем табличку для вывода условия
  FTaskTable := TRVTableItemInfo.CreateEx(1, 2, FRichView.RVData);

  FTaskTable.Options :=  FTaskTable.Options + [rvtoIgnoreContentWidth];
  FTaskTable.Cells[0,0].BestWidth := 170;
  FTaskTable.Cells[0,1].BestWidth := 490;

  FRichView.InsertItem('table1', FTaskTable);
  // Граница не видна
  FTaskTable.VisibleBorders.SetAll(false);
  // Видна вертикальная черта
  FTaskTable.VRuleColor := clBlack;
  FTaskTable.VRuleWidth := 1;


  // Заполняем то, что дано.
  FTaskTable.Cells[0, 0].Clear;
  FTaskTable.Cells[0, 0].AddTextNL('Дано:', 0, -1, 0);

  fDmMain.memItems.First;
  while not fDmMain.memItems.Eof do
  begin
    if fDmMain.memItemsVALUE_CORRECT.AsString <> '' then
    begin
      FTaskTable.Cells[0,0].AddTextNL(#13#10, 0, -1, 0);
      RVAddFormulaTex(Format(cnstFormulaPatt, [fDmMain.memItemsF_TEX.Value,
         RndArr.FormatDoubleStr(fDmMain.memItemsVALUE.Value),
         fDmMain.GetMeasureName(fDmMain.memItemsMEASURE_ID.Value)]), FTaskTable.Cells[0,0]);
    end;
    fDmMain.memItems.Next;
  end;

  FTaskTable.Cells[0, 0].AddBreak;
  AddText(lc('Task')+#13#10);

  fDmMain.memItems.First;
  i := 1;
  while not fDmMain.memItems.Eof do
  begin
    if fDmMain.memItemsVALUE.AsString = '' then
    begin
      RVAddFormulaTex(fDmMain.memItemsF_TEX.Value, FTaskTable.Cells[0,0]);
      if i mod 2 = 0 then
        FTaskTable.Cells[0,0].AddTextNL(#13#10, 0, -1, 0)
      else
        FTaskTable.Cells[0,0].AddNL(',', 0, -1);
      Inc(i);
    end;
    fDmMain.memItems.Next;
  end;

  //FTaskTable.ResizeCol(0, 600, True);
  //FTaskTable.ResizeCol(1, 620, True);
end;

procedure TSolver.RunSolve;
begin
  dmMain.memItems.DisableControls;
  try
    FRichView.Clear;
    FStage := 0;
    PrintTask;

    dmMain.ClearCalc;
    dmMain.Calc(OnCalcCallBack);

    PrintCloss;

    FTaskTable.ResizeRow(0, FTaskTable.Rows[0].GetBestHeight);
  finally
    dmMain.memItems.EnableControls;
  end;

end;

end.
