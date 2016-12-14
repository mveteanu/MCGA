program ProjectionDemo;
uses MCGA,ViewBMP;
var f  : file;
    scr: VirtualScreen;
    pal: PaletteType;

begin
  SetMcga;
  SetUpVirtual(scr);
  LoadBMPFile(0,0,'..\mcga-img\AMBER.BMP',scr,pal);
  SetAllPal(pal);
  SetVisualScreen(scr);ReadLn; Cls(0);
  SphericalProjection(scr,vgascreen,100);ReadLn;Cls(0);
  SphericalProjection(scr,vgascreen,70);ReadLn;Cls(0);
  TriangleProjection(scr,vgascreen,1.7,2,1);ReadLn;Cls(0);
  TriangleProjection(scr,vgascreen,1.7,2,2);ReadLn;Cls(0);
  TriangleProjection(scr,vgascreen,1.7,1.2,1);ReadLn;Cls(0);
  TriangleProjection(scr,vgascreen,1.7,10,2);ReadLn;Cls(0);
  TriangleProjection(scr,vgascreen,0.5,10,2);ReadLn;Cls(0);
  TriangleProjection(scr,vgascreen,0.5,1.2,1);ReadLn;Cls(0);
  ShutDownVirtual(scr);
  SetText;
end.