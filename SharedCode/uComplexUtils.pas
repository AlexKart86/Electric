unit uComplexUtils;
{
  Утилиты для работы с комплексными числами
}

interface

uses jclMath;

type

  //Запись для работы с комплексными формулами
  //ARoundType - название типа элемента для определения типа округления
  //(см. модуль uRounding)
  TComplexFormula = record
  private
    ComplexRect: TRectComplex;
    PolarRect: TPolarComplex;
  public
    function GetRectFormulaStr(ARoundType: String): String;
    function GetPolarFormulaStr(ARoundType: String): string;
    // Формула перевода из тригонометрического вида в нормальный
    function PolarToNormFormula(ARoundType: String): String;
    function RectToPolarFormula(ARoundType: String): String;
    // Формула перевода из нормальной в полярную систему координат
    constructor CreateRect(Re, Im: Double);
    constructor CreatePolar(Angle, Radius: Double);
    class operator Implicit(const Value: TRectComplex): TComplexFormula;
    class operator Implicit(const Value: TPolarComplex): TComplexFormula;
    function Re: Double;
    function Im: Double;
    function Angle: Double;
    function AngleDeg: Double;
    function Radius: Double;
  end;

implementation

uses uStringUtilsShared, SysUtils, Math, uConstsShared, uRounding, uConsts;

{ TComplexFormula }

function TComplexFormula.Angle: Double;
begin
  Result := PolarRect.Angle;
end;

function TComplexFormula.AngleDeg: Double;
begin
  Result := Math.RadToDeg(Angle);
end;

constructor TComplexFormula.CreatePolar(Angle, Radius: Double);
begin
  PolarRect := PolarComplex(Radius, Angle);
  ComplexRect := PolarRect;
end;

constructor TComplexFormula.CreateRect(Re, Im: Double);
begin
  ComplexRect.Re := Re;
  ComplexRect.Im := Im;
  PolarRect := ComplexRect;
end;

function TComplexFormula.GetPolarFormulaStr(ARoundType: String): string;
const
  cnstFmt = '%s*.e^(j*.(%s^0))';
begin
  if RoundTo(Radius, cnstRoundPref) = 0 then
    Result := '0'
  else
    Result := Format(cnstFmt, [RndArr.FormatDoubleStr(Radius, ARoundType),  RndArr.FormatDoubleStr(AngleDeg, cPhi)]);
end;

function TComplexFormula.GetRectFormulaStr(ARoundType: String): String;
begin
  Result := '';
  if RoundTo(Re, cnstRoundPref) <> 0 then
    Result := RndArr.FormatDoubleStr(ComplexRect.Re, ARoundType);
  if RoundTo(Im, cnstRoundPref) <> 0 then
    if Im > 0 then
      Result := SplitAtoms(Result, 'j*.' + RndArr.FormatDoubleStr(ComplexRect.Im, ARoundType), '+')
    else
      Result := SplitAtoms(Result, 'j*.' + RndArr.FormatDoubleStr(-ComplexRect.Im, ARoundType), '-');

  if (RoundTo(Re, cnstRoundPref) = 0) and (RoundTo(Im, cnstRoundPref) = 0) then
    Result := '0';


end;

function TComplexFormula.Im: Double;
begin
  Result := ComplexRect.Im;
end;

class operator TComplexFormula.Implicit(const Value: TRectComplex)
  : TComplexFormula;
begin
  Result := TComplexFormula.CreateRect(Value.Re, Value.Im);
end;

class operator TComplexFormula.Implicit(const Value: TPolarComplex)
  : TComplexFormula;
begin
  Result := TComplexFormula.CreatePolar(Value.Angle, Value.Radius);
end;

function TComplexFormula.PolarToNormFormula(ARoundType: String): String;
const
  cnstFmt = '%s=%s*.(cos(%s^0)+j*.sin(%s^0))=%s';
begin
  if RoundTo(Radius, cnstRoundPref) = 0 then
    Result := '0'
  else
    Result := Format(cnstFmt, [GetPolarFormulaStr(ARoundType), RndArr.FormatDoubleStr(Radius, ARoundType),
      RndArr.FormatDoubleStr(AngleDeg, ARoundType), RndArr.FormatDoubleStr(AngleDeg, ARoundType), GetRectFormulaStr(ARoundType)]);
end;

function TComplexFormula.Radius: Double;
begin
  Result := PolarRect.Radius;
end;

function TComplexFormula.Re: Double;
begin
  Result := ComplexRect.Re;
end;

function TComplexFormula.RectToPolarFormula(ARoundType: String): String;
const
  cnstAnglePatt = 'arctg(%s/%s)';
  cnstMainFmt = '%s=sqrt((%s)^2+(%s)^2)*.e^(j*.(%s))=%s';
var
  vAngleFormula: String;
begin
  if RoundTo(Radius, cnstRoundPref) = 0 then
    Result := '0'
  else
  begin
    vAngleFormula := Format(cnstAnglePatt, [RndArr.FormatDoubleStr(Abs(Im), ARoundType),
      RndArr.FormatDoubleStr(Abs(Re), ARoundType)]);
    if (Re >= 0) and (Im < 0) then
      vAngleFormula := '-' + vAngleFormula;
    if (Re < 0) and (Im > 0) then
      vAngleFormula := '180^0-' + vAngleFormula;
    if (Re < 0) and (Im <  0) then
      vAngleFormula := '-180^0+' + vAngleFormula;
    Result := Format(cnstMainFmt, [GetRectFormulaStr(ARoundType), RndArr.FormatDoubleStr(Re, ARoundType),
      RndArr.FormatDoubleStr(Im, ARoundType), vAngleFormula, GetPolarFormulaStr(ARoundType)]);
  end;
end;

end.
