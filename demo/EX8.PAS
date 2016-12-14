uses mcga,mouse;
var x,y,dr,mo:integer;

begin
if not existmouse then
   begin writeln('   Trebuie sa aveti mouse !');halt(1);end;
setmcga;
initmouse;
showmouse;

setcolor(14);
repeat
moveto(mousex div 2,mousey);
repeat
if leftpressed then begin
  hidemouse;
  lineto(mousex div 2,mousey);
  showmouse;end;
until not leftpressed;
until rightpressed;
settext;
end.