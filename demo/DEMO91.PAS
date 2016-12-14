
{ Acest program trebuie compilat in modul protejat }

uses mcgadpmi,crt;
var scr1,scr2,scr3,
    scr4,scr5,scr6,
    scr7,scr8,scr9,
    scr10,scr40 : virtualscreen;
    where1,where2,where3,where4,
    where5,where6,where7,where8,
    where9,where10,where40  : word;
    pal:palettetype;
    f:word;

PROCEDURE CircleIn(scr:virtualscreen;time:WORD);
  CONST centerX=160;
        centerY=100;
        k=189;
        adjust=0.707106781;
        n=TRUNC(k/adjust);
  VAR radqu,x,y,x0,y0,u1,u2,u3,u4,v1,v2,v3,v4:WORD;
      counter:WORD;
      ClockTicks:LONGINT ABSOLUTE $40:$6C;
      t:LONGINT;
      radius,temp:REAL;
      aa:byte;
  BEGIN
   t:=ClockTicks;
   counter:=0;
   temp:=0.0182*time/n;
   x0:=centerX;
   y0:=centerY;
   radius:=0.0;
   REPEAT
    radqu:=TRUNC(sqr(radius));
    FOR x:=0 TO TRUNC(radius/sqrt(2)) DO
     BEGIN
      y:=TRUNC(sqrt(radqu-sqr(x)));
      u1:=x0-x; v1:=y0-y;
      u2:=x0+x; v2:=y0+y;
      u3:=x0-y; v3:=y0-x;
      u4:=x0+y; v4:=y0+x;
      if u1>319 then u1:=319;if v1>199 then v1:=199;
      if u2>319 then u2:=319;if v2>199 then v2:=199;
      if u3>319 then u3:=319;if v3>199 then v3:=199;
      if u4>319 then u4:=319;if v4>199 then v4:=199;
      aa:=scr^[v1,u1];if aa<>0 then vgascreen^[v1,u1]:=aa;
      aa:=scr^[v2,u1];if aa<>0 then vgascreen^[v2,u1]:=aa;
      aa:=scr^[v1,u2];if aa<>0 then vgascreen^[v1,u2]:=aa;
      aa:=scr^[v2,u2];if aa<>0 then vgascreen^[v2,u2]:=aa;
      aa:=scr^[v3,u3];if aa<>0 then vgascreen^[v3,u3]:=aa;
      aa:=scr^[v4,u3];if aa<>0 then vgascreen^[v4,u3]:=aa;
      aa:=scr^[v3,u4];if aa<>0 then vgascreen^[v3,u4]:=aa;
      aa:=scr^[v4,u4];if aa<>0 then vgascreen^[v4,u4]:=aa;
     END;
    radius:=radius+adjust;
    INC(counter);
    WHILE ClockTicks<t+counter*temp DO BEGIN END;
   UNTIL radius>=k;
  END;

procedure AsteaptaOTasta;
var
  Ch : char;
begin
  repeat until KeyPressed;
  Ch := ReadKey;
  if ch = #0 then ch := readkey;
end;

begin
setmcga;
setupvirtual(scr1);setupvirtual(scr2);
setupvirtual(scr3);setupvirtual(scr4);
setupvirtual(scr5);setupvirtual(scr6);
setupvirtual(scr7);setupvirtual(scr8);
setupvirtual(scr9);setupvirtual(scr10);
setupvirtual(scr40);
loadfont('..\mcga-img\soft.fnt');
loadpal('..\mcga-img\paleta2.pal',pal);setallpal(pal);
loadscreen('..\mcga-img\screen2.scr',scr3);

setactivescreen(scr1);
  cls(0);
  outtextxy(30,100,4,'VMA SOFT 1996');
  setcolor(255);
  circle(140,155,20);circle(180,155,20);circle(160,175,20);

setactivescreen(scr2);
  cls(0);
  outtextxy(10,20,1,'ACEST PROGRAM ESTE');
  outtextxy(70,50,1,'REALIZAT DE');
  outtextxy(20,80,5,'MARIAN VETEANU');
  outtextxy(60,110,1,'DE LA  FIRMA');
  outtextxy(70,140,6,'VMA  SOFT');
  outtextxy(75,170,1,'DIN PITESTI');
  line(100,199,150,199,255);
  line(170,199,210,199,255);
  putpixel(160,199,255);

setactivescreen(scr4);
  cls(0);
  outtextxy(40,20,1,'FIRMA VMA SOFT');
  outtextxy(3,50,-1,'REALIZEAZA LA COMANDA');
  outtextxy(8,80,0,'PROGRAME DE GRAFICA');
  outtextxy(100,110,6,'PENTRU');
  outtextxy(0,140,0,'PERSOANE PARTICULARE');
  outtextxy(75,170,7,'SI FIRME');

setactivescreen(scr5);
  cls(0);
  outtextxy(50,20,1,'CEI INTERESATI');
  outtextxy(80,50,1,'SUNT RUGATI');
  outtextxy(50,80,1,'SA IA LEGATURA');
  outtextxy(80,110,1,'CU VMA SOFT');
  outtextxy(35,140,1,'PENTRU A COMANDA');
  outtextxy(80,170,7,'PRODUSUL');

setactivescreen(scr6);
  cls(0);
  outtextxy(0,20,0,'SE ASIGURA LA CERERE');
  outtextxy(3,50,-1,'INSTALAREA PRODUSULUI');
  outtextxy(40,80,1,'PE CALCULATORUL');
  outtextxy(80,110,1,'CLIENTULUI');
  outtextxy(70,140,1,'PRECUM SI O');
  outtextxy(10,170,2,'GARANTIE DE UN AN');

setactivescreen(scr7);
  cls(0);
  outtextxy(25,20,1,'CLIENTII FIRMEI');
  outtextxy(90,50,2,'VMA SOFT');
  outtextxy(40,80,1,'BENEFICIAZA DE');
  outtextxy(3,110,1,'REDUCERI DE PRETURI');
  outtextxy(15,140,1,'PENTRU COMENZILE');
  outtextxy(80,170,2,'ULTERIOARE');

setactivescreen(scr8);
  cls(0);
  outtextxy(80,20,1,'APELATI CU');
  outtextxy(80,50,1,'INCREDERE');
  outtextxy(20,80,5,'LA SERVICIILE');
  outtextxy(70,110,1,'OFERITE DE');
  outtextxy(70,140,6,'VMA  SOFT');
  outtextxy(75,170,1,'DIN PITESTI');

setactivescreen(scr9);
  cls(0);
  outtextxy(70,20,5,'RETINETI:');
  outtextxy(80,50,3,'VMA SOFT');
  outtextxy(40,80,5,'ESTE SINGURA');
  outtextxy(90,110,1,'SOLUTIE');
  outtextxy(10,140,2,'PENTRU PROBLEMELE');
  outtextxy(55,170,1,'DUMNEAVOASTRA');

setactivescreen(scr10);
  cls(0);
  outtextxy(60,110,3,'VMA SOFTWARE');
  outtextxy(40,140,3,'TEL:048-623554');
  rescale(scr3,0,0,319,199,scr10,30,30,90,67);
  rescale(scr3,0,0,319,199,scr10,220,30,280,67);

  where1:=seg(scr1^);where2:=seg(scr2^);
  where3:=seg(scr3^);where4:=seg(scr4^);
  where5:=seg(scr5^);where6:=seg(scr6^);
  where7:=seg(scr7^);where8:=seg(scr8^);
  where9:=seg(scr9^);where10:=seg(scr10^);
  where40:=seg(scr40^);

repeat
 for f:=1 to 200 do begin
  ScreenScrollUp(where1,where2,0,199);
  Flip(where3,where40);
  FlipTransp(where1,where40);
  if keypressed then break;
  WaitRetrace;
  SetVisualScreen(scr40);
 end;

 for f:=1 to 200 do begin
  ScreenScrollUp(where1,where4,0,199);
  Flip(where3,where40);
  FlipTransp(where1,where40);
  if keypressed then break;
  WaitRetrace;
  SetVisualScreen(scr40);
 end;

 for f:=1 to 200 do begin
  ScreenScrollUp(where1,where5,0,199);
  Flip(where3,where40);
  FlipTransp(where1,where40);
  if keypressed then break;
  WaitRetrace;
  SetVisualScreen(scr40);
 end;

 for f:=1 to 200 do begin
  ScreenScrollUp(where1,where6,0,199);
  Flip(where3,where40);
  FlipTransp(where1,where40);
  if keypressed then break;
  WaitRetrace;
  SetVisualScreen(scr40);
 end;

 for f:=1 to 200 do begin
  ScreenScrollUp(where1,where7,0,199);
  Flip(where3,where40);
  FlipTransp(where1,where40);
  if keypressed then break;
  WaitRetrace;
  SetVisualScreen(scr40);
 end;

 for f:=1 to 200 do begin
  ScreenScrollUp(where1,where8,0,199);
  Flip(where3,where40);
  FlipTransp(where1,where40);
  if keypressed then break;
  WaitRetrace;
  SetVisualScreen(scr40);
 end;

 for f:=1 to 200 do begin
  ScreenScrollUp(where1,where9,0,199);
  Flip(where3,where40);
  FlipTransp(where1,where40);
  if keypressed then break;
  WaitRetrace;
  SetVisualScreen(scr40);
 end;

 for f:=1 to 200 do begin
  ScreenScrollUp(where1,where10,0,199);
  Flip(where3,where40);
  FlipTransp(where1,where40);
  if keypressed then break;
  WaitRetrace;
  SetVisualScreen(scr40);
 end;

until KeyPressed;


  FadeDown(0,0,0);
  setvisualscreen(scr3);Fadeup(pal);
  setactivescreen(scr1);cls(0);
  outtextxy(0,30,0,'APELATI CU INCREDERE');
  outtextxy(50,70,1,'LA SERVICIILE');
  outtextxy(80,110,1,'OFERITE DE');
  outtextxy(40,150,5,'VMA SOFTWARE');

  circlein(scr1,2000);
  AsteaptaOTasta;
  AsteaptaOTasta;

shutdownvirtual(scr1);shutdownvirtual(scr2);
shutdownvirtual(scr3);shutdownvirtual(scr4);
shutdownvirtual(scr5);shutdownvirtual(scr6);
shutdownvirtual(scr7);shutdownvirtual(scr8);
shutdownvirtual(scr9);shutdownvirtual(scr10);
shutdownvirtual(scr40);

  FadeDown(0,0,0);
  SetText;
  WriteLn('By : VMA soft 1996');

end.

