unit uCalc;

interface
uses dataMain, RVEdit, Graphics, RegularExpressions;

type
  TSolver = class
  private
    FRichView: TRichViewEdit;
    fDmMain: TdmMain;
    procedure PrintTask;
    procedure ParseFormulaAndText(AStr: String);
    function Evaluator(const Match: TMatch): string;
    procedure OnCalcCallBack(AStrUkr, AStrRus: String);
  public
    constructor Create(ARichView: TRichViewEdit; AdmMain: TdmMain);
    procedure RunSolve;
  end;

implementation
uses  RVTable, uFormulaUtils, SysUtils, uRounding, uLocalizeShared;

{ TSolver }

constructor TSolver.Create(ARichView: TRichViewEdit; AdmMain: TdmMain);
begin
  FRichView := ARichView;
  fDmMain := AdmMain;
end;

function TSolver.Evaluator(const Match: TMatch): string;
var
  vItemName: String;
begin
  Assert(Match.Groups.Count >=2, 'Щось не так пішло в процесі заміни зразка '+Match.Value);
  vItemName := Match.Groups.Item[2].Value;
  Assert(dmMain.memItems.Locate('NAME', vItemName, []), 'Змінної '+vItemName+' не має в переліку змінних');
  Result := RndArr.FormatDoubleStr(fDmMain.memItemsRESULT_VALUE.Value);
end;

procedure TSolver.OnCalcCallBack(AStrUkr, AStrRus: String);
begin
  case CurrentLang of
    lngUkr: ParseFormulaAndText(AStrUkr);
    lngRus: ParseFormulaAndText(AStrRus);
  end;
end;

procedure TSolver.ParseFormulaAndText(AStr: String);
var
  vText: TArray<string>;
  vFormulas: TArray<String>;
  i: integer;

  procedure BindFormulas;
  var
    i: Integer;
  begin
    for i := Low(vFormulas) to High(vFormulas) do
      vFormulas[i] := TRegEx.Replace(vFormulas[i], '(\[)(.*)(\])', Evaluator);
  end;
begin
  ParseText(AStr, vText, vFormulas);
  BindFormulas;
  for i := Low(vText) to High(vText) do
  begin
    FRichView.InsertTextW(vText[i]);
    if i<=High(vFormulas) then
      RVAddFormulaTex(vFormulas[i], FRichView);
  end;
end;

procedure TSolver.PrintTask;
var
  vtbl: TRVTableItemInfo;
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
    vtbl.Cells[0, 0].AddTextNL(AText, 0, vParaNo, 0);
  end;

begin
    // Создаем табличку для вывода условия
  vtbl := TRVTableItemInfo.CreateEx(1, 2, FRichView.RVData);
  FRichView.InsertItem('table1', vtbl);
  // Граница не видна
  vtbl.VisibleBorders.SetAll(false);
  // Видна вертикальная черта
  vtbl.VRuleColor := clBlack;
  vtbl.VRuleWidth := 1;

  // Заполняем то, что дано.
  vtbl.Cells[0, 0].Clear;
  vtbl.Cells[0, 0].AddTextNLW('Дано:', 0, 0, 0, True);

  fDmMain.memItems.First;
  while not fDmMain.memItems.Eof do
  begin
    if fDmMain.memItemsVALUE_CORRECT.AsString <> '' then
    begin
      RVAddFormulaTex(Format(cnstFormulaPatt, [fDmMain.memItemsF_TEX.Value,
         RndArr.FormatDoubleStr(fDmMain.memItemsVALUE.Value),
         fDmMain.GetMeasureName(fDmMain.memItemsMEASURE_ID.Value)]), vtbl.Cells[0,0]);
    end;
    fDmMain.memItems.Next;
  end;

  vtbl.Cells[0, 0].AddBreak;
  AddText('Знайти');

  fDmMain.memItems.First;
  while not fDmMain.memItems.Eof do
  begin
    if fDmMain.memItemsCALC_VALUE.AsString = '' then
      RVAddFormulaTex(fDmMain.memItemsF_TEX.Value, vtbl.Cells[0,0]);
    fDmMain.memItems.Next;
  end;

  vtbl.ResizeRow(0, vtbl.Rows[0].GetBestHeight);
  vtbl.ResizeCol(0, 150, True);

end;

procedure TSolver.RunSolve;
begin
  FRichView.Clear;
  PrintTask;
  dmMain.ClearCalc;
  dmMain.Calc(OnCalcCallBack);
end;

end.
