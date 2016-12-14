{$x+}
Program Fractal2;
Uses mcga,Crt;

Type
    Tablou  = Array [1..32,1..100] of byte;
    Matrice = Array [1..20,1..20] of byte;
Var
   Tab:Tablou;
   Mat:Matrice;
   Cl,Pas:Real;
   C:Char;
   Dif:Integer;
   Vr,Crs,K,L,N,MM,x,y:Integer;
   i,j,t:integer;
   cul,r,g,b,ii:Byte;
   P:PaletteType;

Procedure CreazaMatricea;
begin
Vr:=1;
     Vr:=Vr+1;
     For I:=1 to 8 do
         For J:=1 to 5 do
             Repeat
             Mat[I,J]:=Random(255);
             Until (Abs(Mat[I,J]-Mat[I,J-1])<250) And (Abs(Mat[I,J]-Mat[I,J+1])>Vr);
     For I:=1 to 8 do
         For J:=1 to 5 do
             Begin
                  Dif:=Mat[I,J]-Mat[I,J+1];
                  Pas:=-1*dif/20;
                  Cl:=Mat[I,J];
                  For Crs:=(J-1)*20+1 to J*20 do
                     Begin
                         Cl:=Cl+Pas;
                         Tab[I,Crs]:=Trunc(Cl);
                     End;
             End;
     MM:=0;
     For j:=1 to 100 do
     Begin
         For i:=1 to 8 do
             Begin
                  Dif:=Tab[I,J]-Tab[I+1,J];
                  Pas:=-1*Dif/20;
                  Cl:=Tab[I,J];
                  For Crs:=1 to 20 do
                  Begin
                      Cl:=Cl+Pas;
                      Cul:=Trunc(Cl);
                      Mem[$A000:MM]:=Cul;
                      MM:=MM+1;
                  End;
             End;
     MM:=MM+160;
     End;
     For J:=1 to 15 do
     For I:=0 to 255 do
         Begin
              If P[I+1,1]<>0 Then P[I+1,1]:=P[I+1,1]-1;
              If P[I+1,2]<>0 Then P[I+1,2]:=P[I+1,2]-1;
              If P[I+1,3]<>0 Then P[I+1,3]:=P[I+1,3]-1;
         End;
end;

Procedure MultiplicaMatricea;
begin
     For J:=1 to 100 do
     For I:=1 to 160 do
         Begin
              Cul:=GetPixel(i,j);   PutPixel(-i,j+1,cul);
              PutPixel(i,200-j,cul);PutPixel(-i,201-j,cul);
         End;
End;

Procedure CreazaPaleta;
var unu,doi,trei,
    patru,cinci,sase:integer;
begin
   unu  :=1+Random(3);
   Doi  :=1+Random(3);
   Trei :=1+Random(3);
   Patru:=1+Random(3);
   Cinci:=1+Random(3);
   Sase :=1+Random(3);
   for t:=0 to 63 do
    begin
       p[t+1  ,unu]   :=63-t;
       p[t+64 ,patru]:=t;
       p[t+128,doi] :=t;p[t+128,cinci]:=t ;
       p[t+192,trei]:=t;p[t+192,sase]:=t;
    end;
end;

Begin
SetMcga;
Repeat
  CreazaMatricea;
  MultiplicaMatricea;
  CreazaPaleta;
     Repeat
       WaitRetrace;
       RotatePal(p,1,255);
       SetAllPal(p);
     Until Keypressed;
until readkey=#27;

SetText;
End.