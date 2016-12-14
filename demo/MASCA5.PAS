uses mcga,crt;
var scr    : virtualscreen;
    scr2   : virtualscreen;
    scr3   : virtualscreen;
    masca  : pointer;
    imag   : pointer;
    size   : word;
    x,y    : integer;
    px,py  : integer;
    where2,
    where3 : word;
begin
setmcga;
setupvirtual(scr2);setactivescreen(scr2);cls(0);
setupvirtual(scr3);setactivescreen(scr3);cls(1);
x:=0; repeat VLine(0,199,x,15);inc(x,10);until x=320;
x:=0; repeat HLine(0,319,x,15);inc(x,10);until x=200;
setupvirtual(scr);setactivescreen(scr);cls(0);


 size:=geticosize(0,0,60,60);
 fillcircle(30,30,30,255);
 getmem(masca,size);
 getico(0,0,60,60,masca);

 ZoomIn(scr3,scr,50,40,2,2);

 where2:=seg(scr2^);where3:=seg(scr3^);
 x:=2;y:=2;
 px:=1;py:=1;
 flip(where3,where2);
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
 waitretrace;
 screentrans(x-2,y-2,64,64,$A000,where2);
 screentrans(x-2,y-2,64,64,where2,where3);
until keypressed;

shutdownvirtual(scr);
shutdownvirtual(scr2);
shutdownvirtual(scr3);
freemem(masca,size);
fadedown(0,0,0);
settext;
end.
