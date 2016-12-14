{$A+,B-,D-,E-,F-,G+,I+,L-,N+,O-,P-,Q-,R-,S+,T-,V-,X+,Y-}

uses crt,mcga;
var x : Word;
    r : Byte;

begin
 SetMcga;

 for x := 1 to 32 do
  begin
    SetPal(x,   x*2-1, 0,     0    );
    SetPal(x+32, 63,   x*2-1, 0    );
    SetPal(x+64, 63,   63,    x*2-1);
    SetPal(x+96, 63,   63,    63   );
  end;

 repeat
   x := 0;
   repeat
       r:=Random(2) * 160;
       asm
        mov     dx,80          {y=80}
        @repeat:
        mov     ax,$a000
        mov     es,ax
        mov     ax,dx
        mov     di,ax
        shl     ax,8
        shl     di,6
        add     di,ax
        add     di,x
        xor     ax,ax
        mov     al,es:[di]    {ax=vgascreen^[y,x]}
        dec     di
        dec     di
        add     al,es:[di]
        adc     ah,0          {ax+=vgascreen^[y,x-2]}
        add     di,4
        add     al,es:[di]
        adc     ah,0          {ax+=vgascreen^[y,x+2]}
        add     di,320
        add     di,320
        add     al,es:[di]
        adc     ah,0          {ax+=vgascreen^[y+2,x+2]}
        shr     ax,2          {ax=ax / 4;  c:= ax }
        jz      @l1
        dec     ax            {if c>0 then dec c}
        @l1:

        mov     ah,al
        shl     al,8
        add     al,ah         {d:=(c shl 8) + c;}

        sub     di,320
        sub     di,320
        sub     di,320
        dec     di
        mov     es:[di],al    {vgascreen^[y-1,x+1]=al}
        dec     di
        mov     es:[di],al    {vgascreen^[y-1,x]=al}
        sub     di,320
        mov     es:[di],al    {vgascreen^[y-2,x]=al}
        inc     di
        mov     es:[di],al    {vgascreen^[y-2,x+1]=al}

        inc     dx
        inc     dx            {inc(y,2)}
        cmp     dx,202
        jb      @repeat       {repeat ... until y>202}
        dec     dx
        dec     dx            {dec(y,2)}

        add     di,320
        add     di,320
        dec     di
        mov     al,r
        mov     es:[di],al    {vgascreen^[y,x]=random(2) * 160}
       end;

     Inc(X,2);
    until x >= 320;

  until KeyPressed;

  SetText;

end.


(*

{ *********** }
{ Only PASCAL }
{ *********** }
uses crt,mcga;
var c, d, x, y, z : Word;

begin
  setmcga;

  for x := 1 to 32 do
  begin
    setpal(x,   x*2-1, 0,     0    );
    setpal(x+32, 63,   x*2-1, 0    );
    setpal(x+64, 63,   63,    x*2-1);
    setpal(x+96, 63,   63,    63   );
  end;

  repeat
   x := 0;
   repeat
     y := 80;
     repeat

       c:=(vgascreen^[y,x]+vgascreen^[y,x+2]+
           vgascreen^[y,x-2]+vgascreen^[y+2,x+2]) shr 2;

       if c <> 0 then dec(c);

       d:=(c shl 8) + c;
       vgascreen^[y-2,x]   := d;
       vgascreen^[y-2,x+1] := d;
       vgascreen^[y-1,x]   := d;
       vgascreen^[y-1,x+1] := d;

       Inc(Y,2);
     until y > 202;
     Dec(y,2);
     vgascreen^[y,x]:=random(2) * 160;
     Inc(X,2);
    until x >= 320;
  until keypressed;

  settext;

end.

*)

