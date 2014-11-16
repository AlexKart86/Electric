program Kinematic;

uses
  Vcl.Forms,
  uFormulaUtils in '..\SharedCode\uFormulaUtils.pas',
  uLocalizeShared in '..\SharedCode\uLocalizeShared.pas',
  ExprDraw in '..\SharedCode\ExprDraw.pas',
  ExprMake in '..\SharedCode\ExprMake.pas',
  uConstsShared in '..\SharedCode\uConstsShared.pas',
  uStringUtilsShared in '..\SharedCode\uStringUtilsShared.pas',
  uGraphicUtils in '..\SharedCode\uGraphicUtils.pas',
  fMainTemplate in '..\SharedCode\fMainTemplate.pas' {frmMainTemplate},
  fMain in 'fMain.pas' {frmMain},
  uSystem in '..\SharedCode\uSystem.pas',
  fEditGraphic in 'fEditGraphic.pas' {frmEditGraphic};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
