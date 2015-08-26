program DriverM;

uses
  Vcl.Forms,
  fMainTemplate in '..\SharedCode\fMainTemplate.pas' {frmMainTemplate},
  fMain in 'fMain.pas' {frmMain},
  dataMain in 'dataMain.pas' {dmMain: TDataModule},
  uLocalizeShared in '..\SharedCode\uLocalizeShared.pas',
  uConstsShared in '..\SharedCode\uConstsShared.pas',
  ExprDraw in '..\SharedCode\ExprDraw.pas',
  ExprMake in '..\SharedCode\ExprMake.pas',
  uFormulaUtils in '..\SharedCode\uFormulaUtils.pas',
  uStringUtilsShared in '..\SharedCode\uStringUtilsShared.pas',
  uGraphicUtils in '..\SharedCode\uGraphicUtils.pas',
  uSystem in '..\SharedCode\uSystem.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;
end.
