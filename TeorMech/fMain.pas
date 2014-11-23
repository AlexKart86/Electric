unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DrawObjects1, DrawObjects2, Vcl.ExtCtrls,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.Ribbon,
  Vcl.RibbonLunaStyleActnCtrls, Vcl.ActnList, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, uGraphic,
  Vcl.StdCtrls, JvExForms, JvScrollBox;

type
  TfrmMain = class(TForm)
    pbMain: TPaintBox;
    Ribbon1: TRibbon;
    RibbonPage1: TRibbonPage;
    RibbonGroup1: TRibbonGroup;
    RibbonGroup2: TRibbonGroup;
    RibbonPage2: TRibbonPage;
    amMain: TActionManager;
    act1: TAction;
    pnl1: TPanel;
    grp1: TGroupBox;
    spl1: TSplitter;
    grp2: TGroupBox;
    sbMain: TScrollBox;
    act2: TAction;
    act3: TAction;
    procedure pbMainPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure act1Execute(Sender: TObject);
    procedure sbMainClick(Sender: TObject);
    procedure act2Execute(Sender: TObject);
    procedure pbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  public
    FObjectList: TDrawObjectList;
  end;

var
  frmMain: TfrmMain;

implementation
const
  cnstGridSize = 10;

{$R *.dfm}

procedure TfrmMain.act1Execute(Sender: TObject);
var
  vLine: Tline;
begin
  vLine := TLine.Create(self);
  vLine.Parent := sbMain;
  vLine.Left := 20;
  vLine.Top := 30;
  FObjectList.Add(vLine);
end;

procedure TfrmMain.act2Execute(Sender: TObject);
var
  vSolidPoint: TSolidPoint;
  vText: TText;
begin
  vSolidPoint := TSolidPoint.Create(self);
  vSolidPoint.Parent := sbMain;
  vSolidPoint.Left := 100;
  vSolidPoint.Top := 200;
  FObjectList.Add(vSolidPoint);
  vText := TText.Create(self);
  vText.Parent := sbMain;
  vText.Strings.Text := 'A';
  vText.OwnerObject := vSolidPoint;
  vText.Left := 100;
  vText.Top := 200;
  vText.IsLinkedObjectNeed := True;
  FObjectList.Add(vText);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
   pbMain.Canvas.Pen.Color := clSilver;
   FObjectList := TDrawObjectList.Create;
end;

procedure TfrmMain.pbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   FObjectList.ClearAllSelection;
end;

procedure TfrmMain.pbMainPaint(Sender: TObject);
var
  i: integer;
begin
  with pbMain do
  begin
    for i := 0 to (Width div cnstGridSize) do
    begin
      canvas.MoveTo(i*cnstGridSize,0);
      canvas.LineTo(i*cnstGridSize,height);
    end;
    for i := 0 to (Height div cnstGridSize) do
    begin
      canvas.MoveTo(0,i*cnstGridSize);
      canvas.LineTo(width,i*cnstGridSize);
    end;
  end;
end;

procedure TfrmMain.sbMainClick(Sender: TObject);
begin
  FObjectList.ClearAllSelection;
end;

end.
