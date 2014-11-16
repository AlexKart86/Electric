unit uCalc;

interface

uses uElements, RVEdit;

type

  TSolver = class
  private
    FSchema: TSchema;
    FRichView: TRichViewEdit;
    // Рисуем условие задачи
    procedure PrintTask;
    // Рисует эквивалентную схему
    procedure DrawSchema;
    procedure PrintModule1;
    procedure PrintModule2;
    procedure PrintModule3;
    procedure PrintModule4;
    procedure PrintModule5;
    procedure PrintModule6;
  public
    constructor Create(ASchema: TSchema; ARichView: TRichViewEdit);
    procedure RunSolve;
  end;

implementation

uses Graphics, RVStyle, RvTable, uFormulaUtils, uLocalizeShared,
  uStringUtilsShared, SysUtils, Math, uConstsShared;

{ TSolver }

constructor TSolver.Create(ASchema: TSchema; ARichView: TRichViewEdit);
begin
  FSchema := ASchema;
  FRichView := ARichView;
end;

procedure TSolver.DrawSchema;
var
  vBitmap: TBitmap;
begin
  FRichView.InsertTextW(#13#10 + lc('Schema') + #13#10);
  vBitmap := TBitmap.Create;
  FSchema.DrawSchema(vBitmap);
  FRichView.InsertPicture('schema', vBitmap, rvvaAbsMiddle);
end;

procedure TSolver.PrintModule1;
var
  vPhi: Double;
begin
  FRichView.InsertTextW(#13#10 + lc('Module1#1') + #13#10);
  RVAddFormula(FSchema.GetTanPhiFormula, FRichView);
  FRichView.InsertTextW(#13#10 + lc('Module1#2'));
  RVAddFormula(FSchema.GetPhiFormula, FRichView);
  vPhi := FSchema.Phi;
  // Вывод анализа по углу
  if RoundTo(vPhi, cnstRoundPref) = RoundTo(pi / 2, cnstRoundPref) then
    FRichView.InsertTextW(#13#10 + lc('Module1#3_90'))
  else if RoundTo(vPhi, cnstRoundPref) = RoundTo(-pi / 2, cnstRoundPref) then
    FRichView.InsertTextW(#13#10 + lc('Module1#3_-90'))
  else if vPhi > 0 then
    FRichView.InsertTextW(#13#10 + lc('Module1#3_>0'))
  else if vPhi < 0 then
    FRichView.InsertTextW(#13#10 + lc('Module1#3_<0'))
  else if vPhi = 0 then
    FRichView.InsertTextW(#13#10 + lc('Module1#3_0'));
end;

procedure TSolver.PrintModule2;
begin
  FRichView.InsertTextW(#13#10+lc('Module2#1')+#13#10);
  RVAddFormula(FSchema.GetCosPhiFormula, FRichView);
end;

procedure TSolver.PrintModule3;
begin
  FRichView.InsertTextW(#13#10+lc('Module3#1')+#13#10);
  RVAddFormula(FSchema.GetUFormula, FRichView);
  FRichView.InsertTextW(' В');
end;

procedure TSolver.PrintModule4;
begin
 FRichView.InsertTextW(#13#10+lc('Module4#1')+#10#13);
 RVAddFormula(FSchema.GetZFormula, FRichView);
 FRichView.InsertTextW(' Ом');
end;

procedure TSolver.PrintModule5;
begin
 FRichView.InsertTextW(#13#10+lc('Module5#1')+#10#13);
 RVAddFormula(FSchema.GetPFormula, FRichView);
 FRichView.InsertTextW(' (Вт)');

 FRichView.InsertTextW(#13#10+lc('Module5#2')+#10#13);
 RVAddFormula(FSchema.GetQFormula, FRichView);
 FRichView.InsertTextW(' (ВАР)');

 FRichView.InsertTextW(#13#10+lc('Module5#3')+#10#13);
 RVAddFormula(FSchema.GetSFormula, FRichView);
 FRichView.InsertTextW(' (В∙А)');
end;

procedure TSolver.PrintModule6;
var i: Integer;
begin
  FRichView.InsertTextW(#13#10+lc('Module6#1'));
  for i := 0 to FSchema.ItemsCount-1 do
  begin
    FRichView.InsertTextW(#13#10);
    RVAddFormula(Fschema.GetXFormula(i), FRichView);
    FRichView.InsertTextW(' Ом');
  end;
end;

procedure TSolver.PrintTask;
var
  vtbl: TRVTableItemInfo;
  vStr: String;
  vBitmap: TBitmap;
  i: Integer;

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

  procedure AddFormulaValue(AFormula, AValue: String; ASuffix: String = '');
  var
    vStr: String;
  begin
    if AValue <> '' then
      vStr := AFormula + '=' + AValue
    else
      vStr := AFormula;
    RVAddFormula(vStr, vtbl.Cells[0, 0]);
    if ASuffix <> '' then
      AddText(' ' + ASuffix);
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

  // Ток
  AddFormulaValue('I', PrepareDouble(FSchema.i), 'A');

  // Напряжения
  for i := 0 to FSchema.ItemsCount - 1 do
    AddFormulaValue('U_' + IntToStr(i + 1),
      PrepareDouble(FSchema.Elements[i].U), 'В');

  vtbl.Cells[0, 0].AddBreak;

  // Пишем, что надо найти

  AddText(lc('Task'), True);
  AddFormulaValue('Z,U,phi,P,Q,S', '');

  // Рисуем диаграмму..
  vBitmap := TBitmap.Create;
  FSchema.DrawDiagram(vBitmap);
  vtbl.Cells[0, 1].Clear;
  vtbl.Cells[0, 1].AddPictureEx('diagram', vBitmap, 0, rvvaAbsMiddle);

  vtbl.ResizeRow(0, vtbl.Rows[0].GetBestHeight);
  vtbl.ResizeCol(1, 300, True);
  vtbl.ResizeCol(0, 150, True);
end;

procedure TSolver.RunSolve;
begin
  FRichView.Clear;
  PrintTask;
  DrawSchema;
  PrintModule1;
  PrintModule2;
  PrintModule3;
  PrintModule4;
  PrintModule5;
  PrintModule6;
  FRichView.ScrollTo(0);
end;

end.
