unit uStringUtilsShared;

// ��������� ��������� �������

interface


// ��������� ��� ������� � ���� ����� ���� AOper
function SplitAtoms(AStr1, AStr2, AOper: String): String;
// ���������� ������� x^n
function StrPower(x: String; n: Integer): String;
// ����������� Double � ������
// IsNeedExponent ����������, ������� �� ���������� ����� � ���������������� ����
// ���� ��� ������� ��������� ��� ������� �������
// IsNeedBracket ����������, ������� �� ��������� ������������� ����� � ������
function PrepareDouble(a: double; IsNeedExp: Boolean = False;
  IsNeedBrackets: Boolean = False): string;
// ���������� ������ AElementStr_1+AElementStr_2+...
function GetSumStrFormula(AElementStr: String; aTo: Integer): String; overload;
// ���������� ������ ATotalStr = AElementStr_1+AElementStr_2+...
function GetSumStrFormula(ATotalStr, AElementStr: String; aTo: Integer)
  : String; overload;
//��������� ����� � ������ (���� �� ������ 1 �������)
function Brakets(AStr: String): String;

implementation

uses SysUtils, uConstsShared;

// ��������� ��� ������� � ���� ����� ���� AOper
function SplitAtoms(AStr1, AStr2, AOper: String): String;
begin
  //���� ������� �������� ���, �� ��������� - ������ ������� � ����� ������
  if AStr2 = '' then
  begin
    Result := AStr1;
    Exit;
  end;
  // ���� + ����� ��������, ������� ��� ���� ����������� ���������
  if AOper <> '+' then
    Result := AStr1 + AOper + AStr2
  else
  //��������� ��� ����� +
  begin
    if AStr1 = '' then
      Result := AStr2
    else
      if Copy(AStr2, 1,1) <> '-' then
        Result := AStr1 + AOper + AStr2
      else
        Result := AStr1 + AStr2;
  end;
end;

// ���������� ������� x^n
function StrPower(x: String; n: Integer): String;
begin
  if x = '' then
    Result := ''
  else if Length(x) = 1 then
    Result := x + '^' + IntToStr(n)
  else
    Result := '(' + x + ')^' + IntToStr(n);
end;

// ����������� Double � ������
function PrepareDouble(a: double; IsNeedExp: Boolean = False;
  IsNeedBrackets: Boolean = False): string;
const
  cnstFloatFormat = '####0.###';
var
  vDivider: Integer;
  vCnt: Integer;
begin
  // ���� ����� � ��������� 0.001..10000 �� ���������� ��� ����, �����
  if not IsNeedExp or ((abs(a) >= 0.001) and (abs(a) <= 10000)) or (a = 0) then
    Result := FormatFloat(cnstFloatFormat, a)
  else
  begin
    vDivider := 1;
    vCnt := 0;
    if abs(a) < 0.001 then
    begin
      while abs(a) < 1 do
      begin
        vDivider := vDivider * 10;
        Dec(vCnt);
        a := a * 10;
      end;
    end
    else
      while abs(a) > 1 do
      begin
        vDivider := vDivider * 10;
        Inc(vCnt);
        a := a / 10;
      end;
    Result := FormatFloat(cnstFloatFormat, a) + '*10^(' + IntToStr(vCnt) + ')';
  end;
  if (a < 0) and IsNeedBrackets then
    Result := '(' + Result + ')';
end;


// ���������� ������ ATotalStr = AElementStr_1+AElementStr_2+...
function GetSumStrFormula(AElementStr: String; aTo: Integer): String;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to aTo do
    Result := Result + '+' + AElementStr + '_' + IntToStr(i);
  Result := Copy(Result, 2, Length(Result) - 1);
end;

// ���������� ������ ATotalStr = AElementStr_1+AElementStr_2+...
function GetSumStrFormula(ATotalStr, AElementStr: String; aTo: Integer): String;
begin
  Result := ATotalStr + '=' + GetSumStrFormula(AElementStr, aTo);
end;

//��������� ����� � ������ (���� �� ������ 1 �������)
function Brakets(AStr: String): String;
begin
  if Length(AStr)>1 then
    Result := '(' + AStr + ')'
  else
    Result := AStr;
end;

end.
