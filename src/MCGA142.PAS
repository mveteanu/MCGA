(*
    旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
    �        Acesta este un unit care vine in ajutorul celor care        �
    �   au placi grafice VGA si doresc sa foloseasca modul 320x200x256   �
    �            Acesta este primul unit al bibliotecii MCGA             �
    �                     Autor : Marian Veteanu                         �
    읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*)

{$A+,G+,X+,R-,F-,S-,D-,L-,Q-}
unit MCGA;
interface
Type
   PaletteType   = Array [0..255,1..3] of byte;
   VirtualScreen = ^VirtualPage;
   VirtualPage   = Array [0..199,0..319] of byte;
   Linear        = Array [0..63999] of byte;
   Point2D        = record
                     x,y:word;
                   end;


Const
   VGA          : word      =  $a000;
   ScrollBreak  : boolean   =  false;
   Where        : word      =  $a000;
Var
   VgaScreen  : VirtualScreen;
   ScrollProc : procedure;


Procedure SetMCGA;
Procedure SetText;
Procedure SetActiveScreen(scr:VirtualScreen);
Procedure SetVisualScreen(scr:VirtualScreen);
Procedure Cls (Col : Byte);
Procedure Putpixel (X,Y : Integer; Col : Byte);
Function  GetPixel (X,Y : Integer) : Byte;
Procedure WaitRetrace;
Procedure SetPal(Col,R,G,B : Byte);
Procedure GetPal(Col : Byte; Var R,G,B : Byte);
Procedure LoadPal (FileName : string ; var DAC : PaletteType);
Procedure LoadVisualPal (FileName : string);
Procedure SavePal (FileName : string ; DAC : PaletteType);
Procedure LoadIcon(FileName : string ;poin:pointer);
Procedure SaveIcon(FileName : string ;poin:pointer);
Procedure Flip(source,dest:Word);
Procedure FlipTransp(source,dest:Word);
Function  GetIcoSize(x,y,z,t:word):word;
Procedure PutIco(X,Y:Word;sprt:pointer);
Procedure PutFrame(X,Y:Word;sprt:pointer);
Procedure PutMask(X,Y:Word;sprt:pointer);
Procedure Mask(imag,masca:pointer);
Procedure GetIco(X,Y,Z,T:Word;sprt:pointer);
Procedure FunnyLine(a,b,c,d:integer;count1,count2:byte);
Procedure RotatePal(var OurPal:palettetype;count1,count2:byte);
Procedure RotatePalBack(var OurPal:palettetype;count1,count2:byte);
Procedure RotateVisualPal(count1,count2:byte);
Procedure RotateVisualPalBack(count1,count2:byte);
Procedure ScreenTrans (x,y,lungime,inaltime:word;vaddrwhere,vaddrfrom:word);
Procedure ScreenTransTransp (x,y,lungime,inaltime:word;vaddrwhere,vaddrfrom:word);
Procedure QuickScreenTrans (x,y,lungime,inaltime:word;vaddrwhere,vaddrfrom:word);
Procedure Line(a,b,c,d:integer;col:byte);
Procedure BLine(x1, y1, x2, y2 : integer; color : byte);
Procedure HLine (x1,x2,y:word;col:byte);
Procedure VLine (y1,y2,x:word;col:byte);
Procedure Rectangle(x1,y1,x2,y2:integer);
Procedure Bar(x1,y1,x2,y2:word;col:byte);
Procedure DrawPoly(nrp:word;var puncte);
Procedure FillPoly(x1,y1,x2,y2,x3,y3,x4,y4:integer;color:byte);
Procedure FloodFill(xinit,yinit:integer;culumplere,culcontur:byte);
Procedure Ellipse(xc,yc,ia,ib:integer;cul:byte);
Procedure Circle(x,y,r:integer);
Procedure FillCircle(xc,yc,r,culoare:integer);
Procedure SetAllPal( Palet : PaletteType);
Procedure GetAllPal( var Palet : PaletteType);
Procedure SetUpVirtual(var VirScr:VirtualScreen);
Procedure ShutDownVirtual(var VirScr:VirtualScreen);
Function  ScreenAddr(VS:VirtualScreen):Word;
Function  GetVideoMode:byte;
Function  GetMaxX:integer;
Function  GetMaxY:integer;
Function  GetMaxColor:byte;
Procedure SetColor(c:byte);
Function  GetColor:byte;
Procedure MoveTo(x,y:integer);
Procedure MoveRel(dx,dy:integer);
Function  GetX:integer;
Function  GetY:integer;
Procedure LineTo(x,y:integer);
Procedure LineRel(dx,dy:integer);
Procedure SaveScreen(FileName : string ; scr : VirtualScreen);
Procedure LoadScreen(FileName : string ; scr : VirtualScreen);
Procedure FadeDown(rv,gv,bv:byte);
Procedure FadeUp(pall2:PaletteType);
Procedure SHLBox(x1,y1,x2,y2:integer;col:byte);
Procedure SHRBox(x1,y1,x2,y2:integer;col:byte);
Procedure SHLBox2(x1,y1,x2,y2:integer);
Procedure SHRBox2(x1,y1,x2,y2:integer);
Procedure ROLBox(x1,y1,x2,y2:integer);
Procedure RORBox(x1,y1,x2,y2:integer);
Procedure SHUBox2(x1,y1,x2,y2:integer);
Procedure SHDBox2(x1,y1,x2,y2:integer);
Procedure SHUBox(x1,y1,x2,y2:integer;col:byte);
Procedure SHDBox(x1,y1,x2,y2:integer;col:byte);
Procedure ScreenScrollUp(where1,where2:word);
Procedure ResetScrScrollUp(sst:word);
Procedure LoadFont( filename : string );
Procedure FreeFont;
Procedure WriteChar(x,y:integer;ch:char);
Procedure SetScrollStyle( FS,FG:integer;FC:boolean);
Procedure OutTextXY(x,y,fspace : integer ; msg : string);
Procedure SHLText(x1,x2,y:integer ; msg : string);
Procedure SHRText(x1,x2,y:integer ; msg : string);
Procedure SetScroll(x1,x2,y:integer;fontgrop:byte;fontciup:boolean;msg:string);
Procedure SHLTextOnce(nrf:byte);
Procedure SHRTextOnce(nrf:byte);
Procedure ResetScroll(nrf:byte);
Procedure VideoScreenOn;
Procedure VideoScreenOff;
Procedure VideoEnable;
Procedure VideoDisable;
Procedure PrintAt(x,y:byte);
Procedure Advance;
Procedure PrintC(a:char);
Procedure PrintS(s:string);
Procedure PrintN(n:integer);
Procedure Print(x,y:integer;s:string);
Procedure Morph(scr:virtualscreen;pal:palettetype;modul:byte);
Function  FileExist(FileName: string): Boolean;
Procedure SphericalProjection(scr1,scr2:virtualscreen;raza:byte);
Procedure TriangleProjection(scr1,scr2:virtualscreen;scara,panta:real;modul:byte);
Procedure Fog(x1,y1,x2,y2:word);
Procedure ZoomOut(scr1,scr2:virtualscreen;x1,y1:word;scarax,scaray:byte);
Procedure Rescale(scr1:virtualscreen;ax1,ay1,ax2,ay2:word;scr2:virtualscreen;bx1,by1,bx2,by2:word);
Procedure ZoomIn(scr1,scr2:virtualscreen;x1,y1:word;scarax,scaray:byte);

implementation

TYPE
        Letter = Array[1..16,1..16] of Byte;
        Letters = Array[' '..']'] of Letter;

const
   color        : byte     = 15;
   coordx       : integer  = 0;
   coordy       : integer  = 0;
   Font         : ^Letters = nil;
   FontSpace    : integer  = 0;
   FontGrosime  : integer  = 1;
   FontCiur     : boolean  = false;
   FontContor   : byte     = 0;
   Ssu          : word     = 0;

var
   AFontLoop1    : array [1..25] of byte;
   AFontLoop2    : array [1..25] of byte;
   AFontMsg      : array [1..25] of string;
   AFontX1       : array [1..25] of integer;
   AFontX2       : array [1..25] of integer;
   AFontY        : array [1..25] of integer;
   AFontLung     : array [1..25] of integer;
   AFontCiu      : array [1..25] of boolean;
   AFontGro      : array [1..25] of byte;


   FontLoop1    : byte;
   FontLoop2    : byte;
   FontMsg      : string;
   FontX1       : integer;
   FontX2       : integer;
   FontY        : integer;
   FontLung     : integer;
   FontCiu      : boolean;
   FontGro      : byte;

   type
    screen=array[1..64000] of byte;
   var
    ecran:screen absolute $a000:0000;
    i:word;
    cl,cl1,cl2:palettetype;
    i1,i2:^screen;
    p:pointer;
    t1,t2:boolean;
   const
    nrp:word=40;



Procedure ScrollNimic;
Begin
End;

Procedure SetMCGA;
begin
  asm
     mov        ax,0013h
     int        10h
  end;
  vgascreen :=ptr($a000,0);
  @ScrollProc:=addr(ScrollNimic);
end;

Procedure SetText;assembler;
  asm
     mov        ax,0003h
     int        10h
  end;

Procedure SetActiveScreen(scr:virtualscreen);
  begin
     where:=seg(scr^);
  end;

Procedure SetVisualScreen;
  begin
     flip(seg(scr^),$A000);
  end;


function FileExist(FileName: string): Boolean;
var f: file;
begin
  {$I-}
  Assign(f, FileName);
  Reset(f);
  Close(f);
  {$I+}
  FileExist := (IOResult = 0) and
   (FileName <> '');
end;


Procedure Cls (Col : Byte);assembler;
     asm
        mov     cx, 32000;
        mov     es,[where]
        xor     di,di
        mov     al,[col]
        mov     ah,al
        rep     stosw
     End;



Procedure Putpixel (X,Y : Integer; Col : Byte);assembler;
  Asm
    mov     ax,where
    mov     es,ax
    mov     ax,y
    mov     di,ax
    shl     ax,8
    shl     di,6
    add     di,ax
    add     di,x
    mov     al,col
    stosb
  End;

Function Getpixel;
var p:byte;
begin
  Asm
    mov     ax,where
    mov     es,ax
    mov     ax,y
    mov     si,ax
    shl     ax,8
    shl     si,6
    add     si,ax
    add     si,x
    mov     al,es:[si]
    mov     [p],al
  End;
  getpixel:=p;
end;

procedure moveto;
begin
 coordx:=x;
 coordy:=y;
end;

procedure moverel;
begin
 inc(coordx,dx);
 inc(coordy,dy);
end;


procedure lineto;
begin
 line(coordx,coordy,x,y,color);
 coordx:=x;coordy:=y;
end;

procedure linerel;
begin
 line(coordx,coordy,coordx+dx,coordy+dy,color);
 inc(coordx,dx);inc(coordy,dy);
end;

function getx:integer;
begin
 getx:=coordx;
end;

function gety:integer;
begin
 gety:=coordy;
end;

Procedure WaitRetrace; Assembler;
  Asm
    mov   dx,3DAh
    @@1:
    in    al,dx
    and   al,08h
    jnz   @@1
    @@2:
    in    al,dx
    and   al,08h
    jz    @@2
  End;


Procedure SetPal(Col,R,G,B : Byte);assembler;
   asm
      mov    dx,3c8h
      mov    al,[col]
      out    dx,al
      inc    dx
      mov    al,[r]
      out    dx,al
      mov    al,[g]
      out    dx,al
      mov    al,[b]
      out    dx,al
   end;


Procedure GetPal(Col : Byte; Var R,G,B : Byte);
Var
   rr,gg,bb : Byte;
Begin
   asm
      mov    dx,3c7h
      mov    al,col
      out    dx,al
      add    dx,2
      in     al,dx
      mov    [rr],al
      in     al,dx
      mov    [gg],al
      in     al,dx
      mov    [bb],al
   end;
   r := rr;
   g := gg;
   b := bb;
end;

procedure LoadPal;
var
    Fil : file of PaletteType;
Begin
  assign (Fil, FileName);
  reset (Fil);
  read (Fil, DAC);
  close (Fil);
End;

procedure LoadVisualPal;
var
    Dac : PaletteType;
Begin
  LoadPal(filename,dac);
  SetAllPal(dac);
End;

procedure SavePal;
var
    Fil : file of PaletteType;
Begin
  assign (Fil, FileName);
  rewrite (Fil);
  write (Fil, DAC);
  close (Fil);
End;

procedure flip(source,dest:Word);assembler;
  asm
    push    ds
    mov     ax, [Dest]
    mov     es, ax
    mov     ax, [Source]
    mov     ds, ax
    xor     si, si
    xor     di, di
    mov     cx, 16000
    db      $F3,$66,$A5  { REP MOVSD }
    pop     ds
  end;

Procedure FlipTransp;assembler;
asm
  push    ds
  mov     ax, Dest
  mov     es, ax
  mov     ax, Source
  mov     ds, ax
  xor     si,si
  xor     di,di
  mov     cx,64000
  cld
  @li:    mov bl,[si]
  or      bl,bl
  jnz     @ste
  inc     si
  inc     di
  loop    @li
  jmp     @ne
  @ste:   movsb
  loop    @li
  @ne:    pop ds
end;


Function GetIcoSize(x,y,z,t:word):word;
begin
  GetIcoSize:=(z-x)*(t-y)+3;
end;

Procedure putico(X,Y:Word; sprt:pointer ); ASSEMBLER;
label dr,ex,li,ne,ste,no;
asm
  push    bp
  push    ds
  mov     ax,where
  mov     es,ax
  lds     si,sprt
  mov     ax,y
  mov     di,ax
  shl     ax,8
  shl     di,6
  add     di,ax
  add     di,x
  cld
  lodsw
  xchg    ah,al
  mov     dl,[si]
  inc     si
  dr:     mov bp,di
  mov     cx,ax
  li:     mov bl,[si]
  or      bl,bl
  jnz     ste
  no:     inc si
  inc     di
  loop    li
  jmp     ne
  ste:    movsb
  loop    li
  ne:     mov di,bp
  dec     dl
  jz      ex
  add     di,320
  jmp     dr
  ex:     pop ds
  pop     bp
end;

Procedure putframe(X,Y:Word; sprt:pointer ); ASSEMBLER;
label dr,ex,li,ne,ste,no;
asm
  push    ds
  mov     ax,where
  mov     es,ax
  lds     si,sprt
  mov     ax,y
  mov     di,ax
  shl     ax,8
  shl     di,6
  add     di,ax
  add     di,x
  cld
  lodsw
  xchg    ah,al
  mov     dl,[si]
  inc     si
  dr:     mov bx,di
  mov     cx,ax
  rep     movsb
  mov     di,bx
  dec     dl
  jz      ex
  add     di,320
  jmp     dr
  ex:  pop     ds
end;

Procedure putmask(X,Y:Word; sprt:pointer ); ASSEMBLER;
label dr,ex,li,ne,ste,no;
asm
  push    ds
  mov     ax,where
  mov     es,ax
  lds     si,sprt
  mov     ax,y
  mov     di,ax
  shl     ax,8
  shl     di,6
  add     di,ax
  add     di,x
  cld
  lodsw
  xchg    ah,al
  mov     dl,[si]
  inc     si
  dr:     push di
  mov     cx,ax
  li:     mov bl,[si]
  and     es:[di],bl
  inc     si
  inc     di
  loop    li
  pop     di
  dec     dl
  jz      ex
  add     di,320
  jmp     dr
  ex:  pop     ds
end;

Procedure Mask;assembler;
asm
  push   ds
  lds    si,masca
  les    di,imag
  lodsw
  xchg   ah,al
  xor    bh,bh
  mov    bl,[si]
  inc    si
  mul    bx
  add    di,3
  mov    cx,ax
  @l1:   mov bl,ds:[si]
  and    es:[di],bl
  inc    si
  inc    di
  loop   @l1
  pop    ds
end;


Procedure Getico(X,Y,Z,T:Word; sprt:pointer ); ASSEMBLER;
label dr,ex,li,ne,ste,no;
asm
  push    ds
  mov     ax,where
  mov     ds,ax
  les     di,sprt
  mov     ax,z
  sub     ax,x
  mov     bx,t
  sub     bx,y
  cld
  xchg    ah,al
  stosw
  mov     al,bl
  stosb
  mov     ax,y
  mov     si,ax
  shl     ax,8
  shl     si,6
  add     si,ax
  add     si,x
  mov     cx,z
  sub     cx,x
  mov     dx,t
  sub     dx,y
  xor     ch,ch
  xor     dh,dh
  mov     ax,cx
  dr:     mov bx,si
  mov     cx,ax
  li:     movsb
  loop    li
  mov si,bx
  dec     dl
  jz      ex
  add     si,320
  jmp     dr
  ex:  pop     ds
end;

Procedure FunnyLine(a,b,c,d:integer;count1,count2:byte);
  function sgn(a:real):integer;
  begin
       if a>0 then sgn:=+1;
       if a<0 then sgn:=-1;
       if a=0 then sgn:=0;
  end;
var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
    count:integer;
begin
     count:=count1;
     u:= c - a;
     v:= d - b;
     d1x:= SGN(u);
     d1y:= SGN(v);
     d2x:= SGN(u);
     d2y:= 0;
     m:= ABS(u);
     n := ABS(v);
     IF NOT (M>N) then
     BEGIN
          d2x := 0 ;
          d2y := SGN(v);
          m := ABS(v);
          n := ABS(u);
     END;
     s := m shr 1;
     FOR i := 0 TO m DO
     BEGIN
          putpixel(a,b,count);
          inc (count);
          if count=count2+1 then count:=count1;
          s := s + n;
          IF not (s<m) THEN
          BEGIN
               s := s - m;
               a:= a + d1x;
               b := b + d1y;
          END
          ELSE
          BEGIN
               a := a + d2x;
               b := b + d2y;
          END;
     end;
END;

Procedure rotatepal(var OurPal:palettetype;count1,count2:byte);
VAR temp : Array [1..3] of byte;
    loop1:integer;
BEGIN
  Move(OurPal[count2],Temp,3);
  Move(OurPal[count1],OurPal[count1+1],(count2-count1)*3);
  Move(Temp,OurPal[count1],3);
END;

Procedure rotatepalback(var OurPal:palettetype;count1,count2:byte);
VAR temp : Array [1..3] of byte;
    loop1:integer;
BEGIN
  Move(OurPal[count1],Temp,3);
  Move(OurPal[count1+1],OurPal[count1],(count2-count1)*3);
  Move(Temp,OurPal[count2],3);
END;

Procedure rotatevisualpal(count1,count2:byte);
VAR
    ourpal:palettetype;
    temp : Array [1..3] of byte;
    loop1:integer;
BEGIN
  GetAllPal(ourpal);
  Move(OurPal[count2],Temp,3);
  Move(OurPal[count1],OurPal[count1+1],(count2-count1)*3);
  Move(Temp,OurPal[count1],3);
  SetAllPal(ourpal);
END;

Procedure rotatevisualpalback(count1,count2:byte);
VAR
    ourpal:palettetype;
    temp : Array [1..3] of byte;
    loop1:integer;
BEGIN
  GetAllPal(ourpal);
  Move(OurPal[count1],Temp,3);
  Move(OurPal[count1+1],OurPal[count1],(count2-count1)*3);
  Move(Temp,OurPal[count2],3);
  SetAllPal(ourpal);
END;


Procedure ScreenTrans ;assembler; { trebuie ca Lungime/2 = INT (Lungime/2) }
  asm
    push    ds
    mov     ax,vaddrwhere
    mov     es,ax
    mov     ax,vaddrfrom
    mov     ds,ax
    mov     ax,y
    mov     di,ax
    shl     ax,8
    shl     di,6
    add     di,ax
    add     di,x
    mov     si, di
    mov     ax,lungime
    mov     bx,inaltime
    mov     dx,320
    sub     dx,ax
    shr     ax,1
    @@1:    mov cx,ax
    rep     movsw
    add     di,dx
    mov     si,di
    dec     bx
    jnz     @@1
    pop     ds
  end;

Procedure QuickScreenTrans ;assembler;
  asm                             { trebuie ca Lungime/4 = INT (Lungime/4) }
    push    ds
    mov     ax,vaddrwhere
    mov     es,ax
    mov     ax,vaddrfrom
    mov     ds,ax
    mov     ax,y
    mov     di,ax
    shl     ax,8
    shl     di,6
    add     di,ax
    add     di,x
    mov     si, di
    mov     ax,lungime
    mov     bx,inaltime
    mov     dx,320
    sub     dx,ax
    shr     ax,2
    @@1:    mov cx,ax
    db      $F3,$66,$A5 { REP MOVSD }
    add     di,dx
    mov     si,di
    dec     bx
    jnz     @@1
    pop     ds
  end;


Procedure ScreenTransTransp ;assembler;
  asm
    push    ds
    mov     ax,vaddrwhere
    mov     es,ax
    mov     ax,vaddrfrom
    mov     ds,ax
    mov     ax,y
    mov     di,ax
    shl     ax,8
    shl     di,6
    add     di,ax
    add     di,x
    mov     si, di
    mov     ax,lungime
    mov     bx,inaltime
    mov     dx,320
    sub     dx,ax
    @@1:    mov cx,ax
    @li:    mov bh,[si]
    or      bh,bh
    jnz     @ste
    @no:    inc si
    inc     di
    loop    @li
    jmp     @ne
    @ste:   movsb
    loop    @li
    @ne:    add di,dx
    mov     si,di
    dec     bl
    jnz     @@1
    pop     ds
  end;

(*Procedure ScreenTransMask;assembler;
  asm
    push    ds
    push    bp
    lds     si,sursa
    les     di,dest
    db      $0F,$B4,$2E
    dw      offset masca
    dw      seg masca          { LFS BP,MASCA   }
    mov     ax,y
    mov     di,ax
    shl     ax,8
    shl     di,6
    add     di,ax
    add     di,x
    mov     si,di
    db      $64,$8B,$46,$00    { MOV AX,FS:[BP] }
    xchg    ah,al
    add     bp,2
    xor     bh,bh
    db      $64,$8A,$5E,$00    { MOV BL,FS:[BP] }
    inc     bp
    @@1:    mov cx,ax
    @@2:    db $64,$8A,$76,$00 { MOV DH,FS:[BP] }
    mov     dl,ds:[si]
    and     dh,dl
    mov     es:[di],dh
    inc     si
    inc     di
    inc     bp
    loop    @@2
    add     di,320
    sub     di,ax
    dec     bx
    jnz     @@1
    pop     bp
    pop     ds
 end;*)


Procedure Line(a,b,c,d:integer;col:byte);
  function sgn(a:real):integer;
  begin
       if a>0 then sgn:=+1;
       if a<0 then sgn:=-1;
       if a=0 then sgn:=0;
  end;
var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
begin
     u:= c - a;
     v:= d - b;
     d1x:= SGN(u);
     d1y:= SGN(v);
     d2x:= SGN(u);
     d2y:= 0;
     m:= ABS(u);
     n := ABS(v);
     IF NOT (M>N) then
     BEGIN
          d2x := 0 ;
          d2y := SGN(v);
          m := ABS(v);
          n := ABS(u);
     END;
     s := m shr 1;
     FOR i := 0 TO m DO
     BEGIN
          putpixel(a,b,col);
          s := s + n;
          IF not (s<m) THEN
          BEGIN
               s := s - m;
               a:= a + d1x;
               b := b + d1y;
          END
          ELSE
          BEGIN
               a := a + d2x;
               b := b + d2y;
          END;
     end;
END;

Procedure BLine;          { Dupa algoritmul lui Bresenham }
var i, deltax, deltay, numpixels,
    d, dinc1, dinc2,
    x, xinc1, xinc2,
    y, yinc1, yinc2 : integer;
    screen : word;
    screeninc1, screeninc2 : integer;
begin
  deltax := abs(x2 - x1);
  deltay := abs(y2 - y1);
  if deltax >= deltay then
    begin
      numpixels := deltax + 1;
      dinc1 := deltay + deltay;
      d := dinc1 - deltax;
      dinc2 := (deltay - deltax) shl 1;
      xinc1 := 1;
      xinc2 := 1;
      yinc1 := 0;
      yinc2 := 1;
    end
  else
    begin
      numpixels := deltay + 1;
      dinc1 := deltax + deltax;
      d := dinc1 - deltay;
      dinc2 := (deltax - deltay) shl 1;
      xinc1 := 0;
      xinc2 := 1;
      yinc1 := 1;
      yinc2 := 1;
    end;
  if x1 > x2 then
    begin
      xinc1 := - xinc1;
      xinc2 := - xinc2;
    end;
  if y1 > y2 then
    begin
      yinc1 := - yinc1;
      yinc2 := - yinc2;
    end;
  screen     := (word(y1) shl 8)+(word(y1) shl 6)+x1;
  screeninc1 := (yinc1 shl 8)+(yinc1 shl 6)+xinc1;
  screeninc2 := (yinc2 shl 8)+(yinc2 shl 6)+xinc2;
  asm
    mov ax,where
    mov es,ax
    mov di, screen
    mov dx, d
    mov al, color
    mov cx, numpixels
    mov bx, dinc1
    @bres1:
    mov es:[di], al
    cmp dx, 0
    jnl @bres2
    add dx, bx
    add di, screeninc1
    jmp @bres3
    @bres2:
    add dx, dinc2
    add di, screeninc2
    @bres3:
    loop @bres1
  end;
end;



Procedure Hline (x1,x2,y:word;col:byte); assembler;
asm
  mov   ax,where
  mov   es,ax
  mov   ax,y
  mov   di,ax
  shl   ax,8
  shl   di,6
  add   di,ax
  add   di,x1
  mov   al,col
  mov   ah,al
  mov   cx,x2
  sub   cx,x1
  shr   cx,1
  jnc   @start
  stosb
  @Start :
  rep   stosw
end;


Procedure VLine;assembler;
asm
  mov ax,where
  mov es,ax
  mov ax,y1
  mov di,ax
  shl ax,8
  shl di,6
  add di,ax
  add di,x
  mov al,col
  mov cx,y2
  sub cx,y1
  cld
  @l1: stosb
  add di,319
  loop @l1
end;

Procedure DrawPoly;
type poly = array [1..maxint div 2] of point2d;
var i:integer;
begin
for i:=1 to nrp-1 do line(
  poly(puncte)[i].x,
  poly(puncte)[i].y,
  poly(puncte)[i+1].x,
  poly(puncte)[i+1].y,
  getcolor);
end;

Procedure FillPoly;
var
  x:integer;
  mny,mxy:integer;
  mnx,mxx,yc:integer;
  mul1,div1,
  mul2,div2,
  mul3,div3,
  mul4,div4:integer;

begin
  mny:=y1; mxy:=y1;
  if y2<mny then mny:=y2;
  if y2>mxy then mxy:=y2;
  if y3<mny then mny:=y3;
  if y3>mxy then mxy:=y3;
  if y4<mny then mny:=y4;
  if y4>mxy then mxy:=y4;

  if mny<0 then mny:=0;
  if mxy>199 then mxy:=199;
  if mny>199 then exit;
  if mxy<0 then exit;

  mul1:=x1-x4; div1:=y1-y4;
  mul2:=x2-x1; div2:=y2-y1;
  mul3:=x3-x2; div3:=y3-y2;
  mul4:=x4-x3; div4:=y4-y3;

  for yc:=mny to mxy do
    begin
      mnx:=320;
      mxx:=-1;
      if (y4>=yc) or (y1>=yc) then
        if (y4<=yc) or (y1<=yc) then
          if not(y4=y1) then
            begin
              x:=(yc-y4)*mul1 div div1+x4;
              if x<mnx then
                mnx:=x;
              if x>mxx then
                mxx:=x;
            end;
      if (y1>=yc) or (y2>=yc) then
        if (y1<=yc) or (y2<=yc) then
          if not(y1=y2) then
            begin
              x:=(yc-y1)*mul2 div div2+x1;
              if x<mnx then
                mnx:=x;
              if x>mxx then
                mxx:=x;
            end;
      if (y2>=yc) or (y3>=yc) then
        if (y2<=yc) or (y3<=yc) then
          if not(y2=y3) then
            begin
              x:=(yc-y2)*mul3 div div3+x2;
              if x<mnx then
                mnx:=x;
              if x>mxx then
                mxx:=x;
            end;
      if (y3>=yc) or (y4>=yc) then
        if (y3<=yc) or (y4<=yc) then
          if not(y3=y4) then
            begin
              x:=(yc-y3)*mul4 div div4+x3;
              if x<mnx then
                mnx:=x;
              if x>mxx then
                mxx:=x;
            end;
      if mnx<0 then
        mnx:=0;
      if mxx>319 then
        mxx:=319;
      if mnx<=mxx then
        hline (mnx,mxx,yc,color);
    end;
  end;

Procedure FloodFill;
const dimstiva = 100;
var   stiva    : array [0..dimstiva] of integer;
      xi,yi,x,xmax,xmin,inint,culoare : integer;
      vfstiva:integer;
begin
 vfstiva:=1;
 stiva[0]:=xinit;stiva[1]:=yinit;
 while vfstiva>0 do
   begin
     yi:=stiva[vfstiva];dec(vfstiva);
     xi:=stiva[vfstiva];dec(vfstiva);
     putpixel(xi,yi,culumplere);
     x:=xi+1;
     while culcontur<>getpixel(x,yi) do begin
                                          putpixel(x,yi,culumplere);
                                          inc(x);
                                        end;
     xmax:=x;
     x:=xi-1;
     while culcontur<>getpixel(x,yi) do begin
                                          putpixel(x,yi,culumplere);
                                          dec(x);
                                        end;
     xmin:=x;
     inint:=0;
     for x:=xmin+1 to xmax-1 do
       begin
         culoare:=getpixel(x,yi-1);
         if (culoare<>culcontur) and (culoare<>culumplere)
                 then begin if inint=0 then inint:=1;end
                 else if inint=1 then begin
                                        if vfstiva=dimstiva-2 then break;
                                        inc(vfstiva);stiva[vfstiva]:=x-1;
                                        inc(vfstiva);stiva[vfstiva]:=yi-1;
                                        inint:=0;
                                      end;
       end;
     if inint=1 then
       begin
         if vfstiva=dimstiva-2 then break;
         inc(vfstiva);stiva[vfstiva]:=x-1;
         inc(vfstiva);stiva[vfstiva]:=yi-1;
       end;
     inint:=0;
     for x:=xmin+1 to xmax-1 do
       begin
         culoare:=getpixel(x,yi+1);
         if (culoare<>culcontur) and (culoare<>culumplere)
                 then begin if inint=0 then inint:=1;end
                 else if inint=1 then begin
                                        if vfstiva=dimstiva-2 then break;
                                        inc(vfstiva);stiva[vfstiva]:=x-1;
                                        inc(vfstiva);stiva[vfstiva]:=yi+1;
                                        inint:=0;
                                      end;
       end;
     if inint=1 then
       begin
         if vfstiva=dimstiva-2 then break;
         inc(vfstiva);stiva[vfstiva]:=x-1;
         inc(vfstiva);stiva[vfstiva]:=yi+1;
       end;
 end;
end;

procedure Ellipse;
procedure pixel(xcp,ycp,xp,yp:integer);
begin
 putpixel(xcp+xp,ycp+yp,cul);
 putpixel(xcp-xp,ycp+yp,cul);
 putpixel(xcp-xp,ycp-yp,cul);
 putpixel(xcp+xp,ycp-yp,cul);
end;
var x,y:integer;
    a,b:longint;
    a2,a22,b2,b22,fmi,dx,dy:longint;
begin
 a:=ia;b:=ib;
 x:=a;y:=0;
 a2:=a*a;b2:=b*b;
 a22:=a2 shl 1;b22:=b2 shl 1;
 dx:=a*b22;dy:=0;
 fmi:=(b2 shr 2)-a*b2+a2;
 while dx>dy do
  begin
    pixel(xc,yc,x,y);
    inc(y);
    inc(dy,a22);
    if fmi<0 then inc(fmi,dy+a2)
             else begin dec(x);dec(dx,b22);inc(fmi,dy+a2-dx);end;
  end;
 fmi:=3*(b2-a2) div 4 - (dy+dx) div 2;
 while x>=0 do
  begin
    pixel(xc,yc,x,y);
    dec(x);
    dec(dx,b22);
    if fmi>0 then inc(fmi,b2-dx)
             else begin inc(y);inc(dy,a22);inc(fmi,dy+b2-dx);end;
  end;
end;


procedure Circle(x,y,r:integer);  { Dupa algoritmul lui Bresenham }
var a,b,c,d:longint;
begin
  a:=r;b:=0;c:=r;d:=0;
  repeat
    putpixel(x+a,y+b,color);putpixel(x-a,y+b,color);
    putpixel(x-a,y-b,color);putpixel(x+a,y-b,color);
    putpixel(x+b,y+a,color);putpixel(x-b,y+a,color);
    putpixel(x-b,y-a,color);putpixel(x+b,y-a,color);
    inc(d,b+b+1);inc(b);
    if (d>c) then begin
                    inc(c,a+a+1);
                    dec(a);
                   end;
   until a<b;
end;

procedure FillCircle(xc,yc,r,culoare:integer);
var x,y,t:integer;
procedure linesim(xcp,ycp,xp,yp:integer);
begin
  line(xcp+xp,ycp+yp,xcp-xp,ycp+yp,culoare);
  line(xcp+xp,ycp-yp,xcp-xp,ycp-yp,culoare);
  line(xcp+yp,ycp+xp,xcp-yp,ycp+xp,culoare);
  line(xcp+yp,ycp-xp,xcp-yp,ycp-xp,culoare);
end;
begin
 t:=3-(r shl 1);
 HLine(xc-r,xc+r,yc,culoare);
 putpixel(xc,yc+r,culoare);
 putpixel(xc,yc-r,culoare);
 x:=1;y:=r;while x<y do
   begin
     if t<0 then inc(t,6+(x shl 2))
            else begin
                   inc(t,10+((x-y) shl 2));
                   dec(y);
                 end;
     linesim(xc,yc,x,y);
     inc(x);
   end;
 if x=y then linesim(xc,yc,x,y);
end;



Procedure Rectangle;
begin
  HLine(x1,x2,y1,color);
  Hline(x1,x2,y2,color);
  Vline(y1,y2,x1,color);
  Vline(y1,y2+1,x2,color);
end;

Procedure Bar;assembler;
asm
  push    bp
  mov     ax,where
  mov     es,ax
  mov     ax,y1
  mov     di,ax
  shl     ax,8
  shl     di,6
  add     di,ax
  add     di,x1
  mov     al,col
  mov     ah,al
  mov     cx,y2
  sub     cx,y1
  mov     dx,x2
  sub     dx,x1
  mov     bp,320
  sub     bp,dx
  shr     dx,1
  @l1:    mov bx,cx
  mov     cx,dx
  rep     stosw
  mov     cx,bx
  add     di,bp
  loop    @l1
  pop     bp
end;



Procedure SetAllPal;Assembler;
Asm
   {call  WaitRetrace}
   push  ds
   lds   si, Palet
   mov   dx, 3c8h
   mov   al, 0
   out   dx, al
   inc   dx
   mov   cx, 768
   rep   outsb
   pop   ds
End;

Procedure GetAllPal;Assembler;
Asm
   les   di, Palet
   mov   dx, 3c7h
   mov   al, 0
   out   dx, al
   inc   dx
   inc   dx
   mov   cx, 768
   rep   insb
End;

Procedure SetUpVirtual(var VirScr:VirtualScreen);
Begin
  GetMem (VirScr,64000);
End;

Function  ScreenAddr(VS:VirtualScreen):word;
begin
  ScreenAddr:=seg(VS^);
end;

Procedure ShutDownVirtual(var VirScr:VirtualScreen);
Begin
  FreeMem (VirScr,64000);
End;

Function GetMaxX:Integer;
begin
  GetMaxX:=memw[0:$44a]*8;
end;

Function GetMaxY:Integer;
begin
  GetMaxY:=(mem[0:$484]+1)*memw[0:$485];
end;

Function GetMaxColor;
begin
  GetMaxColor:=255;
end;

Procedure SetColor;
begin
  Color:=c;
end;

Function GetColor:byte;
begin
  GetColor:=color;
end;

Function GetVideoMode:byte;
begin
  GetVideoMode:=mem[0:$449];
end;

Procedure LoadIcon;
var
    l     : word;
    f     : file;
begin
    assign(f,filename);
    reset(f,1);l:=filesize(f);close(f);
    reset(f,l);
    blockread(f,poin^,1);
    close(f);
end;

Procedure SaveIcon;
var
    l     : word;
    sb,ob : word;
    f     : file;
begin
    sb:=seg(poin^);ob:=ofs(poin^);
    assign(f,filename);
    l:=3+(256*mem[sb:ob]+mem[sb:ob+1])*(mem[sb:ob+2]);
    rewrite(f,l);
    blockwrite(f,poin^,1);
    close(f);
end;

Procedure SaveScreen;
var f : file;
begin
    assign(f,filename);
    rewrite(f,64000);
    blockwrite(f,scr^,1);
    close(f);
end;

Procedure LoadScreen;
var f:file;
begin
    assign(f,filename);
    reset(f,64000);
    blockread(f,scr^,1);
    close(f);
end;

Procedure FadeDown;
Var loop1,loop2:integer;
    Tmp : Array [1..3] of byte;
Begin
  For loop1:=0 to 63 do BEGIN
    WaitRetrace;
    For loop2:=0 to 255 do BEGIN
      GetPal (loop2,Tmp[1],Tmp[2],Tmp[3]);
      If Tmp[1]>rv then dec (Tmp[1]);If Tmp[1]<rv then inc (Tmp[1]);
      If Tmp[2]>gv then dec (Tmp[2]);If Tmp[2]<gv then inc (Tmp[2]);
      If Tmp[3]>bv then dec (Tmp[3]);If Tmp[3]<bv then inc (Tmp[3]);
      SetPal (loop2,Tmp[1],Tmp[2],Tmp[3]);
    end;
  end;
end;

Procedure Fadeup;
Var loop1,loop2:integer;
    Tmp : Array [1..3] of byte;
Begin
  For loop1:=0 to 63 do BEGIN
    WaitRetrace;
    For loop2:=0 to 255 do BEGIN
      Getpal (loop2,Tmp[1],Tmp[2],Tmp[3]);
      If Tmp[1]<Pall2[loop2,1] then inc (Tmp[1]);
      If Tmp[2]<Pall2[loop2,2] then inc (Tmp[2]);
      If Tmp[3]<Pall2[loop2,3] then inc (Tmp[3]);
      If Tmp[1]>Pall2[loop2,1] then dec (Tmp[1]);
      If Tmp[2]>Pall2[loop2,2] then dec (Tmp[2]);
      If Tmp[3]>Pall2[loop2,3] then dec (Tmp[3]);
      SetPal (loop2,Tmp[1],Tmp[2],Tmp[3]);
    end;
  end;
end;

Procedure VideoScreenOn;assembler;
asm
 mov ah,12h
 mov bl,36h
 xor al,al
 int 10h
end;

Procedure VideoScreenOff;assembler;
asm
 mov ah,12h
 mov bl,36h
 mov al,1
 int 10h
end;

Procedure VideoEnable;assembler;
asm
 mov ah,12h
 mov bl,32h
 xor al,al
 int 10h
end;

Procedure VideoDisable;assembler;
asm
 mov ah,12h
 mov bl,32h
 mov al,1
 int 10h
end;

Procedure SHLBox;
 begin
   Vline(y1,y2,x2-1,col);
   SHLBox2(x1,y1,x2,y2);
 end;

Procedure SHRBox;
 begin
   Vline(y1,y2,x1,col);
   SHRBox2(x1,y1,x2,y2);
 end;

Procedure SHUBox;
 begin
   HLine(x1,x2,y2,col);
   SHUBox2(x1,y1,x2,y2);
 end;

Procedure SHDBox;
 begin
   HLine(x1,x2,y1,col);
   SHDBox2(x1,y1,x2,y2);
 end;

Procedure SHLBox2;assembler;
asm
  push    ds
  mov     ax,where
  mov     es,ax
  mov     ds,ax
  mov     ax,y1
  mov     di,ax
  shl     ax,8
  shl     di,6
  add     di,ax
  add     di,x1    { di = adresa coltului stinga-sus }
  mov     si,di
  inc     si       { si = adresa coltului stinga-sus + 1 }
  mov     cx,y2
  sub     cx,y1    { cx = inaltimea }
  mov     dx,x2
  sub     dx,x1
  shr     dx,1     { dx = lungimea / 2 }
  mov     ax,320
  cld
  @l1:    mov bx,cx
  mov     cx,dx
  rep     movsw
  mov     cx,bx
  add     di,ax
  sub     di,dx
  sub     di,dx
  mov     si,di
  inc     si
  loop    @l1
  pop     ds
end;


Procedure SHRBox2;assembler;
asm
  push    ds
  mov     ax,where
  mov     es,ax
  mov     ds,ax
  mov     ax,y1
  mov     si,ax
  shl     ax,8
  shl     si,6
  add     si,ax
  add     si,x1
  mov     cx,y2
  sub     cx,y1    { cx = inaltimea }
  mov     dx,x2
  sub     dx,x1    { dx = lungimea }
  add     si,dx
  mov     di,si    { di = adresa coltului dreapta-sus }
  dec     si       { si = adresa coltului dreapta-sus -1 }
  std
  @l1:    mov bx,cx
  mov     cx,dx
  rep     movsb
  mov     cx,bx
  add     di,320
  add     di,dx
  mov     si,di
  dec     si
  loop    @l1
  cld
  pop     ds
end;


Procedure SHUBox2;assembler;
asm
  push   ds
  mov    ax,where
  mov    es,ax
  mov    ds,ax
  mov    bx,320
  mov    ax,y1
  mov    di,ax
  shl    ax,8
  shl    di,6
  add    di,ax
  add    di,x1
  mov    si,di
  add    si,bx
  mov    dx,y2
  sub    dx,y1
  mov    cx,x2
  sub    cx,x1
  @l1:   mov ax,cx
  shr    cx,1
  rep    movsw
  mov    cx,ax
  add    di,bx
  sub    di,cx
  mov    si,di
  add    si,bx
  dec    dx
  jnz    @l1
  pop    ds
end;

Procedure SHDBox2;assembler;
asm
  push   ds
  mov    ax,where
  mov    es,ax
  mov    ds,ax
  mov    bx,320
  mov    ax,y2
  mov    di,ax
  shl    ax,8
  shl    di,6
  add    di,ax
  add    di,x1
  mov    si,di
  sub    si,bx
  mov    dx,y2
  sub    dx,y1
  mov    cx,x2
  sub    cx,x1
  @l1:   mov ax,cx
  shr    cx,1
  rep    movsw
  mov    cx,ax
  sub    si,bx
  sub    si,cx
  mov    di,si
  add    di,bx
  dec    dx
  jnz    @l1
  pop    ds
end;

Procedure ScreenScrollUp;assembler;
asm
  push   ds
  mov    ax,where1
  mov    es,ax
  mov    ds,ax
  mov    si,320
  xor    di,di
  mov    cx,15920
  db     $F3,$66,$A5 { REP MOVSD }
  mov    ax,where2
  mov    ds,ax
  mov    ax,ssu
  mov    si,ax
  mov    di,63680
  mov    cx,80
  db     $F3,$66,$A5 { REP MOVSD }
  add    ax,320
  cmp    ax,64000
  jnz    @l1
  xor    ax,ax
  @l1:   mov ssu,ax
  pop    ds
end;


Procedure ResetScrScrollUp;assembler;
asm
  mov ax,sst
  mov ssu,ax
end;

Procedure ROLBox;
var f:word;
    p:byte;
begin
  For f := y1 to y2 do
              begin
                p:=getpixel(x1,f);
                move (mem[vga:x1+(f*320)+1],mem[vga:x1+(f*320)],x2-x1-1);
                putpixel(x2-1,f,p);
              end;
end;

Procedure RORBox;
var f:word;
    p:byte;
begin
  For f := y1 to y2 do
              begin
                p:=getpixel(x2-1,f);
                move (mem[vga:x1+(f*320)],mem[vga:x1+(f*320)+1],x2-x1-1);
                putpixel(x1,f,p);
              end;
end;

Procedure LoadFont;
var f:file;
begin
  if font<>nil then freemem(font,15872);
  getmem(font,15872);
  assign(f,filename);
  reset(f,15872);
  blockread(f,font^,1);
  close(f);
end;

Procedure FreeFont;
begin
  freemem(font,15872);
end;

Procedure WriteChar;
var    a : letter;
       b : letter;
procedure trans(m1:letter;var m2:letter);
var l,c:byte;
begin
  for l:=1 to 16 do
    for c:=1 to 16 do
      m2[l,c]:=m1[c,l];
end;
Procedure putchar(X,Y:Word; var sprt ); ASSEMBLER;
label dr,ex,li,ne,ste,no;
asm
  push    ds
  mov     ax,where
  mov     es,ax
  lds     si,sprt
  mov     ax,y
  mov     di,ax
  shl     ax,8
  shl     di,6
  add     di,ax
  add     di,x
  cld
  xor     ch,ch
  mov     cl,16
  mov     dl,16
  mov     ax,cx
  dr:     push di
  mov     cx,ax
  li:     mov bl,[si]
  or      bl,bl
  jnz     ste
  no:     inc si
  inc     di
  loop    li
  jmp     ne
  ste:    movsb
  loop    li
  ne:     pop di
  dec     dl
  jz      ex
  add     di,320
  jmp     dr
  ex:     pop ds
end;
begin
  move(font^[ch],b,256);
  trans(b,a);
  putchar(x,y,a);
end;


Procedure Outtextxy;
Var Loop1 : Integer;
 begin
    For loop1:=0 to length (msg)-1 do
         begin
            writechar(x+loop1*(16+fspace),y,msg[loop1+1]);
         end;
 end;

Procedure SetScrollStyle;
begin
 FontSpace:=FS;
 FontGrosime:=FG;
 FontCiur:=FC;
end;

Procedure SHLText;
Var Loop1,loop2,loop3,f : Integer;
begin
    For loop1:=1 to length (msg) do BEGIN
        for f:=1 to FontSpace do shlbox(x1,y,x2,y+16,0);
        If ScrollBreak=true then begin ScrollBreak:=false;break;end;
        For loop2:=1 to 16 do BEGIN
            ScrollProc;
            for loop3:=y to y+16-1 do
                putpixel (x2-1,loop3,font^[msg[loop1],loop2,loop3-y+1]);
            waitretrace;
            for loop3 := 1 to FontGrosime do
            {For f := y to y+16 do
            move (mem[where:x1+(f*320)+1],mem[where:x1+(f*320)],x2-x1-1);}
            SHLBox2(x1,y,x2,y+16);
                If FontCiur then SHLBox(x1,y,x2,y+16,0);
         end;
    end;
end;

Procedure SHRText;
Var Loop1,loop2,loop3,f : Integer;
begin
    For loop1:=1 to length (msg) do BEGIN
        for f:=1 to FontSpace do shrbox(x1,y,x2,y+16,0);
        If ScrollBreak=true then begin ScrollBreak:=false;break;end;
        For loop2:=1 to 16 do BEGIN
            ScrollProc;
            for loop3:=y to y+16-1 do
                putpixel (x1,loop3,font^[msg[loop1],loop2,loop3-y+1]);
            waitretrace;
            for loop3 := 1 to FontGrosime do
            shrbox2(x1,y,x2,y+16);
            If FontCiur then shrbox(x1,y,x2,y+16,0);
         end;
    end;
end;


Procedure ResetScroll;
begin
  FontContor:=nrf-1;
end;

Procedure SetScroll;
begin
 Inc(FontContor);
 AFontX1[FontContor]    := x1;
 AFontX2[FontContor]    := x2;
 AFontY[FontContor]     := Y ;
 AFontMsg[FontContor]   := msg;
 AFontLoop1[FontContor] := 1;
 AFontLoop2[FontContor] := 1;
 AFontLung [FontContor] := Length(msg);
 AFontCiu  [FontContor] := fontciup;
 AFontGro  [FontContor] := fontgrop;
end;


Procedure SHLTextOnce;
Var Loop1,loop2,loop3,f : Integer;
begin

   FontLoop1    := AFontLoop1[nrf];
   FontLoop2    := AFontLoop2[nrf];
   FontMsg      := AFontMsg[nrf];
   FontX1       := AFontX1[nrf];
   FontX2       := AFontX2[nrf];
   FontY        := AFontY[nrf];
   FontLung     := AFontLung[nrf];
   FontCiu      := AFontCiu[nrf];
   FontGro      := AFontGro[nrf];

        for loop3:=fonty to fonty+16-1 do
          putpixel (fontx2-1,loop3,font^[fontmsg[fontloop1],fontloop2,loop3-fonty+1]);
        for loop3 := 1 to FontGro do SHLBox2(fontx1,fonty,fontx2,fonty+16);
        If FontCiu then SHLBox(fontx1,fonty,fontx2,fonty+16,0);
        inc(afontloop2[nrf]);
        if afontloop2[nrf]=17 then begin inc(afontloop1[nrf]);afontloop2[nrf]:=1;end;
        if afontloop1[nrf]=aFontLung[nrf]+1 then begin afontloop1[nrf]:=1;afontloop2[nrf]:=1;end;
end;

Procedure SHRTextOnce;
Var Loop1,loop2,loop3,f : Integer;
begin

   FontLoop1    := AFontLoop1[nrf];
   FontLoop2    := AFontLoop2[nrf];
   FontMsg      := AFontMsg[nrf];
   FontX1       := AFontX1[nrf];
   FontX2       := AFontX2[nrf];
   FontY        := AFontY[nrf];
   FontLung     := AFontLung[nrf];
   FontCiu      := AFontCiu[nrf];
   FontGro      := AFontGro[nrf];

        for loop3:=fonty to fonty+16-1 do
          putpixel (fontx1+1,loop3,font^[fontmsg[fontloop1],fontloop2,loop3-fonty+1]);
        for loop3 := 1 to FontGro do SHRBox2(fontx1,fonty,fontx2,fonty+16);
        If FontCiu then SHRBox(fontx1,fonty,fontx2,fonty+16,0);
        inc(afontloop2[nrf]);
        if afontloop2[nrf]=17 then begin inc(afontloop1[nrf]);afontloop2[nrf]:=1;end;
        if afontloop1[nrf]=aFontLung[nrf]+1 then begin afontloop1[nrf]:=1;afontloop2[nrf]:=1;end;
end;

procedure PrintAt;
begin
  asm
    push     bp
    mov ah , $02
    mov dh , x
    mov dl , y
    mov bh , 0
    int      $10
    pop      bp
  end
end;

procedure Advance;
begin
  asm
    push bp
    mov ah,3
    mov bh,0
    int $10
    inc dl
    mov ah,2
    mov bh,0
    int 10h
    pop bp
  end
end;

procedure PrintC(a:char);
var c:integer;
begin
  c:=getcolor;
  asm
    push bp
    mov ah,9
    mov al,a
    mov bx,c
    mov cx,1
    int 10h
    pop bp
  end;
  advance;
end;

procedure PrintS;
var i:byte;
begin
  for i:=1 to length(s) do printc(s[i])
end;

procedure print;
 begin
  PrintAt(x,y);
  PrintS(s);
 end;

procedure PrintN;
var s:string[10];
begin
  str(n,s);
  prints(s);
end;

Procedure Morph(scr:virtualscreen;pal:palettetype;modul:byte);
procedure media(n:word);        { modul = 1 - paleta & imaginea impreuna }
var i:word;                     { modul = 2 - paleta inaintea imaginii   }
begin                           { modul = 3 - imaginea inaintea paletei  }
  for i:=0 to 255 do
   begin
     cl[i,1]:=(cl1[i,1]*(nrp-n)+cl2[i,1]*n) div nrp;
     cl[i,2]:=(cl1[i,2]*(nrp-n)+cl2[i,2]*n) div nrp;
     cl[i,3]:=(cl1[i,3]*(nrp-n)+cl2[i,3]*n) div nrp
   end
end;
procedure media1(nrp,n,nrpn:byte);assembler;
asm
  push ds
  mov di,$a000
  mov es,di
  xor di,di
  lds si,i1
  mov ax,si
  mov bx,ds
  shr ax,4
  add bx,ax
  mov ds,bx
  mov dx,15
  and si,dx
  mov cx,32000
  @e1:
  xor ah,ah
  mov al,[ds:si]
  mul n
  mov bx,ax
  xor ah,ah
  mov al,[ds:si+32000]
  mul nrpn
  add ax,bx
  div nrp
  mov [es:di],al
  inc di
  inc si
 loop @e1
  pop ds
end;
procedure media2(nrp,n,nrpn:byte);assembler;
asm
  push ds
  mov di,$a000
  mov es,di
  mov di,32000
  lds si,i2
  mov ax,si
  mov bx,ds
  shr ax,4
  add bx,ax
  mov ds,bx
  mov dx,15
  and si,dx
  mov cx,32000
  @e1:
  mov ah,0
  mov al,[ds:si]
  mul n
  mov bx,ax
  xor ah,ah
  mov al,[ds:si+32000]
  mul nrpn
  add ax,bx
  div nrp
  mov [es:di],al
  inc di
  inc si
  loop @e1
  pop ds
end;

  begin
  case modul of
   1:begin t1:=true ;t2:=false;end;
   2:begin t1:=false;t2:=true ;end;
   3:begin t1:=false;t2:=false;end;
   4:begin t1:=true ;t2:=true ;end;
  end;
  mark(p);
  new(i1);
  new(i2);
  move(ecran[00001],i1^[1],32000);
  move(ecran[32001],i2^[1],32000);
  getallpal(cl1);

     move(scr^[000,0],i1^[32001],32000);
     move(scr^[100,0],i2^[32001],32000);
     move(pal,cl2,768);
     media(0);
     setallpal(cl);

  if t2 then
   begin
    for i:=0 to nrp do
     begin
       media(i);
       setallpal(cl);
     end;
    end;
  for i:=0 to nrp do
    begin
      media1(nrp,nrp-i,i);
      media2(nrp,nrp-i,i);
      if t1 then  begin
                    media(i);
                    setallpal(cl);
                  end;
    end;
  if not(t2) and not(t1) then
   begin
    for i:=0 to nrp do
     begin
       media(i);
       setallpal(cl);
     end;
 end;
  dispose(i1);
  dispose(i2);
  release(p);
end;


Procedure SphericalProjection;
var t     : array [0..199] of word;
    p,j   : word;
    r1,r2 : word;
    i     : byte;
begin
  r1:=raza;
  for i:=0 to 199 do t[i]:=20+trunc(abs(2*sqrt(r1*r1-(i-100)*(i-100))));
  for i:=0 to 199 do begin
    p:=(320-t[i]) div 2;
    for j:=0 to t[i] do
    if (j+p<320) then if (j+p>0) then
       scr2^[i,j+p]:=scr1^[i,abs(j)*320 div (t[i]+1)];
  end;
end;


Procedure TriangleProjection(scr1,scr2:virtualscreen;scara,panta:real;modul:byte);
var t     : array [0..199] of word;
    p,j   : word;
    r1,r2 : word;
    i     : byte;
begin
  if modul=1 then for i:=0 to 199 do t[i]:=trunc(scara*(i));
  if modul=2 then for i:=0 to 199 do t[i]:=trunc(scara*(199-i));
  for i:=0 to 199 do begin
    p:=trunc((320-t[i])/panta);
    for j:=0 to t[i] do
    if (j+p<320) then if (j+p>0) then
      scr2^[i,j+p]:=scr1^[i,abs(j)*320 div (t[i]+1)];
  end;
end;

Procedure Fog;
var s,t:word;
begin
for s:=x1+1 to x2-1 do for t:=y1+1 to y2-1 do
putpixel(s,t ,(getpixel(s-1,t-1)+getpixel(s-1,t)+getpixel(s-1,t+1)+getpixel(s,t-1 )+
             getpixel(s,t )+getpixel(s,t+1 )+getpixel(s+1,t-1)+getpixel(s+1,t)+
             getpixel(s+1,t+1)) div 9 );
end;


Procedure ZoomOut;
var i,j,temp2:word;
    x2,y2:word;
begin
 x2:=320 div scarax;y2:=200 div scaray;
  for i:=y1 to y1+y2-1 do for j:=x1 to x1+x2-1 do
     scr2^[i,j]:=scr1^[i*scaray-scaray*y1,j*scarax-scarax*x1];
end;


Procedure Rescale;
var i,j,temp2:word;
    scarax,scaray:real;
begin
 scarax:=(ax2-ax1)/(bx2-bx1);scaray:=(ay2-ay1)/(by2-by1);
  for i:=by1 to by2-1 do for j:=bx1 to bx2-1 do
    scr2^[i,j]:=scr1^[trunc(ay1+i*scaray-scaray*by1),trunc(ax1+j*scarax-scarax*bx1)];
end;


Procedure ZoomIn;
var i,j,temp2:word;
begin
  for i:=0 to 199 do for j:=0 to 319 do
    scr2^[i,j]:=scr1^[y1+(i div scaray),x1+(j div scarax)];
end;

end.
