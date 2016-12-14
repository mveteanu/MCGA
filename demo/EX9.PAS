uses mcga;

const
 Triangle: array[1..4] of Point2D = ((X: 50; Y: 100), (X: 100; Y:100),
   (X: 150; Y: 150), (X:  50; Y: 100));
begin
 SetMcga;
 DrawPoly(4,Triangle);
 Readln;
 SetText;
end.
