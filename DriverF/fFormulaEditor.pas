unit fFormulaEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dataMain, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, Data.DB, Datasnap.DBClient, SQLite3Dataset,
  GridsEh, DBAxisGridsEh, DBGridEh, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.DBCtrls,
  MemTableDataEh, DataDriverEh, MemTableEh, SQLiteTable3;

type
  TfrmFormulaEditor = class(TForm)
    Panel1: TPanel;
    dbgFormulas: TDBGridEh;
    ldsFormulas: TSQLiteDataset;
    dsFormulas: TDataSource;
    ldsFormulasFORMULA_ID: TIntegerField;
    ldsFormulasF_STR: TWideStringField;
    ldsFormulasF_TEX: TWideStringField;
    ldsFormulasITEM_ID: TIntegerField;
    ldsFormulasNAME_UKR: TWideStringField;
    ldsFormulasNAME_RUS: TWideStringField;
    ldsFormulasTEXT_UKR: TWideStringField;
    ldsFormulasTEXT_RUS: TWideStringField;
    updFormulas: TSQLiteUpdateSQL;
    Button1: TButton;
    GroupBox1: TGroupBox;
    DBMemo1: TDBMemo;
    GroupBox2: TGroupBox;
    DBMemo2: TDBMemo;
    DBGridEh2: TDBGridEh;
    dsFormulaDetail: TDataSource;
    ldsSelecteditems: TSQLiteDataset;
    ldsSelecteditemsID: TIntegerField;
    ldsSelecteditemsNAME: TWideStringField;
    ldsSelecteditemsIS_ITEM_EXISTS: TIntegerField;
    memItems: TMemTableEh;
    dsd: TDataSetDriverEh;
    memItemsID: TIntegerField;
    memItemsNAME: TWideStringField;
    memItemsIS_ITEM_EXISTS: TIntegerField;
    procedure Button1Click(Sender: TObject);
    procedure ldsFormulasAfterScroll(DataSet: TDataSet);
    procedure ldsFormulasAfterPost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure memItemsAfterPost(DataSet: TDataSet);
    procedure ldsFormulasBeforeScroll(DataSet: TDataSet);
  private
    qryDeleteItems: TSQLitePreparedStatement;
    qryInsertItems: TSQLitePreparedStatement;

    IsNeedApplySelectedItems: Boolean;
    procedure FillItemList;
    procedure RefreshldsSelectedItems;
    procedure ApplySelectedItems;
  end;

procedure FormulaEditExecute;

implementation

{$R *.dfm}

procedure FormulaEditExecute;
var
  frm: TfrmFormulaEditor;
begin
  frm := TfrmFormulaEditor.Create(nil);
  frm.FillItemList;
  frm.ldsFormulas.Open;
  frm.ShowModal;
  frm.Free;
end;



procedure TfrmFormulaEditor.ApplySelectedItems;
begin
  if not IsNeedApplySelectedItems then
    Exit;
  ldsSelecteditems.DisableControls;
  ldsSelecteditems.First;
  while not ldsSelecteditems.Eof do
  begin
    dmMain.dbMain.ExecSQL('delete from formula_detail' + #13#10 +
    'where formula_id = :formula_id and item_id = :item_id',
      [ldsFormulasFORMULA_ID.Value, ldsSelecteditemsID.Value]);

    if ldsSelecteditemsIS_ITEM_EXISTS.Value = 1 then
    begin
      dmMain.dbMain.ExecSQL(
      'insert into formula_detail'#13#10'(formula_id, item_id)'#13#10+
      'values '#13#10 +
      '(:formula_id, :item_id)',
       [ldsFormulasFORMULA_ID.Value, ldsSelecteditemsID.Value]);
    end;
    ldsSelecteditems.Next;
  end;
  ldsSelecteditems.EnableControls;
  IsNeedApplySelectedItems := False;
end;

procedure TfrmFormulaEditor.Button1Click(Sender: TObject);
begin
  ldsFormulas.ApplyUpdates;
  IsNeedApplySelectedItems := True;
  ApplySelectedItems;
end;

procedure TfrmFormulaEditor.FillItemList;
begin
  dbgFormulas.FieldColumns['ITEM_ID'].PickList.Clear;
  dbgFormulas.FieldColumns['ITEM_ID'].KeyList.Clear;
  dmMain.ldsItems.First;
  while not dmMain.ldsItems.Eof do
  begin
    dbgFormulas.FieldColumns['ITEM_ID'].PickList.Add(dmMain.ldsItemsNAME.Value);
    dbgFormulas.FieldColumns['ITEM_ID'].KeyList.Add(dmMain.ldsItemsID.AsString);
    dmMain.ldsItems.Next;
  end;
end;

procedure TfrmFormulaEditor.FormCreate(Sender: TObject);
begin
  IsNeedApplySelectedItems := False;
end;

procedure TfrmFormulaEditor.ldsFormulasAfterPost(DataSet: TDataSet);
begin
  ldsFormulas.ApplyUpdates;
end;

procedure TfrmFormulaEditor.ldsFormulasAfterScroll(DataSet: TDataSet);
begin
  RefreshldsSelectedItems;
end;

procedure TfrmFormulaEditor.ldsFormulasBeforeScroll(DataSet: TDataSet);
begin
   ApplySelectedItems;
end;

procedure TfrmFormulaEditor.memItemsAfterPost(DataSet: TDataSet);
begin
  IsNeedApplySelectedItems := True;
end;

procedure TfrmFormulaEditor.RefreshldsSelectedItems;
begin
  ldsSelecteditems.Params.ParamValues['formula_id'] := ldsFormulasFORMULA_ID.Value;
  ldsSelecteditems.Close;
  ldsSelecteditems.Open;
  memItems.Close;
  memItems.Open;
end;

end.
