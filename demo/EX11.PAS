uses mcga,crt;
var f:word;
begin
 setmcga;
 for f:=0 to 90 do gellipse(160,100,f+60,f,f);
 for f:=0 to 30 do gellipse(160,100,f+20,f+60,f);
 for f:=0 to 30 do gellipse(160,100,f+40,f+10,f);
 repeat waitretrace;rotatevisualpalback(1,255);until keypressed;
 settext;
end.