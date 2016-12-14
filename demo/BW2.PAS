{$g+,x+}
uses mcga,viewbmp,crt;
var pal,pal2:palettetype;
    scr,scr2:virtualscreen;

var i:word;
begin
 SetMcga;
 SetUpVirtual(scr);SetUpVirtual(scr2);
 SetActiveScreen(scr);
 LoadBMPFile(0,0,'..\mcga-img\amber.bmp',scr,pal);
 CreateBWPal(pal2);CreateBWScreen(scr,pal,scr2);
 SetAllPal(pal2);

    rescale(scr2,0,0,319,199,vgascreen,0,0,160,100);
    rescale(scr2,0,0,319,199,vgascreen,0,100,160,199);
    rescale(scr2,0,0,319,199,vgascreen,160,0,319,100);
    rescale(scr2,0,0,319,199,vgascreen,160,100,319,199);
 readkey;
 for i:=1 to 100 do
 begin
    waitretrace;
    rescale(scr2,0,0,319,199,vgascreen,160-i*16 div 10,100-i,160+i*16 div 10,100+i);
 end;
 readln;
 waitretrace;setallpal(pal);setvisualscreen(scr);

 for i:=1 to 100 do
 begin
    waitretrace;
    rescale(scr,0,0,319,199,vgascreen,160-i*16 div 10,100-i,160+i*16 div 10,100+i);
 end;

 readln;
 ShutDownVirtual(scr);ShutDownVirtual(scr2);
 SetText;
end.
