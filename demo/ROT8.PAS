{$A+,B-,D-,E-,F-,G+,I+,L-,N+,O-,P-,Q-,R-,S+,T-,V+,X+,Y-}

uses mcga,crt;
var i,j:word;
    pal:virtualpal;

procedure makepal(var pal:virtualpal);
var i:byte;
begin
  for i:=0   to 63  do begin pal[i,1]:=i;    pal[i,2]:=0;    pal[i,3]:=0;end;
  for i:=64  to 127 do begin pal[i,1]:=63-i; pal[i,2]:=i;    pal[i,3]:=0;end;
  for i:=128 to 191 do begin pal[i,1]:=0;    pal[i,2]:=63-i; pal[i,3]:=i;end;
  for i:=192 to 255 do begin pal[i,1]:=0;    pal[i,2]:=0;    pal[i,3]:=63-i;end;
end;

function f1(x,y:word):byte;
begin
  f1:=trunc(64*(sin(x/14)+sin(y/14)));
end;

begin
  setmcga;
  makepal(pal);setallpal(pal);

  for i:=0 to 319 do
    for j:=0 to 199 do
      putpixel(i,j,f1(i,j));

  repeat waitretrace;rotatevisualpal(0,255); until keypressed;

  settext;
end.
