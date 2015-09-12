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
    dbgParams: TDBGridEh;
    CRDBGrid1: TCRDBGrid;
    btnRecalc: TButton;
    Button1: TButton;
    Edit1: TEdit;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure dbgParamsDataHintShow(Sender: TCustomDBGridEh; CursorPos: TPoint;
      Cell: TGridCoord; InCellCursorPos: TPoint; Column: TColumnEh;
      var Params: TDBGridEhDataHintParams; var Processed: Boolean);
    procedure dbgParamsGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btnRecalcClick(Sender: TObject);
  protected
         // �����������
    procedure InitDefaultValues; override;
  end;

var
  frmMain: TfrmMain;

implementation
uses ParseExpr;

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.btnRecalcClick(Sender: TObject);
var
  vResult: Double;
  vItemId: Integer;
begin
  inherited;
{  if dmMain.SearchFormulaForCalc(vResult, vItemId) > 0 then
  begin
    ShowMessage('ID: '+IntToStr(vItemId) + #13#10+
       'Val: ' + FloatToStr(vResult));
  end;}
  if dmMain.Calc then
    ShowMessage('�������');

end;

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

procedure TfrmMain.dbgParamsDataHintShow(Sender: TCustomDBGridEh;
  CursorPos: TPoint; Cell: TGridCoord; InCellCursorPos: TPoint;
  Column: TColumnEh; var Params: TDBGridEhDataHintParams;
  var Processed: Boolean);
begin
  inherited;
  Params.HintStr := dmMain.memItemsHINT.Value;
end;

procedure TfrmMain.dbgParamsGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  inherited;
  if dmMain.memItemsVALUE.AsString <> '' then
    Background := clGreen
  else if dmMain.memItemsCALC_VALUE.AsString <> '' then
    Background := clYellow;
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
