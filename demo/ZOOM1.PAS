{$x+,g+}
Program ZoomOut_Demo;
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
  for i:=2 to 12 do
    begin
      ZoomOut(scr,vgascreen,0,0,i,i);
      ReadKey;
    end;
  ShutDownVirtual(scr);
  SetText;
end.