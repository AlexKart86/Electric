unit fEditRounding;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh, GridsEh,
  DBGridEh, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB;

type
  TfrmEditRounding = class(TForm)
    pnl1: TPanel;
    btnSave: TButton;
    dbgrdhMain: TDBGridEh;
    dsMain: TDataSource;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure EditRounding;

implementation
uses uRounding;

{$R *.dfm}

procedure EditRounding;
var
  frmEditRounding: TfrmEditRounding;
begin
  frmEditRounding := TfrmEditRounding.Create(nil);
  frmEditRounding.ShowModal;
end;

procedure TfrmEditRounding.FormCreate(Sender: TObject);
begin
  dsMain.DataSet := RndArr;
  dbgrdhMain.FieldColumns['ELEMENT_CAPTION'].ReadOnly := True;
end;

end.
