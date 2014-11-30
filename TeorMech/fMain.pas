unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DrawObjects1, DrawObjects2, Vcl.ExtCtrls,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.Ribbon,
  Vcl.RibbonLunaStyleActnCtrls, Vcl.ActnList, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, uGraphic,
  Vcl.StdCtrls, JvExForms, JvScrollBox, Data.DB, MemTableDataEh, MemTableEh;

type
  TfrmMain = class(TForm)
    pbMain: TPaintBox;
    Ribbon1: TRibbon;
    rbStructure: TRibbonPage;
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
    RibbonPage3: TRibbonPage;
    RibbonGroup3: TRibbonGroup;
    dbgObjectList: TDBGridEh;
    dsObjectList: TDataSource;
    memObjectList: TMemTableEh;
    memObjectListCONTROL_NAME: TStringField;
    memObjectListCONTROL_TYPE: TStringField;
    memObjectListOBJECT: TRefObjectField;
    acSave: TAction;
    dlgSave: TSaveDialog;
    actLoadFromFile: TAction;
    RibbonGroup4: TRibbonGroup;
    dlgOpen: TOpenDialog;
    procedure pbMainPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure act1Execute(Sender: TObject);
    procedure sbMainClick(Sender: TObject);
    procedure act2Execute(Sender: TObject);
    procedure pbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure memObjectListCalcFields(DataSet: TDataSet);
    procedure acSaveExecute(Sender: TObject);
    procedure actLoadFromFileExecute(Sender: TObject);
  public
    FObjectList: TDrawObjectList;
    procedure ReloadControlList;
  end;

var
  frmMain: TfrmMain;

implementation
const
  cnstGridSize = 10;

{$R *.dfm}

procedure TfrmMain.acSaveExecute(Sender: TObject);
begin
  if dlgSave.Execute then
     FObjectList.SaveToFile(dlgSave.FileName);
end;

procedure TfrmMain.act1Execute(Sender: TObject);
var
  vLine: Tline;
begin
  vLine := TLine.Create(self);
  vLine.Parent := sbMain;
  vLine.Left := 20;
  vLine.Top := 30;
  FObjectList.Add(vLine);
  ReloadControlList;
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
  ReloadControlList;
end;

procedure TfrmMain.actLoadFromFileExecute(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    FObjectList.LoadFromFile(dlgOpen.FileName, self, sbMain);
    ReloadControlList;
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  pbMain.Canvas.Pen.Color := clSilver;
  FObjectList := TDrawObjectList.Create;
  memObjectList.CreateDataSet;
  memObjectList.Open;
end;

procedure TfrmMain.memObjectListCalcFields(DataSet: TDataSet);
begin
  memObjectListCONTROL_NAME.Value :=  TDrawObject(memObjectListOBJECT).Caption;
  memObjectListCONTROL_TYPE.Value := RusText(memObjectListOBJECT.ClassName);
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

procedure TfrmMain.ReloadControlList;
var
  i: Integer;
begin
  memObjectList.EmptyTable;
  for i := 0 to FObjectList.Count-1 do
  begin
    memObjectList.Insert;
    memObjectListCONTROL_NAME.Value := FObjectList.Items[i].Caption;
    memObjectListCONTROL_TYPE.Value := RusText(FObjectList.Items[i].ClassName);
    memObjectListOBJECT.Value := FObjectList.Items[i];
    memObjectList.Post;
  end;

end;

procedure TfrmMain.sbMainClick(Sender: TObject);
begin
  FObjectList.ClearAllSelection;
end;

end.
