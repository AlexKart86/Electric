unit uCalc;

interface

uses jclMath, uComplexUtils, RVEdit, Windows, Graphics, uConsts, RVStyle;

type

  // Информация об одной ноде
  TNodeInfo = record
  private
    f: Double;
    W: Double;
    L: Double;
    C: Double;
    FXl: Double;
    FXc: Double;
  public
    //Флаги аварийных режимов работы
    //Сопротивление ветки 0
    IsBadR0: Boolean;
    //Сопротивление ветки равно бесконечности
    IsBadRInf: Boolean;
    //Обрыв линейного провода
    IsBadLin: Boolean;
    R: Double;
    ej: Double;
    Letter: String;
    property XL: Double read FXl;
    property XC: Double read FXc;
    function XLFormula: String;
    function XCFormula: String;
    function GetX: Double;
    function GetR: Double;
    function GetZ: TPolarComplex;
    function GetZSimple: Double;
    function GetY: TRectComplex;
    function GetYFormula: String;
    function GetPhi: Double;
    function GetPhiFormula: String;
    procedure GetZFormula(var APart1, APart2: string);
    function GetZFormulaSimple: string;
    // Устанавливает сопротивления катушек и конденсаторов
    // В параметры L, C передается либо непосредственно сопротивления
    // Либо емкссть
    procedure SetX(L, C: Double; f: Double = -1; W: Double = -1);
    class operator Equal(V1, V2: TNodeInfo): Boolean;
  end;

  TProcessNodeProc = procedure(ANode: TNodeInfo);

  TMainSchema = class;

  // Общая информация о схеме (звезды или треугольника)
  TSchemaInfo = class
  private
    FMainSchema: TMainSchema;
    SchemaType: TSchemaType;
    IndexType: TIndexType;
    FUFormula: String;
  public
    U: Double;
    NodeA: TNodeInfo;
    NodeB: TNodeInfo;
    NodeC: TNodeInfo;
    function GetU0: TRectComplex;
    function GetU0Formula: String;

    //Возвращает ноды в аварийном режиме
    function IsBadR0: Boolean;
    function IsBadRInf: Boolean;
    function IsBadLin: Boolean;
    function BadR0Node: TNodeInfo;
    function BadRInfNode: TNodeInfo;
    function BadLinNode: TNodeInfo;
    function BadLinLetter: String;

    // Вовзрашает префикс ноды вместе с индексом
    // флаг AIsSkipIndexTriangle говорит надо ли игнорировать индекс для ноды-трегольника
    function GetIndexedLetter(ANode: TNodeInfo;
      AIsSkipIndexTriangle: Boolean = True): String;
    function GetU(ANode: TNodeInfo; AIsNeedR0: Boolean = True): TPolarComplex;
    //Возвращает формулу начертания напряжения (U+индекс+штрих при необходимости)
    function GetULetter(ANode: TNodeInfo): String;
    //Возврашает формулу вычисления напряжения на фазах потребителя
    //при наличии сопротивления нулевого провода
    function GetUR0Formula(ANode: TNodeInfo): string;

    //Возвращает форулу без учета тока в нулевом проводе
    property UFormula: String read FUFormula;
    // Фазные токи
    function GetIFazeFormula(ANode: TNodeInfo): String;
    function GetIFazeFormulaSimple(ANode: TNodeInfo): String;
    function GetIFaze(ANode: TNodeInfo): TRectComplex;
    function GetIFazeSimple(ANode: TNodeInfo): Double;
    // Линейные токи
    procedure GetILinFormula(ANode: TNodeInfo; var vStr1, vStr2: String);
    function GetILin(ANode: TNodeInfo): TRectComplex;
    constructor Create(ASchemaType: TSchemaType; AIndex: TIndexType; AMainSchema: TMainSchema);
    // Выполнить процедуру AProcessNodeProc над всеми узлами
    procedure ProcessAllNodes(AProcessNodeProc: TProcessNodeProc);
    // Нулевой провод
    function GetI0: TRectComplex;
    procedure GetI0Formula(var vStr1, vStr2: string);
    // Мощность
    function GetS(ANode: TNodeInfo): TRectComplex;
    function GetSSimple(ANode: TNodeInfo): Double;
    procedure GetSFormula(ANode: TNodeInfo; var vStr1, vStr2: String);
    function GetSFormulaSimple(ANode: TNodeInfo): string;
    function GetSTotal: TRectComplex;
    function GetSTotalSimple: Double;

    procedure GetSTotalFormula(var vStr1: string);
    function GetSTotalFormulaSimple: String;

    function GetPSimple(ANode: TNodeInfo): Double;
    function GetPFormulaSimple(ANode: TNodeInfo): string;
    function GetQSimple(ANode: TNodeInfo): Double;
    function GetQFormulaSimple(ANode: TNodeInfo): String;
    function GetPTotalSimple: Double;
    function GetQTotalSimple: Double;
    function GetPTotalFormula: string;
    function GetQTotalFormula: String;
    function GetPTotalFormulaSimple1: String;
    function GetPTotalFormulaSimple2: String;
    function GetQTotalFormulaSimple1: String;
    function GetQTotalFormulaSimple2: string;

    function GetZBadLin: TPolarComplex;
    function GetZBadLinFormula: String;
    function GetZBadLinFormulaLetter: String;

     //Формула рассчета напряжения в ветви при обрыве линейного провода
    function GetUBadLinFormula(ANode: TNodeInfo):String;

  end;

  // Общий класс, отвечающий за хранение всей инфорамции о схеме
  TMainSchema = class
    FULetter: String;
    FUl: Double;
    FUf: Double;
    FSimplePrefix: String;
    FSchemaStar: TSchemaInfo;
    FSchemaTriang: TSchemaInfo;
    FSchemaType: TSchemaTypeSet;
    FIsSimpleMode: Boolean;
    function GetSchema(AType: TSchemaType): TSchemaInfo;
    procedure SetFUl(AValue: Double);
    procedure SetFUf(AValue: Double);
  private
    procedure SetIsSimpleMode(AValue: Boolean);
  public
    R0: Double;
    f: Double;
    W: Double;
    DiagramSize: Integer;
    function GetY0: Double;
    function GetY0Formula: String;
    property Ul: Double read FUl write SetFUl;
    property Uf: Double read FUf write SetFUf;
    property SchemaType: TSchemaTypeSet read FSchemaType;
    property SchemaStar: TSchemaInfo read FSchemaStar;
    property Schema[AType: TSchemaType]: TSchemaInfo read GetSchema;
    property SchemaTriang: TSchemaInfo read FSchemaTriang;
    property IsSimpleMode: Boolean read  FIsSimpleMode write SetIsSimpleMode;
    constructor Create(ASchemaType: TSchemaTypeSet);
    destructor Destroy; override;
  end;

  TSolveOutput = class
  private
    FEditor: TRichViewEdit;
    FMainSchema: TMainSchema;
    FBitmapScale: TBitmap;
    FBitmapMain: TBitmap;
    FBitmapDiagram:TBitmap;
    // Рассчет частоты по f
    procedure PrepareW;
    // Рассчет сопротивлений веток для разных
    procedure PrepareX(ASchemaType: TSchemaType);
    // Рассчет фазного напряжения
    procedure CalcUf(ASchemaType: TSchemaType);
    Procedure RunModule1(ASchemaType: TSchemaType);
    //Вывести результаты рассчета модуля при коротком замыкании фазы при соединении звездой
    procedure RunModule1BadR0;
    //Процедура рассчета напряжения в цепи при обрыве линейного провода в треугольнике
    procedure RunModule1BadLin;
    procedure RunModule2(ASchemaType: TSchemaType);
    procedure RunModuleY(ASchemaType: TSchemaType);
    procedure RunModuleU0(ASchemaType: TSchemaType);
    procedure RunModule3(ASchemaType: TSchemaType);
    procedure RunModule4(ASchemaType: TSchemaType);
    procedure RunModule5(ASchemaType: TSchemaType);
    procedure RunModule5Simple(ASchemaType: TSchemaType);
    // Вызов итерации для одной схемы
    procedure RunSolvePart(ASchemaType: TSchemaType);
    // Рисование диаграммы
    procedure PrintMainSchema(var ABitmap: TBitmap);
    // Рисование условия
    procedure PrintTask;
    // Вывод преамбулы для аварийного режима работы
    procedure PrintAvariaPreambule;
  public
    procedure SplitScaleAndDiagram;
    property BitmapScale: TBitmap read FBitmapScale;
    property BitmapMain: TBitmap read FBitmapMain;
    procedure RunSolve;
    procedure PrintDiagram;
    constructor Create(AEditor: TRichViewEdit; AMainSchema: TMainSchema);
    destructor Destroy; override;
  end;

function IsAssigned(AValue: Double): Boolean;

implementation

uses uConstsShared, uLocalize, uLocalizeShared, uFormulaUtils,
  uStringUtilsShared, SysUtils, Math, StrUtils, uGraphicUtils, ArrowUnit,
  RvTable, uRounding;
{ TMainSchema }

function IsAssigned(AValue: Double): Boolean;
begin
  Result := AValue <> cnstNotSetValue;
end;

constructor TMainSchema.Create(ASchemaType: TSchemaTypeSet);
begin
  FSchemaStar := nil;
  FSchemaTriang := nil;
  FSchemaType := ASchemaType;
  if ASchemaType = [stStar, stTriangle] then
  begin
    FSchemaStar := TSchemaInfo.Create(stStar, it1, self);
    FSchemaTriang := TSchemaInfo.Create(stTriangle, it2, self);
  end
  else
  begin
    if stStar in ASchemaType then
      FSchemaStar := TSchemaInfo.Create(stStar, itNone, self);
    if stTriangle in ASchemaType then
      FSchemaTriang := TSchemaInfo.Create(stTriangle, itNone, self);
  end;
  FUl := cnstNotSetValue;
  FUf := cnstNotSetValue;
  f := cnstNotSetValue;
  W := cnstNotSetValue;
end;

destructor TMainSchema.Destroy;
begin
  FSchemaStar.Free;
  FSchemaTriang.Free;
  inherited;
end;

function TMainSchema.GetSchema(AType: TSchemaType): TSchemaInfo;
begin
  case AType of
    stStar:
      Result := FSchemaStar;
    stTriangle:
      Result := FSchemaTriang;
  end;
end;

function TSchemaInfo.GetU0: TRectComplex;
begin
  if FMainSchema.R0 = 0 then
    Result := 0
  else
    Result := (GetU(NodeA, False) * NodeA.GetY + GetU(NodeB, False) * NodeB.GetY +
      GetU(NodeC, False) * NodeC.GetY) /
      (NodeA.GetY + NodeB.GetY + NodeC.GetY + FMainSchema.GetY0);
end;

function TSchemaInfo.GetU0Formula: String;
const
  cnstFmt = '(%s)/(%s)';
  cnstU = 'Points(U)_%s*.Y_%s';
  cnstY = 'Y_%s';
var
 // vStr: string;
  vFormula: TFormula;
  vU0: TRectComplex;

  vU: String;
  vY: String;

begin
  Result := 'Points(U)_0=';
  vFormula := TFormula.Create;
  try
    vU := '';
    vY := '';
    if not NodeA.IsBadRInf then
    begin
      vU :=  SplitAtoms(vU, Format(cnstU, [NodeA.Letter, NodeA.Letter]), '+');
      vY :=  SplitAtoms(vY, Format(cnstY, [NodeA.Letter]), '+');
    end;
    if not NodeB.IsBadRInf then
    begin
      vU :=  SplitAtoms(vU, Format(cnstU, [NodeB.Letter, NodeB.Letter]), '+');
      vY :=  SplitAtoms(vY, Format(cnstY, [NodeB.Letter]), '+');
    end;
    if not NodeC.IsBadRInf then
    begin
      vU :=  SplitAtoms(vU, Format(cnstU, [NodeC.Letter, NodeC.Letter]), '+');
      vY :=  SplitAtoms(vY, Format(cnstY, [NodeC.Letter]), '+');
    end;

    if (FMainSchema.R0 <> 0) and (FMainSchema.R0 <> Infinity) and not IsBadRInf then
    begin
      vY :=  SplitAtoms(vY, 'Y_0', '+');
    end;


    vFormula.FormulaStr := Format(cnstFmt, [vU, vY]);
    { vFormula.AddReplaceTerm('U_'+ASchema.NodeA.Letter, ASchema.GetU(ASchema.NodeA));
      vFormula.AddReplaceTerm('U_'+ASchema.NodeB.Letter, ASchema.GetU(ASchema.NodeB));
      vFormula.AddReplaceTerm('U_'+ASchema.NodeC.Letter, ASchema.GetU(ASchema.NodeC));
      vFormula.AddReplaceTerm('Y_'+ASchema.NodeA.Letter, ASchema.GetU(ASchema.NodeA));
      vFormula.AddReplaceTerm('Y_'+ASchema.NodeB.Letter, ASchema.GetU(ASchema.NodeB));
      vFormula.AddReplaceTerm('Y_'+ASchema.NodeC.Letter, ASchema.GetU(ASchema.NodeC));
      vFormula.AddReplaceTerm('Y_0', GetY0); }
    vU0 := GetU0;
    Result := Result + vFormula.FormulaStr + '=' +
      TComplexFormula(vU0).GetRectFormulaStr(cU);
  finally
    FreeAndNil(vFormula);
  end;
end;

function TSchemaInfo.GetUBadLinFormula(ANode: TNodeInfo): String;
var
  vIFaze: TPolarComplex;
  vZ: TPolarComplex;
  vU: TPolarComplex;
begin

  if NodeA.IsBadLin and (ANode.Letter = NodeB.Letter) then
    Result := Format('U_bc=%s*.e^(-j*.90^0)', [RndArr.FormatDoubleStr(U, cU)])
  else if NodeB.IsBadLin and (ANode.Letter = NodeC.Letter) then
    Result := Format('U_ca=%s*.e^(j*.150^0)', [RndArr.FormatDoubleStr(U, cU)])
  else if NodeB.IsBadLin and (ANode.Letter = NodeA.Letter) then
    Result := Format('U_ab=%s*.e^(j*.30^0)', [RndArr.FormatDoubleStr(U, cU)])
  else
  begin
    vIFaze := GetIFaze(ANode);
    vZ := ANode.GetZ;
    vU := GetU(ANode);
    Result := Format('U_%s=I_%s*.Z_%s=%s*.%s=%s',[ANode.Letter, ANode.Letter, ANode.Letter,
       TComplexFormula(vIFaze).GetPolarFormulaStr(cI), TComplexFormula(vZ).GetPolarFormulaStr(cR),
       TComplexFormula(vU).GetPolarFormulaStr(cI)]);
  end;
end;

function TSchemaInfo.GetULetter(ANode: TNodeInfo): String;
begin
  Result := 'U';
  if FMainSchema.R0 <> 0 then
    Result := Result + '`';
  Result :=  Result + '_'+ ANode.Letter;
end;

function TSchemaInfo.GetUR0Formula(ANode: TNodeInfo): string;
var vU: TRectComplex;
begin
  Result := GetULetter(ANode) + '=U_' + ANode.Letter +'-U_0=';
  vU := GetU(ANode);
  Result := Result + TComplexFormula(vU).GetRectFormulaStr(cU)+
    '=' + TComplexFormula(vU).GetPolarFormulaStr(cU);
end;

function TSchemaInfo.GetZBadLin: TPolarComplex;
begin
  if NodeA.IsBadLin then
    Result := NodeA.GetZ + NodeC.GetZ;
  if NodeB.IsBadLin then
    Result := NodeA.GetZ + NodeB.GetZ;
  if NodeC.IsBadLin then
    Result := NodeB.GetZ + NodeC.GetZ;
end;

function TSchemaInfo.GetZBadLinFormula: String;
const
  cnstRes = '%s=(%s)+(%s)=%s=%s';
var
  prefix: String;
  Z1, Z2, Z: TPolarComplex;
begin
  if NodeA.IsBadLin then
  begin
    prefix := 'Bline(Z)_(cab)=Bline(Z)_(ca)+Bline(Z)_(ab)';
    Z1 := NodeC.GetZ;
    Z2 := NodeA.GetZ;
  end;
  if NodeB.IsBadLin then
  begin
    prefix := 'Bline(Z)_(abc)=Bline(Z)_(ab)+Bline(Z)_(bc)';
    Z1 := NodeA.GetZ;
    Z2 := NodeB.GetZ;
  end;
  if NodeC.IsBadLin then
  begin
    prefix := 'Bline(Z)_(bca)=Bline(Z)_(bc)+Bline(Z)_(ca)';
    Z1 := NodeB.GetZ;
    Z2 := NodeC.GetZ;
  end;

  Z := GetZBadLin;

  Result := Format(cnstRes, [prefix, TComplexFormula(Z1).GetRectFormulaStr(cR),
      TComplexFormula(Z2).GetRectFormulaStr(cR), TComplexFormula(Z).GetRectFormulaStr(cR),
      TComplexFormula(Z).GetPolarFormulaStr(cR)]);

end;

function TSchemaInfo.GetZBadLinFormulaLetter: String;
begin
  if NodeA.IsBadLin then
    Result := 'Bline(Z)_(cab)';
  if NodeB.IsBadLin then
    Result := 'Bline(Z)_(abc)';
  if NodeC.IsBadLin then
    Result := 'Bline(Z)_(bca)';
end;

function TSchemaInfo.IsBadLin: Boolean;
begin
  Result := BadLinNode.Letter <> '';
end;

function TSchemaInfo.IsBadR0: Boolean;
begin
  Result := BadR0Node.Letter <> '';
end;

function TSchemaInfo.IsBadRInf: Boolean;
begin
  Result := BadRInfNode.Letter <> '';
end;

function TMainSchema.GetY0: Double;
begin
  Result := 1 / R0;
end;

function TMainSchema.GetY0Formula: String;
begin
  Result := 'Y_0=1/Z_0=' + RndArr.FormatDoubleStr(GetY0, cR);
end;

procedure TMainSchema.SetFUf(AValue: Double);
const
  cnstFormula = 'U_л=U_ф*sqrt(3)=%s*sqrt(3)~~%s';
begin
  if AValue <> cnstNotSetValue then
  begin
    // При соединении треугольником фазное напряжение равно линейному!!
    if SchemaType = [stTriangle] then
    begin
      FUf := AValue;
      FSchemaTriang.U := RndArr.FormatDouble(FUf, cU);
      FUl := RndArr.FormatDouble(FUf, cU);
      FSchemaTriang.FUFormula := '';
      FULetter := 'ф';
      Exit;
    end;

    FULetter := 'ф';
    FUf := AValue;
    FUl := Decode(AValue, [220, 380, 127, 220, AValue * sqrt(3)]);
    if Assigned(FSchemaTriang) then
    begin
      FSchemaTriang.U := RndArr.FormatDouble(FUl, cU);
      FSchemaTriang.FUFormula := Format(cnstFormula,
        [RndArr.FormatDoubleStr(FUf, cU),
        RndArr.FormatDoubleStr(FSchemaTriang.U, cU)]);
    end;
    if Assigned(FSchemaStar) then
    begin
      FSchemaStar.U := RndArr.FormatDouble(FUf, cU);
      if SchemaType = [stStar] then
        FSchemaStar.FUFormula := Format(cnstFormula,
          [RndArr.FormatDoubleStr(FUf, cU), RndArr.FormatDoubleStr(FUl, cU)])
      else
        FSchemaStar.FUFormula := '';
    end;
  end;
end;

procedure TMainSchema.SetFUl(AValue: Double);
begin
  if AValue <> cnstNotSetValue then
  begin
    FULetter := 'л';
    FUl := AValue;
    FUf := Decode(Ul, [380, 220, 220, 127, Ul / sqrt(3)]);

    if Assigned(FSchemaStar) then
    begin
      FSchemaStar.U := RndArr.FormatDouble(FUf, cU);
      {if IsSimpleMode then
        FSchemaStar.FUFormula := 'U_ф=U_A=U_B=U_C'
      else}
        FSchemaStar.FUFormula := 'U_ф';

      FSchemaStar.FUFormula := FSchemaStar.FUFormula + '=U_л/sqrt(3)=' + RndArr.FormatDoubleStr(FUl,
        cU) + '/sqrt(3)~~' + RndArr.FormatDoubleStr(FSchemaStar.U, cU);
    end;

    if Assigned(FSchemaTriang) then
      FSchemaTriang.U := RndArr.FormatDouble(FUl, cU);
  end;
end;

procedure TMainSchema.SetIsSimpleMode(AValue: Boolean);
begin
  FIsSimpleMode := Avalue;
  if FIsSimpleMode then
     FSimplePrefix := 'S'
  else
    FSimplePrefix := '';
end;

{ TSchemaInfo }

function TSchemaInfo.BadLinLetter: String;
var
  vNode: TNodeInfo;
begin
  vNode := BadLinNode;
  Result := Copy(vNode.Letter, 1, 1);
end;

function TSchemaInfo.BadLinNode: TNodeInfo;
begin
  Result.Letter := '';
  if NodeA.IsBadLin then
    Result := NodeA;
  if NodeB.IsBadLin then
    Result := NodeB;
  if NodeC.IsBadLin then
    Result := NodeC;
end;

function TSchemaInfo.BadR0Node: TNodeInfo;
begin
  Result.Letter := '';
  if NodeA.IsBadR0 then
    Result := NodeA;
  if NodeB.IsBadR0 then
    Result := NodeB;
  if NodeC.IsBadR0 then
    Result := NodeC;
end;

function TSchemaInfo.BadRInfNode: TNodeInfo;
begin
  Result.Letter := '';
  if NodeA.IsBadRInf then
    Result := NodeA;
  if NodeB.IsBadRInf then
    Result := NodeB;
  if NodeC.IsBadRInf then
    Result := NodeC;
end;

constructor TSchemaInfo.Create(ASchemaType: TSchemaType; AIndex: TIndexType; AMainSchema: TMainSchema);
begin
  SchemaType := ASchemaType;
  FMainSchema := AMainSchema;
  case ASchemaType of
    stStar:
      begin
        NodeA.Letter := 'a';
        NodeB.Letter := 'b';
        NodeC.Letter := 'c';
      end;
    stTriangle:
      begin
        NodeA.Letter := 'ab';
        NodeB.Letter := 'bc';
        NodeC.Letter := 'ca';
      end;
  end;
  IndexType := AIndex;
  FUFormula := '';
end;

function TSchemaInfo.GetI0: TRectComplex;
begin
  Result := GetILin(NodeA) + GetILin(NodeB) + GetILin(NodeC);
end;

procedure TSchemaInfo.GetI0Formula(var vStr1, vStr2: string);
const
  {cnstFmt1 =
    'Points(I)_0=Points(I)_%s+Points(I)_%s+Points(I)_%s=(%s)+(%s)+(%s)=Empty';}
  cnstFmt2 = 'Empty=%s';
  cnstI = 'Points(I)_%s';
  cnstIVal =  '(%s)';
var
  vI1, vI2, vI3, vITotal: TComplexFormula;
  vTmp: String;
begin
  vI1 := GetILin(NodeA);
  vI2 := GetILin(NodeB);
  vI3 := GetILin(NodeC);
  vITotal := GetI0;

  vStr1 := '';
  vTmp := '';
  if not NodeA.IsBadRInf then
  begin
    vStr1 := SplitAtoms(vStr1, Format(cnstI, [GetIndexedLetter(NodeA)]), '+');
    vTmp := SplitAtoms(vTmp, Format(cnstIVal, [vI1.GetRectFormulaStr(cI)]), '+');
  end;

  if not NodeB.IsBadRInf then
  begin
    vStr1 := SplitAtoms(vStr1, Format(cnstI, [GetIndexedLetter(NodeB)]), '+');
    vTmp := SplitAtoms(vTmp, Format(cnstIVal, [vI2.GetRectFormulaStr(cI)]), '+');
  end;

  if not NodeC.IsBadRInf then
  begin
    vStr1 := SplitAtoms(vStr1, Format(cnstI, [GetIndexedLetter(NodeC)]), '+');
    vTmp := SplitAtoms(vTmp, Format(cnstIVal, [vI3.GetRectFormulaStr(cI)]), '+');
  end;

  vStr1 := 'Points(I)_0=' + SplitAtoms(vStr1, vTmp, '=') + '=Empty';


{  vStr1 := Format(cnstFmt1, [GetIndexedLetter(NodeA), GetIndexedLetter(NodeB),
    GetIndexedLetter(NodeC), vI1.GetRectFormulaStr(cI),
    vI2.GetRectFormulaStr(cI), vI3.GetRectFormulaStr(cI)]);}
  vStr2 := Format(cnstFmt2, [vITotal.RectToPolarFormula(cI)]);
end;

function TSchemaInfo.GetIFaze(ANode: TNodeInfo): TRectComplex;
var vSum: TRectComplex;
begin
  if ANode.IsBadR0 then
  begin
    vSum := 0;
    if not NodeA.IsBadR0 then
      vSum := vSum + GetIFaze(NodeA);
    if not NodeB.IsBadR0 then
      vSum := vSum + GetIFaze(NodeB);
    if not NodeC.IsBadR0 then
      vSum := vSum + GetIFaze(NodeC);
    Result := - vSum;
  end
  else
  //Обрыв линейного провода
  if IsBadLin then
  begin
   //Обрыв линейного провода А
   if BadLinNode.Letter = NodeA.Letter then
     if ANode.Letter = NodeB.Letter then
       Result := GetU(NodeB)/Anode.GetZ
     else
       Result := GetU(NodeB)/GetZBadLin;

   //Обрыв линейного провода B
   if BadLinNode.Letter = NodeB.Letter then
     if ANode.Letter = NodeC.Letter then
       Result := GetU(NodeC)/Anode.GetZ
     else
       Result := GetU(NodeC)/GetZBadLin;

   //Обрыв линейного провода C
   if BadLinNode.Letter = NodeC.Letter then
     if ANode.Letter = NodeC.Letter then
       Result := GetU(NodeA)/Anode.GetZ
     else
       Result := GetU(NodeA)/GetZBadLin;

  end
  else
   if not ANode.IsBadRInf then
      Result := RndArr.FormatDoubleC(GetU(ANode) / ANode.GetZ, cC)
   else
      Result := 0;
end;

function TSchemaInfo.GetIFazeFormula(ANode: TNodeInfo): String;
const
  cnstFmt = 'Points(I)_%s=Points(%s)/bline(Z)_%s=(%s)/(%s)=%s=%s';
var
  vU, vZ, vI: TComplexFormula;
  vIa, vIb, vIc: String;
  function GetSuffix: String;
  begin
    if SchemaType = stTriangle then
      Result := ANode.Letter
    else
      case IndexType of
        itNone:
          Result := ANode.Letter;
        it1:
          Result := ANode.Letter + '_1';
        it2:
          Result := ANode.Letter + '_2';
      end;
  end;

  function GetStandartFormula: String;
  begin
    vU := GetU(ANode);
    vZ := ANode.GetZ;
    Result := Format(cnstFmt, [GetSuffix, GetULetter(ANode), GetSuffix,
      vU.GetPolarFormulaStr(cU), vZ.GetPolarFormulaStr(cR),
      vI.GetPolarFormulaStr(cI), vI.GetRectFormulaStr(cI)]);
  end;

begin

  vI := GetIFaze(ANode);
  //Обычный режим
  if not ANode.IsBadR0 and not IsBadLin then
   Result := GetStandartFormula;

  //Обрыв нулевого провода
  if ANode.IsBadR0 then
  begin
    vIa := TComplexFormula(GetIFaze(NodeA)).GetRectFormulaStr(cI);
    vIb := TComplexFormula(GetIFaze(NodeB)).GetRectFormulaStr(cI);
    vIc := TComplexFormula(GetIFaze(NodeC)).GetRectFormulaStr(cI);
    if ANode = NodeA then
      Result := Format('Points(I_a)=-(Points(I_b)+Points(I_c))=-(%s+(%s))=%s', [vIb, vIc, vIa]);
    if ANode = NodeB then
      Result := Format('Points(I_b)=-(Points(I_a)+Points(I_c))=-(%s+(%s))=%s', [vIa, vIc, vIb]);
    if ANode = NodeC then
      Result := Format('Points(I_c)=-(Points(I_a)+Points(I_b))=-(%s+(%s))=%s', [vIa, vIb, vIc]);
  end;

  //Обрыв линейного провода
  if IsBadLin  then
  begin
    //Обрыв линейного провода А
    if NodeA.IsBadLin then
    begin
      if ANode.Letter = NodeB.Letter then
        Result := GetStandartFormula
      else
      begin
        vU := GetU(NodeB);
        vZ := GetZBadLin;
        Result := Format('Points(I)_ca=Points(I)_ab=(Points(U)_bc/bline(Z)_cab)=(%s)/(%s)=%s=%s',
           [vU.GetPolarFormulaStr(cU), vZ.GetPolarFormulaStr(cR), vI.GetPolarFormulaStr(cI),
           vI.GetRectFormulaStr(cI)]);
      end;
    end;

    //Обрыв линейного провода B
    if NodeB.IsBadLin then
    begin
      if ANode.Letter = NodeC.Letter then
        Result := GetStandartFormula
      else
      begin
        vU := GetU(NodeC);
        vZ := GetZBadLin;
        Result := Format('Points(I)_ab=Points(I)_bc=(Points(U)_ca/bline(Z)_abc)=(%s)/(%s)=%s=%s',
           [vU.GetPolarFormulaStr(cU), vZ.GetPolarFormulaStr(cR), vI.GetPolarFormulaStr(cI),
           vI.GetRectFormulaStr(cI)]);
      end;
    end;


    //Обрыв линейного провода C
    if NodeC.IsBadLin then
    begin
      if ANode.Letter = NodeC.Letter then
        Result := GetStandartFormula
      else
      begin
        vU := GetU(NodeA);
        vZ := GetZBadLin;
        Result := Format('Points(I)_bc=Points(I)_ca=(Points(U)_ab/bline(Z)_bca)=(%s)/(%s)=%s=%s',
           [vU.GetPolarFormulaStr(cU), vZ.GetPolarFormulaStr(cR), vI.GetPolarFormulaStr(cI),
           vI.GetRectFormulaStr(cI)]);
      end;
    end;

  end;


end;

function TSchemaInfo.GetIFazeSimple(ANode: TNodeInfo): Double;
begin
  Result := RndArr.FormatDouble(U/ANode.GetZSimple, cU);
end;

function TSchemaInfo.GetILin(ANode: TNodeInfo): TRectComplex;
begin
  // Для схемы звезда линейные токи равны фазным
  if SchemaType = stStar then
    Result := GetIFaze(ANode)
  else
  begin
    if ANode = NodeA then
      Result := GetIFaze(NodeA) - GetIFaze(NodeC);
    if ANode = NodeB then
      Result := GetIFaze(NodeB) - GetIFaze(NodeA);
    if ANode = NodeC then
      Result := GetIFaze(NodeC) - GetIFaze(NodeB);
  end;

end;

procedure TSchemaInfo.GetILinFormula(ANode: TNodeInfo;
  var vStr1, vStr2: String);
const
  cnstFmt1 = 'Points(I)_%s=Points(I)_%s-Points(I)_%s=(%s)-(%s)=Empty';
  cnstFmt2 = 'Empty=%s';
var
  vNode1, vNode2: TNodeInfo;
  vI1, vI2, vI: TComplexFormula;
begin
  vNode1 := ANode;
  if ANode = NodeA then
    vNode2 := NodeC;
  if ANode = NodeB then
    vNode2 := NodeA;
  if ANode = NodeC then
    vNode2 := NodeB;

  vI1 := GetIFaze(vNode1);
  vI2 := GetIFaze(vNode2);
  vI := GetILin(vNode1);
  vStr2 := Format(cnstFmt2, [vI.RectToPolarFormula(cI)]);
  if not IsBadLin then
    vStr1 := Format(cnstFmt1, [GetIndexedLetter(vNode1, False), vNode1.Letter,
      vNode2.Letter, vI1.GetRectFormulaStr(cI), vI2.GetRectFormulaStr(cI)])
  else
  begin
    //Обрыв линейного провода А
    if NodeA.IsBadLin then
    begin
      if ANode.Letter = NodeA.Letter then
      begin
        vStr1 := 'Points(I)_a=0';
        vStr2 := '';
      end
      else
        vStr1 := Format('Points(I)_b=-I_c=Points(I)_bc-Points(I)_ab=(%s)-(%s)=Empty', [vI1.GetRectFormulaStr(cI), vI2.GetRectFormulaStr(cI)]);
    end;
    //Обрыв линейного провода B
    if NodeB.IsBadLin then
    begin
      if ANode.Letter = NodeB.Letter then
      begin
        vStr1 := 'Points(I)_b=0';
        vStr2 := '';
      end
      else
        vStr1 := Format('Points(I)_a=-Points(I)_c=Points(I)_ab-Points(I)_ca=(%s)-(%s)=Empty', [vI1.GetRectFormulaStr(cI), vI2.GetRectFormulaStr(cI)]);
    end;
    //Обрыв линейного провода С
    if NodeC.IsBadLin then
    begin
      if ANode.Letter = NodeC.Letter then
      begin
        vStr1 := 'Points(I)_c=0';
        vStr2 := '';
      end
      else
        vStr1 := Format('Points(I)_a=-Points(I)_b=Points(I)_ab-Points(I)_bc=(%s)-(%s)=Empty', [vI1.GetRectFormulaStr(cI), vI2.GetRectFormulaStr(cI)]);
    end;
  end;
end;

function TSchemaInfo.GetIFazeFormulaSimple(ANode: TNodeInfo): String;
var
  vFormula: TFormula;
begin
  Result := 'I_'+ANode.Letter+'=';
  vFormula := TFormula.create;
  try
    vFormula.FormulaStr := 'U_ф/Z_'+ANode.Letter;
    vFormula.AddReplaceTerm('U_ф', U);
    vFormula.AddReplaceTerm('Z_'+ANode.Letter, ANode.GetZSimple);
    Result := Result + vFormula.FormulaStr + '='+vFormula.GetFormulaValue + '=' +
      RndArr.FormatDoubleStr(GetIFazeSimple(ANode), cI);
  finally
    FreeAndNil(vFormula);
  end;
end;

function TSchemaInfo.GetIndexedLetter(ANode: TNodeInfo;
  AIsSkipIndexTriangle: Boolean = True): String;
begin
  if AIsSkipIndexTriangle and (Length(ANode.Letter) > 1) then
  begin
    Result := ANode.Letter;
    Exit;
  end;
  Result := Copy(ANode.Letter, 1, 1);

  case IndexType of
    it1:
      Result := Result + '_1';
    it2:
      Result := Result + '_2';
    { itNone:
      Result := ANode.Letter; }
  end;
end;

function TSchemaInfo.GetPFormulaSimple(ANode: TNodeInfo): string;
const
  cnstPart = 'P_%s=U_%s*.I_%s*.cos(phi_%s)';
  cnstFormula = 'U_%s*.I_%s*.cos(phi_%s)';
var
  vFormula: TFormula;
begin
  Result := Format(cnstPart, [ANode.Letter, ANode.Letter, ANOde.Letter, ANode.Letter]) + '='+
      Format(cnstFormula, ['f', ANOde.Letter, ANode.Letter]);
  vFormula := TFormula.create;
  try
    vFormula.FormulaStr := Format(cnstFormula, [ANode.Letter, ANOde.Letter, ANode.Letter]);
    vFormula.AddReplaceTerm('U_'+ANode.Letter, U);
    vFormula.AddReplaceTerm('I_'+ANode.Letter, GetIFazeSimple(ANode));
    vFormula.AddReplaceTerm('phi_'+ANode.Letter, RndArr.FormatDouble(Math.RadToDeg(ANode.GetPhi), cPhi));
    Result := Result +'='+vFormula.GetFormulaValue + '=' + RndArr.FormatDoubleStr(GetPSimple(ANode), cP);
  finally
    FreeAndNil(vFormula);
  end;
end;

function TSchemaInfo.GetPSimple(ANode: TNodeInfo): Double;
begin
  if ANode.IsBadR0 then
    Result := 0
  else
    Result := RndArr.FormatDouble(U*GetIFazeSimple(ANode)*cos(ANode.GetPhi), cP);
end;

function TSchemaInfo.GetPTotalFormula: string;
const
  cnstFmtPatt = 'I_%s^2*.R_%s';
  cnstFmt1Patt = 'P_%s';
var
  vFormula: TFormula;
  vIa, vIb, vIc, vRa, vRb, vRc: Double;
  vRes: Double;
  vPrefixStr: String;
begin
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := '';
    vPrefixStr := '';
    if not NodeA.IsBadR0 and not NodeA.IsBadRInf then
    begin
     vFormula.FormulaStr := SplitAtoms(vFormula.FormulaStr,
        Format(cnstFmtPatt, [GetIndexedLetter(NodeA), NodeA.Letter]), '+');
     vPrefixStr := SplitAtoms(vPrefixStr, Format(cnstFmt1Patt, [GetIndexedLetter(NodeA)]), '+');
    end;
    if not NodeB.IsBadR0 and not NodeB.IsBadRInf then
    begin
     vFormula.FormulaStr := SplitAtoms(vFormula.FormulaStr,
        Format(cnstFmtPatt, [GetIndexedLetter(NodeB), NodeB.Letter]), '+');
     vPrefixStr := SplitAtoms(vPrefixStr, Format(cnstFmt1Patt, [GetIndexedLetter(NodeB)]), '+');
    end;
    if not NodeC.IsBadR0 and not NodeC.IsBadRInf then
    begin
     vFormula.FormulaStr := SplitAtoms(vFormula.FormulaStr,
        Format(cnstFmtPatt, [GetIndexedLetter(NodeC), NodeC.Letter]), '+');
     vPrefixStr := SplitAtoms(vPrefixStr, Format(cnstFmt1Patt, [GetIndexedLetter(NodeC)]), '+');
    end;


    vIa := Norm(GetIFaze(NodeA));
    vIb := Norm(GetIFaze(NodeB));
    vIc := Norm(GetIFaze(NodeC));
    vRa := NodeA.GetR;
    vRb := NodeB.GetR;
    vRc := NodeC.GetR;
    vFormula.AddReplaceTerm('I_' + NodeA.Letter, vIa);
    vFormula.AddReplaceTerm('I_' + NodeB.Letter, vIb);
    vFormula.AddReplaceTerm('I_' + NodeC.Letter, vIc);

    vFormula.AddReplaceTerm('R_' + NodeA.Letter, vRa);
    vFormula.AddReplaceTerm('R_' + NodeB.Letter, vRb);
    vFormula.AddReplaceTerm('R_' + NodeC.Letter, vRc);

    vRes := Sqr(vIa) * vRa + Sqr(vIb) * vRb + Sqr(vIc) * vRc;

    Result := 'P='+ vPrefixStr + '=' + vFormula.FormulaStr +
      '=' + vFormula.GetFormulaValue + '=' + RndArr.FormatDoubleStr(vRes, cP);

  finally
    vFormula.Free;
  end;
end;

function TSchemaInfo.GetPTotalFormulaSimple1: String;
const
  cnstFmt = 'P=P_%s+P_%s+P_%s=';
var
  vFormula: TFormula;
  vRes: Double;
begin
  Result := Format(cnstFmt, [NodeA.Letter,
      NodeB.Letter, NodeC.Letter]) +
       RndArr.FormatDoubleStr(GetPTotalSimple, cP);
end;

function TSchemaInfo.GetPTotalFormulaSimple2: String;
const
  cnstFmt = 'I_%s^2*.R_%s+I_%s^2*.R_%s+I_%s^2*.R_%s';
var
  vFormula: TFormula;
  vIa, vIb, vIc, vRa, vRb, vRc: Double;
  vRes: Double;
begin
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := Format(cnstFmt, [GetIndexedLetter(NodeA),
      NodeA.Letter, GetIndexedLetter(NodeB), NodeB.Letter,
      GetIndexedLetter(NodeC), NodeC.Letter]);
    vIa := GetIFazeSimple(NodeA);
    vIb := GetIFazeSimple(NodeB);
    vIc := GetIFazeSimple(NodeC);
    vRa := NodeA.GetR;
    vRb := NodeB.GetR;
    vRc := NodeC.GetR;
    vFormula.AddReplaceTerm('I_' + NodeA.Letter, vIa);
    vFormula.AddReplaceTerm('I_' + NodeB.Letter, vIb);
    vFormula.AddReplaceTerm('I_' + NodeC.Letter, vIc);

    vFormula.AddReplaceTerm('R_' + NodeA.Letter, vRa);
    vFormula.AddReplaceTerm('R_' + NodeB.Letter, vRb);
    vFormula.AddReplaceTerm('R_' + NodeC.Letter, vRc);

    vRes := GetPTotalSimple;

    Result := 'P=' + vFormula.FormulaStr +
      '=' + vFormula.GetFormulaValue + '=' + RndArr.FormatDoubleStr(vRes, cP);
  finally
    FreeAndNil(vFormula);
  end;
end;

function TSchemaInfo.GetPTotalSimple: Double;
begin
  Result := GetPSimple(NodeA)+GetPSimple(NodeB)+GetPSimple(NodeC);
end;

function TSchemaInfo.GetQFormulaSimple(ANode: TNodeInfo): String;
const
  cnstPart = 'Q_%s=U_%s*.I_%s*.sin(phi_%s)';
  cnstFormula = 'U_%s*.I_%s*.sin(phi_%s)';
var
  vFormula: TFormula;
begin
  Result := Format(cnstPart, [ANode.Letter, ANode.Letter, ANOde.Letter, ANode.Letter]) + '='+
      Format(cnstFormula, ['f', ANOde.Letter, ANode.Letter]);
  vFormula := TFormula.create;
  try
    vFormula.FormulaStr := Format(cnstFormula, [ANode.Letter, ANOde.Letter, ANode.Letter]);
    vFormula.AddReplaceTerm('U_'+ANode.Letter, U);
    vFormula.AddReplaceTerm('I_'+ANode.Letter, GetIFazeSimple(ANode));
    vFormula.AddReplaceTerm('phi_'+ANode.Letter, RndArr.FormatDouble(Math.RadToDeg(ANode.GetPhi), cPhi));
    Result := Result +'='+vFormula.GetFormulaValue + '=' + RndArr.FormatDoubleStr(GetQSimple(ANode), cP);
  finally
    FreeAndNil(vFormula);
  end;
end;

function TSchemaInfo.GetQSimple(ANode: TNodeInfo): Double;
begin
   if ANode.IsBadR0 or ANode.IsBadRInf then
     Result := 0
   else
     Result := RndArr.FormatDouble(U*GetIFazeSimple(ANode)*sin(ANode.GetPhi), cP);
end;

function TSchemaInfo.GetQTotalFormulaSimple2: string;
const
  cnstFmt = 'I_%s^2*.X_%s+I_%s^2*.X_%s+I_%s^2*.X_%s';
var
  vFormula: TFormula;
  vIa, vIb, vIc, vXa, vXb, vXc: Double;
  vRes: Double;
begin
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := Format(cnstFmt, [GetIndexedLetter(NodeA),
      NodeA.Letter, GetIndexedLetter(NodeB), NodeB.Letter,
      GetIndexedLetter(NodeC), NodeC.Letter]);
    vIa := GetIFazeSimple(NodeA);
    vIb := GetIFazeSimple(NodeB);
    vIc := GetIFazeSimple(NodeC);
    vXa := NodeA.GetX;
    vXb := NodeB.GetX;
    vXc := NodeC.GetX;
    vFormula.AddReplaceTerm('I_' + GetIndexedLetter(NodeA), vIa);
    vFormula.AddReplaceTerm('I_' + GetIndexedLetter(NodeB), vIb);
    vFormula.AddReplaceTerm('I_' + GetIndexedLetter(NodeC), vIc);

    vFormula.AddReplaceTerm('X_' + NodeA.Letter, vXa);
    vFormula.AddReplaceTerm('X_' + NodeB.Letter, vXb);
    vFormula.AddReplaceTerm('X_' + NodeC.Letter, vXc);

    vRes := GetQTotalSimple;

    Result := 'Q=' + vFormula.FormulaStr +
      '=' + vFormula.GetFormulaValue + '=' + RndArr.FormatDoubleStr(vRes, cP);

  finally
    vFormula.Free;
  end;
end;

function TSchemaInfo.GetQTotalFormula: String;
const
  cnstFmt = 'I_%s^2*.X_%s';
  cnstFmt1 = 'Q_%s';
var
  vFormula: TFormula;
  vIa, vIb, vIc, vXa, vXb, vXc: Double;
  vRes: Double;
  vPrefixStr: String;
begin
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := '';
    vPrefixStr := '';
    if not NodeA.IsBadR0 and not NodeA.IsBadRInf then
    begin
      vFormula.FormulaStr := SplitAtoms(vFormula.FormulaStr, Format(cnstFmt, [GetIndexedLetter(NodeA),
                              NodeA.Letter]), '+');
      vPrefixStr := SplitAtoms(vPrefixStr, 'Q_'+GetIndexedLetter(NodeA), '+');
    end;

    if not NodeB.IsBadR0 and not NodeB.IsBadRInf then
    begin
      vFormula.FormulaStr := SplitAtoms(vFormula.FormulaStr, Format(cnstFmt, [GetIndexedLetter(NodeB),
                              NodeB.Letter]), '+');
      vPrefixStr := SplitAtoms(vPrefixStr, 'Q_'+GetIndexedLetter(NodeB), '+');
    end;

    if not NodeC.IsBadR0 and not NodeC.IsBadRInf then
    begin
      vFormula.FormulaStr := SplitAtoms(vFormula.FormulaStr, Format(cnstFmt, [GetIndexedLetter(NodeC),
                              NodeC.Letter]), '+');
      vPrefixStr := SplitAtoms(vPrefixStr, 'Q_'+GetIndexedLetter(NodeC), '+');
    end;

    vIa := Norm(GetIFaze(NodeA));
    vIb := Norm(GetIFaze(NodeB));
    vIc := Norm(GetIFaze(NodeC));
    vXa := NodeA.GetX;
    vXb := NodeB.GetX;
    vXc := NodeC.GetX;
    vFormula.AddReplaceTerm('I_' + GetIndexedLetter(NodeA), vIa);
    vFormula.AddReplaceTerm('I_' + GetIndexedLetter(NodeB), vIb);
    vFormula.AddReplaceTerm('I_' + GetIndexedLetter(NodeC), vIc);

    vFormula.AddReplaceTerm('X_' + NodeA.Letter, vXa);
    vFormula.AddReplaceTerm('X_' + NodeB.Letter, vXb);
    vFormula.AddReplaceTerm('X_' + NodeC.Letter, vXc);

    vRes := 0;

    if not NodeA.IsBadRInf then
      vRes := vRes + Sqr(vIa) * vXa;

    if not NodeB.IsBadRInf then
      vRes := vRes + Sqr(vIb) * vXb;

    if not NodeC.IsBadRInf then
      vRes := vRes + Sqr(vIc) * vXc;


    //vRes := Sqr(vIa) * vXa + Sqr(vIb) * vXb + Sqr(vIc) * vXc;

    Result := 'Q='+vPrefixStr + '=' + vFormula.FormulaStr +
      '=' + vFormula.GetFormulaValue + '=' + RndArr.FormatDoubleStr(vRes, cP);

  finally
    vFormula.Free;
  end;
end;

function TSchemaInfo.GetQTotalFormulaSimple1: String;
var
   vStr: String;
begin
  vStr := '';
  if not NodeA.IsBadR0 and not NodeA.IsBadRInf then
    vStr := SplitAtoms(vStr, 'Q_'+NodeA.Letter, '+');
  if not NodeB.IsBadR0 and not NodeB.IsBadRInf then
    vStr := SplitAtoms(vStr, 'Q_'+NodeB.Letter, '+');
  if not NodeC.IsBadR0 and not NodeC.IsBadRInf then
    vStr := SplitAtoms(vStr, 'Q_'+NodeC.Letter, '+');

  Result := vStr +
     '=' + RndArr.FormatDoubleStr(GetQTotalSimple, cP);
end;

function TSchemaInfo.GetQTotalSimple: Double;
begin
  Result := GetQSimple(NodeA)+GetQSimple(NodeB)+GetQSimple(NodeC);
end;

function TSchemaInfo.GetS(ANode: TNodeInfo): TRectComplex;
begin
  if ANode.IsBadR0 or Anode.IsBadRInf then
    Result := 0
  else
   Result := GetU(ANode) * Conjugate(GetIFaze(ANode));
end;

procedure TSchemaInfo.GetSFormula(ANode: TNodeInfo; var vStr1, vStr2: String);
const
  cnstFmt1 = 'Points(S)_%s=Points(%s)*.Tilde(Points(I))_%s=(%s)*.(%s)=Empty';
  cnstFmt2 = 'Empty=%s';
var
  vS, vU, vI: TComplexFormula;
begin
  vS := GetS(ANode);
  vU := GetU(ANode);
  vI := Conjugate(GetIFaze(ANode));
  vStr1 := Format(cnstFmt1, [ANode.Letter, GetULetter(ANode),
    GetIndexedLetter(ANode), vU.GetPolarFormulaStr(cU),
    vI.GetPolarFormulaStr(cI)]);
  vStr2 := Format(cnstFmt2, [vS.PolarToNormFormula(cP)]);
end;

function TSchemaInfo.GetSFormulaSimple(ANode: TNodeInfo): string;
const cnstPatt = 'S_%s=U_%s*.I_%s=sqrt(P_%s^2+Q_%s^2)=sqrt(%s^2+(%s)^2)=%s';
begin
  Result := Format(cnstPatt, [ANode.Letter, ANode.Letter, ANode.Letter,
     ANode.Letter, ANode.Letter,
     RndArr.FormatDoubleStr(GetPSimple(ANode), cP), RndArr.FormatDoubleStr(GetQSimple(ANode), cP),
     RndArr.FormatDoubleStr(GetSSimple(ANode), cP)])
end;

function TSchemaInfo.GetSSimple(ANode: TNodeInfo): Double;
begin
  Result := RndArr.FormatDouble(U*GetIFazeSimple(ANode), cP);
end;

function TSchemaInfo.GetSTotal: TRectComplex;
begin
  Result := GetS(NodeA) + GetS(NodeB) + GetS(NodeC);
end;

procedure TSchemaInfo.GetSTotalFormula(var vStr1: string);
const
  cnstFmt1 = 'Points(S)=%s=%s=%s';
var
  vSa, vSb, vSc, vS: TComplexFormula;
  vStr2: String;
begin
  vSa := GetS(NodeA);
  vSb := GetS(NodeB);
  vSc := GetS(NodeC);
  vS := GetSTotal;

  vStr1 := '';
  if not NodeA.IsBadR0 and not NodeA.IsBadRInf then
  begin
    vStr1 := SplitAtoms(vStr1, 'Points(S)_'+NodeA.Letter, '+');
    vStr2 := SplitAtoms(vStr2, vSa.GetRectFormulaStr(cP), '+');
  end;

  if not NodeB.IsBadR0 and not NodeB.IsBadRInf then
  begin
    vStr1 := SplitAtoms(vStr1, 'Points(S)_'+NodeB.Letter, '+');
    vStr2 := SplitAtoms(vStr2, vSb.GetRectFormulaStr(cP), '+');
  end;

  if not NodeC.IsBadR0 and not NodeC.IsBadRInf then
  begin
    vStr1 := SplitAtoms(vStr1, 'Points(S)_'+NodeC.Letter, '+');
    vStr2 := SplitAtoms(vStr2, vSC.GetRectFormulaStr(cP), '+');
  end;

  vStr1 := Format(cnstFmt1, [vStr1, vStr2, vS.GetRectFormulaStr(cP)]);
end;

function TSchemaInfo.GetSTotalFormulaSimple: String;
begin
  Result := 'S=sqrt(P^2+Q^2)=sqrt('+RndArr.FormatDoubleStr(GetPTotalSimple, cP)+'^2+('+
    RndArr.FormatDoubleStr(GetQTotalSimple, cP)+')^2)='+RndArr.FormatDoubleStr(GetSTotalSimple, cP);
end;

function TSchemaInfo.GetSTotalSimple: Double;
begin
  Result := RndArr.FormatDouble(Sqrt(Sqr(GetPTotalSimple)+sqr(GetQTotalSimple)), cP);
end;

function TSchemaInfo.GetU(ANode: TNodeInfo; AIsNeedR0: Boolean = True): TPolarComplex;
begin
  //Если в текущей ноде КЗ то напряжение там равно 0
   if ANode.IsBadR0 then
    Result := 0
  else
  begin
    Result.Radius := U;
    //Если где то в другой ноде КЗ то считаем хитрее
    if Self.IsBadR0 then
    begin
      Result.Radius := FMainSchema.FUl;
      if Self.NodeA.IsBadR0 then
      begin
        if ANode = self.NodeB then
          Result.Angle := pi+pi/6;
        if ANode = self.NodeC then
          Result.Angle := pi-pi/6;
      end;

      if self.NodeB.IsBadR0 then
      begin
        if ANode = self.NodeA then
          Result.Angle := pi/6;
        if ANode = self.NodeC then
          Result.Angle := pi/2;
      end;

      if self.NodeC.IsBadR0 then
      begin
        if ANode = self.NodeA then
          Result.Angle := -pi/6;
        if ANode = self.NodeB then
          Result.Angle := -pi/2
      end;


    end
    else
    //
    if Self.IsBadLin then
    begin
       //При обрыве фазы А особым образом следует считать фазу B
       if NodeA.IsBadLin and (ANode.Letter = NodeB.Letter) then
           Result.Angle := -pi/2
       //При обрыве фазы B особым образом следует считать фазу C
       else if NodeB.IsBadLin and (ANode.Letter = NodeC.Letter) then
           Result.Angle := pi-pi/6
       //При обрыве фазы C особым образом следует считать фазу A
       else if NodeC.IsBadLin and (ANode.Letter = NodeA.Letter) then
           Result.Angle := pi-pi/6
       else
         Result := GetIFaze(ANode)*ANode.GetZ
    end
    else
    //Иначе считаем как обычно
    begin
      Result.Angle := Math.DegToRad(ANode.ej);
      if AIsNeedR0 then
        Result := Result - GetU0;
    end;
  end;
end;

procedure TSchemaInfo.ProcessAllNodes(AProcessNodeProc: TProcessNodeProc);
begin
  AProcessNodeProc(NodeA);
  AProcessNodeProc(NodeB);
  AProcessNodeProc(NodeC);
end;

{ TSolveOutput }

procedure TSolveOutput.CalcUf(ASchemaType: TSchemaType);
var
  vSchemaInfo: TSchemaInfo;
  tmp: String;
begin
  // Фазное напряжение определяем только для типа соединения
  // звезда если есть линейное напряение
  vSchemaInfo := FMainSchema.Schema[ASchemaType];
  if vSchemaInfo.UFormula <> '' then
  begin
    if FMainSchema.FULetter = 'ф' then
      tmp := lc('CalcUf#1_Lin')
    else
      tmp := lc('CalcUf#1_Faz');

    FEditor.InsertTextW(#13#10 + tmp + #13#10);
    RVAddFormula(vSchemaInfo.UFormula, FEditor);
    FEditor.InsertTextW(' В'#13#10);
  end;
end;

constructor TSolveOutput.Create(AEditor: TRichViewEdit;
  AMainSchema: TMainSchema);
begin
  FEditor := AEditor;
  FMainSchema := AMainSchema;
  FBitmapMain := TBitmap.Create;
  FBitmapScale := TBitmap.Create;
  FBitmapDiagram := TBitmap.Create;
end;

destructor TSolveOutput.Destroy;
begin

  inherited;
end;


procedure TSolveOutput.PrepareW;
const
  cnstFormulaPatt = 'omega=2*pi*.f=2*pi*%s=%s';
begin
  if IsAssigned(FMainSchema.f) then
  begin
    FEditor.InsertTextW(lc('PrepareX#1') + #13#10);
    FMainSchema.W := 2 * pi * FMainSchema.f;
    RVAddFormula(Format(cnstFormulaPatt, [RndArr.FormatDoubleStr(FMainSchema.f,
      cPhi), RndArr.FormatDoubleStr(FMainSchema.W, cW)]), FEditor);
    FEditor.InsertTextW(' рад/с');
  end;
end;

procedure TSolveOutput.PrepareX(ASchemaType: TSchemaType);
var
  vSchema: TSchemaInfo;
  vFormula: TFormula;

  procedure ProcessNode(ANode: TNodeInfo);
  var
    vFormula: TFormula;
    vStr: String;
    tmp: String;
  begin

    if IsAssigned(ANode.XL) then
    begin
      FEditor.InsertTextW(#13#10);
      RVAddFormula(ANode.XLFormula, FEditor);
      FEditor.InsertTextW(' Ом');
    end;

    if IsAssigned(ANode.XC) then
    begin
      FEditor.InsertTextW(#13#10);
      RVAddFormula(ANode.XCFormula, FEditor);
      FEditor.InsertTextW(' Ом');
    end;
  end;

begin
  vSchema := FMainSchema.Schema[ASchemaType];

  if IsAssigned(FMainSchema.W) then
  begin
    FEditor.InsertTextW(#13#10 + lc('Preparex#2'));
    ProcessNode(vSchema.NodeA);
    ProcessNode(vSchema.NodeB);
    ProcessNode(vSchema.NodeC);
  end;
end;

procedure TSolveOutput.PrintAvariaPreambule;

   function PrepareText(AText: String; ALetter: String): String;
   begin
     Result := AnsiReplaceStr(AText, '%s', ALetter);
     Result := AnsiReplaceStr(Result, '%S', UpperCase(ALetter));

   end;

   procedure PrintBadR0SchemaStar;
   const
     cnstFormulaPatt = 'U_0=(U_a*.Y_a+U_b*.Y_b+U_c*.Y_c)/(Y_a+Y_b+Y_c)=(U_a*.(Y_a/Y_%s)+U_b*.(Y_b/Y_%s)+U_c*.(Y_c/Y_%s))/((Y_a/Y_%s)+(Y_b/Y_%s)+(Y_c/Y_%s))';
   var
     vText: String;
     vLetter: String;
   begin
     vLetter := FMainSchema.SchemaStar.BadR0Node.Letter;
     vText := PrepareText(lc('BadR0#1'), vLetter);
     RVAddFormulaAndText (vText, FEditor);
     FEditor.InsertTextW(#13#10);
     vText := PrepareText(lc('BadR0#2'), vLetter);
     RVAddFormulaAndText (vText, FEditor);
     FEditor.InsertTextW(#13#10+lc('BadR0#3')+#13);
     vText := AnsiReplaceStr(cnstFormulaPatt, '%s', vLetter);
     case vLetter[1] of
       'a': vText := vText + '=(U_a+0+0)/(1+0+0)=U_a';
       'b': vText := vText + '=(0+U_b+0)/(0+1+0)=U_b';
       'c': vText := vText + '=(0+0+U_c)/(0+0+1)=U_c';
     end;
     RVAddFormula(vText, FEditor);
     vText := PrepareText(lc('BadR0#4'), vLetter);
     FEditor.InsertTextW(#13#10+vText+#13#10);

   end;

   procedure PrintBadRInfSchemaStar;
    var
     vText: String;
     vLetter: String;
   begin
     vLetter := FMainSchema.SchemaStar.BadRInfNode.Letter;
     vText := PrepareText(lc('BadRInf#1'), vLetter);
     RVAddFormulaAndText (vText, FEditor);
   end;

   procedure PrintBadRInfSchemaTriangle;
   var
     vText: String;
     vLetter: String;
   begin
     vLetter := FMainSchema.SchemaTriang.BadRInfNode.Letter;
     vText := PrepareText(lc('BadRInf_Tr#1'), vLetter);
     RVAddFormulaAndText (vText, FEditor);
   end;

   procedure PrintBadLinSchemaTriangle;
   var
     vText: String;
     vLetter: String;
   begin
     vLetter := FMainSchema.SchemaTriang.BadLinLetter;
     vText := PrepareText(lc('BadLin#1'), vLetter);
     RVAddFormulaAndText (vText, FEditor);
   end;



begin
  if (FMainSchema.SchemaType = [stStar]) then
  begin
    if FMainSchema.SchemaStar.IsBadR0 then
      PrintBadR0SchemaStar;
    if FMainSchema.SchemaStar.IsBadRInf then
      PrintBadRInfSchemaStar;
  end;

  if (FMainSchema.SchemaType = [stTriangle]) then
  begin
    if FMainSchema.SchemaTriang.IsBadRInf then
      PrintBadRInfSchemaTriangle;

    if FMainSchema.SchemaTriang.IsBadLin then
       PrintBadLinSchemaTriangle;
  end;

end;

procedure TSolveOutput.PrintDiagram;
const
  cnstMargins = 30;
  cnstR = 35;

var
  vMaxI, vMaxU: Double;
  vKoeffI, vKoeffU: Double;
  vUa, vUb, vUc: TPolarComplex;
  vUa0, vUb0, vUc0, vU0: TPolarComplex;
  vIa, vIb, vIc, vI0: TRectComplex;
  vSchema: TSchemaInfo;
  vWidth: Integer;
  vHeight: Integer;

  procedure CalcU;
  begin
    vUa := PolarComplex(vSchema.U, Math.DegToRad(vSchema.NodeA.ej));
    vUb := PolarComplex(vSchema.U, Math.DegToRad(vSchema.NodeB.ej));
    vUc := PolarComplex(vSchema.U, Math.DegToRad(vSchema.NodeC.ej));
    vUa0 := vSchema.GetU(vSchema.NodeA);
    vUb0 := vSchema.GetU(vSchema.NodeB);
    vUc0 := vSchema.GetU(vSchema.NodeC);
    if not vSchema.IsBadR0 then
      vU0 := vSchema.GetU0
    else
      vU0 := 0;
  end;

  procedure CalcMaxU(ASchema: TSchemaInfo);
  begin
    vMaxU := Abs(ASchema.U);
    if FMainSchema.R0 <> 0 then
    begin
      vMaxU := MaxValue([vMaxU, Abs(ASchema.GetU(ASchema.NodeA).Radius),
                        Abs(ASchema.GetU(ASchema.NodeB).Radius),
                        Abs(ASchema.GetU(ASchema.NodeC).Radius)]);
    end;
  end;

  function Tc(x: TRectComplex; const Koeff: Double): TRectComplex;
  begin
    Result.Re := vWidth div 2 - Trunc(x.Im / Koeff) + cnstMargins;
    // Result.Re := vWidth div 2 + Trunc(x.Im / Koeff) + cnstMargins;
    Result.Im := vHeight div 2 - Trunc(x.Re / Koeff) + cnstMargins;
  end;

// Рисует вектор от точки v0, который составляет угол Angle с вектором v0;v1 и имеет длину d
// Возвращает координаты конца вектора

  function DrawVectorAngle(v0, V1: TRectComplex; d: Double; Angle: Double;
    AName: String; AIsDash: Boolean = False): TRectComplex;
  var
    vAngle: Double;
    tmp: TPolarComplex;
  begin
    if Angle > pi / 2 then
      Angle := Angle - pi;
    v0 := Tc(v0, vKoeffU);
    V1 := Tc(V1, vKoeffU);
    d := d / vKoeffI;
    V1 := V1 - v0;
    vAngle := TPolarComplex(V1).Angle + Angle;
    tmp.Radius := d;
    tmp.Angle := vAngle;
    Result := tmp;
    Result := Result + v0;
    if AName <> '' then
      InsertFormulaIntoPictureEx(FBitmapMain, Trunc(Result.Re) + 5,
        Trunc(Result.Im) + 5, AName);
    DrawArrow(Trunc(v0.Re), Trunc(v0.Im), Trunc(Result.Re), Trunc(Result.Im),
      AIsDash, FBitmapMain.Canvas, clBlue, 2);

  end;

  procedure DrawVector(v0, V1: TRectComplex; AName: String; Koeff: Double;
    AIsDash: Boolean = False; AAddx: Double = 0; AAddY: Double = 0;
    vAddKoeff: Double = 0; ADeltaY: Integer = 5);
  var
    vAdd: TRectComplex;
  begin
    vAdd := RectComplex(0, 0);
    if vAddKoeff > 0 then
      vAdd := Tc(RectComplex(AAddx, AAddY), vAddKoeff) -
        Tc(RectComplex(0, 0), vAddKoeff);
    v0 := Tc(v0, Koeff);
    V1 := Tc(V1, Koeff);
    v0 := v0 + vAdd;
    V1 := V1 + vAdd;
    if AName <> '' then
      InsertFormulaIntoPictureEx(FBitmapMain, Trunc(V1.Re) + 5,
        Trunc(V1.Im) + ADeltaY, AName);
    DrawArrow(Trunc(v0.Re), Trunc(v0.Im), Trunc(V1.Re), Trunc(V1.Im), AIsDash,
      FBitmapMain.Canvas, clBlue, 2);
  end;

  procedure DrawVectorMiddle(v0, V1: TRectComplex; AName: String; Koeff: Double;
    AIsDash: Boolean = False; AAddx: Double = 0; AAddY: Double = 0;
    vAddKoeff: Double = 0; ADeltaY: Integer = -15);
  var
    x, y: Integer;
    vAdd: TRectComplex;
  begin
    v0 := Tc(v0, Koeff);
    V1 := Tc(V1, Koeff);
    vAdd := RectComplex(0, 0);
    if vAddKoeff > 0 then
      vAdd := Tc(RectComplex(AAddx, AAddY), vAddKoeff) -
        Tc(RectComplex(0, 0), vAddKoeff);
    v0 := v0 + vAdd;
    V1 := V1 + vAdd;

    x := Trunc((v0.Re + V1.Re)) div 2;
    y := Trunc((v0.Im + V1.Im)) div 2;
    { if (v0.Re - V1.Re)*(v0.Im-v1.Im)<=0 then
      y := y+5
      else }
    y := y + ADeltaY;

    if AName <> '' then
      InsertFormulaIntoPictureEx(FBitmapMain, x, y, AName);
    DrawArrow(Trunc(v0.Re), Trunc(v0.Im), Trunc(V1.Re), Trunc(V1.Im), AIsDash,
      FBitmapMain.Canvas, clBlue, 2);
  end;

  procedure DrawVectorRadius(v: TRectComplex; AName: String; Koeff: Double; AIsDash: Boolean = False);
  begin
    DrawVector(RectComplex(0, 0), v, AName, Koeff, AIsDash);
  end;

  procedure DrawAngle(v0, V1: TRectComplex; AFormula: string); overload;
  var
    vPhi1, vPhi2: Double;
    tmp: Double;
  begin
    vPhi1 := Math.RadToDeg(NormalizeAngle(TPolarComplex(v0).Angle + pi / 2));
    vPhi2 := Math.RadToDeg(NormalizeAngle(TPolarComplex(V1).Angle + pi / 2));
    if vPhi1 = vPhi2 then
      Exit;

    // Меняем местами чтобы всегда соединяло по меньшей траектории
    if vPhi1 > vPhi2 then
    begin
      tmp := vPhi1;
      vPhi1 := vPhi2;
      vPhi2 := tmp;
    end;

    if vPhi2 - vPhi1 > 180 then
      vPhi2 := vPhi2 - 360;

    if AFormula <> '' then
      InsertFormulaIntoPictureEx(FBitmapMain, vWidth div 2 + cnstMargins +
        Trunc(cnstR * cos(Math.DegToRad((vPhi1 + vPhi2) / 2))) - 15,
        vWidth div 2 + cnstMargins -
        Trunc(cnstR * sin(Math.DegToRad((vPhi1 + vPhi2) / 2))), AFormula, 8);

    FBitmapMain.Canvas.Pen.Width := 1;
    FBitmapMain.Canvas.Pen.Color := clBlue;
    FBitmapMain.Canvas.Pen.Style := psSolid;
    FBitmapMain.Canvas.MoveTo(vWidth div 2 + cnstMargins +
      Trunc(cnstR * cos(Math.DegToRad(vPhi1))), vHeight div 2 + cnstMargins -
      Trunc(cnstR * sin(Math.DegToRad(vPhi1))));
    FBitmapMain.Canvas.AngleArc(vWidth div 2 + cnstMargins,
      vHeight div 2 + cnstMargins, cnstR, vPhi1, vPhi2 - vPhi1);
  end;

// v0 должно быть уже отмасштабировано!
  procedure DrawAngle(v0: TRectComplex; Angle1, Angle2: Double;
    AFormula: string); overload;
  var
    vPhi1, vPhi2: Double;
    tmp: Double;
  begin
    vPhi1 := Math.RadToDeg(NormalizeAngle(Angle1) + pi / 2);
    vPhi2 := Math.RadToDeg(NormalizeAngle(Angle2) + pi / 2);
    if (vPhi1 = vPhi2) or (RoundTo(Abs(vPhi1 - vPhi2) - pi, cnstRoundPref) = 0)
    then
      Exit;

    // Меняем местами чтобы всегда соединяло по меньшей траектории
    if vPhi1 > vPhi2 then
    begin
      tmp := vPhi1;
      vPhi1 := vPhi2;
      vPhi2 := tmp;
    end;

    if vPhi2 - vPhi1 > 180 then
      vPhi2 := vPhi2 - 360;

    if AFormula <> '' then
      InsertFormulaIntoPictureEx(FBitmapMain,
        Trunc(v0.Re + cnstR * cos(Math.DegToRad((vPhi1 + vPhi2) / 2))) - 15,
        Trunc(v0.Im - cnstR * sin(Math.DegToRad((vPhi1 + vPhi2) / 2)) - 20),
        AFormula, 8);

    FBitmapMain.Canvas.Pen.Width := 1;
    FBitmapMain.Canvas.Pen.Color := clBlue;
    FBitmapMain.Canvas.Pen.Style := psSolid;
    FBitmapMain.Canvas.MoveTo(Trunc(v0.Re + cnstR * cos(Math.DegToRad(vPhi1))),
      Trunc(v0.Im - cnstR * sin(Math.DegToRad(vPhi1))));
    FBitmapMain.Canvas.AngleArc(Trunc(v0.Re), Trunc(v0.Im), cnstR, vPhi1,
      vPhi2 - vPhi1);
  end;

  procedure PrintDiagramBoth;
  type
    TDrawingTool = (dtPoint, dtLine, dtRectangle, dtSceneRect);
  var
    vIa1, vIa2, vIb1, vIb2, vIc1, vIc2: TRectComplex;
    vPhia1, vPhia2, vPhib1, vPhib2, vphic1, vPhic2: Double;
    vAddHorz: Double;
    vAddVert: Double;
  begin
    vSchema := FMainSchema.Schema[stStar];
    CalcU;
    vIa1 := vSchema.GetILin(vSchema.NodeA);
    vIb1 := vSchema.GetILin(vSchema.NodeB);
    vIc1 := vSchema.GetILin(vSchema.NodeC);

    vPhia1 := vSchema.NodeA.GetPhi;
    vPhib1 := vSchema.NodeB.GetPhi;
    vphic1 := vSchema.NodeC.GetPhi;

    CalcMaxU(vSchema);

    vSchema := FMainSchema.Schema[stTriangle];
    vIa2 := vSchema.GetILin(vSchema.NodeA);
    vIb2 := vSchema.GetILin(vSchema.NodeB);
    vIc2 := vSchema.GetILin(vSchema.NodeC);
    vPhia2 := vSchema.NodeA.GetPhi;
    vPhib2 := vSchema.NodeB.GetPhi;
    vPhic2 := vSchema.NodeC.GetPhi;

    vIa := vIa2 + vIa1;
    vIb := vIb2 + vIb1;
    vIc := vIc2 + vIc1;

    vAddHorz := MaxValue([vIa1.Re, vIb1.Re, vIc1.Re, vIa2.Re, vIb2.Re, vIc2.Re,
      vIa.Re, vIb.Re, vIc.Re]) +
      Abs(MinValue([vIa1.Re, vIb1.Re, vIc1.Re, vIa2.Re, vIb2.Re, vIc2.Re,
      vIa.Re, vIb.Re, vIc.Re]));
    vAddVert := MaxValue([vIa1.Im, vIb1.Im, vIc1.Im, vIa2.Im, vIb2.Im, vIc2.Im,
      vIa.Im, vIb.Im, vIc.Im]) +
      Abs(MinValue([vIa1.Im, vIb1.Im, vIc1.Im, vIa2.Im, vIb2.Im, vIc2.Im,
      vIa.Im, vIb.Im, vIc.Im]));

    vMaxI := Max(vAddHorz, vAddVert);
    vKoeffI := vMaxI / vHeight * 1.5;
    vMaxU := vMaxU + vMaxI / vKoeffI;
    vKoeffU := vMaxU / vHeight * 1.87;

    DrawVectorRadius(vUa, 'Points(U)_a', vKoeffU);
    DrawVectorRadius(vUb, 'Points(U)_b', vKoeffU);
    DrawVectorRadius(vUc, 'Points(U)_c', vKoeffU);

    if FMainSchema.R0 <> 0 then
    begin
      DrawVectorRadius(vUa0, vSchema.GetULetter(vSchema.NodeA), vKoeffU);
      DrawVectorRadius(vUb0, vSchema.GetULetter(vSchema.NodeB), vKoeffU);
      DrawVectorRadius(vUc0, vSchema.GetULetter(vSchema.NodeC), vKoeffU);
    end;

    DrawVectorMiddle(vUb, vUa, 'Points(U)_bc', vKoeffU);
    DrawVectorMiddle(vUa, vUc, 'Points(U)_ab', vKoeffU);
    DrawVectorMiddle(vUc, vUb, 'Points(U)_ca', vKoeffU);

    DrawVectorRadius(vIa1, 'Points(I)_a_1', vKoeffI);
    DrawVector(vIa1, vIa1 + vIa2, 'Points(I)_a_2', vKoeffI, True, 0, 0, 0, -20);
    DrawVectorRadius(vIb1, 'Points(I)_b_1', vKoeffI);
    DrawVector(vIb1, vIb1 + vIb2, 'Points(I)_b_2', vKoeffI, True, 0, 0, 0, -20);
    DrawVectorRadius(vIc1, 'Points(I)_c_1', vKoeffI);
    DrawVector(vIc1, vIc1 + vIc2, 'Points(I)_c_2', vKoeffI, True, 0, 0, 0, -20);

    DrawVectorRadius(vIa, 'Points(I)_a', vKoeffI);
    DrawVectorRadius(vIb, 'Points(I)_b', vKoeffI);
    DrawVectorRadius(vIc, 'Points(I)_c', vKoeffI);

    DrawAngle(vIa1, vUa, 'phi_a_1=' + RndArr.FormatDoubleStr
      (Math.RadToDeg(vPhia1), cPhi) + '^0');
    DrawAngle(vIb1, vUb, 'phi_b_1=' + RndArr.FormatDoubleStr
      (Math.RadToDeg(vPhib1), cPhi) + '^0');
    DrawAngle(vIc1, vUc, 'phi_c_1=' + RndArr.FormatDoubleStr
      (Math.RadToDeg(vphic1), cPhi) + '^0');

    if FMainSchema.R0 = 0 then
    begin
      DrawAngle(Tc(vUb, vKoeffU), 2 * pi / 3 - pi / 2, TPolarComplex(vIa2).Angle,
        'phi_a_2=' + RndArr.FormatDoubleStr(Math.RadToDeg(vPhia2), cPhi) + '^0');
      DrawAngle(Tc(vUa, vKoeffU), -2 * pi / 3 - pi / 2, TPolarComplex(vIc2).Angle,
        'phi_c_2=' + RndArr.FormatDoubleStr(Math.RadToDeg(vPhic2), cPhi) + '^0');
      DrawAngle(Tc(vUc, vKoeffU), 0 - pi / 2, TPolarComplex(vIb2).Angle,
        'phi_b_2=' + RndArr.FormatDoubleStr(Math.RadToDeg(vPhib2), cPhi) + '^0');
    end;

    DrawVector(RectComplex(0, 0), vIa2, 'Points(I)_a_2', vKoeffI, False,
      TRectComplex(vUb).Re, TRectComplex(vUb).Im, vKoeffU);
    DrawVector(RectComplex(0, 0), vIb2, 'Points(I)_b_2', vKoeffI, False,
      TRectComplex(vUc).Re, TRectComplex(vUc).Im, vKoeffU);
    DrawVector(RectComplex(0, 0), vIc2, 'Points(I)_c_2', vKoeffI, False,
      TRectComplex(vUa).Re, TRectComplex(vUa).Im, vKoeffU);
  end;

  procedure PrintDiagramStar;
  var vIsDashU: Boolean;
  begin
    vSchema := FMainSchema.Schema[stStar];
    CalcU;
    CalcMaxU(vSchema);
    vKoeffU := vMaxU / vHeight * 2;
    vIsDashU := FMainSchema.R0 <> 0;
    DrawVectorRadius(vUa, 'Points(U)_a', vKoeffU, vIsDashU);
    DrawVectorRadius(vUb, 'Points(U)_b', vKoeffU, vIsDashU);
    DrawVectorRadius(vUc, 'Points(U)_c', vKoeffU, vIsDashU);
    if (FMainSchema.R0 <> 0) and not vSchema.IsBadR0 then
    begin
      DrawVectorRadius(vUa0, vSchema.GetULetter(vSchema.NodeA), vKoeffU);
      DrawVectorRadius(vUb0, vSchema.GetULetter(vSchema.NodeB), vKoeffU);
      DrawVectorRadius(vUc0, vSchema.GetULetter(vSchema.NodeC), vKoeffU);
      DrawVectorRadius(vU0, 'U_0', vKoeffU);
    end;

    vIa := vSchema.GetILin(vSchema.NodeA);
    vIb := vSchema.GetILin(vSchema.NodeB);
    vIc := vSchema.GetILin(vSchema.NodeC);
    vI0 := vSchema.GetI0;
    vMaxI := MaxValue([Abs(vI0.Re), Abs(vI0.Im), Abs(vIa.Re) + Abs(vIb.Re)
      { +Abs(vIc.Re) } , Abs(vIa.Im) + Abs(vIb.Im) { +Abs(vIc.Im) } ]);
    vKoeffI := vMaxI / vHeight * 2;
    if not vSchema.NodeA.isBadRInf then
      DrawVectorRadius(vIa, 'Points(I)_a', vKoeffI);
    if not vSchema.NodeB.isBadRInf then
      DrawVectorRadius(vIb, 'Points(I)_b', vKoeffI);
    if not vSchema.NodeC.isBadRInf then
      DrawVectorRadius(vIc, 'Points(I)_c', vKoeffI);

    if FMainSchema.R0 <> Infinity then
    begin
      DrawVectorRadius(vI0, 'Points(I)_0', vKoeffI);
      DrawVector(vIa, vIa + vIb, '', vKoeffI, True);
      DrawVector(vIa + vIb, vI0, '', vKoeffI, True);
    end;
    if FMainSchema.R0 = 0 then
    begin
     if not vSchema.NodeA.isBadRInf then
      DrawAngle(vIa, vUa, 'phi_a=' + RndArr.FormatDoubleStr
        (Math.RadToDeg(vSchema.NodeA.GetPhi), cPhi) + '^0');
     if not vSchema.NodeB.isBadRInf then
      DrawAngle(vIb, vUb, 'phi_b=' + RndArr.FormatDoubleStr
        (Math.RadToDeg(vSchema.NodeB.GetPhi), cPhi) + '^0');
    if not vSchema.NodeC.isBadRInf then
      DrawAngle(vIc, vUc, 'phi_c=' + RndArr.FormatDoubleStr
        (Math.RadToDeg(vSchema.NodeC.GetPhi), cPhi) + '^0');
    end
    else
    begin
     if not vSchema.NodeA.isBadRInf then
      DrawAngle(vIa, vUa0, 'phi_a=' + RndArr.FormatDoubleStr
        (Math.RadToDeg(vSchema.NodeA.GetPhi), cPhi) + '^0');
     if not vSchema.NodeB.isBadRInf then
      DrawAngle(vIb, vUb0, 'phi_b=' + RndArr.FormatDoubleStr
        (Math.RadToDeg(vSchema.NodeB.GetPhi), cPhi) + '^0');
     if not vSchema.NodeC.isBadRInf then
      DrawAngle(vIc, vUc0, 'phi_c=' + RndArr.FormatDoubleStr
        (Math.RadToDeg(vSchema.NodeC.GetPhi), cPhi) + '^0');
    end;

  end;

  procedure PrintDiagramTriangle;
  var
    vU1, vU2, vU3: TRectComplex;
    Ia, Ib, Ic: TRectComplex;
    Iab, Ibc, Ica: TRectComplex;
    vAddHorz, vAddVert: Double;
    tmp: TPolarComplex;
    tmp1: TRectComplex;
  begin
    vSchema := FMainSchema.Schema[stTriangle];
    CalcU;
    CalcMaxU(vSchema);
    Ia := vSchema.GetILin(vSchema.NodeA);
    Ib := vSchema.GetILin(vSchema.NodeB);
    Ic := vSchema.GetILin(vSchema.NodeC);

    Iab := vSchema.GetIFaze(vSchema.NodeA);
    Ibc := vSchema.GetIFaze(vSchema.NodeB);
    Ica := vSchema.GetIFaze(vSchema.NodeC);

    vMaxU := Abs(vSchema.U);
    if FMainSchema.R0 <> 0 then
    begin
      vMaxU := MaxValue([vMaxU, Abs(vSchema.GetU(vSchema.NodeA).Radius),
                        Abs(vSchema.GetU(vSchema.NodeB).Radius),
                        Abs(vSchema.GetU(vSchema.NodeC).Radius)]);
    end;

    vAddHorz := MaxValue([Ia.Re, Ib.Re, Ic.Re, Iab.Re, Ibc.Re, Ica.Re]) +
      Abs(MinValue([Ia.Re, Ib.Re, Ic.Re, Iab.Re, Ibc.Re, Ica.Re]));
    vAddVert := MaxValue([Ia.Im, Ib.Im, Ic.Im, Iab.Im, Ibc.Im, Ica.Im]) +
      Abs(MinValue([Ia.Im, Ib.Im, Ic.Im, Iab.Im, Ibc.Im, Ica.Im]));
    vMaxI := Max(vAddHorz, vAddVert);
    vKoeffI := vMaxI / vHeight * 2;
    vMaxU := vMaxU + vMaxI / vKoeffI;

    vKoeffU := vMaxU / vHeight;
    vU1.Im := Abs(vSchema.U) / 2;;
    vU1.Re := -Abs(vSchema.U) / 2 / sqrt(3);
    vU2.Im := -Abs(vSchema.U) / 2;
    vU2.Re := -Abs(vSchema.U) / 2 / sqrt(3);
    if not vSchema.NodeB.IsBadRInf then
      DrawVectorMiddle(vU1, vU2, 'U_(BC)', vKoeffU, False, 0, 0, 0, 5);
    vU3.Im := 0;
    vU3.Re := Abs(vSchema.U) / sqrt(3);
    if not vSchema.NodeA.IsBadRInf then
      DrawVectorMiddle(vU2, vU3, 'U_(AB)', vKoeffU);
    if not vSchema.NodeC.IsBadRInf then
      DrawVectorMiddle(vU3, vU1, 'U_(CA)', vKoeffU, False);

    // Рисуем векторы
    if not vschema.NodeA.IsBadRInf then
      DrawVector(RectComplex(0, 0), Iab, 'Points(I)_ab', vKoeffI, False, vU2.Re,
        vU2.Im, vKoeffU);

    if Ia <> 0 then
    DrawVector(RectComplex(0, 0), Ia, 'Points(I)_a', vKoeffI, False, vU2.Re,
      vU2.Im, vKoeffU);
    if not vschema.NodeA.IsBadRInf then
      DrawAngle(Tc(vU2, vKoeffU), 2 * pi / 3 - pi / 2, TPolarComplex(Iab).Angle,
        'phi_ab=' + RndArr.FormatDoubleStr(Math.RadToDeg(vSchema.NodeA.GetPhi),
        cPhi) + '^0');

    if not vschema.NodeC.IsBadRInf then
      DrawVector(RectComplex(0, 0), Ica, 'Points(I)_ca', vKoeffI, False, vU3.Re,
        vU3.Im, vKoeffU);

    if Ic <> 0 then
      DrawVector(RectComplex(0, 0), Ic, 'Points(I)_с', vKoeffI, False, vU3.Re,
       vU3.Im, vKoeffU);
    if not vschema.NodeC.IsBadRInf then
     DrawAngle(Tc(vU3, vKoeffU), -2 * pi / 3 - pi / 2, TPolarComplex(Ica).Angle,
      'phi_ca=' + RndArr.FormatDoubleStr(Math.RadToDeg(vSchema.NodeC.GetPhi),
      cPhi) + '^0');

   if not vschema.NodeB.IsBadRInf then
      DrawVector(RectComplex(0, 0), Ibc, 'Points(I)_bc', vKoeffI, False, vU1.Re,
        vU1.Im, vKoeffU);

    if Ib <> 0 then
    DrawVector(RectComplex(0, 0), Ib, 'Points(I)_b', vKoeffI, False, vU1.Re,
      vU1.Im, vKoeffU);
    if not vschema.Nodeb.IsBadRInf then
      DrawAngle(Tc(vU1, vKoeffU), 0 - pi / 2, TPolarComplex(Ibc).Angle,
        'phi_bc=' + RndArr.FormatDoubleStr(Math.RadToDeg(vSchema.NodeB.GetPhi),
        cPhi) + '^0');

    //
    if not vschema.NodeC.IsBadRInf and not vSchema.IsBadLin then
      DrawVectorMiddle(Iab, Iab - Ica, '-Points(I)_ca', vKoeffI, True, vU2.Re,
        vU2.Im, vKoeffU, -20);
    if not vschema.NodeB.IsBadRInf and not vSchema.IsBadLin then
      DrawVectorMiddle(Ica, Ica - Ibc, '-Points(I)_bc', vKoeffI, True, vU3.Re,
        vU3.Im, vKoeffU, -20);
    if not vschema.NodeA.IsBadRInf and not vSchema.IsBadLin then
     DrawVectorMiddle(Ibc, Ibc - Iab, '-Points(I)_ab', vKoeffI, True, vU1.Re,
        vU1.Im, vKoeffU, +5);

  end;

// Рисует масштабные коэффициенты
  procedure DrawMultKoeff;
  const
    vStartY = 20;
    cnstX = 50;
    cnstY = 50;
  var
    vCntX, vCntY: Double;
    vWidthX, vWidthY: Integer;
  begin
    FBitmapScale.Width := 80;
    FBitmapScale.Height := 80;
    vCntX := GetNeast(cnstX * vKoeffU);
    vCntY := GetNeast(cnstY * vKoeffI);
    vWidthX := Trunc(vCntX / vKoeffU);
    vWidthY := Trunc(vCntY / vKoeffI);

    FBitmapScale.Canvas.MoveTo(60 - vWidthX, vStartY);
    FBitmapScale.Canvas.LineTo(60, vStartY);
    FBitmapScale.Canvas.TextOut(60 - vWidthX + 10, vStartY - 20,
      RndArr.FormatDoubleStr(vCntX, cU) + ' B');
    FBitmapScale.Canvas.MoveTo(60, vStartY - 5);
    FBitmapScale.Canvas.LineTo(60, vStartY + 5);
    FBitmapScale.Canvas.MoveTo(60 - vWidthX, vStartY - 5);
    FBitmapScale.Canvas.LineTo(60 - vWidthX, vStartY + 5);

    FBitmapScale.Canvas.MoveTo(60 - vWidthY, vStartY + 40);
    FBitmapScale.Canvas.LineTo(60, vStartY + 40);
    FBitmapScale.Canvas.TextOut(60 - vWidthY + 10, vStartY + 20,
      RndArr.FormatDoubleStr(vCntY, cI) + ' A');
    FBitmapScale.Canvas.MoveTo(60 - vWidthY, vStartY + 35);
    FBitmapScale.Canvas.LineTo(60 - vWidthY, vStartY + 45);
    FBitmapScale.Canvas.MoveTo(60, vStartY + 35);
    FBitmapScale.Canvas.LineTo(60, vStartY + 45);
    // FEditor.InsertTextW(#13#10);
    // FEditor.InsertTextW('Масштаб'#13#10);
    // FEditor.InsertPicture('image1', FBitmapScale, rvvaMiddle);
  end;

begin

  FBitmapMain.Width := FMainSchema.DiagramSize;
  FBitmapMain.Height := FMainSchema.DiagramSize;
  ClearImage(FBitmapMain);
  vWidth := FMainSchema.DiagramSize - 2 * cnstMargins;
  vHeight := FMainSchema.DiagramSize - 2 * cnstMargins;
  // Рисуем координатные оси. Они всегда в центре
  FBitmapMain.Canvas.Pen.Style := psDash;
  FBitmapMain.Canvas.MoveTo(cnstMargins, vHeight div 2 + cnstMargins);
  FBitmapMain.Canvas.LineTo(vWidth + cnstMargins, vHeight div 2 + cnstMargins);
  FBitmapMain.Canvas.MoveTo(vWidth div 2 + cnstMargins, cnstMargins);
  FBitmapMain.Canvas.LineTo(vWidth div 2 + cnstMargins, vHeight + cnstMargins);
  FBitmapMain.Canvas.TextOut(2 + cnstMargins, vHeight div 2 - 15 +
    cnstMargins, '+j');
  FBitmapMain.Canvas.TextOut(vHeight div 2 - 20 + cnstMargins,
    2 + cnstMargins, '+1');


  if FMainSchema.SchemaType = [stStar] then
    PrintDiagramStar;
  if FMainSchema.SchemaType = [stTriangle] then
    PrintDiagramTriangle;
  if FMainSchema.SchemaType = [stStar, stTriangle] then
    PrintDiagramBoth;

  DrawMultKoeff;
  // FEditor.InsertTextW(#13#10);
  // FEditor.InsertPicture('diagram', FBitmapMain, rvvaAbsMiddle);
end;

procedure TSolveOutput.PrintMainSchema(var ABitmap: TBitmap);
var
  vResName: String;
  vRect: TRect;

  procedure ClearRect(x1, y1, x2, y2: Integer);
  var
    p: TRect;
  begin
    p.Left := x1;
    p.Top := y1;
    p.Bottom := y2;
    p.Right := x2;
    ABitmap.Canvas.FillRect(p);
  end;

  procedure line(x1, y1, x2, y2: Integer{; AIsClear: Boolean = False});
  begin
    {ABitmap.Canvas.Pen.Style := psSolid;
    ABitmap.Canvas.Pen.Width := 2;
    if AIsClear then
      ABitmap.Canvas.Pen.Color := clWhite;}
    ABitmap.Canvas.MoveTo(x1, y1);
    ABitmap.Canvas.LineTo(x2, y2);
    //ABitmap.Canvas.Pen.Color := clBlack;
  end;

  procedure ClearRectLine(x1, y1, x2, y2: Integer);
  begin
    ClearRect(x1, y1, x2, y2);
    line(x1, y1, x2, y2);
  end;

begin
  // FEditor.InsertTextW(#13#10+lc('MainSchema')+#13#10);
  if FMainSchema.SchemaType = [stStar] then
  begin
    if FMainSchema.R0 = Infinity then
      vResName := 'STAR_R0_INF'
    else  if FMainSchema.R0 > 0 then
      vResName := 'STAR_R0'
    else
      vResName := 'STAR';
  end;
  if FMainSchema.SchemaType = [stTriangle] then
    vResName := 'TRIANGLE';
  if FMainSchema.SchemaType = DoubleTypes then
    vResName := 'BOTH';

  { if not (FMainSchema.SchemaType = [stStar])  then
    Exit; }

  ABitmap := LoadBitmapFromRes(vResName);

  // ЗВЕЗДА
  if FMainSchema.SchemaType = [stStar] then
  begin

    // R
    if not IsAssigned(FMainSchema.Schema[stStar].NodeA.R) then
    begin
      ClearRect(253, 58, 320, 141);
      line(288, 58, 288, 141);
    end;

    //Обрыв линейного провода А
    if FMainSchema.Schema[stStar].NodeA.IsBadRInf then
    begin
      ClearRect(253, 58, 320, 141);
      DrawPoint(288, 58, ABitmap.Canvas);
      line(288, 58, 270, 100);
      DrawPoint(288, 100, ABitmap.Canvas);
      line(288, 100, 288, 141);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeB.R) then
      ClearRectLine(108, 502, 163, 448);

    //Обрыв линейного провода В
    if FMainSchema.Schema[stStar].NodeB.IsBadRInf then
    begin
      ClearRect(108, 502, 163, 448);
      DrawPoint(108, 502, ABitmap.Canvas);
      line(108, 502, 120, 470);
      DrawPoint(140, 470, ABitmap.Canvas);
      line(140, 470, 163, 448);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeC.R) then
      ClearRectLine(399, 432, 454, 486);

    //Обрыв линейного провода C
    if FMainSchema.Schema[stStar].NodeC.IsBadRInf then
    begin
      ClearRect(399, 432, 454, 486);
      DrawPoint(454, 486, ABitmap.Canvas);
      line(454, 486, 440, 450);
      DrawPoint(428, 460, ABitmap.Canvas);
      line(428, 460, 399, 432);
    end;

    // L
    if not IsAssigned(FMainSchema.Schema[stStar].NodeA.L) then
    begin
      ClearRect(253, 141, 350, 229);
      line(288, 141, 288, 229);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeB.L) then
    begin
      ClearRectLine(163, 448, 227, 383);
      // Очищаем надпись
      ClearRect(145, 389, 183, 409);
    end;
    //Очищаем линию внизу
    {else
      line(163, 448, 227, 383, True);}


    if not IsAssigned(FMainSchema.Schema[stStar].NodeC.L) then
    begin
      ClearRectLine(344, 376, 399, 432);
      ClearRect(387, 377, 422, 392);
    end;
    {else
      line(344, 376, 399, 432, True);}

    // C
    if not IsAssigned(FMainSchema.Schema[stStar].NodeA.C) then
    begin
      ClearRect(258, 226, 354, 285);
      line(288, 226, 288, 285);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeB.C) then
    begin
      ClearRectLine(227, 383, 271, 339);
      // Очищаем надпись
      ClearRect(203, 335, 250, 353);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeC.C) then
    begin
      ClearRectLine(288, 322, 344, 376);
      ClearRect(338, 332, 381, 353);
    end;
  end;

  // ТРЕУГОЛЬНИК
  if FMainSchema.SchemaType = [stTriangle] then
  begin

    // R
    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeC.R) then
    begin
      ClearRectLine(271, 61, 234, 172);
      ClearRect(262, 115, 290, 132);
    end;

    //Обрыв фазы нагрузки CA
    if FMainSchema.SchemaTriang.NodeC.IsBadRInf then
    begin
      ClearRect(257, 101, 234, 172);
      DrawPoint(257, 101, ABitmap.Canvas);
      line(257, 101, 230, 116);
      DrawPoint(248, 127, ABitmap.Canvas);
      line(248, 127, 234, 172);
    end;


    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeA.R) then
      ClearRectLine(326, 92, 401, 226);


      //Обрыв фазы нагрузки АВ
    if FMainSchema.SchemaTriang.NodeA.IsBadRInf then
    begin
      ClearRect(343, 122, 401, 226);
      DrawPoint(343, 122, ABitmap.Canvas);
      line(343, 122, 391, 135);
      DrawPoint(364, 158, ABitmap.Canvas);
      line(364, 158, 401, 226);
    end;


    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeB.R) then
    begin
      ClearRect(399, 488, 488, 546);
      line(399, 529, 488, 529);
    end;


    //Обрыв фазы нагрузки BC
    if FMainSchema.SchemaTriang.NodeB.IsBadRInf then
    begin
      ClearRect(427, 488, 468, 546);
      DrawPoint(468, 529, ABitmap.Canvas);
      line(468, 529, 447, 503);
      DrawPoint(427, 529, ABitmap.Canvas);
      //line(248, 127, 234, 172);
    end;




    // L
    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeB.L) then
    begin
      ClearRect(290, 488, 378, 548);
      line(257, 529, 399, 529);
    end;
    {else
      line(290, 488, 378, 548, True);}

    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeA.L) then
      ClearRectLine(401, 226, 491, 388);

    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeC.L) then
    begin
      ClearRectLine(234, 172, 190, 305);
      ClearRect(238, 243, 282, 262);
    end;



    {else
      line(234, 172, 190, 305, True);}

    // C
    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeB.C) then
    begin
      ClearRect(152, 478, 290, 548);
      line(152, 529, 290, 529);
    end;

    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeA.C) then
    begin
      ClearRectLine(491, 388, 542, 481);
      ClearRect(528, 391, 575, 411);
    end;

    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeC.C) then
    begin
      ClearRectLine(190, 305, 152, 420);
      ClearRect(191, 346, 229, 366);
    end;


     //Обрыв линейного провода А
    if FMainSchema.SchemaTriang.NodeA.IsBadLin then
    begin
       ClearRect(144,9, 175,32);
       DrawPoint(144,21, ABitmap.Canvas);
       line(144, 21, 175, 8);
       DrawPoint(175, 21, ABitmap.Canvas);
    end;

    //Обрыв линейного провода B
    if FMainSchema.SchemaTriang.NodeB.IsBadLin then
    begin
       ClearRect(105, 596, 138, 624);
       DrawPoint(105, 605, ABitmap.Canvas);
       line(105, 605, 138, 592);
       DrawPoint(138, 605, ABitmap.Canvas);
    end;

    //Обрыв линейного провода C
    if FMainSchema.SchemaTriang.NodeC.IsBadLin then
    begin
       ClearRect(82, 520, 104, 542);
       DrawPoint(84, 529, ABitmap.Canvas);
       line(84, 529, 100, 515);
       DrawPoint(100, 529, ABitmap.Canvas);
    end;

  end;

  // КОМБИНАЦИЯ
  if FMainSchema.SchemaType = DoubleTypes then
  begin

    // R
    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeA.R) then
    begin
      ClearRectLine(313, 359, 348, 421);
      ClearRect(337, 373, 364, 386);
    end;

    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeB.R) then
    begin
      ClearRect(131, 419, 195, 464);
      line(124, 454, 195, 454);
    end;

    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeC.R) then
    begin
      ClearRectLine(126, 417, 162, 354);
      ClearRect(150, 391, 181, 406);
    end;

    // L
    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeA.L) then
    begin
      ClearRectLine(279, 300, 313, 359);
      ClearRect(309, 296, 361, 351);
    end;

    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeB.L) then
    begin
      ClearRect(215, 415, 276, 464);
      line(215, 454, 276, 454);
    end;

    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeC.L) then
    begin
      ClearRectLine(162, 354, 197, 293);
      ClearRect(118, 294, 169, 342);
    end;

    // C
    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeA.C) then
    begin
      ClearRectLine(245, 240, 279, 301);
      ClearRect(280, 250, 352, 289);
    end;

    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeB.C) then
    begin
      ClearRect(285, 421, 335, 470);
      line(285, 454, 335, 454);
    end;

    if not IsAssigned(FMainSchema.Schema[stTriangle].NodeC.C) then
    begin
      ClearRectLine(197, 293, 226, 243);
      ClearRect(146, 223, 200, 280);
    end;

    //
    if not IsAssigned(FMainSchema.Schema[stStar].NodeA.R) then
    begin
      ClearRect(383, 39, 444, 93);
      line(371, 76, 443, 76);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeA.L) then
    begin
      ClearRect(443, 39, 513, 93);
      line(443, 76, 513, 76);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeA.C) then
    begin
      ClearRect(513, 39, 570, 93);
      line(513, 76, 570, 76);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeB.R) then
    begin
      ClearRect(393, 99, 444, 150);
      line(393, 133, 443, 133);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeB.L) then
    begin
      ClearRect(443, 99, 513, 150);
      line(443, 133, 513, 133);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeB.C) then
    begin
      ClearRect(513, 99, 570, 150);
      line(513, 133, 570, 133);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeC.R) then
    begin
      ClearRect(383, 152, 444, 207);
      line(371, 190, 443, 190);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeC.L) then
    begin
      ClearRect(443, 152, 513, 207);
      line(443, 190, 513, 190);
    end;

    if not IsAssigned(FMainSchema.Schema[stStar].NodeC.C) then
    begin
      ClearRect(513, 152, 570, 207);
      line(513, 190, 570, 190);
    end;

  end;

end;

procedure TSolveOutput.PrintTask;
var
  vtbl: TRVTableItemInfo;
  vStr: String;
  vBitmap: TBitmap;
  i: Integer;

  procedure AddText(AText: String; IsCR: Boolean = False);
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

  procedure ProcessNode(ANode: TNodeInfo);
  begin
    if IsAssigned(ANode.R) then
      AddFormulaValue('R_' + ANode.Letter, RndArr.FormatDoubleStr(ANode.R,
        cR), 'Ом');
    if IsAssigned(FMainSchema.f) or IsAssigned(FMainSchema.W) then
    begin
      if IsAssigned(ANode.L) then
        AddFormulaValue('L_' + ANode.Letter, RndArr.FormatDoubleStr(ANode.L,
          cL), 'Гн');
      if IsAssigned(ANode.C) then
        AddFormulaValue('C_' + ANode.Letter, PrepareDouble(ANode.C, True), 'Ф');
    end
    else
    begin
      if IsAssigned(ANode.XL) then
        AddFormulaValue('X_L_' + ANode.Letter, RndArr.FormatDoubleStr(ANode.XL,
          cR), 'Ом');
      if IsAssigned(ANode.XC) then
        AddFormulaValue('X_C_' + ANode.Letter, PrepareDouble(ANode.XC,
          True), 'Ом');

    end;
    if Anode.IsBadRInf then
    begin
      AddFormulaValue('Z_'+ANode.Letter,'INF');
    end;
  end;

begin
  // Создаем табличку для вывода условия
  vtbl := TRVTableItemInfo.CreateEx(1, 2, FEditor.RVData);
  FEditor.InsertItem('table1', vtbl);
  // Граница не видна
  vtbl.VisibleBorders.SetAll(False);
  // Видна вертикальная черта
  vtbl.VRuleColor := clBlack;
  vtbl.VRuleWidth := 1;

  // Заполняем то, что дано.
  vtbl.Cells[0, 0].Clear;
  vtbl.Cells[0, 0].AddTextNLW('Дано:', 0, 0, 0, True);

  // Частота
  if IsAssigned(FMainSchema.f) then
    RVAddFormula('f=' + RndArr.FormatDoubleStr(FMainSchema.f, cW) +
      '&space(5)&c^(-1)', vtbl.Cells[0, 0]);
  if IsAssigned(FMainSchema.W) then
    RVAddFormula('w=' + RndArr.FormatDoubleStr(FMainSchema.W, cW) +
      '&space(5)&c^(-1)', vtbl.Cells[0, 0]);

  // Напряжение
  AddFormulaValue('U_' + FMainSchema.FULetter,
    RndArr.FormatDoubleStr(Decode(FMainSchema.FULetter, ['л', FMainSchema.Ul,
    'ф', FMainSchema.Uf]), cU), 'В');

  //Нулевой провод
  if FMainSchema.R0 <> 0 then
  begin
    if FMainSchema.R0 = Infinity then
      AddFormulaValue('R_0', 'INF')
    else
      AddFormulaValue('R_0', RndArr.FormatDoubleStr(FMainSchema.R0, cR), 'Ом');
  end;

  // Собственно схемы
  if stStar in FMainSchema.SchemaType then
  begin
    ProcessNode(FMainSchema.Schema[stStar].NodeA);
    ProcessNode(FMainSchema.Schema[stStar].NodeB);
    ProcessNode(FMainSchema.Schema[stStar].NodeC);
  end;

  if stTriangle in FMainSchema.SchemaType then
  begin
    ProcessNode(FMainSchema.Schema[stTriangle].NodeA);
    ProcessNode(FMainSchema.Schema[stTriangle].NodeB);
    ProcessNode(FMainSchema.Schema[stTriangle].NodeC);
  end;

  // AddFormulaValue('I', RndArr.FormatDoubleStr(FSchema.i), 'A');

  // Напряжения
  { for i := 0 to FSchema.ItemsCount - 1 do
    AddFormulaValue('U_' + IntToStr(i + 1),
    RndArr.FormatDoubleStr(FSchema.Elements[i].U), 'В'); }

  vtbl.Cells[0, 0].AddBreak;

  // Пишем, что надо найти

  AddText(lc('Task'), True);
  // Для соединения треугольником ничего не пишем
  if not(FMainSchema.SchemaType = [stTriangle]) then
    AddFormulaValue('U_' + Decode(FMainSchema.FULetter,
      ['л', 'ф', 'ф', 'л']), '');
  //Для соединения "Треугольник" не пишем "Найти ток в нулевом проводе"
  if FMainSchema.SchemaType = [stTriangle] then
    AddFormulaValue('I_ф', '')
  else
    AddFormulaValue('I_0,I_ф', '');
  AddFormulaValue('P,Q,S', '');
  AddFormulaValue('P_i,Q_i,S_i', '');

  // Рисуем диаграмму..
  PrintMainSchema(vBitmap);
  vtbl.Cells[0, 1].Clear;
  if Assigned(vBitmap) then
    vtbl.Cells[0, 1].AddPictureEx('diagram', vBitmap, 0, rvvaAbsMiddle);

  vtbl.ResizeRow(0, vtbl.Rows[0].GetBestHeight);
  vtbl.ResizeCol(1, 250, True);
  vtbl.ResizeCol(0, 200, True);
end;

procedure TSolveOutput.RunModule1(ASchemaType: TSchemaType);
var
  vSchemaInfo: TSchemaInfo;
  procedure ProcessNode(ANode: TNodeInfo);
  const
    cnstPrefix = 'Points(U_%s)=U_%s*.e^(j*.(%s^0))=';
  var
    vStr: String;
  begin
    FEditor.InsertTextW(#13#10);
    vStr := Format(cnstPrefix, [ANode.Letter, ANode.Letter,
      PrepareDouble(ANode.ej)]);
    vStr := vStr + TComplexFormula.CreatePolar(Math.DegToRad(ANode.ej),
      vSchemaInfo.U).PolarToNormFormula(cU);
    RVAddFormula(vStr, FEditor);
    FEditor.InsertTextW(' B');
  end;

begin
  vSchemaInfo := FMainSchema.Schema[ASchemaType];
  if not FMainSchema.IsSimpleMode then
    FEditor.InsertTextW(#13#10 + lc('Module1#1'));
  FEditor.InsertTextW(#13#10 + lcS('Module1#2', ASchemaType));
  case ASchemaType of
    stStar:
      RVAddFormula('U_a=U_b=U_c=U_Ф=' + RndArr.FormatDoubleStr(vSchemaInfo.U,
        cU), FEditor);
    stTriangle:
      RVAddFormula('U_ab=U_bc=U_ca=U_л=' + RndArr.FormatDoubleStr(vSchemaInfo.U,
        cU), FEditor);
  end;
  FEditor.InsertTextW(' В');
  if not FMainSchema.IsSimpleMode then
  begin
    FEditor.InsertTextW(#13#10 + lc('Module1#3'));
    ProcessNode(vSchemaInfo.NodeA);
    ProcessNode(vSchemaInfo.NodeB);
    ProcessNode(vSchemaInfo.NodeC);
  end;
end;

procedure TSolveOutput.RunModule2(ASchemaType: TSchemaType);
var
  vSchemaInfo: TSchemaInfo;
  vStr: string;
  procedure ProcessNode(ANode: TNodeInfo);
  var
    vStr: String;
    vPrefix: String;
    V1, V2: String;
  begin
    if ANode.IsBadR0 or ANode.IsBadRInf then
      Exit;
    FEditor.InsertTextW(#13#10);
    if FMainSchema.IsSimpleMode then
    begin
      V1 := ANode.GetZFormulaSimple;
      V2 := '';
    end
    else
      ANode.GetZFormula(V1, V2);
    RVAddFormula(V1, FEditor);
    if V2 <> '' then
    begin
      FEditor.InsertTextW(#13#10 + '     ');
      RVAddFormula(V2, FEditor);
    end;
    FEditor.InsertTextW(' Ом'#13#10);
  end;

begin
  vSchemaInfo := FMainSchema.Schema[ASchemaType];
  FEditor.InsertTextW(#13#10 + lc('Module2#1'+FMainSchema.FSimplePrefix));
  ProcessNode(vSchemaInfo.NodeA);
  ProcessNode(vSchemaInfo.NodeB);
  ProcessNode(vSchemaInfo.NodeC);
  if (FMainSchema.R0 > 0) and not FMainSchema.IsSimpleMode then
  begin
    if FMainSchema.R0 = Infinity then
      vStr := 'INF'
    else
      vStr := RndArr.FormatDoubleStr(FMainSchema.R0, cR);
    RVAddFormula('Z_0=R_0=' + vStr, FEditor);
    FEditor.InsertTextW(' Ом' + #13#10);
    FEditor.InsertTextW(#13#10);
  end;

  //Обрыв линейного провода в схеме "Треугольник"
  if vSchemaInfo.IsBadLin then
  begin
    RVAddFormulaAndText(Format(lc('BadLin#2'), [vSchemaInfo.GetZBadLinFormulaLetter]), FEditor);
    FEditor.InsertTextW(#13#10);
    RVAddFormula(vSchemaInfo.GetZBadLinFormula, FEditor);
    FEditor.InsertTextW(' Ом'#13#10);
  end;


end;

procedure TSolveOutput.RunModule3(ASchemaType: TSchemaType);
var
  vSchemaInfo: TSchemaInfo;
  procedure ProcessNode(ANode: TNodeInfo);
  var
    vPhi: Double;
    vPhiStr: String;
  begin
    if ANode.IsBadR0 or ANode.IsBadRInf then
      Exit;
    FEditor.InsertTextW(#13#10);
    RVAddFormula(ANode.GetPhiFormula, FEditor);
    vPhi := ANode.GetPhi;
    vPhiStr := 'phi_' + ANode.Letter;
    FEditor.InsertTextW(#13#10 + lc('Module3#2'));
    if RoundTo(vPhi, cnstRoundPref) = 0 then
    begin
      RVAddFormula(vPhiStr + '=0', FEditor);
      FEditor.InsertTextW(lc('Module3#2_0'));
    end
    else if RoundTo(vPhi, cnstRoundPref) = RoundTo(pi / 2, cnstRoundPref) then
    begin
      RVAddFormula(vPhiStr + '=90^0', FEditor);
      FEditor.InsertTextW(lc('Module3#2_90'));
    end
    else if RoundTo(vPhi, cnstRoundPref) = RoundTo(-pi / 2, cnstRoundPref) then
    begin
      RVAddFormula(vPhiStr + '=-90^0', FEditor);
      FEditor.InsertTextW(lc('Module3#2_-90'));
    end
    else if vPhi > 0 then
    begin
      RVAddFormula(vPhiStr + '>0', FEditor);
      FEditor.InsertTextW(lc('Module3#2>0'));
    end
    else if vPhi < 0 then
    begin
      RVAddFormula(vPhiStr + '<0', FEditor);
      FEditor.InsertTextW(lc('Module3#2<0'));
    end;
  end;

begin
  FEditor.InsertTextW(#13#10 + lc('Module3#1'));
  vSchemaInfo := FMainSchema.Schema[ASchemaType];
  ProcessNode(vSchemaInfo.NodeA);
  ProcessNode(vSchemaInfo.NodeB);
  ProcessNode(vSchemaInfo.NodeC);
end;

procedure TSolveOutput.RunModule4(ASchemaType: TSchemaType);
var
  vSchemaInfo: TSchemaInfo;
  vStr1, vStr2: String;
  procedure ProcessNode(ANode: TNodeInfo);
  begin
    if Anode.IsBadR0 or ANode.IsBadRInf then
      Exit;
    FEditor.InsertTextW(#13#10);
    if FMainSchema.IsSimpleMode then
      RVAddFormula(vSchemaInfo.GetIFazeFormulaSimple(ANode), FEditor)
    else
      RVAddFormula(vSchemaInfo.GetIFazeFormula(ANode), FEditor);
    FEditor.InsertTextW(' А');
  end;

  procedure ProcessNodeLinear(ANode: TNodeInfo);
  var
    vStr1, vStr2: String;
  begin
    vSchemaInfo.GetILinFormula(ANode, vStr1, vStr2);
    FEditor.InsertTextW(#13#10);
    RVAddFormula(vStr1, FEditor);
    if vStr2 <> '' then
    begin
      FEditor.InsertTextW('   ');
      RVAddFormula(vStr2, FEditor);
      FEditor.InsertTextW(' A');
    end;
  end;

begin
  FEditor.InsertTextW(#13#10 + lc('Module4#1'+FMainSchema.FSimplePrefix));
  vSchemaInfo := FMainSchema.Schema[ASchemaType];
  if not FMainSchema.IsSimpleMode then
     FEditor.InsertTextW(lcS('Module4#1', ASchemaType));
  // Для всех схем выводим рассчет фазных токов
  if not (vSchemaInfo.IsBadLin and (vSchemaInfo.BadLinNode = vSchemaInfo.NodeA))then
    ProcessNode(vSchemaInfo.NodeA);
  if not (vSchemaInfo.IsBadLin and (vSchemaInfo.BadLinNode = vSchemaInfo.NodeB))then
    ProcessNode(vSchemaInfo.NodeB);
  if not (vSchemaInfo.IsBadLin and (vSchemaInfo.BadLinNode = vSchemaInfo.NodeC))then
    ProcessNode(vSchemaInfo.NodeC);

  if vSchemaInfo.IsBadR0 then
  begin
    FEditor.InsertTextW(#13#10 + lc('BadR0#4_1'));
    FEditor.InsertTextW(#13#10);
    RVAddFormula(vSchemaInfo.GetIFazeFormula(vSchemaInfo.BadR0Node), FEditor);
    FEditor.InsertTextW(' А');
  end;


  //Для упрощенного режима больше ничего не надо считать
  if FMainSchema.IsSimpleMode then
   Exit;

  // Для схемы типа треугольник надо дополнительно включить рассчет линейных токов
  if ASchemaType = stTriangle then
  begin
    FEditor.InsertTextW(#13#10 + lc('Module4#2'));
    if not (vSchemaInfo.IsBadLin and (vSchemaInfo.BadLinNode = vSchemaInfo.NodeB))then
       ProcessNodeLinear(vSchemaInfo.NodeA);
    if not (vSchemaInfo.IsBadLin and (vSchemaInfo.BadLinNode = vSchemaInfo.NodeC))then
       ProcessNodeLinear(vSchemaInfo.NodeB);
    if not (vSchemaInfo.IsBadLin and (vSchemaInfo.BadLinNode = vSchemaInfo.NodeA))then
       ProcessNodeLinear(vSchemaInfo.NodeC);
  end;
  // Для схемы звезда добавляем рассчет тока в нулевом проводнике
  // Только если  в нем нет обрыва
  if (ASchemaType = stStar) and  (FMainSchema.R0 <> Infinity) then
  begin

    FEditor.InsertTextW(#13#10 + lc('Module4#3') + #13#10);
    vSchemaInfo.GetI0Formula(vStr1, vStr2);
    RVAddFormula(vStr1, FEditor);
    FEditor.InsertTextW(#13#10);
    RVAddFormula(vStr2, FEditor);
    FEditor.InsertTextW(' A');
  end;
end;

procedure TSolveOutput.RunModule5(ASchemaType: TSchemaType);
var
  vSchemaInfo: TSchemaInfo;
  vStr1, vStr2: string;
  procedure ProcessNode(ANode: TNodeInfo);
  var
    vStr1, vStr2: String;
    vS: TRectComplex;
  begin
    if ANode.IsBadR0 or ANode.IsBadRInf then
      Exit;
    vS := vSchemaInfo.GetS(ANode);
    FEditor.InsertTextW(#13#10 + 'Фаза ' + ANode.Letter + #13#10);
    FEditor.InsertTextW(lc('S'));
    vSchemaInfo.GetSFormula(ANode, vStr1, vStr2);
    RVAddFormula(vStr1, FEditor);
    FEditor.InsertTextW(#13#10);
    RVAddFormula(vStr2, FEditor);
    FEditor.InsertTextW(' В∙А');
    FEditor.InsertTextW(#13#10 + lc('Module5#2'));
    RVAddFormula('Tilde(Points(I))_' + vSchemaInfo.GetIndexedLetter
      (ANode), FEditor);
    FEditor.InsertTextW(lc('Module5#3'));
    RVAddFormula('Points(I)_' + vSchemaInfo.GetIndexedLetter(ANode), FEditor);
    FEditor.InsertTextW(#13#10 + lc('Module5#4'));
    RVAddFormula('P_' + ANode.Letter + '=' + RndArr.FormatDoubleStr(vS.Re,
      cP), FEditor);
    FEditor.InsertTextW(' Вт');
    FEditor.InsertTextW(#13#10 + lc('Module5#5'));
    RVAddFormula('Q_' + ANode.Letter + '=' + RndArr.FormatDoubleStr(vS.Im,
      cP), FEditor);
    FEditor.InsertTextW(' ВАР');
  end;

begin
  FEditor.InsertTextW(#13#10 + lc('Module5#1'));
  vSchemaInfo := FMainSchema.Schema[ASchemaType];
  ProcessNode(vSchemaInfo.NodeA);
  ProcessNode(vSchemaInfo.NodeB);
  ProcessNode(vSchemaInfo.NodeC);

  // Выводим общую мощность фаз
  FEditor.InsertTextW(#13#10 + lc('Module5#6') + #13#10);
  FEditor.InsertTextW(lc('S'));
  vSchemaInfo.GetSTotalFormula(vStr1);
  RVAddFormula(vStr1, FEditor);
  FEditor.InsertTextW(' В∙А'#13#10);
  RVAddFormula('P=' + RndArr.FormatDoubleStr(vSchemaInfo.GetSTotal.Re,
    cP), FEditor);
  FEditor.InsertTextW(' Вт' + #13#10);
  RVAddFormula('Q=' + RndArr.FormatDoubleStr(vSchemaInfo.GetSTotal.Im,
    cP), FEditor);
  FEditor.InsertTextW(' ВАР');

  FEditor.InsertTextW(#13#10 + lc('Module5#7'));
  FEditor.InsertTextW(#13#10 + lc('Module5#8') + #13#10);
  RVAddFormula(vSchemaInfo.GetPTotalFormula, FEditor);
  FEditor.InsertTextW(' Вт');
  FEditor.InsertTextW(#13#10 + lc('Module5#9') + #13#10);
  RVAddFormula(vSchemaInfo.GetQTotalFormula, FEditor);
  FEditor.InsertTextW(' ВАР');
  FEditor.InsertTextW(#13#10 + lc('Module5#10'));
end;

procedure TSolveOutput.RunModule5Simple(ASchemaType: TSchemaType);
var
  vSchemaInfo: TSchemaInfo;
  vStr1, vStr2: String;
  procedure ProcessNode(ANode: TNodeInfo);
  begin
    FEditor.InsertTextW(#13#10 + 'Фаза ' + ANode.Letter + #13#10);
    RVAddFormula(vSchemaInfo.GetPFormulaSimple(ANode) , FEditor);

    FEditor.InsertTextW(' Вт');
    FEditor.InsertTextW(#13#10);
    RVAddFormula(vSchemaInfo.GetQFormulaSimple(ANode) , FEditor);
    FEditor.InsertTextW(' ВАР');

    FEditor.InsertTextW(#13#10);
    RVAddFormula(vSchemaInfo.GetSFormulaSimple(ANode) , FEditor);
    FEditor.InsertTextW(' В∙А');


  end;


begin
  FEditor.InsertTextW(#13#10 + lc('Module5#1S'));
  vSchemaInfo := FMainSchema.Schema[ASchemaType];
  ProcessNode(vSchemaInfo.NodeA);
  ProcessNode(vSchemaInfo.NodeB);
  ProcessNode(vSchemaInfo.NodeC);


  FEditor.InsertTextW(#13#10 + lc('Module5#6'));
  //FEditor.InsertTextW(lc('S'));
 { RVAddFormula('P=' + RndArr.FormatDoubleStr(vSchemaInfo.GetSTotal.Re,
    cP), FEditor);
  FEditor.InsertTextW(' Вт' + #13#10);
  RVAddFormula('Q=' + RndArr.FormatDoubleStr(vSchemaInfo.GetSTotal.Im,
    cP), FEditor);
  FEditor.InsertTextW(' ВАР');}

 // FEditor.InsertTextW(#13#10 + lc('Module5#7'));
  FEditor.InsertTextW(#13#10 + lc('Module5#8') + #13#10);
  RVAddFormula(vSchemaInfo.GetPTotalFormulaSimple1, FEditor);
  FEditor.InsertTextW(' Вт');
  FEditor.InsertTextW(#13#10 + lc('Module5#9') + #13#10);
  RVAddFormula(vSchemaInfo.GetQTotalFormulaSimple1, FEditor);
  FEditor.InsertTextW(' ВАР');
  FEditor.InsertTextW(#13#10 + lc('Module5#99')+#13#10);
  RVAddFormula(vSchemaInfo.GetSTotalFormulaSimple, FEditor);
  FEditor.InsertTextW(' В∙А');
  //Рассчет мощностей по другим формулам
  FEditor.InsertTextW(#13#10 + lc('Module5#7S') + #13#10);
  RVAddFormula(vSchemaInfo.GetPTotalFormulaSimple2, FEditor);
  FEditor.InsertTextW(' Вт');
  FEditor.InsertTextW(#13#10);
  RVAddFormula(vSchemaInfo.GetQTotalFormulaSimple2, FEditor);
  FEditor.InsertTextW(' ВАР');
  FEditor.InsertTextW(#13#10 + lc('Module5#10'));



end;

procedure TSolveOutput.RunModule1BadLin;
var
  vFormula: String;
begin
  FEditor.InsertTextW(#13#10+lc('BadLin#3')+#13#10);
  if FMainSchema.SchemaTriang.NodeA.IsBadLin then
    vFormula := FMainSchema.SchemaTriang.GetUBadLinFormula(FMainSchema.SchemaTriang.NodeB);
  if FMainSchema.SchemaTriang.NodeB.IsBadLin then
    vFormula := FMainSchema.SchemaTriang.GetUBadLinFormula(FMainSchema.SchemaTriang.NodeC);
  if FMainSchema.SchemaTriang.NodeC.IsBadLin then
    vFormula := FMainSchema.SchemaTriang.GetUBadLinFormula(FMainSchema.SchemaTriang.NodeA);
  RVAddFormula(vFormula, FEditor);
  FEditor.InsertTextW(' B'#13#10);
end;

procedure TSolveOutput.RunModule1BadR0;
var
  vSchemaInfo: TSchemaInfo;
  vBadLetter: String;
  vRes: TComplexFormula;
begin
  FEditor.InsertTextW(#13#10+lc('BadR0#1_1')+#13#10);
  vSchemaInfo := FMainSchema.Schema[stStar];

  vBadLetter := vSchemaInfo.BadR0Node.Letter;

  RVAddFormula(Format('Points(U_%s)=0', [vBadLetter]), FEditor);
  FEditor.InsertTextW(#13#10);

  if vSchemaInfo.NodeA.IsBadR0 then
  begin
    vRes := TComplexFormula(vSchemaInfo.GetU(vSchemaInfo.NodeB));
    RVAddFormula('Points(U_b)=-Points(U_(ab))=U_л*.e^(j*.(30^0+180^0))='+
       vRes.GetPolarFormulaStr(cU)+'='+
       vRes.GetRectFormulaStr(cU), FEditor);
    FEditor.InsertTextW(' B'#13#10);
    vRes := TComplexFormula(vSchemaInfo.GetU(vSchemaInfo.NodeC));
    RVAddFormula('Points(U_c)=Points(U_(ca))=U_л*.e^(j*.(150^0))='+
       vRes.GetPolarFormulaStr(cU)+'='+
       vRes.GetRectFormulaStr(cU), FEditor);
    FEditor.InsertTextW(' B'#13#10);
  end;

  if vSchemaInfo.NodeB.IsBadR0 then
  begin
    vRes := TComplexFormula(vSchemaInfo.GetU(vSchemaInfo.NodeA));
    RVAddFormula('Points(U_a)=Points(U_(ab))=U_л*.e^(j*.30^0)='+
       vRes.GetPolarFormulaStr(cU)+'='+
       vRes.GetRectFormulaStr(cU), FEditor);
    FEditor.InsertTextW(' B'#13#10);
    vRes := TComplexFormula(vSchemaInfo.GetU(vSchemaInfo.NodeC));
    RVAddFormula('Points(U_c)=Points(U_(cb))=-Points(U_(bc))=U_л*.e^(j*.90^0)='+
       vRes.GetPolarFormulaStr(cU)+'='+
       vRes.GetRectFormulaStr(cU), FEditor);
    FEditor.InsertTextW(' B'#13#10);
  end;

  if vSchemaInfo.NodeC.IsBadR0 then
  begin
    vRes := TComplexFormula(vSchemaInfo.GetU(vSchemaInfo.NodeA));
    RVAddFormula('Points(U_a)=Points(U_(ac))=-Points(U_(ca))=U_л*.e^(j*.(150^0+180^0))='+
       vRes.GetPolarFormulaStr(cU)+'='+
       vRes.GetRectFormulaStr(cU), FEditor);
    FEditor.InsertTextW(' B'#13#10);
    vRes := TComplexFormula(vSchemaInfo.GetU(vSchemaInfo.NodeB));
    RVAddFormula('Points(U_b)=Points(U_(bc))=U_л*.e^(j*.(-90^0))='+
       vRes.GetPolarFormulaStr(cU)+'='+
       vRes.GetRectFormulaStr(cU), FEditor);
    FEditor.InsertTextW(' B'#13#10);
  end;

end;

procedure TSolveOutput.RunModuleU0(ASchemaType: TSchemaType);
var
  vFormula: TFormula;
begin
  if FMainSchema.R0 = 0 then
    Exit;
  FEditor.InsertTextW(#13#10 + lc('U0#1') + #13#10);
  RVAddFormula(FMainSchema.Schema[ASchemaType].GetU0Formula, FEditor);
  FEditor.InsertTextW(' B');
  FEditor.InsertTextW(#13#10 + lc('U0#2') + #13#10);
  RVAddFormula(FMainSchema.Schema[ASchemaType].GetUR0Formula(FMainSchema.Schema[ASchemaType].NodeA), FEditor);
  FEditor.InsertTextW(' B'#13#10);
  RVAddFormula(FMainSchema.Schema[ASchemaType].GetUR0Formula(FMainSchema.Schema[ASchemaType].NodeB), FEditor);
  FEditor.InsertTextW(' B'#13#10);
  RVAddFormula(FMainSchema.Schema[ASchemaType].GetUR0Formula(FMainSchema.Schema[ASchemaType].NodeC), FEditor);
  FEditor.InsertTextW(' B'#13#10);
end;

procedure TSolveOutput.RunModuleY(ASchemaType: TSchemaType);
  procedure ProcessNode(ANodeInfo: TNodeInfo);
  begin
    if ANodeInfo.IsBadR0 or ANodeInfo.IsBadRInf then
      Exit;
    RVAddFormula(ANodeInfo.GetYFormula, FEditor);
    FEditor.InsertTextW(' См' + #13#10);
  end;

var
  vSchema: TSchemaInfo;
begin
  vSchema := FMainSchema.Schema[ASchemaType];

  if FMainSchema.R0 = 0 then
    Exit;

  FEditor.InsertTextW(#13#10 + lc('Y#1') + #13#10);
  ProcessNode(vSchema.NodeA);
  ProcessNode(vSchema.NodeB);
  ProcessNode(vSchema.NodeC);
  RVAddFormula(FMainSchema.GetY0Formula, FEditor);
  FEditor.InsertTextW('См');
end;

procedure TSolveOutput.RunSolve;

begin
  FEditor.Clear;
  PrintTask;
  PrepareW;
  PrintAvariaPreambule;
  if FMainSchema.SchemaType = DoubleTypes then
  begin
    FEditor.InsertTextW(#13#10);
    FEditor.ApplyTextStyle(7);
    FEditor.InsertTextW(lcS('Start', stStar));
    FEditor.ApplyTextStyle(0);
  end;

  if stStar in FMainSchema.FSchemaType then
    RunSolvePart(stStar);

  if FMainSchema.SchemaType = DoubleTypes then
  begin
    FEditor.InsertTextW(#13#10);
    FEditor.ApplyTextStyle(7);
    FEditor.InsertTextW(lcS('Start', stTriangle));
    FEditor.ApplyTextStyle(0);
  end;

  if stTriangle in FMainSchema.FSchemaType then
    RunSolvePart(stTriangle);

 { if (stStar in FMainSchema.FSchemaType) and
      FMainSchema.Schema[stStar].IsBadR0 then
    Exit;}

  PrintDiagram;
  FEditor.InsertTextW(#13#10 + lc('Diagram#1') + #13#10);
  FEditor.InsertTextW(#13#10);
  FEditor.InsertTextW('Масштаб'#13#10);

  SplitScaleAndDiagram;
  FEditor.InsertPicture('diagram', FBitmapDiagram, rvvaMiddle);

  FEditor.ScrollTo(0);

end;

procedure TSolveOutput.RunSolvePart(ASchemaType: TSchemaType);
begin
  PrepareX(ASchemaType);
  CalcUf(ASchemaType);
  RunModule2(ASchemaType);
  RunModuleY(ASchemaType);
  if FMainSchema.Schema[ASchemaType].IsBadR0 then
    RunModule1BadR0
  else if FMainSchema.Schema[ASchemaType].IsBadLin then
    RunModule1BadLin
  else
    RunModule1(ASchemaType);

  if not FMainSchema.Schema[ASchemaType].IsBadR0 then
    RunModuleU0(ASchemaType);
  RunModule3(ASchemaType);
  RunModule4(ASchemaType);
  if FMainSchema.IsSimpleMode then
   RunModule5Simple(ASchemaType)
  else
   RunModule5(ASchemaType);
end;

procedure TSolveOutput.SplitScaleAndDiagram;
begin
  FBitmapDiagram.Height := BitmapScale.Height + BitmapMain.Height;
  FBitmapDiagram.Width := BitmapMain.Width;
  FBitmapDiagram.Canvas.CopyRect(
     TRect.Create(0,0,BitmapScale.Width,BitmapScale.Height),
     BitmapScale.Canvas,
     TRect.Create(0,0,BitmapScale.Width,BitmapScale.Height));
  FBitmapDiagram.Canvas.CopyRect(
     TRect.Create(0,BitmapScale.Height, BitmapMain.Width, BitmapMain.Height+BitmapScale.Height),
     BitmapMain.Canvas,
     TRect.Create(0,0,BitmapMain.Width,BitmapMain.Height));
end;

{ TNodeInfo }

class operator TNodeInfo.Equal(V1, V2: TNodeInfo): Boolean;
begin
  Result := (V1.Letter = V2.Letter) and (V1.f = V2.f) and (V1.W = V2.W) and
    (V1.ej = V2.ej) and (V1.L = V2.L) and (V1.C = V2.C);
end;

function TNodeInfo.GetPhi: Double;
begin
  if GetR = 0 then
  begin
    if GetX = 0  then
      Result := 0
    else
      Result := IfThen(GetX > 0, pi / 2, -pi / 2);
  end
  else
    Result := ArcTan(GetX / GetR);
end;

function TNodeInfo.GetPhiFormula: String;
const
  cnstFmt = 'arctg(X_%s/R_%s)';
var
  vFormula: TFormula;
begin
  Result := 'phi_' + Letter + '=';
  vFormula := TFormula.Create;
  try
    vFormula.FormulaStr := Format(cnstFmt, [Letter, Letter]);
    vFormula.AddReplaceTerm('X_' + Letter, GetX);
    vFormula.AddReplaceTerm('R_' + Letter, GetR);
    Result := Result + vFormula.FormulaStr + '=' + vFormula.GetFormulaValue +
      '=' + RndArr.FormatDoubleStr(Math.RadToDeg(GetPhi), cPhi) + '^0';
  finally
    vFormula.Free;
  end;
end;

function TNodeInfo.GetR: Double;
begin
  Result := IfThen(IsAssigned(R), R, 0);
end;

function TNodeInfo.GetX: Double;
begin
  Result := 0;
  if IsBadR0 then
    Result := 0
  else if IsBadRInf then
    Result := Infinity
  else
  begin
    if IsAssigned(XL) then
      Result := Result + XL;
    if IsAssigned(XC) then
      Result := Result - XC;
  end;
end;

function TNodeInfo.GetY: TRectComplex;
begin
  //Если сопротивление фазы 0, ее проводимость бексонечность
  if IsBadR0 then
    Result := Infinity
  //Если сопротивление фазы бесконечность, ее проводимость 0
  else if IsBadRInf then
    Result := 0
  //Иначе считаем по формуле
  else
    Result := 1 / GetZ;
end;

function TNodeInfo.GetYFormula: String;
var
  vZ: TComplexFormula;
  vY: TComplexFormula;
begin
  vZ := GetZ;
  vY := GetY;
  Result := 'Y_' + Letter + '=1/Bline(Z_' + Letter + ')=1/(' + vZ.GetPolarFormulaStr
    (cR) + ')=' + vY.GetPolarFormulaStr(cR) + '=' + vY.GetRectFormulaStr(cR);
end;

function TNodeInfo.GetZ: TPolarComplex;
begin
  Result.Radius := sqrt(Sqr(GetR) + Sqr(GetX));
  Result.Angle := GetPhi;
end;

procedure TNodeInfo.GetZFormula(var APart1, APart2: string);
var
  vStr, vStrR: String;
  vRStr: String;
  vFormula: TFormula;
begin
  APart1 := 'Bline(Z)_' + Letter + '=';
  vFormula := TFormula.Create;
  try
    vStr := '';
    if IsAssigned(XL) then
      vStr := 'X_L_' + Letter;
    if IsAssigned(XC) then
      vStr := '(' + vStr + '-X_C_' + Letter + ')';
    if vStr <> '' then
      vStr := 'j*.' + vStr;

    vStrR := IfThen(IsAssigned(R), 'R_' + Letter);
    vStr := SplitAtoms(vStrR, vStr, '+');

    vFormula.FormulaStr := vStr;
    vFormula.AddReplaceTerm('R_' + Letter, GetR);
    vFormula.AddReplaceTerm('X_L_' + Letter, XL);
    vFormula.AddReplaceTerm('X_C_' + Letter, XC);
    APart1 := APart1 + vStr;
    if IsAssigned(XL) and IsAssigned(XC) then
      APart1 := APart1 + '=' + vFormula.GetFormulaValue;
    APart1 := APart1 + '=Empty';
    APart2 := 'Empty=' + TComplexFormula.CreateRect(GetR, GetX)
      .RectToPolarFormula(cR);
  finally
    vFormula.Free;
  end;

end;

function TNodeInfo.GetZFormulaSimple: String;
var
  vIsAssignedR: Boolean;
  vIsAssignedLC: Boolean;
  vStrR: String;
  vStrL: string;
  vStrC: String;
  vStrLC: String;
  vFormula: TFormula;
begin
  Result := 'Z_'+Letter + '=';
  vStrR := StrPower(IfThen(IsAssigned(R), 'R_'+Letter), 2);
  vStrC := IfThen(IsAssigned(C), 'X_C_'+Letter);
  vStrL := IfThen(IsAssigned(L), 'X_L_'+Letter);
  vStrLC := StrPower(SplitAtoms(vStrL, vStrC, '-'), 2);

  vFormula  := TFormula.create;
  try
    vFormula.FormulaStr :=  'sqrt('+SplitAtoms(vStrR, vStrLC, '+') + ')';
    vFormula.AddReplaceTerm('R_'+Letter, GetR);
    vFormula.AddReplaceTerm('X_L_' + Letter, XL);
    vFormula.AddReplaceTerm('X_C_' + Letter, XC);
    Result := Result + vFormula.FormulaStr + '=' +vFormula.GetFormulaValue + '=' +
        RndArr.FormatDoubleStr(GetZSimple, cR);
  finally
    vFormula.Free;
  end;
end;

function TNodeInfo.GetZSimple: Double;
begin
  Result := RndArr.FormatDouble(sqrt(Sqr(GetR) + Sqr(GetX)), cR);
end;

procedure TNodeInfo.SetX(L, C, f, W: Double);
begin

  if C = 0 then
    C := cnstNotSetValue;

  if C <> cnstNotSetValue then
    C := Abs(C);

  Self.f := f;
  Self.W := W;
  Self.L := L;
  Self.C := C;
  Self.FXl := cnstNotSetValue;
  Self.FXc := cnstNotSetValue;

  if IsAssigned(f) then
    Self.W := 2 * pi * f;
  if IsAssigned(L) then
  begin
    if IsAssigned(Self.W) then
      FXl := Self.W * L
    else
      FXl := L;
  end;

  if IsAssigned(C) then
  begin
    if IsAssigned(Self.W) then
      FXc := 1 / Self.W / C
    else
      FXc := C;
  end;

end;

function TNodeInfo.XCFormula: String;
var
  tmp: String;
begin
  Result := '';
  if IsAssigned(XC) and IsAssigned(W) then
  begin
    tmp := 'C_' + Letter;
    Result := 'X_' + tmp + '=1/(omega*.' + tmp + ')=1/(' +
      RndArr.FormatDoubleStr(W, cW) + '*.' + PrepareDouble(C, True) + ')=' +
      RndArr.FormatDoubleStr(XC, cR);
  end;
end;

function TNodeInfo.XLFormula: String;
var
  tmp: String;
begin
  Result := '';
  if IsAssigned(XL) and IsAssigned(W) then
  begin
    tmp := 'L_' + Letter;
    Result := 'X_' + tmp + '=omega*.' + tmp + '=' + RndArr.FormatDoubleStr(W,
      cW) + '*.' + RndArr.FormatDoubleStr(L, cL) + '=' +
      RndArr.FormatDoubleStr(XL, cR);
  end;
end;

end.
