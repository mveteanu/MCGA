Program ZoomIn_Demo;
uses MCGA,ViewBMP,Crt;
var f  : file;
    scr: VirtualScreen;
    pal: PaletteType;

begin
  SetMcga;
  SetUpVirtual(scr);
  LoadBMPFile(0,0,'..\mcga-img\AMBER.BMP',scr,pal);
  SetAllPal(pal);
  SetVisualScreen(scr);
  ReadLn;
  ZoomIn(scr,vgascreen,50,40,2,2);ReadLn;
  ZoomIn(scr,vgascreen,50,30,3,3);ReadLn;
  ZoomIn(scr,vgascreen,50,20,4,4);ReadLn;
  SetVisualScreen(scr);ReadLn;
  ShutDownVirtual(scr);
  SetText;
end.