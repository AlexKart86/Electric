unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fMainTemplate, RVStyle, Vcl.StdCtrls,
  Vcl.ExtCtrls, Ruler, RVRuler, RVScroll, RichView, RVEdit, Vcl.ComCtrls,
  dataMain, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.Grids, Vcl.DBGrids, CRGrid;

type
  TfrmMain = class(TfrmMainTemplate)
    GroupBox1: TGroupBox;
    DBGridEh1: TDBGridEh;
    CRDBGrid1: TCRDBGrid;
    btnRecalc: TButton;
    Button1: TButton;
    Edit1: TEdit;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  protected
         // ³í³ö³àë³çàö³ÿ
    procedure InitDefaultValues; override;
  end;

var
  frmMain: TfrmMain;

implementation
uses ParseExpr;

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.Button1Click(Sender: TObject);
var
 vPar: TExpressionParser;
 a,b,c: Double;
begin
  inherited;
  vPar := TExpressionParser.Create;
  a := 2;
  b := 2;
  c := 2;
  vPar.DefineVariable('P1n', @a);
  vPar.DefineVariable('Un', @b);
  vPar.DefineVariable('cosF', @c);
  ShowMessage(FloatToStr(vPar.Evaluate(Edit1.Text)));
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  inherited;
  dmMain.dbMain.Connected := False;
  dmMain.RefreshItems;
end;

procedure TfrmMain.InitDefaultValues;
begin
  inherited;

end;

end.
