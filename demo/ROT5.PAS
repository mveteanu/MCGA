{$x+,g+}
program SphericalPaletteRotationDemo;
uses MCGA,ViewBMP,crt;
var f  : file;
    scr: VirtualScreen;
    pal: PaletteType;

begin
  SetMcga;
  SetUpVirtual(scr);
  LoadBMPFile(0,0,'..\mcga-img\PLASMA.BMP',scr,pal);
  SetAllPal(pal);
  SetVisualScreen(scr);
  repeat
    rotatepal(pal,1,255);
    waitretrace;
    setallpal(pal);
  until keypressed;
  Cls(0);readkey;
  SphericalProjection(scr,vgascreen,70);
  repeat
    rotatepal(pal,1,255);
    waitretrace;
    setallpal(pal);
  until keypressed;
  ShutDownVirtual(scr);
  SetText;
end.