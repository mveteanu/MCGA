program Demo_Rotire_Paleta_3;
uses Mcga,crt;
var f   : word;
    pal : PaletteType;
begin
  SetMcga;
  For f := 001 to 199 do SetPal(f,f mod 30+33,0,0);
  For f := 200 to 255 do SetPal(f,0,0,f mod 30+33);
  for f := 000 to 199 do Hline(0,319,f,f);
  GetAllPal(pal);
  repeat
    WaitRetrace;
    RotateVisualPal(1,199);
  until KeyPressed;
  for f:=2 to 55 do begin SetColor(f+199);Circle(160,100,f);end;
  readln;
  repeat
    WaitRetrace;
    RotateVisualPalBack(1,199);
    RotateVisualPal(200,255);
  until KeyPressed;
  Readln;
  for f:=0 to 100 do FunnyLine(0,0,319,f,200,255);
  for f:=0 to 100 do FunnyLine(319,199,0,199-f,200,255);
  repeat
    RotatePal(pal,1,199);
    RotatePalBack(pal,200,255);
    WaitRetrace;
    SetAllPal(pal);
  until KeyPressed;
  FadeDown(0,0,0);
  SetText;
  end.

