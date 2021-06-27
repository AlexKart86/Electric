unit uCalc;

// Собственно основной модуль рассчета

interface

uses RVEdit, Graphics, uConsts, uElements, VCLTee.TeEngine, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.Series;

type
  // Собственно класс, реализующий рассчеты
  TSolver = class
  private
    FElementList: TRLCList;
    FRichView: TRichViewEdit;
    FSerU: TLineSeries;
    FSerI: TLineSeries;
    FChrtTotal: TChart;
    FCrtI: TChart;
    FIsAutoScale: Boolean;
    FScaleU: Double;
    FScaleI: Double;
    // Буква начала ветви i
    function GetLetterNodeBegin(i: Integer): Char;
    // Буква конца ветви i
    function GetLetterNodeEnd(i: Integer): Char;
    // рисует на битмапе картинку со схемой
    procedure DrawSchema(Abitmap: TBitmap);
    // Печатает условие задачи
    procedure PrintTask;
    // Печатает вступление
    procedure PrintHeader;
    // Печатает первый модуль
    procedure PrintModule1;
    // Печатает второй модуль
    procedure PrintModule2;
    // Печатает процедуру поиска токов в ветках
    procedure PrintFindI;
    // Печатает процедуру поиска токов по эквивалентному сопротивлению
    procedure PrintFindIByR;
    // Печатает третий модуль
    procedure PrintModule3;
    // Печатает кусочек (начало) третьего модуля, который также нужен для 7 модуля
    procedure PrintModule31;
    // Печатаем 6 модуль
    procedure PrintModule6;
    // Печатает 7 модуль
    procedure PrintModule7;
    // Печатает 8 модуль
    procedure PrintModule8;
    // Печатает векторные диаграммы
    procedure PrintDiagram;
    // Выводит графики
    procedure PrintGraphics;
    function GetSchemaInfo: TSchemaInfo;
  public
    property SchemaInfo: TSchemaInfo read GetSchemaInfo;
    constructor Create(AElementList: TRLCList; ARichView: TRichViewEdit;
      ASerU, ASerI: TLineSeries; AChrtTotal, ACrtI: TChart; AIsAutoScale: Boolean;
      AScaleI, AScaleU: Double);
    procedure RunSolve;
  end;

  // Возвращает истина, если параметр определен
function IsParamAssigned(AValue: double): Boolean;

implementation

uses SysUtils, RVStyle, Types, uGraphicUtils, ExprDraw, ExprMake,
  uLocalizeShared,
  uFormulaUtils, Math, uStringUtils, uStringUtilsShared, StrUtils, RVTable,
  Forms, ArrowUnit,
  uConstsShared;

var
  vBitmap: TBitmap;

function IsParamAssigned(AValue: double): Boolean;
begin
  Result := not(AValue = cnstNotSetValue);
end;

{ TSolver }

constructor TSolver.Create(AElementList: TRLCList; ARichView: TRichViewEdit;
  ASerU, ASerI: TLineSeries; AChrtTotal, ACrtI: TChart; AIsAutoScale: Boolean;
      AScaleI, AScaleU: Double);
begin
  FElementList := AElementList;
  FRichView := ARichView;
  FSerU := ASerU;
  FSerI := ASerI;
  FChrtTotal := AChrtTotal;
  FCrtI := ACrtI;
  FIsAutoScale := AIsAutoScale;
  FScaleI := AScaleI;
  FScaleU := AScaleU;
end;

procedure TSolver.DrawSchema(Abitmap: TBitmap);
const
  cnstElementsDelta = 20;
  cnstNodeWidth = 80;
  cnstNodeHeight = 150;
  cnstElementWidth = 20;
  cnstHeightMargins = 20;
  cnstWidthMargins = 30;
var
  vWidth: Integer;
  i, vOffset, vCurX: Integer;
  vElement: TElementItem;
begin
  vWidth := FElementList.NodesCount * cnstNodeWidth;
  // Устанавливаем размеры картинки
  Abitmap.Width := vWidth + 2 * cnstWidthMargins;
  Abitmap.Height := cnstNodeHeight + 2 * cnstHeightMargins;
  // Рисуем контур
  Abitmap.Canvas.MoveTo(cnstWidthMargins, cnstHeightMargins);
  Abitmap.Canvas.LineTo(cnstWidthMargins + vWidth, cnstHeightMargins);
  Abitmap.Canvas.LineTo(cnstWidthMargins + vWidth,
    cnstHeightMargins + cnstNodeHeight);
  Abitmap.Canvas.LineTo(cnstWidthMargins, cnstHeightMargins + cnstNodeHeight);
  // Рисуем концы контура
  DrawLineEnd(cnstWidthMargins - 4, cnstHeightMargins, Abitmap.Canvas);
  DrawLineEnd(cnstWidthMargins - 4, cnstHeightMargins + cnstNodeHeight,
    Abitmap.Canvas);
  // Рисуем стрелку с напряжением
  Abitmap.Canvas.MoveTo(cnstWidthMargins - 4, cnstHeightMargins + 8);
  Abitmap.Canvas.LineTo(cnstWidthMargins - 4, cnstHeightMargins +
    cnstNodeHeight - 8);
  uGraphicUtils.DrawVertArrow('', '', cnstWidthMargins - 4,
    cnstHeightMargins + cnstNodeHeight - 10, Abitmap.Canvas);
  // Букву рисуем посередине
  Abitmap.Canvas.Font.Size := 12;
  Abitmap.Canvas.TextOut(cnstWidthMargins - Abitmap.Canvas.TextWidth('U') - 7,
    (cnstNodeHeight - Abitmap.Canvas.TextHeight('U')) div 2 +
    cnstHeightMargins, 'U');
  Abitmap.Canvas.Font.Size := 10;

  // Рисуем стрелку с током
  uGraphicUtils.DrawHorzArrow('I', '', cnstWidthMargins + 40, cnstHeightMargins,
    Abitmap.Canvas);

  for i := 1 to FElementList.NodesCount do
  begin
    // Рисуем вертикальную линию
    vCurX := cnstWidthMargins + i * cnstNodeWidth;

    Abitmap.Canvas.Font.Size := cnstNormalFontSize;
    Abitmap.Canvas.TextOut(vCurX - 5, cnstHeightMargins - 18,
      GetLetterNodeBegin(i));

    Abitmap.Canvas.MoveTo(vCurX, cnstHeightMargins);
    Abitmap.Canvas.LineTo(vCurX, cnstHeightMargins + cnstNodeHeight);
    vOffset := cnstHeightMargins;
    // Рисуем сами элементы в ветках

    // R
    uGraphicUtils.DrawVertArrow('I', IntToStr(i), vCurX,
      vOffset + cnstElementsDelta div 2 + 5, Abitmap.Canvas);
    vOffset := vOffset + 10;
    if Assigned(FElementList.r[i - 1]) then
    begin
      vOffset := vOffset + cnstElementsDelta;
      FElementList.r[i - 1].DrawItem(vCurX, vOffset, Abitmap.Canvas);
      vOffset := vOffset + FElementList.r[i - 1].ElementHeight;
    end;

    // L
    if Assigned(FElementList.l[i - 1]) then
    begin
      vOffset := vOffset + cnstElementsDelta;
      FElementList.l[i - 1].DrawItem(vCurX, vOffset, Abitmap.Canvas);
      vOffset := vOffset + FElementList.l[i - 1].ElementHeight;
    end;

    // C
    if Assigned(FElementList.c[i - 1]) then
    begin
      vOffset := vOffset + cnstElementsDelta;
      FElementList.c[i - 1].DrawItem(vCurX, vOffset, Abitmap.Canvas);
      vOffset := vOffset + FElementList.c[i - 1].ElementHeight;
    end;

    // Буквы в концке
    Abitmap.Canvas.Font.Size := cnstNormalFontSize;
    Abitmap.Canvas.TextOut(vCurX - 5, cnstHeightMargins + cnstNodeHeight + 2,
      GetLetterNodeEnd(i));

    if i <> FElementList.NodesCount then
    begin
      DrawLineEnd(vCurX, cnstHeightMargins, Abitmap.Canvas);
      DrawLineEnd(vCurX, cnstHeightMargins + cnstNodeHeight, Abitmap.Canvas);
    end;
  end;

end;

function TSolver.GetLetterNodeBegin(i: Integer): Char;
begin
  Result := Chr(ord('A') + 2 * (i - 1))
end;

function TSolver.GetLetterNodeEnd(i: Integer): Char;
begin
  Result := Chr(ord('A') + 2 * i - 1);
end;

function TSolver.GetSchemaInfo: TSchemaInfo;
begin
  Result := FElementList.SchemaInfo;
end;

procedure TSolver.PrintDiagram;
const
  MaxWidth = 210 * 3;
  MaxHeight = 210 * 3;
  cnstMargins = 20;
  // Шаг изменения радиуса в дуге угла
  cnstPhiRadStep = 40;
  //сколько точек будет в 1 единице
  cnstScaleRatio = 50;

var
  vBitmap, vBitmapPrefix: TBitmap;
  vMultI, vMultU: double;
  vMaxA, vMaxR, vMinA, vMinR: double;
  iA, iR: double;
  r: Integer;
  x0, y0: double;
  koeffI, koeffU: double;
  i: Integer;
  vSumA, vSumR: double;
  vLastX, vlastY: double;
  vStr: String;

  // Преобразует "Обычные" координаты в координаты на канве
  function TxI(x: double; IsUseMargins: Boolean = True): Integer;
  begin
    Result := Round(x / koeffI);
    if IsUseMargins then
      Result := Result + cnstMargins;
  end;

  function TyI(y: double; IsUseMargins: Boolean = True): Integer;
  begin
    Result := -Round(y / koeffI);
    if IsUseMargins then
      Result := Result + cnstMargins;
  end;

  function TxU(x: double; IsUseMargins: Boolean = True): Integer;
  begin
    Result := Round(x / koeffU);
    if IsUseMargins then
      Result := Result + cnstMargins;
  end;

// Рисует масштабные коэффициенты
  procedure DrawMultKoeff;
  const
    vStartY = 20;
  var
    vBitmapPrefix: TBitmap;
  begin
    vBitmapPrefix := TBitmap.Create;
    vBitmapPrefix.Width := 80;
    vBitmapPrefix.Height := 80;
    vBitmapPrefix.Canvas.MoveTo(60 - 50, vStartY);
    vBitmapPrefix.Canvas.LineTo(60, vStartY);
    vBitmapPrefix.Canvas.TextOut(60 - 45, vStartY - 20,
      PrepareDouble(cnstScaleRatio * koeffU) + ' B');
    vBitmapPrefix.Canvas.MoveTo(60, vStartY - 5);
    vBitmapPrefix.Canvas.LineTo(60, vStartY + 5);
    vBitmapPrefix.Canvas.MoveTo(60 - 50, vStartY - 5);
    vBitmapPrefix.Canvas.LineTo(60 - 50, vStartY + 5);

    vBitmapPrefix.Canvas.MoveTo(60 - 50, vStartY + 40);
    vBitmapPrefix.Canvas.LineTo(60, vStartY + 40);
    vBitmapPrefix.Canvas.TextOut(60 - 45, vStartY + 20,
      PrepareDouble(cnstScaleRatio * koeffI) + ' A');
    vBitmapPrefix.Canvas.MoveTo(60 - 50, vStartY + 35);
    vBitmapPrefix.Canvas.LineTo(60 - 50, vStartY + 45);
    vBitmapPrefix.Canvas.MoveTo(60, vStartY + 35);
    vBitmapPrefix.Canvas.LineTo(60, vStartY + 45);
    FRichView.InsertTextW(#13#10);
    FRichView.InsertPicture('image1', vBitmapPrefix, rvvaMiddle);
  end;

begin
  FRichView.InsertTextW(#13#10 + lc('Diagram#1') + #13#10);
  vBitmap := TBitmap.Create;
  vBitmap.Width := MaxWidth + cnstMargins;
  vBitmap.Height := MaxHeight + cnstMargins;

  vMaxR := -FElementList.iR[0];
  vMinR := vMaxR;

  vSumA := 0;
  vSumR := 0;

  for i := 0 to FElementList.NodesCount - 1 do
  begin
    vSumA := vSumA + FElementList.iA[i];
    iR := -FElementList.iR[i];
    if iR < vMinR then
      vMinR := iR;
    if iR > vMaxR then
      vMaxR := iR;
    vSumR := vSumR + iR;
  end;

  x0 := 0;
  y0 := -Max(vMaxR, vSumR);
  if y0 > 0 then
    y0 := 0;

  koeffI := IfThen(FIsAutoScale, GetMultKoeff(Max(vSumA, vMaxR - vMinR), MaxWidth - 40), FScaleI / cnstScaleRatio);
  // Уменьшаем Высоту диаграммы на случай, если ее ширина будет значительно превосходить выосту
  vBitmap.Height := Round(MaxValue([Abs(vSumR), vMaxR - vMinR, vSumR - vMinR]) /
    koeffI) + 2 * cnstMargins;

  // Рисуем токи в ветвях
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    DrawArrow(TxI(x0), TyI(y0), TxI(FElementList.iA[i] + x0),
      TyI(-FElementList.iR[i] + y0), false, vBitmap.Canvas);
    DrawIndexedText('I', IntToStr(i + 1), TxI(x0 + FElementList.iA[i]) + 20,
      TyI(y0 - FElementList.iR[i]) + 5, vBitmap.Canvas);
    r := (i + 1) * cnstPhiRadStep;
    // Угол
    vBitmap.Canvas.MoveTo(TxI(x0) + r, TyI(y0));
    vBitmap.Canvas.AngleArc(TxI(x0), TyI(y0), r, 0, -FElementList.Phi0[i]);

    DrawIndexedText('φ', IntToStr(i + 1),
      TxI(x0) + Trunc(r * cos(FElementList.Phi[i] / 2)) + 10,
      TyI(y0) + Trunc(r * sin(FElementList.Phi[i] / 2)), vBitmap.Canvas);

    DrawIndexedText('=' + PrepareDouble(FElementList.Phi0[i]) + '°', '',
      TxI(x0) + Trunc(r * cos(FElementList.Phi[i] / 2)) + 30,
      TyI(y0) + Trunc(r * sin(FElementList.Phi[i] / 2)), vBitmap.Canvas);

    // Проекция на ось Х
    DrawArrow(TxI(FElementList.iA[i] + x0), TyI(-FElementList.iR[i] + y0),
      TxI(FElementList.iA[i] + x0), TyI(y0), True, vBitmap.Canvas, clBlack,
      1, amNone);
    DrawArrow(TxI(x0), TyI(y0), TxI(FElementList.iA[i] + x0), TyI(y0), false,
      vBitmap.Canvas, clBlack, 1, amArrow);
    DrawIndexedText('I', 'a' + IntToStr(i + 1), TxI(FElementList.iA[i] + x0),
      TyI(y0) + 10, vBitmap.Canvas);
    // Проекция на ось Y
    DrawArrow(TxI(FElementList.iA[i] + x0), TyI(-FElementList.iR[i] + y0),
      TxI(x0), TyI(-FElementList.iR[i] + y0), True, vBitmap.Canvas, clBlack,
      1, amNone);
    DrawArrow(TxI(x0), TyI(y0), TxI(x0), TyI(-FElementList.iR[i] + y0), false,
      vBitmap.Canvas, clBlack, 1, amArrow);
    DrawIndexedText('I', 'р' + IntToStr(i + 1), 1,
      TyI(-FElementList.iR[i] + y0), vBitmap.Canvas);
  end;

  // НАЧАЛО Рисуем общий ток
  Inc(r, cnstPhiRadStep);
  DrawArrow(TxI(x0), TyI(y0), TxI(vSumA + x0), TyI(vSumR + y0), false,
    vBitmap.Canvas);
  DrawIndexedText('I', '', TxI(x0 + vSumA) + 20, TyI(y0 + vSumR) + 5,
    vBitmap.Canvas);

  // Угол
  r := r + 40;
  vBitmap.Canvas.MoveTo(TxI(x0) + r, TyI(y0));
  vBitmap.Canvas.AngleArc(TxI(x0), TyI(y0), r, 0,
    -RadToDeg(FElementList.PhiTotal));
  DrawIndexedText('φ=' + PrepareDouble(RadToDeg(FElementList.PhiTotal)) + '°',
    '', TxI(x0) + Trunc(r * cos(FElementList.PhiTotal / 2)) + 10,
    TyI(y0) + Trunc(r * sin(FElementList.PhiTotal / 2)), vBitmap.Canvas);

  // КОНЕЦ. Рисуем общий ток

  // Рисуем пунктиром
  vLastX := FElementList.iA[0];
  vlastY := -FElementList.iR[0];
  for i := 1 to FElementList.NodesCount - 1 do
  begin
    DrawArrow(TxI(vLastX + x0), TyI(vlastY + y0),
      TxI(FElementList.iA[i] + vLastX + x0),
      TyI(-FElementList.iR[i] + vlastY + y0), True, vBitmap.Canvas);
    vLastX := vLastX + FElementList.iA[i];
    vlastY := vlastY + -FElementList.iR[i];
  end;

  // Рисуем напряжение
  koeffU := IfThen(FIsAutoScale, GetMultKoeff(Abs(FElementList.U), MaxWidth / 2 - 40), FScaleU / cnstScaleRatio);
  DrawArrow(TxU(x0), TyI(y0), TxU(FElementList.U + x0), TyI(y0), false,
    vBitmap.Canvas);
  DrawIndexedText('U', '', TxU(x0 + FElementList.U) + 10, TyI(y0) + 9,
    vBitmap.Canvas);

  DrawMultKoeff;
  FRichView.InsertTextW(#13#10);
  FRichView.InsertPicture('image1', vBitmap, rvvaMiddle);
  FRichView.InsertTextW(#13#10);

end;

procedure TSolver.PrintFindI;
var
  vFormulaStr: String;
  i: Integer;
begin
  if SchemaInfo.AddParamType <> apIi then
  begin
    FRichView.InsertTextW(#13#10 + lc('FindI#0'));
    RVAddFormula(GetFormulaAddParam(SchemaInfo), FRichView);
    FRichView.InsertTextW(':');
  end;
  // Рассчет для "Простых параметров"
  if SchemaInfo.AddParamType in TNeedNodeParamSet then
  begin
    // Для уже заданного в ветке тока не надо писать его рассчет
    if SchemaInfo.AddParamType <> apIi then
    begin
      FRichView.InsertTextW(#13#10);
      vFormulaStr := TAddParamFormulas[ord(SchemaInfo.AddParamType)];
      vFormulaStr := ReplaceStr(vFormulaStr, '_i',
        '_' + IntToStr(SchemaInfo.AddParamNodeNum));
      RVAddFormula(vFormulaStr, FRichView);
      FRichView.InsertTextW(lc('FindI#1'));
    end;
    FElementList.CalcIBySimpleAddParam(vFormulaStr);
    if SchemaInfo.AddParamType <> apIi then
    begin
      RVAddFormula(vFormulaStr, FRichView);
      FRichView.InsertTextW(' A');
    end;
    // Ищем напряжение в контуре
    FElementList.CalcUBySimpleParam(vFormulaStr);
    FRichView.InsertTextW(#13#10 + lc('FindI#2') + #13#10);
    RVAddFormula(vFormulaStr, FRichView);
    FRichView.InsertTextW(' В');
    FRichView.InsertTextW(#13#10 + lc('FindI#3'));
  end;

  // Рассчет для параметра "Напряжение"
  if SchemaInfo.AddParamType = apU then
    FElementList.U := SchemaInfo.AddParamValue;

  // TO DO: сюда пишем рассчет для "Сложных" параметров

  // После того, как нашли напряжение, ищем токи
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    // Пропускаем ветку с уже найденным (заданным) током
    if i = SchemaInfo.AddParamNodeNum - 1 then
      Continue;
    FRichView.InsertTextW(#13#10 + Format(lc('Part'), [i + 1]));
    FElementList.CalcIByU(i, vFormulaStr);
    RVAddFormula(vFormulaStr, FRichView);
    FRichView.InsertTextW(' A');
  end;

end;

procedure TSolver.PrintFindIByR;
var
  vStr: String;
begin
  case SchemaInfo.AddParamType of
    apI:
      FElementList.Itotal := SchemaInfo.AddParamValue;
    apP:
      begin
        FElementList.Itotal :=
          sqrt(SchemaInfo.AddParamValue / FElementList.RaTotal);
        FRichView.InsertTextW(#13#10 + lc('FindIR#1'));
        vStr := 'P=I^2*.R_(string(екв))';
        RVAddFormula(vStr, FRichView);
        FRichView.InsertTextW(#13#10 + lc('FindIR#n') + ' ');
        vStr := 'I=sqrt(P/R_(string(екв)))=sqrt(' +
          PrepareDouble(SchemaInfo.AddParamValue) + '/' +
          PrepareDouble(FElementList.RaTotal) + ')=' +
          PrepareDouble(FElementList.Itotal);
        RVAddFormula(vStr, FRichView);
        FRichView.InsertTextW(' A');
      end;
    apQ:
      begin
        FElementList.Itotal :=
          sqrt(Abs(SchemaInfo.AddParamValue / FElementList.XrTotal));
        FRichView.InsertTextW(#13#10 + lc('FindIR#2'));
        vStr := 'Q=I^2*.X_(string(екв))';
        RVAddFormula(vStr, FRichView);
        FRichView.InsertTextW(#13#10 + lc('FindIR#n') + ' ');
        vStr := 'I=sqrt(|Q/X_(string(екв))|)=sqrt(|' +
          PrepareDouble(SchemaInfo.AddParamValue) + '/' +
          PrepareDouble(FElementList.XrTotal) + '|)=' +
          PrepareDouble(FElementList.Itotal);
        RVAddFormula(vStr, FRichView);
        FRichView.InsertTextW(' A');
      end;
    apS:
      begin
        FElementList.Itotal :=
          sqrt(Abs(SchemaInfo.AddParamValue / FElementList.ZTotal));
        FRichView.InsertTextW(#13#10 + lc('FindIR#2'));
        vStr := 'S=I^2*.Z_(string(екв))';
        RVAddFormula(vStr, FRichView);
        FRichView.InsertTextW(#13#10 + lc('FindIR#n') + ' ');
        vStr := 'I=sqrt(S/Z_(string(екв)))=sqrt(' +
          PrepareDouble(SchemaInfo.AddParamValue) + '/' +
          PrepareDouble(FElementList.ZTotal) + ')=' +
          PrepareDouble(FElementList.Itotal);
        RVAddFormula(vStr, FRichView);
        FRichView.InsertTextW(' A');
      end;
  end;
end;

procedure TSolver.PrintGraphics;
const
  PointsPerPeriod = 20;
var
  vStr: String;
  i: Integer;
  j: double;
  h: double;
  p: TChart;
begin

  FRichView.InsertTextW(#13#10 + lc('Graph#1') + #13#10);
  RVAddFormula(FElementList.GetUByTFormula, FRichView);
  FRichView.InsertTextW(lc('Graph#2'));
  vStr := 'U_0=U*sqrt(2)=' + PrepareDouble(FElementList.U) + '*sqrt(2)=' +
    PrepareDouble(FElementList.U * sqrt(2));
  RVAddFormula(vStr, FRichView);
  FRichView.InsertTextW(' В' + lc('Graph#21'));
  // Выводим формулы для токов в ветвях
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    FRichView.InsertTextW(#13#10 + Format(lc('Graph#3'), [i + 1]) + #13#10);
    RVAddFormula(FElementList.GetIByTFormula(i), FRichView);
    FRichView.InsertTextW(lc('Graph#2'));
    vStr := 'I_0_' + IntToStr(i + 1) + '=I_' + IntToStr(i + 1) + '*.sqrt(2)=' +
      PrepareDouble(FElementList.i[i]) + '*sqrt(2)=' +
      PrepareDouble(FElementList.i[i] * sqrt(2));
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(' A' + Format(lc('Graph#4'), [i + 1]));
  end;
  // Выводим формулу для общего тока
  FRichView.InsertTextW(#13#10 + lc('Graph#31') + #13#10);
  RVAddFormula(FElementList.GetItotalFormula, FRichView);
  FRichView.InsertTextW(lc('Graph#2'));
  vStr := 'I_0=I*.sqrt(2)=' + PrepareDouble(FElementList.Itotal) + '*sqrt(2)=' +
    PrepareDouble(FElementList.Itotal * sqrt(2));
  RVAddFormula(vStr, FRichView);
  FRichView.InsertTextW(' A' + lc('Graph#41'));

  FRichView.InsertTextW(#13#10);
  FSerU.Clear;
  FSerI.Clear;
  j := SchemaInfo.t0;
  // h := (SchemaInfo.t - SchemaInfo.t0) / 150;
  h := 2 * pi / SchemaInfo.W / PointsPerPeriod;
  while j <= SchemaInfo.t do
  begin
    FSerU.AddXY(j * SchemaInfo.W, FElementList.GetUByT(j));
    FSerI.AddXY(j * SchemaInfo.W, FElementList.GetITotalByT(j));
    j := j + h;
  end;
  Application.ProcessMessages;
  FChrtTotal.Title.Caption := lc('Graph#5');
  FChrtTotal.Series[0].LegendTitle := lc('Graph#7');
  FChrtTotal.Series[1].LegendTitle := lc('Graph#8');
  FChrtTotal.Legend.Title.Text.Text := lc('Graph#9');
  FChrtTotal.CopyToClipboardBitmap;


  FRichView.PasteBitmap(false);

  for i := 0 to FCrtI.SeriesCount - 2 do
  begin
    FCrtI.Series[i].Clear;
    FCrtI.Series[i].Active := i < FElementList.NodesCount;
    FCrtI.Series[i].LegendTitle := lc('Graph#10')+IntToStr(i+1);

  end;
  // Серия отвечающая за вывод общего тока
  FCrtI.Series[FCrtI.SeriesCount - 1].Clear;

  for i := 0 to FElementList.NodesCount - 1 do
  begin
    j := SchemaInfo.t0;
    while j <= SchemaInfo.t do
    begin
      FCrtI.Series[i].AddXY(j * SchemaInfo.W, FElementList.GetIByT(i, j));
      j := j + h;
    end;
  end;

  // Рисуем общий ток
  j := SchemaInfo.t0;
  while j <= SchemaInfo.t do
  begin
    FCrtI.Series[FCrtI.SeriesCount - 1].AddXY(j * SchemaInfo.W,
      FElementList.GetITotalByT(j));
    j := j + h;
  end;
  FCrtI.Series[FCrtI.SeriesCount - 1].LegendTitle := lc('Graph#11');

  Application.ProcessMessages;
  FCrtI.Title.Caption := lc('Graph#6');
  FCrtI.CopyToClipboardBitmap;
  FRichView.InsertTextW(#13#10);
  FRichView.PasteBitmap(false);
end;

procedure TSolver.PrintHeader;
const
  cnstFormulaPattern = 'omega=2*pi*.f=2*pi*%s=%s';
var
  s1, s2: String;
begin
  FRichView.InsertTextW(#13#10 + Format(lc('Header#1'),
    [FElementList.NodesCount]));
  RVAddFormula('U', FRichView);
  // Если задана частота, а циклическая частота не задана,
  // Добавляем блок вычисления частоты
  if (SchemaInfo.W = cnstNotSetValue) and (SchemaInfo.F <> cnstNotSetValue) then
  begin
    FRichView.InsertTextW(#13#10 + lc('Header#2'));
    FElementList.SchemaInfo.W := 2 * pi * FElementList.SchemaInfo.F;
    s1 := PrepareDouble(SchemaInfo.F);
    s2 := PrepareDouble(SchemaInfo.W);
    RVAddFormula(Format(cnstFormulaPattern, [s1, s2]), FRichView);
    FRichView.InsertTextW(' рад/с');
  end;

end;

procedure TSolver.PrintModule1;
var
  i: Integer;
  vFormula: TFormula;
  vStr: String;
begin
  // Если задана частота определяем сопротивления
  if SchemaInfo.CalcType = ctRLC then
  begin
    FRichView.InsertTextW(#13#10 + lc('Module1#0'));
    for i := 0 to FElementList.NodesCount - 1 do
    begin
      // Если на этой ветке отмечено хотя бы одна катушка или конденсатор
      if Assigned(FElementList.l[i]) or Assigned(FElementList.c[i]) then
        FRichView.InsertTextW(#13#10 + Format(lc('Part'), [i + 1]));

      // Преобразование для катушки
      if Assigned(FElementList.l[i]) then
      begin
        FRichView.InsertTextW(#13#10);
        vStr := 'X_L_' + IntToStr(i + 1) + '=omega*.L_' + IntToStr(i + 1) + '='
          + PrepareDouble(SchemaInfo.W) + '*.' +
          PrepareDouble(FElementList.l[i].Value) + '=' +
          PrepareDouble(FElementList.l[i].GetFormulaRValue(SchemaInfo));
        RVAddFormula(vStr, FRichView);
        FRichView.InsertTextW(' Ом');
      end;

      // Преобразование для конденсатора
      if Assigned(FElementList.c[i]) then
      begin
        FRichView.InsertTextW(#13#10);
        vStr := 'X_C_' + IntToStr(i + 1) + '=1/(omega*.С_' + IntToStr(i + 1) +
          ')=' + '1/(' + PrepareDouble(SchemaInfo.W) + '*.' +
          PrepareDouble(FElementList.c[i].Value, True) + ')=' +
          PrepareDouble(FElementList.c[i].GetFormulaRValue(SchemaInfo));
        RVAddFormula(vStr, FRichView);
        FRichView.InsertTextW(' Ом');
      end;

    end;
  end;

  FRichView.InsertTextW(#13#10 + lc('Module1#1'));
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    FRichView.InsertTextW(#13#10 + Format(lc('Part'), [i + 1]));
    vFormula := TFormula.Create;
    try
      FElementList.GetFormulaR(i, vFormula);
      vStr := 'Z_' + IntToStr(i + 1) + '=' + vFormula.FormulaStr + '=' +
        vFormula.GetFormulaValue + '=' + PrepareDouble(FElementList.Z[i]);
      RVAddFormula(vStr, FRichView);
      FRichView.InsertTextW(' Ом');
    finally
      FreeAndNil(vFormula);
    end;
  end;
end;

procedure TSolver.PrintModule2;
var
  vFormula: TFormula;
  vPhi: double;
  vStr: String;
  i: Integer;
begin
  FRichView.InsertTextW(#13#10 + lc('Module2#1'));
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    FRichView.InsertTextW(#13#10 + Format(lc('Part'), [i + 1]));
    vFormula := TFormula.Create;
    try
      FElementList.GetFormulaSin(i, vFormula);
      if FElementList.Phi0[i] = 0 then
      begin
        vStr := 'sin(phi_' + IntToStr(i + 1) + ')=0';
      end
      else
      begin
        vStr := 'sin(phi_' + IntToStr(i + 1) + ')=' + vFormula.FormulaStr + '='
          + vFormula.GetFormulaValue;
        vStr := vStr + '=' + PrepareDouble(FElementList.GetFormulaSinValue(i));
      end;
      RVAddFormula(vStr, FRichView);
    finally
      vFormula.Free;
    end;
    // Печатаем угол
    vPhi := FElementList.Phi0[i];
    vStr := 'phi_' + IntToStr(i + 1) + '=' + PrepareDouble(vPhi) + '^0';
    FRichView.InsertTextW(#13#10);
    RVAddFormula(vStr, FRichView);

    FRichView.InsertTextW(#13#10 + lc('Module2#2'));
    // Если phi=90
    if vPhi = 90 then
    begin
      RVAddFormula(vStr, FRichView);
      FRichView.InsertTextW('. ' + Format(lc('Module2#3'), [i + 1]));
      FRichView.ApplyTextStyle(1);
      FRichView.InsertTextW(' ' + lc('Module2#3_90'));
      FRichView.ApplyTextStyle(0);
      FRichView.InsertTextW(' ' + lc('Module2#3_90_1'));
      RVAddFormula('90^0', FRichView);
    end

    // Если phi=-90
    else if vPhi = -90 then
    begin
      RVAddFormula(vStr, FRichView);
      FRichView.InsertTextW('. ' + Format(lc('Module2#3'), [i + 1]));
      FRichView.ApplyTextStyle(1);
      FRichView.InsertTextW(' ' + lc('Module2#3_-90'));
      FRichView.ApplyTextStyle(0);
      FRichView.InsertTextW(' ' + lc('Module2#3_-90_1'));
      RVAddFormula('90^0', FRichView);
    end
    else if vPhi = 0 then
    begin
      RVAddFormula(vStr, FRichView);
      FRichView.InsertTextW('. ' + Format(lc('Module2#3'), [i + 1]));
      FRichView.ApplyTextStyle(1);
      FRichView.InsertTextW(' ' + lc('Module2#3_0'));
      FRichView.ApplyTextStyle(0);
      FRichView.InsertTextW(' ' + lc('Module2#3_0_1'));
    end
    else if vPhi > 0 then
    begin
      RVAddFormula('phi_' + IntToStr(i + 1) + '>0', FRichView);
      FRichView.InsertTextW('. ' + Format(lc('Module2#3'), [i + 1]));
      FRichView.ApplyTextStyle(1);
      FRichView.InsertTextW(' ' + lc('Module2#3_>0'));
      FRichView.ApplyTextStyle(0);
      FRichView.InsertTextW(' ' + lc('Module2#3_>0_1'));
      RVAddFormula('|phi_' + IntToStr(i + 1) + '|=' + PrepareDouble(vPhi) +
        '^0', FRichView);
    end
    else if vPhi < 0 then
    begin
      RVAddFormula('phi_' + IntToStr(i + 1) + '<0', FRichView);
      FRichView.InsertTextW('. ' + Format(lc('Module2#3'), [i + 1]));
      FRichView.ApplyTextStyle(1);
      FRichView.InsertTextW(' ' + lc('Module2#3_<0'));
      FRichView.ApplyTextStyle(0);
      FRichView.InsertTextW(' ' + lc('Module2#3_<0_1'));
      RVAddFormula('|phi_' + IntToStr(i + 1) + '|=' + PrepareDouble(Abs(vPhi)) +
        '^0', FRichView);
    end;
  end;
end;

procedure TSolver.PrintModule3;
var
  i: Integer;
  vStr: String;
  vPhi: double;
  vP, vQ, vS: double;
begin
  FRichView.InsertTextW(#13#10 + lc('Module3#0'));
  PrintModule31;

  FRichView.InsertTextW(#13#10 + lc('Module3#2'));
  // Формируем формулу общего подсчета тока
  vStr := '';
  for i := 0 to FElementList.NodesCount - 1 do
    vStr := vStr + '+Vect(I_' + IntToStr(i + 1) + ')';
  vStr := Copy(vStr, 2, Length(vStr) - 1);
  vStr := 'Vect(I)=' + vStr;
  FRichView.InsertTextW(#13#10);
  RVAddFormula(vStr, FRichView);
  FRichView.InsertTextW(lc('Module3#3') + #13#10);
  RVAddFormula(FElementList.CalcITotalFormula, FRichView);
  FRichView.InsertTextW(' A');
  FRichView.InsertTextW(#13#10 + lc('Module3#4') + #13#10);
  RVAddFormula(FElementList.CalcPhiTotalFormula, FRichView);

end;

procedure TSolver.PrintModule31;
var
  i: Integer;
begin
  FRichView.InsertTextW(#13#10 + lc('Module3#1'));
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    FRichView.InsertTextW(#13#10 + Format(lc('Part'), [i + 1]) + #13#10);
    RVAddFormula(FElementList.GetIaFormula(i), FRichView);
    FRichView.InsertTextW(' A' + #13#10);
    RVAddFormula(FElementList.GetIrFormula(i), FRichView);
    FRichView.InsertTextW(' A');
  end;
end;

procedure TSolver.PrintModule6;
var
  i: Integer;
  vStr: String;
  fg, fb: array of double;
  y: double;
  sumg, sumb: double;
  vFormula: TFormula;
begin
  FRichView.InsertTextW(#13#10 + lc('Module6#1'));
  SetLength(fg, FElementList.NodesCount);
  SetLength(fb, FElementList.NodesCount);
  sumg := 0;
  sumb := 0;
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    FRichView.InsertTextW(#13#10 + Format(lc('Part'), [i + 1]));
    FRichView.InsertTextW(#13#10 + lc('Module6#2'));
    fg[i] := FElementList.CalcgFormulaVal(i, vStr);
    sumg := sumg + fg[i];
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(' См');
    FRichView.InsertTextW(#13#10 + lc('Module6#3'));
    fb[i] := FElementList.CalcbFormulaVal(i, vStr);
    sumb := sumb + fb[i];
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(' См');
  end;

  // Подсчет общей проводимости
  vFormula := TFormula.Create;
  try
    FRichView.InsertTextW(#13#10 + lc('Module6#4') + #13#10);
    for i := 0 to FElementList.NodesCount - 1 do
    begin
      vFormula.AddReplaceTerm('g_' + IntToStr(i + 1), fg[i]);
      vFormula.AddReplaceTerm('b_' + IntToStr(i + 1), fb[i]);
    end;
    y := sqrt(sqr(sumg) + sqr(sumb));
    vFormula.FormulaStr := 'sqrt(' +
      StrPower(GetSumStrFormula('g', FElementList.NodesCount), 2) + '+' +
      StrPower(GetSumStrFormula('b', FElementList.NodesCount), 2) + ')';
    vStr := 'y=' + vFormula.FormulaStr + '=' + vFormula.GetFormulaValue + '=' +
      PrepareDouble(y);
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(' См');

    // Определение активной и реактивной составляющей напряжения
    FRichView.InsertTextW(#13#10 + lc('Module6#5'));
    FRichView.InsertTextW(#13#10 + lc('Module6#6'));

    FElementList.RaTotal := sumg / sqr(y);
    vFormula.AddReplaceTerm('y', y);
    vFormula.FormulaStr := '(' + GetSumStrFormula('g', FElementList.NodesCount)
      + ')/(y^2)';
    vStr := 'R_(string(екв))=' + vFormula.FormulaStr + '=' +
      vFormula.GetFormulaValue + '=' + PrepareDouble(FElementList.RaTotal);
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(' Ом');
    FRichView.InsertTextW(#13#10 + lc('Module6#7'));
    FElementList.XrTotal := sumb / sqr(y);
    vFormula.FormulaStr := '(' + GetSumStrFormula('b', FElementList.NodesCount)
      + ')/(y^2)';
    vStr := 'X_(string(екв))=' + vFormula.FormulaStr + '=' +
      vFormula.GetFormulaValue + '=' + PrepareDouble(FElementList.XrTotal);
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(' Ом');

  finally
    FreeAndNil(vFormula);
  end;
  // Находим эквивалетное сопротивление цепи
  FRichView.InsertTextW(#13#10 + lc('Module6#8') + #13#10);
  FElementList.ZTotal := 1 / y;
  vStr := 'Z_(string(екв))=1/y=1/' + PrepareDouble(y) + '=' +
    PrepareDouble(FElementList.ZTotal);
  RVAddFormula(vStr, FRichView);
  FRichView.InsertTextW(' Ом');
  FRichView.InsertTextW(#13#10 + lc('Module6#9') + ' ');
  FElementList.ZTotal := sqrt(sqr(FElementList.XrTotal) +
    sqr(FElementList.RaTotal));
  vStr := 'Z_(string(екв))=sqrt(X_(string(екв))^2+R_(string(екв))^2)=sqrt(' +
    StrPower(PrepareDouble(FElementList.XrTotal, false, True), 2) + '+' +
    StrPower(PrepareDouble(FElementList.RaTotal), 2) + ')=' +
    PrepareDouble(FElementList.ZTotal);
  RVAddFormula(vStr, FRichView);
  FRichView.InsertTextW(' Ом');
end;

procedure TSolver.PrintModule7;
var
  vStr: String;
  vSin: double;
  vPhi: double;
  i: Integer;
begin
  // Ищем напряжение
  FRichView.InsertTextW(#13#10 + lc('Module7#1') + #13#10);
  FElementList.U := FElementList.Itotal * FElementList.ZTotal;
  vStr := 'U=I*.Z_(string(екв))=' + PrepareDouble(FElementList.Itotal) + '*.' +
    PrepareDouble(FElementList.ZTotal) + '=' + PrepareDouble(FElementList.U);
  RVAddFormula(vStr, FRichView);
  FRichView.InsertTextW(' В');

  // После того, как нашли напряжение, ищем токи
  FRichView.InsertTextW(#13#10 + lc('Module7#2'));
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    FRichView.InsertTextW(#13#10 + Format(lc('Part'), [i + 1]));
    FElementList.CalcIByU(i, vStr);
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(' A');
  end;

  // Находим составляюшие токов
  PrintModule31;

  // Находим угол
  FRichView.InsertTextW(#13#10 + lc('Module7#3') + #13#10);
  vSin := FElementList.XrTotal / FElementList.ZTotal;
  vStr := 'sin(phi)=X_(string(екв))/Z_(string(екв))=' +
    PrepareDouble(FElementList.XrTotal) + '/' +
    PrepareDouble(FElementList.ZTotal) + '=' + PrepareDouble(vSin);
  RVAddFormula(vStr, FRichView);
  FRichView.InsertTextW(#13#10);
  FElementList.PhiTotal := Arcsin(vSin);
  vPhi := RadToDeg(FElementList.PhiTotal);
  vStr := 'phi=arcsin(' + PrepareDouble(vSin) + ')=' +
    PrepareDouble(vPhi) + '^0';
  RVAddFormula(vStr, FRichView);
end;

procedure TSolver.PrintModule8;
var
  vPhi: double;
  vStr: String;
  vS, vP, vQ: double;
begin
  // Выводим анализ по результатам, полученным при вычислении угла
  vPhi := RadToDeg(FElementList.PhiTotal);
  FRichView.InsertTextW(#13#10 + lc('Module3#5'));
  if vPhi = 90 then
  begin
    RVAddFormula('phi=90^0', FRichView);
    FRichView.InsertTextW(lc('Module3#6_90_1'));
    FRichView.ApplyTextStyle(1);
    FRichView.InsertTextW(lc('Module3#6_90_2'));
    FRichView.ApplyTextStyle(0);
    FRichView.InsertTextW(lc('Module3#6_90_3'));
    RVAddFormula('90^0', FRichView);
  end
  else if vPhi = -90 then
  begin
    RVAddFormula('phi=-90^0', FRichView);
    FRichView.InsertTextW(lc('Module3#6_-90_1'));
    FRichView.ApplyTextStyle(1);
    FRichView.InsertTextW(lc('Module3#6_-90_2'));
    FRichView.ApplyTextStyle(0);
    FRichView.InsertTextW(lc('Module3#6_-90_3'));
    RVAddFormula('90^0', FRichView);
  end
  else if vPhi > 0 then
  begin
    RVAddFormula('phi>0', FRichView);
    FRichView.InsertTextW(lc('Module3#6_>0_1'));
    FRichView.ApplyTextStyle(1);
    FRichView.InsertTextW(lc('Module3#6_>0_2'));
    FRichView.ApplyTextStyle(0);
    FRichView.InsertTextW(lc('Module3#6_>0_3'));
    RVAddFormula('Abs(phi)=' + PrepareDouble(Abs(vPhi)) + '^0', FRichView);
  end
  else if vPhi = 0 then
  begin
    RVAddFormula('phi=0', FRichView);
    FRichView.InsertTextW(lc('Module3#6_0_1'));
    FRichView.ApplyTextStyle(1);
    FRichView.InsertTextW(lc('Module3#6_0_2'));
    FRichView.ApplyTextStyle(0);
    FRichView.InsertTextW(lc('Module3#6_0_3'));
  end
  else if vPhi < 0 then
  begin
    RVAddFormula('phi<0', FRichView);
    FRichView.InsertTextW(lc('Module3#6_<0_1'));
    FRichView.ApplyTextStyle(1);
    FRichView.InsertTextW(lc('Module3#6_<0_2'));
    FRichView.ApplyTextStyle(0);
    FRichView.InsertTextW(lc('Module3#6_<0_3'));
    RVAddFormula('Abs(phi)=' + PrepareDouble(Abs(vPhi)) + '^0', FRichView);
  end;

  FRichView.InsertTextW(#13#10 + lc('Module3#7'));
  vStr := 'cos(phi)=cos(' + PrepareDouble(vPhi) + '^0)=' +
    PrepareDouble(cos(FElementList.PhiTotal));
  RVAddFormula(vStr, FRichView);

  // Сумарная активная мощность
  if SchemaInfo.AddParamType <> apP then
  begin
    FRichView.InsertTextW(#13#10 + lc('Module3#8'));
    vStr := GetSumStrFormula('P', 'P', FElementList.NodesCount);
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(lc('Module3#9'));
    vP := FElementList.Itotal * FElementList.U * cos(FElementList.PhiTotal);
    vStr := 'P=I*.U*.cos(phi)=' + PrepareDouble(FElementList.Itotal) + '*.' +
      PrepareDouble(FElementList.U) + '*.cos(' + PrepareDouble(vPhi) + '^0)=' +
      PrepareDouble(vP);
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(' Вт');
  end
  else
    vP := SchemaInfo.AddParamValue;

  // Суммарная реактивная мощность
  if SchemaInfo.AddParamType <> apQ then
  begin
    FRichView.InsertTextW(#13#10 + lc('Module3#10'));
    vStr := GetSumStrFormula('Q', 'Q', FElementList.NodesCount);
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(lc('Module3#9'));
    vQ := FElementList.Itotal * FElementList.U * sin(FElementList.PhiTotal);
    vStr := 'Q=I*.U*.sin(phi)=' + PrepareDouble(FElementList.Itotal) + '*.' +
      PrepareDouble(FElementList.U) + '*.sin(' + PrepareDouble(vPhi) + '^0)=' +
      PrepareDouble(vQ);
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(' ВАР');
  end
  else
    vQ := SchemaInfo.AddParamValue;

  // Полная мощность в цепи
  if SchemaInfo.AddParamType <> apS then
  begin
    FRichView.InsertTextW(#13#10 + lc('Module3#11'));
    vS := sqrt(sqr(vP) + sqr(vQ));
    vStr := 'S=sqrt(P^2+Q^2)=sqrt(' + PrepareDouble(vP, false, True) + '^2+' +
      PrepareDouble(vQ, false, True) + '^2)=' + PrepareDouble(vS);
    RVAddFormula(vStr, FRichView);
    FRichView.InsertTextW(' В∙А');
  end
  else
    vS := SchemaInfo.AddParamValue;

  //
  FRichView.InsertTextW(#13#10 + lc('Module3#12') + #13#10);
  vStr := GetSumStrFormula('S', FElementList.NodesCount);
  vStr := 'S<>' + vStr;
  RVAddFormula(vStr, FRichView);

  // Ток, другой способ

  FRichView.InsertTextW(#13#10 + lc('Module3#13') + #13#10);
  vStr := 'I=S/U=' + PrepareDouble(vS) + '/' + PrepareDouble(FElementList.U) +
    '=' + PrepareDouble(vS / FElementList.U);
  RVAddFormula(vStr, FRichView);
  FRichView.InsertTextW(' A');

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

  i := ord(SchemaInfo.AddParamType);
  vStr := TAddParamPrefix[i];
  // Для "индексированных" параметров добавляем еще индекс
  if SchemaInfo.AddParamType in TNeedNodeParamSet then
  begin
    vStr := vStr + '_' + IntToStr(SchemaInfo.AddParamNodeNum);
  end;
  AddFormulaValue(vStr, PrepareDouble(SchemaInfo.AddParamValue),
    TAddParamsPostfix[i]);

  if SchemaInfo.W0 > 0 then
    // AddFormulaValue('omega_0', PrepareDouble(SchemaInfo.W0), '^0');
    RVAddFormula('omega_0=' + PrepareDouble(SchemaInfo.W0) + '^0',
      vtbl.Cells[0, 0]);

  if SchemaInfo.W > 0 then
    // AddFormulaValue('omega', PrepareDouble(SchemaInfo.W), 'рад/с');
    RVAddFormula('omega=' + PrepareDouble(SchemaInfo.W) + '&space(5)&c^(-1)',
      vtbl.Cells[0, 0]);

  if SchemaInfo.F > 0 then
    // AddFormulaValue('f', PrepareDouble(SchemaInfo.F), 'рад/с');
    RVAddFormula('f=' + PrepareDouble(SchemaInfo.F) + '&space(5)&c^(-1)',
      vtbl.Cells[0, 0]);

  // Добавляем сведения о элементах цепи
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    // Сопротивление
    if Assigned(FElementList.r[i]) then
    begin
      vStr := 'R_' + IntToStr(i + 1);
      AddFormulaValue(vStr, PrepareDouble(FElementList.r[i].Value), 'Ом');
    end;
    // Катушка
    if Assigned(FElementList.l[i]) then
    begin
      if SchemaInfo.CalcType = ctRLC then
      begin
        vStr := 'L_' + IntToStr(i + 1);
        AddFormulaValue(vStr, PrepareDouble(FElementList.l[i].Value), 'Гн');
      end
      else
      begin
        vStr := 'X_L_' + IntToStr(i + 1);
        AddFormulaValue(vStr, PrepareDouble(FElementList.l[i].Value), 'Ом');
      end;
    end;

    // Емкость
    if Assigned(FElementList.c[i]) then
    begin
      if SchemaInfo.CalcType = ctRLC then
      begin
        vStr := 'C_' + IntToStr(i + 1);
        AddFormulaValue(vStr, PrepareDouble(FElementList.c[i].Value,
          True), 'Ф');
      end
      else
      begin
        vStr := 'X_C_' + IntToStr(i + 1);
        AddFormulaValue(vStr, PrepareDouble(FElementList.c[i].Value), 'Ом');
      end;
    end;
  end;

  vtbl.Cells[0, 0].AddBreak;

  // Пишем, что надо найти

  AddText(lc('Task'), True);

  // Формируем строку с тем, что нужно найти
  vStr := 'Z';
  if SchemaInfo.AddParamType <> apU then
    vStr := vStr + ',U';
  if SchemaInfo.AddParamType <> apI then
    vStr := vStr + ',I';
  if SchemaInfo.AddParamType <> apS then
    vStr := vStr + ',S';
  if SchemaInfo.AddParamType <> apQ then
    vStr := vStr + ',Q';
  if SchemaInfo.AddParamType <> apP then
    vStr := vStr + ',P';
  if (SchemaInfo.CalcType = ctRLC) and (SchemaInfo.W <= 0) then
    vStr := vStr + ',omega';

  AddFormulaValue(vStr, '');

  vStr := '';
  // Формируем строку с токами
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    //Пропускаем надпись о токе в ветке, если он уже задан
    if (SchemaInfo.AddParamType = apIi) and (SchemaInfo.AddParamNodeNum = i+1) then
      continue;
    vStr := vStr + ',I_' + IntToStr(i + 1);
  end;
  // Выкусываем запятую
  vStr := Copy(vStr, 2, Length(vStr) - 1);
  AddFormulaValue(vStr, '');
  AddFormulaValue('phi,cos(phi)', '');

  // Рисуем схему
  vBitmap := TBitmap.Create;
  DrawSchema(vBitmap);
  vtbl.Cells[0, 1].Clear;
  vtbl.Cells[0, 1].AddPictureEx('schema', vBitmap, 0, rvvaAbsMiddle);

  vtbl.ResizeRow(0, vtbl.Rows[0].GetBestHeight);
  vtbl.ResizeCol(0, 150, True);
end;

procedure TSolver.RunSolve;
begin
  FRichView.Clear;

  // Рисуем условие
  PrintTask;

  // Рисуем заголовок
  PrintHeader;

  // Выводим первый модуль
  PrintModule1;

  // Выводим второй модуль
  PrintModule2;

  // Для типов дополнительны параметров,
  // для которых вычисляются токи в 2 этапа выполняем вычисления сразу
  case SchemaInfo.AddParamType of
    apU, apPRi, apUri, apUli, apUci, apQli, apQci, apSi, apIi:
      begin
        PrintFindI;
        PrintModule3;
      end;
  else
    // Для сложных параметров
    begin
      PrintModule6;
      PrintFindIByR;
      PrintModule7;
    end;
  end;

  PrintModule8;
  PrintDiagram;
  if SchemaInfo.CalcType = ctRLC then
    PrintGraphics;

  FRichView.ScrollTo(0);

end;

end.
