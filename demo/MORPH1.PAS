{$g+}
program MORPHING_1;
uses mcga,crt;
var  scr:virtualscreen;
     pal:palettetype;
     f:file;
begin
  setmcga;
  setupvirtual(scr);
  assign(f,'..\mcga-img\selectii.img');
  reset(f,1);
  randomize;
  seek(f,64768*(round(random(17))));
  blockread(f,vgascreen^,64000);
  blockread(f,pal,768);
  setallpal(pal);

  repeat
   seek(f,64768*(round(random(17))));
   blockread(f,scr^,64000);
   blockread(f,pal,768);
   morph(scr,pal,1,40);
  until keypressed;

  shutdownvirtual(scr);
  settext;
end.
