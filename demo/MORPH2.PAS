{$g+}
program MORPHING_2;
uses mcga,viewbmp,crt;
var  scr:virtualscreen;
     pal:palettetype;
     f:file;
begin
  setmcga;
  setupvirtual(scr);
  videoscreenoff;  { Placa grafica nu mai citeste continutul memoriei vedeo }
  loadbmpfile(0,0,'..\mcga-img\plasma.bmp',vgascreen,pal);
  setallpal(pal);
  videoscreenon;   { Se citeste continutul memoriei vedeo }
  loadbmpfile(0,0,'..\mcga-img\2fc-vga.bmp',scr,pal);
  morph(scr,pal,1,80);
  shutdownvirtual(scr);
  readln;
  settext;
end.
