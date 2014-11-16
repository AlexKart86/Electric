unit fEditDiagram;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh, Data.DB,
  GridsEh, DBGridEh, Vcl.ExtCtrls, Vcl.StdCtrls, uCalc, uFormulaUtils;

type
  TfrmEditDiagram = class(TForm)
    img1: TImage;
    dbgrdh1: TDBGridEh;
    ds1: TDataSource;
    btn1: TButton;
    pnl1: TPanel;
    spl1: TSplitter;
    btn2: TButton;
    procedure dbgrdh1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure btn2Click(Sender: TObject);
  private
    FSolver: TSolveOutput;
    FPicture: TBitmap;
    procedure AfterEdit(DataSet: TDataSet);
  public
    { Public declarations }
  end;

procedure EditDiagramExecute(ASolver: TSolveOutput);

implementation

{$R *.dfm}

procedure EditDiagramExecute(ASolver: TSolveOutput);
var frm: TfrmEditDiagram;
begin
  frm := TfrmEditDiagram.Create(Application);
  frm.ds1.DataSet := fCoordsCache;
  frm.FPicture := ASolver.BitmapMain;
  frm.img1.Picture.Assign(frm.FPicture);
  frm.FSolver := ASolver;
 // frm.ds1.DataSet.AfterEdit := frm.AfterEdit;
  frm.ShowModal;
end;

procedure TfrmEditDiagram.AfterEdit(DataSet: TDataSet);
begin
  FSolver.PrintDiagram;
end;

procedure TfrmEditDiagram.btn2Click(Sender: TObject);
begin
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

end.
