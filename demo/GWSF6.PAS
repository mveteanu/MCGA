{                                                     }
{  Efectul realizat de GWS daca se apasa F6 - Reverse }
{                                                     }

uses mcga,viewbmp;
var pal:palettetype;
    f:word;
    a:byte;
begin
setmcga;
loadpal('..\mcga-img\paleta1.pal',pal);setallpal(pal);
loadscreen('..\mcga-img\screen1.scr',vgascreen);
for f:=0 to 255 do
  begin
    pal[f,1]:=63-pal[f,1];
    pal[f,2]:=63-pal[f,2];
    pal[f,3]:=63-pal[f,3];
  end;
readln;
setallpal(pal);
savebmpfile(0,0,319,199,'test.bmp',vgascreen,pal);
readln;
settext;
end.
