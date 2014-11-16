unit uElements;

interface

uses Graphics;

type

  TElementOrientation = (arUp, arDown, arRight);

  TElement = class
  private
    Fu: Double;
    FIndex: Integer;
    FWidth: Integer;
    FHeight: Integer;
  public
    property U: Double read Fu;
    property Width: Integer read FWidth;
    procedure Draw(x, y: Integer; ACanvas: TCanvas); virtual;
    // Буква сопротивления
    function RLetter: String; virtual; abstract;
    constructor Create(U: Double; Index: Integer); virtual;
  end;

  TRElement = class(TElement)
  public
    procedure Draw(x, y: Integer; ACanvas: TCanvas); override;
    function RLetter: String; override;
    constructor Create(U: Double; Index: Integer); override;
  end;

  TLElement = class(TElement)
  public
    procedure Draw(x, y: Integer; ACanvas: TCanvas); override;
    function RLetter: String; override;
    constructor Create(U: Double; Index: Integer); override;
  end;

  TCElement = class(TElement)
  public
    procedure Draw(x, y: Integer; ACanvas: TCanvas); override;
    function RLetter: String; override;
    constructor Create(U: Double; Index: Integer); override;
  end;

  TElementArr = array of TElement;

  TSchema = class
  private
    FItemsCount: Integer;
    FElements: TElementArr;
    function GetElement(AIndex: Integer): TElement;
    function GetPhi: Double;
    function GetU: Double;
    function GetTanResult: String;
    function GetP: Double;
    function GetQ: Double;
    function GetS: Double;
  public
    I: Double;
    property Phi: Double read GetPhi;
    property U: Double read GetU;
    property P: Double read GetP;
    property Q: Double read GetQ;
    property S: Double read GetS;
    property Elements[AIndex: Integer]: TElement read GetElement;
    // Добавляет к схеме еще один элемент
    procedure AddElement(AU: Double; AOrientation: TElementOrientation);
    // Рисует схему
    procedure DrawSchema(ABitmap: TBitmap);
    // Рисует диаграмму напряжений
    procedure DrawDiagram(ABitmap: TBitmap);
    property ItemsCount: Integer read FItemsCount;
    constructor Create;

    // Возврашает формулу для рассчета тангенса угла
    function GetTanPhiFormula: String;
    // Возвращает формулу для рассчета угла по его тангенсу
    function GetPhiFormula: String;
    // Возвращает формулу для рассчета коэффициента мощности
    function GetCosPhiFormula: String;
    // Возвращает формулу для рассчета общего напряжения
    function GetUFormula: String;
    // Возвращает формулу для рассчета Z
    function GetZFormula: String;
    function GetPFormula: String;
    function GetQFormula: String;
    function GetSFormula: String;
    // Возвращает формулу сопротивления для i-ого элемента цепи
    function GetXFormula(I: Integer): String;
  end;

implementation

uses Math, uGraphicUtils, SysUtils, ArrowUnit, System.Types, uFormulaUtils,
  uStringUtilsShared, uConstsShared;

{ TElement }

constructor TElement.Create(U: Double; Index: Integer);
begin
  Fu := U;
  FIndex := Index;
end;

procedure TElement.Draw(x, y: Integer; ACanvas: TCanvas);
var
  vRect: TRect;
begin
  // Очищаем прямоугольник под элемент
  vRect := TRect.Create(x, y - FHeight div 2, x + FWidth, y + FHeight div 2);
  ACanvas.FillRect(vRect);
end;

{ TRElement }

constructor TRElement.Create(U: Double; Index: Integer);
begin
  inherited;
  FWidth := 35;
  FHeight := 15;
end;

procedure TRElement.Draw(x, y: Integer; ACanvas: TCanvas);
begin
  inherited;
  ACanvas.Rectangle(x, y - FHeight div 2, x + FWidth, y + FHeight div 2);
  DrawIndexedText('R', IntToStr(FIndex + 1), x + FWidth div 2 - 5,
    y - FHeight div 2 - 10, ACanvas);
end;

function TRElement.RLetter: String;
begin
  Result := 'R_' + IntToStr(FIndex + 1);
end;

{ TCElement }

constructor TCElement.Create(U: Double; Index: Integer);
begin
  inherited;
  FHeight := 35;
  FWidth := 10;
end;

procedure TCElement.Draw(x, y: Integer; ACanvas: TCanvas);
begin
  inherited;
  ACanvas.MoveTo(x, y - FHeight div 2);
  ACanvas.LineTo(x, y + FHeight div 2);
  ACanvas.MoveTo(x + FWidth, y - FHeight div 2);
  ACanvas.LineTo(x + FWidth, y + FHeight div 2);
  DrawIndexedText('X', 'C' + IntToStr(FIndex + 1), x + FWidth div 2 - 8,
    y - FHeight div 2 - 10, ACanvas);
end;

function TCElement.RLetter: String;
begin
  Result := 'X_(C_' + IntToStr(FIndex + 1) + ')';
end;

{ TLElement }

constructor TLElement.Create(U: Double; Index: Integer);
begin
  inherited;
  FHeight := 20;
  FWidth := 48;
end;

procedure TLElement.Draw(x, y: Integer; ACanvas: TCanvas);
const
  ArcCnt = 4;
var
  vR: Integer;
  I: Integer;
begin
  vR := Round(FWidth / ArcCnt / 2);
  for I := 1 to ArcCnt do
  begin
    ACanvas.MoveTo(x + 2 * I * vR, y);
    ACanvas.AngleArc(x + (2 * I - 1) * vR, y, vR, 0, 180);
  end;
  DrawIndexedText('X', 'L' + IntToStr(FIndex + 1), x + FWidth div 2 - 8,
    y - FHeight div 2 - 10, ACanvas);
end;

function TLElement.RLetter: String;
begin
  Result := 'X_(C_' + IntToStr(FIndex + 1) + ')';
end;

{ TSchema }

procedure TSchema.AddElement(AU: Double; AOrientation: TElementOrientation);
var
  vNewElement: TElement;
begin
  SetLength(FElements, ItemsCount + 1);
  case AOrientation of
    arUp:
      vNewElement := TLElement.Create(AU, ItemsCount);
    arDown:
      vNewElement := TCElement.Create(AU, ItemsCount);
    arRight:
      vNewElement := TRElement.Create(AU, ItemsCount);
  end;
  FElements[ItemsCount] := vNewElement;
  Inc(FItemsCount);
end;

constructor TSchema.Create;
begin
  SetLength(FElements, 0);
  FItemsCount := 0;
end;

procedure TSchema.DrawDiagram(ABitmap: TBitmap);
const
  cnstSize = 300;
  cnstMargins = 20;
  cnstR = 40;
var
  vMultKoeff: Double;
  I: Integer;
  x0, y0: Double;
  vX, Vy: Double;
  // Результирующий угол в радианах
  // vPhi: Double;

  // Подготавливает масштабные коэффициенты и координаты начала
  procedure PrepareMulfKoeff;
  var
    vMaxSum, vMinSum, vHorzSum, vVertSum: Double;
    I: Integer;
  begin
    vMaxSum := 0;
    vMinSum := 0;
    vHorzSum := 0;
    vVertSum := 0;
    for I := 0 to ItemsCount - 1 do
    begin
      if (FElements[I] is TRElement) then
        vHorzSum := vHorzSum + FElements[I].U;
      if (FElements[I] is TLElement) then
        vVertSum := vVertSum + FElements[I].U;
      if (FElements[I] is TCElement) then
        vVertSum := vVertSum - FElements[I].U;

      if vVertSum > vMaxSum then
        vMaxSum := vVertSum;

      if vVertSum < vMinSum then
        vMinSum := vVertSum;
    end;
    if vMinSum > 0 then
      vMinSum := 0;
    vMultKoeff := Max(vMaxSum - vMinSum, vHorzSum) /
      (cnstSize - 2 * cnstMargins);
    x0 := 0;
    y0 := -vMaxSum;
    if y0 > 0 then
      y0 := 0;
  end;

// Преобразует "Обычные" координаты в координаты на канве
  function Tx(x: Double; IsUseMargins: Boolean = True): Integer;
  begin
    Result := Round(x / vMultKoeff);
    if IsUseMargins then
      Result := Result + cnstMargins;
  end;

  function Ty(y: Double; IsUseMargins: Boolean = True): Integer;
  begin
    Result := -Round(y / vMultKoeff);
    if IsUseMargins then
      Result := Result + cnstMargins;
  end;

begin
  ABitmap.Width := cnstSize;
  ABitmap.Height := cnstSize;
  PrepareMulfKoeff;
  vX := x0;
  Vy := y0;
  for I := 0 to ItemsCount - 1 do
  begin
    if FElements[I] is TRElement then
    begin
      DrawHorzArrow(Tx(vX), Ty(Vy), Tx(FElements[I].U, false), false,
        ABitmap.Canvas, clBlue, 2);
      DrawIndexedText('U', IntToStr(I + 1), Tx(vX + FElements[I].U / 2) - 5,
        Ty(Vy) + 12, ABitmap.Canvas);
      vX := vX + FElements[I].U;
    end;
    if FElements[I] is TCElement then
    begin
      DrawVertArrow(Tx(vX), Ty(Vy), Ty(-FElements[I].U, false), false,
        ABitmap.Canvas, clBlue, 2);
      DrawIndexedText('U', IntToStr(I + 1), Tx(vX) + 5,
        Ty(Vy - FElements[I].U / 2) - 5, ABitmap.Canvas);
      Vy := Vy - FElements[I].U;
    end;
    if FElements[I] is TLElement then
    begin
      DrawVertArrow(Tx(vX), Ty(Vy), Ty(FElements[I].U, false), false,
        ABitmap.Canvas, clBlue, 2);
      DrawIndexedText('U', IntToStr(I + 1), Tx(vX) + 5,
        Ty(Vy + FElements[I].U / 2) - 5, ABitmap.Canvas);
      Vy := Vy + FElements[I].U;
    end;
  end;
  // Рисуем ток
  DrawHorzArrow(Tx(x0), Ty(y0), cnstSize - 2 * cnstMargins, false,
    ABitmap.Canvas, clBlack, 1);
  DrawIndexedText('I', '', cnstSize - 2 * cnstMargins, Ty(y0) - 12,
    ABitmap.Canvas);
  DrawIndexedText('0', '', Tx(x0) - cnstMargins, Ty(y0) - 10, ABitmap.Canvas);
  // Рисуем общее напряжение
  DrawArrow(Tx(x0), Ty(y0), Tx(vX), Ty(Vy), false, ABitmap.Canvas, clBlue,2);
  DrawIndexedText('U', '', Tx(x0 + (vX - x0) / 2) - 25, Ty(y0 + (Vy - y0) / 2),
    ABitmap.Canvas);
  ABitmap.Canvas.MoveTo(Tx(x0) + cnstR, Ty(y0));
  ABitmap.Canvas.AngleArc(Tx(x0), Ty(y0), cnstR, 0, RadToDeg(Phi));
  DrawIndexedText('φ', '', Tx(x0) + Round(cnstR * cos(Phi / 2)) + 7,
    Ty(y0) - Round(cnstR * sin(Phi / 2)), ABitmap.Canvas);
end;

procedure TSchema.DrawSchema(ABitmap: TBitmap);
const
  // Расстояние между элементами на схеме
  cnstDist = 30;
  // Отступ
  cnstMargins = 35;
  // Высота контролов
  cnstHeight = 100;
  //Высота линий для обозначений напряжения
  cnstLineHeight = 25;
var
  I: Integer;
  vCanvas: TCanvas;
  vSumWidth1, vSumWidth2: Integer;

  // Рисует линию последовательно соединенных элементов
  procedure DrawElementLine(y: Integer; AFromIndex, AToIndex: Integer);
  var
    I: Integer;
    vOffset: Integer;
    vLineX1, vLineX2: Integer;
    vArrow: TArrow;
    procedure ProcessAtom;
    begin
      vCanvas.MoveTo(vOffset, y);
      Inc(vOffset, cnstDist);
      vLineX1 := vOffset-cnstDist div 2;
      vCanvas.LineTo(vOffset, y);
      FElements[I].Draw(vOffset, y, vCanvas);
      Inc(vOffset, FElements[I].Width);
      vLineX2 := vOffset+cnstDist div 2;
      //Рисуем Линии напряжения
      vCanvas.MoveTo(vLineX1, y);
      vCanvas.LineTo(vLineX1, y+cnstLineHeight);
      vCanvas.MoveTo(vLineX2, y);
      vCanvas.LineTo(vLineX2, y+cnstLineHeight);
      vArrow.XB := vLineX1;
      vArrow.YB := y+cnstLineHeight;
      vArrow.XE := vLineX2;
      vArrow.YE := y+cnstLineHeight;
      vArrow.Color := clBlack;
      vArrow.Width := 1;
      vArrow.Style := psSolid;
      vArrow.B.Marker := amOpenArrow;
      vArrow.B.Length := 12;
      vArrow.B.Width := 5;
      vArrow.B.Indent := 0;
      vArrow.E := vArrow.B;
      DrawArrow(vCanvas, vArrow);
      DrawIndexedText('U', IntToStr(i+1), (vLineX1+vLineX2)div 2 - 6, y+cnstLineHeight+10, vCanvas);
    end;

  begin
    vOffset := cnstMargins;
    if AFromIndex < AToIndex then
      for I := AFromIndex to AToIndex do
        ProcessAtom
    else
      for I := AFromIndex downto AToIndex do
        ProcessAtom;
    vCanvas.MoveTo(vOffset, y);
    vCanvas.LineTo(Max(vSumWidth1, vSumWidth2) + cnstMargins, y);
  end;

begin
  vCanvas := ABitmap.Canvas;
  ABitmap.Height := 2 * cnstMargins + cnstHeight+cnstLineHeight;
  // Рассчитываем оптимальную ширину картинки с эквивалентной схемой
  vSumWidth1 := 0;
  for I := 0 to ItemsCount div 2 - 1 do
    Inc(vSumWidth1, cnstDist + Elements[I].Width);
  Inc(vSumWidth1, cnstDist);
  vSumWidth2 := 0;
  for I := ItemsCount div 2 to ItemsCount - 1 do
    Inc(vSumWidth2, cnstDist + Elements[I].Width);
  Inc(vSumWidth2, cnstDist);
  ABitmap.Width := 2 * cnstMargins + Max(vSumWidth1, vSumWidth2);

  DrawElementLine(cnstMargins, 0, ItemsCount div 2 - 1);
  DrawElementLine(cnstMargins + cnstHeight, ItemsCount - 1, ItemsCount div 2);
  vCanvas.MoveTo(ABitmap.Width - cnstMargins, cnstMargins);
  vCanvas.LineTo(ABitmap.Width - cnstMargins, cnstMargins + cnstHeight);
  DrawLineEnd(cnstMargins, cnstMargins, vCanvas);
  DrawLineEnd(cnstMargins, cnstMargins + cnstHeight, vCanvas);
  DrawVertArrow(cnstMargins, cnstMargins + 8, cnstHeight - 2 * 8, false,
    vCanvas, clBlack, 1, amOpenArrow);
  DrawIndexedText('~U', '', cnstMargins - 25,
    cnstMargins + cnstHeight div 2, vCanvas);
end;

function TSchema.GetCosPhiFormula: String;
begin
  Result := 'cos(phi)=cos(' + PrepareDouble(RadToDeg(Phi)) + '^0)=' +
    PrepareDouble(cos(Phi));
end;

function TSchema.GetElement(AIndex: Integer): TElement;
begin
  Assert(AIndex < ItemsCount, 'Розробнику - елемента ' + IntToStr(AIndex) +
    ' не існує в схемі');
  Result := FElements[AIndex]
end;

function TSchema.GetP: Double;
begin
  Result := I * U * cos(Phi);
end;

function TSchema.GetPFormula: String;
var
  vFormula: TFormula;
begin
  Result := 'P=';
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := 'I*.U*.cos(phi)';
    vFormula.AddReplaceTerm('I', I);
    vFormula.AddReplaceTerm('U', U);
    vFormula.AddReplaceTerm('phi', RadToDeg(Phi));
    Result := Result + vFormula.FormulaStr + '=' + vFormula.GetFormulaValue +
      '=' + PrepareDouble(P);
  finally
    FreeAndNil(vFormula);
  end;
end;

function TSchema.GetPhi: Double;
var
  vX, Vy: Double;
  I: Integer;
begin
  vX := 0;
  Vy := 0;
  for I := 0 to ItemsCount - 1 do
  begin
    if FElements[I] is TRElement then
      vX := vX + FElements[I].U;
    if FElements[I] is TCElement then
      Vy := Vy - FElements[I].U;
    if FElements[I] is TLElement then
      Vy := Vy + FElements[I].U;
  end;
  if vX = 0 then
  begin
    if Vy > 0 then
      Result := pi / 2
    else
      Result := -pi / 2;
  end
  else
    Result := ArcTan(Vy / vX);
end;

function TSchema.GetPhiFormula: String;
begin
  Result := 'phi=arctg(' + GetTanResult + ')=' +
    PrepareDouble(RadToDeg(Phi)) + '^0';
end;

function TSchema.GetQ: Double;
begin
  Result := I * U * sin(Phi);
end;

function TSchema.GetQFormula: String;
var
  vFormula: TFormula;
begin
  Result := 'Q=';
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := 'I*.U*.sin(phi)';
    vFormula.AddReplaceTerm('I', I);
    vFormula.AddReplaceTerm('U', U);
    vFormula.AddReplaceTerm('phi', RadToDeg(Phi));
    Result := Result + vFormula.FormulaStr + '=' + vFormula.GetFormulaValue +
      '=' + PrepareDouble(Q);
  finally
    FreeAndNil(vFormula);
  end;
end;

function TSchema.GetS: Double;
begin
  Result := sqrt(sqr(P) + sqr(Q));
end;

function TSchema.GetSFormula: String;
var
  vFormula: TFormula;
begin
  Result := 'S=';
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := 'sqrt(P^2+Q^2)';
    vFormula.AddReplaceTerm('P', P);
    vFormula.AddReplaceTerm('Q', Q);
    Result := Result + vFormula.FormulaStr + '=' + vFormula.GetFormulaValue +
      '=' + PrepareDouble(S);
  finally
    FreeAndNil(vFormula);
  end;
end;

function TSchema.GetTanPhiFormula: String;
var
  vFormula: TFormula;
  vStrY1, vStrY2, vStrX, tmp: String;
  I: Integer;

  function ReplaceFormulas(vStr: String): String;
  begin
    Result := StringReplace(vStr, 'U_L', 'U', [rfReplaceAll]);
    Result := StringReplace(Result, 'U_C', 'U', [rfReplaceAll]);
    Result := StringReplace(Result, 'U_R', 'U', [rfReplaceAll]);
  end;

begin
  Result := 'tg(phi)=(Summa(U_(Li))-Summa(U_(Ci)))/Summa(U_(Ri))';
  vFormula := TFormula.Create;
  vStrY1 := '';
  vStrY2 := '';
  vStrX := '';
  try
    for I := 0 to ItemsCount - 1 do
    begin
      if FElements[I] is TRElement then
      begin
        tmp := 'U_R_' + IntToStr(I + 1);
        vStrX := vStrX + '+' + tmp;
      end;
      if FElements[I] is TLElement then
      begin
        tmp := 'U_L_' + IntToStr(I + 1);
        vStrY1 := vStrY1 + '+' + tmp;
      end;
      if FElements[I] is TCElement then
      begin
        tmp := 'U_C_' + IntToStr(I + 1);
        vStrY2 := vStrY2 + '+' + tmp;
      end;
      vFormula.AddReplaceTerm(tmp, FElements[I].U);
    end;
    // Удаляем ведующие +
    vStrX := Copy(vStrX, 2, Length(vStrX) - 1);
    if vStrX = '' then
      vStrX := '0';
    vStrY1 := Copy(vStrY1, 2, Length(vStrY1) - 1);
    vStrY2 := Copy(vStrY2, 2, Length(vStrY2) - 1);
    vStrX := Brakets(vStrX);
    vStrY1 := Brakets(vStrY1);
    vStrY2 := Brakets(vStrY2);

    vFormula.FormulaStr := SplitAtoms(Brakets(SplitAtoms(vStrY1, vStrY2, '-')),
      Brakets(vStrX), '/');
    Result := Result + '=' + vFormula.FormulaStr + '=' +
      ReplaceFormulas(vFormula.FormulaStr) + '=' + vFormula.GetFormulaValue +
      '=' + GetTanResult;
  finally
    FreeAndNil(vFormula);
  end;
end;

function TSchema.GetTanResult: String;
begin
  if RoundTo(Phi, cnstRoundPref) = RoundTo(pi / 2, cnstRoundPref) then
    Result := '+Inf'
  else if RoundTo(Phi, cnstRoundPref) = -RoundTo(pi / 2, cnstRoundPref) then
    Result := '-Inf'
  else
    Result := PrepareDouble(Tan(Phi));
end;

function TSchema.GetU: Double;
var
  vSumR: Double;
  I: Integer;
begin
  vSumR := 0;
  for I := 0 to ItemsCount - 1 do
  begin
    if FElements[I] is TRElement then
      vSumR := vSumR + FElements[I].U;
  end;
  Result := vSumR / cos(Phi);
end;

function TSchema.GetUFormula: String;
var
  vStrX, tmp: String;
  vFormula: TFormula;
  I: Integer;
begin
  Result := 'U=(Summa(U_R_i))/cos(phi)=';
  vFormula := TFormula.Create;
  try
    for I := 0 to ItemsCount - 1 do
      if FElements[I] is TRElement then
      begin
        tmp := 'U_R_' + IntToStr(I + 1) + '';
        vFormula.AddReplaceTerm(tmp, FElements[I].U);
        vFormula.FormulaStr := vFormula.FormulaStr + '+' + tmp;
      end;
    vFormula.FormulaStr := Copy(vFormula.FormulaStr, 2,
      Length(vFormula.FormulaStr) - 1);
    tmp := 'cos(phi)';
    vFormula.AddReplaceTerm(tmp, cos(Phi));
    vFormula.FormulaStr := Brakets(vFormula.FormulaStr) + '/' + tmp;
    Result := Result + vFormula.FormulaStr + '=' +
      StringReplace(vFormula.FormulaStr, 'U_R', 'U', [rfReplaceAll]) + '=' +
      vFormula.GetFormulaValue + '=' + PrepareDouble(U);
  finally
    FreeAndNil(vFormula);
  end;
end;

function TSchema.GetXFormula(I: Integer): String;
var
  vStr: String;
  vFormula: TFormula;
begin
  Assert(I < ItemsCount, 'Розробнику: в GetXFormula переданий індекс масива ( '
    + IntToStr(I) + ') більший за кількість елементів масиву');
  vFormula := TFormula.Create;
  try
    Result := '';
    if FElements[I] is TRElement then
      Result := 'R_' + IntToStr(I + 1);
    if FElements[I] is TLElement then
      Result := 'X_L_' + IntToStr(I + 1);
    if FElements[I] is TCElement then
      Result := 'X_C_' + IntToStr(I + 1);

    vStr := 'U_' + IntToStr(I + 1);
    vFormula.FormulaStr := vStr + '/I';
    vFormula.AddReplaceTerm(vStr, FElements[I].U);
    vFormula.AddReplaceTerm('I', Self.I);
    Result := Result + '=' + vFormula.FormulaStr + '=' +
      vFormula.GetFormulaValue + '=' + PrepareDouble(FElements[I].U / Self.I);
  finally
    FreeAndNil(vFormula);
  end;

end;

function TSchema.GetZFormula: String;
var
  vFormula: TFormula;
begin
  Result := 'Z=';
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := 'U/I';
    vFormula.AddReplaceTerm('U', U);
    vFormula.AddReplaceTerm('I', I);
    Result := Result + vFormula.FormulaStr + '=' + vFormula.GetFormulaValue +
      '=' + PrepareDouble(U / I);
  finally
    FreeAndNil(vFormula);
  end;
end;

end.
