Program Burn; { That's a program from Internet and adapted to MCGA by VMA soft}
uses
  Mcga,Crt;

Const
  RootRand     =  20;   { Max/Min decrease of the root of the flames }
  Decay        =  10;   { How far should the flames go up on the screen? }
  MinY         = 100;   { Startingline of the flame routine.(should be adjusted along with MinY above) }
  Smooth       =   1;   { How descrete can the flames be?}
  MinFire      =  50;   { limit between the "starting to burn" and the "is burning" routines }
  XStart       =  90;   { Startingpos on the screen }
  XEnd         = 210;   { Guess! }
  Width        = XEnd-XStart; {Well- }
  MaxColor     = 110;   { Constant for the MakePal procedure }
  FireIncrease : Byte =   3;  {3 = Wood, 90 = Gazolin}

Var
  FlameArray : Array[XStart..XEnd] Of Byte;
  I,J,X,P    : Integer;
  MoreFire,V : Integer;
  Ch         : Char;
  pal        : PaletteType;


Procedure MakePal(var Pal : Palettetype);
Var
  I : Byte;
begin
  FillChar(Pal,SizeOf(Pal),0);
  For I:=1 To MaxColor Do
    HSI2RGB(4.6-1.5*I/MaxColor,I/MaxColor,I/MaxColor,Pal[I,1],Pal[I,2],Pal[I,3]);
  For I:=MaxColor To 255 Do
  begin
    Pal[I]:=Pal[I-1];
      If pal[i,1]<63 Then Inc(pal[i,1]);
      If pal[i,1]<63 Then Inc(pal[i,1]);
      If (I Mod 2=0) And (pal[i,2]<53)  Then Inc(pal[i,2]);
      If (I Mod 2=0) And (pal[i,3]<63) Then Inc(pal[i,3]);
  end;
end;


Function Rand(R:Integer):Integer;{ Return a random number between -R And R}
begin
  Rand:=Random(R*2+1)-R;
end;

Procedure Help;
begin
  SetText;
  ClrScr;
  WriteLn('Burn version 1.00');
  WriteLn;
  WriteLn('Keys : ');
  WriteLn('<space> : Throw in a match');
  WriteLn('<W>     : Water');
  WriteLn('<+>     : Increase intensity');
  WriteLn('<->     : Decrease intensity');
  WriteLn('<C>     : Initialize fire');
  WriteLn('<1>..<9>: Burnability (1=Wood, 9=Gaz)');
  WriteLn('<?>     : This help');
  WriteLn;
  Write('Hit any key kid >');
  ReadKey;
  SetMcga;
  MakePal(pal);SetAllPal(pal);
end;

begin
  Help;
  Randomize;
  MoreFire:=1;

  {For I:=0 To 255 Do
  For J:=0 To 20 Do
    Put(I,J,I);
  readkey;}

  { Initialize FlameArray }
  For I:=XStart To XEnd Do FlameArray[I]:=0;
  cls(0);

  repeat
    If KeyPressed Then Ch:=ReadKey Else Ch:='.';
    While KeyPressed Do ReadKey;

    { Put the values from FlameArray on the bottom line of the screen }
    For I:=XStart To XEnd Do PutPixel(I,199,FlameArray[I]);

    { This loop makes the actual flames }
    For I:=XStart To XEnd Do
    For J:=MinY To 199 Do
    begin
      V:=GetPixel(I,J);
      If (V=0) Or(V<Decay) Or
         (I<=XStart) Or(I>=XEnd)
	 Then PutPixel(I,Pred(J),0)
         else PutPixel(I-Pred(Random(3)),Pred(J),V-Random(Decay));
    end;

    {Match?}
    If (Random(150)=0) Or (Ch=' ') Then
      FillChar(FlameArray[XStart+Random(XEnd-XStart-5)],5,255);

    {In-/Decrease?}
    If (Ch='-') Then If MoreFire >-2 Then Dec(MoreFire);
    If (Ch='+') Then If MoreFire < 4 Then Inc(MoreFire);

    {!!}
    If UpCase(Ch) = 'C' Then FillChar(FlameArray,SizeOf(FlameArray),0);
    If UpCase(Ch) = 'W' Then
      for I:=1 To 10 Do FlameArray[XStart+Random(Width)]:=0;

    If Ch = '?' Then Help;

    if Ch in ['1'..'9'] Then FireIncrease:=3+Sqr(Ord(Ch)-Ord('1'));

    {This loop controls the "root" of the flames ie. the values in FlameArray.}
    For I:=XStart To XEnd Do
    begin
      X:=FlameArray[I];
      If ((X<MinFire) and (X>10))
      Then Inc(X,Random(FireIncrease))     { Increase by the "burnability"}
      else Inc(X,Rand(RootRand)+MoreFire); { Otherwise randomize and increase by intensity (is burning)}
      If X>255 Then X:=255;
      FlameArray[I]:=X;
    end;

    { Pour a little water on both sides of the fire to make it look nice on the sides}
    For I:=1 To Width Div 8 Do
    begin
      X:=Trunc(Sqr(Random)*Width/8);
      FlameArray[XStart+X]:=0;
      FlameArray[XEnd-X]:=0;
    end;

    {Smoothen the values of FrameArray to avoid "descrete" flames}
    P:=0;
    For I:=XStart+Smooth To XEnd-Smooth Do
    begin
      X:=0;
      For J:=-Smooth To Smooth Do Inc(X,FlameArray[I+J]);
      FlameArray[I]:=X Div (2*Smooth+1);
    end;
  Until Ch=#27;
  SetText;
end.
