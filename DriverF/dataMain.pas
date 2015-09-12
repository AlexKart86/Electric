unit dataMain;

interface

uses
  System.SysUtils, System.Classes,  MemTableDataEh, Data.DB,
  DataDriverEh, MemTableEh, SQLiteTable3, Datasnap.DBClient, SQLite3Dataset,
  Vcl.ImgList, Vcl.Controls, System.Generics.Collections;

type


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
    ldsMeasuresID: TIntegerField;
    ldsMeasuresLABEL_UKR: TWideStringField;
    ldsMeasuresKOEFF: TFloatField;
    ldsMeasuresDESCRIPTION_UKR: TWideStringField;
    ldsMeasuresBASE_ID: TIntegerField;
    ldsMeasuresDESCRIPTION_RU: TWideStringField;
    ldsMeasuresLABEL_RU: TWideStringField;
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
    procedure memItemsAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure memItemsCalcFields(DataSet: TDataSet);

  private
    FProcessedItems: TDictionary<integer, double>;
    procedure RefreshProcessedItems;
    procedure RefreshCurMeasList;
     //����� ������ ���� ������� �� ������� ����� ���-������ ���������
    //� ������� ��� �� ���������
    //���������� �� �������
    function SearchFormulaForCalc(var AResult: Double;  var AItemId: Integer): Integer;
  public
    procedure ConnectIfNeeded;
    procedure RefreshItems;
    function Calc: Boolean;
  end;

var
  dmMain: TdmMain;

implementation
uses Forms, uFormulaUtils, Vcl.Imaging.GIFImg, ParseExpr, ParseClass;

const
  cnstDbName = 'formulas.db';
  //��� �������� �� �������� ����������
  cnstAllFormulasCalc = -2;
  //��� ������� ������� �� ����� ���� ���������
  cnstCantCalc = -1;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TdmMain }

function TdmMain.Calc: Boolean;
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
      end
      else
        Exit;
    until true;
  finally
    memItems.GotoBookmark(vBookMark);
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
      RefreshCurMeasList;
      if memCurMeasList.RecordCount >= 1 then
        memItemsMEASURE_ID.Value := memCurMeasListID.Value;
      memItems.Post;

      ldsItems.Next;
    end;
  finally
    FreeAndNil(vStream);
  end;
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


  //���������� �� ������ ��� �������� �� �������
  function IsCanCalcFormula(AFormulaId: Integer): Boolean;
  begin
    Result := True;
    //����������, ����� �������� ������ ���� � ������� ����� �� ���������
    ldsFormulaDetail.Filter := Format(cnstFormulaFilter, [AFormulaID]);
    ldsFormulaDetail.Filtered := True;
    try
    ldsFormulaDetail.First;
    while not ldsFormulaDetail.Eof do
    begin
      //���� ����� �� ������� �� ��������� - �������
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
    //����������� �� ���� ���������
    while not memItems.Eof do
    begin
      if memItemsCALC_VALUE.AsString = '' then
      begin
        Result := cnstCantCalc;

        //����� �������, ������� ����� ���� ������������ ��� ������� ��������
        ldsFormulas.Filter := Format(cnstItemFilter, [memItemsITEM_ID.Value]);
        ldsFormulas.Filtered := True;
        try
          ldsFormulas.First;
          while not ldsFormulas.Eof do
          begin
            //���� ������ ������� ����� ���� ���������, �������
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


        //���� ����� ����� ���� ������� �� ������� ����� ���������
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
