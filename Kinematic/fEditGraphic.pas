unit fEditGraphic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  Vcl.ExtCtrls, GridsEh, DBGridEh, MemTableDataEh, Db, MemTableEh, uSystem,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask, DBCtrlsEh;

type
  TfrmEditGraphic = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    dbgrdhMain: TDBGridEh;
    spl1: TSplitter;
    memMain: TMemTableEh;
    dsMain: TDataSource;
    strngfldMainFORMULA: TStringField;
    strngfldMainstr_x: TStringField;
    strngfldMainstr_y: TStringField;
    memMainval_x: TIntegerField;
    memMainval_y: TIntegerField;
    pnl3: TPanel;
    imgMain: TImage;
    btnRecalc: TBitBtn;
    memMainIMG: TGraphicField;
    btn1: TButton;
    pnl4: TPanel;
    grp1: TGroupBox;
    dbnWkoeff: TDBNumberEditEh;
    lbl1: TLabel;
    dbnVKoeff: TDBNumberEditEh;
    lbl2: TLabel;
    chkWnKoeff: TCheckBox;
    dbnRKoeff: TDBNumberEditEh;
    lbl3: TLabel;
    procedure btnRecalcClick(Sender: TObject);
    procedure dbgrdhMainDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
  private
    FImg: TGraphic;
    FCallBackProc: TCallbackProc;
    procedure InitCoords;
    procedure LoadCoords;
    procedure SaveCoords;
  end;

const cnstCoordsFile='mark_coords.txt';

procedure ShowGraphEdit(AImage:TGraphic; ARedrawProc:TCallbackProc);

implementation
uses uFormulaUtils, Vcl.Imaging.GIFImg;

{$R *.dfm}

procedure ShowGraphEdit(AImage:TGraphic; ARedrawProc:TCallbackProc);
var
  frm: TfrmEditGraphic;
begin
  frm := TfrmEditGraphic.Create(nil);
  frm.FImg := AImage;
  frm.FCallBackProc  := ARedrawProc;
  frm.LoadCoords;
  frm.InitCoords;
  frm.imgMain.Picture.Assign(frm.FImg);
  frm.ShowModal;
end;

procedure TfrmEditGraphic.btnRecalcClick(Sender: TObject);
begin
  btnRecalc.Enabled := False;
  btnRecalc.Caption := 'Зачейкайте..';
  Application.ProcessMessages;
  try
    SaveCoords;
    FCallBackProc();
    imgMain.Picture.Assign(FImg);
  finally
    btnRecalc.Enabled := True;
    btnRecalc.Caption := 'Перестроїти графік';
  end;
end;

procedure TfrmEditGraphic.dbgrdhMainDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var B: TGIFImage;
    vStream: TMemoryStream;
begin
  inherited;
 if (DataCol = 0) then
  begin
    with TDBGridEh(Sender).Canvas do
    begin
      Brush.Color:=clWhite;
      FillRect(REct);
      B:=TGIFImage.Create;
      vStream := TMemoryStream.Create;
      try
        memMainIMG.SaveToStream(vStream);
        vStream.Position := 0;
        b.LoadFromStream(vStream);
      finally
        FreeAndNil(vStream);
      end;
      Draw(round((Rect.Left + Rect.Right - B.Width) / 2), Rect.Top, B);
      FreeAndNil(B);
    end;
  end;
end;

procedure TfrmEditGraphic.InitCoords;
var
  vStrList: TStringList;
begin
  vStrList := TStringList.Create;
  vStrList.Delimiter := '=';
  vStrList.LoadFromFile(GetAppPath+cnstCoordsFile);
  memMain.First;
  while not memMain.Eof do
  begin
    memMain.Edit;
    memMainval_x.Value := StrToInt(vStrList.Values[strngfldMainstr_x.Value]);
    memMainval_y.Value := StrToInt(vStrList.Values[strngfldMainstr_y.Value]);
    memMain.Post;
    memMain.Next;
  end;
  dbnWKoeff.Value := Abs(StrToFloat(vStrList.Values['Wnkoeff']));
  chkWnKoeff.Checked := StrToFloat(vStrList.Values['Wnkoeff'])<0;
  dbnVKoeff.Value := Abs(StrToFloat(vStrList.Values['Vkoeff']));
  dbnRKoeff.Value := Abs(StrToFloat(vStrList.Values['Rkoeff']));
end;

procedure TfrmEditGraphic.LoadCoords;
var vImg: TGifImage;
    vStream: TMemoryStream;
begin
  vStream := TMemoryStream.Create;
  try
    memMain.First;
    while not memMain.Eof do
    begin
      vImg := GetTexFormulaGif(strngfldMainFORMULA.Value);
      vImg.SaveToStream(vStream);
      vStream.Position := 0;
      memMain.Edit;
      memMainIMG.LoadFromStream(vStream);
      memMain.Post;
      memMain.Next;
      vStream.Clear;
    end;
  finally
    FreeAndNil(vStream);
  end;
end;

procedure TfrmEditGraphic.SaveCoords;
var vStrList: TStringList;
begin
  vStrList := TStringList.Create;
  vStrList.Delimiter := '=';

  if chkWnKoeff.Checked then
    vStrList.Values['Wnkoeff'] := FloatToStr(-dbnWKoeff.Value)
  else
    vStrList.Values['Wnkoeff'] := FloatToStr(dbnWKoeff.Value);
  vStrList.Values['Vkoeff'] := dbnVKoeff.Value;
  vStrList.Values['Rkoeff'] := dbnRKoeff.Value;
  memMain.First;
  while not memMain.Eof do
  begin
    vStrList.Values[strngfldMainstr_x.Value] := FloatToStr(memMainval_x.Value);
    vStrList.Values[strngfldMainstr_y.Value] := FloatToStr(memMainval_y.Value);
    memMain.Next;
  end;
  vStrList.SaveToFile(GetAppPath+cnstCoordsFile);
end;

end.
