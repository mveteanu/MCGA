{$X+,R-,S-,L-,D-}
Program cu_viermi;

USES
   Mcga,Crt;

VAR
   WholePal : palettetype;
   CurX,CurY,CurCol : Word;
   right,down:Boolean;
   block:array[1..40,1..40] of byte;

Procedure IngeniouslyMoveCurPos;
Begin
   CurCol := (CurCol) mod 210 + 1;
   if right then CurX := CurX + 4 else CurX := CurX - 3;
   if down then CurY := CurY + 3 else CurY := CurY - 2;

   If CurX > 250 then right:= FALSE;
   If CurY > 150 then down := FALSE;

   If CurX < 10 then right := TRUE;
   If CurY < 10 then down  := TRUE;

End;


Procedure DrawBlock;
Var
   Xloop,Yloop : Integer;
Begin
   For XLoop := 1 to 40 do
      For Yloop := 1 to 40 do
         If block[Yloop,Xloop] = 1 then
            PutPixel(CurX+Xloop,CurY+Yloop,CurCol);
End;


Procedure StartSnakiepoo;
Begin
   CurX := 100;
   CurY := 100;
   CurCol := 1;
   LoadPal ('..\mcga-img\worm.pal',wholepal);
   LoadIcon('..\mcga-img\worm.blc',addr(block));
   Repeat
      DrawBlock;
      RotatePal(wholepal,1,210);
      WaitRetrace;
      SetallPal(wholepal);
      IngeniouslyMoveCurPos;
   Until Keypressed;
   fadedown(0,0,0);
   Readkey;
End;

Begin
   SetMCGA;
   StartSnakiepoo;
   SetText;
End.