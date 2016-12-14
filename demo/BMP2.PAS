Program MCGA_DEMO_BMP2;
uses mcga,viewbmp;
var pal:palettetype;
    scr:virtualscreen;
begin
 SetMcga;
 SetUpVirtual(scr);
 SetActiveScreen(scr);cls(0);
 LoadBMPFile(0,0,'..\mcga-img\bee.bmp',scr,pal);
 SetAllPal(pal);
 SetVisualScreen(scr);
 readln;
 ShutDownVirtual(scr);
 SetText;
end.
