Unit ArrowUnit;

{
  CopyLeft(Ц) by CrazyMihey
  E-Mail: CrazyMihey@Pisem.Net
  ICQ:    13412847
}

INTERFACE

Uses Types, Graphics;

Type
  TArrowMarker = (amNone, // Просто Прямая Линия.
    amArrow, // ТреУгольная Стрелка.
    amOpenArrow, // Открытая Стрелка.
    amInsideArrow, // Вогнутая Стрелка.
    amSquare, // Квадратный Маркер.
    amRomb, // РомбоВидный Маркер.
    amCircle // ШароОбразный Маркер.
    );
  TArrowSize = 0 .. High(Integer);

  TArrowHead = Record
    Marker: TArrowMarker;
    Length: TArrowSize;
    Width: TArrowSize;
    Indent: TArrowSize;
  End;

  TArrow = Record
    XB, YB: Integer; // Координаты Начала Стрелки.
    XE, YE: Integer; // Координаты Конца Стрелки.
    Color: TColor; // Цвет Стрелки.
    Width: TArrowSize; // Толщина Линии.
    Style: TPenStyle; // Стиль Линии.
    B: TArrowHead; // Стиль Начала Стрелки.
    E: TArrowHead; // Стиль Конца Стрелки.
  End;

Var
  NearDistance: Integer = 2;

Function Dist(Const DX, DY: Integer): Integer; OverLoad;
Function Dist(Const XB, YB, XE, YE: Integer): Integer; OverLoad;
Function IsNear(Const XB, YB, XE, YE: Integer): Boolean;
Procedure DrawArrow(Const Canvas: TCanvas; Const Arrow: TArrow); overload;

// Рисует линию от точки (x,y) до точки (x1, y1)
procedure DrawArrow(x, y, x1, y1: Integer; IsDash: Boolean;
  const Canvas: TCanvas; AColor: TColor = clBlue; AWidth: Integer = 3;
  AMarker: TArrowMarker = amArrow); overload;

// Рисует горизонтальную линию
procedure DrawHorzArrow(x, y, DX: Integer; IsDash: Boolean;
  const Canvas: TCanvas; AColor: TColor = clBlue; AWidth: Integer = 3;
  AMarker: TArrowMarker = amArrow);
// Рисует вертикальную линию
procedure DrawVertArrow(x, y, DY: Integer; IsDash: Boolean;
  const Canvas: TCanvas; AColor: TColor = clBlue; AWidth: Integer = 3;
  AMarker: TArrowMarker = amArrow);

procedure DrawPoint(x,y: Integer; Canvas: TCanvas);

IMPLEMENTATION

Function Dist(Const DX, DY: Integer): Integer; OverLoad;
BEGIN { Dist }
  Result := Trunc(SqRt(DX * DX + DY * DY));
END; { Dist }

Function Dist(Const XB, YB, XE, YE: Integer): Integer; OverLoad;
BEGIN { Dist }
  Result := Dist(XE - XB, YE - YB);
END; { Dist }

Function IsNear(Const XB, YB, XE, YE: Integer): Boolean;
BEGIN { IsNear }
  Result := Dist(XB, YB, XE, YE) <= NearDistance;
END; { IsNear }

Procedure DrawArrowMarker(Const Canvas: TCanvas; Const XB, YB, XE, YE: Integer;
  Const Head: TArrowHead);
Var
  AX, AY, AD: Integer;
  NX, NY: Integer;
  XI, YI: Integer;
  Points: Array [0 .. 3] of TPoint;
  OldBrushColor: TColor;
  OldBrushStyle: TBrushStyle;
BEGIN { DrawArrowMarker }
  OldBrushColor := Canvas.Brush.Color;
  OldBrushStyle := Canvas.Brush.Style;
  Canvas.Brush.Color := Canvas.Pen.Color;
  Canvas.Brush.Style := bsSolid;
  AX := XE - XB;
  AY := YE - YB;
  AD := Dist(AX, AY); // Длина Всей Стрелки.
  XI := XE - AX * Head.Indent div AD;
  YI := YE - AY * Head.Indent div AD;
  Case Head.Marker of
    amNone:
      Begin
      End;
    amArrow:
      Begin
        NX := XI - AX * Head.Length div AD;
        NY := YI - AY * Head.Length div AD;
        Points[0].x := XI;
        Points[0].y := YI;
        Points[2].x := XI - AX * Head.Length div AD;
        Points[2].y := YI - AY * Head.Length div AD;
        Points[1].x := NX - AY * Head.Width div (AD * 2);
        Points[1].y := NY + AX * Head.Width div (AD * 2);
        Points[3].x := NX + AY * Head.Width div (AD * 2);
        Points[3].y := NY - AX * Head.Width div (AD * 2);
        Canvas.Polygon(Points);
      End;
    amOpenArrow:
      Begin
        NX := XI - AX * Head.Length div AD;
        NY := YI - AY * Head.Length div AD;
        Points[0].x := XI;
        Points[0].y := YI;
        Points[2].x := XI;
        Points[2].y := YI;
        Points[1].x := NX - AY * Head.Width div (AD * 2);
        Points[1].y := NY + AX * Head.Width div (AD * 2);
        Points[3].x := NX + AY * Head.Width div (AD * 2);
        Points[3].y := NY - AX * Head.Width div (AD * 2);
        Canvas.Polygon(Points);
      End;
    amInsideArrow:
      Begin
        NX := XI - AX * Head.Length div AD;
        NY := YI - AY * Head.Length div AD;
        Points[0].x := XI;
        Points[0].y := YI;
        Points[2].x := XI - AX * Head.Length div (AD * 2);
        Points[2].y := YI - AY * Head.Length div (AD * 2);
        Points[1].x := NX - AY * Head.Width div (AD * 2);
        Points[1].y := NY + AX * Head.Width div (AD * 2);
        Points[3].x := NX + AY * Head.Width div (AD * 2);
        Points[3].y := NY - AX * Head.Width div (AD * 2);
        Canvas.Polygon(Points);
      End;
    amSquare:
      Begin
        NX := AX * Head.Width div (AD * 2);
        NY := AY * Head.Width div (AD * 2);
        Points[0].x := XI + NX + NY;
        Points[0].y := YI + NY - NX;
        Points[1].x := XI + NX - NY;
        Points[1].y := YI + NY + NX;
        Points[2].x := XI - NX - NY;
        Points[2].y := YI - NY + NX;
        Points[3].x := XI - NX + NY;
        Points[3].y := YI - NY - NX;
        Canvas.Polygon(Points);
      End;
    amRomb:
      Begin
        NX := AX * Head.Width div (AD * 2);
        NY := AY * Head.Width div (AD * 2);
        Points[0].x := XI + NX;
        Points[0].y := YI + NY;
        Points[1].x := XI + NY;
        Points[1].y := YI - NX;
        Points[2].x := XI - NX;
        Points[2].y := YI - NY;
        Points[3].x := XI - NY;
        Points[3].y := YI + NX;
        Canvas.Polygon(Points);
      End;
    amCircle:
      Begin
        NX := Head.Width div 2;
        NY := Head.Width div 2;
        Canvas.Ellipse(XI - NX, YI - NY, XI + NX, YI + NY);
      End;
  End; // Case;
  Canvas.Brush.Color := OldBrushColor;
  Canvas.Brush.Style := OldBrushStyle;
END; { DrawArrowMarker }

Procedure DrawArrow(Const Canvas: TCanvas; Const Arrow: TArrow);
Var
  OldPenPos: TPoint;
  OldPenColor: TColor;
  OldPenWidth: TArrowSize;
  OldPenStyle: TPenStyle;
  AX, AY, AD: Integer;
BEGIN { DrawArrow }
  OldPenPos := Canvas.PenPos;
  OldPenColor := Canvas.Pen.Color;
  OldPenWidth := Canvas.Pen.Width;
  OldPenStyle := Canvas.Pen.Style;
  Canvas.Pen.Color := Arrow.Color;
  Canvas.Pen.Width := Arrow.Width;
  Canvas.Pen.Style := Arrow.Style;
  Canvas.MoveTo(Arrow.XB, Arrow.YB);
  Canvas.LineTo(Arrow.XE, Arrow.YE);
  AX := Arrow.XE - Arrow.XB;
  AY := Arrow.YE - Arrow.YB;
  AD := Dist(AX, AY); // Длина Всей Стрелки.
  IF (Arrow.B.Marker <> amNone) and (Arrow.B.Length + Arrow.B.Indent < AD) then
    DrawArrowMarker(Canvas, Arrow.XE, Arrow.YE, Arrow.XB, Arrow.YB, Arrow.B)
  else;
  IF (Arrow.E.Marker <> amNone) and (Arrow.E.Length + Arrow.E.Indent < AD) then
    DrawArrowMarker(Canvas, Arrow.XB, Arrow.YB, Arrow.XE, Arrow.YE, Arrow.E)
  else;
  Canvas.PenPos := OldPenPos;
  Canvas.Pen.Color := OldPenColor;
  Canvas.Pen.Width := OldPenWidth;
  Canvas.Pen.Style := OldPenStyle;
END; { DrawArrow }

// Рисует линию от  x1, x2, y1, y2
procedure DrawArrow(x, y, x1, y1: Integer; IsDash: Boolean;
  const Canvas: TCanvas; AColor: TColor = clBlue; AWidth: Integer = 3;
  AMarker: TArrowMarker = amArrow);
var
  vArrow: TArrow;
begin
  vArrow.Color := AColor;

  if IsDash then
  begin
    vArrow.Style := psDash;
    vArrow.Width := 1;
  end
  else
  begin
    vArrow.Style := psSolid;
    vArrow.Width := AWidth;
  end;
  vArrow.E.Marker := AMarker;
  vArrow.E.Length := 16;
  vArrow.E.Width := 8;
  vArrow.E.Indent := 0;
  vArrow.XB := x;
  vArrow.YB := y;
  vArrow.XE := x1;
  vArrow.YE := y1;
  DrawArrow(Canvas, vArrow);

end;

// Рисует горизонтальную линию
procedure DrawHorzArrow(x, y, DX: Integer; IsDash: Boolean;
  const Canvas: TCanvas; AColor: TColor = clBlue; AWidth: Integer = 3;
  AMarker: TArrowMarker = amArrow);
begin
  DrawArrow(x, y, x + DX, y, IsDash, Canvas, AColor, AWidth, AMarker);
end;

// Рисует вертикальную линию
procedure DrawVertArrow(x, y, DY: Integer; IsDash: Boolean;
  const Canvas: TCanvas; AColor: TColor = clBlue; AWidth: Integer = 3;
  AMarker: TArrowMarker = amArrow);
begin
  DrawArrow(x, y, x, y + DY, IsDash, Canvas, AColor, AWidth, AMarker);
end;

procedure DrawPoint(x,y: Integer; Canvas: TCanvas);
var
  vOldColor: TColor;
begin
  vOldColor := Canvas.Brush.Color;
  try
    Canvas.Brush.Color := clBlack;
    Canvas.Ellipse(x-3, y-3, x+3, y+3);
  finally
    Canvas.Brush.Color := vOldColor;
  end;
end;

END. // { ArrowUnit }
