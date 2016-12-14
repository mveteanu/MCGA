program Demonstratie_Mouse;
uses graph,mouse;
var x,y,dr,mo:integer;

begin
if not existmouse then
   begin writeln('   Trebuie sa aveti mouse !');halt(1);end;
dr:=9;mo:=2;
initgraph(dr,mo,'\bp\bgi');
setcolor(magenta);setbkcolor(black);
setlinestyle(0,0,3);rectangle(3,3,637,477);setlinestyle(0,0,0);
setviewport(5,5,635,475,clipon);
setcolor(white);
initmouse;
showmouse;

repeat
moveto(mousex,mousey);
repeat
if leftpressed then begin
  hidemouse;
  lineto(mousex,mousey);
  showmouse;end;
until not leftpressed;
until rightpressed;
closegraph;
end.