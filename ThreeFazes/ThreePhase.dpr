program ThreePhase;

{$R *.dres}

uses
  Vcl.Forms,
  fMainTemplate in '..\SharedCode\fMainTemplate.pas' {frmMainTemplate},
  uConstsShared in '..\SharedCode\uConstsShared.pas',
  uFormulaUtils in '..\SharedCode\uFormulaUtils.pas',
  uGraphicUtils in '..\SharedCode\uGraphicUtils.pas',
  uStringUtilsShared in '..\SharedCode\uStringUtilsShared.pas',
  uLocalizeShared in '..\SharedCode\uLocalizeShared.pas',
  ExprDraw in '..\SharedCode\ExprDraw.pas',
  ExprMake in '..\SharedCode\ExprMake.pas',
  fMain in 'fMain.pas' {frmMain},
  uCalc in 'uCalc.pas',
  uLocalize in 'uLocalize.pas',
  uConsts in 'uConsts.pas',
  TestuFormulaUtils in 'TestuFormulaUtils.pas',
  ArrowUnit in '..\SharedCode\ArrowUnit.Pas',
  uRounding in '..\SharedCode\uRounding.pas',
  uSystem in '..\SharedCode\uSystem.pas',
  fEditDiagram in 'fEditDiagram.pas' {frmEditDiagram},
  uComplexUtils in '..\SharedCode\uComplexUtils.pas',
  fEditRounding in '..\SharedCode\fEditRounding.pas' {frmEditRounding};

{$R *.res}
{$R picture.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
