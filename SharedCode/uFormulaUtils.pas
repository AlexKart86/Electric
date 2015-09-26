unit uFormulaUtils;

// Различные утилиты для формул

interface

uses ExprDraw, ExprMake, Graphics, RVEdit, RvStyle, Classes, RvTable,
  MemTableDataEh, MemTableEh, Db, Vcl.Imaging.GIFImg;

type

  // Класс для отображения формулы
  TFormula = class
  protected
    FTermVal: TStringList;
  public
    FormulaStr: String;
    procedure AddReplaceTerm(ATerm: String; AValue: Double);
    procedure SplitFormula(AFormula: TFormula; AChar: Char);
    // Возвращает строку формулы, где все термы заменены их значениями
    function GetFormulaValue: String;
    constructor create;
    destructor Destroy; override;
    procedure Copy(ASource: TFormula);
    // Заменяет индексы (в формуле _i на значения)
    procedure ReplaceIndexes(Index: Integer);
  end;

  // Возвращает картинку для формулы  AFormulaStr
function GetFormulaBitMap(AFormulaStr: String; AFontSize: Integer = 12)
  : TBitMap;
function GetTexFormulaGif(AFormulaStr: String): TGIFImage;

// Делает из строки картинку с формулой и вставляет ее в ричвью
procedure RVAddFormula(AFormulaStr: String; rv: TRichViewEdit); overload;
procedure RVAddFormula(AFormulaStr: String; rv: TRVTableCellData); overload;

//Добавляет текст и формулы, помеченные тегами <formula> </formula> в рич вью
procedure RVAddFormulaAndText(AText: String; rv: TRichViewEdit);

//ТОже самое для формул в tex формате
procedure RVAddFormulaTex(AFormulaStr: String; rv: TRichViewEdit); overload;
procedure RVAddFormulaTex(AFormulaStr: String; rv: TRVTableCellData); overload;

// Вставить формулу в виде картинки в битмар
procedure InsertFormulaIntoPicture(ABitmap: TBitMap; x, y: Integer;
  AFormula: string; AFontSize: Integer = 12);
// Хранит в кеше координаты вывода, при повторном вызове зачитывает координаты из кеша
procedure InsertFormulaIntoPictureEx(ABitmap: TBitMap; x, y: Integer;
  AFormula: string; AFontSize: Integer = 12);

// Находит масшабный коеффициент, ПОДЕЛИВ на который получим наиболее близкое значение
function GetMultKoeff(AValue: Double; AMax: Double; AIsExtMode: Boolean=False): Double;

function Decode(ATest: Variant; AVariants: array of Variant): Variant;

// Округляет число до "Красивого вида":
// Если число больше 1 то до целого
// Есди число меньше 1 то до ближайшего из чисел 0,5; 0,25; 0.75
function GetNeast(AValue: Double): Double;


//Выполняет парсинг файла, и раскидывает текст и формулы по разным массивам
//Формула должна обрамляться тегами {tex} {/tex}
procedure ParseFile(AFileName: String; var AText: TArray<String>; var AFormulas: TArray<String>);
procedure ParseText(AStr: String; var AText: TArray<String>; var AFormulas: TArray<String>);

var
  fCoordsCache: TMemTableEh;

implementation

uses SysUtils, uConstsShared, uStringUtilsShared, StrUtils, uGraphicUtils, uSystem,
     Forms, RegularExpressions, Dialogs, Math;




function GetFormulaBitMap(AFormulaStr: String; AFontSize: Integer = 12)
  : TBitMap;
var
  VExpClass: TExprClass;
begin
  VExpClass := BuildExpr(AFormulaStr);
  try
    Result := TBitMap.create;
    VExpClass.Font.Size := AFontSize;
    VExpClass.Font.Name := 'Courier New';
    VExpClass.Canvas := Result.Canvas;
    Result.Width := VExpClass.Width;
    Result.Height := VExpClass.Height;
    VExpClass.Draw(1, 1, ehLeft, evTop);
  finally
    VExpClass.Free;
  end;
end;

function GetTexFormulaGif(AFormulaStr: String): TGIFImage;
const cnstParams='"%s" -e %s -s 3';
      cnstTmpFile='tmp.gif';
begin
  Result := TGIFImage.Create;
  RunCommand('mimetex.exe', Format(cnstParams, [AFormulaStr, cnstTmpFile]));
  Result.LoadFromFile(cnstTmpFile);
  DeleteFile(cnstTmpFile)
end;

function GetRvBitmap(AFormulaStr: String; AFontSize: Integer = 12): TBitMap;
var
  vOldDecimalSep: Char;
begin
  // Временно меняем формат вывода десятичного разделителя на запятую
  vOldDecimalSep := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := ',';
  try
    Result := GetFormulaBitMap(AFormulaStr, AFontSize);
  finally
    FormatSettings.DecimalSeparator := vOldDecimalSep;
  end;
end;

// Делает из строки картинку с формулой и вставляет ее в ричвью
procedure RVAddFormula(AFormulaStr: String; rv: TRichViewEdit);
begin
  rv.InsertPicture(AFormulaStr, GetRvBitmap(AFormulaStr), rvvaAbsMiddle);
end;

procedure RVAddFormula(AFormulaStr: String; rv: TRVTableCellData);
begin
  rv.AddPictureEx(AFormulaStr, GetRvBitmap(AFormulaStr), 0, rvvaAbsMiddle);
end;


//ТОже самое для формул в tex формате
procedure RVAddFormulaTex(AFormulaStr: String; rv: TRichViewEdit);
begin
  rv.InsertPicture(AFormulaStr, GetTexFormulaGif(AFormulaStr), rvvaAbsMiddle);
end;

procedure RVAddFormulaTex(AFormulaStr: String; rv: TRVTableCellData);
begin
  rv.AddPictureEx(AFormulaStr, GetTexFormulaGif(AFormulaStr), 0, rvvaAbsMiddle);
end;

{ TFormula }

procedure TFormula.AddReplaceTerm(ATerm: String; AValue: Double);
begin
  FTermVal.Values[ATerm] := PrepareDouble(AValue);
end;

procedure TFormula.Copy(ASource: TFormula);
begin
  Self.FormulaStr := ASource.FormulaStr;
  Self.FTermVal.Assign(ASource.FTermVal);
end;

constructor TFormula.create;
begin
  FTermVal := TStringList.create;
end;

destructor TFormula.Destroy;
begin
  FreeAndNil(FTermVal);
  inherited;
end;

function TFormula.GetFormulaValue: String;
var
  I: Integer;
  vStr: String;
  vVal: Double;
begin
  Result := FormulaStr;
  for I := 0 to FTermVal.Count - 1 do
  begin
    if FTermVal.ValueFromIndex[I]='INF' then
       vVal := Infinity
    else
      vVal := StrToFloat(FTermVal.ValueFromIndex[I]);

    vStr := PrepareDouble(vVal);
    // Если заменяемый символ - Phi - то приклеиваем градусы
    if 'phi' = LowerCase(System.Copy(FTermVal.Names[I], 1, 3)) then
      vStr := vStr + '^0';

    // Отрицательные числа берем в скобки
    if vVal < 0 then
      vStr := '(' + vStr + ')';
    Result := ReplaceStr(Result, FTermVal.Names[I], vStr);
    // Заменяем все * на *.
    Result := ReplaceStr(Result, '*.', '*');
    Result := ReplaceStr(Result, '*', '*.');

  end;
end;

procedure TFormula.ReplaceIndexes(Index: Integer);
const
  cnstIndexStr = '_i';
var
  I: Integer;
  vTmpList: TStringList;
  vName: String;
begin
  // Вносим замены в строке формулы
  FormulaStr := ReplaceStr(FormulaStr, cnstIndexStr, '_' + IntToStr(Index));
  vTmpList := TStringList.create;
  try
    // Вносим замены в символах подстановки
    for I := 0 to FTermVal.Count - 1 do
    begin
      vName := FTermVal.Names[I];
      vName := ReplaceStr(vName, cnstIndexStr, '_' + IntToStr(Index));
      vTmpList.Values[vName] := FTermVal.ValueFromIndex[I];
    end;
    FTermVal.Clear;
    FTermVal.Assign(vTmpList);
  finally
    vTmpList.Free;
  end;
end;

procedure TFormula.SplitFormula(AFormula: TFormula; AChar: Char);
var
  I: Integer;
begin
  Self.FormulaStr := SplitAtoms(Self.FormulaStr, AFormula.FormulaStr, AChar);
  for I := 0 to AFormula.FTermVal.Count - 1 do
    Self.FTermVal.Values[AFormula.FTermVal.Names[I]] :=
      AFormula.FTermVal.ValueFromIndex[I];
end;

// Находит масшабный коеффициент, ПОДЕЛИВ на который получим наиболее близкое значение
function GetMultKoeff(AValue: Double; AMax: Double; AIsExtMode: Boolean=False): Double;
begin
  if AIsExtMode then
  begin
   Result := 1;

    if Abs(AValue) > Abs(AMax) then
    begin
      while abs(AValue)/Result>Abs(AMax)  do
        Result := Result * 2;
      Result := Result /2;
    end
    else
    begin
      while abs(AValue)/Result < Abs(AMax) do
        Result := Result / 2;
      Result := Result*2;
    end;
  end
  else
    Result := AValue / AMax;
end;

function Decode(ATest: Variant; AVariants: array of Variant): Variant;
var
  I: Integer;
  len: Integer;
begin
  Result := '';
  len := Length(AVariants);
  for I := 0 to len div 2 - 1 do
  begin
    if ATest = AVariants[2 * I] then
    begin
      Result := AVariants[2 * I + 1];
      Exit;
    end;
  end;
  if len mod 2 = 1 then
    Result := AVariants[len - 1];
end;

// Вставить формулу в виде картинки в битмар
procedure InsertFormulaIntoPicture(ABitmap: TBitMap; x, y: Integer;
  AFormula: string; AFontSize: Integer = 12);
var
  vPaste: TBitMap;
begin
  vPaste := GetRvBitmap(AFormula, AFontSize);
  ABitmap.Width := vPaste.Width+10;
  ABitmap.Height := vpaste.Height+10;
  InsertBitmap(ABitmap, vPaste, x, y);
  FreeAndNil(vPaste);
end;

// Хранит в кеше координаты вывода, при повторном вызове зачитывает координаты из кеша
procedure InsertFormulaIntoPictureEx(ABitmap: TBitMap; x, y: Integer;
  AFormula: string; AFontSize: Integer = 12);
var
  vPaste: TBitMap;
  vX, vy: Integer;
  vStream: TMemoryStream;
begin
  vPaste := GetRvBitmap(AFormula, AFontSize);
  // Если координаты есть в кеше, берем оттуда
  if fCoordsCache.Locate('ID', AFormula, []) then
  begin
    vX := fCoordsCache.FieldByName('X').Value;
    vy := fCoordsCache.FieldByName('Y').Value;
  end
  else
  begin
    vX := x;
    vy := y;
    fCoordsCache.Insert;
    fCoordsCache.FieldByName('ID').Value := AFormula;
    fCoordsCache.FieldByName('X').Value := vX;
    fCoordsCache.FieldByName('Y').Value := vy;
    vStream := TMemoryStream.create;
    try
      vPaste.SaveToStream(vStream);
      vStream.Position := 0;
      TBlobField(fCoordsCache.FieldByName('IMG')).LoadFromStream(vStream);
    finally
      vStream.Free;
    end;
    fCoordsCache.Post;
  end;

  InsertBitmap(ABitmap, vPaste, vX, vY);
  FreeAndNil(vPaste);
end;

// Округляет число до "Красивого вида":
// Если число больше 1 то до целого
// Есди число меньше 1 то до ближайшего из чисел 0,5; 0,25; 0.75
function GetNeast(AValue: Double): Double;
const Arr: array[1..3] of double = (0.5, 0.25, 0.75);
var
   Dist: array[1..3] of double;
   MinValue:Double;
   i: Integer;
begin
  if (AValue >= 0.8) or (AValue = 0) then
    Result := Round(AValue)
  else
  begin
    for i := Low(Dist) to High(Dist) do
       Dist[i] := abs(Abs(AValue)-Arr[i]);

    Result := Arr[1];
    MinValue := Dist[1];
    for i := Low(Dist) to High(Dist) do
      if Dist[i]<MinValue then
      begin
        MinValue := Dist[i];
        Result := Arr[i];
      end;
   { Result := Abs(AValue);
    if Result <= 0.25 then
      Result := 0.25
    else if Result <= 0.5 then
      Result := 0.5
    else
      Result := 0.75;
    if AValue < 0 then
      Result := -Result;}
  end;
end;

//Выполняет парсинг файла, и раскидывает текст и формулы по разным массивам
//Формула должна обрамляться тегами {tex} {/tex}
procedure ParseFile(AFileName: String; var AText: TArray<String>; var AFormulas: TArray<String>);
var vList: TStringList;
    vRegExp: TRegEx;
    vFormulas: TMatchCollection;
    i: Integer;
begin
  vList := TStringList.Create;
  try
    vList.LoadFromFile(GetAppPath+AFileName);
    ParseText(vList.Text, AText, AFormulas);
  finally
    FreeAndNil(vList);
  end;
end;

procedure ParseText(AStr: String; var AText: TArray<String>; var AFormulas: TArray<String>);
var vList: TStringList;
    vRegExp: TRegEx;
    vFormulas: TMatchCollection;
    i: Integer;
begin
  vRegExp := TRegEx.Create('({tex}+)(.+?)({\\tex}+)', [roMultiLine]);
  vFormulas := vRegExp.Matches(AStr);
  AText := TRegEx.Split(AStr, '{tex}.+?{\\tex}', [roMultiLine]);
  SetLength(AFormulas, vFormulas.Count);
  for i := 0 to vFormulas.Count-1 do
     AFormulas[i] :=  vFormulas.Item[i].Groups[2].Value;
end;

//Добавляет текст и формулы, помеченные тегами <formula> </formula> в рич вью
procedure RVAddFormulaAndText(AText: String; rv: TRichViewEdit);
var vRegExp: TRegEx;
    vFormulas: TMatchCollection;
    vText: TArray<string>;
    i: Integer;
begin
  vRegExp := TRegEx.Create('(<formula>+)(.+?)(</formula>+)', [roMultiLine]);
  vFormulas := vRegExp.Matches(AText);
  vText := TRegEx.Split(AText, '<formula>.+?</formula>', [roMultiLine]);
  for i := Low(vText) to High(vText) do
  begin
    rv.InsertTextW(vText[i]);
    if vFormulas.Count > i then
      RVAddFormula(vFormulas[i].Groups[2].Value, rv);
  end;
end;

initialization

fCoordsCache := TMemTableEh.create(nil);
fCoordsCache.FieldDefs.Add('IMG', ftGraphic);
fCoordsCache.FieldDefs.Add('ID', ftString, 200);
fCoordsCache.FieldDefs.Add('X', ftInteger);
fCoordsCache.FieldDefs.Add('Y', ftInteger);
fCoordsCache.CreateDataSet;
fCoordsCache.Fields[1].Visible := False;

finalization

fCoordsCache.Free;

end.
