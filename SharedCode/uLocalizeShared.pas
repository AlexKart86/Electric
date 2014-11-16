unit uLocalizeShared;
// ћодуль дл€ локализации текстов сообщений

interface
uses Classes;

type
  TLanguage = (lngUkr, lngRus);

var
  CurrentLang: TLanguage;
  vUkrList: TStringList;
  vRusList: TStringList;

function lc(AStringId: String): String;

implementation

uses SysUtils;



function lc(AStringId: String): String;
begin
  case CurrentLang of
    lngUkr:
      Result := vUkrList.Values[AStringId];
    lngRus:
      Result := vRusList.Values[AStringId];
  end;
end;

initialization
vUkrList := TStringList.Create;
vRusList := TStringList.Create;

finalization

FreeAndNil(vUkrList);
FreeAndNil(vRusList);

end.
