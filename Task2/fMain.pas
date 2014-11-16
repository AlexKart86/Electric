unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fMainTemplate, RVStyle, Vcl.StdCtrls,
  Vcl.ExtCtrls, Ruler, RVRuler, RVScroll, RichView, RVEdit, Vcl.ComCtrls,
  DBGridEhGrouping, ToolCtrlsEh, GridsEh, DBGridEh, MemTableDataEh, Db,
  MemTableEh, Vcl.DBCtrls, Vcl.Mask, DBCtrlsEh, Vcl.ImgList, Vcl.Buttons;

type
  TfrmMain = class(TfrmMainTemplate)
    dbgU: TDBGridEh;
    memU: TMemTableEh;
    memUUType: TIntegerField;
    dsU: TDataSource;
    memUVALUE: TFloatField;
    dbnU: TDBNavigator;
    dbnI: TDBNumberEditEh;
    lblI: TLabel;
    GroupBox1: TGroupBox;
    ilU: TImageList;
    btnAdd: TBitBtn;
    procedure memUBeforeInsert(DataSet: TDataSet);
    procedure btnAddClick(Sender: TObject);
  protected
   procedure InitDefaultValues; override;
    // Собственно, запускает выполнение задания
    procedure RunSolve; override;
    // Подготавливает введенные параметры для использования их в алгоритме
    procedure PrepareInputParams; override;
    // Проверяет, все ли параметры были введены корректно
    function CheckInputParams: Boolean; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  uCalc, uElements;

{ TfrmMain }

procedure TfrmMain.btnAddClick(Sender: TObject);
begin
  inherited;
  if memU.State in dsEditModes then
    memU.Post;
  memU.Next;
  if (memU.RecordCount < 2) or memU.Eof then
   memU.Append
  else
    memU.Insert;
end;

function TfrmMain.CheckInputParams: Boolean;
//var vIsRExists: Boolean;
begin
  Result := False;
  if VarIsNull(dbnI.Value) then
  begin
    MessageDlg('Не вказано струм', mtError, [mbOk], 0);
    dbnI.SetFocus;
    Exit;
  end;

  //vIsRExists := False;
  memU.First;
  while not memU.Eof do
  begin
   {if memUUType.Value = Ord(arRight) then
     vIsRExists :=True; }

    if memUUType.IsNull then
    begin
      MessageDlg('Не вказаний напрям розташування напруги', mtError, [mbOk], 0);
      dbgU.Col := 0;
      Exit;
    end;
    if memUVALUE.IsNull then
    begin
      MessageDlg('Не вказане значення напруги', mtError, [mbOk], 0);
      dbgU.Col := 1;
      Exit;
    end;
    memU.Next;
  end;
 { if not vIsRExists then
  begin
    MessageDlg('У колі має бути хоча б один резистор!',mtError, [mbOk], 0);
    Exit;
  end; }
  Result := true;
end;

procedure TfrmMain.InitDefaultValues;
begin
  inherited;
  memUVALUE.ValidChars := memUVALUE.ValidChars + ['.'];
end;

procedure TfrmMain.memUBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  memU.Next;
end;

procedure TfrmMain.PrepareInputParams;
begin
  inherited;
  //nothing do
end;

procedure TfrmMain.RunSolve;
var
  vSchema: TSchema;
  vSolver: TSolver;
begin
  inherited;
  vSchema := TSchema.Create;
  vSolver := TSolver.Create(vSchema, rvMain);
  try
    vSchema.I := dbnI.Value;
    memU.First;
    while not memU.Eof do
    begin
      vSchema.AddElement(memUVALUE.Value, TElementOrientation(memUUType.Value));
      memU.Next;
    end;
    vSolver.RunSolve;
  finally
    FreeAndNil(vSchema);
    FreeAndNil(vSolver);
  end;
end;

end.
