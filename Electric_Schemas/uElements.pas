unit uElements;

// ������, ����������� �������� �����

interface

uses Graphics, uConsts, uFormulaUtils;

type

  // ���������� �� �����, ����������� �������������
  TSchemaInfo = record
    CalcType: TCalcType;
    FreqType: TFreqType;
    ChangeRule: TUChangeRule;
    AddParamType: TAddParamType;
    AddParamNodeNum: Integer;
    AddParamValue: double;
    F: double;
    W: double;
    // ��������� ���� � ��������!!!
    W0: double;
    t0: double;
    t: double;
  public
    function W0Deg: double;
  end;

  // ����������� �����, ����������� ���� ������� �����
  TElementItem = class
  protected
    // �������� ��� ���������� � �������
    function GetFormulaName: String;
  public
    Value: double;
    ElementWidth: Integer;
    ElementHeight: Integer;
    ItemName: String;
    Index: Integer;
    // ���������� ��������� �� ����� � ������������ ����� ����������� x,y
    procedure DrawItem(x, y: Integer; ACanvas: TCanvas); virtual;
    // ������ ������� ��� ���������� �������� �������������
    procedure GetFormulaR(ASchemaInfo: TSchemaInfo; AFormula: TFormula);
      virtual; abstract;
    // ������ �������� �������������
    function GetFormulaRValue(ASchemaInfo: TSchemaInfo): double;
      virtual; abstract;
    constructor Create(AIndex: Integer; AValue: double); virtual;
  end;

  // �����, ����������� ������ � ��������������
  TElementItemR = class(TElementItem)
  public
    procedure DrawItem(x, y: Integer; ACanvas: TCanvas); override;
    constructor Create(AIndex: Integer; AValue: double); override;
    // ������ ������� ��� ���������� �������� �������������
    procedure GetFormulaR(ASchemaInfo: TSchemaInfo;
      AFormula: TFormula); override;
    // ������ �������� �������������
    function GetFormulaRValue(ASchemaInfo: TSchemaInfo): double; override;
  end;

  // �����, ����������� ������ � ��������
  TElementItemL = class(TElementItem)
  public
    procedure DrawItem(x, y: Integer; ACanvas: TCanvas); override;
    constructor Create(AIndex: Integer; AValue: double); override;
    // ������ ������� ��� ���������� �������� �������������
    procedure GetFormulaR(ASchemaInfo: TSchemaInfo;
      AFormula: TFormula); override;
    // ������ �������� �������������
    function GetFormulaRValue(ASchemaInfo: TSchemaInfo): double; override;
  end;

  // �����, ����������� ������ � �������������
  TElementItemC = class(TElementItem)
  public
    procedure DrawItem(x, y: Integer; ACanvas: TCanvas); override;
    constructor Create(AIndex: Integer; AValue: double); override;
    // ������ ������� ��� ���������� �������� �������������
    procedure GetFormulaR(ASchemaInfo: TSchemaInfo;
      AFormula: TFormula); override;
    // ������ �������� �������������
    function GetFormulaRValue(ASchemaInfo: TSchemaInfo): double; override;
  end;

  TRArr = array of TElementItemR;
  TLArr = array of TElementItemL;
  TCArr = array of TElementItemC;

  // ������ ��������� ����, ��������������� �� ������
  TRLCList = class
  private
    FR: TRArr;
    FL: TLArr;
    FC: TCArr;
    FI: array of double;

    function GetNodesCount: Integer;
    function GetR(Index: Integer): TElementItemR;
    function GetL(Index: Integer): TElementItemL;
    function GetC(Index: Integer): TElementItemC;
    // ���������� �������� �������������� � i-�� ����
    function GetZ(Index: Integer): double;
    function GetI(Index: Integer): double;
    function GetIa(Index: Integer): double;
    function GetIr(Index: Integer): double;
    // ��������� �������� ���� � ������ 2 � � ��������
    function GetFormulaArcsinValue(AIndex: Integer): double;
    // ���������� �������� ���� � ������ 2 � ��������
    function Getphi0(AIndex: Integer): double;
  public
    SchemaInfo: TSchemaInfo;
    U: double;
    // ����� ��� � ����
    Itotal: double;
    // ����� ���� � ��������
    PhiTotal: double;
    // ����� �������������
    ZTotal: double;
    // ����� ���������� �������������
    XrTotal: double;
    // ����� �������� �������������
    RaTotal: double;

    constructor Create(ASchemaInfo: TSchemaInfo);
    procedure Add(r, l, c: double);
    property NodesCount: Integer read GetNodesCount;
    property r[Index: Integer]: TElementItemR read GetR;
    property l[Index: Integer]: TElementItemL read GetL;
    property c[Index: Integer]: TElementItemC read GetC;
    property Z[Index: Integer]: double read GetZ;
    property I[Index: Integer]: double read GetI;
    property Ia[Index: Integer]: double read GetIa;
    property Ir[Index: Integer]: double read GetIr;
    // �������� ������ ���� � ��������
    property Phi[Index: Integer]: double read GetFormulaArcsinValue;
    // �������� ������ ���� � ��������
    property Phi0[Index: Integer]: double read Getphi0;

    // ���������� ������� �������� ������������� ��� ���� ��������� ����
    procedure GetFormulaR(AIndex: Integer; AFormula: TFormula);
    // ���������� ������� ��� �������� ������� �������� ��� ��� ����� ����
    procedure GetFormulaSin(AIndex: Integer; AFormula: TFormula);
    function GetFormulaSinValue(AIndex: Integer): double;
    // ���������� ������� ��� ���������� �������� ���� � ����
    // ������ �� ���������� � ���� U
    // ��������� ��������� � I
    procedure CalcIByU(AIndex: Integer; var vResStr: String);
    // ���������� �������� ���� �� ������������ ���������
    // �������������� ������ ������� ���������
    // ��������� ��������� � I
    procedure CalcIBySimpleAddParam(var vResStr: String);
    // ���������� ������� �������� ���������� �� ��� ������������� I[SchemaInfo.NodeNUm-1]
    // ��������� ��������� ���������� � ���� U
    procedure CalcUBySimpleParam(var vResStr: String);
    // ���������� ������� ��� ���������� �������� ������������ ����
    function GetIaFormula(AIndex: Integer): String;
    // ���������� ������� ��� ���������� ���������� ������������ ����
    function GetIrFormula(AIndex: Integer): String;
    // ���������� ������� ���������� ������ ���� �� ������� ��������� Ia, Ir
    // ��������� �������� ���� Itotal
    function CalcITotalFormula: String;
    // ���������� ������� ���������� ������ ���� �� ������� ��������� Ia, Ir
    // ��������� �������� ���� PhiTotal
    function CalcPhiTotalFormula: String;
    // �������� ������� � �������� ��� �������� ���������� ������������
    function CalcbFormulaVal(AIndex: Integer; var AFormulaStr: String): double;
    // �������� ������� � �������� ��� �������� �������� ������������
    function CalcgFormulaVal(AIndex: Integer; var AFormulaStr: String): double;
    // �������� �������� ���������� � ���� � ������ ������� t
    function GetUByT(t: double): double;
    function GetUByTFormula: String;
    // �������� �������� ���� � i-�� ����� ���� � ������ ������� t
    function GetIByT(AIndex: Integer; t: double): double;
    function GetITotalByT(t: double): double;
    function GetIByTFormula(AIndex: Integer): String;
    function GetItotalFormula: String;

  end;

implementation

uses SysUtils, uGraphicUtils, Types, Math, uStringUtils, uStringUtilsShared,
  uConstsShared;

{ TElementItem }

constructor TElementItem.Create(AIndex: Integer; AValue: double);
begin
  Index := AIndex;
  Value := AValue;
end;

procedure TElementItem.DrawItem(x, y: Integer; ACanvas: TCanvas);
begin
  // � ���������� ������ ������ ������ �������� ��������
  DrawIndexedText(ItemName, IntToStr(Index), x + ElementWidth div 2 + 3,
    y + ElementHeight div 2, ACanvas);
end;

function TElementItem.GetFormulaName: String;
begin
  Result := ItemName + '_' + IntToStr(Index);
end;

{ TElementItemR }

constructor TElementItemR.Create(AIndex: Integer; AValue: double);
begin
  inherited;
  ItemName := 'R';
  ElementWidth := 16;
  ElementHeight := 30;
end;

procedure TElementItemR.DrawItem(x, y: Integer; ACanvas: TCanvas);
var
  vRect: TRect;
begin
  ACanvas.Rectangle(x - ElementWidth div 2, y, x + (ElementWidth shr 1),
    y + ElementHeight);
  inherited;
end;

procedure TElementItemR.GetFormulaR(ASchemaInfo: TSchemaInfo;
  AFormula: TFormula);
begin
  AFormula.FormulaStr := GetFormulaName;
  AFormula.AddReplaceTerm(AFormula.FormulaStr, Value);
end;

function TElementItemR.GetFormulaRValue(ASchemaInfo: TSchemaInfo): double;
begin
  Result := Value;
end;

{ TElementItemL }

constructor TElementItemL.Create(AIndex: Integer; AValue: double);
begin
  inherited;
  ItemName := 'L';
  ElementWidth := 10;
  ElementHeight := 30;
end;

procedure TElementItemL.DrawItem(x, y: Integer; ACanvas: TCanvas);
// ���������� ������ � �������
const
  ArcCnt = 3;
var
  I: Integer;
  vRect: TRect;
  delta: Integer;
begin
  // ������� ������������� ��� �������
  vRect := TRect.Create(x, y, x + ElementWidth, y + ElementHeight);
  ACanvas.FillRect(vRect);
  delta := Trunc(ElementHeight / ArcCnt);
  // ������ �������
  for I := 1 to ArcCnt do
  begin
    ACanvas.MoveTo(x, y + I * delta);
    ACanvas.AngleArc(x, y + (I - 1) * delta + delta div 2, delta div 2,
      -90, 180);
  end;
  inherited;
end;

procedure TElementItemL.GetFormulaR(ASchemaInfo: TSchemaInfo;
  AFormula: TFormula);
begin
  AFormula.FormulaStr := 'X_' + GetFormulaName;
  AFormula.AddReplaceTerm(AFormula.FormulaStr, GetFormulaRValue(ASchemaInfo));
end;

function TElementItemL.GetFormulaRValue(ASchemaInfo: TSchemaInfo): double;
begin
  if ASchemaInfo.CalcType = ctRXX then
    Result := Value
  else
    Result := ASchemaInfo.W * Value;
end;

{ TElementItem� }

constructor TElementItemC.Create(AIndex: Integer; AValue: double);
begin
  inherited;
  ItemName := '�';
  ElementWidth := 24;
  ElementHeight := 8;
end;

procedure TElementItemC.DrawItem(x, y: Integer; ACanvas: TCanvas);
var
  vRect: TRect;
begin
  // ������� ������������� ��� ������������
  vRect := TRect.Create(x - ElementWidth div 2, y, x + ElementWidth div 2,
    y + ElementHeight);
  ACanvas.FillRect(vRect);
  // ������ ������� ��������
  ACanvas.MoveTo(x - ElementWidth div 2, y);
  ACanvas.LineTo(x + ElementWidth div 2, y);
  // ������ ������ ��������
  ACanvas.MoveTo(x - ElementWidth div 2, y + ElementHeight);
  ACanvas.LineTo(x + ElementWidth div 2, y + ElementHeight);
  inherited;
end;

procedure TElementItemC.GetFormulaR(ASchemaInfo: TSchemaInfo;
  AFormula: TFormula);
begin
  AFormula.FormulaStr := 'X_' + GetFormulaName;
  AFormula.AddReplaceTerm(AFormula.FormulaStr, GetFormulaRValue(ASchemaInfo));
end;

function TElementItemC.GetFormulaRValue(ASchemaInfo: TSchemaInfo): double;
begin
  if ASchemaInfo.CalcType = ctRXX then
    Result := Value
  else
    Result := 1 / ASchemaInfo.W / Value;
end;

{ TRLCList }

procedure TRLCList.Add(r, l, c: double);
begin
  SetLength(FR, Length(FR) + 1);
  SetLength(FL, Length(FL) + 1);
  SetLength(FC, Length(FC) + 1);
  SetLength(FI, Length(FI) + 1);

  if (r <> cnstNotSetValue) and (r <> 0) then
    FR[NodesCount - 1] := TElementItemR.Create(NodesCount, r)
  else
    FR[NodesCount - 1] := nil;

  if (l <> cnstNotSetValue) and (l <> 0) then
    FL[NodesCount - 1] := TElementItemL.Create(NodesCount, l)
  else
    FL[NodesCount - 1] := nil;

  if (c <> cnstNotSetValue) and (c <> 0) then
    FC[NodesCount - 1] := TElementItemC.Create(NodesCount, c)
  else
    FC[NodesCount - 1] := nil;
end;

function TRLCList.CalcbFormulaVal(AIndex: Integer;
  var AFormulaStr: String): double;
var
  vFormulaL, vFormulaC: TFormula;
  vL, vC: double;
  vStr: String;
begin
  if not Assigned(l[AIndex]) and not Assigned(c[AIndex]) then
  begin
    AFormulaStr := 'b_' + IntToStr(AIndex + 1) + '=0';
    Result := 0;
  end
  else
  begin
    vFormulaL := TFormula.Create;
    vFormulaC := TFormula.Create;
    vL := 0;
    vC := 0;
    try
      // ��������� ������� ������������� ��� ������� �
      if Assigned(l[AIndex]) then
      begin
        l[AIndex].GetFormulaR(SchemaInfo, vFormulaL);
        vL := l[AIndex].GetFormulaRValue(SchemaInfo);
      end;
      if Assigned(c[AIndex]) then
      begin
        c[AIndex].GetFormulaR(SchemaInfo, vFormulaC);
        vC := c[AIndex].GetFormulaRValue(SchemaInfo);
      end;

      // XL-Xc
      vFormulaL.SplitFormula(vFormulaC, '-');
      // ��������� ������� � Z_i
      vStr := 'Z_' + IntToStr(AIndex + 1);
      vStr := StrPower(vStr, 2);
      vFormulaL.AddReplaceTerm(vStr, Z[AIndex]);
      vFormulaL.FormulaStr := '(' + vFormulaL.FormulaStr + ')/(' + vStr + ')';
      Result := (vL - vC) / Sqr(Z[AIndex]);
      AFormulaStr := 'b_' + IntToStr(AIndex + 1) + '=' + vFormulaL.FormulaStr +
        '=' + vFormulaL.GetFormulaValue + '=' + PrepareDouble(Result);
    finally
      FreeAndNil(vFormulaL);
      FreeAndNil(vFormulaC);
    end;
  end;
end;

function TRLCList.CalcgFormulaVal(AIndex: Integer;
  var AFormulaStr: String): double;
var
  vFormula: TFormula;
begin
  if not Assigned(r[AIndex]) then
  begin
    AFormulaStr := 'g_' + IntToStr(AIndex + 1) + '=0';
    Result := 0;
  end
  else
  begin
    Result := r[AIndex].GetFormulaRValue(SchemaInfo) / Sqr(Z[AIndex]);
    vFormula := TFormula.Create;
    try
      vFormula.FormulaStr := 'R_i/(Z_i)^2';
      vFormula.AddReplaceTerm('R_i', r[AIndex].GetFormulaRValue(SchemaInfo));
      vFormula.AddReplaceTerm('Z_i', Z[AIndex]);
      vFormula.ReplaceIndexes(AIndex + 1);
      AFormulaStr := 'g_' + IntToStr(AIndex + 1) + '=' + vFormula.FormulaStr +
        '=' + vFormula.GetFormulaValue + '=' + PrepareDouble(Result);
    finally
      FreeAndNil(vFormula);
    end;
  end;
end;

procedure TRLCList.CalcIBySimpleAddParam(var vResStr: String);
var
  vI: Integer;
  vIStr: String;
  vFormula: TFormula;

begin
  // ������� ����� �������� ������ ��� "�������" ���������
  Assert(SchemaInfo.AddParamType in TNeedNodeParamSet,
    '����������: CalcIBySimpleAddParam ����� ��������� ���� ��� "�������" ���������� ���������');
  vI := SchemaInfo.AddParamNodeNum - 1;
  vIStr := IntToStr(SchemaInfo.AddParamNodeNum);
  vResStr := 'I_' + vIStr;
  vFormula := TFormula.Create;
  try

    case SchemaInfo.AddParamType of
      apPRi:
        begin
          vFormula.FormulaStr := 'sqrt((P_R_i)/(R_i))';
          vFormula.AddReplaceTerm('P_R_i', SchemaInfo.AddParamValue);
          vFormula.AddReplaceTerm('R_i', r[vI].GetFormulaRValue(SchemaInfo));
          FI[vI] := sqrt(SchemaInfo.AddParamValue / r[vI].GetFormulaRValue
            (SchemaInfo));
        end;
      apUri:
        begin
          vFormula.FormulaStr := 'U_R_i/R_i';
          vFormula.AddReplaceTerm('U_R_i', SchemaInfo.AddParamValue);
          vFormula.AddReplaceTerm('R_i', r[vI].GetFormulaRValue(SchemaInfo));
          FI[vI] := SchemaInfo.AddParamValue / r[vI].GetFormulaRValue
            (SchemaInfo);
        end;
      apUli:
        begin
          vFormula.FormulaStr := 'U_L_i/X_L_i';
          vFormula.AddReplaceTerm('U_L_i', SchemaInfo.AddParamValue);
          vFormula.AddReplaceTerm('X_L_i', l[vI].GetFormulaRValue(SchemaInfo));
          FI[vI] := SchemaInfo.AddParamValue / l[vI].GetFormulaRValue
            (SchemaInfo);
        end;
      apUci:
        begin
          vFormula.FormulaStr := 'U_C_i/X_C_i';
          vFormula.AddReplaceTerm('U_C_i', SchemaInfo.AddParamValue);
          vFormula.AddReplaceTerm('X_C_i', c[vI].GetFormulaRValue(SchemaInfo));
          FI[vI] := SchemaInfo.AddParamValue / c[vI].GetFormulaRValue
            (SchemaInfo);
        end;
      apQli:
        begin
          vFormula.FormulaStr := 'sqrt(Q_L_i/X_L_i)';
          vFormula.AddReplaceTerm('Q_L_i', SchemaInfo.AddParamValue);
          vFormula.AddReplaceTerm('X_L_i', l[vI].GetFormulaRValue(SchemaInfo));
          FI[vI] := sqrt(SchemaInfo.AddParamValue / l[vI].GetFormulaRValue
            (SchemaInfo));
        end;
      apQci:
        begin
          vFormula.FormulaStr := 'sqrt(|Q_C_i/X_C_i|)';
          vFormula.AddReplaceTerm('Q_C_i', SchemaInfo.AddParamValue);
          vFormula.AddReplaceTerm('X_C_i', c[vI].GetFormulaRValue(SchemaInfo));
          FI[vI] := sqrt(abs(SchemaInfo.AddParamValue / c[vI].GetFormulaRValue
            (SchemaInfo)));
        end;
      apSi:
        begin
          vFormula.FormulaStr := 'sqrt(S_i/Z_i)';
          vFormula.AddReplaceTerm('S_i', SchemaInfo.AddParamValue);
          vFormula.AddReplaceTerm('Z_i', Z[vI]);
          FI[vI] := sqrt(SchemaInfo.AddParamValue / Z[vI]);
        end;
      apIi:
       begin
         vFormula.FormulaStr := '';
         FI[vI] := SchemaInfo.AddParamValue;
       end;
    end;
    vFormula.ReplaceIndexes(vI + 1);
    vResStr := vResStr + '=' + vFormula.FormulaStr + '=' +
      vFormula.GetFormulaValue + '=' + PrepareDouble(FI[vI]);
  finally
    FreeAndNil(vFormula);
  end;
end;

procedure TRLCList.CalcIByU(AIndex: Integer; var vResStr: String);
var
  vFormula: TFormula;
  vI: Integer;
begin
  vI := AIndex + 1;
  vResStr := 'I_' + IntToStr(vI) + '=';
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := 'U/Z_' + IntToStr(vI);
    vFormula.AddReplaceTerm('U', U);
    vFormula.AddReplaceTerm('Z_' + IntToStr(vI), Z[AIndex]);
    vResStr := vResStr + vFormula.FormulaStr + '=' + vFormula.GetFormulaValue;
    FI[AIndex] := U / Z[AIndex];
    vResStr := vResStr + '=' + PrepareDouble(FI[AIndex]);
  finally
    FreeAndNil(vFormula);
  end;
end;

function TRLCList.CalcITotalFormula: String;
var
  I: Integer;
  vSuma, vSumr: double;
  vStra, vStrr: String;
  vFormula: TFormula;
begin
  vSuma := 0;
  vSumr := 0;

  vFormula := TFormula.Create;
  try
    // ������������  �������� ���������
    for I := 0 to NodesCount - 1 do
    begin
      vFormula.AddReplaceTerm('I_a_' + IntToStr(I + 1), Ia[I]);
      vSuma := vSuma + Ia[I];

      vFormula.AddReplaceTerm('I_p_' + IntToStr(I + 1), Ir[I]);
      vSumr := vSumr + Ir[I];
    end;
    Itotal := sqrt(Sqr(vSuma) + Sqr(vSumr));
    // ��������� ������ �������
    vStra := GetSumStrFormula('I_a', NodesCount);
    vStrr := GetSumStrFormula('I_p', NodesCount);

    vStra := StrPower(vStra, 2);
    vStrr := StrPower(vStrr, 2);
    vFormula.FormulaStr := 'sqrt(' + vStra + '+' + vStrr + ')';

    Result := 'I=' + vFormula.FormulaStr + '=' + vFormula.GetFormulaValue + '='
      + PrepareDouble(Itotal);
  finally
    FreeAndNil(vFormula);
  end;
end;

function TRLCList.CalcPhiTotalFormula: String;
var
  I: Integer;
  vSuma, vSumr: double;
  vStra, vStrr: String;
  vFormula: TFormula;
begin
  vSuma := 0;
  vSumr := 0;

  vFormula := TFormula.Create;
  try
    // ������������  �������� ���������
    for I := 0 to NodesCount - 1 do
    begin
      vFormula.AddReplaceTerm('I_a_' + IntToStr(I + 1), Ia[I]);
      vSuma := vSuma + Ia[I];

      vFormula.AddReplaceTerm('I_p_' + IntToStr(I + 1), Ir[I]);
      vSumr := vSumr + Ir[I];
    end;
    // Assert(vSuma <> 0, '����������: ��� ��������� ���� Phi �������� �������� ��� = 0');

    // ����� � �������� �� 0 ��� �������� ����
    if RoundTo(vSuma, cnstRoundPref) = 0 then
    begin
      if vSumr > 0 then
        PhiTotal := pi / 2
      else
        PhiTotal := -pi / 2;
    end
    else
      PhiTotal := RoundTo(ArcTan(vSumr / vSuma), cnstRoundPref);

    // ��������� ������ �������
    vStra := GetSumStrFormula('I_a', NodesCount);
    vStrr := GetSumStrFormula('I_p', NodesCount);

    vFormula.FormulaStr := '(' + vStrr + ')/(' + vStra + ')';
    Result := 'tg(phi)=' + vFormula.FormulaStr + ',';
    vFormula.FormulaStr := 'arctg((' + vStrr + ')/(' + vStra + '))';
    Result := Result + 'phi=' + vFormula.FormulaStr + '=' +
      vFormula.GetFormulaValue + '=' + PrepareDouble(RadToDeg(PhiTotal)) + '^0';
  finally
    FreeAndNil(vFormula);
  end;
end;

procedure TRLCList.CalcUBySimpleParam(var vResStr: String);
var
  vFormula: TFormula;
  vI: Integer;
begin
  vFormula := TFormula.Create;
  vResStr := 'U=';
  try
    vFormula.FormulaStr := 'I_i*.Z_i';
    vI := SchemaInfo.AddParamNodeNum - 1;
    vFormula.AddReplaceTerm('I_i', FI[vI]);
    vFormula.AddReplaceTerm('Z_i', Z[vI]);
    vFormula.ReplaceIndexes(vI + 1);
    U := FI[vI] * Z[vI];
    vResStr := vResStr + vFormula.FormulaStr + '=' + vFormula.GetFormulaValue +
      '=' + PrepareDouble(U);
  finally
    vFormula.Free;
  end;
end;

constructor TRLCList.Create(ASchemaInfo: TSchemaInfo);
begin
  SetLength(FR, 0);
  SetLength(FL, 0);
  SetLength(FC, 0);
  SetLength(FI, 0);
  SchemaInfo := ASchemaInfo;
end;

function TRLCList.GetC(Index: Integer): TElementItemC;
begin
  Assert(Index < NodesCount, '���������� � GetC ��������� ������ ' +
    IntToStr(Index) + ' ��� ������� ������ ' + IntToStr(NodesCount));
  Result := FC[Index];
end;

function TRLCList.GetFormulaArcsinValue(AIndex: Integer): double;
begin
  Result := ArcSin(GetFormulaSinValue(AIndex));
end;

procedure TRLCList.GetFormulaR(AIndex: Integer; AFormula: TFormula);
const
  cnstResFmt = 'Sqrt(%s)';
var
  vFormulaL, vFormulaR, vFormulaC: TFormula;
begin
  vFormulaL := TFormula.Create;
  vFormulaR := TFormula.Create;
  vFormulaC := TFormula.Create;
  try
    if Assigned(r[AIndex]) then
      r[AIndex].GetFormulaR(SchemaInfo, vFormulaR);
    if Assigned(l[AIndex]) then
      l[AIndex].GetFormulaR(SchemaInfo, vFormulaL);
    if Assigned(c[AIndex]) then
      c[AIndex].GetFormulaR(SchemaInfo, vFormulaC);
    // R^2
    vFormulaR.FormulaStr := StrPower(vFormulaR.FormulaStr, 2);
    // L-C
    vFormulaL.SplitFormula(vFormulaC, '-');
    // (L-c)^2
    vFormulaL.FormulaStr := StrPower(vFormulaL.FormulaStr, 2);
    vFormulaR.SplitFormula(vFormulaL, '+');
    AFormula.Copy(vFormulaR);
    if AFormula.FormulaStr <> '' then
      AFormula.FormulaStr := Format(cnstResFmt, [AFormula.FormulaStr]);
  finally
    FreeAndNil(vFormulaL);
    FreeAndNil(vFormulaR);
    FreeAndNil(vFormulaC);
  end;
end;

procedure TRLCList.GetFormulaSin(AIndex: Integer; AFormula: TFormula);
var
  vFormulaL, vFormulaC: TFormula;
  vStr: String;
begin
  // ���� � ����� ��� �� ������� �� ������������ �� � ������� ������
  if not Assigned(l[AIndex]) and not Assigned(c[AIndex]) then
    AFormula.FormulaStr := '0'
  else
  begin
    vFormulaL := TFormula.Create;
    vFormulaC := TFormula.Create;
    try
      // ��������� ������� ������������� ��� ������� �
      if Assigned(l[AIndex]) then
        l[AIndex].GetFormulaR(SchemaInfo, vFormulaL);
      if Assigned(c[AIndex]) then
        c[AIndex].GetFormulaR(SchemaInfo, vFormulaC);
      // XL-Xc
      vFormulaL.SplitFormula(vFormulaC, '-');
      // ��������� ������� � Z_i
      vStr := 'Z_' + IntToStr(AIndex + 1);
      vFormulaL.AddReplaceTerm(vStr, Z[AIndex]);
      vFormulaL.FormulaStr := '(' + vFormulaL.FormulaStr + ')/(' + vStr + ')';
      AFormula.Copy(vFormulaL);
    finally
      FreeAndNil(vFormulaL);
      FreeAndNil(vFormulaC);
    end;
  end;
end;

function TRLCList.GetFormulaSinValue(AIndex: Integer): double;
var
  vZ, vL, vC: double;
begin
  vZ := 0;
  vL := 0;
  vC := 0;
  if Assigned(c[AIndex]) then
    vC := c[AIndex].GetFormulaRValue(SchemaInfo);
  if Assigned(l[AIndex]) then
    vL := l[AIndex].GetFormulaRValue(SchemaInfo);
  vZ := Z[AIndex];
  Result := (vL - vC) / vZ;
end;

function TRLCList.GetI(Index: Integer): double;
begin
  Result := FI[Index];
end;

function TRLCList.GetIa(Index: Integer): double;
begin
  Result := I[Index] * cos(Phi[Index]);
end;

function TRLCList.GetIaFormula(AIndex: Integer): String;
var
  vFormula: TFormula;
begin
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := 'I_i*.cos(phi_i)';
    vFormula.AddReplaceTerm('I_i', I[AIndex]);
    vFormula.AddReplaceTerm('phi_i', RadToDeg(Phi[AIndex]));
    vFormula.ReplaceIndexes(AIndex + 1);
    Result := 'I_a_' + IntToStr(AIndex + 1) + '=' + vFormula.FormulaStr + '=' +
      vFormula.GetFormulaValue + '=' + PrepareDouble(Ia[AIndex]);
  finally
    vFormula.Free;
  end;
end;

function TRLCList.GetIByT(AIndex: Integer; t: double): double;
begin
  case SchemaInfo.ChangeRule of
    uSin:
      Result := I[AIndex] * sqrt(2) * sin(SchemaInfo.W * t + SchemaInfo.W0Deg -
        Phi[AIndex]);
    uCos:
      Result := I[AIndex] * sqrt(2) * cos(SchemaInfo.W * t + SchemaInfo.W0Deg -
        Phi[AIndex]);
  end;
end;

function TRLCList.GetIByTFormula(AIndex: Integer): String;
// To Do ���������� �� ���������
var
  vStr: String;
  vStrW0: String;
  vStrW0Value: String;
  vPhiStr: String;
begin
  case SchemaInfo.ChangeRule of
    uSin:
      vStr := 'sin';
    uCos:
      vStr := 'cos';
  end;
  if SchemaInfo.W0 = 0 then
  begin
    vStrW0 := '';
    vStrW0Value := ''
  end
  else
  begin
    vStrW0 := '+psi_0';
    if SchemaInfo.W0 > 0 then
      vStrW0Value := '+' + PrepareDouble(SchemaInfo.W0) + '^0'
    else
      vStrW0Value := '-' + PrepareDouble(abs(SchemaInfo.W0)) + '^0'
  end;
  if Phi0[AIndex] > 0 then
    vPhiStr := '-' + PrepareDouble(Phi0[AIndex])
  else
    vPhiStr := '+' + PrepareDouble(abs(Phi0[AIndex]));

  Result := 'I(omega*t)_' + IntToStr(AIndex + 1) + '=I_0_' +
    IntToStr(AIndex + 1) + '*.' + vStr + '(omega*t' + vStrW0 + '-phi_' +
    IntToStr(AIndex + 1) + ')=' + PrepareDouble(I[AIndex] * sqrt(2)) + '*' +
    vStr + '(' + PrepareDouble(SchemaInfo.W) + '*t' + vStrW0Value +
    vPhiStr + '^0)';

end;

function TRLCList.GetIr(Index: Integer): double;
begin
  Result := I[Index] * sin(Phi[Index]);
end;

function TRLCList.GetIrFormula(AIndex: Integer): String;
var
  vFormula: TFormula;

begin
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := 'I_i*.sin(phi_i)';
    vFormula.AddReplaceTerm('I_i', I[AIndex]);
    vFormula.AddReplaceTerm('phi_i', RadToDeg(Phi[AIndex]));
    vFormula.ReplaceIndexes(AIndex + 1);
    Result := 'I_p_' + IntToStr(AIndex + 1) + '=' + vFormula.FormulaStr + '=' +
      vFormula.GetFormulaValue + '=' + PrepareDouble(Ir[AIndex]);
  finally
    vFormula.Free;
  end;
end;

function TRLCList.GetITotalByT(t: double): double;
begin
  case SchemaInfo.ChangeRule of
    uSin:
      Result := Itotal * sqrt(2) * sin(SchemaInfo.W * t - PhiTotal +
        SchemaInfo.W0Deg);
    uCos:
      Result := Itotal * sqrt(2) * cos(SchemaInfo.W * t - PhiTotal +
        SchemaInfo.W0Deg);
  end;
end;

function TRLCList.GetItotalFormula: String;
// To Do ���������� �� ���������
var
  vStr: String;
  vStrW0: String;
  vStrW0Value: String;
  vPhiStr: String;
begin
  case SchemaInfo.ChangeRule of
    uSin:
      vStr := 'sin';
    uCos:
      vStr := 'cos';
  end;
  if SchemaInfo.W0 = 0 then
  begin
    vStrW0 := '';
    vStrW0Value := ''
  end
  else
  begin
    vStrW0 := '+psi_0';
    if SchemaInfo.W0 > 0 then
      vStrW0Value := '+' + PrepareDouble(SchemaInfo.W0) + '^0'
    else
      vStrW0Value := '-' + PrepareDouble(abs(SchemaInfo.W0)) + '^0'
  end;

  if PhiTotal > 0 then
    vPhiStr := '-' + PrepareDouble(RadToDeg(PhiTotal)) + '^0'
  else
    vPhiStr := '+' + PrepareDouble(abs(RadToDeg(PhiTotal))) + '^0';

  Result := 'I(omega*t)=I_0*.' + vStr + '(omega*t' + vStrW0 + '-phi)=' +
    PrepareDouble(Itotal * sqrt(2)) + '*' + vStr + '(' +
    PrepareDouble(SchemaInfo.W) + '*t' + vStrW0Value + vPhiStr + ')';
end;

function TRLCList.GetL(Index: Integer): TElementItemL;
begin
  Assert(Index < NodesCount, '���������� � GetL ��������� ������ ' +
    IntToStr(Index) + ' ��� ������� ������ ' + IntToStr(NodesCount));
  Result := FL[Index];
end;

function TRLCList.GetNodesCount: Integer;
begin
  Result := Length(FR);
end;

function TRLCList.Getphi0(AIndex: Integer): double;
begin
  Result := RadToDeg(Phi[AIndex]);
end;

function TRLCList.GetR(Index: Integer): TElementItemR;
begin
  Assert(Index < NodesCount, '���������� � GetR ��������� ������ ' +
    IntToStr(Index) + ' ��� ������� ������ ' + IntToStr(NodesCount));
  Result := FR[Index];
end;

function TRLCList.GetUByT(t: double): double;
begin
  case SchemaInfo.ChangeRule of
    uSin:
      Result := U * sqrt(2) * sin(SchemaInfo.W * t + SchemaInfo.W0Deg);
    uCos:
      Result := U * sqrt(2) * cos(SchemaInfo.W * t + SchemaInfo.W0Deg);
  end;
end;

function TRLCList.GetUByTFormula: String;
var
  vStr: String;
  vStrW0: String;
  vStrW0Value: String;
begin
  case SchemaInfo.ChangeRule of
    uSin:
      vStr := 'sin';
    uCos:
      vStr := 'cos';
  end;
  if SchemaInfo.W0 = 0 then
  begin
    vStrW0 := '';
    vStrW0Value := ''
  end
  else
  begin
    vStrW0 := '+psi_0';
    if SchemaInfo.W0 > 0 then
      vStrW0Value := '+' + PrepareDouble(SchemaInfo.W0)
    else
      vStrW0Value := '-' + PrepareDouble(abs(SchemaInfo.W0))
  end;

  Result := 'U(omega*t)=U_0*' + vStr + '(omega*t' + vStrW0 + ')=' +
    PrepareDouble(U * sqrt(2)) + '*' + vStr + '(' + PrepareDouble(SchemaInfo.W)
    + '*t' + vStrW0Value + '^0)';
end;

function TRLCList.GetZ(Index: Integer): double;
var
  vr, vL, vC: double;
begin
  vr := 0;
  vL := 0;
  vC := 0;
  if Assigned(r[Index]) then
    vr := r[Index].GetFormulaRValue(SchemaInfo);
  if Assigned(l[Index]) then
    vL := l[Index].GetFormulaRValue(SchemaInfo);
  if Assigned(c[Index]) then
    vC := c[Index].GetFormulaRValue(SchemaInfo);
  Result := sqrt(Sqr(vr) + Sqr(vL - vC));
end;

{ TSchemaInfo }

function TSchemaInfo.W0Deg: double;
begin
  Result := RadToDeg(W0);
end;

end.
