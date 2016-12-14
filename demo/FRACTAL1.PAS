{$A+,B-,D+,E+,G+,I-,L+,N+,P-,Q-,R-,S+,T-,V-,X+,Y-}
{$M 65000,0,655360}
program Fractal1;
uses crt,mcga;
const maxx=319;
      maxy=199;
var
video:array[0..maxy,0..maxx] of byte absolute $a000:0;
pal  :palettetype;
bruit,s,t:word;

function creerbruit(x1,y1,x2,y2,x,y:word):byte;
var moy,val:word;
begin
moy:=(video[y1,x1]+video[y2,x2]) shr 1;
val:=(random(256) and bruit)-bruit shr 1+moy;
video[y,x]:=val;
creerbruit:=val;
end;

procedure divise(x1,y1,x2,y2:word);
var x,y,num,tmp:word;
begin
  x:=(x1+x2) shr 1;
  y:=(y1+y2) shr 1;
  if (x<>x1) or (y<>y1) then begin
  num:=0;
  if video[y1,x]=0 then num:=creerbruit(x1,y1,x2,y1,x,y1)
                   else num:=video[y1,x];
  if video[y2,x]=0 then num:=num+creerbruit(x1,y2,x2,y2,x,y2)
                   else num:=num+video[y2,x];
  if video[y,x2]=0 then num:=num+creerbruit(x2,y1,x2,y2,x2,y)
                   else num:=num+video[y,x2];
  if video[y,x1]=0 then num:=num+creerbruit(x1,y1,x1,y2,x1,y)
                   else num:=num+video[y,x1];
  video[y,x]:=num shr 2;
  tmp:=bruit;
  bruit:=bruit shr 1;
  divise(x1,y1,x,y);
  divise(x,y1,x2,y);
  divise(x,y,x2,y2);
  divise(x1,y,x,y2);
  bruit:=tmp;
end;
end;

procedure flou;
begin
  Fog(0,0,320,200);
end;

procedure creazapaleta;
begin
 for t:=0 to 63 do
   begin
     pal[t+1,3]:=63-t;pal[t+64,2]:=t;
     pal[t+128,1]:=t;pal[t+128,2]:=t shr 1;
     pal[t+192,1]:=t;pal[t+192,2]:=t;
   end;
 end;

begin
randomize;
setmcga;
creazapaleta;
   setallpal(pal);
   cls(0);
   bruit:=round(exp((random(4)+7)*ln(2)))-1;
   video[0,0]:=random(255)+1;
   divise(0,0,maxx+1,maxy+1);
repeat
  repeat
    waitretrace;
    rotatepal(pal,1,255);
    setallpal(pal);
  until keypressed;
  if readkey='f' then flou else begin
   cls(0);
   bruit:=round(exp((random(4)+7)*ln(2)))-1;
   video[0,0]:=random(255)+1;
   divise(0,0,maxx+1,maxy+1);   end;
until readkey=#27;

settext;
end.

