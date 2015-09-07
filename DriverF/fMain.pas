unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fMainTemplate, RVStyle, Vcl.StdCtrls,
  Vcl.ExtCtrls, Ruler, RVRuler, RVScroll, RichView, RVEdit, Vcl.ComCtrls,
  dataMain, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.Grids, Vcl.DBGrids, CRGrid;

type
  TfrmMain = class(TfrmMainTemplate)
    GroupBox1: TGroupBox;
    DBGridEh1: TDBGridEh;
    CRDBGrid1: TCRDBGrid;
    btnRecalc: TButton;
    procedure FormShow(Sender: TObject);
  protected
         // ³í³ö³àë³çàö³ÿ
    procedure InitDefaultValues; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.FormShow(Sender: TObject);
begin
  inherited;
  dmMain.dbMain.Connected := False;
  dmMain.RefreshItems;
end;

procedure TfrmMain.InitDefaultValues;
begin
  inherited;

end;

end.
