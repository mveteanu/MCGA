uses mcga,crt,
     adlib,playhsc;
var scr1,scr2,scr3,scr4           : virtualscreen;
    where1,where2,where3,where4   : word;
    pal:palettetype;

Const
  SBDet : boolean = false;
Var
  Music : HSC_obj;

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
  If Not AdlibExists then
                      Begin
                        clrscr;
                        writeln(' Nu aveti SoundBlaster. Apasati orice tasta ');
                        readkey;
                      End;
setmcga;
setupvirtual(scr1);
setupvirtual(scr2);
setupvirtual(scr3);
setupvirtual(scr4);
loadfont('..\mcga-img\soft.fnt');
loadpal('..\mcga-img\paleta2.pal',pal);setallpal(pal);
loadscreen('..\mcga-img\screen2.scr',scr3);

   If AdlibExists then SBDet:=true;
   If SBDet then Music.Init(0);
   If SBDet and  Music.LoadFile ('..\mcga-img\CRYSTAL2.HSC') then Music.Start;

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

  where1:=seg(scr1^);where2:=seg(scr2^);
  where3:=seg(scr3^);where4:=seg(scr4^);

repeat
  ScreenScrollUp(where1,where2,0,199);
  Flip(where3,where4);
  FlipTransp(where1,where4);
  WaitRetrace;
  SetVisualScreen(scr4);
until KeyPressed;

  FadeDown(0,0,0);
  setvisualscreen(scr3);Fadeup(pal);
  setactivescreen(scr1);cls(0);
  outtextxy(0,30,0,'APELATI CU INCREDERE');
  outtextxy(50,70,1,'LA SERVICIILE');
  outtextxy(80,110,1,'OFERITE DE');
  outtextxy(40,150,5,'VMA SOFTWARE');

  circlein(scr1,2000); { Se afiseaza in 2000ms=2s }
  AsteaptaOTasta;
  AsteaptaOTasta;

shutdownvirtual(scr1);
shutdownvirtual(scr2);
shutdownvirtual(scr3);
shutdownvirtual(scr4);

  If SBDet then Music.Fade;
  FadeDown(0,0,0);
  SetText;
  WriteLn('By : VMA soft 1996');
  If SBDet then begin Delay(800);Music.Done;end;

end.

