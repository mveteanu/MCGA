{$x+}
program Demo_Rotire_Paleta_1;
uses mcga,crt;
var i  : byte;
    f  : file;
    pal: palettetype;
begin
  setmcga;
  assign(f,'..\mcga-img\selectii.img');
  reset(f,1);
  for i:=1 to filesize(f) div 64768 do
    begin
      blockread(f,vgascreen^,64000);
      blockread(f,pal,768);
      setallpal(pal);
      repeat
        rotatepal(pal,0,255);
        WaitRetrace;
        setallpal(pal);
      until keypressed;
      readkey;
    end;
  close(f);
  settext;
end.