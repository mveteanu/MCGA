uses mcga,crt;
var f:real;
begin
setmcga;
cls(0);
circle(160,100,80);
fillcircle(160,100,60,5);
readln;
cls(1);
                       repeat
                        bline(160,100,
                        round(160+100*cos(f)),
                        round(100+60*sin(f)),
                        round(f));f:=f+0.01;
                       until keypressed;
settext;
end.