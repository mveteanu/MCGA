uses mcga,crt;
var scr1,scr2,scr3: virtualscreen;
    where1,where2,where3 : word;
    F:WORD;
begin
setmcga;
setupvirtual(scr1);setupvirtual(scr2);setupvirtual(scr3);
loadfont('..\mcga-img\soft.fnt');
loadvisualpal('..\mcga-img\pallette.pal');

setactivescreen(scr1);
  cls(0);
  outtextxy(30,100,4,'VMA SOFT 1996');
  setpal(255,63,63,0);setcolor(255);
  circle(140,155,20);circle(180,155,20);circle(160,175,20);

setactivescreen(scr2);
  cls(0);
  outtextxy(10,20,1,'ACEST PROGRAM ESTE');
  outtextxy(70,50,1,'REALIZAT DE');
  outtextxy(20,80,5,'MARIAN VETEANU');
  outtextxy(60,110,1,'DE LA  FIRMA');
  outtextxy(70,140,6,'VMA  SOFT');
  outtextxy(75,170,1,'DIN PITESTI');

setactivescreen(scr3);
  cls(0);
  outtextxy(80,00,1,'APELATI CU');
  outtextxy(80,30,1,'INCREDERE');
  outtextxy(20,60,5,'LA SERVICIILE');
  outtextxy(70,90,1,'OFERITE DE');
  outtextxy(70,120,6,'VMA  SOFT');
  outtextxy(75,150,1,'DIN PITESTI');

  for f:=0 to 10 do gellipse(160,185,f+20,f,f+100);
  for f:=0 to 10 do gellipse(100,185,f+20,f,f+100);
  for f:=0 to 10 do gellipse(220,185,f+20,f,f+100);

  where1:=seg(scr1^);where2:=seg(scr2^);where3:=seg(scr3^);

repeat
  for f:=1 to 200 do begin
  ScreenScrollUp(where1,where2,0,199);
  if keypressed then break;
  WaitRetrace;
  SetVisualScreen(scr1);
  end;


  for f:=1 to 200 do begin
  ScreenScrollUp(where1,where3,0,199);
  if keypressed then break;
  WaitRetrace;
  SetVisualScreen(scr1);end;
until keypressed;

fadedown(0,0,0);
shutdownvirtual(scr1);
shutdownvirtual(scr2);
shutdownvirtual(scr3);
settext;
end.

