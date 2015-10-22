program DriverM;

uses
  Vcl.Forms,
  SysUtils,
  fMainTemplate in '..\SharedCode\fMainTemplate.pas' {frmMainTemplate},
  fMain in 'fMain.pas' {frmMain},
  dataMain in 'dataMain.pas' {dmMain: TDataModule},
  uLocalizeShared in '..\SharedCode\uLocalizeShared.pas',
  uConstsShared in '..\SharedCode\uConstsShared.pas',
  ExprDraw in '..\SharedCode\ExprDraw.pas',
  ExprMake in '..\SharedCode\ExprMake.pas',
  uFormulaUtils in '..\SharedCode\uFormulaUtils.pas',
  uStringUtilsShared in '..\SharedCode\uStringUtilsShared.pas',
  uSystem in '..\SharedCode\uSystem.pas',
  ParseClass in '..\SharedCode\ParseClass.pas',
  ParseExpr in '..\SharedCode\ParseExpr.pas',
  oObjects in '..\SharedCode\oObjects.pas',
  uCalc in 'uCalc.pas',
  uRounding in '..\SharedCode\uRounding.pas',
  uLocalize in 'uLocalize.pas',
  fFormulaEditor in 'fFormulaEditor.pas' {frmFormulaEditor},
  uGraphicUtils in '..\SharedCode\uGraphicUtils.pas',
  ArrowUnit in '..\SharedCode\ArrowUnit.Pas';

{$R *.res}

begin
  Application.Initialize;
  FormatSettings.DecimalSeparator := '.';
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Electric machines and transformers';
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
