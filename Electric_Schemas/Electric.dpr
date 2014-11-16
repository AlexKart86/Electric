program Electric;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {frmMain},
  uCalc in 'uCalc.pas',
  uElements in 'uElements.pas',
  uConsts in 'uConsts.pas',
  uGraphicUtils in '..\SharedCode\uGraphicUtils.pas',
  ExprMake in '..\SharedCode\ExprMake.pas',
  ExprDraw in '..\SharedCode\ExprDraw.pas',
  uStringUtils in 'uStringUtils.pas',
  uLocalize in 'uLocalize.pas',
  uFormulaUtils in '..\SharedCode\uFormulaUtils.pas',
  ArrowUnit in '..\SharedCode\ArrowUnit.Pas',
  uConstsShared in '..\SharedCode\uConstsShared.pas',
  uLocalizeShared in '..\SharedCode\uLocalizeShared.pas',
  uStringUtilsShared in '..\SharedCode\uStringUtilsShared.pas',
  uSystem in '..\SharedCode\uSystem.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
