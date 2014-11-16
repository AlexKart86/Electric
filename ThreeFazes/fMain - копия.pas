unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fMainTemplate, RVStyle, Vcl.StdCtrls,
  Vcl.ExtCtrls, Ruler, RVRuler, RVScroll, RichView, RVEdit, Vcl.ComCtrls,
  JvComponentBase, JvInterpreter, Vcl.Tabs, Vcl.Mask, DBCtrlsEh;

type
  TfrmMain = class(TfrmMainTemplate)
    gbStar: TGroupBox;
    chbStar: TCheckBox;
    Label1: TLabel;
    cbSUa: TComboBox;
    cbSUb: TComboBox;
    Label2: TLabel;
    cbSUc: TComboBox;
    Label3: TLabel;
    gbSU: TGroupBox;
    rgSU: TRadioGroup;
    pnlSUf: TPanel;
    pnlSUl: TPanel;
    lblUl: TLabel;
    dbnSUl: TDBNumberEditEh;
    cbSejc: TComboBox;
    Label4: TLabel;
    cbSejb: TComboBox;
    Label5: TLabel;
    cbSEja: TComboBox;
    Label6: TLabel;
    gbSW: TGroupBox;
    dbnSF: TDBNumberEditEh;
    gbSR: TGroupBox;
    cbSF: TCheckBox;
    dbnSW: TDBNumberEditEh;
    cbSW: TCheckBox;
    Label7: TLabel;
    dbnSRa: TDBNumberEditEh;
    dbnSRb: TDBNumberEditEh;
    Label8: TLabel;
    dbnSRc: TDBNumberEditEh;
    Label9: TLabel;
    dbnSXla: TDBNumberEditEh;
    lblSXla: TLabel;
    dbnSXCa: TDBNumberEditEh;
    lblSXCa: TLabel;
    cbSLa: TDBComboBoxEh;
    cbSCa: TDBComboBoxEh;
    cbSCb: TDBComboBoxEh;
    dbnSXCb: TDBNumberEditEh;
    lblSXCb: TLabel;
    cbSlb: TDBComboBoxEh;
    dbnSXlb: TDBNumberEditEh;
    lblSXlb: TLabel;
    cbSCc: TDBComboBoxEh;
    dbnSXCc: TDBNumberEditEh;
    lblSXCc: TLabel;
    cbSlc: TDBComboBoxEh;
    dbnSxlc: TDBNumberEditEh;
    lblSXlc: TLabel;
    lblSR0: TLabel;
    dbnSR0: TDBNumberEditEh;
    gbTriangle: TGroupBox;
    gbTu: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Panel1: TPanel;
    Label21: TLabel;
    DBNumberEditEh3: TDBNumberEditEh;
    Panel2: TPanel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    cbTUa: TComboBox;
    cbTUb: TComboBox;
    cbTUc: TComboBox;
    cbTejc: TComboBox;
    cbTejb: TComboBox;
    cbTeja: TComboBox;
    gbTW: TGroupBox;
    dbnTf: TDBNumberEditEh;
    cbTf: TCheckBox;
    dbnTW: TDBNumberEditEh;
    cbTw: TCheckBox;
    gbTR: TGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    lblTXLa: TLabel;
    lblTXCa: TLabel;
    lblTXCb: TLabel;
    lblTXLb: TLabel;
    lblTXCc: TLabel;
    lblTXLc: TLabel;
    dbnTRa: TDBNumberEditEh;
    dbnTRb: TDBNumberEditEh;
    dbnTRc: TDBNumberEditEh;
    dbnTXla: TDBNumberEditEh;
    dbnTXCa: TDBNumberEditEh;
    cbTLa: TDBComboBoxEh;
    cbTCa: TDBComboBoxEh;
    cbTCb: TDBComboBoxEh;
    dbnTXCb: TDBNumberEditEh;
    cbTLb: TDBComboBoxEh;
    dbnTXlb: TDBNumberEditEh;
    cbTCc: TDBComboBoxEh;
    dbnTXcc: TDBNumberEditEh;
    cbTLc: TDBComboBoxEh;
    dbnTXlc: TDBNumberEditEh;
    chbTriangle: TCheckBox;
    procedure chbStarClick(Sender: TObject);
    procedure rgSUClick(Sender: TObject);
    procedure chbTriangleClick(Sender: TObject);
    procedure cbTfClick(Sender: TObject);
    procedure cbTwClick(Sender: TObject);
    procedure cbSFClick(Sender: TObject);
    procedure cbSWClick(Sender: TObject);
    procedure rgTuClick(Sender: TObject);
  protected
    // ініціалізація
    procedure InitDefaultValues; override;
    // Собственно, запускает выполнение задания
    procedure RunSolve; override;
    // Подготавливает введенные параметры для использования их в алгоритме
    procedure PrepareInputParams; override;
    // Проверяет, все ли параметры были введены корректно
    function CheckInputParams: Boolean; override;
    procedure RefreshToolbar; override;
    // Возвращает значение занесенное в контрол или -1 если ничего не занесено
    function GetControlValue(AControl: TDBNumberEditEh): Double; overload;
    function GetControlValue(AControl: TComboBox): Double; overload;
    function GetControlValue(AControl: TDBNumberEditEh; AScale: TDBComboBoxEh): Double; overload;
  end;

var
  frmMain: TfrmMain;

implementation

uses uCalc, uConstsShared, uConsts;

{$R *.dfm}
{ TfrmMain }

procedure TfrmMain.cbSFClick(Sender: TObject);
begin
  inherited;
  RefreshToolbar;
  if dbnSF.CanFocus then
    dbnSF.SetFocus;
end;

procedure TfrmMain.cbSWClick(Sender: TObject);
begin
  inherited;
  RefreshToolbar;
  if dbnSW.CanFocus then
    dbnSW.SetFocus;
end;

procedure TfrmMain.cbTfClick(Sender: TObject);
begin
  inherited;
  RefreshToolbar;
  if dbnTf.CanFocus then
    dbnTf.SetFocus;
end;

procedure TfrmMain.chbStarClick(Sender: TObject);
begin
  inherited;
  RefreshToolbar;
end;

procedure TfrmMain.chbTriangleClick(Sender: TObject);
begin
  inherited;
  RefreshToolbar;
end;

procedure TfrmMain.cbTwClick(Sender: TObject);
begin
  inherited;
  RefreshToolbar;
  if dbnTW.CanFocus then
    dbnTW.SetFocus;
end;

function TfrmMain.CheckInputParams: Boolean;
begin
  Result := inherited CheckInputParams;
end;

function TfrmMain.GetControlValue(AControl: TDBNumberEditEh;
  AScale: TDBComboBoxEh): Double;
begin
  if AControl.Text = '' then
    Result := cnstNotSetValue
  else
    Result := AControl.Value / AScale.Value;
end;

function TfrmMain.GetControlValue(AControl: TComboBox): Double;
begin
  Result := StrToFloatDef(AControl.Text, cnstNotSetValue);
end;

function TfrmMain.GetControlValue(AControl: TDBNumberEditEh): Double;
begin
  if AControl.Text = '' then
    Result := cnstNotSetValue
  else
    Result := AControl.Value;
end;

procedure TfrmMain.InitDefaultValues;
begin
  inherited;
  cbSLa.Value := 1000;
  cbSlb.Value := 1000;
  cbSlc.Value := 1000;

  cbTLa.Value := 1000;
  cbTLb.Value := 1000;
  cbTLc.Value := 1000;

  cbSCa.Value := 1000000;
  cbSCb.Value := 1000000;
  cbSCc.Value := 1000000;

  cbTCa.Value := 1000000;
  cbTCb.Value := 1000000;
  cbTCc.Value := 1000000;
end;

procedure TfrmMain.PrepareInputParams;
begin
  inherited;

end;

procedure TfrmMain.RefreshToolbar;
begin
  inherited;
  rgSU.Visible := chbStar.Checked;
  gbSU.Visible := chbStar.Checked;
  gbSW.Visible := chbStar.Checked;
  gbSR.Visible := chbStar.Checked;
  lblSR0.Visible := chbStar.Checked;
  dbnSR0.Visible := chbStar.Checked;

  gbTu.Visible := chbTriangle.Checked;
  gbTW.Visible := chbTriangle.Checked;
  gbTR.Visible := chbTriangle.Checked;

  dbnSF.Visible := cbSF.Checked;
  dbnTf.Visible := cbTf.Checked;

  dbnSW.Visible := cbSW.Checked;
  dbnTW.Visible := cbTw.Checked;

  pnlSUf.Visible := rgSU.ItemIndex = 0;
  pnlSUl.Visible := rgSU.ItemIndex = 1;

  cbSLa.Visible := cbSF.Checked or cbSW.Checked;
  cbSlb.Visible := cbSLa.Visible;
  cbSlc.Visible := cbSLa.Visible;
  cbSCa.Visible := cbSLa.Visible;
  cbSCb.Visible := cbSlb.Visible;
  cbSCc.Visible := cbSLa.Visible;
  if cbSLa.Visible then
  begin
    lblSXla.Caption := 'La=';
    lblSXCa.Caption := 'Ca=';
    lblSXlb.Caption := 'Lb=';
    lblSXCb.Caption := 'Cb=';
    lblSXlc.Caption := 'Lc=';
    lblSXCc.Caption := 'Cc=';
  end
  else
  begin
    lblSXla.Caption := 'XLa=';
    lblSXCa.Caption := 'XCa=';
    lblSXlb.Caption := 'XLb=';
    lblSXCb.Caption := 'XCb=';
    lblSXlc.Caption := 'XLc=';
    lblSXCc.Caption := 'XCc=';
  end;

  cbTLa.Visible := cbTf.Checked or cbTw.Checked;
  cbTLb.Visible := cbTLa.Visible;
  cbTLc.Visible := cbTLa.Visible;
  cbTCa.Visible := cbTLa.Visible;
  cbTCb.Visible := cbTLb.Visible;
  cbTCc.Visible := cbTLa.Visible;
  if cbSLa.Visible then
  begin
    lblTXLa.Caption := 'La=';
    lblTXCa.Caption := 'Ca=';
    lblTXLb.Caption := 'Lb=';
    lblTXCb.Caption := 'Cb=';
    lblTXLc.Caption := 'Lc=';
    lblTXCc.Caption := 'Cc=';
  end
  else
  begin
    lblTXLa.Caption := 'XLa=';
    lblTXCa.Caption := 'XCa=';
    lblTXLb.Caption := 'XLb=';
    lblTXCb.Caption := 'XCb=';
    lblTXLc.Caption := 'XLc=';
    lblTXCc.Caption := 'XCc=';
  end;

  if not dbnSF.Visible then
    dbnSF.Clear;
  if not dbnSW.Visible then
    dbnSW.Clear;

end;

procedure TfrmMain.rgSUClick(Sender: TObject);
begin
  inherited;
  RefreshToolbar;
end;

procedure TfrmMain.rgTuClick(Sender: TObject);
begin
  inherited;
  RefreshToolbar;
end;

procedure TfrmMain.RunSolve;
var
  vMainSchema: TMainSchema;
  vSchemaType: TSchemaTypeSet;
  vSolver: TSolveOutput;
begin
  inherited;
  vSchemaType := [];
  if chbStar.Checked then
    vSchemaType := vSchemaType + [stStar];
  if chbTriangle.Checked then
    vSchemaType := vSchemaType + [stTriangle];
  vMainSchema := TMainSchema.Create(vSchemaType);
  if stStar in vSchemaType then
    with vMainSchema.SchemaStar do
    begin
      f := GetControlValue(dbnSF);
      W := GetControlValue(dbnSW);
      R0 := GetControlValue(dbnSR0);
      if rgSU.ItemIndex = 0 then
      begin
        NodeA.U := GetControlValue(cbSUa);
        NodeB.U := GetControlValue(cbSUb);
        NodeC.U := GetControlValue(cbSUc);
      end
      else
        Ul := GetControlValue(dbnSUl);

      NodeA.ej := GetControlValue(cbSEja);
      NodeB.ej := GetControlValue(cbSejb);
      NodeC.ej := GetControlValue(cbSejc);

      NodeA.R := GetControlValue(dbnSRa);
      NodeB.R := GetControlValue(dbnSRb);
      NodeC.R := GetControlValue(dbnSRc);

      if (f <> cnstNotSetValue) or (W <> cnstNotSetValue) then
      begin
        NodeA.SetX(GetControlValue(dbnSXla,cbSLa), GetControlValue(dbnSXCa,cbSCa), f, W);
        NodeB.SetX(GetControlValue(dbnSXlb,cbSLb), GetControlValue(dbnSXCb,cbSCb), f, W);
        NodeC.SetX(GetControlValue(dbnSxlc,cbSLc), GetControlValue(dbnSXCc,cbSCc), f, W);
      end
      else
      begin
        NodeA.SetX(GetControlValue(dbnSXla), GetControlValue(dbnSXCa));
        NodeB.SetX(GetControlValue(dbnSXlb), GetControlValue(dbnSXCb));
        NodeC.SetX(GetControlValue(dbnSxlc), GetControlValue(dbnSXCc));
      end;
    end;

  if stTriangle in vSchemaType then
    with vMainSchema.SchemaTriang do
    begin
      f := GetControlValue(dbnTf);
      W := GetControlValue(dbnTW);
       //TO DO
     // R0 := GetControlValue(dbnTR0);
      NodeA.U := GetControlValue(cbTUa);
      NodeB.U := GetControlValue(cbTUb);
      NodeC.U := GetControlValue(cbTUc);

      NodeA.ej := GetControlValue(cbTeja);
      NodeB.ej := GetControlValue(cbTejb);
      NodeC.ej := GetControlValue(cbTejc);

      NodeA.R := GetControlValue(dbnTRa);
      NodeB.R := GetControlValue(dbnTRb);
      NodeC.R := GetControlValue(dbnTRc);

     if (f <> cnstNotSetValue) or (W <> cnstNotSetValue) then
      begin
        NodeA.SetX(GetControlValue(dbnTXla)/cbTLa.Value, GetControlValue(dbnTXCa)/cbTCa.Value, f, W);
        NodeB.SetX(GetControlValue(dbnTXlb)/cbTLb.Value, GetControlValue(dbnTXCb)/cbTCb.Value, f, W);
        NodeC.SetX(GetControlValue(dbnTxlc)/cbTLc.Value, GetControlValue(dbnTXCc)/cbTCc.Value, f, W);
      end
      else
      begin
        NodeA.SetX(GetControlValue(dbnTXla), GetControlValue(dbnTXCa));
        NodeB.SetX(GetControlValue(dbnTXlb), GetControlValue(dbnTXCb));
        NodeC.SetX(GetControlValue(dbnTxlc), GetControlValue(dbnTXCc));
      end;
    end;

  vSolver := TSolveOutput.Create(rvMain, vMainSchema);
  vSolver.RunSolve;

end;

end.
