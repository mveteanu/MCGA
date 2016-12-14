Program cu_paleta_de_culori;
uses mcga;
var pal:palettetype;
    f,g:word;
begin
setmcga;
loadpal('..\mcga-img\paleta1.pal',pal);setallpal(pal);
for f:=0 to 15 do for g:=0 to 15 do bar(f*19,g*12,f*19+19,g*12+12,f*16+g);
readln;
settext;
end.