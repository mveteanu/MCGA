Program KBD_Demo;
uses kbd;
begin
 writeln;
 writeln('Apasati Alt+X pentru terminare');
 repeat
 if kbdKeyPressed then if KbdReadKey=kbAltX then Halt;
 until false;
end.