program Editor_de_iconuri;
uses mcga,mouse,crt;
const  cul  : byte = 14;
       lung : byte = 30;
       lat  : byte = 20;
       mar  : byte = 06;
var x1,y1,x2,y2,n2,m2:integer;
    mat: array[1..90,1..90] of byte;

procedure CreateImage(x,y,n,m,l: integer;modul:boolean);
var xm,ym,i,j: integer;
begin
     if modul=false then begin
     n2 := n div 2;m2 := m div 2;
     x1 := x-n2*l; y1 := y-m2*l; x2:=x+n2*l; y2:=y+m2*l;
     HideMouse;
     SetColor(15);
     for i:=1 to n do
         for j:=1 to m do
             begin
             Bar(x1+(i-1)*l,y1+(j-1)*l,x1+i*l,y1+j*l,mat[i,j]);
             Rectangle(x1+(i-1)*l,y1+(j-1)*l,x1+i*l,y1+j*l);
             end;
             ShowMouse;end
           else begin
           xm:=mousex div 2;ym:=mousey;
           if  leftpressed and (xm>x1) and (xm<x2) and
                               (ym>y1) and (ym<y2) then begin
              i := Round((xm-x1) div l)+1;
              if i<1 then i:=1; if i>n then i:=n;
              j := Round((ym-y1) div l)+1;
              if j<1 then j:=m; if j>m then j:=m;
              mat[i,j]:=cul;
              HideMouse;
              Bar(x1+(i-1)*l,y1+(j-1)*l,x1+i*l,y1+j*l,cul);
              SetColor(White);
              Rectangle(x1+(i-1)*l,y1+(j-1)*l,x1+i*l,y1+j*l);
              ShowMouse
           end;end;
end;

procedure Paleta;
var f,g:word;
begin
for f:=0 to 7 do for g:=0 to 31 do bar(f*7,g*6,f*7+6,g*6+5,f*4+g);
end;


procedure AlegeCuloarea;
var xm,ym:integer;
begin
  if leftpressed1 then begin xm:=mousex div 2;ym:=mousey;
  if (xm>0) and (xm<56) and (ym>0) and (ym<192)
  then begin cul:=4*(xm div 7)+(ym div 6);end;end;
end;

procedure IncarcaFisier;
var f:file of byte ;
    i,j:word;
    c:byte;
begin
if (paramcount=1) and (fileexist(paramstr(1))) then begin
assign(f,paramstr(1));reset(f);
read(f,lung);read(f,lung);read(f,lat);mar:=4;
for i:=1 to lat do
  for j:=1 to lung do
    begin
      read(f,c);
      mat[j,i]:=c;
    end;
close(f);
end;
end;

procedure AfisIcon;
var i,j:integer;
  begin
     for i:=1 to lung do
         for j:=1 to lat do
             PutPixel(319-lung+i-1,0+j-1,mat[i,j]);
  end;

begin
SetMcga;
Paleta;
IncarcaFisier;
CreateImage(160,100,lung,lat,mar,false);
InitMouse;ShowMouse;
repeat
  AlegeCuloarea;
  CreateImage(160,100,lung,lat,mar,true);
  if leftpressed then AfisIcon;
until rightpressed;
settext;
end.


