program TeorMech;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {frmMain},
  uGraphic in 'uGraphic.pas',
  objInspector in 'objInspector.pas' {ObjInspectForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TObjInspectForm, ObjInspectForm);
  Application.Run;
end.
