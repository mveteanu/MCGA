uses mcga;
const Triangle: array[1..4] of record x,y:integer;end = ((X: 50; Y: 100), (X: 100; Y:100),
  (X: 150; Y: 150), (X:  50; Y: 100));
begin
setmcga;
cls(1);
line(0,0,20,30,2);
hline(100,200,100,12);
vline(50,150,100,3);
rectangle(20,20,150,150);
rectangle(30,30,180,190);
hline(100,200,120,12);
fillpoly(10,10,70,10,50,80,10,80,13);
fillPolygon(3,triangle,3);
readln;
settext;
end.