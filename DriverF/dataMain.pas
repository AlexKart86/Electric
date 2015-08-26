unit dataMain;

interface

uses
  System.SysUtils, System.Classes, DISQLite3Database, MemTableDataEh, Data.DB,
  DataDriverEh, MemTableEh, DISQLite3DataSet;

type
  TdmMain = class(TDataModule)
    dbMain: TDISQLite3Database;
    DISQLite3UniDirQuery1: TDISQLite3UniDirQuery;
    DataSource1: TDataSource;
    MemTableEh1: TMemTableEh;
    DataSetDriverEh1: TDataSetDriverEh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMain: TdmMain;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
