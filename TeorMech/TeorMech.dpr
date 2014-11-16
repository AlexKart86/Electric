program TeorMech;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {frmMain},
  uGraphic in 'uGraphic.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
