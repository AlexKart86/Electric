unit uCalc;

interface
uses dataMain, RVEdit, Graphics, RegularExpressions, RVTable;

type
  TSolver = class
  private
    FStage: Integer;
    FTaskTable: TRVTableItemInfo;
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
uses  uFormulaUtils, SysUtils, uRounding, uLocalizeShared;

{ TSolver }

constructor TSolver.Create(ARichView: TRichViewEdit; AdmMain: TdmMain);
begin
  FRichView := ARichView;
  fDmMain := AdmMain;
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

  Assert(dmMain.memItems.Locate('NAME', vItemName, []), 'Змінної '+vItemName+' не має в переліку змінних');
  Result := RndArr.FormatDoubleStr(fDmMain.memItemsRESULT_VALUE.Value*vKoeff);
end;

procedure TSolver.OnCalcCallBack(AStrUkr, AStrRus: String);
begin
  case CurrentLang of
    lngUkr: ParseFormulaAndText(AStrUkr);
    lngRus: ParseFormulaAndText(AStrRus);
  end;
end;

procedure TSolver.ParseFormulaAndText(AStr: String);
const
  stages_tbl = 15;
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
    begin

      //Блядские переводы строки игнорируются
      if (Copy(AText, 1, 1) = #10) or (AText = #13#10) or
          (Copy(AText, 1, 1) = #13) or (AText[length(Atext)] = #13) then
      begin
        vParaNo := 0;
      end
      else
        vParaNo := -1;

        FTaskTable.Cells[0,1].AddTextNL(AText, 0, -1, 0);
       //FTaskTable.Cells[0,1].AddTextBlockNLA(AText, 0, -1);
    end
    else
      FRichView.InsertTextW(AText);
  end;

begin
  if AStr = '' then
    Exit;
  ParseText(AStr, vText, vFormulas);
  BindFormulas;

  Inc(FStage);
  AddText(IntToStr(FStage)+') ');

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
  AddText(#13#10);
  AddText(#13#10);
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
  FTaskTable.Cells[0,0].BestWidth := 150;
  FTaskTable.Cells[0,1].BestWidth := 450;

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
  AddText('Знайти:'#13#10);

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
  FRichView.Clear;
  FStage := 0;
  PrintTask;
{

  FTaskTable.Cells[0,1].DoSelect;
  FRichView.InsertTextW('ddd');}

  dmMain.ClearCalc;
  dmMain.Calc(OnCalcCallBack);

 // FTaskTable.ResizeCol(0, 120, True);

  FTaskTable.ResizeRow(0, FTaskTable.Rows[0].GetBestHeight);

end;

end.
