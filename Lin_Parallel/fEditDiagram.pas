unit fEditDiagram;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh, Data.DB,
  GridsEh, DBGridEh, Vcl.ExtCtrls, Vcl.StdCtrls, uCalc, uFormulaUtils, Vcl.Mask,
  DBCtrlsEh;

type
  TfrmEditDiagram = class(TForm)
    img1: TImage;
    dbgrdh1: TDBGridEh;
    ds1: TDataSource;
    btn1: TButton;
    pnl1: TPanel;
    spl1: TSplitter;
    btn2: TButton;
    dbnScaleI: TDBNumberEditEh;
    lbl1: TLabel;
    dbnScaleU: TDBNumberEditEh;
    lbl2: TLabel;
    grp1: TGroupBox;
    grp2: TGroupBox;
    lbl3: TLabel;
    lbl4: TLabel;
    dbnX0: TDBNumberEditEh;
    dbnY0: TDBNumberEditEh;
    procedure dbgrdh1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure btn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbnX0Enter(Sender: TObject);
    procedure dbnY0Enter(Sender: TObject);
    procedure dbnX0Exit(Sender: TObject);
    procedure dbnY0Exit(Sender: TObject);
  private
    FOldValueX: Variant;
    FOldValueY: Variant;
    FSolver: TSolver;
    FPicture: TBitmap;
    procedure ApplyValues;
    //Меняет координаты всех надписей
    procedure ShiftCoords(DeltaX: Integer; DeltaY: INteger);
    procedure AfterEdit(DataSet: TDataSet);
  public
    { Public declarations }
  end;

procedure EditDiagramExecute(ASolver: TSolver);

implementation

{$R *.dfm}

procedure EditDiagramExecute(ASolver: TSolver);
var frm: TfrmEditDiagram;
begin
  frm := TfrmEditDiagram.Create(Application);
  frm.ds1.DataSet := fCoordsCache;
  frm.FPicture := ASolver.BitmapMain;
  frm.img1.Picture.Assign(frm.FPicture);
  frm.FSolver := ASolver;
  frm.dbnScaleI.Value := ASolver.vScaleI;
  frm.dbnScaleU.Value := ASolver.vScaleU;
  frm.dbnX0.Value := ASolver.vX0;
  frm.dbnY0.Value := ASolver.vY0;
  frm.FOldValueX := ASolver.vX0;
  frm.FOldValueY := ASolver.vY0;
  ASolver.IsScaleInit := True;
 // frm.ds1.DataSet.AfterEdit := frm.AfterEdit;
  frm.ShowModal;
end;

procedure TfrmEditDiagram.AfterEdit(DataSet: TDataSet);
begin
  FSolver.PrintDiagram;
end;

procedure TfrmEditDiagram.ApplyValues;
begin
  FSolver.vScaleI := dbnScaleI.Value;
  FSolver.vScaleU := dbnScaleU.Value;
  FSolver.vX0 := dbnX0.Value;
  FSolver.vY0 := dbnY0.Value;
end;

procedure TfrmEditDiagram.btn2Click(Sender: TObject);
begin
  ApplyValues;
  FSolver.PrintDiagram;
  img1.Picture.Assign(FPicture);
end;

procedure TfrmEditDiagram.dbgrdh1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var b: TBitmap;
begin
 if (DataCol = 0) then
  begin
    with TDBGridEh(Sender).Canvas do
    begin
      Brush.Color:=clWhite;
      FillRect(REct);
      B:=TBitmap.Create;
      B.Assign(TGraphicField(ds1.DataSet.FieldByName('IMG')));;
      Draw(round((Rect.Left + Rect.Right - B.Width) / 2), Rect.Top, B);
      FreeAndNil(B);
    end;
  end;
end;

procedure TfrmEditDiagram.dbnX0Enter(Sender: TObject);
begin
  FOldValueX := dbnX0.Value;
end;

procedure TfrmEditDiagram.dbnX0Exit(Sender: TObject);
begin
  if VarIsNull(dbnX0.Value) or VarIsNull(FOldValueX) then
     Exit;
  ShiftCoords(Trunc(dbnX0.Value-FOldValueX), 0);
end;

procedure TfrmEditDiagram.dbnY0Enter(Sender: TObject);
begin
  FOldValueY := dbnY0.Value;
end;

procedure TfrmEditDiagram.dbnY0Exit(Sender: TObject);
begin
  if VarIsNull(dbnY0.Value) or VarIsNull(FOldValueY) then
     Exit;
  ShiftCoords(0, Trunc(dbnY0.Value-FOldValueY));
end;

procedure TfrmEditDiagram.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ApplyValues;
  Action := caFree;
end;

procedure TfrmEditDiagram.ShiftCoords(DeltaX, DeltaY: INteger);
var
  vBookmark: TBookmark;
begin
  if (DeltaX = 0) and (DeltaY = 0) then
    Exit;

  fCoordsCache.DisableControls;
  vBookmark := fCoordsCache.GetBookmark;
  fCoordsCache.First;

  while not fCoordsCache.Eof do
  begin
    fCoordsCache.Edit;
    fCoordsCache.FieldByName('X').Value := fCoordsCache.FieldByName('X').Value + DeltaX;
    fCoordsCache.FieldByName('Y').Value := fCoordsCache.FieldByName('Y').Value + DeltaY;
    fCoordsCache.Post;
    fCoordsCache.Next;
  end;
  fCoordsCache.GotoBookmark(vBookmark);
  fCoordsCache.EnableControls;
end;

end.
