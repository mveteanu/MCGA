Program FadeDown_Demo;
uses mcga;
var f,g:word;
    pal:palettetype;
begin
setmcga;
for f:=0 to 255 do
    for g:=1 to 3 do
        pal[f,g]:=round(f div 4);setallpal(pal);

for f:=0 to 199 do vline(0,199,f,f);
readln;
fadedown(0,0,34);
readln;
settext;
end.