uses mcga,crt;
var scr  :virtualscreen;
    scr2 :virtualscreen;
    masca:pointer;
    imag :pointer;
    size :word;
    x    :integer;
begin
setmcga;
loadvisualpal('..\mcga-img\paleta1.pal');
setupvirtual(scr2);setactivescreen(scr2);cls(0);
setupvirtual(scr);setactivescreen(scr);cls(0);


 size:=geticosize(0,0,100,100);
 fillcircle(50,50,50,255);
 getmem(masca,size);
 getico(0,0,100,100,masca);

 loadscreen('..\mcga-img\screen1.scr',scr);
 getmem(imag,size);
 getico(0,0,100,100,imag);

repeat
 setactivescreen(scr);
 freemem (imag,size);
 getmem  (imag,size);
 getico  (x,0,x+100,100,imag);
 inc(x);if x>200 then x:=0;
 setactivescreen(scr2);
 putico(120,50,imag);putmask(120,50,masca);
 waitretrace;
 screentrans(120,50,100,100,$A000,seg(scr2^));
until keypressed;

readln;
shutdownvirtual(scr);
freemem(imag ,size);
freemem(masca,size);
settext;
end.
