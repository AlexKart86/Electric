unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fMainTemplate, RVStyle, Vcl.StdCtrls,
  Vcl.ExtCtrls, Ruler, RVRuler, RVScroll, RichView, RVEdit, Vcl.ComCtrls,
  JvComponentBase, JvInterpreter, Vcl.Tabs, Vcl.Mask, DBCtrlsEh, MemTableDataEh,
  Db, MemTableEh, uCalc;

type

  TWType = (sf, sW, sNone);

  TfrmMain = class(TfrmMainTemplate)
    gbStar: TGroupBox;
    chbStar: TCheckBox;
    gbSU: TGroupBox;
    cbSejc: TComboBox;
    Label4: TLabel;
    cbSejb: TComboBox;
    Label5: TLabel;
    cbSEja: TComboBox;
    Label6: TLabel;
    gbSR: TGroupBox;
    lblRa: TLabel;
    dbnSRa: TDBNumberEditEh;
    dbnSRb: TDBNumberEditEh;
    lblRb: TLabel;
    dbnSRc: TDBNumberEditEh;
    lblRc: TLabel;
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
    cbTejc: TComboBox;
    cbTejb: TComboBox;
    cbTeja: TComboBox;
    gbTR: TGroupBox;
    lblRab: TLabel;
    lblRbc: TLabel;
    lblRac: TLabel;
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
    rgUType: TRadioGroup;
    gbW: TGroupBox;
    cbF: TCheckBox;
    dbnW: TDBNumberEditEh;
    cbW: TCheckBox;
    gbU: TGroupBox;
    cbU: TComboBox;
    MemTableEh1: TMemTableEh;
    btnRounds: TButton;
    grp1: TGroupBox;
    dbnDiagramSize: TDBNumberEditEh;
    btnEditDiagram: TButton;
    chkIsR0Infty: TCheckBox;
    chkIsSimpleMode: TCheckBox;
    grpAvaria: TGroupBox;
    grpFaza: TGroupBox;
    chkFazaA: TCheckBox;
    chkFazaB: TCheckBox;
    chkFazaC: TCheckBox;
    grpLin: TGroupBox;
    chkLinA: TCheckBox;
    chkLinB: TCheckBox;
    chkLinC: TCheckBox;
    procedure chbStarClick(Sender: TObject);
    procedure rgUTypeClick(Sender: TObject);
    procedure chbTriangleClick(Sender: TObject);
    procedure cbFClick(Sender: TObject);
    procedure cbWClick(Sender: TObject);
    procedure rgTuClick(Sender: TObject);
    procedure btnRoundsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnEditDiagramClick(Sender: TObject);
    procedure chkIsR0InftyClick(Sender: TObject);
    procedure chkIsSimpleModeClick(Sender: TObject);
    procedure RefreshAvariaCheckBoxes(Sender: TObject);
  private
    FAvariaFazaCheckBoxes: array[1..3] of TCheckBox;
    FAvariaLinCheckBoxes: array[1..3] of TCheckBox;
    FAvariaCheckBoxes: array[1..6] of TCheckBox;
    vSolver: TSolveOutput;
    WType: TWType;
    procedure RecalcWType;
    procedure InitRounds;
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
    function GetControlValue(AControl: TDBNumberEditEh; AScale: TDBComboBoxEh)
      : Double; overload;
    procedure RefreshBtnsVisible; override;
    procedure SetControlEnabled(AValue: Boolean; AControls: array of TCustomEdit); overload;
    procedure SetControlEnabled(AValue: Boolean; AControls: array of TLabel); overload;

  end;

  TCrackedCustomEdit = class(TCustomEdit)

  end;

var
  frmMain: TfrmMain;


implementation

uses uConstsShared, uConsts, uRounding, fEditRounding, fEditDiagram,
  uFormulaUtils, Math;


{$R *.dfm}
{ TfrmMain }

procedure TfrmMain.btnEditDiagramClick(Sender: TObject);
begin
  inherited;
  EditDiagramExecute(vSolver);
  vSolver.SplitScaleAndDiagram;
end;

procedure TfrmMain.btnRoundsClick(Sender: TObject);
begin
  inherited;
  EditRounding;
end;

procedure TfrmMain.cbFClick(Sender: TObject);
begin
  inherited;
  if cbF.Checked then
    cbW.Checked := False;
  RefreshToolbar;

  if dbnW.CanFocus then
    dbnW.SetFocus;
end;

procedure TfrmMain.cbWClick(Sender: TObject);
begin
  inherited;
  if cbW.Checked then
    cbF.Checked := False;

  RefreshToolbar;
  if dbnW.CanFocus then
    dbnW.SetFocus;
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

function TfrmMain.CheckInputParams: Boolean;
begin
  Result := inherited CheckInputParams;
end;

procedure TfrmMain.chkIsR0InftyClick(Sender: TObject);
begin
  inherited;
  RefreshToolbar;
end;

procedure TfrmMain.chkIsSimpleModeClick(Sender: TObject);
begin
  inherited;
  RefreshToolbar;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  InitRounds;
  vSolver := nil;
  FAvariaFazaCheckBoxes[1] := chkFazaA;
  FAvariaFazaCheckBoxes[2] := chkFazaB;
  FAvariaFazaCheckBoxes[3] := chkFazaC;
  FAvariaLinCheckBoxes[1] := chkLinA;
  FAvariaLinCheckBoxes[2] := chkLinB;
  FAvariaLinCheckBoxes[3] := chkLinC;
  for I := 1 to 3 do
    FAvariaCheckBoxes[i] := FAvariaFazaCheckBoxes[i];

  for I := 4 to 6 do
    FAvariaCheckBoxes[i] := FAvariaLinCheckBoxes[i-3];
end;

function TfrmMain.GetControlValue(AControl: TDBNumberEditEh;
  AScale: TDBComboBoxEh): Double;
begin
  if (StrToFloatDef(AControl.Text, 0) = 0) or not AControl.Enabled then
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
  if (StrToFloatDef(AControl.Text, 0) = 0) or not AControl.Enabled then
    Result := cnstNotSetValue
  else
    Result := AControl.Value
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

  RecalcWType;
end;

procedure TfrmMain.InitRounds;
begin
  RndArr.AddType('Напруга', cU);
  RndArr.AddType('Сила струму', cI);
  RndArr.AddType('Опір', cR);
  RndArr.AddType('Кут', cPhi);
  RndArr.AddType('Потужність', cP);
  RndArr.AddType('Частота', cW);
  RndArr.AddType('Ємність', cC, 6);
  RndArr.AddType('Індуктивність', cL, 3);

end;

procedure TfrmMain.PrepareInputParams;
begin
  inherited;

end;

procedure TfrmMain.RecalcWType;
begin
  WType := sNone;
  if cbW.Checked then
    WType := sW;
  if cbF.Checked then
    WType := sf;
end;

procedure TfrmMain.RefreshAvariaCheckBoxes(Sender: TObject);
var
  i: Integer;
  vCheckBox: TCheckBox;
begin
  vCheckBox :=  TCheckBox(Sender);
  if vCheckBox.Checked then
  begin
    //Сбрасываем все остальные чекбоксы
    for i := Low(FAvariaCheckBoxes) to High(FAvariaCheckBoxes) do
      if FAvariaCheckBoxes[i] <> vCheckBox then
        FAvariaCheckBoxes[i].Checked := False;
  end;

  RefreshToolbar;

end;

procedure TfrmMain.RefreshBtnsVisible;
begin
  inherited;
  btnRounds.Visible := pcMain.ActivePage = tsFirst;
  btnEditDiagram.Visible := pcMain.ActivePage = tsResults;
end;

procedure TfrmMain.RefreshToolbar;
begin
  inherited;

  RecalcWType;

  gbSU.Visible := chbStar.Checked;
  gbSR.Visible := chbStar.Checked;
  lblSR0.Visible := chbStar.Checked;
  dbnSR0.Visible := chbStar.Checked;
  chkIsR0Infty.Visible := chbStar.Checked;

  gbTu.Visible := chbTriangle.Checked;
  gbTR.Visible := chbTriangle.Checked;

  cbSLa.Visible := WType <> sNone;
  dbnW.Visible := cbSLa.Visible;
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

    lblTXLa.Caption := 'Lab=';
    lblTXCa.Caption := 'Cab=';
    lblTXLb.Caption := 'Lbc=';
    lblTXCb.Caption := 'Cbc=';
    lblTXLc.Caption := 'Lca=';
    lblTXCc.Caption := 'Cca=';

  end
  else
  begin
    lblSXla.Caption := 'XLa=';
    lblSXCa.Caption := 'XCa=';
    lblSXlb.Caption := 'XLb=';
    lblSXCb.Caption := 'XCb=';
    lblSXlc.Caption := 'XLc=';
    lblSXCc.Caption := 'XCc=';

    lblTXLa.Caption := 'XLab=';
    lblTXCa.Caption := 'XCab=';
    lblTXLb.Caption := 'XLbc=';
    lblTXCb.Caption := 'XCbc=';
    lblTXLc.Caption := 'XLca=';
    lblTXCc.Caption := 'XCca=';

  end;

  cbTLa.Visible := WType <> sNone;
  cbTLb.Visible := cbTLa.Visible;
  cbTLc.Visible := cbTLa.Visible;
  cbTCa.Visible := cbTLa.Visible;
  cbTCb.Visible := cbTLb.Visible;
  cbTCc.Visible := cbTLa.Visible;

  dbnSR0.Enabled := not chkIsR0Infty.Checked and not chkIsSimpleMode.Checked;
  chkIsR0Infty.Enabled := not chkIsSimpleMode.Checked;

  //Для смешанного соединения аварийный режим работы не показывается
  grpAvaria.Visible := not (chbStar.Checked and chbTriangle.Checked);
  if grpAvaria.Visible then
  begin
    if chbStar.Checked then
    begin
      grpFaza.Caption := 'КЗ фази';
      chkFazaA.Caption := 'Фаза "А"';
      chkFazaB.Caption := 'Фаза "В"';
      chkFazaC.Caption := 'Фаза "С"';
    end
    else
    begin
      grpFaza.Caption := 'Обрив фази навантаження';
      chkFazaA.Caption := 'Фаза "АВ"';
      chkFazaB.Caption := 'Фаза "ВС"';
      chkFazaC.Caption := 'Фаза "СА"';
    end;
  end;


  SetControlEnabled(not( (chkFazaA.Checked or (chkLinA.Checked and chbStar.Checked) ) and grpAvaria.Visible), [dbnSra, dbnSXla, cbSla, dbnSXCa, cbSCa, dbnTRa,
                                                    dbnTXla, cbTLa, dbnTXCa, cbTCa]);
  SetControlEnabled(not( (chkFazaA.Checked  or (chkLinA.Checked and chbStar.Checked)) and grpAvaria.Visible), [lblRa, lblSXla, lblSXCa,
                                                                  lblRab, lblTXLa, lblTXCa]);

  SetControlEnabled(not( (chkFazaB.Checked or (chkLinB.Checked and chbStar.Checked)) and grpAvaria.Visible), [dbnSrb, dbnSXlb, cbSlb, dbnSXCb, cbSCb, dbnTRb,
                                                    dbnTXlb, cbTLb, dbnTXCb, cbTCb]);
  SetControlEnabled(not( (chkFazaB.Checked or (chkLinB.Checked and chbStar.Checked)) and grpAvaria.Visible), [lblRb, lblSXlb, lblSXCb,
                                                                  lblRbc, lblTXLb, lblTXCb]);

  SetControlEnabled(not( (chkFazaC.Checked or (chkLinC.Checked and chbStar.Checked)) and grpAvaria.Visible), [dbnSrc, dbnSXlc, cbSlc, dbnSXCc, cbSCc, dbnTRc,
                                                    dbnTXlc, cbTLc, dbnTXCc, cbTCc]);
  SetControlEnabled(not( (chkFazaC.Checked or (chkLinC.Checked and chbStar.Checked)) and grpAvaria.Visible), [lblRc, lblSXlc, lblSXCc,
                                                                  lblRac, lblTXLc, lblTXCc]);


  chkIsSimpleMode.Visible := not( chkFazaA.Checked or chkFazaB.Checked or chkFazaC.Checked
    or chkLinA.Checked or chkLinB.Checked or chkLinC.Checked);

  if chbStar.Checked and (chkFazaA.Checked or chkFazaB.Checked or chkFazaC.Checked)
     then
  begin
    chkIsR0Infty.Checked := True;
    chkIsR0Infty.Enabled := False
  end
  else
  begin
   chkIsR0Infty.Enabled := True;
  end;



end;

procedure TfrmMain.rgUTypeClick(Sender: TObject);
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
begin
  inherited;
  vSchemaType := [];

  fCoordsCache.EmptyTable;

  if chbStar.Checked then
    vSchemaType := vSchemaType + [stStar];
  if chbTriangle.Checked then
    vSchemaType := vSchemaType + [stTriangle];
  vMainSchema := TMainSchema.Create(vSchemaType);
  vMainSchema.IsSimpleMode := chkIsSimpleMode.Checked;
  vMainSchema.DiagramSize := dbnDiagramSize.Value;

  case WType of
    sW:
      vMainSchema.W := GetControlValue(dbnW);
    sf:
      vMainSchema.f := GetControlValue(dbnW);
  end;

  if not dbnSR0.Visible then
    vMainSchema.R0 := 0
  else
  begin
    if chkIsR0Infty.Checked then
      vMainSchema.R0 := infinity
    else
    begin
      vMainSchema.R0 := GetControlValue(dbnSR0);
       if vMainSchema.R0 <0  then
         vMainSchema.R0 := 0;
    end;
  end;

  if rgUType.ItemIndex = 0 then
    vMainSchema.Uf := GetControlValue(cbU)
  else
    vMainSchema.Ul := GetControlValue(cbU);

  if stStar in vSchemaType then
    with vMainSchema.SchemaStar do
    begin
      NodeA.ej := GetControlValue(cbSEja);
      NodeB.ej := GetControlValue(cbSejb);
      NodeC.ej := GetControlValue(cbSejc);

      NodeA.R := GetControlValue(dbnSRa);
      NodeB.R := GetControlValue(dbnSRb);
      NodeC.R := GetControlValue(dbnSRc);

      if WType <> sNone then
      begin
        NodeA.SetX(GetControlValue(dbnSXla, cbSLa),
          GetControlValue(dbnSXCa, cbSCa), vMainSchema.f, vMainSchema.W);
        NodeB.SetX(GetControlValue(dbnSXlb, cbSlb),
          GetControlValue(dbnSXCb, cbSCb), vMainSchema.f, vMainSchema.W);
        NodeC.SetX(GetControlValue(dbnSxlc, cbSlc),
          GetControlValue(dbnSXCc, cbSCc), vMainSchema.f, vMainSchema.W);
      end
      else
      begin
        NodeA.SetX(GetControlValue(dbnSXla), GetControlValue(dbnSXCa));
        NodeB.SetX(GetControlValue(dbnSXlb), GetControlValue(dbnSXCb));
        NodeC.SetX(GetControlValue(dbnSxlc), GetControlValue(dbnSXCc));
      end;


      //Выставляем флаги аварийного режима работы
      if vSchemaType = [stStar] then
      begin
        NodeA.IsBadLin := False;
        NodeB.IsBadLin := False;
        NodeC.IsBadLin := False;

       NodeA.IsBadR0 := chkFazaA.Checked and grpAvaria.Visible;
       NodeA.IsBadRInf := chkLinA.Checked and grpAvaria.Visible;

       NodeB.IsBadR0 := chkFazaB.Checked and grpAvaria.Visible;
       NodeB.IsBadRInf := chkLinB.Checked and grpAvaria.Visible;

       NodeC.IsBadR0 := chkFazaC.Checked and grpAvaria.Visible;
       NodeC.IsBadRInf := chkLinC.Checked and grpAvaria.Visible;
      end;
    end;

  if stTriangle in vSchemaType then
    with vMainSchema.SchemaTriang do
    begin

      NodeA.ej := GetControlValue(cbTeja);
      NodeB.ej := GetControlValue(cbTejb);
      NodeC.ej := GetControlValue(cbTejc);

      NodeA.R := GetControlValue(dbnTRa);
      NodeB.R := GetControlValue(dbnTRb);
      NodeC.R := GetControlValue(dbnTRc);

      if WType <> sNone then
      begin
        NodeA.SetX(GetControlValue(dbnTXla, cbTLa),
          GetControlValue(dbnTXCa, cbTCa), vMainSchema.f, vMainSchema.W);
        NodeB.SetX(GetControlValue(dbnTXlb, cbTLb),
          GetControlValue(dbnTXCb, cbTCb), vMainSchema.f, vMainSchema.W);
        NodeC.SetX(GetControlValue(dbnTXlc, cbTLc),
          GetControlValue(dbnTXcc, cbTCc), vMainSchema.f, vMainSchema.W);
      end
      else
      begin
        NodeA.SetX(GetControlValue(dbnTXla), GetControlValue(dbnTXCa));
        NodeB.SetX(GetControlValue(dbnTXlb), GetControlValue(dbnTXCb));
        NodeC.SetX(GetControlValue(dbnTXlc), GetControlValue(dbnTXcc));
      end;

      if vSchemaType = [stTriangle] then
      begin
        NodeA.IsBadR0 := False;
        NodeB.IsBadR0 := False;
        NodeC.IsBadR0 := False;

        NodeA.IsBadRInf := chkFazaA.Checked and grpAvaria.Visible;
        NodeB.IsBadRInf := chkFazaB.Checked and grpAvaria.Visible;
        NodeC.IsBadRInf := chkFazaC.Checked and grpAvaria.Visible;

        NodeA.IsBadLin :=  chkLinA.Checked and grpAvaria.Visible;
        NodeB.IsBadLin :=  chkLinB.Checked and grpAvaria.Visible;
        NodeC.IsBadLin :=  chkLinC.Checked and grpAvaria.Visible;
      end;

    end;

  if Assigned(vSolver) then
    FreeAndNil(vSolver);
  vSolver := TSolveOutput.Create(rvMain, vMainSchema);
  vSolver.RunSolve;

end;

procedure TfrmMain.SetControlEnabled(AValue: Boolean; AControls: array of TLabel);
var
  vControl: TLabel;
begin
  for vControl in AControls do
    vControl.Font.Color := ifThen(AValue, clBlack, clGrayText);
end;

procedure TfrmMain.SetControlEnabled(AValue: Boolean; AControls: array of TCustomEdit);
var
  vControl: TCustomEdit;
begin
  for vControl in AControls do
    begin
      vControl.Enabled := AValue;
      TCrackedCustomEdit(vControl).Color := IfThen(AValue, clWindow, clInactiveCaption)
    end;
end;

end.
