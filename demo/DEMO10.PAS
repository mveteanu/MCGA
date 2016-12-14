{$x+,r-,s-,d-,l-}
uses mcga,crt,dos;
var    f                   : word;
       scr1,scr2,scr3,scr4 : virtualscreen;
       pal1,pal2,pal4,pal  : palettetype;

begin
setmcga;setupvirtual(scr1);setupvirtual(scr2);
setupvirtual(scr3);setupvirtual(scr4);
loadscreen('..\mcga-img\screen1.scr',scr1);loadpal('..\mcga-img\paleta1.pal',pal1);
loadscreen('..\mcga-img\screen3.scr',scr4);loadpal('..\mcga-img\paleta3.pal',pal4);
loadscreen('..\mcga-img\screen2.scr',scr2);loadpal('..\mcga-img\paleta2.pal',pal2);
createbwpal(pal);
createbwscreen(scr1,pal1,scr1);
createbwscreen(scr2,pal2,scr2);
createbwscreen(scr4,pal4,scr4);


  setactivescreen(scr3);randomize;
  for f:=64  to 114 do begin pal[f,1]:=f mod 63;pal[f,2]:=0;pal[f,3]:=0;end;
  for f:=115 to 170 do begin pal[f,1]:=0;pal[f,2]:=0;pal[f,3]:=f mod 30+33;end;
  for f:=0 to 199 do Hline(0,319,f,f mod 50+64);
  for f:=0 to 100 do FunnyLine(0,0,319,f,115,170);
  for f:=0 to 100 do FunnyLine(319,199,0,199-f,115,170);
  setallpal(pal);

for f:=0 to 159 do begin
  rescale(scr1,0,0,319,199,scr3,0,0,f,199);
  rescale(scr2,0,0,319,199,scr3,319-f,0,319,199);
  if f>100 then rescale(scr4,0,0,319,199,scr3,320-16*f div 10,200-f,f*16 div 10,f);
  rotatepal(pal,64,114);rotatepal(pal,115,170);
  waitretrace;setallpal(pal);setvisualscreen(scr3);
end;
readln;
shutdownvirtual(scr1);shutdownvirtual(scr2);
shutdownvirtual(scr3);shutdownvirtual(scr4);
settext;
end.
