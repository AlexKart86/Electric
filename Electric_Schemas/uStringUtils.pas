unit uStringUtils;

// Различные строковые утилиты

interface

uses uElements;


// Возвращает строку с формулой-именем для неизвествного параметра
function GetFormulaAddParam(ASchemaInfo: TSchemaInfo): String;

implementation

uses SysUtils, uConsts;


// Возвращает строку с формулой-именем для неизвествного параметра
function GetFormulaAddParam(ASchemaInfo: TSchemaInfo): String;
begin
  case ASchemaInfo.AddParamType of
    apU, apI, apS, apP, apQ:
      Result := TAppParamNames[Ord(ASchemaInfo.AddParamType)];
    apPRi:
      Result := 'P_R_' + IntToStr(ASchemaInfo.AddParamNodeNum);
    apUri:
      Result := 'U_R_' + IntToStr(ASchemaInfo.AddParamNodeNum);
    apUli:
      Result := 'U_L_' + IntToStr(ASchemaInfo.AddParamNodeNum);
    apUci:
      Result := 'U_C_' + IntToStr(ASchemaInfo.AddParamNodeNum);
    apQli:
      Result := 'Q_L_' + IntToStr(ASchemaInfo.AddParamNodeNum);
    apQci:
      Result := 'Q_C_' + IntToStr(ASchemaInfo.AddParamNodeNum);
    apSi:
      Result := 'S_' + IntToStr(ASchemaInfo.AddParamNodeNum);
    apIi:
      Result := 'I_' + IntToStr(ASchemaInfo.AddParamNodeNum);
  end;
end;

end.
