{ ---------------------- }
{ BigScreen manipulation }
{ ---------------------- }

uses mcga,crt;

const maxY = 199;
      maxL = 999;

type linePtr = ^line;
     line    = array[0..maxL] of byte;
     PScr    = ^TScr;
     TScr    = array[0..maxy] of linePtr;

Var
  BigScr : PScr;
  x,y    : word;
  scr    : virtualscreen;

begin
  SetMcga;

  new (BigScr);
  For y := 0 to maxY do
  begin
    new (BigScr^[y]);
    For x := 0 to maxL do BigScr^[y]^[x] := random(256);
  end;

  SetUpVirtual(scr);SetActiveScreen(Scr);

  For x := 0 to 679 do
  begin
    For y := 0 to maxY do move (BigScr^[y]^[x], linear(scr^)[y*320], 320);
    Bar(90,90,120,120,15);
    WaitRetrace;
    SetVisualScreen(scr);
    if keypressed then break;
  end;

  SetText;

  ShutDownVirtual(scr);
  For y := 0 to maxY do dispose(BigScr^[y]);
  dispose(BigScr);
end.

