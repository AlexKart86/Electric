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
    FDragObjectList: TDragObjectList;
  protected
    procedure Notify(const Value: TDrawObject; Action: TCollectionNotification); override;
    procedure ItemMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
        X, Y: Integer); virtual;
  public
    procedure ClearAllSelection;
    constructor Create;
  end;

implementation

{ TDrawObjectList }

procedure TDrawObjectList.ClearAllSelection;
var
  i: Integer;
begin
  for i:=0 to Count-1 do
    Items[i].Focused := False;
end;

constructor TDrawObjectList.Create;
begin
  inherited Create;
  FDragObjectList := TDragObjectList.Create;
end;

procedure TDrawObjectList.ItemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not (ssShift in Shift) then
    ClearAllSelection;
  TDrawObject(Sender).Focused := True;
end;

procedure TDrawObjectList.Notify(const Value: TDrawObject;
  Action: TCollectionNotification);
begin
  inherited;
  if Action = cnAdded then
  begin
    Value.OnMouseDown := ItemMouseDown;
  end;
end;

end.
