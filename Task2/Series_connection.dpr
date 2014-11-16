program Series_connection;

uses
  Vcl.Forms,
  fMainTemplate in '..\SharedCode\fMainTemplate.pas' {frmMainTemplate},
  uConstsShared in '..\SharedCode\uConstsShared.pas',
  uLocalizeShared in '..\SharedCode\uLocalizeShared.pas',
  ExprDraw in '..\SharedCode\ExprDraw.pas',
  ExprMake in '..\SharedCode\ExprMake.pas',
  uFormulaUtils in '..\SharedCode\uFormulaUtils.pas',
  uStringUtilsShared in '..\SharedCode\uStringUtilsShared.pas',
  fMain in 'fMain.pas' {frmMain},
  uCalc in 'uCalc.pas',
  uConsts in 'uConsts.pas',
  uElements in 'uElements.pas',
  ArrowUnit in '..\SharedCode\ArrowUnit.Pas',
  uGraphicUtils in '..\SharedCode\uGraphicUtils.pas',
  uLocalize in 'uLocalize.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
