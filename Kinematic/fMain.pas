unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fMainTemplate, RVStyle, Vcl.StdCtrls,
  Vcl.ExtCtrls, Ruler, RVRuler, RVScroll, RichView, RVEdit, Vcl.ComCtrls,
  Vcl.Imaging.GIFImg, PNGimage;

type
  TfrmMain = class(TfrmMainTemplate)
    edtXt: TLabeledEdit;
    edtYt: TLabeledEdit;
    edtt1: TLabeledEdit;
    edtDigits: TLabeledEdit;
    grp1: TGroupBox;
    edtMint: TLabeledEdit;
    edtMaxt: TLabeledEdit;
    edtMinx: TLabeledEdit;
    edtMaxx: TLabeledEdit;
    edtMaxy: TLabeledEdit;
    edtMiny: TLabeledEdit;
    btnDrawGraph: TButton;
    procedure btnDrawGraphClick(Sender: TObject);
  protected
    img: TPngImage;
    procedure InitDefaultValues; override;
    procedure PrepareInputParams; override;

    //Подготавливает файл с параметрами для питона
    procedure CreateParamsFile;

    //Парсит файл out.txt и формирует результат
    procedure TransformResults;

    procedure RunSolve; override;
    procedure PrintTask;
    procedure PrintAnswer;
    //Рисует график
    procedure PrintGraph;
    procedure RefreshBtnsVisible; override;
  end;

var
  frmMain: TfrmMain;

implementation
uses uSystem, RegularExpressions, uFormulaUtils, RvTable, fEditGraphic;

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.btnDrawGraphClick(Sender: TObject);
begin
  inherited;
  ShowGraphEdit(img, PrintGraph);
end;

procedure TfrmMain.CreateParamsFile;
var vStrList: TStringList;
begin
  vStrList := TStringList.Create;
  try
    vStrList.Add(edtXt.Text);
    vStrList.Add(edtYt.Text);
    vStrList.Add(edtt1.Text);
    vStrList.Add(edtMint.Text);
    vStrList.Add(edtMaxt.Text);
    vStrList.Add(edtMinx.Text);
    vStrList.Add(edtMaxx.Text);
    vStrList.Add(edtMiny.Text);
    vStrList.Add(edtMaxy.Text);
    vStrList.Add(edtDigits.Text);
    if rgLanguage.ItemIndex = 0 then
      vStrList.Add('ukr.txt')
    else
      vStrList.Add('rus.txt');
    vStrList.SaveToFile('params.txt');
  finally
    FreeAndNil(vStrList);
  end;
end;

procedure TfrmMain.InitDefaultValues;
begin
  inherited;
end;

procedure TfrmMain.PrepareInputParams;
begin

end;

procedure TfrmMain.PrintAnswer;
var
  vtbl: TRVTableItemInfo;
  i: Integer;
  j: Integer;
  vText, vFormulas: TArray<String>;


  procedure AddMs(i,j: Integer);
  begin
    vtbl.Cells[i,j].AddTextNL(', м/с', -1, -1, 0);
  end;

  procedure AddMs2(i,j: Integer);
  begin
    vtbl.Cells[i,j].AddTextNL(', м/с', -1, -1, 0);
    vtbl.Cells[i,j].AddTextNL('2', 7, -1, 0);
  end;


begin
  // Создаем табличку для вывода результатов
  vtbl := TRVTableItemInfo.CreateEx(11, 4, rvMain.RVData);
  //Наводим границы
  vtbl.BorderColor := clBlack;
  vtbl.BorderWidth := 1;
  vtbl.BorderStyle := rvtbColor;
  vtbl.BorderLightColor := clBlack;
  vtbl.VRuleColor := clBlack;
  vtbl.VRuleWidth := 1;
  vtbl.HRuleWidth := 1;
  vtbl.HRuleColor := clBlack;

  rvMain.InsertItem('table_results', vtbl);


  //Заполняем первую колонку
  ParseFile('res_1.txt', vText, vFormulas);
  for I := 0 to High(vFormulas) do
  begin
    vtbl.Cells[i, 0].Clear;
    RVAddFormulaTex(vFormulas[i], vtbl.Cells[i, 0]);
  end;

  AddMs(4,1);
  AddMs(3,1);
  AddMs(2,1);
  AddMs2(5,1);
  AddMs2(6,1);
  AddMs2(7,1);

  AddMs(4,3);
  AddMs(3,3);
  AddMs(2,3);
  AddMs2(5,3);
  AddMs2(6,3);
  AddMs2(7,3);
  AddMs2(8,3);
  AddMs2(9,3);
  vtbl.Cells[10,3].AddTextNL(', м', -1, -1, 0);

  //Заполняем третью строчку
  ParseFile('res_2.txt', vText, vFormulas);
  for I := 0 to High(vFormulas) do
  begin
    vtbl.Cells[i, 2].Clear;
    RVAddFormulaTex(vFormulas[i], vtbl.Cells[i, 2]);
  end;

  for I := 0 to 9 do
   vtbl.ResizeRow(i, 20);

   vtbl.ResizeCol(1, 80, True);
   vtbl.ResizeCol(3, 80, True);
   vtbl.ResizeCol(0, 130, True);
   vtbl.ResizeCol(2, 130, True);
end;

//Добавляет график функции
procedure TfrmMain.PrintGraph;
begin
  //Рисуем график
  RunCommand('python', '"'+GetAppPath+'print_graph.py"');
  img.LoadFromFile(GetAppPath + 'img.png');
end;

procedure TfrmMain.PrintTask;
var
  vtbl: TRVTableItemInfo;
  vStr: String;
  vBitmap: TBitmap;
  i: Integer;
  vText, vFormulas: TArray<string>;

  procedure AddText(AText: String; IsCR: Boolean = false);
  var
    vParaNo: Integer;
  begin
    if IsCR then
      vParaNo := 0
    else
      vParaNo := -1;
    vtbl.Cells[0, 0].AddTextNL(AText, 0, vParaNo, 0);
  end;

  procedure AddFormulaValue(AFormula, AValue: String; ASuffix: String = '');
  var
    vStr: String;
  begin
    if AValue <> '' then
      vStr := AFormula + '=' + AValue
    else
      vStr := AFormula;
    RVAddFormula(vStr, vtbl.Cells[0, 0]);
    if ASuffix <> '' then
      AddText(' ' + ASuffix);
  end;

begin
  // Создаем табличку для вывода условия
  vtbl := TRVTableItemInfo.CreateEx(1, 2, rvMain.RVData);
  rvMain.InsertItem('table1', vtbl);
  // Граница не видна
  vtbl.VisibleBorders.SetAll(false);
  // Видна вертикальная черта
  vtbl.VRuleColor := clBlack;
  vtbl.VRuleWidth := 1;

  // Заполняем то, что дано.
  vtbl.Cells[0, 0].Clear;
  vtbl.Cells[0, 0].AddTextNLW('Дано:', 0, 0, 0, True);

  RunCommand('python', '"'+GetAppPath+'print_task.py"');
  ParseFile('out_task.txt', vText, vFormulas);
  for i := 0 to High(vText) do
  begin
    AddText(vText[i]);
    if i<=High(vFormulas) then
       RVAddFormulaTex(vFormulas[i], vtbl.Cells[0, 0]);
    end;

  vtbl.Cells[0, 0].AddBreak;

  // Пишем, что надо найти

  if rgLanguage.ItemIndex = 0 then
    AddText('Знайти:', True)
  else
    AddText('Найти:', True);

  RVAddFormulaTex('y(x)', vtbl.Cells[0, 0]);
  RVAddFormulaTex('v_x, \; v_y', vtbl.Cells[0, 0]);
  RVAddFormulaTex('cos(ox, \overrightarrow{v_1}), \; cos(oy, \overrightarrow{v_1})', vtbl.Cells[0, 0]);
  RVAddFormulaTex('W_x, \; W_y, \; W', vtbl.Cells[0, 0]);
  RVAddFormulaTex('W^{\tau}, \; W^n', vtbl.Cells[0, 0]);
  RVAddFormulaTex('\rh_1', vtbl.Cells[0, 0]);

  vtbl.ResizeRow(0, vtbl.Rows[0].GetBestHeight);
  vtbl.ResizeCol(0, 300, True);

end;

procedure TfrmMain.RefreshBtnsVisible;
begin
  inherited;
  btnDrawGraph.Visible := pcMain.ActivePage = tsResults;
end;

procedure TfrmMain.RunSolve;
begin
  inherited;
  rvMain.Clear;
  //Подготавливаем файл с параметрами
  CreateParamsFile;
  //Печатаем условие
  PrintTask;
  //Запускаем вычисления
  RunCommand('python', '"'+GetAppPath+'process.py"');
  //Показываем результаты
  TransformResults;
  //Показываем ответ
  PrintAnswer;
end;

procedure TfrmMain.TransformResults;
var i: Integer;
    vText, vFormulas: TArray<string>;
begin
  inherited;
  //Добавляем график
  img := TPngImage.Create;
  rvMain.InsertPicture('gr', img, rvvaMiddle);
  PrintGraph;
  //Добавляем основной текст
    ParseFile('out.txt', vText, vFormulas);
    for i := 0 to High(vText) do
    begin
      rvMain.InsertTextW(vText[i]);
      if i<=High(vFormulas) then
         RVAddFormulaTex(vFormulas[i], rvMain);
    end;
end;

end.
