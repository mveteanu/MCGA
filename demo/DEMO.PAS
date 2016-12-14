Program cu_prajitoare_de_paine_si_un_SoundBlaster;
{$x+,r-,s-,d-,l-}
USES adlib,playhsc,
     mcga,crt;

Const
  SBDet : boolean = false;
Var
  Music : HSC_obj;

Type Toastinfo = Record
                 x,y:integer;
                 speed,frame:integer;
                 active:boolean;
               END;

var pal      : palettetype;
    toaster  : Array [1..10] of toastinfo;
    scr,scr2 : virtualscreen;
    frame1,frame2,frame3:pointer;

Procedure SetUpScreen;
CONST circ : Array [1..28] of byte =
        (0,5,5,0,10,10,10,0,10,13,12,11,10,10,12,12,11,10,
         10,11,11,11,10,0,10,10,10,0);
VAR x,y:integer;
    loop1,loop2,loop3:integer;
BEGIN
  LoadPal('..\mcga-img\toaster.pal',pal);SetAllPal(pal);
  SetActiveScreen(scr);
  For loop1:=0 to 319 do Funnyline (0,199,loop1,0,50,100);
  For loop1:=0 to 199 do Funnyline (0,199,319,loop1,50,100);
  For loop1:=1 to 200 do BEGIN
    x:=random (315);y:=random (195);
    PutIco(x,y,addr(circ));
  END;
  SetVisualScreen(scr);Flip (seg(scr^),seg(scr2^));
  GetMem(frame1,30*48+3);LoadIcon('..\mcga-img\frame1.icn',frame1);
  GetMem(frame2,30*48+3);LoadIcon('..\mcga-img\frame2.icn',frame2);
  GetMem(frame3,30*48+3);LoadIcon('..\mcga-img\frame3.icn',frame3);
END;


Procedure NewToaster;
VAR loop1:integer;
BEGIN
  loop1:=0;
  repeat
    inc (loop1);
    if not (toaster[loop1].active) then BEGIN
      toaster[loop1].x:=random (200)+70;
      toaster[loop1].y:=0;
      toaster[loop1].active:=true;
      toaster[loop1].frame:=1;
      toaster[loop1].speed:=Random (3)+1;
      loop1:=10;
    END;
  until loop1=10;
END;

Procedure Fly;
VAR loop1,loop2:integer;
    ch:char;
BEGIN
  For loop1:=1 to 10 do
    toaster[loop1].active:=FALSE;
  ch:=#0;
  NewToaster;
  Repeat
    if keypressed then BEGIN
      ch:=readkey;
      if ch='+' then NewToaster;
      if ch='-' then BEGIN
      loop1:=0;
        repeat
          inc (loop1);
          if toaster[loop1].active then BEGIN
            screentrans (toaster[loop1].x,toaster[loop1].y,48,30,seg(scr^),seg(scr2^));
            toaster [loop1].active:=FALSE;
            loop1:=10;
          END;
        until loop1=10;
      END;
    END;
    for loop1:=1 to 10 do
      if toaster[loop1].active then BEGIN
        screentrans (toaster[loop1].x,toaster[loop1].y,48,30,seg(scr^),seg(scr2^));
        dec (toaster[loop1].x,toaster[loop1].speed);
        inc (toaster[loop1].y,toaster[loop1].speed);
        if (toaster[loop1].x<1) or (toaster[loop1].y>170) then BEGIN
          toaster[loop1].active:=FALSE;
          NewToaster;
        END;
      END;
    for loop1:=1 to 10 do
      if toaster[loop1].active then BEGIN
        CASE toaster [loop1].frame of
           1   : putico (toaster[loop1].x,toaster[loop1].y,frame1);
           3   : putico (toaster[loop1].x,toaster[loop1].y,frame2);
           2,4 : putico (toaster[loop1].x,toaster[loop1].y,frame3);
        END;
        toaster[loop1].frame:=toaster[loop1].frame+1;
        if toaster [loop1].frame=5 then toaster[loop1].frame:=1;
      END;
    RotatePal(pal,50,100);
    { puneti o pauza aici daca programul are viteza prea mare ! }
    Delay(50);
    WaitRetrace;
    SetAllPal(pal);
    SetVisualScreen(scr);
  Until ch=#27;
END;


BEGIN
  If not AdlibExists then
                      Begin
                        clrscr;
                        writeln(' Nu aveti SoundBlaster. Apasati orice tasta ');
                        readkey;
                      End;
  Randomize;
  SetupVirtual(scr);
  SetupVirtual(scr2);
  SetMCGA;
  SetupScreen;
   If AdlibExists then SBDet:=true;
   If SBDet then Music.Init(0);
   If SBDet and  Music.LoadFile ('..\mcga-img\ILLUSIONS.HSC') then Music.Start;
  Fly;
  ShutDownvirtual(scr);
  ShutDownvirtual(scr2);
   If SBDet then Music.Fade;
  FadeDown(0,0,0);
  SetText;
  WriteLn('By : VMA soft 1996');
   If SBDet then begin Delay(800);Music.Done;end;
END.
