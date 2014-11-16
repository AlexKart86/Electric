unit uSystem;
{
  Утилиты для работы с системой
}

interface

type
 TCallbackProc = procedure of object;

function RunCommand(ACommand, AParams: string): Boolean;
function GetAppPath: String;

implementation

uses Windows, Dialogs, SysUtils, Forms;

function RunCommand(ACommand, AParams: String): Boolean;
var
  si: TStartupInfo;
  pi: TProcessInformation;
begin
  Result := false;
  ZeroMemory(@si, SizeOf(si));
  si.cb := SizeOf(si);
  si.dwFlags := STARTF_USESHOWWINDOW;
  si.wShowWindow := SW_HIDE;
  Result := CreateProcess(nil, PChar(ACommand + ' ' + AParams), nil, nil, false,
    0, nil, nil, si, pi);
  CloseHandle(pi.hThread);
  WaitForSingleObject(pi.hProcess, INFINITE);
  CloseHandle(pi.hProcess);
end;

function GetAppPath: String;
begin
   Result := ExtractFilePath(Application.ExeName);
end;

end.
