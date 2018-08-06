program cmd_findwindow;
{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;


var hw : HWND;

begin
     if (ParamCount <> 2) then
     begin
          writeln(ParamStr(0)  + ': invalid number of arguments!');
          exit;
     end;
     hw := FindWindow(pchar(ParamStr(1)), pchar(ParamStr(2)));
     writeln(hw);
end.
