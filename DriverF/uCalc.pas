unit uCalc;

interface
uses dataMain, RVEdit, Graphics;

type
  TSolver = class
  private
    FRichView: TRichViewEdit;
    fDmMain: TdmMain;
    procedure PrintTask;
  public
    constructor Create(ARichView: TRichViewEdit; AdmMain: TdmMain);
    procedure RunSolve;
  end;

implementation
uses  RVTable, uFormulaUtils, SysUtils, uRounding;

{ TSolver }

constructor TSolver.Create(ARichView: TRichViewEdit; AdmMain: TdmMain);
begin
  FRichView := ARichView;
  fDmMain := AdmMain;
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

  vtbl.ResizeRow(0, vtbl.Rows[0].GetBestHeight);
  vtbl.ResizeCol(0, 150, True);

end;

procedure TSolver.RunSolve;
begin
  FRichView.Clear;
  PrintTask;
end;

end.
