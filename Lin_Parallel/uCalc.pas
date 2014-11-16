unit uCalc;

// Собственно основной модуль рассчета

interface

uses RVEdit, Graphics, uConsts, uElements, VCLTee.TeEngine, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.Series;

type
  // Собственно класс, реализующий рассчеты
  TSolver = class
  private
    FBitmapMain: TBitmap;
    FBitmapScale: TBitmap;
    FElementList: TRLCList;
    FRichView: TRichViewEdit;
    FSerU: TLineSeries;
    FSerI: TLineSeries;
    FChrtTotal: TChart;
    FCrtI: TChart;
    procedure AddFormula(AFormula: String); overload;
    procedure AddFormula(AFormula: String; NodeNo: Integer); overload;

    function  PrepareFormulaNodeno(AFormula: String; ANodeNo: INteger = -1000): String;

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
    //Поиск общего сопротивления
    procedure PrintModuleZtotal;
    //Вычисление тока по доп параметру
    procedure PrintFindIByAddParam;



    // Печатает процедуру поиска токов в   ветках
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
    // Печатает 9 модуль
    procedure PrintModule9;
    // Выводит графики
    procedure PrintGraphics;
    function GetSchemaInfo: TSchemaInfo;
  public
    IsScaleInit: Boolean;
    vScaleI: Double;
    vScaleU: Double;
    vX0: Double;
    vY0: Double;

    // Печатает векторные диаграммы
    procedure PrintDiagram;
    procedure PrintDiagramPrefix;
    property SchemaInfo: TSchemaInfo read GetSchemaInfo;
    constructor Create(AElementList: TRLCList; ARichView: TRichViewEdit;
      ASerU, ASerI: TLineSeries; AChrtTotal, ACrtI: TChart);
    procedure RunSolve;
    property BitmapScale: TBitmap read FBitmapScale;
    property BitmapMain: TBitmap read FBitmapMain;
  end;

  // Возвращает истина, если параметр определен
function IsParamAssigned(AValue: double): Boolean;

implementation

uses SysUtils, RVStyle, Types, uGraphicUtils, ExprDraw, ExprMake,
  uLocalizeShared,
  uFormulaUtils, Math, uStringUtils, uStringUtilsShared, StrUtils, RVTable,
  Forms, ArrowUnit,
  uConstsShared, uRounding, jclMath,
  uComplexUtils;


function IsParamAssigned(AValue: double): Boolean;
begin
  Result := not(AValue = cnstNotSetValue);
end;

{ TSolver }


constructor TSolver.Create(AElementList: TRLCList; ARichView: TRichViewEdit;
  ASerU, ASerI: TLineSeries; AChrtTotal, ACrtI: TChart);
begin
  IsScaleInit := False;
  FElementList := AElementList;
  FRichView := ARichView;
  FSerU := ASerU;
  FSerI := ASerI;
  FChrtTotal := AChrtTotal;
  FCrtI := ACrtI;
  FBitmapMain := TBitmap.Create;
  FBitmapScale := TBitmap.Create;
end;

procedure TSolver.DrawSchema(Abitmap: TBitmap);
const
  cnstElementsDelta = 20;
  cnstNodeWidth = 80;
  cnstNodeHeight = 150;
  //Длина последовательной ветки
  cnstLinWidth = 120;
  cnstElementWidth = 20;
  cnstHeightMargins = 20;
  cnstWidthMargins = 30;
var
  vWidth: Integer;
  i, vOffset, vCurX: Integer;
  vElement: TElementItem;
begin
  vWidth := (FElementList.NodesCount-1) * cnstNodeWidth + cnstLinWidth;
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
  Abitmap.Canvas.TextOut(cnstWidthMargins - Abitmap.Canvas.TextWidth('~U') - 7,
    (cnstNodeHeight - Abitmap.Canvas.TextHeight('~U')) div 2 +
    cnstHeightMargins, '~U');
  Abitmap.Canvas.Font.Size := 10;

  // Рисуем стрелку с током
  uGraphicUtils.DrawHorzArrow('I', '1', cnstWidthMargins + 20, cnstHeightMargins,
    Abitmap.Canvas);

  //Рисуем элементы последовательной цепи
  vOffset := cnstWidthMargins + 20;
  if Assigned(FElementList.r[0]) then
    begin
      vOffset := vOffset + cnstElementsDelta;
      FElementList.r[0].DrawItem(vOffset, cnstHeightMargins,  Abitmap.Canvas);
      vOffset := vOffset + FElementList.r[0].ElementWidth;
    end;

  if Assigned(FElementList.l[0]) then
  begin
    vOffset := vOffset + cnstElementsDelta;
      FElementList.l[0].DrawItem(vOffset, cnstHeightMargins,  Abitmap.Canvas);
      vOffset := vOffset + FElementList.l[0].ElementWidth;
  end;

  if Assigned(FElementList.c[0]) then
  begin
    vOffset := vOffset + cnstElementsDelta;
      FElementList.c[0].DrawItem(vOffset, cnstHeightMargins,  Abitmap.Canvas);
      vOffset := vOffset + FElementList.c[0].ElementWidth;
  end;



  for i := 1 to FElementList.NodesCount-1 do
  begin
    // Рисуем вертикальную линию
    vCurX := cnstWidthMargins + i * cnstNodeWidth+cnstLinWidth;

    {Abitmap.Canvas.Font.Size := cnstNormalFontSize;
    Abitmap.Canvas.TextOut(vCurX - 5, cnstHeightMargins - 18,
      GetLetterNodeBegin(i));}

    Abitmap.Canvas.MoveTo(vCurX, cnstHeightMargins);
    Abitmap.Canvas.LineTo(vCurX, cnstHeightMargins + cnstNodeHeight);
    vOffset := cnstHeightMargins;
    // Рисуем сами элементы в ветках

    // R
    uGraphicUtils.DrawVertArrow('I', IntToStr(i+1), vCurX,
      vOffset + cnstElementsDelta div 2 + 5, Abitmap.Canvas);
    vOffset := vOffset + 10;
    if Assigned(FElementList.r[i]) then
    begin
      vOffset := vOffset + cnstElementsDelta;
      FElementList.r[i].DrawItem(vCurX, vOffset, Abitmap.Canvas);
      vOffset := vOffset + FElementList.r[i].ElementHeight;
    end;

    // L
    if Assigned(FElementList.l[i]) then
    begin
      vOffset := vOffset + cnstElementsDelta;
      FElementList.l[i].DrawItem(vCurX, vOffset, Abitmap.Canvas);
      vOffset := vOffset + FElementList.l[i].ElementHeight;
    end;

    // C
    if Assigned(FElementList.c[i]) then
    begin
      vOffset := vOffset + cnstElementsDelta;
      FElementList.c[i].DrawItem(vCurX, vOffset, Abitmap.Canvas);
      vOffset := vOffset + FElementList.c[i].ElementHeight;
    end;

    // Буквы в концке
    {Abitmap.Canvas.Font.Size := cnstNormalFontSize;
    Abitmap.Canvas.TextOut(vCurX - 5, cnstHeightMargins + cnstNodeHeight + 2,
      GetLetterNodeEnd(i));}

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

var
  tmp: TRectComplex;
  vMultI, vMultU: double;
  vMaxA, vMaxR, vMinA, vMinR: double;
  iA, iR: double;
  x0, y0: double;
  koeffI, koeffU: double;
  i: Integer;
  vSumA, vSumR: double;
  vLastX, vlastY: double;
  vStr: String;
  U1, UParal, U: TRectComplex;

  vMaxX, vMinX, vMaxY, vMiny: Double;
  vSumI: TRectComplex;

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

  function TyU(y: double; IsUseMargins: Boolean = True): Integer;
  begin
    Result := -Round(y / koeffU);
    if IsUseMargins then
      Result := Result + cnstMargins;
  end;

// Рисует масштабные коэффициенты
  procedure DrawMultKoeff;
  const
    vStartY = 20;
  begin

    BitmapScale.Width := 80;
    BitmapScale.Height := 80;
    ClearImage(BitmapScale);
    BitmapScale.Canvas.MoveTo(60 - 50, vStartY);
    BitmapScale.Canvas.LineTo(60, vStartY);
    BitmapScale.Canvas.TextOut(60 - 50+5, vStartY - 20,
      PrepareDouble(vScaleU) + ' B');
    BitmapScale.Canvas.MoveTo(60, vStartY - 5);
    BitmapScale.Canvas.LineTo(60, vStartY + 5);
    BitmapScale.Canvas.MoveTo(60 - 50, vStartY - 5);
    BitmapScale.Canvas.LineTo(60 - 50, vStartY + 5);

    BitmapScale.Canvas.MoveTo(60 - 50, vStartY + 40);
    BitmapScale.Canvas.LineTo(60, vStartY + 40);
    BitmapScale.Canvas.TextOut(60 - 45, vStartY + 20,
      PrepareDouble(50 * koeffI) + ' A');
    BitmapScale.Canvas.MoveTo(60 - 50, vStartY + 35);
    BitmapScale.Canvas.LineTo(60 - 50, vStartY + 45);
    BitmapScale.Canvas.MoveTo(60, vStartY + 35);
    BitmapScale.Canvas.LineTo(60, vStartY + 45);
  end;

  procedure DrawAngle(V: TRectComplex; AFormula: String; IsU: Boolean = True);
  var
    vAngle: double;
    r: Integer;
  begin
   // Угол
   vAngle := TPolarComplex(V).Angle;
   if Abs(vAngle) <= 0.001 then
     Exit;
   if IsU then
     r := Trunc(TxU(TPolarComplex(V).Radius)*2/3)
   else
     r := Trunc(TxI(TPolarComplex(V).Radius)*2/3);
  { BitmapMain.Canvas.Pen.Color := clBlue;
   BitmapMain.Canvas.Brush.Color := clWhite;   }

 {  if Math.RadToDeg(vAngle) > 0 then
   begin
   }

     if vAngle > 0 then

      BitmapMain.Canvas.Arc(Trunc(x0-r*sqrt(2)/2)+cnstMargins, Trunc(y0-r*sqrt(2)/2)+cnstMargins,
        Trunc(x0+r*sqrt(2)/2)+cnstMargins, Trunc(y0+r*sqrt(2)/2)+cnstMargins,
        Trunc(x0+r)+cnstMargins, Trunc(y0)+cnstMargins,
        Trunc(x0+r*cos(vAngle))+cnstMargins, Trunc(y0-r*sin(vAngle))+cnstMargins)
     else
      BitmapMain.Canvas.Arc(Trunc(x0-r*sqrt(2)/2)+cnstMargins, Trunc(y0-r*sqrt(2)/2)+cnstMargins,
        Trunc(x0+r*sqrt(2)/2)+cnstMargins, Trunc(y0+r*sqrt(2)/2)+cnstMargins,
        Trunc(x0+r*cos(vAngle))+cnstMargins, Trunc(y0-r*sin(vAngle))+cnstMargins,
        Trunc(x0+r)+cnstMargins, Trunc(y0)+cnstMargins);

     //BitmapMain.Canvas.MoveTo(Trunc(x0 + r)+cnstMargins, Trunc(y0)+cnstMargins);
     //BitmapMain.Canvas.AngleArc(Trunc(x0)+cnstMargins, Trunc(y0)+cnstMargins, r, 0, Math.RadToDeg(vAngle));
  { end
   else
   begin
     BitmapMain.Canvas.MoveTo(Trunc(x0+r*cos(vAngle))+cnstMargins, Trunc(y0-r*sin(vAngle))+cnstMargins);
     BitmapMain.Canvas.AngleArc(Trunc(x0)+cnstMargins, Trunc(y0)+cnstMargins, r, Math.RadToDeg(vAngle), 0);
   end;  }

   InsertFormulaIntoPictureEx(FBitmapMain,
      Trunc(x0+cnstMargins) + Trunc(r * cos(vAngle/ 2)) + 10,
      Trunc(y0+cnstMargins) - Trunc(r * sin(vAngle / 2)),AFormula);
  end;

begin

  BitmapMain.Width := MaxWidth + cnstMargins;
  BitmapMain.Height := MaxHeight + cnstMargins;
  ClearImage(BitmapMain);


  vMaxX := TRectComplex(FElementList.getI_(0)).Re;
  vMinx := vMaxX;

  vMinY := TRectComplex(FElementList.getI_(0)).Im;
  vMaxY := vMinY;

  vSumI := 0;
  for i := 0 to FElementList.NodesCount-1 do
    vSumI := vSumI +FElementList.GetI_(i);

  for i := 0 to FElementList.NodesCount  do
  begin
    if i<FElementList.NodesCount then
      tmp := TRectComplex(FElementList.GetI_(i))
    else
      tmp :=  vSumI;
    if tmp.Re > vMaxX then
      vMaxX := tmp.Re;

    if tmp.Re < vMinX then
      vMinX := tmp.Re;

    if tmp.Im < vMinY then
      vMinY := tmp.Im;

    if tmp.Im > vMaxY then
      vMaxY := tmp.Im;
  end;

  if vMinX > 0 then
    vMinX := 0;
  if vMaxX < 0 then
    vMaxX := 0;

  if vMaxY < 0 then
    vMaxY := 0;

  if vMinY > 0 then
    vMinY := 0;

  U1 := FElementList.GetU1;
  UParal := FElementList.GetUParal;
  U := U1+Uparal;


  if not IsScaleInit then
  begin
     vScaleI := 50*KoeffI;
     vScaleU := 50*KoeffU;
     //Автоматический рассчет
     x0 := (MaxWidth - 2*cnstMargins) div 2;
     y0 := (MaxHeight - 2*cnstMargins) div 2;
     vX0 := x0;
     vY0 := y0;
     koeffI := GetMultKoeff(Max(vMaxX-vMinx, vMaxY-vMinY ), (MaxWidth - 2*cnstMargins) div 2, True);
     koeffU := GetMultKoeff(MaxValue([U1.Re, UParal.Re, U.Re, U1.Im, UParal.Im, U.Im, 0])-
        MinValue([U1.Re, UParal.Re, U.Re, U1.Im, UParal.Im, U.Im, 0]), (MaxWidth - 2*cnstMargins) div 2, True);

  end
  else
  begin
    KoeffI := vScaleI/50;
    KoeffU := vScaleU/50;
    x0 := vx0;
    y0 := vY0;
  end;



  //Рисуем координатные прямые
  DrawArrow(cnstMargins, Trunc(y0)+cnstMargins, MaxWidth-cnstMargins, Trunc(y0)+cnstMargins, false, BitmapMain.Canvas, clBlack, 1);
  DrawArrow(Trunc(x0)+cnstMargins, MaxHeight - cnstMargins, Trunc(x0)+cnstMargins, cnstMargins, false, BitmapMain.Canvas, clBlack, 1);

  DrawIndexedText('+j', '', Trunc(x0)+cnstMargins-15, 5+cnstMargins, BitmapMain.Canvas);
  DrawIndexedText('+i', '', MaxWidth-cnstMargins-10, Trunc(y0)+cnstMargins+10, BitmapMain.Canvas);

  //Рисуем токи
  for i := 0 to FElementList.NodesCount-1 do
  begin
    tmp :=  TRectComplex(FElementList.GetI_(i));
    DrawArrow(Trunc(x0)+cnstMargins, Trunc(y0)+cnstMargins, TxI(tmp.Re)+Trunc(x0), TyI(tmp.Im)+Trunc(y0), false, BitmapMain.Canvas);
    InsertFormulaIntoPictureEx(FBitmapMain, TxI(tmp.Re)+Trunc(x0)+5, TyI(tmp.Im)+Trunc(y0)+5, 'I_'+IntToStr(i+1));
    DrawAngle(tmp, 'phi_I_'+IntToStr(i+1), false);

     //DrawIndexedText('I', IntToStr(i+1),  TxI(tmp.Re)+Trunc(x0)+5, TyI(tmp.Im)+Trunc(y0)+5, BitmapMain.Canvas);

   {  r := (i + 1) * cnstPhiRadStep;
    // Угол
    BitmapMain.Canvas.MoveTo(TxI(x0) + r, TyI(y0));
    BitmapMain.Canvas.AngleArc(TxI(x0), TyI(y0), r, 0, Math.RadToDeg(FElementList.GetI_(i).Angle));}
  end;

  //Рисуем общий ток
 { tmp :=  TRectComplex(vSumI);
  DrawArrow(Trunc(x0)+cnstMargins, Trunc(y0)+cnstMargins, TxI(tmp.Re)+Trunc(x0), TyI(tmp.Im)+Trunc(y0), false, BitmapMain.Canvas);
  InsertFormulaIntoPictureEx(FBitmapMain, TxI(tmp.Re)+Trunc(x0)+5, TyI(tmp.Im)+Trunc(y0)+5, 'I');}
  //DrawIndexedText('I', '',  TxI(tmp.Re)+Trunc(x0)+5, TyI(tmp.Im)+Trunc(y0)+5, BitmapMain.Canvas);


  //Рисуем напряжение
   DrawArrow(Trunc(x0)+cnstMargins, Trunc(y0)+cnstMargins, TxU(U1.Re)+Trunc(x0), TyU(U1.Im)+Trunc(y0), false, BitmapMain.Canvas);
   //DrawIndexedText('U', '1', TxU(U1.Re)+Trunc(x0)+5, TyU(U1.Im)+Trunc(y0)+5, BitmapMain.Canvas);
   InsertFormulaIntoPictureEx(FBitmapMain, TxU(U1.Re)+Trunc(x0)+5, TyU(U1.Im)+Trunc(y0)+5, 'U_1');
   // Угол
   DrawAngle(U1, 'phi_U_1');


   DrawArrow(Trunc(x0)+cnstMargins, Trunc(y0)+cnstMargins, TxU(UParal.Re)+Trunc(x0), TyU(UParal.Im)+Trunc(y0), false, BitmapMain.Canvas);
   //DrawIndexedText('U', 'пар', TxU(UParal.Re)+Trunc(x0)+5, TyU(UParal.Im)+Trunc(y0)+5, BitmapMain.Canvas);
   InsertFormulaIntoPictureEx(FBitmapMain, TxU(UParal.Re)+Trunc(x0)+5, TyU(UParal.Im)+Trunc(y0)+5, 'U_String(пар)');
   DrawAngle(UParal, 'phi_U_String(парал)');

   DrawArrow(Trunc(x0)+cnstMargins, Trunc(y0)+cnstMargins, TxU(U.Re)+Trunc(x0), TyU(U.Im)+Trunc(y0), false, BitmapMain.Canvas);
   InsertFormulaIntoPictureEx(FBitmapMain, TxU(U.Re)+Trunc(x0)+5, TyU(U.Im)+Trunc(y0)+5, 'U');
   DrawAngle(U, 'phi_U');

   //Пунктирные линии
   DrawArrow(TxU(U1.Re)+Trunc(x0), TyU(U1.Im)+Trunc(y0), TxU(U.Re)+Trunc(x0), TyU(U.Im)+Trunc(y0), true, BitmapMain.Canvas);
  // DrawArrow(TxU(UParal.Re)+Trunc(x0), TyU(UParal.Im)+Trunc(y0), TxU(U.Re)+Trunc(x0), TyU(U.Im)+Trunc(y0), true, BitmapMain.Canvas);

  // Пунктирные линии для токов
 { tmp := FElementList.GetI_(0);
  vLastX := tmp.Re;
  vlastY := tmp.Im;
  for i := 1 to FElementList.NodesCount - 1 do
  begin
    tmp := FElementList.GetI_(i);
    DrawArrow(TxI(vLastX) + Trunc(x0), TyI(vlastY) + Trunc(y0),
      TxI(tmp.Re + vLastX) + Trunc(x0),
      TyI(tmp.Im + vlastY) + Trunc(y0), True, BitmapMain.Canvas);
    vLastX := vLastX + tmp.Re;
    vlastY := vlastY + tmp.Im;
  end;
  }

  {tmp := FElementList.GetI_(FElementList.NodesCount - 1);
  vLastX := tmp.Re;
  vLastY := tmp.Im;
  tmp := TRectComplex(vSumI);

  DrawArrow(TxI(vLastX) + Trunc(x0), TyI(vlastY) + Trunc(y0),
      TxI(tmp.Re) + Trunc(x0),
      TyI(tmp.Im) + Trunc(y0), True, BitmapMain.Canvas);}



  // Уменьшаем Высоту диаграммы на случай, если ее ширина будет значительно превосходить выосту
  {BitmapMain.Height := Round(MaxValue([Abs(vSumR), vMaxR - vMinR, vSumR - vMinR]) /
    koeffI) + 2 * cnstMargins;}

 { // Рисуем токи в ветвях
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    DrawArrow(TxI(x0), TyI(y0), TxI(FElementList.iA[i] + x0),
      TyI(-FElementList.iR[i] + y0), false, BitmapMain.Canvas);
    DrawIndexedText('I', IntToStr(i + 1), TxI(x0 + FElementList.iA[i]) + 20,
      TyI(y0 - FElementList.iR[i]) + 5, BitmapMain.Canvas);
    r := (i + 1) * cnstPhiRadStep;
    // Угол
    BitmapMain.Canvas.MoveTo(TxI(x0) + r, TyI(y0));
    BitmapMain.Canvas.AngleArc(TxI(x0), TyI(y0), r, 0, -FElementList.Phi0[i]);

    DrawIndexedText('φ', IntToStr(i + 1),
      TxI(x0) + Trunc(r * cos(FElementList.Phi[i] / 2)) + 10,
      TyI(y0) + Trunc(r * sin(FElementList.Phi[i] / 2)), BitmapMain.Canvas);

    DrawIndexedText('=' + PrepareDouble(FElementList.Phi0[i]) + '°', '',
      TxI(x0) + Trunc(r * cos(FElementList.Phi[i] / 2)) + 30,
      TyI(y0) + Trunc(r * sin(FElementList.Phi[i] / 2)), BitmapMain.Canvas);

    // Проекция на ось Х
    DrawArrow(TxI(FElementList.iA[i] + x0), TyI(-FElementList.iR[i] + y0),
      TxI(FElementList.iA[i] + x0), TyI(y0), True, BitmapMain.Canvas, clBlack,
      1, amNone);
    DrawArrow(TxI(x0), TyI(y0), TxI(FElementList.iA[i] + x0), TyI(y0), false,
      BitmapMain.Canvas, clBlack, 1, amArrow);
    DrawIndexedText('I', 'a' + IntToStr(i + 1), TxI(FElementList.iA[i] + x0),
      TyI(y0) + 10, BitmapMain.Canvas);
    // Проекция на ось Y
    DrawArrow(TxI(FElementList.iA[i] + x0), TyI(-FElementList.iR[i] + y0),
      TxI(x0), TyI(-FElementList.iR[i] + y0), True, BitmapMain.Canvas, clBlack,
      1, amNone);
    DrawArrow(TxI(x0), TyI(y0), TxI(x0), TyI(-FElementList.iR[i] + y0), false,
      BitmapMain.Canvas, clBlack, 1, amArrow);
    DrawIndexedText('I', 'р' + IntToStr(i + 1), 1,
      TyI(-FElementList.iR[i] + y0), BitmapMain.Canvas);
  end;

  // НАЧАЛО Рисуем общий ток
  Inc(r, cnstPhiRadStep);
  DrawArrow(TxI(x0), TyI(y0), TxI(vSumA + x0), TyI(vSumR + y0), false,
    BitmapMain.Canvas);
  DrawIndexedText('I', '', TxI(x0 + vSumA) + 20, TyI(y0 + vSumR) + 5,
    BitmapMain.Canvas);

  // Угол
  r := r + 40;
  BitmapMain.Canvas.MoveTo(TxI(x0) + r, TyI(y0));
  BitmapMain.Canvas.AngleArc(TxI(x0), TyI(y0), r, 0,
    -Math.RadToDeg(FElementList.PhiTotal));
  DrawIndexedText('φ=' + PrepareDouble(Math.RadToDeg(FElementList.PhiTotal)) + '°',
    '', TxI(x0) + Trunc(r * cos(FElementList.PhiTotal / 2)) + 10,
    TyI(y0) + Trunc(r * sin(FElementList.PhiTotal / 2)), BitmapMain.Canvas);

  // КОНЕЦ. Рисуем общий ток

  // Рисуем пунктиром
  vLastX := FElementList.iA[0];
  vlastY := -FElementList.iR[0];
  for i := 1 to FElementList.NodesCount - 1 do
  begin
    DrawArrow(TxI(vLastX + x0), TyI(vlastY + y0),
      TxI(FElementList.iA[i] + vLastX + x0),
      TyI(-FElementList.iR[i] + vlastY + y0), True, BitmapMain.Canvas);
    vLastX := vLastX + FElementList.iA[i];
    vlastY := vlastY + -FElementList.iR[i];
  end;

  // Рисуем напряжение
  koeffU := GetMultKoeff(Abs(FElementList.U), MaxWidth / 2 - 40);
  DrawArrow(TxU(x0), TyI(y0), TxU(FElementList.U + x0), TyI(y0), false,
    BitmapMain.Canvas);
  DrawIndexedText('U', '', TxU(x0 + FElementList.U) + 10, TyI(y0) + 9,
    BitmapMain.Canvas);  }

  DrawMultKoeff;
 

end;

procedure TSolver.PrintDiagramPrefix;
var tmp: TRectComplex;
    i: Integer;
begin
  FRichView.InsertTextW(#13#10 + lc('Diagram#1') + #13#10);
  tmp := FElementList.GetU1;
  RVAddFormula('Points(U)_1=U_1*.e^(j*.psi_U_1)='+TComplexFormula(tmp).GetPolarFormulaStr(cU),
     FRichView);
  FRichView.InsertTextW('B'#13#10);
  tmp := FElementList.GetUTotal;
   RVAddFormula('Points(U)=U*.e^(j*.psi_U)='+TComplexFormula(tmp).GetPolarFormulaStr(cU),
     FRichView);
  FRichView.InsertTextW('B'#13#10);
  tmp := FElementList.GetUParal;
  RVAddFormula('Points(U)_String(парал)=U_String(парал)*.e^(j*.psi_U_String(парал))='+TComplexFormula(tmp).GetPolarFormulaStr(cU),
     FRichView);
  FRichView.InsertTextW('B'#13#10);
  for i := 0 to FElementList.NodesCount-1 do
  begin
   tmp := FElementList.GetI_(i);
   RVAddFormula(
    ReplaceStr('Points(I)_%s=I_%s*.e^(j*.psi_I_%s)='+TComplexFormula(tmp).GetPolarFormulaStr(cI), '%s',
     IntToStr(i+1)), FRichView);
    FRichView.InsertTextW('A'#13#10);
  end;
  FRichView.InsertTextW(#13#10 + lc('Diagram#2') + #13#10);
  RVAddFormula('Points(U)_1+Points(U)_String(парал)=Points(U)', FRichView);
  FRichView.InsertTextW(#13#10);
  RVAddFormula('Points(I)=Summa(Points(I)_i, i)', FRichView);

end;

procedure TSolver.PrintFindI;
var
  vFormulaStr: String;
  i: Integer;
begin
  {if SchemaInfo.AddParamType <> apIi then
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
  end;  }

end;


function TSolver.PrepareFormulaNodeno(AFormula: String; ANodeNo: INteger = -1000): String;
var
  vNodeNo: Integer;
begin
  if ANodeNo = -1000 then
    vNodeNo := FElementList.AddParam.NodeNo+1
  else
    vNodeNo := ANodeNo + 1;
  Result := ReplaceStr(AFormula, '%s', IntToStr(vNodeNo));
end;

procedure TSolver.AddFormula(AFormula: String);
begin
  RVAddFormula(PrepareFormulaNodeno(AFormula), FRichView);
end;

procedure TSolver.AddFormula(AFormula: String; NodeNo: Integer);
begin
    RVAddFormula(PrepareFormulaNodeno(AFormula, NodeNO), FRichView);
end;


procedure TSolver.PrintFindIByAddParam;
var
  vI, vIMax: Double;
  vIStr: String;
  vIComplex, vIComplexMax: TPolarComplex;
  vIComplexStr: String;
  vAddParam: TAddParam;
  s: String;
  vMsgI: String;


begin
  vAddParam := FElementList.AddParam;
  vI := FElementList.GetIByAddParam;
  vIStr := RndArr.FormatDoubleStr(vI, cI);
  vIComplex := FElementList.GetIByAddParamC;
  vIComplexMax := vIComplex * sqrt(2);
  vIMax := vI * sqrt(2);
  vIComplexStr := TComplexFormula(vIComplex).GetPolarFormulaStr(cI);

  if vAddParam.NodeNo > 0 then
    vMsgI := Format(#13#10+lc('IAdd#I_')+#13#10, [ vAddParam.NodeNo+1])
  else
    vMsgI := #13#10+lc('IAdd#I')+#13#10;


  //U, psi_U
  if (vAddParam.AddParamType = apU) and
     (vAddParam.NodeNo = cnstNotSetValue) then
  begin
    FRichView.InsertTextW(vMsgI);
    RVAddFormula('I_1=U/Z='+vIStr, FRichView);
    FRichView.InsertTextW(' A'#13#10);
    FRichView.InsertTextW(lc('IAdd#IC')+#13#10);
    RVAddFormula('Points(I_1)=Points(U)/Bline(Z)=(U*.e^(j*.psi_U))/(Z*.e^(j*.phi))='+
      vIComplexStr, FRichView);
    FRichView.InsertTextW(' A'#13#10);
  end;

  //Umax psi_U
  if (vAddParam.AddParamType = apUmax) and (vAddParam.NodeNo = cnstNotSetValue) then
  begin
    FRichView.InsertTextW(#13#10);
    vIMax := vAddParam.Value / FElementList.ZTotal;
    vIComplexMax := vIComplex*sqrt(2);
    RVAddFormula('I_1_(max)=U_(max)/Z='+RndArr.FormatDoubleStr(vIMax, cI), FRichView);
    FRichView.InsertTextW(' A'#13#10);
    FRichView.InsertTextW(#13#10+lc('IAdd#2')+#13#10);
    RVAddFormula('Points(I)_1_(max)=Points(U)_(max)/Bline(Z)=(U_(max)*.e^(j*.psi_U))/(Z*.e^(j*.phi))='
      +TComplexFormula(vIComplexMax).GetPolarFormulaStr(cI), FRichView);
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(vMsgI);
    RVAddFormula('I_1=I_(max)_1/sqrt(2)='+RndArr.FormatDoubleStr(vI, cI), FRichView);
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(#13#10 + lc('IAdd#IC')+#13#10);
    RVAddFormula('Points(I_1)=Points(I)_(max)_1/sqrt(2)='+
       TcomplexFormula(vIComplexMax).GetPolarFormulaStr(cI) + '/sqrt(2)='+
       TcomplexFormula(vIComplex).GetPolarFormulaStr(cI), FRichView);
    FRichView.InsertTextW(' A');
  end;

  //P
  if (vAddParam.AddParamType = apP) and
     (vAddParam.NodeNo = cnstNotSetValue) then
  begin
    FRichView.InsertTextW(#13#10);
    RVAddFormula('P=I_1^2*.R', FRichView);
    FRichView.InsertTextW(vMsgI);
    RVAddFormula('I_1=sqrt(P/R)=sqrt('+RndArr.FormatDoubleStr(vAddParam.Value, cP) + '/'+
       RndArr.FormatDoubleStr(FElementList.Z_Total.Re, cR)+')='+ vIStr, FRichView);
    FRichView.InsertTextW(' A');
  end;

  //Q
  if (vAddParam.AddParamType = apQ) and
     (vAddParam.NodeNo = cnstNotSetValue) then
  begin
   FRichView.InsertTextW(#13#10);
    RVAddFormula('Q=I_1^2*.X', FRichView);
    FRichView.InsertTextW(vMsgI);
    RVAddFormula('I_1=sqrt(abs(Q/X))=sqrt('+RndArr.FormatDoubleStr(abs(vAddParam.Value), cP) + '/'+
       RndArr.FormatDoubleStr(abs(FElementList.Z_Total.Im), cR)+')='+ vIStr, FRichView);
    FRichView.InsertTextW(' A');
  end;

  //S
  if (vAddParam.AddParamType = apS) and
     (vAddParam.NodeNo = cnstNotSetValue) then
  begin
   FRichView.InsertTextW(#13#10);
    RVAddFormula('S=I_1^2*.Z', FRichView);
    FRichView.InsertTextW(#13#10+Format(lc('IAdd#I'), [1])+#13#10);
    RVAddFormula('I_1=sqrt(S/Z)=sqrt('+RndArr.FormatDoubleStr(vAddParam.Value, cP) + '/'+
       RndArr.FormatDoubleStr(FElementList.ZTotal, cR)+')='+ vIStr, FRichView);
    FRichView.InsertTextW(' A');
  end;

  //UR1
  if (vAddParam.AddParamType = apU) and
     (vAddParam.NodeNo >= 0) and
     (vAddParam.AddParamElement = apeR) then
  begin
    FRichView.InsertTextW(#13#10);
    AddFormula('U_R_%s=I_%s*.R_%s');
    FRichView.InsertTextW(#13#10);
    AddFormula('I_%s=U_R_%s/R_%s='+vIStr);
    FRichView.InsertTextW(' A'#13#10);
    FRichView.InsertTextW(lc('IAdd#IC')+#13#10);
    AddFormula('Points(I_%s)=Points(U_R_%s)/R_%s=(U_R_%s*.e^(j*.psi_U_R_%s))/R_%s=('+
      RndArr.FormatDoubleStr(vAddParam.Value, cU)+'/'+
      RndArr.FormatDoubleStr(FElementList.r[0].GetFormulaRValue(FElementList.SchemaInfo), cU)+')*.e^('+
      RndArr.FormatDoubleStr(Math.RadToDeg(vIComplex.Angle), cPhi) +'^0)='+  vIComplexStr);
    FRichView.InsertTextW(' A'#13#10);
  end;

  //UMaxRi
  if (vAddParam.AddParamType = apUmax) and
     (vAddParam.NodeNo >= 0) and
     (vAddParam.AddParamElement = apeR) then
  begin
    FRichView.InsertTextW(#13#10);
    AddFormula('U_max_R_%s=I_max_%s*.R_%s');
    FRichView.InsertTextW(#13#10);
    AddFormula('I_max_%s=U_max_R_%s/R_%s='+ RndArr.FormatDoubleStr(vI*sqrt(2), cI));
    FRichView.InsertTextW(' A'#13#10);

    FRichView.InsertTextW(#13#10+Format(lc('IAdd#2'), [1])+#13#10);
    AddFormula('Points(I)_%s_(max)=Points(U)_max_R_%s/R_%s=(U_max_R_%s*.e^(j*.psi_U_R_%s))/R_%s='
      +TComplexFormula(vIComplexMax).GetPolarFormulaStr(cI));
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(vMsgI);
    AddFormula('I_%s=I_(max)_%s/sqrt(2)='+RndArr.FormatDoubleStr(vI, cI));
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(#13#10 + lc('IAdd#IC')+#13#10);
    AddFormula('Points(I_%s)=Points(I)_(max)_%s/sqrt(2)='+
       TcomplexFormula(vIComplexMax).GetPolarFormulaStr(cI) + '/sqrt(2)='+
       TcomplexFormula(vIComplex).GetPolarFormulaStr(cI));
    FRichView.InsertTextW(' A');
  end;


  //UMaxLi
  if (vAddParam.AddParamType = apUmax) and
     (vAddParam.NodeNo >= 0) and
     (vAddParam.AddParamElement = apeL) then
  begin
    FRichView.InsertTextW(#13#10);
    AddFormula('U_max_L_%s=I_max_%s*.X_L_%s');
    FRichView.InsertTextW(#13#10);
    AddFormula('I_max_%s=U_max_L_%s/X_L_%s='+ RndArr.FormatDoubleStr(vI*sqrt(2), cI));
    FRichView.InsertTextW(' A'#13#10);

    FRichView.InsertTextW(#13#10+Format(lc('IAdd#2'), [1])+#13#10);
    AddFormula('Points(I)_%s_(max)=(U_max_L_%s*.e^(j*.psi_U_L_%s))/(X_L_%s*.e^(90^0))='+
       '(U_max_L_%s/X_L_%s)*.e^(j(psi_U_L_%s-90^0))='
      +TComplexFormula(vIComplexMax).GetPolarFormulaStr(cI));
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(vMsgI);
    AddFormula('I_%s=I_(max)_%s/sqrt(2)='+RndArr.FormatDoubleStr(vI, cI));
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(#13#10 + lc('IAdd#IC')+#13#10);
    AddFormula('Points(I_%s)=Points(I)_(max)_%s/sqrt(2)='+
       TcomplexFormula(vIComplexMax).GetPolarFormulaStr(cI) + '/sqrt(2)='+
       TcomplexFormula(vIComplex).GetPolarFormulaStr(cI));
    FRichView.InsertTextW(' A');
  end;

    //UMaxCi
  if (vAddParam.AddParamType = apUmax) and
     (vAddParam.NodeNo >= 0) and
     (vAddParam.AddParamElement = apeC) then
  begin
    FRichView.InsertTextW(#13#10);
    AddFormula('U_max_L_%s=I_max_%s*.X_C_%s');
    FRichView.InsertTextW(#13#10);
    AddFormula('I_max_%s=U_max_L_%s/X_C_%s='+ RndArr.FormatDoubleStr(vI*sqrt(2), cI));
    FRichView.InsertTextW(' A'#13#10);

    FRichView.InsertTextW(#13#10+Format(lc('IAdd#2'), [1])+#13#10);
    AddFormula('Points(I)_%s_(max)=(U_max_C_%s*.e^(j*.psi_U_C_%s))/(X_L_%s*.e^(-90^0))='+
       '(U_max_L_%s/X_C_%s)*.e^(j(psi_U_C_%s+90^0))='
      +TComplexFormula(vIComplexMax).GetPolarFormulaStr(cI));
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(vMsgI);
    AddFormula('I_%s=I_(max)_%s/sqrt(2)='+RndArr.FormatDoubleStr(vI, cI));
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(#13#10 + lc('IAdd#IC')+#13#10);
    AddFormula('Points(I_%s)=Points(I)_(max)_%s/sqrt(2)='+
       TcomplexFormula(vIComplexMax).GetPolarFormulaStr(cI) + '/sqrt(2)='+
       TcomplexFormula(vIComplex).GetPolarFormulaStr(cI));
    FRichView.InsertTextW(' A');
  end;

  //I_1
  if vAddParam.AddParamType = apI then
  begin
    FRichView.InsertTextW(#13#10 + Format(lc('IAdd#IC'), [vAddParam.NodeNo+1])+#13#10);
    AddFormula('Points(I_%s)=I_%s*.e^(j*.psi_I_%s)='+vIComplexStr);
    FRichView.InsertTextW(' A'#13#10);
  end;

  //Imax
  if vAddParam.AddParamType = apImax then
  begin
    FRichView.InsertTextW(vMsgI);
    AddFormula('I_%s=I_(max)_%s/sqrt(2)='+RndArr.FormatDoubleStr(vI, cI));
    FRichView.InsertTextW(#13#10 + Format(lc('IAdd#IC'), [vAddParam.NodeNo+1])+#13#10);
    AddFormula('Points(I_%s)=I_%s*.e^(j*.psi_I_%s)='+vIComplexStr);
    FRichView.InsertTextW(' A'#13#10);
  end;

  //UL
  if (vAddParam.AddParamType = apU) and
     (vAddParam.AddParamElement = apeL) then
  begin
   FRichView.InsertTextW(#13#10);
   AddFormula('U_L_%s=I_%s*.X_L_%s');
   FRichView.InsertTextW(vMsgI);
   AddFormula('I_%s=U_L_%s/X_L_%s='+RndArr.FormatDoubleStr(vAddParam.Value, cU)+'/'+
     RndArr.FormatDoubleStr(FElementList.l[vAddParam.NodeNo].GetFormulaRValue(FElementList.SchemaInfo), cR)+
     '='+ vIStr);
   FRichView.InsertTextW(' A'#13#10);
   FRichView.InsertTextW(lc('IAdd#IC')+#13#10);
   AddFormula('Points(I)_%s=(U_L_%s*.e^(j*.psi_U_L_%s))/(X_L_%s*.e^(j*.90^0))=(U_L_%s/X_L_%s)*.e^(j(psi_L_%s-90^0))='+
      vIComplexStr);
   FRichView.InsertTextW(' A'#13#10);
  end;

  //Uc
   if (vAddParam.AddParamType = apU) and
     (vAddParam.AddParamElement = apeC) then
  begin
   FRichView.InsertTextW(#13#10);
   AddFormula('U_C_%s=I_%s*.X_C_%s');
   FRichView.InsertTextW(vMsgI);
   AddFormula('I_%s=U_C_%s/X_C_%s='+RndArr.FormatDoubleStr(vAddParam.Value, cU)+'/'+
     RndArr.FormatDoubleStr(FElementList.c[vAddParam.NodeNo].GetFormulaRValue(FElementList.SchemaInfo), cR)+
     '='+ vIStr);
   FRichView.InsertTextW(' A'#13#10);
   FRichView.InsertTextW(lc('IAdd#IC')+#13#10);
   AddFormula('Points(I)_%s=(U_C_%s*.e^(j*.psi_U_C_%s))/(X_C_%s*.e^(-j*.90^0))=(U_C_%s/X_C_%s)*.e^(j(psi_C_%s+90^0))='+
      vIComplexStr);
   FRichView.InsertTextW(' A'#13#10);
  end;

  //U_1
   if (vAddParam.AddParamType = apU) and
     (vAddParam.NodeNo = 0) and
     (vAddParam.AddParamElement = apeNone) then
  begin
   FRichView.InsertTextW(#13#10);
   AddFormula('U_1=I_1*.Z_1');
   FRichView.InsertTextW(vMsgI);
   AddFormula('I_1=U_1/Z_1='+RndArr.FormatDoubleStr(vAddParam.Value, cU)+'/'+
     RndArr.FormatDoubleStr(FElementList.Z[vAddParam.NodeNo], cR)+
     '='+ vIStr);
   FRichView.InsertTextW(' A'#13#10);
   FRichView.InsertTextW(lc('IAdd#IC')+#13#10);
   AddFormula('Points(I)_1=Points(U_1)/Z_1=U_1*.e^(j*.psi_U_1)/Z_1=('+
      RndArr.FormatDoubleStr(vAddParam.Value, cU)+'/'+
      RndArr.FormatDoubleStr(FElementList.z[0], cR)+')*.e^('+
      RndArr.FormatDoubleStr(Math.RadToDeg(vIComplex.Angle), cPhi) +'^0)='+  vIComplexStr);
   FRichView.InsertTextW(' A'#13#10);
  end;

    //UMax_1
  if (vAddParam.AddParamType = apUmax) and
     (vAddParam.NodeNo >= 0) and
     (vAddParam.AddParamElement = apeNone) then
  begin
    FRichView.InsertTextW(#13#10);
    AddFormula('U_max_1=I_max_1*.Z_1');
    FRichView.InsertTextW(#13#10);
    AddFormula('I_max_1=U_max_1/Z_1='+ RndArr.FormatDoubleStr(vI*sqrt(2), cI));
    FRichView.InsertTextW(' A'#13#10);
    FRichView.InsertTextW(lc('IAdd#IC')+#13#10);
    FRichView.InsertTextW(#13#10+Format(lc('IAdd#2'), [1])+#13#10);
    AddFormula('Points(I)_1_(max)=Points(U)_max_1/Z_1=(U_max_1*.e^(j*.psi_U_1))/Z_1='
      +TComplexFormula(vIComplexMax).GetPolarFormulaStr(cI));
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(vMsgI);
    AddFormula('I_1=I_(max)_1/sqrt(2)='+RndArr.FormatDoubleStr(vI, cI));
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(#13#10 + lc('IAdd#IC')+#13#10);
    AddFormula('Points(I_1)=Points(I)_(max)_1/sqrt(2)='+
       TcomplexFormula(vIComplexMax).GetPolarFormulaStr(cI) + '/sqrt(2)='+
       TcomplexFormula(vIComplex).GetPolarFormulaStr(cI));
    FRichView.InsertTextW(' A');
  end;


  //Uparal
  if (vAddParam.AddParamType = apUparal) then
  begin
   FRichView.InsertTextW(#13#10);
   AddFormula('U_String(парал)=I_1*.Z_String(парал)');
   FRichView.InsertTextW(vMsgI);
   AddFormula('I_1=U_String(парал)/Z_String(парал)='+vIStr);
   FRichView.InsertTextW(' A'#13#10);
   FRichView.InsertTextW(lc('IAdd#IC')+#13#10);
   AddFormula('Points(I)_1=Points(U)_String(парал)/Bline(Z)_String(парал)='+
      '(U_String(парал)*.e^(j*.psi_U_String(парал)))/(Z_String(парал)*.e^(j*.phi_String(парал)))='+
      '(U_String(парал)/Z_String(парал))*.e^(j*(psi_U_String(парал)-phi_String(парал)))='+ vIComplexStr);
   FRichView.InsertTextW(' A'#13#10);
  end;

  //Umaxparal
  if (vAddParam.AddParamType = apUmaxParal) then
  begin
    FRichView.InsertTextW(#13#10);
    AddFormula('U_max_String(парал)=I_max_1*.Z_String(парал)');
    FRichView.InsertTextW(#13#10);
    AddFormula('I_max_1=U_max_String(парал)/Z_String(парал)='+ RndArr.FormatDoubleStr(vI*sqrt(2), cI));
    FRichView.InsertTextW(' A'#13#10);

    FRichView.InsertTextW(#13#10+Format(lc('IAdd#2'), [1])+#13#10);
    AddFormula('Points(I)_max_1=Points(U)_max_String(парал)/Bline(Z)_String(парал)='+
      '(U_max_String(парал)*.e^(j*.psi_U_String(парал)))/(Z_String(парал)*.e^(j*.phi_String(парал)))='+
      '(U_max_String(парал)/Z_String(парал))*.e^(j*(psi_U_max_String(парал)-phi_String(парал)))='
      +TComplexFormula(vIComplexMax).GetPolarFormulaStr(cI));
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(vMsgI);
    AddFormula('I_1=I_(max)_1/sqrt(2)='+RndArr.FormatDoubleStr(vI, cI));
    FRichView.InsertTextW(' A');
    FRichView.InsertTextW(#13#10 + lc('IAdd#IC')+#13#10);
    AddFormula('Points(I_1)=Points(I)_(max)_1/sqrt(2)='+
       TcomplexFormula(vIComplexMax).GetPolarFormulaStr(cI) + '/sqrt(2)='+
       TcomplexFormula(vIComplex).GetPolarFormulaStr(cI));
    FRichView.InsertTextW(' A');

  end;



   //UR
 {  if (vAddParam.AddParamType = apU) and
     (vAddParam.AddParamElement = apeR) then
  begin
   FRichView.InsertTextW(#13#10);
   AddFormula('U_R_%s=I_%s*.X_C_%s');
   FRichView.InsertTextW(vMsgI);
   AddFormula('I_%s=U_C_%s/X_C_%s='+RndArr.FormatDoubleStr(vAddParam.Value, cU)+'/'+
     RndArr.FormatDoubleStr(FElementList.c[vAddParam.NodeNo].GetFormulaRValue(FElementList.SchemaInfo), cR)+
     '='+ vIStr);
   FRichView.InsertTextW(' A'#13#10);
   FRichView.InsertTextW(lc('IAdd#IC')+#13#10);
   AddFormula('Points(I)_%s=(U_C_%s*.e^(j*.psi_U_C_%s))/(X_C_%s*.e^(-j*.90^0))=(U_C_%s/X_C_%s)*.e^(j(psi_C_%s+90^0))='+
      vIComplexStr);
   FRichView.InsertTextW(' A'#13#10);
  end;
  }

  //Pi
  if (vAddParam.AddParamType = apP) and
     (vAddParam.NodeNo > cnstNotSetValue) and
     (vAddParam.AddParamElement = apeNone) then
  begin
    FRichView.InsertTextW(#13#10);
    AddFormula('P_%s=I_%s^2*.R_%s');
    FRichView.InsertTextW(vMsgI);
    AddFormula('I_%s=sqrt(P_%s/R_%s)=sqrt('+ RndArr.FormatDoubleStr(vAddParam.Value, cP)+ '/'+
        RndArr.FormatDoubleStr(FElementList.r[vAddParam.NodeNo].GetFormulaRValue(FElementList.SchemaInfo), cR)+')='+
        vIStr);
    FRichView.InsertTextW(' A'#13#10);
  end;

  //Qi
  if (vAddParam.AddParamType = apQ) and
     (vAddParam.NodeNo > cnstNotSetValue) and
     (vAddParam.AddParamElement = apeNone) then
  begin
    FRichView.InsertTextW(#13#10);
    AddFormula('Q_%s=I_%s^2*.(X_L_%s-X_C_%s)');
    FRichView.InsertTextW(vMsgI);
    AddFormula('I_%s=sqrt(abs(Q_%s/(X_L_%s-X_C_%s)))=sqrt(abs('+ RndArr.FormatDoubleStr(vAddParam.Value, cP)+ '/('+
        RndArr.FormatDoubleStr(FElementList.l[vAddParam.NodeNo].GetFormulaRValue(FElementList.SchemaInfo), cR)+'-'+
        RndArr.FormatDoubleStr(FElementList.c[vAddParam.NodeNo].GetFormulaRValue(FElementList.SchemaInfo), cR)+ ')))='+
        vIStr);
    FRichView.InsertTextW(' A'#13#10);
  end;

  //Pi
  if (vAddParam.AddParamType = apS) and
     (vAddParam.NodeNo > cnstNotSetValue) and
     (vAddParam.AddParamElement = apeNone) then
  begin
    FRichView.InsertTextW(#13#10);
    AddFormula('S_%s=I_%s^2*.Z_%s');
    FRichView.InsertTextW(vMsgI);
    AddFormula('I_%s=sqrt(S_%s/Z_%s)=sqrt('+ RndArr.FormatDoubleStr(vAddParam.Value, cP)+ '/'+
        RndArr.FormatDoubleStr(FElementList.z[vAddParam.NodeNo], cR)+')='+
        vIStr);
    FRichView.InsertTextW(' A'#13#10);
  end;

   //QLi
  if (vAddParam.AddParamType = apQ) and
     (vAddParam.NodeNo > cnstNotSetValue) and
     (vAddParam.AddParamElement = apeL) then
  begin
    FRichView.InsertTextW(#13#10);
    AddFormula('Q_L_%s=I_%s^2*.X_L_%s');
    FRichView.InsertTextW(vMsgI);
    AddFormula('I_%s=sqrt(Q_L_%s/X_L_%s)=sqrt('+ RndArr.FormatDoubleStr(vAddParam.Value, cP)+ '/'+
        RndArr.FormatDoubleStr(FElementList.l[vAddParam.NodeNo].GetFormulaRValue(FElementList.SchemaInfo), cR)+')='+
        vIStr);
    FRichView.InsertTextW(' A'#13#10);
  end;

     //QCi
  if (vAddParam.AddParamType = apQ) and
     (vAddParam.NodeNo > cnstNotSetValue) and
     (vAddParam.AddParamElement = apeC) then
  begin
    FRichView.InsertTextW(#13#10);
    AddFormula('Q_C_%s=I_%s^2*.X_C_%s');
    FRichView.InsertTextW(vMsgI);
    AddFormula('I_%s=sqrt(abs(Q_C_%s/X_C_%s))=sqrt(abs('+ RndArr.FormatDoubleStr(vAddParam.Value, cP)+ '/'+
        RndArr.FormatDoubleStr(FElementList.c[vAddParam.NodeNo].GetFormulaRValue(FElementList.SchemaInfo), cR)+'))='+
        vIStr);
    FRichView.InsertTextW(' A'#13#10);
  end;


end;

procedure TSolver.PrintFindIByR;
var
  vStr: String;
begin
 { case SchemaInfo.AddParamType of
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
  end;}
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

  for i := 0 to FElementList.NodesCount - 1 do
  begin
    case i of
      0: FRichView.InsertTextW(#13#10 + lc('Module1#1')+#13#10);
      1: begin
           FRichView.InsertTextW(#13#10 + lc('Module1#1_')+#13#10);
           FRichView.InsertTextW(Format(lc('Part'), [i + 1])+#13#10);
         end;
    else
      FRichView.InsertTextW(#13#10 + Format(lc('Part'), [i + 1])+#13#10);
    end;
    vFormula := TFormula.Create;
    try
      FElementList.GetFormulaR(i, vFormula);
      vStr := 'Z_' + IntToStr(i + 1) + '=' + vFormula.FormulaStr + '=' +
        vFormula.GetFormulaValue + '=' + PrepareDouble(FElementList.Z[i]);
      RVAddFormula(vStr, FRichView);
      FRichView.InsertTextW(' Ом');
      FRichView.InsertTextW(#13#10 + lc('Complex')+#13#10);
      RVAddFormula(FElementList.GetZ_Formula(i), FRichView);
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

  for i := 0 to FElementList.NodesCount - 1 do
  begin
    case i of
     0: FRichView.InsertTextW(#13#10 + lc('Module2#1')+#13#10);
     1: FRichView.InsertTextW(#13#10 + lc('Module2#1_'));
    end;
    if i>0 then
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

//Рассчет напряжения в параллельной ветке
procedure TSolver.PrintModule6;
var
 vAddParam: TAddParam;
 tmp: TPolarComplex;
 i: Integer;
begin
  vAddParam := FElementList.AddParam;

  //Не задано apUparal, apUmaxParal
  if not (vAddParam.AddParamType in [apUparal, apUmaxParal]) then
  begin

    //Рассчитался только обычный ток в первой ветке
    if not vAddParam.IsResultComplex and (vAddParam.ResultNodeNo = 0) then
    begin
      FElementList.UParal.Radius := FElementList.GetIByAddParam * FElementList.Z_Parallel.Radius;
      FElementList.UParal.Angle := 0;

      FRichView.InsertTextW(#13#10+lc('Module61#1')+#13#10);
      RVAddFormula('U_String(парал)=I_1*.Z_String(парал)=' +
       RndArr.FormatDoubleStr(FElementList.GetIByAddParam, cI) + '*.' +
       RndArr.FormatDoubleStr(FElementList.Z_Parallel.Radius, Cr) + '='+
       RndArr.FormatDoubleStr(FElementList.UParal.Radius, cU), FRichView);
      FRichView.InsertTextW(' B'#13#10);
      FRichView.InsertTextW(lc('Module61#2')+#13#10);
      RVAddFormula('Points(U)_String(парал)=U_String(парал)*.e^(j*.0^0)='+
         TComplexFormula(FElementList.UParal).GetPolarFormulaStr(cU), FRichView);
      FRichView.InsertTextW(' B'#13#10);
      FRichView.InsertTextW(lc('Module61#3')+#13#10);
      RVAddFormula('Points(I)_1=Points(U)_String(парал)/Bline(Z)_String(парал)='+
         '(U_String(парал)*.e^(j*.0^0))/(Z_String(парал)*.e^(j*.phi_String(парал)))='+
         '(U_String(парал)/Z_String(парал))*.e^(-j*.phi_String(парал))='+
         TComplexFormula(FElementList.GetI_(0)).GetPolarFormulaStr(cI), FRichView);
      FRichView.InsertTextW(' A'#13#10);
      FRichView.InsertTextW(lc('Module61#4')+#13#10);
      for i := 1 to FElementList.NodesCount-1 do
      begin
        AddFormula('I_%s=U_String(парал)/Z_%s='+
          RndArr.FormatDoubleStr(FElementList.GetI_(i).Radius, cI), i);
        FRichView.InsertTextW(' A'#13#10);
        FRichView.InsertTextW(lc('Module61#5')+#13#10);
        AddFormula('Points(I)_%s=Points(U)_String(парал)/Bline(Z)_%s='+
         '(U_String(парал)*.e^(j*.0^0))/(Z_%s*.e^(j*.phi_%s))='+
         '(U_String(парал)/Z_%s)*.e^(-j*.phi_%s)='+
         TComplexFormula(FElementList.GetI_(i)).GetPolarFormulaStr(cI), i);
        FRichView.InsertTextW(' A'#13#10);
      end;
    end;


      //Рассчитался комплексный ток в 1й ветке
    if vAddParam.IsResultComplex and (vAddParam.ResultNodeNo = 0) then
    begin
      tmp := FElementList.GetIByAddParamC;
      FElementList.UParal := tmp * FElementList.Z_Parallel;

      FRichView.InsertTextW(#13#10+lc('Module62#1')+#13#10);
      RVAddFormula('Points(U)_String(парал)=I_1*.BLine(Z)_String(парал)=' +
       TComplexFormula(tmp).GetPolarFormulaStr(cI)+'*.'+
       TComplexFormula(FElementList.Z_Parallel).GetPolarFormulaStr(cR)+ '=' +
       TComplexFormula(FElementList.UParal).GetPolarFormulaStr(cU), FRichView);
      FRichView.InsertTextW(' B'#13#10);
      FRichView.InsertTextW(lc('Module62#2')+#13#10);

      for i := 1 to FElementList.NodesCount-1 do
      begin
        AddFormula('Points(I)_%s=Points(U)_String(парал)/Bline(Z)_%s='+
         '(U_String(парал)*.e^(j*.psi_0))/(Z_%s*.e^(j*.phi_%s))='+
         '(U_String(парал)/Z_%s)*.e^(j*.(psi_0-phi_%s))='+
         TComplexFormula(FElementList.GetI_(i)).GetPolarFormulaStr(cI), i);
        FRichView.InsertTextW(' A'#13#10);
      end;
    end;

      //Рассчитался комплексный ток в iй ветке
    if vAddParam.IsResultComplex and (vAddParam.ResultNodeNo > 0) then
    begin
      tmp := FElementList.GetIByAddParamC;
      FElementList.UParal := tmp *  FElementList.GetZ_(vAddParam.ResultNodeNo);

      FRichView.InsertTextW(#13#10+lc('Module65#1')+#13#10);
      AddFormula('Points(U)_String(парал)=I_%s*.BLine(Z)_%s=' +
       RndArr.FormatDoubleStr(FElementList.GetIByAddParam, cI) + '*.' +
       RndArr.FormatDoubleStr(FElementList.Z_Parallel.Radius, Cr) + '='+
       RndArr.FormatDoubleStr(FElementList.UParal.Radius, cU));
      FRichView.InsertTextW(' B'#13#10);
      FRichView.InsertTextW(lc('Module65#2')+#13#10);

      AddFormula('Points(I)_1=Points(U)_String(парал)/Bline(Z)_String(парал)='+
         '(U_String(парал)*.e^(j*.psi_0))/(Z_String(парал)*.e^(j*.phi_String(парал)))='+
         '(U_String(парал)/Z_String(парал))*.e^(j*.(psi_0-phi_String(парал)))='+
         TComplexFormula(FElementList.GetI_(0)).GetPolarFormulaStr(cI), 1);
      FRichView.InsertTextW(' А'#13#10);
      FRichView.InsertTextW(lc('Module64#3')+#13#10);

      for i := 1 to FElementList.NodesCount-1 do
      begin
        AddFormula('Points(I)_%s=Points(U)_String(парал)/Bline(Z)_%s='+
         '(U_String(парал)*.e^(j*.psi_0))/(Z_%s*.e^(j*.phi_%s))='+
         '(U_String(парал)/Z_%s)*.e^(j*.(psi_0-phi_%s))='+
         TComplexFormula(FElementList.GetI_(i)).GetPolarFormulaStr(cI), i);
        FRichView.InsertTextW(' A'#13#10);
      end;
    end;

  //Рассчитался обычный ток в iй ветке
    if not vAddParam.IsResultComplex and (vAddParam.ResultNodeNo > 0) then
    begin
      tmp.Radius := FElementList.GetIByAddParam;
      tmp.Angle := 0;
      FElementList.UParal := tmp *  FElementList.GetZ_(vAddParam.ResultNodeNo);

      FRichView.InsertTextW(#13#10+lc('Module65#1')+#13#10);
      AddFormula('U_String(парал)=I_%s*.Z_%s=' +
        TComplexFormula(tmp).GetPolarFormulaStr(cI)+'*.'+
       TComplexFormula(FElementList.GetZ_(vAddParam.ResultNodeNo)).GetPolarFormulaStr(cR)+ '=' +
       TComplexFormula(FElementList.UParal).GetPolarFormulaStr(cU));
      FRichView.InsertTextW(' B'#13#10);
      FRichView.InsertTextW(lc('Module64#2')+#13#10);

      AddFormula('Points(I)_1=Points(U)_String(парал)/Bline(Z)_String(парал)='+
         '(U_String(парал)*.e^(j*.psi_0))/(Z_String(парал)*.e^(j*.phi_String(парал)))='+
         '(U_String(парал)/Z_String(парал))*.e^(j*.(psi_0-phi_String(парал)))='+
         TComplexFormula(FElementList.GetI_(0)).GetPolarFormulaStr(cI), 1);
      FRichView.InsertTextW(' А'#13#10);
      FRichView.InsertTextW(lc('Module64#3')+#13#10);

      for i := 1 to FElementList.NodesCount-1 do
      begin
        AddFormula('Points(I)_%s=Points(U)_String(парал)/Bline(Z)_%s='+
         '(U_String(парал)*.e^(j*.psi_0))/(Z_%s*.e^(j*.phi_%s))='+
         '(U_String(парал)/Z_%s)*.e^(j*.(psi_0-phi_%s))='+
         TComplexFormula(FElementList.GetI_(i)).GetPolarFormulaStr(cI), i);
        FRichView.InsertTextW(' A'#13#10);
      end;
    end;
  end
  else
  begin
   FElementList.UParal.Radius := vAddParam.Value;
   if vAddParam.AddParamType = apUmaxParal then
      FElementList.UParal.Radius := FElementList.UParal.Radius / sqrt(2);
   FElementList.UParal.Angle := Math.DegToRad(vAddParam.W0);


   FRichView.InsertTextW(#13#10+lc('Module66#1')+#13#10);
   for i := 1 to FElementList.NodesCount-1 do
      begin
        AddFormula('Points(I)_%s=Points(U)_String(парал)/Bline(Z)_%s='+
         '(U_String(парал)*.e^(j*.psi_0))/(Z_%s*.e^(j*.phi_%s))='+
         '(U_String(парал)/Z_%s)*.e^(j*.(psi_0-phi_%s))='+
         TComplexFormula(FElementList.GetI_(i)).GetPolarFormulaStr(cI), i);
        FRichView.InsertTextW(' A'#13#10);
      end;
  end;



end;

procedure TSolver.PrintModule7;
var
  vStr: String;
  vSin: double;
  vPhi: double;
  i: Integer;
begin
   FRichView.InsertTextW(#13#10+lc('Module7#1'));
   FRichView.InsertTextW(#13#10+lc('Module7#1_1'));
   RVAddFormula(FElementList.GetUTotalFormula, FRichView);
   FRichView.InsertTextW(' В'#13#10);

   for i := 0 to FElementList.NodesCount-1 do
   begin

      if i=1 then
      begin
        FRichView.InsertTextW(lc('Module7#3')+#13#10);
        RVAddFormula(FElementList.GetUParalFormula, FRichView);
        FRichView.InsertTextW(lc('Module7#4')+#13#10);
      end;

     //Заголовок
     if i=0 then
       FRichView.InsertTextW(lc('Module7#2')+#13#10)
     else
       FRichView.InsertTextW(Format(lc('Module7#2i'), [i+1])+#13#10);

     //Ur
     if Assigned(FElementList.r[i]) then
     begin
       RVAddFormula(FElementList.GetURFormula(i), FRichView);
       FRichView.InsertTextW(' B - ');
       if i = 0 then
         FRichView.InsertTextW(lc('Module7#Ur1')+#13#10)
       else
         FRichView.InsertTextW(Format(lc('Module7#Uri'), [i+1])+#13#10);
     end;

     //Ul
     if Assigned(FElementList.l[i]) then
     begin
       RVAddFormula(FElementList.GetULFormula(i), FRichView);
       FRichView.InsertTextW(' B - ');
       if i = 0 then
         FRichView.InsertTextW(lc('Module7#Ul1')+#13#10)
       else
         FRichView.InsertTextW(Format(lc('Module7#Uli'), [i+1])+#13#10);
     end;

     //UC
     if Assigned(FElementList.c[i]) then
     begin
       RVAddFormula(FElementList.GetUCFormula(i), FRichView);
       FRichView.InsertTextW(' B - ');
       if i = 0 then
         FRichView.InsertTextW(lc('Module7#UC1')+#13#10)
       else
         FRichView.InsertTextW(Format(lc('Module7#UCi'), [i+1])+#13#10);
     end;

     //U1
     if i=0 then
     begin
       RVAddFormula(FElementList.GetU1Formula, FRichView);
       FRichView.InsertTextW(' B - ');
       FRichView.InsertTextW(lc('Module7#U1')+#13#10)
     end;

     //Pr
     if Assigned(FElementList.r[i]) then
     begin
       RVAddFormula(FElementList.GetPrFormula(i), FRichView);
       FRichView.InsertTextW(' Bт - ');
       if i = 0 then
         FRichView.InsertTextW(lc('Module7#UP1')+#13#10)
       else
         FRichView.InsertTextW(Format(lc('Module7#UPi'), [i+1])+#13#10);
     end;


     //Qli
     if Assigned(FElementList.l[i]) then
     begin
       RVAddFormula(FElementList.GetQlFormula(i), FRichView);
       FRichView.InsertTextW(' BАР - ');
       if i = 0 then
         FRichView.InsertTextW(lc('Module7#UQl1')+#13#10)
       else
         FRichView.InsertTextW(Format(lc('Module7#UQli'), [i+1])+#13#10);
     end;

       //QCi
     if Assigned(FElementList.c[i]) then
     begin
       RVAddFormula(FElementList.GetQCFormula(i), FRichView);
       FRichView.InsertTextW(' BАР - ');
       if i = 0 then
         FRichView.InsertTextW(lc('Module7#UQC1')+#13#10)
       else
         FRichView.InsertTextW(Format(lc('Module7#UQCi'), [i+1])+#13#10);
     end;

   end;

  // Ищем напряжение
{  FRichView.InsertTextW(#13#10 + lc('Module7#1') + #13#10);
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
  vPhi := Math.RadToDeg(FElementList.PhiTotal);
  vStr := 'phi=arcsin(' + PrepareDouble(vSin) + ')=' +
    PrepareDouble(vPhi) + '^0';
  RVAddFormula(vStr, FRichView);  }
end;

procedure TSolver.PrintModule8;
begin
   FRichView.InsertTextW(#13#10 + lc('Module8#1')+#13#10);
   FRichView.InsertTextW(lc('Module8#2')+#13#10);
   RVAddFormula('Points(S)=Points(U)*.Tilde(I)_1', FRichView);
   FRichView.InsertTextW(#13#10);
   RVAddFormula('Points(U)', FRichView);
   FRichView.InsertTextW(lc('Module8#3')+#13#10);
   RVAddFormula('Tilde(I)_1', FRichView);
   FRichView.InsertTextW(lc('Module8#4')+#13#10);
   RVAddFormula(FElementList.GetSFormula, FRichView);
   FRichView.InsertTextW(' В∙А'#13#10);
   FRichView.InsertTextW(lc('Module8#5')+#13#10);
   RVAddFormula(FElementList.GetPFormula, FRichView);
   FRichView.InsertTextW('Вт'#13#10);
   FRichView.InsertTextW(lc('Module8#6')+#13#10);
   RVAddFormula(FElementList.GetQFormula, FRichView);
   FRichView.InsertTextW('ВАР'#13#10);
   FRichView.InsertTextW(lc('Module8#7')+#13#10);
end;

procedure TSolver.PrintModule9;
var i: Integer;
begin
  //Когда заданы сопротивление ничего не считаем
  if SchemaInfo.CalcType = ctRXX then
     Exit;

  FRichView.InsertTextW(lc('Module9#0')+#13#10);
  for i := 0 to FElementList.NodesCount-1 do
  begin
    if i=0 then
      FRichView.InsertTextW(#13#10 + lc('Module9#1_1')+#13#10)
    else
      FRichView.InsertTextW(#13#10 + Format(lc('Module9#1_i'), [i+1])+#13#10);
   RVAddFormula(FElementList.GetIByTFormula(i), FRichView);
   FRichView.InsertTextW('A');
  end;

  //Добавляем инфу о напряжении
  FRichView.InsertTextW(#13#10+lc('Module9#2')+#13#10);
  RVAddFormula(FElementList.GetUtotalByTFormula, FRichView);
  FRichView.InsertTextW('В');
  FRichView.InsertTextW(#13#10+lc('Module9#3')+#13#10);
  RVAddFormula(FElementList.GetU1ByTFormula, FRichView);
  FRichView.InsertTextW('В');
  FRichView.InsertTextW(#13#10+lc('Module9#4')+#13#10);
  RVAddFormula(FElementList.GetUparalbyTFormula, FRichView);
  FRichView.InsertTextW('В');

end;

procedure TSolver.PrintModuleZtotal;
var
  vStr1, vStr2, vStr3: String;
begin
  FRichView.InsertTextW(#13#10 + lc('ModuleZ#1')+#13#10);
  FElementList.CalcZ_Parallel;
  FElementList.GetZ_Parallel_Formula(vStr1, vStr2, vStr3);
  RVAddFormula(vStr1, FRichView);
  FRichView.InsertTextW(#13#10);
  RVAddFormula(vStr2, FRichView);
  FRichView.InsertTextW(#13#10);
  RVAddFormula(vStr3, FRichView);
  FRichView.InsertTextW(' Ом');
  FRichView.InsertTextW(#13#10 + lc('ModuleZ#2')+#13#10);
  RVAddFormula('Z_String(парал)='+
    RndArr.FormatDoubleStr(FElementList.Z_Parallel.Radius, cR), FRichView);
  FRichView.InsertTextW(' Ом');
  FRichView.InsertTextW(#13#10 + lc('ModuleZ#3')+#13#10);
  RVAddFormula('phi_String(парал)='+
    RndArr.FormatDoubleStr(Math.RadToDeg(FElementList.Z_Parallel.Angle), cPhi)+'^0', FRichView);
  FRichView.InsertTextW(#13#10 + lc('ModuleZ#4')+#13#10);
  FElementList.CalcZ_Total;
  RVAddFormula(FElementList.GetZ_TotalFormula, FRichView);
  FRichView.InsertTextW(' Ом');
  FRichView.InsertTextW(#13#10 + lc('ModuleZ#5'));
  RVAddFormula('Z='+RndArr.FormatDoubleStr(FElementList.ZTotal, cR), FRichView);
  FRichView.InsertTextW(' Ом');
  FRichView.InsertTextW(#13#10 + lc('ModuleZ#6'));
  RVAddFormula('R=Re(Z)='+RndArr.FormatDoubleStr(FElementList.RaTotal, cR), FRichView);
  FRichView.InsertTextW(' Ом');
  FRichView.InsertTextW(#13#10 + lc('ModuleZ#7'));
  RVAddFormula('X=Im(Z)='+RndArr.FormatDoubleStr(FElementList.XrTotal, cR), FRichView);
  FRichView.InsertTextW(' Ом');
  FRichView.InsertTextW(#13#10 + lc('ModuleZ#8'));
  RVAddFormula('phi='+RndArr.FormatDoubleStr(Math.RadToDeg(FElementList.PhiTotal), cPhi)+'^0', FRichView);
  FRichView.InsertTextW(#13#10 + lc('ModuleZ#9'));
  RVAddFormula('cos(phi)=cos('+RndArr.FormatDoubleStr(Math.RadToDeg(FElementList.PhiTotal), cPhi)+'^0)='+
     RndArr.FormatDoubleStr(cos(FElementList.PhiTotal), cPhi), FRichView);
end;

procedure TSolver.PrintTask;
var
  vtbl: TRVTableItemInfo;
  vStr: String;
  BitmapMain: TBitmap;
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



  RVAddFormula(FElementList.AddParam.GetElementFormula, vtbl.Cells[0, 0]);


  {i := ord(SchemaInfo.AddParamType);
  vStr := TAddParamPrefix[i];
  // Для "индексированных" параметров добавляем еще индекс
  if SchemaInfo.AddParamType in TNeedNodeParamSet then
  begin
    vStr := vStr + '_' + IntToStr(SchemaInfo.AddParamNodeNum);
  end;
  AddFormulaValue(vStr, PrepareDouble(SchemaInfo.AddParamValue),
    TAddParamsPostfix[i]);}

  {if SchemaInfo.W0 > 0 then
    // AddFormulaValue('omega_0', PrepareDouble(SchemaInfo.W0), '^0');
    RVAddFormula('psi_0=' + PrepareDouble(SchemaInfo.W0) + '^0',
      vtbl.Cells[0, 0]);}
  if FElementList.AddParam.GetW0Fornula <> '' then
    RVAddFormula(FElementList.AddParam.GetW0Fornula, vtbl.Cells[0, 0]);
      

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
  if FElementList.AddParam.AddParamType <> apU then
    vStr := vStr + ',U';
  if FElementList.AddParam.AddParamType <> apI then
    vStr := vStr + ',I';
  if FElementList.AddParam.AddParamType <> apS then
    vStr := vStr + ',S';
  if FElementList.AddParam.AddParamType <> apQ then
    vStr := vStr + ',Q';
  if FElementList.AddParam.AddParamType <> apP then
    vStr := vStr + ',P';
  if (SchemaInfo.CalcType = ctRLC) and (SchemaInfo.W <= 0) then
    vStr := vStr + ',omega';

  AddFormulaValue(vStr, '');

  vStr := '';
  // Формируем строку с токами
  for i := 0 to FElementList.NodesCount - 1 do
  begin
    //Пропускаем надпись о токе в ветке, если он уже задан
    if (FElementList.AddParam.AddParamType = apI) and (FElementList.AddParam.NodeNo = i) then
      continue;
    vStr := vStr + ',I_' + IntToStr(i + 1);
  end;
  // Выкусываем запятую
  vStr := Copy(vStr, 2, Length(vStr) - 1);
  AddFormulaValue(vStr, '');
  AddFormulaValue('phi,cos(phi)', '');

  // Рисуем схему
  BitmapMain := TBitmap.Create;
  DrawSchema(BitmapMain);
  vtbl.Cells[0, 1].Clear;
  vtbl.Cells[0, 1].AddPictureEx('schema', BitmapMain, 0, rvvaAbsMiddle);

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

  //Ищем общее сопростивление цепи
  PrintModuleZtotal;

  //Ищем ток по дополнительному параметру
  PrintFindIByAddParam;

  //Печатаем модуль 6
  PrintModule6;

  //Печтатем модуль 7
  PrintModule7;

  //Печатаем модуль 8
  PrintModule8;

  //Печатаем модуль 9
  PrintModule9;

  PrintDiagramPrefix;
  PrintDiagram;
  PrintDiagram;
  FRichView.InsertTextW(#13#10);
  FRichView.InsertPicture('image1', BitmapScale, rvvaMiddle);
  FRichView.InsertTextW(#13#10);
  FRichView.InsertPicture('image2', BitmapMain, rvvaMiddle);
  FRichView.InsertTextW(#13#10);

  // Для типов дополнительны параметров,
  // для которых вычисляются токи в 2 этапа выполняем вычисления сразу
 { case SchemaInfo.AddParamType of
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

  if SchemaInfo.CalcType = ctRLC then
    PrintGraphics;         }

  FRichView.ScrollTo(0);

end;

end.
