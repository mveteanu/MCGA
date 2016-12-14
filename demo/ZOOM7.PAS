{$g+,x+}
uses mcga,viewbmp,crt;
var pal:palettetype;
    scr:virtualscreen;

var i:word;
begin
 SetMcga;
 SetUpVirtual(scr);
 SetActiveScreen(scr);
 LoadBMPFile(0,0,'..\mcga-img\amber.bmp',scr,pal);SetAllPal(pal);
 SetVisualScreen(scr);

 repeat
  for i:=1 to 100 do
  begin
     waitretrace;
     rescale(scr,0,0,319,199,vgascreen,160-i*16 div 10,100-i,160+i*16 div 10,100+i);
  end;
 until keypressed;

 FadeDown(0,0,0);
 ShutDownVirtual(scr);
 SetText;
end.
