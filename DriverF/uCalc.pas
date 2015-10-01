unit uCalc;

interface
uses dataMain, RVEdit, Graphics, RegularExpressions, RVTable;

type
  TSolver = class
  private
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
  Assert(Match.Groups.Count >=2, '���� �� ��� ���� � ������ ����� ������ '+Match.Value);
  vItemName := Match.Groups.Item[2].Value;

  vKoeff := 1;
  vStr := '';
  //��������, ������� ���� �����������, �� ������� ������� ��������
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

  Assert(dmMain.memItems.Locate('NAME', vItemName, []), '����� '+vItemName+' �� �� � ������� ������');
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
  rows_left = 15;
var
  vText: TArray<string>;
  vFormulas: TArray<String>;
  i: integer;
  row_count: Integer;
  vParaNo: Integer;


  procedure BindFormulas;
  var
    i: Integer;
  begin
    for i := Low(vFormulas) to High(vFormulas) do
      vFormulas[i] := TRegEx.Replace(vFormulas[i], '(\[)(.*)(\])', Evaluator);
  end;
begin
  if AStr = '' then
    Exit;
  ParseText(AStr, vText, vFormulas);
  BindFormulas;
  row_count := 0;
  for i := Low(vText) to High(vText) do
  begin
    if row_count < rows_left then
    begin
      if Copy(vText[i], 1, 1) = #10 then
        vParaNo := 0
      else
        vParaNo := -1;

      FTaskTable.Cells[0,1].AddTextNL(vText[i], 0, vParaNo, -1);
    end
    else
      FRichView.InsertTextW(vText[i]);
    if i<=High(vFormulas) then
    begin
      if row_count < rows_left then
        RVAddFormulaTex(vFormulas[i], FTaskTable.Cells[0,1])
      else
        RVAddFormulaTex(vFormulas[i], FRichView);
    end;
  end;
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
    // ������� �������� ��� ������ �������
  FTaskTable := TRVTableItemInfo.CreateEx(1, 2, FRichView.RVData);
  FRichView.InsertItem('table1', FTaskTable);
  // ������� �� �����
  FTaskTable.VisibleBorders.SetAll(false);
  // ����� ������������ �����
  FTaskTable.VRuleColor := clBlack;
  FTaskTable.VRuleWidth := 1;

  // ��������� ��, ��� ����.
  FTaskTable.Cells[0, 0].Clear;
  FTaskTable.Cells[0, 0].AddTextNLW('����:', 0, 0, 0, True);

  fDmMain.memItems.First;
  while not fDmMain.memItems.Eof do
  begin
    if fDmMain.memItemsVALUE_CORRECT.AsString <> '' then
    begin
      RVAddFormulaTex(Format(cnstFormulaPatt, [fDmMain.memItemsF_TEX.Value,
         RndArr.FormatDoubleStr(fDmMain.memItemsVALUE.Value),
         fDmMain.GetMeasureName(fDmMain.memItemsMEASURE_ID.Value)]), FTaskTable.Cells[0,0]);
    end;
    fDmMain.memItems.Next;
  end;

  FTaskTable.Cells[0, 0].AddBreak;
  AddText('������');

  fDmMain.memItems.First;
  while not fDmMain.memItems.Eof do
  begin
    if fDmMain.memItemsVALUE.AsString = '' then
      RVAddFormulaTex(fDmMain.memItemsF_TEX.Value, FTaskTable.Cells[0,0]);
    fDmMain.memItems.Next;
  end;

  FTaskTable.ResizeRow(0, FTaskTable.Rows[0].GetBestHeight);
  FTaskTable.ResizeCol(0, 150, True);

end;

procedure TSolver.RunSolve;
begin
  FRichView.Clear;
  PrintTask;
  dmMain.ClearCalc;
  dmMain.Calc(OnCalcCallBack);
end;

end.
