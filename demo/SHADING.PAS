Program Shading;

uses crt,mcga;
Var  ColorNum,
     Y : Integer;

Begin
ColorNum:=1;
SetMcga;
For y:=0 to 63 do SetPal(y,1,1,y);
For y:=64 to 127 do SetPal(y,1,y,1);
For y:=128  to 191 do SetPal(y,y,1,1);
SetPal(192,63,63,63);

For Y:=1 to 63 do
  Begin
   HLine(80,239,35+Y,Colornum);
   ColorNum:=Colornum+1;
  End;

For Y:=64 to 126 do
  Begin
   ColorNum:=ColorNum-1;
   HLine(80,239,35+Y,ColorNum);
  End;

SetColor(192);Print(23,8,'Shading Demo by VMA soft');

 readkey;
 repeat
  waitretrace;
  rotatevisualpalback(1,191);
 until keypressed;

SetText;
End.

