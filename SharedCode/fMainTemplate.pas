unit fMainTemplate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Grids, RVStyle, RVScroll, RichView, RVEdit,
  Ruler, RVRuler, VCLTee.TeEngine, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.Series, VCLTee.TeeSpline;

type
  TfrmMainTemplate = class(TForm)
    pcMain: TPageControl;
    tsFirst: TTabSheet;
    tsResults: TTabSheet;
    pnlFooter: TPanel;
    btnCalc: TButton;
    btnCancel: TButton;
    rgLanguage: TRadioGroup;
    btnSaveToFile: TButton;
    btnPrev: TButton;
    dlgSave: TSaveDialog;
    RVStyle1: TRVStyle;
    rvMain: TRichViewEdit;
    RVRuler1: TRVRuler;
    tsHidden: TTabSheet;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCalcClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure rgLanguageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    procedure RefreshToolbar;  virtual;
    procedure RefreshBtnsVisible; virtual;
    procedure RefreshLanguage; virtual;
     // ініціалізація
    procedure InitDefaultValues; virtual; abstract;
    // Собственно, запускает выполнение задания
    procedure RunSolve; virtual; abstract;
    // Подготавливает введенные параметры для использования их в алгоритме
    procedure PrepareInputParams; virtual; abstract;
    // Проверяет, все ли параметры были введены корректно
    function CheckInputParams: Boolean; virtual;
  public
  end;

implementation

uses uLocalizeShared, uFormulaUtils, uConstsShared;

{$R *.dfm}
{ TfrmMainTemplate }

procedure TfrmMainTemplate.btnCalcClick(Sender: TObject);
begin
  // Проверяем корректность введенных параметров
  if not CheckInputParams then
    Exit;
  PrepareInputParams;
  RunSolve;
  pcMain.ActivePage := tsResults;
  RefreshBtnsVisible;
end;

procedure TfrmMainTemplate.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMainTemplate.btnPrevClick(Sender: TObject);
begin
  pcMain.ActivePage := tsFirst;
  RefreshBtnsVisible;
end;

procedure TfrmMainTemplate.btnSaveToFileClick(Sender: TObject);
begin
  if dlgSave.Execute then
    rvMain.SaveRTF(dlgSave.FileName, False);
end;

function TfrmMainTemplate.CheckInputParams: Boolean;
begin
  // TO Do
  Result := True;
end;

procedure TfrmMainTemplate.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator := '.';
end;

procedure TfrmMainTemplate.FormShow(Sender: TObject);
begin
  pcMain.ActivePage := tsFirst;
  RefreshBtnsVisible;
  InitDefaultValues;
  RefreshToolbar;
  RefreshLanguage;
end;



procedure TfrmMainTemplate.pcMainChange(Sender: TObject);
begin
  RefreshBtnsVisible;
end;


procedure TfrmMainTemplate.RefreshBtnsVisible;
begin
  btnSaveToFile.Visible := pcMain.ActivePage = tsResults;
  btnCalc.Visible := pcMain.ActivePage = tsFirst;
  btnPrev.Visible := pcMain.ActivePage = tsResults;
end;

procedure TfrmMainTemplate.RefreshLanguage;
begin
  if rgLanguage.ItemIndex = 0 then
    CurrentLang := lngUkr;
  if rgLanguage.ItemIndex = 1 then
    CurrentLang := lngRus;
end;

procedure TfrmMainTemplate.RefreshToolbar;
begin

end;

procedure TfrmMainTemplate.rgLanguageClick(Sender: TObject);
begin
  RefreshLanguage;
end;

end.
