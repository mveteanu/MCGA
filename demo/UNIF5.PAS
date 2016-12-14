
{   Acesta este un program demonstrativ pentru procedura ChangeScreenPal   }
{   Scopul acestei proceduri este acela de a crea mai multe imagini cu o   }
{   singura paleta pentru a fi afisate simultan pe ecran                   }
{   Acest program afiseaza pe ecran 2 imagin cu o singura paleta           }
{   OBS : Imaginile au fost prelucrate anterior                            }

uses mcga,gif,crt;
var scr1,scr2,scr3:virtualscreen;
    pal:palettetype;


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
      vgascreen^[v1,u1]:=scr^[v1,u1];
      vgascreen^[v2,u1]:=scr^[v2,u1];
      vgascreen^[v1,u2]:=scr^[v1,u2];
      vgascreen^[v2,u2]:=scr^[v2,u2];
      vgascreen^[v3,u3]:=scr^[v3,u3];
      vgascreen^[v4,u3]:=scr^[v4,u3];
      vgascreen^[v3,u4]:=scr^[v3,u4];
      vgascreen^[v4,u4]:=scr^[v4,u4];
     END;
    radius:=radius+adjust;
    INC(counter);
    WHILE ClockTicks<t+counter*temp DO BEGIN END;
   UNTIL radius>=k;
  END;

begin
setmcga;
setupvirtual(scr1);setupvirtual(scr2);setupvirtual(scr3);
loadgiffile(0,0,'..\mcga-img\papaga.gif',scr1,pal);
loadgiffile(0,0,'..\mcga-img\pante.gif',scr2,pal);
setallpal(pal);setvisualscreen(scr1);
readln;circlein(scr2,1500);
readln;
shutdownvirtual(scr1);shutdownvirtual(scr2);shutdownvirtual(scr3);
settext;
end.