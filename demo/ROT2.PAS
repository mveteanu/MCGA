{$x+}
program Demo_Rotire_Paleta_2;
uses mcga,viewbmp,crt;
var i  : byte;
    f  : file;
    scr:virtualscreen;
    pal: palettetype;
begin
  setmcga;
  for i:=0 to 255 do begin
                       pal[i,1]:=0;
                       pal[i,2]:=0;
                       pal[i,3]:=0;
                     end;
  setallpal(pal);
  setupvirtual(scr);
  loadquickbmpfile('..\mcga-img\2fc-vga.bmp'{'..\mcga-img\fract002.bmp'},scr,pal);
  setvisualscreen(scr);
  fadeup(pal);
      repeat
        rotatepal(pal,1,255);
        WaitRetrace;
        setallpal(pal);
      until keypressed;
      readkey;
  shutdownvirtual(scr);
  fadedown(0,0,0);
  settext;
end.