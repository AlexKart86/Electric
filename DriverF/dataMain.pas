unit dataMain;

interface

uses
  System.SysUtils, System.Classes,  MemTableDataEh, Data.DB,
  DataDriverEh, MemTableEh, SQLiteTable3, Datasnap.DBClient, SQLite3Dataset,
  Vcl.ImgList, Vcl.Controls;

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
    memItemsCALC_VALUE: TFloatField;
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
    procedure memItemsAfterScroll(DataSet: TDataSet);
  private
    procedure RefreshCurMeasList;
  public
    procedure ConnectIfNeeded;
    procedure RefreshItems;
  end;

var
  dmMain: TdmMain;

implementation
uses Forms, uFormulaUtils, Vcl.Imaging.GIFImg;

const
  cnstDbName = 'formulas.db';

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TdmMain }

procedure TdmMain.ConnectIfNeeded;
begin
  if not dbMain.Connected then
  begin
    dbMain.Filename := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+ cnstDbName;
    dbMain.Connected := True;
  end;
end;




procedure TdmMain.memItemsAfterScroll(DataSet: TDataSet);
begin
  RefreshCurMeasList;
end;

procedure TdmMain.RefreshCurMeasList;
const
  cnstFilter = 'ITEM_ID = %d';
begin
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

end.
