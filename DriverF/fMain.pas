unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fMainTemplate, RVStyle, Vcl.StdCtrls,
  Vcl.ExtCtrls, Ruler, RVRuler, RVScroll, RichView, RVEdit, Vcl.ComCtrls,
  dataMain, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.Grids, Vcl.DBGrids,
  Vcl.Mask, EhLibVCL, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  VCLTee.Chart, DBCtrlsEh, DB;

type
  TfrmMain = class(TfrmMainTemplate)
    GroupBox1: TGroupBox;
    dbgParams: TDBGridEh;
    btnRecalc: TButton;
    Button1: TButton;
    chbNeedRecalc: TDBCheckBoxEh;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure dbgParamsDataHintShow(Sender: TCustomDBGridEh; CursorPos: TPoint;
      Cell: TGridCoord; InCellCursorPos: TPoint; Column: TColumnEh;
      var Params: TDBGridEhDataHintParams; var Processed: Boolean);
    procedure dbgParamsGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btnRecalcClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure dbgParamsKeyPress(Sender: TObject; var Key: Char);
  private
    function TryCalc: Boolean;
    procedure DsAfterPost(DataSet: TDataSet);
  protected
    // �����������
    procedure InitDefaultValues; override;
    // ����������, ��������� ���������� �������
    procedure RunSolve; override;
    // �������������� ��������� ��������� ��� ������������� �� � ���������
    procedure PrepareInputParams; override;
  end;

var
  frmMain: TfrmMain;

implementation
uses ParseExpr, uCalc, uRounding, fFormulaEditor;

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.btnPrevClick(Sender: TObject);
begin
  inherited;
  dmMain.memItems.AfterPost := DsAfterPost;
end;

procedure TfrmMain.btnRecalcClick(Sender: TObject);
begin
  inherited;
  dmMain.ClearCalc;
  TryCalc;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
 vPar: TExpressionParser;
 a,b,c: Double;
begin
  inherited;
  FormulaEditExecute;
{  vPar := TExpressionParser.Create;
  a := 2;
  b := 2;
  c := 2;
  vPar.DefineVariable('P1n', @a);
  vPar.DefineVariable('Un', @b);
  vPar.DefineVariable('cosF', @c);
  ShowMessage(FloatToStr(vPar.Evaluate(Edit1.Text)));}


//  dmMain.memItems.Edit;
//  dmMain.memItemsVALUE.Value := 3.44;
//  dmMain.memItems.Post;
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
    Background := clLime
  else if dmMain.memItemsCALC_VALUE.AsString <> '' then
    Background := clYellow;
end;

procedure TfrmMain.dbgParamsKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = #13) and (dmMain.memItems.State in dsEditModes) then
    dmMain.memItems.Post;
end;

procedure TfrmMain.DsAfterPost(DataSet: TDataSet);
begin
  if chbNeedRecalc.Checked then
  begin
    dmMain.memItems.AfterPost := nil;
    try
      dmMain.ClearCalc;
      dmMain.Calc;
    finally
      dmMain.memItems.AfterPost := DsAfterPost;
    end;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  inherited;
  dmMain.dbMain.Connected := False;
  dmMain.RefreshItems;
  dmMain.memItems.AfterPost := DsAfterPost;
end;

procedure TfrmMain.InitDefaultValues;
begin
  inherited;

end;

procedure TfrmMain.PrepareInputParams;
begin
  inherited;
end;

procedure TfrmMain.RunSolve;
var
  vSolver: TSolver;
begin
 // if not TryCalc then
 //   Exit;
  dmMain.memItems.AfterPost := nil;
  vSolver := TSolver.Create(rvMain, dmMain);
  vSolver.RunSolve;
end;

function TfrmMain.TryCalc: Boolean;
begin
  Result := dmMain.Calc;
  if not Result then
    ShowMessage('����������� ������� ����� ��� ����������');
end;

end.
