unit dataMain;

interface

uses
  System.SysUtils, System.Classes,  MemTableDataEh, Data.DB,
  DataDriverEh, MemTableEh, SQLiteTable3, Datasnap.DBClient, SQLite3Dataset,
  Vcl.ImgList, Vcl.Controls, System.Generics.Collections;

type


   TCalcCallbackProc = procedure(AStrUkr, AStrRus: String; AFontSize: Integer) of object;


  TdmMain = class(TDataModule)
    dbMain: TSQLiteDatabase;
    memItems: TMemTableEh;
    memItemsITEM_ID: TIntegerField;
    memItemsMEASURE_ID: TIntegerField;
    ldsItems: TSQLiteDataset;
    ldsItemsID: TIntegerField;
    ldsItemsNAME: TWideStringField;
    ldsItemsF_STR: TWideStringField;
    ldsItemsF_TEX: TWideStringField;
    ldsItemsDESC_RU: TWideStringField;
    ldsItemsDESC_UKR: TWideStringField;
    memItemsVALUE: TFloatField;
    memItemsITEM_IMG: TBlobField;
    dsItems: TDataSource;
    ldsMeasures: TSQLiteDataset;
    memItemsMEASURE_ID_LOOKUP: TStringField;
    ldsItemMeas: TSQLiteDataset;
    ldsItemMeasITEM_ID: TIntegerField;
    ldsItemMeasMEAS_ID: TIntegerField;
    ldsItemMeasLABEL_UKR: TWideStringField;
    memCurMeasList: TMemTableEh;
    dsCurMeasList: TDataSource;
    memCurMeasListID: TIntegerField;
    memCurMeasListLABEL_UKR: TStringField;
    memItemsHINT: TStringField;
    ldsFormulas: TSQLiteDataset;
    ldsFormulasFORMULA_ID: TIntegerField;
    ldsFormulasF_STR: TWideStringField;
    ldsFormulasF_TEX: TWideStringField;
    ldsFormulasITEM_ID: TIntegerField;
    ldsFormulasNAME_UKR: TWideStringField;
    ldsFormulasNAME_RUS: TWideStringField;
    ldsFormulasTEXT_UKR: TWideStringField;
    ldsFormulasTEXT_RUS: TWideStringField;
    ldsFormulaDetail: TSQLiteDataset;
    memItemsCALC_VALUE_CORRECT: TFloatField;
    memItemsVALUE_CORRECT: TFloatField;
    memItemsCALC_VALUE: TFloatField;
    ldsFormulaDetailFORMULA_ID: TIntegerField;
    ldsFormulaDetailITEM_ID: TIntegerField;
    ldsFormulaDetailF_STR: TWideStringField;
    ldsFormulaDetailNAME: TWideStringField;
    memItemsF_TEX: TStringField;
    ldsMeasuresID: TIntegerField;
    ldsMeasuresLABEL_UKR: TWideStringField;
    ldsMeasuresKOEFF: TFloatField;
    ldsMeasuresDESCRIPTION_UKR: TWideStringField;
    ldsMeasuresBASE_ID: TIntegerField;
    ldsMeasuresDESCRIPTION_RU: TWideStringField;
    ldsMeasuresLABEL_RU: TWideStringField;
    ldsMeasuresLABEL_UKR_TR: TWideStringField;
    ldsMeasuresLABEL_RU_TR: TWideStringField;
    memItemsNAME: TStringField;
    memItemsRESULT_VALUE: TFloatField;
    ilFormulas: TImageList;
    memItemsDESC_RU: TStringField;
    ldsFormulasFONT_SIZE: TWideStringField;
    procedure memItemsAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure memItemsCalcFields(DataSet: TDataSet);

  private
    FProcessedItems: TDictionary<integer, double>;
    procedure RefreshProcessedItems;
    procedure RefreshCurMeasList;
     //Среди формул ищет формулу по которой можно что-нибудь посчитать
    //И которая еще не посчитана
    //Возвращает Ид формулы
    function SearchFormulaForCalc(var AResult: Double;  var AItemId: Integer): Integer;
  public
    procedure ClearCalc;
    procedure ConnectIfNeeded;
    procedure RefreshItems;
    function Calc(ACallBack: TCalcCallbackProc = nil): Boolean;
    property ProcessedItems: TDictionary<integer, double> read FProcessedItems;
    function GetMeasureName(AMeasureID: Integer): String;
    function GetItemValue(AItemName: String): Double;
    function IsItemCalced(AItemName: String): Boolean;
    procedure ClearInputParams;
  end;

var
  dmMain: TdmMain;

implementation
uses Forms, uFormulaUtils, Vcl.Imaging.GIFImg, ParseExpr, ParseClass, uLocalizeShared, StrUtils;

const
  cnstDbName = 'formulas.db';
  //Все значения по формулам рассчитаны
  cnstAllFormulasCalc = -2;
  //Нет формулы которую бы можно было вычислить
  cnstCantCalc = -1;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TdmMain }

function TdmMain.Calc(ACallBack: TCalcCallbackProc = nil): Boolean;
var
  vResult: Double;
  vItemId: Integer;
  vRes: Integer;
  vBookMark: TBookmark;
begin
  vBookMark := memItems.GetBookmark;
  memItems.DisableControls;
  try
    repeat
      vRes := SearchFormulaForCalc(vResult, vItemId);
      Result := vRes = cnstAllFormulasCalc;
      if vRes > 0 then
      begin
        memItems.Locate('ITEM_ID', vItemId, []);
        memItems.Edit;
        memItemsCALC_VALUE_CORRECT.Value := vResult;
        memItems.Post;
        ldsFormulas.Locate('FORMULA_ID', vRes, []);
        if Assigned(ACallBack) then
          ACallBack(ldsFormulasTEXT_UKR.Value, ldsFormulasTEXT_RUS.Value, ldsFormulasFONT_SIZE.AsInteger);
      end
      else
        Exit;
    until false;
  finally
    memItems.GotoBookmark(vBookMark);
    memItems.EnableControls;
  end;
end;

procedure TdmMain.ClearCalc;
var
  vBookmark: TBookmark;
begin
  vBookmark := memItems.GetBookmark;
  memItems.DisableControls;
  try
    memItems.First;
    while not memItems.Eof do
    begin
      if memItemsCALC_VALUE.AsString <> '' then
      begin
        memItems.Edit;
        memItemsCALC_VALUE.Clear;
        memItemsCALC_VALUE_CORRECT.Clear;
        memItems.Post;
      end;
      memItems.Next;
    end;
  finally
    memItems.GotoBookmark(vBookmark);
    memItems.EnableControls;
  end;
  ldsFormulas.Close;
  ldsFormulas.Open;
  ldsFormulaDetail.Close;
  ldsFormulaDetail.Open;
end;

procedure TdmMain.ClearInputParams;
var
  vAfterPost: TDataSetNotifyEvent;
  vBookmark: TBookmark;
begin
  vAfterPost :=  memItems.AfterPost;
  memItems.AfterPost := nil;
  vBookmark := memItems.GetBookmark;
  memItems.DisableControls;
  memItems.BeforePost := nil;
  try
    memItems.First;
    while not memItems.Eof do
    begin
      memItems.Edit;
      memItemsVALUE.Clear;
      memItemsCALC_VALUE_CORRECT.Clear;
      memItems.Next;
    end;
  finally
    memItems.AfterPost := vAfterPost;
    memItems.GotoBookmark(vBookmark);
    memItems.EnableControls;
  end;
end;

procedure TdmMain.ConnectIfNeeded;
begin
  if not dbMain.Connected then
  begin
    dbMain.Filename := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+ cnstDbName;
    dbMain.Connected := True;
  end;
end;


procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  FProcessedItems := TDictionary<integer, double>.Create;
end;

procedure TdmMain.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FProcessedItems);
end;

function TdmMain.GetItemValue(AItemName: String): Double;
begin
  Assert(IsItemCalced(AItemName), 'Змінної '+AItemName+' не має в переліку змінних');
  Result := memItemsRESULT_VALUE.Value;
end;


function TdmMain.GetMeasureName(AMeasureID: Integer): String;
begin
  Result := '';
  if ldsMeasures.Locate('ID', AMeasureID, []) then
  begin
    case CurrentLang of
     lngUkr: Result := ldsMeasuresLABEL_UKR_TR.Value;
     lngRus: Result := ldsMeasuresLABEL_RU_TR.Value;
    end;
    Result := ReplaceStr(Result, '∙', '\cdot ')
  end;
end;

function TdmMain.IsItemCalced(AItemName: String): Boolean;
begin
  Result := memItems.Locate('NAME', AItemName, []) and
     (memItemsRESULT_VALUE.AsString <> '');
end;

procedure TdmMain.memItemsAfterScroll(DataSet: TDataSet);
begin
  RefreshCurMeasList;
end;

procedure TdmMain.memItemsCalcFields(DataSet: TDataSet);
begin
  if (memItemsVALUE.AsString <> '') and
      ldsMeasures.Locate('ID', memItemsMEASURE_ID.Value, []) then
    memItemsVALUE_CORRECT.Value := memItemsVALUE.Value * ldsMeasuresKOEFF.Value;

  if (memItemsCALC_VALUE_CORRECT.AsString <> '') and
     ldsMeasures.Locate('ID', memItemsMEASURE_ID.Value, []) then
    memItemsCALC_VALUE.Value := memItemsCALC_VALUE_CORRECT.Value / ldsMeasuresKOEFF.Value;

  if memItemsVALUE_CORRECT.AsString <> '' then
    memItemsRESULT_VALUE.Value := memItemsVALUE_CORRECT.Value;

  if memItemsCALC_VALUE_CORRECT.AsString <> '' then
    memItemsRESULT_VALUE.Value := memItemsCALC_VALUE_CORRECT.Value;
end;

procedure TdmMain.RefreshCurMeasList;
const
  cnstFilter = 'ITEM_ID = %d';
begin
  ConnectIfNeeded;
  memCurMeasList.Open;
  memCurMeasList.EmptyTable;
  ldsItemMeas.Filter := Format(cnstFilter, [memItemsITEM_ID.Value]);
  ldsItemMeas.Filtered := True;
  try
    ldsItemMeas.First;
    while not ldsItemMeas.Eof do
    begin
      memCurMeasList.Append;
      memCurMeasListID.Value := ldsItemMeasMEAS_ID.Value;
      memCurMeasListLABEL_UKR.Value := ldsItemMeasLABEL_UKR.Value;
      memCurMeasList.Post;
      ldsItemMeas.Next;
    end;
  finally
    ldsItemMeas.Filtered := False;
    ldsItemMeas.Filter := '';
  end;
end;

procedure TdmMain.RefreshItems;
var
  vImg: TGifImage;
  vStream: TMemoryStream;
begin
  ConnectIfNeeded;
  ldsMeasures.Open;
  ldsItems.Close;
  ldsItems.Open;
  ldsItems.First;
  ldsItemMeas.Close;
  ldsItemMeas.Open;
  ldsFormulas.Close;
  ldsFormulas.Open;
  ldsFormulaDetail.Close;
  ldsFormulaDetail.Open;
  memItems.Open;
  memItems.EmptyTable;
  vStream := TMemoryStream.Create;
  try
    while not ldsItems.Eof do
    begin
      vImg := GetTexFormulaGif(ldsItemsF_TEX.Value);
      memItems.Append;
      vStream.Clear;
      vImg.Bitmap.SaveToStream(vStream);
      memItemsITEM_ID.Value := ldsItemsID.Value;
      memItemsITEM_IMG.LoadFromStream(vStream);
      memItemsHINT.Value := ldsItemsDESC_UKR.Value;
      memItemsF_TEX.Value := ldsItemsF_TEX.Value;
      memItemsNAME.Value := ldsItemsNAME.Value;
      memItemsDESC_RU.Value := ldsItemsDESC_RU.Value;
      RefreshCurMeasList;
      if memCurMeasList.RecordCount >= 1 then
        memItemsMEASURE_ID.Value := memCurMeasListID.Value;
      memItems.Post;

      ldsItems.Next;
    end;
  finally
    FreeAndNil(vStream);
  end;
  memItems.First;
end;

procedure TdmMain.RefreshProcessedItems;
var
  vBookMark: TBookmark;
begin
  vBookMark := memItems.GetBookmark;
  memItems.DisableControls;
  try
    memItems.First;
    FProcessedItems.Clear;
    while not memItems.Eof do
    begin
      if memItemsVALUE_CORRECT.AsString <> '' then
        FProcessedItems.AddOrSetValue(memItemsITEM_ID.Value,  memItemsVALUE_CORRECT.Value);
      if memItemsCALC_VALUE_CORRECT.AsString <> '' then
        FProcessedItems.AddOrSetValue(memItemsITEM_ID.Value, memItemsCALC_VALUE_CORRECT.Value);
      memItems.Next;
    end;
  finally
    memItems.GotoBookmark(vBookMark);
    memItems.EnableControls;
  end;
end;

function TdmMain.SearchFormulaForCalc(var AResult: Double; var AItemId: Integer): Integer;
var
  vBookMark: TBookMark;
  vValue: Variant;
  vPar: TExpressionParser;
  vVars: array of double;
  i: Integer;
const
  cnstItemFilter  = 'ITEM_ID = %d';
  cnstFormulaFilter = ' formula_id = %d';


  //Достаточно ли данных для рассчета по формуле
  function IsCanCalcFormula(AFormulaId: Integer): Boolean;
  begin
    Result := True;
    //Определяем, какие элементы должны быть в формуле чтобы ее посчитать
    ldsFormulaDetail.Filter := Format(cnstFormulaFilter, [AFormulaID]);
    ldsFormulaDetail.Filtered := True;
    try
    ldsFormulaDetail.First;
    while not ldsFormulaDetail.Eof do
    begin
      //Если какой то элемент не рассчитан - выходит
      if not FProcessedItems.ContainsKey(ldsFormulaDetailITEM_ID.Value) then
      begin
        Result := False;
        Exit;
      end;
      ldsFormulaDetail.Next;
    end;
    finally
      ldsFormulaDetail.Filtered := False;
      ldsFormulaDetail.Filter := '';
    end;
  end;

begin
  vBookMark := memItems.GetBookmark;
  Result :=  cnstAllFormulasCalc;
  RefreshProcessedItems;
  SetLength(vVars, FProcessedItems.Count);

  try
    memItems.DisableControls;
    memItems.First;
    //Пробегаемся по всем элементам
    while not memItems.Eof do
    begin
      if memItemsRESULT_VALUE.AsString = '' then
      begin
        Result := cnstCantCalc;

        //Берем формулы, которые могут быть использованы для данного элемента
        ldsFormulas.Filter := Format(cnstItemFilter, [memItemsITEM_ID.Value]);
        ldsFormulas.Filtered := True;
        try
          ldsFormulas.First;
          while not ldsFormulas.Eof do
          begin
            //Если данная формула может быть посчитана, выходим
            if IsCanCalcFormula(ldsFormulasFORMULA_ID.Value) then
            begin
              Result := ldsFormulasFORMULA_ID.Value;
              break;
            end;
            ldsFormulas.Next;
          end;
        finally
          ldsFormulas.Filtered := False;
          ldsFormulas.Filter := '';
        end;


        //Если нашли какую либо формулу по которой можно посчитать
        if Result > 0 then
        begin
          vPar := TExpressionParser.Create;
          ldsFormulaDetail.Filter := Format(cnstFormulaFilter, [Result]);
          ldsFormulaDetail.Filtered := True;
          try
            ldsFormulaDetail.First;
            i := 0;
            while not ldsFormulaDetail.Eof do
            begin
              vVars[i] := FProcessedItems[ldsFormulaDetailITEM_ID.Value];
              vPar.DefineVariable(ldsFormulaDetailNAME.Value, @vVars[i]);
              Inc(i);
              ldsFormulaDetail.Next;
            end;
            AResult := vPar.Evaluate(ldsFormulaDetailF_STR.Value);
            AItemId := memItemsITEM_ID.Value;
            Exit;
          finally
            FreeAndNil(vPar);
            ldsFormulaDetail.Filtered := False;
            ldsFormulaDetail.Filter := '';
          end;
        end;
      end;

      memItems.Next;
    end;
  finally
    memItems.GotoBookmark(vBookMark);
    memItems.EnableControls;
  end;
end;

end.
