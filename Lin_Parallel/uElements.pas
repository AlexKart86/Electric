unit uElements;

// Модуль, описывающий элементы схемы

interface

uses Graphics, uConsts, uFormulaUtils,  jclMath, Math;

type


  // Информация по схеме, заполняется пользователем
  TSchemaInfo = record
    CalcType: TCalcType;
    FreqType: TFreqType;
    ChangeRule: TUChangeRule;
    F: double;
    W: double;
    // Начальная фаза в градусах!!!
    W0: double;
    t0: double;
    t: double;
  public
    function W0Deg: double;
  end;

  // Абстрактный класс, описывающий один элемент схемы
  TElementItem = class
  private
    //Является последовательным в цепи
    FIsParallel: Boolean;
  protected
    // Получить имя компонента в формуле
    function GetFormulaName: String;
  public
    Value: double;
    ElementWidth: Integer;
    ElementHeight: Integer;
    ItemName: String;
    Index: Integer;
    // Нарисовать компонент на канве с координатами начал компонеента x,y
    procedure DrawItem(x, y: Integer; ACanvas: TCanvas); virtual;
    // Выдает формулу для вычислений значения сопротивления
    procedure GetFormulaR(ASchemaInfo: TSchemaInfo; AFormula: TFormula);
      virtual; abstract;
    // Выдает значение сопротивления
    function GetFormulaRValue(ASchemaInfo: TSchemaInfo): double;
      virtual; abstract;
    constructor Create(AIndex: Integer; AValue: double; AIsParallel: Boolean); virtual;
  end;

  // Класс, реализующий работу с сопротивлением
  TElementItemR = class(TElementItem)
  public
    procedure DrawItem(x, y: Integer; ACanvas: TCanvas); override;
    constructor Create(AIndex: Integer; AValue: double; AIsParallel: Boolean); override;
    // Выдает формулу для вычислений значения сопротивления
    procedure GetFormulaR(ASchemaInfo: TSchemaInfo;
      AFormula: TFormula); override;
    // Выдает значение сопротивления
    function GetFormulaRValue(ASchemaInfo: TSchemaInfo): double; override;
  end;

  // Класс, реализующий работу с катушкой
  TElementItemL = class(TElementItem)
  public
    procedure DrawItem(x, y: Integer; ACanvas: TCanvas); override;
    constructor Create(AIndex: Integer; AValue: double; AIsParallel: Boolean); override;
    // Выдает формулу для вычислений значения сопротивления
    procedure GetFormulaR(ASchemaInfo: TSchemaInfo;
      AFormula: TFormula); override;
    // Выдает значение сопротивления
    function GetFormulaRValue(ASchemaInfo: TSchemaInfo): double; override;
  end;

  // Класс, реализующий работу с конденсатором
  TElementItemC = class(TElementItem)
  public
    procedure DrawItem(x, y: Integer; ACanvas: TCanvas); override;
    constructor Create(AIndex: Integer; AValue: double; AIsParallel: Boolean); override;
    // Выдает формулу для вычислений значения сопротивления
    procedure GetFormulaR(ASchemaInfo: TSchemaInfo;
      AFormula: TFormula); override;
    // Выдает значение сопротивления
    function GetFormulaRValue(ASchemaInfo: TSchemaInfo): double; override;
  end;

  TRArr = array of TElementItemR;
  TLArr = array of TElementItemL;
  TCArr = array of TElementItemC;

  //Запись, описывающая дополнительный параметр схемы
  TAddParam = record
    //Тип параметра
    AddParamType: TAddParamType;
    //Тип элемента дополнительного параметра
    AddParamElement: TAddParamElement;
    //Номер ветки цепи. 0 - общий параметр
    NodeNo: Integer;
    //Значение
    Value: Double;
    //Начальная фаза
    W0: Double;
    //Допустим ли номер ветки
    function IsAllowNodeNo: Boolean;
    //Нужен ли номер ветки
    function IsNeedNodeNo: Boolean;
    //Нужна ли начальная фаза
    function IsAllowW0: Boolean;
    //Можно ли вводить R
    function IsAllowR: Boolean;
    //Можно ли вводить L,C
    function IsAllowLC: Boolean;
    //ПОлучить формулу названия параметра
    function GetElementNameFormula: String;
    //Формула элемент = значение
    function GetElementFormula: String;
    //Получить единицу измерения параметра
    function GetElementMeasure:String;
    //Какой тип тока возвращает - комплексный или обычный
    function IsResultComplex: Boolean;
    //Формула для начальной фазы
    function GetW0Fornula: String;
    //Номер возвращаемой ветки
    function ResultNodeNo: Integer;
    //Корректно ли введены данные
    function IsDataCorrect: Boolean;

  end;

  // Список элементов цепи, сгруппированных по веткам
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
    // Возвращает значение сопростивления в i-ой цепи
    function GetZ(Index: Integer): double;
    function GetI(Index: Integer): double;
    function GetIa(Index: Integer): double;
    function GetIr(Index: Integer): double;
    // Возврщает значение угла в модуле 2 в в радианах
    function GetFormulaArcsinValue(AIndex: Integer): double;
    // Возвращает значение угла в модуле 2 в градусах
    function Getphi0(AIndex: Integer): double;
  public
    SchemaInfo: TSchemaInfo;
    AddParam: TAddParam;
    U: double;
    // Общий ток в цепи
    Itotal: double;

    //Общее сопротивление параллельных веток
    Z_Parallel: TPolarComplex;
    Z_Total: TRectComplex;
     //Напряжение параллельной ветки
    UParal: TPolarComplex;


    // Общее сопротивление
    function ZTotal: double;
    // Общее реактивное сопротивление
    function XrTotal: double;
    // Общее активное сопротивление
    function RaTotal: double;
    // Общий угол в радианах
    function PhiTotal: double;


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
    // Значение синуса угла в радианах
    property Phi[Index: Integer]: double read GetFormulaArcsinValue;
    // значение синуса угла в градусах
    property Phi0[Index: Integer]: double read Getphi0;

    // Возвращает формулу рассчета сопротивления для всех єдементов цепи
    procedure GetFormulaR(AIndex: Integer; AFormula: TFormula);
    // Возвращает формулу для рассчета синусов смещения фаз для веток цепи
    procedure GetFormulaSin(AIndex: Integer; AFormula: TFormula);
    function GetFormulaSinValue(AIndex: Integer): double;
    // Возвращает формулы для вычисления значения тока в цепи
    // исходя из напряжения в сети U
    // Результат заносится в I
    procedure CalcIByU(AIndex: Integer; var vResStr: String);
    // Возвращает значение тока по специальному параметру
    // Поддерживаются только простые параметры
    // Результат заносится в I
    //procedure CalcIBySimpleAddParam(var vResStr: String);
    // Возвращает формулу рассчета напряжения по уже подсчитанному I[SchemaInfo.NodeNUm-1]
    // Заполняет найденное напряжение в поле U
    //procedure CalcUBySimpleParam(var vResStr: String);
    // Возвращает формулу для вычисления актинвой составляющей тока
    function GetIaFormula(AIndex: Integer): String;
    // Возвращает формулу для вычисления реактивной составляющей тока
    function GetIrFormula(AIndex: Integer): String;
    // Возврашает формулу вычисления общего тока по готовым значениям Ia, Ir
    // Заполняем значение тока Itotal
    function CalcITotalFormula: String;
    // Возвращает формулу вычисления общего угла по готовым значениям Ia, Ir
    // Заполняет значение угла PhiTotal
    function CalcPhiTotalFormula: String;
    // Получает формулу и значение для рассчета реактивной проводимости
    function CalcbFormulaVal(AIndex: Integer; var AFormulaStr: String): double;
    // Получает формулу и значение для рассчета активной проводтмости
    function CalcgFormulaVal(AIndex: Integer; var AFormulaStr: String): double;
    // Получаем значение напряжения в цепи в момент времени t
    function GetUByT(t: double): double;
    function GetUByTFormula: String;
    // Получаем значение тока в i-ой ветки цепи в момент времени t
    function GetIByT(AIndex: Integer; t: double): double;
    function GetITotalByT(t: double): double;

    function GetItotalFormula: String;



    ///Новые процедуры
    // Получить сопротивление участвка цепи в компексной форме
    function GetZ_(Index: Integer): TPolarComplex;
    //Получить формулу рассчета сопротивления в комплексной форме
    function GetZ_Formula(Index: Integer): String;
    //Рассчитать общее сопротивление параллельных веток
    procedure CalcZ_Parallel;
    //Возвращает формулу рассчета полного сопротивления параллельны
    procedure GetZ_Parallel_Formula(var APart1: String; var APart2: String; var APart3: String);
    //Вычисляет значение полного сопротивления
    procedure CalcZ_Total;
    //Возврашает формулу рассчета полного сопротивления
    function GetZ_TotalFormula: String;
    //Возвращает значение комплексного тока по дополнительному параметру
    function GetIByAddParamC: TPolarComplex;
    function GetIByAddParam: Double;
    //Получить ток в I-ой ветке
    function GetI_(Index: Integer): TPolarComplex;
    //Получить напряжение UR в ветке
    function GetUR_(Index: Integer): TPolarComplex;
    function GetURFormula(Index: Integer): String;
    //ПОлучить напряжение Ul в ветке
    function GetUl_(Index: Integer): TPolarComplex;
    function GetULFormula(Index: Integer): String;
    //ПОлучить напряжение UC в ветке
    function GetUC_(Index: Integer): TPolarComplex;
    function GetUCFormula(Index: Integer): String;
    //Напруга на вході
    function GetUTotal: TPolarComplex;
    function GetUTotalFormula: String;
    //Напруга на паралельних гілках
    function GetUParal: TPolarComplex;
    function GetUParalFormula: String;

    //Напруга в гілці 1
    function GetU1: TPolarComplex;
    function GetU1Formula: String;
    //PR
    function GetPr(Index: Integer): Double;
    function GetPrFormula(Index: Integer): String;
    //QL
    function GetQl(Index: Integer): Double;
    function GetQlFormula(Index: Integer): String;
    //QC
    function GetQC(Index: Integer): Double;
    function GetQCFormula(Index: Integer): String;
    //S
    function GetS: TPolarComplex;
    function GetSFormula: String;
    //P
    function GetP: Double;
    function GetPFormula: String;
    //Q
    function GetQ: Double;
    function GetQFormula: String;

    //I(t)
     function GetIByTFormula(AIndex: Integer): String;
     function GetUtotalByTFormula: String;
     function GetU1ByTFormula: String;
     function GetUparalbyTFormula: String;







  end;

implementation

uses SysUtils, uGraphicUtils, Types, uStringUtils, uStringUtilsShared,
  uConstsShared, uComplexUtils, StrUtils, uRounding;

{ TElementItem }

constructor TElementItem.Create(AIndex: Integer; AValue: double; AIsParallel: Boolean);
begin
  FIsParallel := AIsParallel;
  Index := AIndex;
  Value := AValue;
end;

procedure TElementItem.DrawItem(x, y: Integer; ACanvas: TCanvas);
begin
  // В реализации предка рисуем только название єлемента
  if FIsParallel then
   DrawIndexedText(ItemName, IntToStr(Index), x + ElementWidth div 2 + 3,
     y + ElementHeight div 2, ACanvas)
  else
   DrawIndexedText(ItemName, IntToStr(Index), x + ElementWidth div 2,
     y + ElementHeight + 2, ACanvas, True)

end;

function TElementItem.GetFormulaName: String;
begin
  Result := ItemName + '_' + IntToStr(Index);
end;

{ TElementItemR }

constructor TElementItemR.Create(AIndex: Integer; AValue: double; AIsParallel: Boolean);
begin
  inherited;
  ItemName := 'R';
  if AIsParallel then
  begin
    ElementWidth := 16;
    ElementHeight := 30;
  end
  else
  begin
    ElementWidth := 30;
    ElementHeight := 14;
  end;
end;

procedure TElementItemR.DrawItem(x, y: Integer; ACanvas: TCanvas);
var
  vRect: TRect;
begin
  if FIsParallel then
    ACanvas.Rectangle(x - ElementWidth div 2, y, x + (ElementWidth shr 1),
       y + ElementHeight)
  else
   ACanvas.Rectangle(x, y-(ElementHeight shr 1), x + ElementWidth, y+(ElementHeight shr 1));
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

constructor TElementItemL.Create(AIndex: Integer; AValue: double; AIsParallel: Boolean);
begin
  inherited;
  ItemName := 'L';
  if AIsParallel then
  begin
    ElementWidth := 10;
    ElementHeight := 30;
  end
  else
  begin
    ElementWidth := 30;
    ElementHeight := 16;
  end;
end;

procedure TElementItemL.DrawItem(x, y: Integer; ACanvas: TCanvas);
// Количество витков в катушке
const
  ArcCnt = 3;
var
  I: Integer;
  vRect: TRect;
  delta: Integer;
begin
  // Очищаем прямоугольник под катушку
  vRect := TRect.Create(x, y, x + ElementWidth, y + ElementHeight);
  ACanvas.FillRect(vRect);
  if FIsParallel then
  begin
    delta := Trunc(ElementHeight / ArcCnt);
    // Рисуем катушку
    for I := 1 to ArcCnt do
    begin
      ACanvas.MoveTo(x, y + I * delta);
      ACanvas.AngleArc(x, y + (I - 1) * delta + delta div 2, delta div 2,
        -90, 180);
    end;
  end
  else
  begin
    delta := Trunc(ElementWidth / ArcCnt);
    // Рисуем катушку
    for I := 1 to ArcCnt do
    begin
      ACanvas.MoveTo(x+i*delta, y);
      ACanvas.AngleArc(x+(i-1)*delta + delta div 2, y, delta div 2,
        0, 180);
    end;
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

{ TElementItemС }

constructor TElementItemC.Create(AIndex: Integer; AValue: double; AIsParallel: Boolean);
begin
  inherited;
  ItemName := 'С';
  if AIsParallel then
  begin
    ElementWidth := 24;
    ElementHeight := 8;
  end
  else
  begin
   ElementWidth := 8;
   ElementHeight := 24;
  end;
end;

procedure TElementItemC.DrawItem(x, y: Integer; ACanvas: TCanvas);
var
  vRect: TRect;
begin
  if FIsParallel then
  begin
    // Очищаем прямоугольник под кондекнсатор
    vRect := TRect.Create(x - ElementWidth div 2, y, x + ElementWidth div 2,
      y + ElementHeight);
    ACanvas.FillRect(vRect);
    // Рисуем верхнюю пластину
    ACanvas.MoveTo(x - ElementWidth div 2, y);
    ACanvas.LineTo(x + ElementWidth div 2, y);
    // Рисуем нижнюю пластину
    ACanvas.MoveTo(x - ElementWidth div 2, y + ElementHeight);
    ACanvas.LineTo(x + ElementWidth div 2, y + ElementHeight);
  end
  else
  begin
   // Очищаем прямоугольник под кондекнсатор
    vRect := TRect.Create(x, y-ElementHeight div 2, x + ElementWidth,
      y + ElementHeight div 2);
    ACanvas.FillRect(vRect);
    // Рисуем левую пластину
    ACanvas.MoveTo(x , y-ElementHeight div 2);
    ACanvas.LineTo(x,  y+ElementHeight div 2);
    // Рисуем правую пластину
    ACanvas.MoveTo(x+ElementWidth, y-ElementHeight div 2);
    ACanvas.LineTo(x+ElementWidth,  y+ElementHeight div 2);
  end;
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
    FR[NodesCount - 1] := TElementItemR.Create(NodesCount, r, NodesCount>1)
  else
    FR[NodesCount - 1] := nil;

  if (l <> cnstNotSetValue) and (l <> 0) then
    FL[NodesCount - 1] := TElementItemL.Create(NodesCount, l, NodesCount>1)
  else
    FL[NodesCount - 1] := nil;

  if (c <> cnstNotSetValue) and (c <> 0) then
    FC[NodesCount - 1] := TElementItemC.Create(NodesCount, Abs(c), NodesCount>1)
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
      // Заполняем формулы сопротивлений для катушки и
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
      // Формируем строчку с Z_i
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

{procedure TRLCList.CalcIBySimpleAddParam(var vResStr: String);
var
  vI: Integer;
  vIStr: String;
  vFormula: TFormula;

begin
  // Функцию можно вызывать только для "Простих" параметрів
  Assert(SchemaInfo.AddParamType in TNeedNodeParamSet,
    'Розробнику: CalcIBySimpleAddParam можна викликати лише для "простих" додаткових параметрів');
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
end;      }

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
    // Рассчитываем  значение выражения
    for I := 0 to NodesCount - 1 do
    begin
      vFormula.AddReplaceTerm('I_a_' + IntToStr(I + 1), Ia[I]);
      vSuma := vSuma + Ia[I];

      vFormula.AddReplaceTerm('I_p_' + IntToStr(I + 1), Ir[I]);
      vSumr := vSumr + Ir[I];
    end;
    Itotal := sqrt(Sqr(vSuma) + Sqr(vSumr));
    // Формируем строку формулы
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

{  vFormula := TFormula.Create;
  try
    // Рассчитываем  значение выражения
    for I := 0 to NodesCount - 1 do
    begin
      vFormula.AddReplaceTerm('I_a_' + IntToStr(I + 1), Ia[I]);
      vSuma := vSuma + Ia[I];

      vFormula.AddReplaceTerm('I_p_' + IntToStr(I + 1), Ir[I]);
      vSumr := vSumr + Ir[I];
    end;
    // Assert(vSuma <> 0, 'Розробнику: при обчисленні кута Phi сумарний активний ток = 0');

    // Возня с делением на 0 при рассчете угла
    if RoundTo(vSuma, cnstRoundPref) = 0 then
    begin
      if vSumr > 0 then
        PhiTotal := pi / 2
      else
        PhiTotal := -pi / 2;
    end
    else
      PhiTotal := RoundTo(ArcTan(vSumr / vSuma), cnstRoundPref);

    // Формируем строку формулы
    vStra := GetSumStrFormula('I_a', NodesCount);
    vStrr := GetSumStrFormula('I_p', NodesCount);

    vFormula.FormulaStr := '(' + vStrr + ')/(' + vStra + ')';
    Result := 'tg(phi)=' + vFormula.FormulaStr + ',';
    vFormula.FormulaStr := 'arctg((' + vStrr + ')/(' + vStra + '))';
    Result := Result + 'phi=' + vFormula.FormulaStr + '=' +
      vFormula.GetFormulaValue + '=' + PrepareDouble(Math.RadToDeg(PhiTotal)) + '^0';
  finally
    FreeAndNil(vFormula);
  end; }
end;

{procedure TRLCList.CalcUBySimpleParam(var vResStr: String);
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
end;  }

procedure TRLCList.CalcZ_Parallel;
var
  i: Integer;
begin
  Z_Parallel := 0;
  //Не учитываем первую ветку
  for i := 1 to NodesCount-1 do
    Z_Parallel := Z_Parallel + (1/GetZ_(i));
  Z_Parallel := 1/Z_Parallel;
end;

procedure TRLCList.CalcZ_Total;
begin
  Z_Total := Z_Parallel + GetZ_(0);
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
  Assert(Index < NodesCount, 'Розробнику в GetC переданий індекс ' +
    IntToStr(Index) + ' але довжина масива ' + IntToStr(NodesCount));
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
  // Если в ветке нет ни катушки ни конденсатора то и считать нечего
  if not Assigned(l[AIndex]) and not Assigned(c[AIndex]) then
    AFormula.FormulaStr := '0'
  else
  begin
    vFormulaL := TFormula.Create;
    vFormulaC := TFormula.Create;
    try
      // Заполняем формулы сопротивлений для катушки и
      if Assigned(l[AIndex]) then
        l[AIndex].GetFormulaR(SchemaInfo, vFormulaL);
      if Assigned(c[AIndex]) then
        c[AIndex].GetFormulaR(SchemaInfo, vFormulaC);
      // XL-Xc
      vFormulaL.SplitFormula(vFormulaC, '-');
      // Формируем строчку с Z_i
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
    vFormula.AddReplaceTerm('phi_i', Math.RadToDeg(Phi[AIndex]));
    vFormula.ReplaceIndexes(AIndex + 1);
    Result := 'I_a_' + IntToStr(AIndex + 1) + '=' + vFormula.FormulaStr + '=' +
      vFormula.GetFormulaValue + '=' + PrepareDouble(Ia[AIndex]);
  finally
    vFormula.Free;
  end;
end;

function TRLCList.GetIByAddParam: Double;
begin
  if //U, psi_U, U_max
     ( (AddParam.AddParamType in [apU, apUmax, apUparal, apUmaxParal]) and
       (AddParam.NodeNo = cnstNotSetValue)) or
      (
        (AddParam.AddParamType in [apU, apUMax]) and
        (AddParam.NodeNo >= 0) and
        (AddParam.AddParamElement in [apeNone, apeR, apeL, apeC] )
      )  then
   Result := GetIByAddParamC.Radius;
  //P
  if( AddParam.AddParamType = apP) and
     (AddParam.NodeNo = cnstNotSetValue) then
   Result := sqrt(RndArr.FormatDouble(AddParam.Value, cP)/ RndArr.FormatDouble(Z_Total.Re, cR));

  //Q
  if (AddParam.AddParamType = apQ) and
     (AddParam.NodeNo = cnstNotSetValue) then
   Result := sqrt(Abs(RndArr.FormatDouble(AddParam.Value, cP)/ RndArr.FormatDouble(Z_Total.Im, cR)));

  //S
  if (AddParam.AddParamType = apS) and
     (AddParam.NodeNo = cnstNotSetValue) then
   Result := sqrt(Abs(RndArr.FormatDouble(AddParam.Value, cP)/ RndArr.FormatDouble(ZTotal, cR)));

  //I
  if AddParam.AddParamType = apI then
    Result := AddParam.Value;

  //IMax
  if AddParam.AddParamType = apImax then
    Result := AddParam.Value / sqrt(2);


  //Pi
  if (AddParam.AddParamType = apP) and
     (AddParam.NodeNo > cnstNotSetValue) and
     (AddParam.AddParamElement = apeNone) then
  begin
    Result := Sqrt(AddParam.Value/r[AddParam.NodeNo].GetFormulaRValue(SchemaInfo));
  end;

  //Qi
  if (AddParam.AddParamType = apQ) and
     (AddParam.NodeNo > cnstNotSetValue) and
     (AddParam.AddParamElement = apeNone) then
  begin
    Result := Sqrt(AddParam.Value/abs(l[AddParam.NodeNo].GetFormulaRValue(SchemaInfo)-
       c[AddParam.NodeNo].GetFormulaRValue(SchemaInfo)));
  end;

  //Si
  if (AddParam.AddParamType = apS) and
     (AddParam.NodeNo > cnstNotSetValue) and
     (AddParam.AddParamElement = apeNone) then
  begin
    Result := Sqrt(AddParam.Value/z[AddParam.NodeNo]);
  end;

  //QLi
  if (AddParam.AddParamType = apQ) and
     (AddParam.NodeNo > cnstNotSetValue) and
     (AddParam.AddParamElement = apeL) then
  begin
    Result := Sqrt(AddParam.Value/l[AddParam.NodeNo].GetFormulaRValue(SchemaInfo));
  end;

  //QCi
  if (AddParam.AddParamType = apQ) and
     (AddParam.NodeNo > cnstNotSetValue) and
     (AddParam.AddParamElement = apeC) then
  begin
    Result := Sqrt(Abs(AddParam.Value/c[AddParam.NodeNo].GetFormulaRValue(SchemaInfo)));
  end;

end;

function TRLCList.GetIByAddParamC: TPolarComplex;
var
   v1, v2: TPolarComplex;
   IMaxC: TPolarComplex;
begin
  Result.Angle := 0;
  Result.Radius := 0;
  //U, psi_U
  if (AddParam.AddParamType = apU) and
     (AddParam.NodeNo = cnstNotSetValue)  then
  begin
    v1.Angle := Math.DegToRad(AddParam.W0);
    v1.Radius := AddParam.Value;
    Result := v1/Z_Total;
  end;

  //U_1
  if (AddParam.AddParamType = apU) and
     (AddParam.NodeNo = 0) and
     (AddParam.AddParamElement = apeNone) then
  begin
    v1.Angle := Math.DegToRad(AddParam.W0);
    v1.Radius := AddParam.Value;
    Result := v1/Z[AddParam.NodeNo];
  end;



  //Umax, psi_U
  if (AddParam.AddParamType = apUmax) and
     (AddParam.NodeNo = cnstNotSetValue)  then
  begin
    v1.Radius := AddParam.Value;
    v1.Angle := Math.DegToRad(AddParam.W0);
    IMaxC := v1/Z_Total;
    Result := ImaxC/sqrt(2);
  end;

  //Umax_1, psi_U
  if (AddParam.AddParamType = apUmax) and
     (AddParam.NodeNo = 0) and
     (AddParam.AddParamElement = apeNone)  then
  begin
    v1.Radius := AddParam.Value;
    v1.Angle := Math.DegToRad(AddParam.W0);
    IMaxC := v1/z[0];
    Result := ImaxC/sqrt(2);
  end;

  //P
  {if AddParam.AddParamType = apP then
  begin
    Result.Radius := GetIByAddParam;
    Result.Angle := 0;
  end;}


  //Ur1
  if (AddParam.AddParamType = apU) and
     (AddParam.NodeNo >= 0) and
     (AddParam.AddParamElement = apeR) then
  begin
    v1.Radius := AddParam.Value;
    v1.Angle := Math.DegToRad(AddParam.W0);
    Result := v1/r[AddParam.NodeNo].GetFormulaRValue(SchemaInfo);
  end;

  //Umaxr1
  if (AddParam.AddParamType = apUmax) and
     (AddParam.NodeNo >= 0) and
     (AddParam.AddParamElement = apeR) then
  begin
    v1.Radius := AddParam.Value;
    v1.Angle := Math.DegToRad(AddParam.W0);
    Result := v1/r[AddParam.NodeNo].GetFormulaRValue(SchemaInfo)/sqrt(2);
  end;

  //I
  if AddParam.AddParamType = apI then
  begin
    Result.Radius := AddParam.Value;
    Result.Angle := Math.DegToRad(AddParam.W0);
  end;

  //I
  if AddParam.AddParamType = apImax then
  begin
    Result.Radius := AddParam.Value/sqrt(2);
    Result.Angle := Math.DegToRad(AddParam.W0);
  end;

  //Ul
  if (AddParam.AddParamType = apU) and
      (AddParam.AddParamElement = apeL) then
  begin
    v1.Radius := AddParam.Value;
    v1.Angle := Math.DegToRad(AddParam.W0);
    v2.Radius := l[AddParam.NodeNo].GetFormulaRValue(SchemaInfo);
    v2.Angle := PI/2;
    Result := v1/v2;
  end;

  //Ulmax
  if (AddParam.AddParamType = apUmax) and
      (AddParam.AddParamElement = apeL) then
  begin
    v1.Radius := AddParam.Value/sqrt(2);
    v1.Angle := Math.DegToRad(AddParam.W0);
    v2.Radius := l[AddParam.NodeNo].GetFormulaRValue(SchemaInfo);
    v2.Angle := PI/2;
    Result := v1/v2;
  end;

  //UC
  if (AddParam.AddParamType = apU) and
      (AddParam.AddParamElement = apeC) then
  begin
    v1.Radius := AddParam.Value;
    v1.Angle := Math.DegToRad(AddParam.W0);
    v2.Radius := c[AddParam.NodeNo].GetFormulaRValue(SchemaInfo);
    v2.Angle := -PI/2;
    Result := v1/v2;
  end;

  //Ucmax
  if (AddParam.AddParamType = apUmax) and
      (AddParam.AddParamElement = apeC) then
  begin
    v1.Radius := AddParam.Value/sqrt(2);
    v1.Angle := Math.DegToRad(AddParam.W0);
    v2.Radius := c[AddParam.NodeNo].GetFormulaRValue(SchemaInfo);
    v2.Angle := -PI/2;
    Result := v1/v2;
  end;

  //Uparal
  if (AddParam.AddParamType = apUparal) then
  begin
    v1.Radius := AddParam.Value;
    v1.Angle := Math.DegToRad(AddParam.W0);
    Result := v1/ Z_Parallel;
  end;

  //Umaxparal
  if (AddParam.AddParamType = apUmaxParal) then
  begin
    v1.Radius := AddParam.Value/sqrt(2);
    v1.Angle := Math.DegToRad(AddParam.W0);
    Result := v1/ Z_Parallel;
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
  Result := ReplaceStr('i_%d=I_%d*.sqrt(2)*'+vStr+'(omega*t+psi_I_%d)=', '%d', IntToStr(AIndex+1))+
   RndArr.FormatDoubleStr(GetI_(AIndex).Radius, cI)+'*.sqrt(2)*'+vStr+'('+
   RndArr.FormatDoubleStr(SchemaInfo.W, cW)+
   SplitAtoms('*t', RndArr.FormatDoubleStr(Math.RadToDeg(GetI_(AIndex).Angle), cPhi)+'^0)', '+') + '=' +
   RndArr.FormatDoubleStr(GetI_(AIndex).Radius*sqrt(2), cI)+'*.'+vStr+'('+
   RndArr.FormatDoubleStr(SchemaInfo.W, cW)+
   SplitAtoms('*t', RndArr.FormatDoubleStr(Math.RadToDeg(GetI_(AIndex).Angle), cPhi)+'^0)', '+');
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
    vFormula.AddReplaceTerm('phi_i', Math.RadToDeg(Phi[AIndex]));
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
// To Do избавиться от копипасты
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
    vPhiStr := '-' + PrepareDouble(Math.RadToDeg(PhiTotal)) + '^0'
  else
    vPhiStr := '+' + PrepareDouble(abs(Math.RadToDeg(PhiTotal))) + '^0';

  Result := 'I(omega*t)=I_0*.' + vStr + '(omega*t' + vStrW0 + '-phi)=' +
    PrepareDouble(Itotal * sqrt(2)) + '*' + vStr + '(' +
    PrepareDouble(SchemaInfo.W) + '*t' + vStrW0Value + vPhiStr + ')';
end;

function TRLCList.GetI_(Index: Integer): TPolarComplex;
begin
  if Index = 0 then
   Result := UParal / Z_Parallel
  else
    Result := UParal / GetZ_(Index);
end;

function TRLCList.GetL(Index: Integer): TElementItemL;
begin
  Assert(Index < NodesCount, 'Розробнику в GetL переданий індекс ' +
    IntToStr(Index) + ' але довжина масива ' + IntToStr(NodesCount));
  Result := FL[Index];
end;

function TRLCList.GetNodesCount: Integer;
begin
  Result := Length(FR);
end;

function TRLCList.GetP: Double;
var i: Integer;
begin
  Result := 0;
  for i := 0 to NodesCount-1 do
    if Assigned(r[i]) then
       Result := Result + GetPr(i);
end;

function TRLCList.GetPFormula: String;
var i: Integer;
    tmp: String;
begin
  Result := 'P=Summa(P_i, i)=';
  tmp := '';
  for i := 0 to NodesCount-1 do
    if Assigned(r[i]) then
       tmp :=  SplitAtoms(tmp, 'P_R_'+IntToStr(i+1), '+');

  //Вообще нет сопротивлений
  if tmp = '' then
  begin
    Result := Result + '0';
    Exit;
  end;

  Result := Result + tmp + '=';
  tmp := '';

   for i := 0 to NodesCount-1 do
     if Assigned(r[i]) then
       tmp := SplitAtoms(tmp, RndArr.FormatDoubleStr(GetPr(i), cR), '+');

   Result := Result + tmp + '=' + RndArr.FormatDoubleStr(GetP, cP);

end;

function TRLCList.Getphi0(AIndex: Integer): double;
begin
  Result := Math.RadToDeg(Phi[AIndex]);
end;

function TRLCList.GetPr(Index: Integer): Double;
begin
  Result := Sqr(GetI_(Index).Radius)*r[Index].Value;
end;

function TRLCList.GetPrFormula(Index: Integer): String;
begin
  Result := ReplaceStr('P_R_%d=I_%d^2*.R_1', '%d', IntToStr(Index+1)) + '=(' +
     RndArr.FormatDoubleStr(GetI_(Index).Radius, cI)+')^2*.' +
     RndArr.FormatDoubleStr(r[Index].Value, cR) + '=' +
     RndArr.FormatDoubleStr(GetPr(Index), cP);
end;

function TRLCList.GetQ: Double;
var
   i: Integer;
begin
 Result := 0;
 for i := 0 to NodesCount-1 do
 begin
   if Assigned(c[i]) then
    Result := Result + GetQC(i);
   if Assigned(l[i]) then
     Result := Result + GetQl(i);
 end;
end;

function TRLCList.GetQC(Index: Integer): Double;
begin
  Result := -Sqr(GetI_(Index).Radius)*c[Index].GetFormulaRValue(SchemaInfo);
end;

function TRLCList.GetQCFormula(Index: Integer): String;
begin
  Result := ReplaceStr('Q_C_%d=-I_%d^2*.X_C_%d', '%d', IntToStr(Index+1)) + '=(' +
     RndArr.FormatDoubleStr(GetI_(Index).Radius, cI)+')^2*.' +
     RndArr.FormatDoubleStr(c[Index].GetFormulaRValue(SchemaInfo), cR) + '=' +
     RndArr.FormatDoubleStr(GetQC(Index), cP);
end;

function TRLCList.GetQFormula: String;
var i: Integer;
    tmp, tmp1: String;
    str, str1: String;
begin
  Result := '';
  str := '';
  str1 := '';

  for i := 0 to NodesCount-1 do
  begin
    tmp := '';
    tmp1 := '';
    if Assigned(l[i]) then
    begin
      tmp := 'Q_L_'+IntToStr(i+1);
      tmp1 := RndArr.FormatDoubleStr(GetQl(i), cP);
    end;

    if Assigned(c[i]) then
    begin
      tmp := SplitAtoms(tmp, 'Q_C_'+IntToStr(i+1), '+');
      tmp1 := SplitAtoms(tmp1, '['+RndArr.FormatDoubleStr(GetQC(i), cP)+']', '+');
    end;

    if tmp <> '' then
    begin
      tmp := '('+tmp+')';
      tmp1 := '('+tmp1 + ')';
    end;

    str := SplitAtoms(str, tmp, '+');
    str1 := SplitAtoms(str1, tmp1, '+');
  end;

  //Вообще нет катушек и конденсаторов
  if str = '' then
  begin
    Result := 'Q=Summa(Q_i, i)=0';
  end
  else
    Result := 'Q=Summa(Q_i, i)='+str+'='+str1+'='+ RndArr.FormatDoubleStr(GetQ, cP);
end;

function TRLCList.GetQl(Index: Integer): Double;
begin
  Result := Sqr(GetI_(Index).Radius)*l[Index].GetFormulaRValue(SchemaInfo);
end;

function TRLCList.GetQlFormula(Index: Integer): String;
begin
  Result := ReplaceStr('Q_L_%d=I_%d^2*.X_L_%d', '%d', IntToStr(Index+1)) + '=(' +
     RndArr.FormatDoubleStr(GetI_(Index).Radius, cI)+')^2*.' +
     RndArr.FormatDoubleStr(l[Index].GetFormulaRValue(SchemaInfo), cR) + '=' +
     RndArr.FormatDoubleStr(GetQl(Index), cP);
end;

function TRLCList.GetR(Index: Integer): TElementItemR;
begin
  Assert(Index < NodesCount, 'Розробнику в GetR переданий індекс ' +
    IntToStr(Index) + ' але довжина масива ' + IntToStr(NodesCount));
  Result := FR[Index];
end;

function TRLCList.GetS: TPolarComplex;
var
   v: TPolarComplex;
begin
  v := GetI_(0);
  Result := GetUTotal*v.Conjugate;
end;

function TRLCList.GetSFormula: String;
var
  v0,  v1, v2: TPolarComplex;
begin
  v0 := GetUTotal;
  v1 := GetI_(0);
  v1 := v1.Conjugate;
  v2 := GetS;
  Result  := 'Points(S)=Points(U)*.Tilde(I)_1=' +
     TComplexFormula(v0).GetPolarFormulaStr(cU)+ '*.'+
     TComplexFormula(v1).GetPolarFormulaStr(cI) + '='+
     TComplexFormula(v2).GetPolarFormulaStr(cP) + '='+
     TComplexFormula(v2).GetRectFormulaStr(cP) + '=P+j*.Q';
end;

function TRLCList.GetU1: TPolarComplex;
begin
  Result := GetI_(0)*GetZ_(0);
end;

function TRLCList.GetU1ByTFormula: String;
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
  Result := 'u_1=U_1*.sqrt(2)*'+vStr+'(omega*t+psi_U_1)='+
   RndArr.FormatDoubleStr(GetU1.Radius, cU)+'*.sqrt(2)*'+vStr+'('+
   RndArr.FormatDoubleStr(SchemaInfo.W, cW)+
   SplitAtoms('*t', RndArr.FormatDoubleStr(Math.RadToDeg(GetU1.Angle), cPhi)+'^0)=', '+')+
   RndArr.FormatDoubleStr(GetU1.Radius*sqrt(2), cU)+'*'+vStr+'('+
   RndArr.FormatDoubleStr(SchemaInfo.W, cW)+
   SplitAtoms('*t', RndArr.FormatDoubleStr(Math.RadToDeg(GetU1.Angle), cPhi)+'^0)', '+');
end;

function TRLCList.GetU1Formula: String;
var v: TPolarComplex;
begin
  v := GetU1;
  Result := 'Points(U)_1=Points(I)_1*.Points(Z)_1='+
    TComplexFormula(GetI_(0)).GetPolarFormulaStr(cI) + '*.' +
    TComplexFormula(GetZ_(0)).GetPolarFormulaStr(cR) + '=' +
    TComplexFormula(v).GetPolarFormulaStr(cU);
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

function TRLCList.GetUCFormula(Index: Integer): String;
var
  v1, v2, v3: TPolarComplex;
begin
  v1 := GetI_(Index);
  v2.Radius := c[Index].GetFormulaRValue(SchemaInfo);
  v2.Angle := -pi/2;
  v3 := GetUC_(Index);
  Result := ReplaceStr('Points(U)_C_%d=Points(I)_%d*.Points(X)_C_%d', '%d', IntToStr(Index+1));
  Result := Result + '=' + TComplexFormula(v1).GetPolarFormulaStr(cI) + '*.'+
     TComplexFormula(v2).GetPolarFormulaStr(cI)+ '=' + TComplexFormula(v3).GetPolarFormulaStr(cU);
end;

function TRLCList.GetUC_(Index: Integer): TPolarComplex;
var vXC: TPolarComplex;
begin
  vXC.Radius := c[Index].GetFormulaRValue(SchemaInfo);
  vXC.Angle := -pi/2;
  Result := GetI_(Index)*vXC;
end;

function TRLCList.GetULFormula(Index: Integer): String;
var
  v1, v2, v3: TPolarComplex;
begin
  v1 := GetI_(Index);
  v2.Radius := l[Index].GetFormulaRValue(SchemaInfo);
  v2.Angle := pi/2;
  v3 := GetUl_(Index);
  Result := ReplaceStr('Points(U)_L_%d=Points(I)_%d*.Points(X)_L_%d', '%d', IntToStr(Index+1));
  Result := Result + '=' + TComplexFormula(v1).GetPolarFormulaStr(cI) + '*.'+
     TComplexFormula(v2).GetPolarFormulaStr(cI)+ '=' + TComplexFormula(v3).GetPolarFormulaStr(cU);
end;

function TRLCList.GetUl_(Index: Integer): TPolarComplex;
var vXl: TPolarComplex;
begin
  vXl.Radius := l[Index].GetFormulaRValue(SchemaInfo);
  vXl.Angle := pi/2;
  Result := GetI_(Index)*vXl;
end;

function TRLCList.GetUParal: TPolarComplex;
begin
  Result := GetI_(0)*Z_Parallel;
end;

function TRLCList.GetUparalbyTFormula: String;
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
  Result := 'u_String(парал)=U_String(парал)*.sqrt(2)*'+vStr+'(omega*t+psi_U_String(парал))='+
   RndArr.FormatDoubleStr(GetUParal.Radius, cU)+'*.sqrt(2)*'+vStr+'('+
   RndArr.FormatDoubleStr(SchemaInfo.W, cW)+
   SplitAtoms('*t', RndArr.FormatDoubleStr(Math.RadToDeg(GetUParal.Angle), cPhi)+'^0)=', '+')+
   RndArr.FormatDoubleStr(GetUParal.Radius*sqrt(2), cU)+'*'+vStr+'('+
   RndArr.FormatDoubleStr(SchemaInfo.W, cW)+
   SplitAtoms('*t', RndArr.FormatDoubleStr(Math.RadToDeg(GetUParal.Angle), cPhi)+'^0)', '+');
end;

function TRLCList.GetUParalFormula: String;
var
  v: TPolarComplex;
begin
  v := GetUParal;
  Result := 'Points(U)_String(парал)=Points(I)_1*.Points(Z)_String(парал)='+
    TComplexFormula(GetI_(0)).GetPolarFormulaStr(cI) + '*.' +
    TComplexFormula(Z_Parallel).GetPolarFormulaStr(cR) + '=' +
    TComplexFormula(v).GetPolarFormulaStr(cU);
end;

function TRLCList.GetURFormula(Index: Integer): String;
begin
  Result :=  ReplaceStr('Points(U)_R_%d=Points(I)_%d*.R_%d', '%d', IntToStr(Index+1));
  Result := Result + '=' + TComplexFormula(GetI_(Index)).GetPolarFormulaStr(cI) + '*.'+
    RndArr.FormatDoubleStr(r[Index].Value, cR) + '=' +
    TComplexFormula(GetUR_(INdex)).GetPolarFormulaStr(cU);

end;

function TRLCList.GetUR_(Index: Integer): TPolarComplex;
begin
  Result := GetI_(Index)*R[Index].Value;
end;

function TRLCList.GetUTotal: TPolarComplex;
begin
  Result := GetI_(0)*Z_Total;
end;

function TRLCList.GetUtotalByTFormula: String;
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
  Result := 'u=U*.sqrt(2)*'+vStr+'(omega*t+psi_U)='+
   RndArr.FormatDoubleStr(GetUTotal.Radius, cU)+'*.sqrt(2)*'+vStr+'('+
   RndArr.FormatDoubleStr(SchemaInfo.W, cW)+
   SplitAtoms('*t', RndArr.FormatDoubleStr(Math.RadToDeg(GetUTotal.Angle), cPhi)+'^0)=', '+')+
   RndArr.FormatDoubleStr(GetUTotal.Radius*sqrt(2), cU)+'*'+vStr+'('+
   RndArr.FormatDoubleStr(SchemaInfo.W, cW)+
   SplitAtoms('*t', RndArr.FormatDoubleStr(Math.RadToDeg(GetUTotal.Angle), cPhi)+'^0)', '+');
end;

function TRLCList.GetUTotalFormula: String;
var
  v: TPolarComplex;
begin
  v := GetUTotal;
  Result := 'Points(U)=Points(I)_1*.Points(Z)='+
    TComplexFormula(GetI_(0)).GetPolarFormulaStr(cI) + '*.' +
    TComplexFormula(Z_Total).GetPolarFormulaStr(cR) + '=' +
    TComplexFormula(v).GetPolarFormulaStr(cU);
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

function TRLCList.GetZ_(Index: Integer): TPolarComplex;
var
  vr, vL, vC: double;
begin
  Result.Radius := GetZ(Index);
  vr := 0;
  vL := 0;
  vC := 0;
  if Assigned(r[Index]) then
    vr := r[Index].GetFormulaRValue(SchemaInfo);
  if Assigned(l[Index]) then
    vL := l[Index].GetFormulaRValue(SchemaInfo);
  if Assigned(c[Index]) then
    vC := c[Index].GetFormulaRValue(SchemaInfo);


  if vr <> 0 then
   Result.Angle := arctan((vL-Vc)/vR)
  else
   Result.Angle := Sign(vL-vC)*Pi/2;

end;

function TRLCList.GetZ_Formula(Index: Integer): String;
var
  vStr, vStrR: String;
  vRStr: String;
  vFormula: TFormula;
begin
  Result := 'Bline(Z)_' + IntToStr(Index+1) + '=';
  vFormula := TFormula.Create;
  try
    vStr := '';
    if Assigned(l[Index]) then
    begin
      vStr := 'X_'+ l[Index].GetFormulaName;
      vFormula.AddReplaceTerm(vStr, l[Index].GetFormulaRValue(SchemaInfo));
    end;
    if Assigned(c[Index]) then
    begin
      vStr := '(' + vStr + '-' + 'X_'+c[Index].GetFormulaName + ')';
      vFormula.AddReplaceTerm('X_'+c[Index].GetFormulaName, c[Index].GetFormulaRValue(SchemaInfo));
    end;
    if vStr <> '' then
      vStr := 'j*.' + vStr;

    if Assigned(r[Index]) then
    begin
      vStrR := r[Index].GetFormulaName;
      vFormula.AddReplaceTerm(r[Index].GetFormulaName, r[Index].GetFormulaRValue(SchemaInfo));
    end
    else
      vStrR := '';
    vStr := SplitAtoms(vStrR, vStr, '+');

    vFormula.FormulaStr := vStr;
    Result := Result + vStr;
    if Assigned(l[Index]) or Assigned(c[Index]) then
      Result := Result + '=' + vFormula.GetFormulaValue;
    Result := Result + '=' + TComplexFormula(GetZ_(Index)).GetPolarFormulaStr('R');
  finally
    vFormula.Free;
  end;
end;

procedure TRLCList.GetZ_Parallel_Formula(var APart1, APart2, APart3: String);
const cnstFmt = '(1/Z_%d)*.e^(-j*.phi_%d)';
var vStr, s: String;
    z, z1: TRectComplex;
    i: Integer;
begin
  APart1 := 'Bline(Z)_String(парал)=';
  for i:=1 to NodesCount-1 do
    vStr := SplitAtoms(vStr, '1/Bline(Z_'+IntToStr(i+1)+')', '+');
  vStr := '1/('+vStr+')';
  APart1 := APart1 + vStr;
  vStr := '';
  for i:=1 to NodesCount-1 do
    vStr := SplitAtoms(vStr, Format(cnstFmt, [i+1,i+1]), '+');
  vStr := '1/('+vStr+')';
  APart1 := APart1 + '=' + vStr + '=Empty';
  //Рассчет второй части формулы
  APart2 := 'Empty=';
  vStr := '';
  for i := 1 to NodesCount-1 do
  begin
    s := '(' + TComplexFormula(1/GetZ_(i)).GetRectFormulaStr(cR)+ ')';
    vStr := SplitAtoms(vStr, s, '+');
  end;
  z := 1/Z_Parallel;
  s := '1/('+TComplexFormula(z).GetRectFormulaStr(cR)+')';
  APart2 := APart2 +  '1/('+vStr + ')='+s+'=Empty';
  z1 := z.Conjugate;
  APart3 := 'Empty=('+s+')*.(('+
    TComplexFormula(z1).GetRectFormulaStr(cR)+')/('+ TComplexFormula(z1).GetRectFormulaStr(cR)+'))='+
    TComplexFormula(Z_Parallel).GetRectFormulaStr(cR)+'=' +
    TComplexFormula(Z_Parallel).GetPolarFormulaStr(cR);
end;


function TRLCList.GetZ_TotalFormula: String;
const
  cnstFmt = 'Bline(Z)=Bline(Z_1)+Bline(Z)_String(парал)=(%s)+(%s)=%s=%s';
begin
  Result := Format(cnstFmt, [TComplexFormula(GetZ_(0)).GetRectFormulaStr(cR),
                             TComplexFormula(Z_Parallel).GetRectFormulaStr(cR),
                             TComplexFormula(Z_Total).GetRectFormulaStr(cR),
                             TComplexFormula(Z_Total).GetPolarFormulaStr(cR)]);

end;

function TRLCList.PhiTotal: double;
begin
  Result := TPolarComplex(Z_Total).Angle;
end;

function TRLCList.RaTotal: double;
begin
  Result := Z_Total.Re;
end;

function TRLCList.XrTotal: double;
begin
 Result := Z_Total.Im;
end;

function TRLCList.ZTotal: double;
begin
  Result := Norm(Z_Total);
end;

{ TSchemaInfo }

function TSchemaInfo.W0Deg: double;
begin
  Result := Math.RadToDeg(W0);
end;

{ TAddParam }

function TAddParam.GetElementFormula: String;
var
  vRoundType: String;
begin
  case AddParamType of
    apU: vRoundType := cU;
    apUmax: vRoundType := cU;
    apUparal: vRoundType := cU;
    apUmaxParal: vRoundType := cU;
    apI: vRoundType := cI;
    apImax: vRoundType := cI;
    apP: vRoundType := cP;
    apQ: vRoundType := cP;
    apS: vRoundType := cP;
  end;
 Result := GetElementNameFormula + '=' + RndArr.FormatDoubleStr(Value, vRoundType)+
     '&space(10)&String('+ GetElementMeasure + ')';
end;

function TAddParam.GetElementMeasure: String;
begin
  case AddParamType of
    apU: Result := 'B';
    apUmax: Result := 'B';
    apUparal: Result := 'B';
    apUmaxParal: Result := 'B';
    apI: Result := 'A';
    apImax: Result := 'A';
    apP: Result := 'Bт';
    apQ: Result := 'BАР';
    apS: Result := 'B∙A';
  end;
end;

function TAddParam.GetElementNameFormula: String;
var
  vStr: String;
begin
  Result := TAddParamFormulas[ord(AddParamType)];
  vStr := TAddParamElementNames[ord(AddParamElement)];
  if  vStr <> '' then
    Result := Result + '_'+ vStr;
  if NodeNo >= 0 then
    Result := Result + '_'+IntToStr(NodeNo+1);
end;

function TAddParam.GetW0Fornula: String;
var vElementName: String;
    vStr: String;
begin
  Result := '';
  if not IsAllowW0 then
    Exit;

  Result := 'psi_'+TAddParamFormulasW0[ord(AddParamType)];
  vStr := TAddParamElementNames[ord(AddParamElement)];
  if  vStr <> '' then
    Result := Result + '_'+ vStr;
  if NodeNo >= 0 then
    Result := Result + '_'+IntToStr(NodeNo+1);

  Result := Result + '='+ RndArr.FormatDoubleStr(W0, cPhi)+'^0';
end;

function TAddParam.IsAllowLC: Boolean;
begin
  Result :=  (NodeNo >= 0) and not (AddParamType in[apP, apS, apI, apImax]);
end;

function TAddParam.IsAllowNodeNo: Boolean;
begin
  Result :=  not (AddParamType in [apUparal]);
end;

function TAddParam.IsAllowR: Boolean;
begin
  Result := (NodeNo >= 0) and not (AddParamType in [apQ, apS, apI, apImax]);
end;

function TAddParam.IsAllowW0: Boolean;
begin
  Result := AddParamType in [apU, apI, apUmax, apImax, apUparal, apUmaxParal];
end;

function TAddParam.IsDataCorrect: Boolean;
begin
  Result := (IsAllowNodeNo or (NodeNo = cnstNotSetValue)) and
            (IsAllowR or (AddParamElement <> apeR)) and
            (IsAllowLC or not (AddParamElement in [apeL, apeC])) and
            (not IsNeedNodeNo or (NodeNo <> cnstNotSetValue));
end;

function TAddParam.IsNeedNodeNo: Boolean;
begin
  Result := AddParamType in [apI, apImax];
end;

function TAddParam.IsResultComplex: Boolean;
begin
  Result := not (AddParamType in [apP, apQ, apS]);
end;

function TAddParam.ResultNodeNo: Integer;
begin
  if NodeNo <= 0 then
    Result := 0
  else
    Result := NodeNo;
end;

end.
