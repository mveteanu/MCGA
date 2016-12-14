Program MCGA_DEMO_BMP1;
uses mcga,viewbmp;
var  pal1:palettetype;
begin

 SetMcga;
 LoadBMPFile(90,45,'..\mcga-img\bee.bmp',vgascreen,pal1);
 SetAllPal(pal1);
 readln;
 SetText;

end.
