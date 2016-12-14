uses mcga;
var scr:virtualscreen;
    masca:pointer;
    imag :pointer;
    size :word;
begin
setmcga;
loadvisualpal('..\mcga-img\paleta1.pal');
setupvirtual(scr);setactivescreen(scr);cls(0);

 size:=geticosize(0,0,100,100);
 fillcircle(50,50,50,255);
 getmem(masca,size);
 getico(0,0,100,100,masca);

 loadscreen('..\mcga-img\screen1.scr',scr);
 getmem(imag,size);
 getico(0,0,100,100,imag);

setactivescreen(vgascreen);
videoscreenoff;
putico(120,50,imag);putmask(120,50,masca);
videoscreenon;
readln;
shutdownvirtual(scr);
freemem(imag ,size);
freemem(masca,size);
settext;
end.
