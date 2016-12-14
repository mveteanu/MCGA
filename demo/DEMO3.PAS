Program foarte_rotitor;

uses mcga;
var f   : word;
    pal : palettetype;
    scr : virtualscreen;
begin
setmcga;
setupvirtual(scr);
loadscreen('..\mcga-img\screen1.scr',scr);loadpal('..\mcga-img\paleta1.pal',pal);
setvisualscreen(scr);setallpal(pal);
for f:=1 to 140 do begin waitretrace;shlbox(100,10,240,40,2);end;
for f:=1 to 140 do begin waitretrace;shrbox(100,50,240,80,2);end;
for f:=1 to 140 do begin waitretrace;rolbox(100,90,240,120);end;
for f:=1 to 140 do begin waitretrace;rorbox(100,130,240,160);end;
for f:=1 to 30 do begin waitretrace;shdbox(100,90,240,120,0);end;
for f:=1 to 30 do begin waitretrace;shubox(100,130,240,160,0);end;

shutdownvirtual(scr);
readln;
settext;
end.
