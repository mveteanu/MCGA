program Minge;
uses crt,mcga;
label exit;
var  y,rx,ry:integer;
     x:real;

Procedure Turtire;
 begin
  if (y>=160) and (y<=170) then
   begin
    ry:=175-y;
    rx:=30-ry;
   end;
  if (y>=15) and (y<=25) then
   begin
    ry:=y-10;
    rx:=30-ry;
   end;
 end;

 begin
   setmcga;
   x:=25;
   Hline(0,319,8,100);
   Hline(0,319,178,100);
   Print(23,11,'Mingea saltareata');
   repeat
    for y:=15 to 170 do
     begin
      if keypressed then goto exit;
      rx:=15;ry:=15;
      turtire;
      ellipse(trunc(x),y,rx,ry,12);
      delay(10);
      ellipse(trunc(x),y,rx,ry,0);
      x:=x+0.1;
     end;
    for y:=170 downto 15 do
     begin
      if keypressed then goto exit;
      rx:=15;ry:=15;
      turtire;
      ellipse(trunc(x),y,rx,ry,12);
      delay(10);
      ellipse(trunc(x),y,rx,ry,0);
      x:=x+0.1;
     end;
   until x>290;
 exit:
 settext;

 end.