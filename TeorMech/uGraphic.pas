unit uGraphic;

interface
uses
  DrawObjects1,
  DrawObjects2,
  Classes,
  Controls,
  System.Generics.Collections,
  Types;

type

  TDragListRec = record
    control: TControl;
    startPt: TPoint;
  end;


  TDragObjectList = class(TList<TDragListRec>);


  TDrawObjectList = class(TObjectList<TDrawObject>)
  private
    startDragPt: TPoint;
    FDragObjectList: TDragObjectList;
    procedure OnObjectLoadedFromFile(AObject: TObject);
  protected
    function  ConnectorHasStuckEnd(connector: TConnector): boolean;
    procedure AddToDragList(AControl: TControl);
    procedure Notify(const Value: TDrawObject; Action: TCollectionNotification); override;
    procedure ItemMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
        X, Y: Integer); virtual;
    procedure ItemMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
    procedure ItemMouseUp(Sender: TObject;  Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
  public
    procedure ClearAllSelection;
    constructor Create;
    procedure ClearObjects;
    procedure GetCaptionForControl(ctrl: TDrawObject);
    procedure GetNameForControl(ctrl: TDrawObject);
    procedure SaveToFile(AFileName: String);
    procedure LoadFromFile(AFileName: String; AOwner: TComponent; AParent: TWinControl);
  end;

function RusText(AEngText: String): String;

implementation
uses Windows, SysUtils;

{ TDrawObjectList }

function RusText(AEngText: String): String;
begin
  if LowerCase(AEngText) = 'tline' then
    Result := 'Стержень'
  else if LowerCase(AEngText) = 'ttext' then
    Result := 'Надпись'
  else if LowerCase(AEngText) = 'tsolidpoint' then
    Result := 'Простой узел'
  else
    Result := AEngText;

end;

procedure TDrawObjectList.AddToDragList(AControl: TControl);
var
  vItem: TDragListRec;
begin
  if not assigned(AControl) then exit;
  vItem.control := AControl;
  vItem.startPt := TPoint.Create(AControl.Left, AControl.Top);
  FDragObjectList.Add(vItem);
end;

procedure TDrawObjectList.ClearAllSelection;
var
  i: Integer;
begin
  for i:=0 to Count-1 do
    Items[i].Focused := False;
end;

procedure TDrawObjectList.ClearObjects;
var
  i: Integer;
begin
  {for i := 0 to Count-1 do
    Items[i].Free;}
  Clear;
  FDragObjectList.Clear;
end;

constructor TDrawObjectList.Create;
begin
  inherited Create;
  FDragObjectList := TDragObjectList.Create;
end;

procedure TDrawObjectList.GetCaptionForControl(ctrl: TDrawObject);
var
  i,j: integer;
  s: string;
  vIsFound: Boolean;
begin
  vIsFound := False;
  if not assigned(ctrl) or (ctrl.Caption <> '') then exit;
  s := RusText(ctrl.ClassName);
  j := 0;
  while not vIsFound do
  begin
    inc(j);
    vIsFound := true;
    for i:= 0 to Count-1  do
      if SameText(Items[i].Caption, s+IntToStr(j)) then
      begin
        vIsFound := false;
        break;
      end;
  end;
  ctrl.Caption := s+IntToStr(j);
end;

procedure TDrawObjectList.GetNameForControl(ctrl: TDrawObject);
var
  i,j: integer;
  s: string;
  vIsFound: Boolean;
begin
  vIsFound := False;
  if not assigned(ctrl) or (ctrl.Name <> '') then exit;
  s := copy(ctrl.ClassName, 2, 256);
  j := 0;
  while not vIsFound do
  begin
    inc(j);
    vIsFound := true;
    for i:= 0 to Count-1  do
      if SameText(Items[i].Name, s+IntToStr(j)) then
      begin
        vIsFound := false;
        break;
      end;
  end;
  ctrl.Name := s+IntToStr(j);
end;

function TDrawObjectList.ConnectorHasStuckEnd(connector: TConnector): boolean;
begin
  with connector do
    result := (assigned(Connection1) and not Connection1.Focused) or
      (assigned(Connection2) and not Connection2.Focused);
end;

procedure TDrawObjectList.ItemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  vItem: TDrawObject;
begin
  if not (ssShift in Shift) and not TDrawObject(Sender).Focused then
      ClearAllSelection;

  //prepare for possible drag moving ...
  FDragObjectList.Clear;
  GetCursorPos(startDragPt);

  for i:=0 to Count-1 do
  begin
    vItem := Items[i];
    if vItem.Focused then
    begin
      if vItem is TConnector and
         ConnectorHasStuckEnd(TConnector(vItem)) then continue;
      AddToDragList(vItem);
    end;
  end;
end;

procedure TDrawObjectList.ItemMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i: integer;
  screenPt: TPoint;
  dragItem: TDragListRec;
begin
  if not (ssLeft in Shift) or (FDragObjectList.Count < 2) then exit;
  //drag move all focused objects ...
  GetCursorPos(screenPt);
  for dragItem in FDragObjectList do
  begin
     dragItem.control.SetBounds(dragItem.startPt.X + (screenPt.X - startDragPt.X),
      dragItem.startPt.Y + (screenPt.Y - startDragPt.Y),
      dragItem.control.Width,
      dragItem.control.Height);
  end;
end;

procedure TDrawObjectList.ItemMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragObjectList.Clear;
end;

procedure TDrawObjectList.LoadFromFile(AFileName: String; AOwner: TComponent; AParent: TWinControl);
var
  i: Integer;
  strings: TStringList;
begin
  //first clear existing objects ...
  ClearObjects;

  //now load new objects from file ...
  strings := TStringList.Create;
  try
    strings.LoadFromFile(AFileName);
    DrawObjects1.LoadDrawObjectsFromStrings(strings, AOwner, AParent, OnObjectLoadedFromFile);
  finally
    strings.Free;
  end;
end;

procedure TDrawObjectList.Notify(const Value: TDrawObject;
  Action: TCollectionNotification);
begin
  inherited;
  if Action = cnAdded then
  begin
    Value.OnMouseDown := ItemMouseDown;
    Value.OnMouseMove := ItemMouseMove;
    Value.OnMouseUp := ItemMouseUp;
    GetNameForControl(Value);
    GetCaptionForControl(Value);
  end;
end;

procedure TDrawObjectList.OnObjectLoadedFromFile(AObject: TObject);
begin
  if AObject is TDrawObject then
    Add(TDrawObject(AObject));
end;

procedure TDrawObjectList.SaveToFile(AFileName: String);
var
  i: integer;
  saveList: TList;
  strings: TStringList;
begin
  saveList := TList.Create;
  strings := TStringList.Create;
  try
    for i := 0 to Count-1 do
      saveList.Add(Items[i]);
    DrawObjects1.SaveDrawObjectsToStrings(saveList, strings);
    strings.SaveToFile(AFileName);
  finally
    saveList.Free;
    strings.Free;
  end;
end;

end.
