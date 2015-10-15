unit uCalc;

interface
uses dataMain, RVEdit, Graphics, RegularExpressions, RVTable, ParseExpr, System.Generics.Collections;

type
  TSolver = class
  private
  const
    cnstStep = 0.1;
  private
    Fu: Double;
    Fku2: Double;
    FKDelta: Double;
    Fs: Double;
    FM1: Double;
    FM1N: Double;
    FMParse: TExpressionParser;
    FN2Parse: TExpressionParser;
    FStage: Integer;
    FTaskTable: TRVTableItemInfo;
    FRichView: TRichViewEdit;
    fDmMain: TdmMain;


    FTblM: TDictionary<double, double>;
    FTblM1: TDictionary<double, double>;
    function M(S: Double; AIsM1: Boolean): Double;
    function  N2(S:double): Double;
    procedure PrintTask;
    procedure ParseFormulaAndText(AStr: String; AIsUseNumerator: Boolean = True);
    function Evaluator(const Match: TMatch): string;
    procedure OnCalcCallBack(AStrUkr, AStrRus: String);
    //Печатает таблицу значений, в которую заносит M(s) или M'(s) в зависимости от флага
    procedure PrintTable(AIsM1: Boolean);
    //Рассчет M'
    procedure PrintM1Calc;
    procedure PrintCloss;
    //Строит график зависимости момента от S
    procedure DrawGraphM;
    //Строкит график зависимости s, n от M
    //AIsDrawM1 - надо ли строить еще и график s, n от M'
    procedure DrawGraphS(AIsDrawM1: Boolean);
    function IsNeedDrawMPusk: Boolean;
  public
    constructor Create(ARichView: TRichViewEdit; AdmMain: TdmMain);
    destructor Destroy; override;
    procedure RunSolve;
  end;

implementation
uses  uFormulaUtils, SysUtils, uRounding, uLocalizeShared, Math, Types, uGraphicUtils,
      ArrowUnit, RVStyle;

{ TSolver }

constructor TSolver.Create(ARichView: TRichViewEdit; AdmMain: TdmMain);
begin
  FTblM := TDictionary<double, double>.Create;
  FTblM1 := TDictionary<double, double>.Create;
  FRichView := ARichView;
  fDmMain := AdmMain;
  FMParse := TExpressionParser.Create;
  FMParse.DefineVariable('s', @Fs);
  FN2Parse := TExpressionParser.Create;
  FN2Parse.DefineVariable('s', @Fs);
end;

destructor TSolver.Destroy;
begin
  FreeAndNil(FMParse);
  FreeAndNil(FN2Parse);
  inherited;
end;

{procedure TSolver.DrawGraphM;
var
  i: TPair<double, double>;
  vLabel: String;
  sn, skr: Double;
begin
  FSeriesM.Clear;
  sn := dmMain.GetItemValue('sn');
  skr := dmMain.GetItemValue('skr');
  for i in FTblM do
  begin
    if SameValue(i.Key, sn) then


    FSeriesM.AddNull(i.Key, i.Value, RndArr.FormatDoubleStr(i.Key))

  end;
  FChartM.CopyToClipboardBitmap;
  FRichView.PasteBitmap(false);
end; }

procedure TSolver.DrawGraphM;
const
  cnstWidth = 500;
  cnstHeight = 500;
  cnstMargins = 50;
  cnstMax = 1.1;
var
  vBitmap: TBitmap;
  vMaxy: Double;
  sn, skr: Double;

  i: TPair<double, double>;
  k: Double;
  //Преобразовывает обычные координаты в реальные координаты для битмапа
  function Px(x: Double): Integer;
  begin
    Result := cnstMargins + Trunc(x/cnstMax*cnstWidth);
  end;

  function Py(y: Double): Integer;
  begin
    Result := cnstMargins + cnstHeight - Trunc(y/vMaxy*cnstHeight);
  end;

begin
  vBitmap := TBitmap.Create;
  vBitmap.Width := cnstWidth + 2*cnstMargins;
  vBitmap.Height := cnstHeight + 2*cnstMargins;

  DrawHorzArrow(cnstMargins, cnstMargins+cnstHeight, cnstWidth, False, vBitmap.Canvas, clBlack, 2);
  DrawVertArrow(cnstMargins, cnstMargins+cnstHeight, -cnstHeight, False, vBitmap.Canvas, clBlack, 2);

  vMaxy := dmMain.GetItemValue('Mmax')*1.1;

  sn := dmMain.GetItemValue('sn');
  skr := dmMain.GetItemValue('skr');
  //Рисуем горизонтальные засечки
  for i in FTblM do
  begin
    vBitmap.Canvas.MoveTo(Px(i.Key), Py(0)-5);
    vBitmap.Canvas.LineTo(Px(i.Key), Py(0)+5);
    if SameValue(i.Key, sn) then
      DrawIndexedText('s', 'н', Px(i.Key), Py(0)+15, vBitmap.Canvas, True)
    else if SameValue(i.Key, skr) then
      DrawIndexedText('s', 'кр', Px(i.Key), Py(0)+15, vBitmap.Canvas, True)
    else if not SameValue(i.Key, 0) then
      DrawIndexedText(RndArr.FormatDoubleStr(i.Key), '', Px(i.Key), Py(0)+15, vBitmap.Canvas, True);
  end;

  //Рисуем непосредственно график
  vBitmap.Canvas.Pen.Width := 2;
  vBitmap.Canvas.MoveTo(Px(0), Py(0));

  k := 0;
  while k <= 1 do
  begin
    vBitmap.Canvas.LineTo(Px(k), Py(M(k, False)) );
    k := k+ 0.01;
  end;

  DrawIndexedText('S', '', Px(1.1)-10, Py(0)+15,  vBitmap.Canvas);
  DrawIndexedText('M,', '', Px(0)-30, Py(vMaxy)-15,  vBitmap.Canvas);
  DrawIndexedText('Н•м', '', Px(0)-30, Py(vMaxy),  vBitmap.Canvas);

  k := dmMain.GetItemValue('Mn');

  //Рисуем штриховку и точки моментов  для графиков
  vBitmap.Canvas.Pen.Width := 1;
  vBitmap.Canvas.Pen.Style := psDash;


  vBitmap.Canvas.MoveTo(Px(0), Py(k));
  vBitmap.Canvas.LineTo(Px(sn),Py(k));
  vBitmap.Canvas.LineTo(Px(sn),Py(0));
  DrawPoint(Px(sn), Py(k), vBitmap.Canvas);
  DrawIndexedText('M', 'н', Px(0)-50, Py(k), vBitmap.Canvas);


  k := dmMain.GetItemValue('Mmax');
  vBitmap.Canvas.MoveTo(Px(0), Py(k));
  vBitmap.Canvas.LineTo(Px(skr),Py(k));
  vBitmap.Canvas.LineTo(Px(skr),Py(0));
  DrawPoint(Px(skr), Py(k), vBitmap.Canvas);
  DrawIndexedText('M', 'макс', Px(0)-50, Py(k), vBitmap.Canvas);

  //Пусковой момент считаем только если он одинаково считается по формуле клосса и через кратность
  if IsNeedDrawMPusk then
  begin
    k := M(1, False);
    vBitmap.Canvas.MoveTo(Px(0), Py(k));
    vBitmap.Canvas.LineTo(Px(1),Py(k));
    vBitmap.Canvas.LineTo(Px(1),Py(0));
    DrawPoint(Px(1), Py(k), vBitmap.Canvas);
    DrawIndexedText('M', 'пуск', Px(0)-50, Py(k), vBitmap.Canvas);
  end;

  //Рисуем области устойчивой и неустойчивой работы внизу
  DrawHorzArrow(Px(0), Py(0)+45, Px(skr)-cnstMargins, False, vBitmap.Canvas, clBlack, 1);
  DrawHorzArrow(Px(skr), Py(0)+45, -Px(skr)+cnstMargins, False, vBitmap.Canvas, clBlack, 1);

  DrawHorzArrow(Px(skr), Py(0)+45, Px(1-skr)-cnstMargins, False, vBitmap.Canvas, clBlack, 1);
  DrawHorzArrow(Px(1), Py(0)+45, -Px(1-skr)+cnstMargins, False, vBitmap.Canvas, clBlack, 1);

  DrawIndexedText(lc('Gr1'), '', Px(skr/2), Py(0)+35, vBitmap.Canvas, True);
  DrawIndexedText(lc('Gr2'), '', Px(skr + (1-skr)/2) , Py(0)+35, vBitmap.Canvas, True);

  FRichView.InsertPicture('picture_M', vBitmap, rvvaMiddle);
end;

procedure TSolver.DrawGraphS(AIsDrawM1: Boolean);
const
  cnstWidth = 500;
  cnstHeight = 500;
  cnstMargins = 60;
  cnstMax = 1.1;

  cnstMargN = 20;
  cnstMargS = 50;
  cnstMargY = 15;
var
  vBitmap: TBitmap;
  vMaxx: Double;
  sn, skr: Double;

  i: TPair<double, double>;
  k: Double;

  vPrefix: String;

  //Преобразовывает обычные координаты в реальные координаты для битмапа
  function Px(x: Double): Integer;
  begin
    Result := cnstMargins + Trunc(x/vMaxx*cnstWidth);
  end;

  function Py(y: Double): Integer;
  begin
    Result := cnstMargins + cnstHeight - Trunc((1-y)/cnstMax*cnstHeight);
  end;
begin
  if AIsDrawM1 then
    vPrefix := '_M1'
  else
    vPrefix := '';

  FRichView.InsertTextW(#13#10);
  FRichView.InsertTextW(#13#10);

  if AIsDrawM1 then
  begin
    ParseFormulaAndText(lc('Gr3'), False);
    FRichView.InsertTextW(#13#10);
  end;

  vBitmap := TBitmap.Create;
  vBitmap.Width := cnstWidth + 2*cnstMargins;
  vBitmap.Height := cnstHeight + 2*cnstMargins;

  //рисуем координатные оси
  DrawHorzArrow(cnstMargins, cnstMargins+cnstHeight, cnstWidth, False, vBitmap.Canvas, clBlack, 2);
  DrawVertArrow(cnstMargins, cnstMargins+cnstHeight, -cnstHeight, False, vBitmap.Canvas, clBlack, 2);
  DrawVertArrow(cnstMargins div 2, cnstMargins+cnstHeight, -cnstHeight, False, vBitmap.Canvas, clBlack, 2);

  vMaxx := dmMain.GetItemValue('Mmax')*1.1;

  sn := dmMain.GetItemValue('sn');
  skr := dmMain.GetItemValue('skr');

  //Рисуем непосредственно график
  vBitmap.Canvas.Pen.Width := 2;
  vBitmap.Canvas.MoveTo(Px(0), Py(0));

  k := 0;
  while k <= 1 do
  begin
    vBitmap.Canvas.LineTo(Px(M(k, False)), Py(k));
    k := k+ 0.01;
  end;

  if AIsDrawM1 then
  begin
    k := 0;
    vBitmap.Canvas.MoveTo(Px(0), Py(0));
    while k <= 1 do
    begin
      vBitmap.Canvas.LineTo(Px(M(k, True)), Py(k));
      k := k+ 0.01;
    end;
  end;

  //Рисуем подписи осей
  DrawIndexedText('M, Н•м', '', Px(vMaxx)-10, Py(1)+cnstMargY,  vBitmap.Canvas);
  DrawIndexedText('n', '2', Px(0)-cnstMargN, Py(0)-25,  vBitmap.Canvas);
  DrawIndexedText('S', '', Px(0)-cnstMargS, Py(0)-25,  vBitmap.Canvas);

  DrawIndexedText('n', '1', Px(0)-cnstMargN, Py(0),  vBitmap.Canvas);
  DrawIndexedText('0', '', Px(0)-cnstMargS, Py(0),  vBitmap.Canvas);
  vBitmap.Canvas.MoveTo(Px(0)- (cnstMargins div 2), Py(0));
  vBitmap.Canvas.LineTo(Px(0)- (cnstMargins div 2) +3, Py(0));

  DrawIndexedText('n', 'н', Px(0)-cnstMargN, Py(sn),  vBitmap.Canvas);
  DrawIndexedText('s', 'н', Px(0)-cnstMargS, Py(sn),  vBitmap.Canvas);
  vBitmap.Canvas.MoveTo(Px(0)- (cnstMargins div 2), Py(sn));
  vBitmap.Canvas.LineTo(Px(0)- (cnstMargins div 2)  +3, Py(sn));


  DrawIndexedText('n', 'кр', Px(0)-cnstMargN-3, Py(skr),  vBitmap.Canvas);
  DrawIndexedText('s', 'кр', Px(0)-cnstMargS-5, Py(skr),  vBitmap.Canvas);
  vBitmap.Canvas.MoveTo(Px(0)- (cnstMargins div 2), Py(skr));
  vBitmap.Canvas.LineTo(Px(0)- (cnstMargins div 2)+3, Py(skr));


  DrawIndexedText('0', '', Px(0)-cnstMargN, Py(1),  vBitmap.Canvas);
  DrawIndexedText('1', '', Px(0)-cnstMargS, Py(1),  vBitmap.Canvas);
  vBitmap.Canvas.MoveTo(Px(0)- (cnstMargins div 2), Py(1));
  vBitmap.Canvas.LineTo(Px(0) - (cnstMargins div 2)+3, Py(1));

  //Рисуем штриховку и точки моментов  для графиков
  vBitmap.Canvas.Pen.Width := 1;
  vBitmap.Canvas.Pen.Style := psDash;

  DrawPoint(Px(0), Py(0), vBitmap.Canvas);

  k := dmMain.GetItemValue('Mn');
  vBitmap.Canvas.MoveTo(Px(0), Py(sn));
  vBitmap.Canvas.LineTo(Px(k),Py(sn));
  vBitmap.Canvas.LineTo(Px(k),Py(1));
  DrawPoint(Px(k), Py(sn), vBitmap.Canvas);
  DrawIndexedText('M', 'н', Px(k), Py(1)+cnstMargY,  vBitmap.Canvas, True);


  //Пусковой момент считаем только если он одинаково считается по формуле клосса и через кратность
  if IsNeedDrawMPusk then
  begin
    k := dmMain.GetItemValue('Mpusk');
    DrawPoint(Px(k), Py(1), vBitmap.Canvas);
    DrawIndexedText('M', 'пуск', Px(k), Py(1)+cnstMargY,  vBitmap.Canvas, True);
  end;

  k := dmMain.GetItemValue('Mmax');
  vBitmap.Canvas.MoveTo(Px(0), Py(skr));
  vBitmap.Canvas.LineTo(Px(k),Py(skr));
  vBitmap.Canvas.LineTo(Px(k),Py(1));
  DrawPoint(Px(k), Py(skr), vBitmap.Canvas);
  DrawIndexedText('M', 'макс', Px(k), Py(1)+cnstMargY,  vBitmap.Canvas, True);

  if AIsDrawM1 then
  begin
    if IsNeedDrawMPusk then
    begin
      k := M(1, True);
      DrawPoint(Px(k), Py(1), vBitmap.Canvas);
      DrawIndexedText('M''', 'пуск', Px(k), Py(1)+cnstMargY,  vBitmap.Canvas, True);
      k := M(skr, True);
      DrawPoint(Px(k), Py(skr), vBitmap.Canvas);
    end;
    vBitmap.Canvas.Pen.Style := psSolid;
    k := dmMain.GetItemValue('Mmax');
    vBitmap.Canvas.MoveTo(Px(k), Py(skr));
    vBitmap.Canvas.LineTo(Px(k)+10, Py(0)-10);
    vBitmap.Canvas.LineTo(Px(k)+30, Py(0)-10);
    DrawIndexedText('1', '', Px(k)+15, Py(0)-20, vBitmap.Canvas, True);

    k := M(skr, True);
    vBitmap.Canvas.MoveTo(Px(k), Py(skr));
    vBitmap.Canvas.LineTo(Px(k)+10, Py(0)-10);
    vBitmap.Canvas.LineTo(Px(k)+30, Py(0)-10);
    DrawIndexedText('2', '', Px(k)+15, Py(0)-20, vBitmap.Canvas, True);
  end;

  FRichView.InsertPicture('picture_S'+vPrefix, vBitmap, rvvaMiddle);
  if AIsDrawM1 then
  begin
    FRichView.InsertTextW(#13#10);
    ParseFormulaAndText(lc('Gr4'), False);
  end;
end;

function TSolver.Evaluator(const Match: TMatch): string;
var
  vItemName: String;
  vStr: String;
  vKoeff: Double;
  i: Integer;
  vValue: Double;
begin
  Assert(Match.Groups.Count >=2, 'Щось не так пішло в процесі заміни зразка '+Match.Value);
  vItemName := Match.Groups.Item[2].Value;

  vKoeff := 1;
  vStr := '';
  //Возможно, вначале есть коэффициент, на который следует умножать
  for i := 1 to Length(vItemName) do
  begin
    if not (vitemName[i] in ['0'..'9','.']) then
      break;
     vStr := vStr + vItemName[i];
  end;
  if vStr <> '' then
  begin
    vItemName := Copy(vItemName, Length(vStr)+1, Length(vItemName)-Length(vStr));
    vKoeff :=  StrToFloat(vStr);
  end;

  {Assert(dmMain.memItems.Locate('NAME', vItemName, []), 'Змінної '+vItemName+' не має в переліку змінних');
  Result := RndArr.FormatDoubleStr(fDmMain.memItemsRESULT_VALUE.Value*vKoeff);}

  //Некоторые переменные храняться не в датасете а в внутри класса
  if vItemName = 'U' then
    vValue := Fu
  else if vItemName = 'M''' then
    vValue := FM1
  else if vItemName = 'M''N' then
    vValue := FM1N
  else if vItemName = 'kDelta' then
    vValue := FKDelta
  else if vItemName = 'kU2' then
    vValue := Fku2
  else
    vValue := dmMain.GetItemValue(vItemName);

  Result := RndArr.FormatDoubleStr(vValue*vKoeff);
end;

function TSolver.IsNeedDrawMPusk: Boolean;
begin
  Result := SameValue(M(1, false), dmMain.GetItemValue('Mpusk'), 1);
end;

function TSolver.M(S: Double; AIsM1: Boolean): Double;
const
  cnstN = '2*%s/(s/%s+%s/s)';
var
  m: Double;
begin
  if S = 0 then
  begin
    Result := 0;
    Exit;
  end;
  if AIsM1 then
    m := FM1
  else
    m := dmMain.GetItemValue('Mmax');

  Fs := s;

  Result := FN2Parse.Evaluate(
     Format(cnstN, [RndArr.FormatDoubleStr(m),
                    RndArr.FormatDoubleStr(dmMain.GetItemValue('skr')),
                    RndArr.FormatDoubleStr(dmMain.GetItemValue('skr'))]));
end;

function TSolver.N2(S: Double): Double;
const
  cnstF = '%s*(1-s)';
begin
  Fs := S;
  Result := FMParse.Evaluate(Format(cnstF, [RndArr.FormatDoubleStr(dmMain.GetItemValue('n1'))]));
end;

procedure TSolver.OnCalcCallBack(AStrUkr, AStrRus: String);
begin
  case CurrentLang of
    lngUkr: ParseFormulaAndText(AStrUkr);
    lngRus: ParseFormulaAndText(AStrRus);
  end;
end;

procedure TSolver.ParseFormulaAndText(AStr: String; AIsUseNumerator: Boolean = True);
const
  stages_tbl = 3;
var
  vText: TArray<string>;
  vFormulas: TArray<String>;
  i: integer;
  vParaNo: Integer;


  procedure BindFormulas;
  var
    i: Integer;
  begin
    for i := Low(vFormulas) to High(vFormulas) do
      vFormulas[i] := TRegEx.Replace(vFormulas[i], '(\[)(.+?)(\])', Evaluator);
  end;


  procedure AddText(AText:  String);
  begin
    if FStage <= stages_tbl then
        FTaskTable.Cells[0,1].AddTextNL(AText, 0, -1, 0)
    else
      FRichView.InsertTextW(AText);
  end;

begin
  if AStr = '' then
    Exit;
  ParseText(AStr, vText, vFormulas);
  BindFormulas;

  Inc(FStage);
  if AIsUseNumerator then
  begin
    AddText(IntToStr(FStage)+') ');
  end;

  for i := Low(vText) to High(vText) do
  begin
    AddText(vText[i]);

   if i<=High(vFormulas) then
    begin
      if FStage <= stages_tbl then
        RVAddFormulaTex(vFormulas[i], FTaskTable.Cells[0,1])
      else
        RVAddFormulaTex(vFormulas[i], FRichView);
    end;
  end;
  //Отступы
  if AIsUseNumerator then
  begin
    AddText(#13#10);
    AddText(#13#10);
  end;
end;

procedure TSolver.PrintCloss;
begin
  ParseFormulaAndText(lc('Fs'), False);
  ParseFormulaAndText('Формулу Клосса: {tex}M=\frac{2M_{\cyr{maks}}}{\frac{S}{s_{\cyr{kr}}}+\frac{s_{\cyr{kr}}}{S}}=\frac{2 \cdot [Mmax]}{\frac{S}{[skr]}+\frac{[skr]}{S}} {\tex}',
                      False);
  FRichView.InsertTextW(#13#10);
  ParseFormulaAndText(lc('N2'), False);
  FRichView.InsertTextW(#13#10);
end;

procedure TSolver.PrintM1Calc;
var
  vMPusk: Double;
begin
  FRichView.InsertTextW(#13#10);
  Fu := dmMain.GetItemValue('Un')*dmMain.GetItemValue('kU');
  vmPusk := dmMain.GetItemValue('Mpusk');
  FKDelta := 1-dmMain.GetItemValue('kU');
  Fku2 := dmMain.GetItemValue('kU') * dmMain.GetItemValue('kU');
  FM1 := vMPusk*Fku2;
  FM1N := Fku2*dmMain.GetItemValue('Mn');
  ParseFormulaAndText(lc('M1_1'), False);
  ParseFormulaAndText('{tex}\frac{M''_{\cyr{pusk}}}{M_{\cyr{pusk}}}=\frac{(U''_{\cyr{n}})^2}{(U_{\cyr{n}})^2}=\frac{(k_U \cdot U_{\cyr{n}})^2}{(U_{\cyr{n}})^2}=(k_U)^2=[kU2]{\tex}', False);
  FRichView.InsertTextW(lc('M1_2'));
  FRichView.InsertTextW(#13#10);
  ParseFormulaAndText('{tex}M''_{\cyr{pusk}}=(k_U)^2\cdot M_{\cyr{pusk}}=[kU2]\cdot[Mpusk]=[M'']{\tex}Н•м. ', False);
  FRichView.InsertTextW(lc('M1_3'), False);
  if SameValue(Fm1, vMPusk) then
    ParseFormulaAndText(lc('M1_3='), False)
  else if Fm1 > vMPusk then
    ParseFormulaAndText(lc('M1_3>'), False)
  else
    ParseFormulaAndText(lc('M1_3<'), False);
  FRichView.InsertTextW(#13#10);
  FRichView.InsertTextW(lc('M1_4'));
  ParseFormulaAndText('{tex}M''_{\cyr{n}}=(k_U)^2\cdot M_{\cyr{n}}=[kU2]\cdot[Mn]=[M''N]{\tex} Н•м.', False);
  FRichView.InsertTextW(#13#10);
  FRichView.InsertTextW(lc('M1_5'));
  FRichView.InsertTextW(#13#10);
  ParseFormulaAndText('{tex}M''=(k_U)^2\cdot M=\frac{2\cdot (k_U)^2 \cdot M_{\cyr{maks}}}{\frac{S}{S_{\cyr{kr}}}+\frac{S_{\cyr{kr}}}{S}}=\frac{2\cdot[kU2]\cdot [Mmax]}{\frac{S}{[skr]}+\frac{[skr]}{S}}{\tex}',
    False);
  FRichView.InsertTextW(#13#10);
end;

procedure TSolver.PrintTable(AIsM1: Boolean);
var
  mPref: String;
  vTbl: TRVTableItemInfo;
  s, sn, skr: Double;
  i, j: Integer;
begin
  FTblM.Clear;
  if AIsM1 then
    mPref := '_M1'
  else
    mPref := '';
  ParseFormulaAndText(lc('tbl_h'+mPref), False);
  skr := dmMain.GetItemValue('skr');

  if dmMain.IsItemCalced('sn') then
    sn := dmMain.GetItemValue('sn')
  else
    sn := -1;

  vTbl := TRVTableItemInfo.CreateEx(1, 4, FRichView.RVData);
  vTbl.Options := vTbl.Options + [rvtoIgnoreContentWidth];

  vTbl.Cells[0,0].BestWidth := 80;
  vTbl.Cells[0,1].BestWidth := 150;
  vTbl.Cells[0,2].BestWidth := 150;
  vTbl.Cells[0,3].BestWidth := 150;

  vtbl.Cells[0,0].AddNL('№', 1, -1);
  vtbl.Cells[0,1].AddNL(lc('tbl_h1'), 1, -1);

  vtbl.BorderColor := clBlack;
  vtbl.BorderWidth := 1;
  vtbl.BorderStyle := rvtbColor;
  vtbl.BorderLightColor := clBlack;
  vtbl.VRuleColor := clBlack;
  vtbl.VRuleWidth := 1;
  vtbl.HRuleWidth := 1;
  vtbl.HRuleColor := clBlack;

  RVAddFormulaTex('n_2', vtbl.Cells[0,2]);
  vtbl.Cells[0,2].AddNL(lc('tbl_h2'), 1, -1);

  RVAddFormulaTex(lc('tbl_h3'+mPref), vtbl.Cells[0,3]);
  vtbl.Cells[0,3].AddNL(' Н•м', 1, -1);

  s := 0;
  i := 0;
  j := 0;
  while s<=1 do
  begin
    Inc(i);
    vtbl.InsertRows(i, 1, -1);
    vTbl.Cells[i, 0].AddNL(IntToStr(i), 0, -1);

    if SameValue(s, sn) then
      RVAddFormulaTex('s_{\cyr{n}}='+RndArr.FormatDoubleStr(sn), vTbl.Cells[i,1])
    else if SameValue(s, skr) then
      RVAddFormulaTex('s_{\cyr{kr}}=' + RndArr.FormatDoubleStr(skr), vTbl.Cells[i,1])
    else
      vtbl.Cells[i,1].AddNL(FloatToStr(s), 0, -1);

    vTbl.Cells[i,2].AddNL(RndArr.FormatDoubleStr(N2(s)), 0, -1);
    vTbl.Cells[i,3].AddNL(RndArr.FormatDoubleStr(M(s, AIsM1)), 0, -1);

    if AIsM1 then
      FTblM1.AddOrSetValue(s, M(s, AIsM1))
    else
      FTblM.AddOrSetValue(s, M(s, AIsM1));

    if (CompareValue(sn, s) = GreaterThanValue) and (CompareValue(sn, s+cnstStep) = LessThanValue) then
      s := sn
    else if (CompareValue(skr, s) = GreaterThanValue) and (CompareValue(skr, s+cnstStep) = LessThanValue) then
      s := skr
    else
    begin
      inc(j);
      s := cnstStep*j;
    end;
  end;

  FRichView.InsertItem('tbl'+mPref, vtbl);
end;

procedure TSolver.PrintTask;
var
  i: Integer;
const
  cnstFormulaPatt = '%s = %s \quad \cyr{%s}';

  procedure AddText(AText: String; IsCR: Boolean = false);
  var
    vParaNo: Integer;
  begin
    if IsCR then
      vParaNo := 0
    else
      vParaNo := -1;
    FTaskTable.Cells[0, 0].AddTextNL(AText, 0, vParaNo, 0);
  end;

begin
    // Создаем табличку для вывода условия
  FTaskTable := TRVTableItemInfo.CreateEx(1, 2, FRichView.RVData);

  FTaskTable.Options :=  FTaskTable.Options + [rvtoIgnoreContentWidth];
  FTaskTable.Cells[0,0].BestWidth := 170;
  FTaskTable.Cells[0,1].BestWidth := 450;

  FRichView.InsertItem('table1', FTaskTable);
  // Граница не видна
  FTaskTable.VisibleBorders.SetAll(false);
  // Видна вертикальная черта
  FTaskTable.VRuleColor := clBlack;
  FTaskTable.VRuleWidth := 1;


  // Заполняем то, что дано.
  FTaskTable.Cells[0, 0].Clear;
  FTaskTable.Cells[0, 0].AddTextNL('Дано:', 0, -1, 0);

  fDmMain.memItems.First;
  while not fDmMain.memItems.Eof do
  begin
    if fDmMain.memItemsVALUE_CORRECT.AsString <> '' then
    begin
      FTaskTable.Cells[0,0].AddTextNL(#13#10, 0, -1, 0);
      RVAddFormulaTex(Format(cnstFormulaPatt, [fDmMain.memItemsF_TEX.Value,
         RndArr.FormatDoubleStr(fDmMain.memItemsVALUE.Value),
         fDmMain.GetMeasureName(fDmMain.memItemsMEASURE_ID.Value)]), FTaskTable.Cells[0,0]);
    end;
    fDmMain.memItems.Next;
  end;

  FTaskTable.Cells[0, 0].AddBreak;
  AddText(lc('Task')+#13#10);

  fDmMain.memItems.First;
  i := 1;
  while not fDmMain.memItems.Eof do
  begin
    if fDmMain.memItemsVALUE.AsString = '' then
    begin
      RVAddFormulaTex(fDmMain.memItemsF_TEX.Value, FTaskTable.Cells[0,0]);
      if i mod 2 = 0 then
        FTaskTable.Cells[0,0].AddTextNL(#13#10, 0, -1, 0)
      else
        FTaskTable.Cells[0,0].AddNL(',', 0, -1);
      Inc(i);
    end;
    fDmMain.memItems.Next;
  end;

  //FTaskTable.ResizeCol(0, 600, True);
  //FTaskTable.ResizeCol(1, 620, True);
end;

procedure TSolver.RunSolve;
begin
  dmMain.memItems.DisableControls;
  try
    FRichView.Clear;
    FStage := 0;
    PrintTask;

    dmMain.ClearCalc;
    dmMain.Calc(OnCalcCallBack);

    if dmMain.IsItemCalced('Mmax') and
       dmMain.IsItemCalced('skr') and
       dmMain.IsItemCalced('n1') then
    begin
      PrintCloss;
      PrintTable(False);
      DrawGraphM;
      DrawGraphS(False);
      if dmMain.IsItemCalced('kU') and
         dmMain.IsItemCalced('Un') then
      begin
        PrintM1Calc;
        PrintTable(True);
        DrawGraphS(True);
      end;
    end;
    FTaskTable.ResizeRow(0, FTaskTable.Rows[0].GetBestHeight);
    FRichView.ScrollTo(0);
  finally
    dmMain.memItems.EnableControls;
  end;

end;

end.
