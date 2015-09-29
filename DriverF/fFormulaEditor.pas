unit fFormulaEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dataMain, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, Data.DB, Datasnap.DBClient, SQLite3Dataset,
  GridsEh, DBAxisGridsEh, DBGridEh, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.DBCtrls;

type
  TfrmFormulaEditor = class(TForm)
    Panel1: TPanel;
    DBGridEh1: TDBGridEh;
    ldsFormulas: TSQLiteDataset;
    DataSource1: TDataSource;
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
    DBMemo1: TDBMemo;
    GroupBox1: TGroupBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure FormulaEditExecute;

implementation

{$R *.dfm}

procedure FormulaEditExecute;
var
  frm: TfrmFormulaEditor;
begin
  frm := TfrmFormulaEditor.Create(nil);
  frm.ldsFormulas.Open;
  frm.ShowModal;
  frm.Free;
end;



procedure TfrmFormulaEditor.Button1Click(Sender: TObject);
begin
  ldsFormulas.ApplyUpdates;
end;

end.
