uses mcga,crt;
var scr  :virtualscreen;
    scr2 :virtualscreen;
    masca:pointer;
    imag :pointer;
    size :word;
    x,y  :integer;
    px,py:integer;
    where2,where1:word;
begin
setmcga;
loadvisualpal('..\mcga-img\paleta2.pal');
setupvirtual(scr2);setactivescreen(scr2);cls(0);
setupvirtual(scr);setactivescreen(scr);cls(0);


 size:=geticosize(0,0,60,60);
 fillcircle(30,30,30,255);
 {x:=10; repeat VLine(0,60,x,0);VLine(0,60,x+1,0);inc(x,10);until x=60;
 x:=10; repeat HLine(0,60,x,0);HLine(0,60,x+1,0);inc(x,10);until x=60;}
 getmem(masca,size);
 getico(0,0,60,60,masca);

 loadscreen('..\mcga-img\screen2.scr',scr);

 where2:=seg(scr2^);
 x:=5;y:=5;
 px:=1;py:=1;
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
 setactivescreen(scr2);bar(x-2,y-2,x+62,y+62,0);
until keypressed;

readln;
shutdownvirtual(scr);
shutdownvirtual(scr2);
freemem(masca,size);
settext;
end.
