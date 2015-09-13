unit uRounding;

interface

uses MemTableDataEh, MemTableEh, Classes, jclMath;

type
  TRoundArr = class(TMemTableEh)
  private
    class var FInstance: TRoundArr;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    procedure AddType(ATypeCaption, ATypeName: string; AValue: Integer = 3);
    // Округлить число в соответствии с типом данных
    function FormatDouble(a: Double; AElementType: string): Double;
    function FormatDoubleC(a: TRectComplex; AElementType: string): TRectComplex;

    // Тоже самое что и предыдущая функа но выводит строковое представление числа
    function FormatDoubleStr(a: Double; AElementType: string = 'default'): String;
    class function GetInstance: TRoundArr;
  end;

function RndArr: TRoundArr;


implementation

uses Forms, Db, SysUtils, System.Math;

{ TRoundArr }

procedure TRoundArr.AddType(ATypeCaption, ATypeName: string; AValue: Integer);
const
  cnstErr = 'Розробнику: тип %s вже визначений в переліку типів для округлення';
begin
  Assert(not Locate('ELEMENT_NAME', ATypeName, []),
    Format(cnstErr, [ATypeName]));
  Insert;
  Fields[0].Value := ATypeCaption;
  Fields[1].Value := ATypeName;
  Fields[2].Value := AValue;
  Post;
end;

constructor TRoundArr.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // FInstance := nil;
  // Добавляем поля
  FieldDefs.Add('ELEMENT_CAPTION', ftString, 20);
  FieldDefs.Add('ELEMENT_NAME', ftString, 10);
  FieldDefs.Add('VALUE', ftInteger);
  CreateDataSet;
  Fields[0].DisplayLabel := 'Назва параметру';
  Fields[1].Visible := False;
  Fields[2].DisplayLabel := 'Кількість знаків після коми ';
  AddType('За замовчанням', 'default');
end;

destructor TRoundArr.Destroy;
begin
  if Assigned(FInstance) then
    FInstance.Active := False;
  //За удаление отвечает Application
  //FreeAndNil(FInstance);
  inherited;
end;

function TRoundArr.FormatDouble(a: Double; AElementType: string): Double;
const
  cnstErr = 'Розробнику: типу %s не визначено в переліку типів для округлення';
var
  val: Integer;
begin
  Assert(Locate('ELEMENT_NAME', AElementType, []),
    Format(cnstErr, [AElementType]));
  Result := RoundTo(a, -FieldByName('VALUE').AsInteger);
end;

function TRoundArr.FormatDoubleC(a: TRectComplex;
  AElementType: string): TRectComplex;
begin
  Result.Re := FormatDouble(a.Re, AElementType);
  Result.Im := FormatDouble(a.Im, AElementType);
end;

function TRoundArr.FormatDoubleStr(a: Double; AElementType: string): String;
begin
  Result := FloatToStr(FormatDouble(a, AElementType));
end;

class function TRoundArr.GetInstance: TRoundArr;
begin
  if not Assigned(FInstance) then
    FInstance := TRoundArr.Create(Application);
  Result := FInstance;
end;

function RndArr: TRoundArr;
begin
  Result := TRoundArr.GetInstance;
end;

initialization

finalization

end.
