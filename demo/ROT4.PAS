Program Demo_Rotire_Paleta_4;
Uses Crt,Mcga;
Var
   P     :PaletteType;
   vit   :Integer;
   Cul   :Integer;

Procedure CreazaDesenul;
var  i,j : Byte;
begin
     For J:=1 to 100 do
     For I:=1 to 160 do
         Begin
              Cul:=Trunc((J*i+I*j)/vit);
              PutPixel(i,j,cul);
              PutPixel(-i,j+1,cul);
              PutPixel(i,200-j,cul);
              PutPixel(-i,201-j,cul);
         End;
end;


Procedure CreazaPaleta;
Var k   : integer;
    i,j : Byte;
begin
     For K:=1 to 64 do
         Begin
              P[K-1,1]:=K-1;
              P[K-1,2]:=0;
              P[K-1,3]:=64-k;
         End;
     For K:=65 to 128 do
         Begin
              P[K-1,2]:=128-k;
              P[K-1,2]:=0;
              P[K-1,3]:=K-65;
         End;
     For k:=129 to 192 do
         Begin
              P[K-1,1]:=K-129;
              P[K-1,2]:=k-129;
              P[K-1,3]:=192-k;
         End;
     For K:=193 to 256 do
         Begin
              P[K-1,1]:=256-K;
              P[K-1,2]:=256-K;
              P[K-1,3]:=K-193;
         End;
     For J:=1 to 15 do
     For I:=0 to 255 do
         Begin
              If P[I,1]<>0 Then P[I,1]:=P[I,1]-1;
              If P[I,2]<>0 Then P[I,2]:=P[I,2]-1;
              If P[I,3]<>0 Then P[I,3]:=P[I,3]-1;
         End;
end;

Begin
     ClrScr;
     Write('Introduceti viteza   (20...100)  V=');
     Readln(Vit);

     SetMcga;
     CreazaPaleta;
     SetAllPal(p);
     CreazaDesenul;

     Repeat
       RotatePal(p,0,255);
       SetAllPal(p);
       Delay((100-vit)div 30);
     Until KeyPressed;
     SetText;
End.
