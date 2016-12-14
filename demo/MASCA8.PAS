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
loadvisualpal('..\mcga-img\paleta2.pal');
loadfont('..\mcga-img\soft.fnt');
setupvirtual(scr4);setactivescreen(scr4);cls(0);
outtextxy(30,60,5,'VMA SOFT 1996');
setcolor(254);
circle(140,115,20);circle(180,115,20);circle(160,135,20);
setupvirtual(scr2);setactivescreen(scr2);cls(0);
setupvirtual(scr);setactivescreen(scr);cls(0);
setupvirtual(scr3);

 size:=geticosize(0,0,60,60);
 fillcircle(30,30,30,255);
 getmem(masca,size);
 getico(0,0,60,60,masca);

 loadscreen('..\mcga-img\screen2.scr',scr3);
 ZoomIn(scr3,scr,50,40,2,2);

 where2:=seg(scr2^);
 where3:=seg(scr3^);
 where4:=seg(scr4^);
 x:=2;y:=2;
 px:=1;py:=1;
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
 if x>256 then px:=-1;
 if y>136 then py:=-1;
 if x<4 then px:=1;
 if y<4 then py:=1;
 screentranstransp(x-2,y-2,64,64,where2,where4);
 waitretrace;
 screentrans(x-2,y-2,64,64,$A000,where2);
 screentrans(x-2,y-2,64,64,where2,where3);
until keypressed;

shutdownvirtual(scr);
shutdownvirtual(scr2);
shutdownvirtual(scr3);
shutdownvirtual(scr4);
freemem(masca,size);
fadedown(0,0,0);
settext;
end.
