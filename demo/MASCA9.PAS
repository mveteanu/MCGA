uses mcga,crt;
var scr    : virtualscreen;
    scr2   : virtualscreen;
    scr3   : virtualscreen;
    scr4   : virtualscreen;
    masca  : pointer;
    imag   : pointer;
    size   : word;
    x,y    : integer;
    px,py  : integer;
    where2,
    where3,
    where4 : word;
begin
setmcga;
loadfont('..\mcga-img\soft.fnt');
loadvisualpal('..\mcga-img\paleta2.pal');
setupvirtual(scr4);setactivescreen(scr4);cls(0);
outtextxy(30,50,5,'VMA SOFT 1996');
outtextxy(20,90,5,'MARIAN VETEANU');
outtextxy(40,130,5,'DEMONSTRATIE');
setupvirtual(scr2);setactivescreen(scr2);cls(0);
setupvirtual(scr);setactivescreen(scr);cls(0);
setupvirtual(scr3);

 size:=geticosize(0,0,60,60);
 fillcircle(30,30,30,255);
 getmem(masca,size);
 getico(0,0,60,60,masca);

 loadscreen('..\mcga-img\screen2.scr',scr);
 setactivescreen(scr3);cls(0);

 where2:=seg(scr2^);
 where3:=seg(scr3^);
 where4:=seg(scr4^);

 x:=4;y:=4;
 px:=2;py:=2;
 flip(where3,where2);
 fliptransp(where4,where2);
 setvisualscreen(scr2);

repeat
 getmem  (imag,size);
 setactivescreen(scr);
 getico  (x,y,x+60,y+60,imag);
 mask    (imag,masca);
 setactivescreen(scr2);
 putico(x,y,imag);
 freemem (imag,size);
 inc(x,px);inc(y,py);
 if x>252 then px:=-2;
 if y>132 then py:=-2;
 if x<6 then px:=2;
 if y<6 then py:=2;
 screentranstransp(x-4,y-4,68,68,where2,where4);
 waitretrace;
 screentrans(x-4,y-4,68,68,$A000,where2);
 screentrans(x-4,y-4,68,68,where2,where3);
until keypressed;


shutdownvirtual(scr);
shutdownvirtual(scr2);
shutdownvirtual(scr3);
shutdownvirtual(scr4);
freemem(masca,size);
fadedown(0,0,0);
settext;
end.
