Program Rescale_Demo;
uses MCGA,ViewBMP,Crt;
var f  : file;
    scr: VirtualScreen;
    pal: PaletteType;
    i  : byte;

begin
  SetMcga;
  SetUpVirtual(scr);
  LoadBMPFile(0,0,'..\mcga-img\AMBER.BMP',scr,pal);
  SetAllPal(pal);
  SetVisualScreen(scr);ReadLn;
  Rescale(scr,0,0,320,200,vgascreen,20,100,220,180);ReadLn;
  Rectangle(160,20,230,80);
  Rescale(scr,160,20,230,80,vgascreen,50,50,140,160);ReadLn;
  Rescale(scr,160,20,230,80,vgascreen,160,90,300,160);ReadLn;
  Rescale(scr,160,20,230,80,vgascreen,140,10,250,101);ReadLn;
  ShutDownVirtual(scr);
  SetText;
end.