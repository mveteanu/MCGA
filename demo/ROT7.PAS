{$x+,g+}
Program demonstrativ_foarte_rotitor;
USES Mcga,ViewBMP,Kbd;

CONST
      Fundal : string = '..\mcga-img\2FC-VGA.BMP';
      MaxLines = 12;
      Obj : Array [1..MaxLines,1..2,1..3] of integer =
        (
        ((-10,-10,-10),(10,-10,-10)),((-10,-10,-10),(-10,10,-10)),
        ((-10,10,-10),(10,10,-10)),((10,-10,-10),(10,10,-10)),
        ((-10,-10,10),(10,-10,10)),((-10,-10,10),(-10,10,10)),
        ((-10,10,10),(10,10,10)),((10,-10,10),(10,10,10)),
        ((-10,-10,10),(-10,-10,-10)),((-10,10,10),(-10,10,-10)),
        ((10,10,10),(10,10,-10)),((10,-10,10),(10,-10,-10))
        );


Type Point = Record
               x,y,z:real;
             END;

VAR Lines : Array [1..MaxLines,1..2] of Point;
    Translated : Array [1..MaxLines,1..2] of Point;
    Xoff,Yoff,Zoff:Integer;
    lookup : Array [0..360,1..2] of real;
    scr,sc2:virtualscreen;
    pal:palettetype;

Function rad (theta : real) : real;
BEGIN
  rad := theta * pi / 180
END;


Procedure SetUpPoints;
VAR loop1:integer;
BEGIN
  Xoff:=160;
  Yoff:=100;
  Zoff:=-256;
  For loop1:=0 to 360 do BEGIN
    lookup [loop1,1]:=sin (rad (loop1));
    lookup [loop1,2]:=cos (rad (loop1));
  END;
  For loop1:=1 to MaxLines do BEGIN
    Lines [loop1,1].x:=Obj [loop1,1,1];
    Lines [loop1,1].y:=Obj [loop1,1,2];
    Lines [loop1,1].z:=Obj [loop1,1,3];
    Lines [loop1,2].x:=Obj [loop1,2,1];
    Lines [loop1,2].y:=Obj [loop1,2,2];
    Lines [loop1,2].z:=Obj [loop1,2,3];
  END;
END;


Procedure RotatePoints (X,Y,Z:Integer);
VAR loop1:integer;
    temp:point;
BEGIN
  For loop1:=1 to maxlines do BEGIN
    temp.x:=lines[loop1,1].x;
    temp.y:=lookup[x,2]*lines[loop1,1].y - lookup[x,1]*lines[loop1,1].z;
    temp.z:=lookup[x,1]*lines[loop1,1].y + lookup[x,2]*lines[loop1,1].z;

    translated[loop1,1]:=temp;

    If y>0 then BEGIN
      temp.x:=lookup[y,2]*translated[loop1,1].x - lookup[y,1]*translated[loop1,1].y;
      temp.y:=lookup[y,1]*translated[loop1,1].x + lookup[y,2]*translated[loop1,1].y;
      temp.z:=translated[loop1,1].z;
      translated[loop1,1]:=temp;
    END;

    If z>0 then BEGIN
      temp.x:=lookup[z,2]*translated[loop1,1].x + lookup[z,1]*translated[loop1,1].z;
      temp.y:=translated[loop1,1].y;
      temp.z:=-lookup[z,1]*translated[loop1,1].x + lookup[z,2]*translated[loop1,1].z;
      translated[loop1,1]:=temp;
    END;

    temp.x:=lines[loop1,2].x;
    temp.y:=lookup[x,2]*lines[loop1,2].y - lookup[x,1]*lines[loop1,2].z;
    temp.z:=lookup[x,1]*lines[loop1,2].y + lookup[x,2]*lines[loop1,2].z;

    translated[loop1,2]:=temp;

    If y>0 then BEGIN
      temp.x:=lookup[y,2]*translated[loop1,2].x - lookup[y,1]*translated[loop1,2].y;
      temp.y:=lookup[y,1]*translated[loop1,2].x + lookup[y,2]*translated[loop1,2].y;
      temp.z:=translated[loop1,2].z;
      translated[loop1,2]:=temp;
    END;

    If z>0 then BEGIN
      temp.x:=lookup[z,2]*translated[loop1,2].x + lookup[z,1]*translated[loop1,2].z;
      temp.y:=translated[loop1,2].y;
      temp.z:=-lookup[z,1]*translated[loop1,2].x + lookup[z,2]*translated[loop1,2].z;
      translated[loop1,2]:=temp;
    END;
  END;
END;

Procedure DrawPoints;
VAR loop1:Integer;
    nx,ny,nx2,ny2:integer;
    temp:integer;
BEGIN
  For loop1:=1 to MaxLines do BEGIN
    If (translated[loop1,1].z+zoff<0) and (translated[loop1,2].z+zoff<0) then BEGIN
      temp:=round (translated[loop1,1].z+zoff);
      nx :=round (256*translated[loop1,1].X) div temp+xoff;
      ny :=round (256*translated[loop1,1].Y) div temp+yoff;
      temp:=round (translated[loop1,2].z+zoff);
      nx2:=round (256*translated[loop1,2].X) div temp+xoff;
      ny2:=round (256*translated[loop1,2].Y) div temp+yoff;
      If (NX > 0) and (NX < 320) and (NY > 25) and (NY < 200) and
         (NX2> 0) and (NX2< 320) and (NY2> 25) and (NY2< 200) then
           bline (nx,ny,nx2,ny2,13);
    END;
  END;
END;

Procedure ClearPoints;
VAR loop1:Integer;
    nx,ny,nx2,ny2:Integer;
    temp:integer;
BEGIN
  flip(seg(sc2^),where);
END;


Procedure MoveAround;
VAR deg,loop1:integer;
    ch:word;
BEGIN
  deg:=0;
  For loop1:=-256 to -40 do BEGIN
    zoff:=loop1*2;
    RotatePoints (deg,deg,deg);
    DrawPoints;rotatepalback(pal,1,255);
    SetVisualScreen(scr);SetAllPal(pal);
    if KbdKeyPressed then if kbdreadkey=kbEsc then begin
                                            SetText;
                                            ShutDownVirtual(scr);
                                            ShutDownVirtual(sc2);
                                            Halt;
                                              end;
    ClearPoints;
    deg:=(deg+5) mod 360;
  END;

  Repeat
    if kbdkeypressed then BEGIN
      ch:=kbdreadkey;
      Case ch of kbGrayPlus  : inc(zoff,5);
                 kbGrayMinus : dec(zoff,5);
                 kbLeft      : dec(xoff,5);
                 kbRight     : inc(xoff,5);
                 kbUp        : dec(yoff,5);
                 kbDown      : inc(yoff,5);
      END;
    END;
    RotatePoints (deg,deg,deg);
    DrawPoints;
    rotatepalback(pal,1,255);
    SetVisualScreen(scr);SetAllPal(pal);
    ClearPoints;
    deg:=(deg+5) mod 360;
  Until ch=kbEsc;
END;


BEGIN
  SetUpVirtual(scr);SetActiveScreen(scr);
  SetUpVirtual(sc2);LoadQuickBMPFile(fundal,sc2,pal);
  SetMCGA;SetAllPal(pal);
  SetUpPoints;
  MoveAround;
  SetText;
  ShutDownVirtual(scr);ShutDownVirtual(sc2);
END.
