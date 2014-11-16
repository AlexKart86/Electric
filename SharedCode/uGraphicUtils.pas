unit uGraphicUtils;

// Общие графические утилиты

interface

uses Windows, WinTypes,  Graphics;



/// <summary>
/// Рисует текст с индексом в нижней строке
/// </summary>
/// <param name="AName">
/// Основной текст
/// </param>
/// <param name="AIndex">
/// Текст индекса
/// </param>
/// <param name="x">
/// Координата х начала текста
/// </param>
/// <param name="y">
/// Координата у центра основного текста
/// </param>
/// <param name="ACanvas">
/// Канва на которой надо нарисовать
/// </param>
/// <param name="AIsCenterByX">
/// Надо ли чтобы текст размешался с выравниванием по центру
///  (координата Х являлась центром текста)
/// </param>
procedure DrawIndexedText(AName, AIndex: String; x, y: Integer;
  ACanvas: TCanvas; AIsCenterByX: Boolean = False);

// Рисует точку - место соединения проводников
procedure DrawLineEnd(x, y: Integer; ACanvas: TCanvas);

//Рисует горизонтальную линию
//Устарела, следует использовать функцию из ArrowUnit
procedure DrawHorzArrow(AName, AIndex: String; x,y: Integer; ACanvas: TCanvas); deprecated;

//Рисует вертикальную линию
//Устарела, следует использовать функцию из ArrowUnit

///	<summary>
///	  Функция рисут вертикальную линию
///	</summary>
///	<param name="AName">
///	  Подпись
///	</param>
procedure DrawVertArrow(AName, AIndex: String; x,y: Integer; ACanvas: TCanvas); deprecated;

//Загружает битмар из ресурса, возвращает созданный битмар
function LoadBitmapFromRes(AResId: string): TBitmap;

//Вставляет картинку в другую картинку
procedure InsertBitmap(ASource, APaste: TBitmap; x,y: Integer);

procedure ClearImage(ABitmap: TBitmap);

function GetStringRect (const AString: string; AFont: TFont): INteger;

implementation

uses uConstsShared, Classes, Sysutils;


function GetStringRect (const AString: string; AFont: TFont): INteger;
var
DC: HDC;
RGN: HRGN;
v: TRect;
begin
DC := CreateCompatibleDC(0);
Win32Check(DC<>0);
try
  SelectObject(DC, AFont.Handle);
  Win32Check(BeginPath(DC));
  try
    TextOut(DC,1,1,PChar(AString),Length(AString));
  finally
    EndPath(DC);
  end;

  RGN := PathToRegion(DC);
  Win32Check(RGN<>0);
  try
    GetRgnBox(RGN,v);
    Result := v.Width;
  finally
    DeleteObject(RGN);
  end;

finally
  DeleteDC(DC);
end;
end;


procedure DrawIndexedText(AName, AIndex: String; x, y: Integer;
  ACanvas: TCanvas; AIsCenterByX: Boolean = False);
var
  vOldFontSize: Integer;
  vDx: Integer;
  vY: Integer;
begin
  vOldFontSize := ACanvas.Font.Size;
  try
    ACanvas.Font.Size := cnstNormalFontSize;
    vY := y - (ACanvas.TextHeight(AName) div 2);
    if AIsCenterByX then
      x := x - (ACanvas.TextWidth(AName+AIndex) shr 1);
    ACanvas.TextOut(x, vY, AName);
    vDx := ACanvas.TextWidth(AName);
    ACanvas.Font.Size := cnstLittleFontSize;
    ACanvas.TextOut(x + vDx + 2, vY + 5, AIndex);
  finally
    ACanvas.Font.Size := vOldFontSize;
  end;
end;

// Рисует точку - место соединения проводников
procedure DrawLineEnd(x, y: Integer; ACanvas: TCanvas);
begin
  ACanvas.Ellipse(x - 4, y - 4, x + 4, y + 4);
end;

//Рисует горизонтальную линию
procedure DrawHorzArrow(AName, AIndex: String; x,y: Integer; ACanvas: TCanvas);
begin
  ACanvas.MoveTo(x,y);
  ACanvas.LineTo(x-12, y-3);
  ACanvas.MoveTo(x,y);
  ACanvas.LineTo(x-12, y+3);
  DrawIndexedText(AName, AIndex, x-3,y-10, ACanvas);
end;

//Рисует вертикальную линию
procedure DrawVertArrow(AName, AIndex: String; x,y: Integer; ACanvas: TCanvas);
begin
  ACanvas.MoveTo(x,y);
  ACanvas.LineTo(x-3, y-10);
  ACanvas.MoveTo(x,y);
  ACanvas.LineTo(x+3, y-10);
  DrawIndexedText(AName, AIndex, x-15, y-4, ACanvas);
end;

//Загружает битмар из ресурса, возвращает созданный битмар
function LoadBitmapFromRes(AResId: string): Graphics.TBitmap;
const
  BM = $4D42; {Идентификатор типа изображения}
var
  BMF: TBitmapFileHeader;
  HResInfo: THandle;
  MemHandle: THandle;
  Stream: TMemoryStream;
  ResPtr: PByte;
  ResSize: Longint;
begin
  (*BMF.bfType := BM;
  {Ищем, загружаем и блокируем ресурс, содержащий BITMAP_1}
  HResInfo := FindResource(HInstance, PWideChar(AResId), RT_Bitmap);
  MemHandle := LoadResource(HInstance, HResInfo);
  ResPtr := LockResource(MemHandle);

  {Создаем Memory-поток, устанавливаем его размер, записываем
  туда заголовок изображения и, наконец, само изображение }
  Stream := TMemoryStream.Create;
  ResSize := SizeofResource(HInstance, HResInfo);
  Stream.SetSize(ResSize + SizeOf(BMF));
  Stream.Write(BMF, SizeOf(BMF));
  Stream.Write(ResPtr^, ResSize);

  {Освобождаем поток и сбрасываем его позицию в 0}
  FreeResource(MemHandle);
  Stream.Seek(0, 0);

  {Создаем TBitmap и загружаем изображение из MemoryStream}
  Result  := Graphics.TBitmap.Create;
  Result.LoadFromStream(Stream);
  Stream.Free;
                *)
  Result  := Graphics.TBitmap.Create;
  Result.LoadFromResourceName(HInstance, AResId);
end;

//Вставляет картинку в другую картинку
procedure InsertBitmap(ASource, APaste: TBitmap; x,y: Integer);
begin
  BitBlt(ASource.Canvas.Handle, x,y, APaste.Width, APaste.Height, APaste.Canvas.Handle, 0, 0, SrcCopy);
end;

procedure ClearImage(ABitmap: TBitmap);
var vRect: TRect;
begin
  vRect.Left := 0;
  vRect.Top := 0;
  vRect.Width := ABitmap.Width;
  vRect.Height := ABitmap.Height;
  ABitmap.Canvas.Brush.Color := clWhite;
  ABitmap.Canvas.FillRect(vRect);
end;

end.
