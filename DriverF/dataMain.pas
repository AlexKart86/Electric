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
    ilItems: TImageList;
    memItemsITEM_IMG: TBlobField;
    dsItems: TDataSource;
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




procedure TdmMain.RefreshItems;
var
  vImg: TGifImage;
  vStream: TMemoryStream;
begin
  ilItems.Clear;
  ConnectIfNeeded;
  ldsItems.Close;
  ldsItems.Open;
  ldsItems.First;
  memItems.EmptyTable;
  vStream := TMemoryStream.Create;
  try
    while not ldsItems.Eof do
    begin
      vImg := GetTexFormulaGif(ldsItemsF_TEX.Value);
      memItems.Insert;
      vStream.Clear;
      vImg.Bitmap.SaveToStream(vStream);
      memItemsITEM_IMG.LoadFromStream(vStream);
      memItems.Post;
      ldsItems.Next;
    end;
  finally
    FreeAndNil(vStream);
  end;
end;

end.
