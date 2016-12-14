{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³  Screen virtual de marime mare 1024x768x256  ³
  ³ Programul trebuie compilat in modul protejat ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}
{$IFNDEF DPMI} Eroare ! {$ENDIF}

uses  crt,mcgadpmi;

const kbUp=#72;kbDown=#80;kbLeft=#75;kbRight=#77;kbesc=#27;
const Lungime = 1024;
      Latime  = 768;

type PLine=^TLine;
     TLine=array [0..Lungime-1] of byte;
     PScreen=^TScreen;
     TScreen=array [0..Latime-1] of PLine;

Procedure InitScreen(var screen:PScreen);
var f:word;
begin
 New(Screen);
 For f:=0 to Latime-1 do New(Screen^[f]);
end;

Procedure UmpleScreen(var screen:PScreen);
var x,y:word;
begin
 for y:=0 to Latime-1 do
  for x:=0 to Lungime-1 do
   Screen^[y]^[x]:=trunc(random(255));
end;

Procedure DisplayTest(x,y:word;screen:PScreen);
var i,j:word;
begin
 for j:=0 to 199 do
  for i:=0 to 319 do
   VgaScreen^[j,i]:=Screen^[y+j]^[x+i];
end;

Procedure WalkScreen(screen:PScreen);
var tasta:char;
    cx,cy:word;
    px,py:byte;
begin
 px:=2;py:=2;
 cx:=50;cy:=50;
 repeat
  if keypressed then tasta:=readkey;
  if tasta=#0 then tasta:=readkey;
  case tasta of
   KbLeft  : if cx>10 then dec(cx,px);
   KbRight : if cx<Lungime-330 then inc(cx,px);
   KbUp    : if cy>10 then dec(cy,py);
   KbDown  : if cy<Latime-210 then inc(cy,py);
  end;
 DisplayTest(cx,cy,screen);
 until tasta=kbesc;
end;

var  Scr:PScreen;
begin
  ClrScr;
  Writeln('Asteptati putin...');
  InitScreen(Scr);
  UmpleScreen(Scr);
  SetMcga;
  DisplayTest(100,100,Scr);
  WalkScreen(Scr);
  SetText;
end.

