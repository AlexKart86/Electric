unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fMainTemplate, RVStyle, Vcl.StdCtrls,
  Vcl.ExtCtrls, Ruler, RVRuler, RVScroll, RichView, RVEdit, Vcl.ComCtrls,
  DISQLite3Database, dataMain, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh;

type
  TfrmMain = class(TfrmMainTemplate)
    DBGridEh1: TDBGridEh;
  protected
         // ³í³ö³àë³çàö³ÿ
    procedure InitDefaultValues; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.InitDefaultValues;
begin
  inherited;

end;

end.
