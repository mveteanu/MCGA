(*
    旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
    �   Aceasta este versiunea pentru modul protejat a unitului MCGA     �
    �                < Atentie : Are inca multe bug-uri >                �
    읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*)

{$A+,G+,X+,N+,E-,R-,S-,D-,L-,Q-}
unit MCGADPMI;
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
   ScrollBreak  : boolean   =  false;
Var
   VgaScreen  : VirtualScreen;
   ScrollProc : procedure;
   Where      : word;

Procedure SetMCGA;
Procedure SetText;
Procedure SetActiveScreen(scr:VirtualScreen);
Procedure SetVisualScreen(scr:VirtualScreen);
Procedure Cls (Col : Byte);
Procedure Putpixel (X,Y : Integer; Col : Byte);
Function  GetPixel (X,Y : Integer) :  Byte;
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
Procedure Ellipse(x,y:word;a,b:longint;col:byte);
Procedure GEllipse(x,y:word;a,b:longint;col:byte);
Procedure FillEllipse(x,y:word;a,b:longint;col:byte);
Procedure Circle(x,y,r:word);
Procedure GCircle(x,y,r:word;col:byte);
Procedure FillCircle(x,y,r:word;col:byte);
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
Procedure ScreenScrollUp(where1,where2,lin1,lin2:word);
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
Function  FileExist(FileName : string): Boolean;
Procedure SphericalProjection(scr1,scr2:virtualscreen;raza:byte);
Procedure TriangleProjection(scr1,scr2:virtualscreen;scara,panta:real;modul:byte);
Procedure Fog(x1,y1,x2,y2:word);
Procedure ZoomOut(scr1,scr2:virtualscreen;x1,y1:word;scarax,scaray:byte);
Procedure Rescale(scr1:virtualscreen;xx1,yy1,xx2,yy2:word;scr2:virtualscreen;x1,y1,x2,y2:word);
Procedure ZoomIn(scr1,scr2:virtualscreen;x1,y1:word;scarax,scaray:byte);
Procedure SetBWZone(zona:byte);
Procedure CreateUniformPal(var pal:palettetype);
Procedure CreateBWPal(var pal:palettetype);
Procedure CreateBWScreen(scrsursa:virtualscreen;palsursa:palettetype;var scrdest:virtualscreen);
Procedure MediaScreen(scr1,scr2,scr:virtualscreen;nrp,i1,i2:byte);
Procedure MediaPal(var pal1,pal2,pal:palettetype;nrp,i1,i2:byte);
Procedure ChangeScreenPal(scr1:virtualscreen;pal1:palettetype;scr2:virtualscreen;pal2:palettetype);

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
   BWZone       : byte     = 0;


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


Procedure ScrollNimic;
Begin
End;

Procedure SetMCGA;
begin
  asm
     mov        ax,0013h
     int        10h
  end;
  vgascreen :=ptr(SegA000,0);
  @ScrollProc:=addr(ScrollNimic);
  where:=sega000;
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
     flip(seg(scr^),SegA000);
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
        mov     cx, 16000
        mov     es,[where]
        xor     di,di
        mov     al,[col]
        mov     ah,al
        push    ax
        push    ax
        db 66h; pop ax   { pop eax   }
        cld
        db $f3,$66,$ab   { rep stosd }
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

Function Getpixel;assembler;
  Asm
    mov     ax,where
    mov     es,ax
    mov     ax,y
    mov     si,ax
    shl     ax,8
    shl     si,6
    add     si,ax
    add     si,x       { conform conventiei Turbo Pascal valoarea functiei }
    mov     al,es:[si] { fiind de tip byte este intoarsa in registrul al   }
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


Procedure GetPal(Col:byte;var R,G,B:Byte);assembler;
asm
  mov dx,3C7h
  mov al,Col
  out dx,al
  inc dx
  inc dx
  in al,dx
  les bx,r
  mov [es:bx],al
  in al,dx
  les bx,g
  mov [es:bx],al
  in al,dx
  les bx,b
  mov [es:bx],al
end;

procedure LoadPal;
var
    Fil : file of PaletteType;
Begin
  assign (Fil, FileName);
  {$I-}reset (Fil);{$I+}
  if ioresult<>0 then begin
                        settext;
                        writeln(' Eroare de executie !');
                        writeln(' Fisierul '+filename+' este inexistent');
                        halt(1);
                      end;
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
    cld
    mov     ax,where
    mov     es,ax
    mov     ax,y
    mov     di,ax
    mov     ah,al
    xor     al,al
    shl     di,6
    add     di,ax
    add     di,x1
    mov     al,col
    mov     cx,x2
    sub     cx,x1
    cmp     cx,3
    ja      @jmpq
    rep     stosb
    jmp @jmp01
@jmpq:
    mov     ah,al
    push    ax
    push    ax
    db      66h
    pop     ax
    mov     bx,x1
    and     bx,00000011b
    jz      @jmp1
    shr     bx,1
    jnc     @jmp2
    jz      @jmp3
    stosb
    dec cx
    jmp      @jmp1
@jmp3:
    stosb
    dec cx
@jmp2:
    stosw
    sub      cx,2
@jmp1:
    mov      bx,cx
    shr      cx,2
    db       0f3h,066h
    stosw
    and     bx,00000011b
    jz      @jmp01
    shr     bx,1
    jnc     @jmp02
    jnz     @jmp03
    stosb
    jmp      @jmp01
@jmp03:
    stosb
@jmp02:
    stosw
@jmp01:
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

procedure Ellipse(x,y:word;a,b:longint;col:byte);assembler;
var di1,di2,di3,di4,di5,di6,di7,di8:word;
    a2,b2,a22,b22:longint;
  {Astea-s salvarile registrului DS}
asm
  {Calculeaza pozitia centrului\/}
  mov ax,where
  mov es,ax
  mov ax,y
  mov di,ax
  mov ah,al
  mov al,0
  shl di,6
  add di,ax
  add di,x
  {/\}
  {pune primele puncte\/}
  mov al,col    {de ce cred eu ca primele puncte se pun tot in ciclu?}
  mov si,di
  add si,word ptr[a]
  mov di1,si
  mov di8,si
  mov si,di
  sub si,word ptr[a]
  mov di4,si
  mov di5,si
  {calculeaza diferenta in bytes pe verticala}
  mov cx,word ptr[b]
  mov dx,cx
  mov ch,cl
  mov cl,0
  shl dx,6
  add dx,cx
  mov si,di
  sub si,dx
  mov di2,si
  mov di3,si
  mov si,di
  add si,dx
  mov di6,si
  mov di7,si
  {/\}
  {Initzializarea variabilelor pe 32 biti:\/}
  db 66h;mov ax,0;dw 0       {mov eax,0}
  db 66h;mov bx,ax           {mov ebx,eax}
  db 66h;mov cx,ax           {mov ecx,eax}
  db 66h;mov dx,ax           {mov edx,eax}
  db 66h;mov si,ax           {mov esi,eax}
  db 66h;mov di,ax           {mov edi,eax}

  db 66h;mov ax,word ptr[b]  {mov ax,b}
  db 66h;mul ax              {mul eax}
  db 66h;mov word ptr [b2],ax{mov b2,eax}
  db 66h;add ax,ax           {add eax,eax}
  db 66h;mov di,ax           {mov edi,eax}
  db 66h;mul word ptr[a]     {mul a}
  db 66h;mov bx,ax           {mov ebx,eax}
  db 66h;mov ax,word ptr[a]  {mov eax,a}
  db 66h;mul ax              {mul eax}
  db 66h;mov word ptr [a2],ax{mov a2,eax}
  db 66h;mov si,ax           {mov esi,eax}
  db 66h;mov cx,di           {mov ecx,edi}
  db 66h;shr cx,3            {shr ecx,2}
  db 66h;mov ax,bx           {mov eax,ebx}
  db 66h;shr ax,1            {shr eax,1}
  db 66h;sub cx,ax           {add ecx,eax}
  db 66h;add cx,word ptr [a2]{sub ecx,a2}
  db 66h;mov dx,bx           {mov edx,ebx}
  db 66h;xor bx,bx           {xor ebx,ebx}
  {/\}
  mov al,col
  db 66h;mov word ptr [b22],di{mov b22,edi}          {pune la pastrare}
  {Urmeaza ciclul}
@loop1:
  db 66h;cmp dx,bx           {cmp edx,ebx}
  jng @exit1                 {while edx>ebx}
  {pune punctele si face inc(b) numai in puncte,nu incrementeaza bx\/}

  mov di,di1
  mov [es:di],al
  sub di,320
  mov di1,di

  mov di,di4
  mov [es:di],al
  sub di,320
  mov di4,di

  mov di,di5
  mov [es:di],al
  add di,320
  mov di5,di

  mov di,di8
  mov [es:di],al
  add di,320
  mov di8,di

  db 66h;mov di,word ptr [b22]{mov edi,b22}
  {/\}
  db 66h;add bx,si        {dy+=2*b^2}
  db 66h;add bx,si
  {conditia:}
  db 66h;or cx,cx         {or ecx,ecx}
  jns @else1
  db 66h;add cx,bx        {add ecx,ebx}
  db 66h;add cx,si        {add ecx,esi}
  jmp @loop1
@else1:
  db 66h;sub dx,di        {sub edx,edi}
  db 66h;add cx,bx        {add ecx,ebx}
  db 66h;add cx,si        {edd ecx,esi}
  db 66h;sub cx,dx        {sub ecx,edx}
  {Decrementeaza a doar pentru puncte:}
  mov di,di1
  dec di
  mov di1,di

  mov di,di4
  inc di
  mov di4,di

  mov di,di5
  inc di
  mov di5,di

  mov di,di8
  dec di
  mov di8,di
  jmp @loop1                  {./\.}
  {/\}
@exit1:
  mov di,di1
  mov [es:di],al

  mov di,di4
  mov [es:di],al

  mov di,di5
  mov [es:di],al

  mov di,di8
  mov [es:di],al

  {partea ][:}
  {Initzializarea variabilelor pe 32 biti:\/}
  db 66h;mov ax,0;dw 0       {mov eax,0}
  db 66h;mov bx,ax           {mov ebx,eax}
  db 66h;mov cx,ax           {mov ecx,eax}
  db 66h;mov dx,ax           {mov edx,eax}
  db 66h;mov si,ax           {mov esi,eax}
  db 66h;mov di,ax           {mov edi,eax}

  db 66h;mov ax,word ptr[a]  {mov ax,b}
  db 66h;mul ax              {mul eax}
  db 66h;mov word ptr [a2],ax{mov b2,eax}
  db 66h;add ax,ax           {add eax,eax}
  db 66h;mov di,ax           {mov edi,eax}
  db 66h;mul word ptr[b]     {mul a}
  db 66h;mov bx,ax           {mov ebx,eax}
  db 66h;mov ax,word ptr[b]  {mov eax,a}
  db 66h;mul ax              {mul eax}
  db 66h;mov word ptr [b2],ax{mov a2,eax}
  db 66h;mov si,ax           {mov esi,eax}
  db 66h;mov cx,di           {mov ecx,edi}
  db 66h;shr cx,3            {shr ecx,2}
  db 66h;mov ax,bx           {mov eax,ebx}
  db 66h;shr ax,1            {shr eax,1}
  db 66h;sub cx,ax           {add ecx,eax}
  db 66h;add cx,word ptr [b2]{sub ecx,a2}
  db 66h;mov dx,bx           {mov edx,ebx}
  db 66h;xor bx,bx           {xor ebx,ebx}
   {/\}
  mov al,col
  db 66h;mov word ptr [a22],di{mov b22,edi}          {pune la pastrare}
  {Urmeaza ciclul}
@loop2:
  db 66h;cmp dx,bx           {cmp edx,ebx}
  jng @exit2                 {while edx>ebx}
  {pune punctele si face inc(b) numai in puncte,nu incrementeaza bx\/}

  mov di,di2
  mov [es:di],al
  inc di
  mov di2,di

  mov di,di3
  mov [es:di],al
  dec di
  mov di3,di

  mov di,di6
  mov [es:di],al
  dec di
  mov di6,di

  mov di,di7
  mov [es:di],al
  inc di
  mov di7,di

  db 66h;mov di,word ptr [a22]{mov edi,b22}
  {/\}
  db 66h;add bx,si
  db 66h;add bx,si
  {conditia:}
  db 66h;or cx,cx         {or ecx,ecx}
  jns @else2
  db 66h;add cx,bx        {add ecx,ebx}
  db 66h;add cx,si        {add ecx,esi}
  jmp @loop2
@else2:
  db 66h;sub dx,di        {sub edx,edi}
  db 66h;add cx,bx        {add ecx,ebx}
  db 66h;add cx,si        {edd ecx,esi}
  db 66h;sub cx,dx        {sub ecx,edx}
  {Decrementeaza a doar pentru puncte:}
  mov di,di2
  add di,320
  mov di2,di

  mov di,di3
  add di,320
  mov di3,di

  mov di,di6
  sub di,320
  mov di6,di

  mov di,di7
  sub di,320
  mov di7,di
  jmp @loop2                  {./\.}
  {/\}
@exit2:
  mov di,di2
  mov [es:di],al

  mov di,di3
  mov [es:di],al

  mov di,di6
  mov [es:di],al

  mov di,di7
  mov [es:di],al
end;

Procedure FillEllipse(x,y:word;a,b:longint;col:byte);assembler;
var di3,di4,di5,di6,xxx,yyy,xx,yy:word;
    a2,b2,a22,b22,rbx,rcx:longint;
asm
  cld
  mov ax,where
  mov es,ax
  mov ax,y
  mov di,ax
  mov ah,al
  mov al,0
  shl di,6
  add di,ax
  add di,x
  mov al,col
  mov si,di
  sub si,word ptr[a]
  sub si,320
  mov di4,si
  add si,640
  mov di5,si
  sub si,320
  xchg si,di
  mov al,col
  mov cx,word ptr [a]
  add cx,cx
  inc cx
  cmp     cx,3
  ja      @1jmpq
  rep stosb
  jmp @1jmp01
@1jmpq:
  mov     ah,al
  push    ax
  push    ax

  db      66h
  pop     ax
  mov     bx,x
  and     bx,00000011b
  jz      @1jmp1
  shr     bx,1
  jnc     @1jmp2
  jz      @1jmp3
  stosb
  dec cx
  jmp      @1jmp1
@1jmp3:
  stosb
  dec cx

@1jmp2:
  stosw
  sub      cx,2
@1jmp1:

    mov      bx,cx
    shr      cx,2
    db       0f3h,066h;stosw

    and     bx,00000011b
    jz      @1jmp01
    shr     bx,1
    jnc     @1jmp02
    jnz      @1jmp03
    stosb
    jmp      @1jmp01
@1jmp03:
    stosb

@1jmp02:
    stosw
@1jmp01:

  xchg si,di

  mov cx,word ptr[b]
  mov dx,cx
  mov ch,cl
  mov cl,0
  shl dx,6
  add dx,cx
  mov si,di
  sub si,dx
  mov di3,si
  mov si,di
  add si,dx
  mov di6,si

  mov dx,word ptr [a]
  mov xxx,dx

  db 66h;mov ax,0;dw 0
  db 66h;mov bx,ax
  db 66h;mov cx,ax
  db 66h;mov dx,ax
  db 66h;mov si,ax
  db 66h;mov di,ax

  db 66h;mov ax,word ptr[b]
  db 66h;mul ax
  db 66h;mov word ptr [b2],ax
  db 66h;add ax,ax
  db 66h;mov di,ax
  db 66h;mul word ptr[a]
  db 66h;mov bx,ax
  db 66h;mov ax,word ptr[a]
  db 66h;mul ax
  db 66h;mov word ptr [a2],ax
  db 66h;mov si,ax
  db 66h;mov cx,di
  db 66h;shr cx,3
  db 66h;mov ax,bx
  db 66h;shr ax,1
  db 66h;sub cx,ax
  db 66h;add cx,word ptr [a2]
  db 66h;mov dx,bx
  db 66h;xor bx,bx

  mov al,col
  mov     ah,al
  push    ax
  push    ax
  db      66h;pop     ax
  mov yyy,0

  db 66h;mov word ptr [b22],di

  db 66h;add bx,si
  db 66h;add bx,si

  db 66h;or cx,cx
  jns @elsex
  db 66h;add cx,bx
  db 66h;add cx,si
  jmp @loop1
@elsex:
  db 66h;sub dx,di
  db 66h;add cx,bx
  db 66h;add cx,si
  db 66h;sub cx,dx
  dec xxx
  mov di,di4
  inc di
  mov di4,di
  mov di,di5
  inc di
  mov di5,di
@loop1:
  db 66h;cmp dx,bx
  jng @exit1

  db 66h;mov word ptr [rbx],bx
  db 66h;mov word ptr [rcx],cx
  inc yyy
  mov di,di4
  mov si,di
  sub di,320
  mov di4,di

  mov di,di5
  add di,320
  mov di5,di
  sub di,320

    mov cx,xxx
    add cx,cx
    inc cx
    mov bx,cx
    cmp     cx,3
    ja      @3jmpq
    rep stosb
    mov cx,bx
    mov di,si
    rep stosb
    jmp @3jmp01
@3jmpq:

    mov     bx,di
    and     bx,00000011b
    jz      @3jmp1
    shr     bx,1
    jnc     @3jmp2
    jz      @3jmp3
    stosb
    mov [es:si],al
    inc si
    dec cx
    jmp      @3jmp1
@3jmp3:
    stosb
    mov [es:si],al
    inc si
    dec cx

@3jmp2:
    stosw
    mov [es:si],ax
    add si,2
    sub      cx,2
@3jmp1:

    mov      bx,cx
    shr      cx,2
    db       0f3h,066h
    stosw
    mov cx,bx
    xchg di,si
    shr      cx,2
    db       0f3h,066h
    stosw
    and     bx,00000011b
    jz      @3jmp01
    shr     bx,1
    jnc     @3jmp02
    jnz     @3jmp03
    stosb
    mov [es:si],al
    jmp      @3jmp01
@3jmp03:
    stosb
    mov [es:si],al
    inc si

@3jmp02:
    stosw
    mov [es:si],ax
@3jmp01:

  db 66h;mov bx,word ptr [rbx]
  db 66h;mov si,word ptr [a2]
  db 66h;mov cx,word ptr [rcx]
  db 66h;mov di,word ptr [b22]

  db 66h;add bx,si
  db 66h;add bx,si

  db 66h;or cx,cx
  jns @else1
  db 66h;add cx,bx
  db 66h;add cx,si
  jmp @loop1
@else1:
  db 66h;sub dx,di
  db 66h;add cx,bx
  db 66h;add cx,si
  db 66h;sub cx,dx

  dec xxx

  mov di,di4
  inc di
  mov di4,di

  mov di,di5
  inc di
  mov di5,di

  jmp @loop1

@exit1:

  mov ax,word ptr [b]
  mov yy,ax

  db 66h;mov ax,0;dw 0
  db 66h;mov bx,ax
  db 66h;mov cx,ax
  db 66h;mov dx,ax
  db 66h;mov si,ax
  db 66h;mov di,ax

  db 66h;mov ax,word ptr[a]
  db 66h;mul ax
  db 66h;mov word ptr [a2],ax
  db 66h;add ax,ax
  db 66h;mov di,ax
  db 66h;mul word ptr[b]
  db 66h;mov bx,ax
  db 66h;mov ax,word ptr[b]
  db 66h;mul ax
  db 66h;mov word ptr [b2],ax
  db 66h;mov si,ax
  db 66h;mov cx,di
  db 66h;shr cx,3
  db 66h;mov ax,bx
  db 66h;shr ax,1
  db 66h;sub cx,ax
  db 66h;add cx,word ptr [b2]
  db 66h;mov dx,bx
  db 66h;xor bx,bx

  mov xx,0
  mov al,col
  mov     ah,al
  push    ax
  push    ax
  db      66h;pop     ax

  db 66h;mov word ptr [a22],di

@loop2:
  db 66h;cmp dx,bx
  jng @exit2

  mov di,di3
  dec di
  mov di3,di

  mov di,di6
  dec di
  mov di6,di

  inc [xx]
  db 66h;mov di,word ptr [a22]

  db 66h;add bx,si
  db 66h;add bx,si

  db 66h;or cx,cx
  jns @else2
  db 66h;add cx,bx
  db 66h;add cx,si
  jmp @loop2
@else2:
  db 66h;sub dx,di
  db 66h;add cx,bx
  db 66h;add cx,si
  db 66h;sub cx,dx

  db 66h;mov word ptr [rbx],bx
  db 66h;mov word ptr [rcx],cx

  mov di,di3
  mov si,di
  add di,320
  mov di3,di
  inc si

  mov di,di6
  sub di,320
  mov di6,di
  add di,321

  dec yy

    mov cx,xx
    add cx,cx
    dec cx
    mov bx,cx
    cmp     cx,3
    ja      @2jmpq
    rep stosb
    mov cx,bx
    mov di,si
    rep stosb
    jmp @2jmp01
@2jmpq:

    mov     bx,di
    and     bx,00000011b
    jz      @2jmp1
    shr     bx,1
    jnc     @2jmp2
    jz      @2jmp3
    stosb
    mov [es:si],al
    inc si
    dec cx
    jmp      @2jmp1
@2jmp3:
    stosb
    mov [es:si],al
    inc si
    dec cx

@2jmp2:
    stosw
    mov [es:si],ax
    add si,2
    sub      cx,2
@2jmp1:
    mov      bx,cx
    shr      cx,2
    db       0f3h,066h
    stosw
    mov cx,bx
    xchg di,si
    shr      cx,2

    db       0f3h,066h
    stosw
    and     bx,00000011b
    jz      @2jmp01
    shr     bx,1
    jnc     @2jmp02
    jnz     @2jmp03
    stosb
    mov [es:si],al
    jmp      @2jmp01
@2jmp03:
    stosb
    mov [es:si],al
    inc si

@2jmp02:
    stosw
    mov [es:si],ax
@2jmp01:


  db 66h;mov bx,word ptr [rbx]
  db 66h;mov si,word ptr [b2]
  db 66h;mov cx,word ptr [rcx]

  jmp @loop2

@exit2:
  mov dx,yy
  mov ax,yyy
  sub dx,ax
  jz @gata

  mov di,di3
  mov si,di6
  mov bx,xx
  add bx,bx
  inc bx
  mov al,col
@lp1:
  mov cx,bx
  rep stosb
  sub di,bx
  add di,320
  xchg di,si
  mov cx,bx
  rep stosb
  sub di,bx
  sub di,320
  xchg di,si
  dec dx
  jnz @lp1
@gata:
end;

procedure Circle(x,y,r:word);assembler;
var di1,di2,di3,di4,di5,di6,di7,di8:word;
  {Astea-s salvarile registrului DS}
asm
  {Calculeaza pozitia centrului\/}
  mov ax,where
  mov es,ax
  mov ax,y
  mov di,ax
  mov ah,al
  mov al,0
  shl di,6
  add di,ax
  add di,x
  {/\}
  {pune primele puncte\/}
  mov al,color
  mov si,di
  add si,r
  mov [es:si],al
  sub si,320
  mov di1,si
  add si,640
  mov di8,si
  mov si,di
  sub si,r
  mov [es:si],al
  sub si,320
  mov di4,si
  add si,640
  mov di5,si
  {calculeaza diferenta in bytes pe verticala}
  mov cx,r
  mov dx,cx
  mov ch,cl
  mov cl,0
  shl dx,6
  add dx,cx
  mov si,di
  sub si,dx
  mov [es:si],al
  inc si
  mov di2,si
  sub si,2
  mov di3,si
  mov si,di
  add si,dx
  mov [es:si],al
  dec si
  mov di6,si
  add si,2
  mov di7,si
  {/\}
  {Initzializarea variabilelor:\/}
  mov bx,1  {b}
  mov dx,r  {a}
  mov cx,dx {c}
  mov si,bx {d}
  {/\}
  {Urmeaza ciclul}
@loop:
  {pune punctele si face inc(b) numai in puncte,nu incrementeaza bx\/}
  mov di,di1
  mov [es:di],al
  sub di,320
  mov di1,di

  mov di,di2
  mov [es:di],al
  inc di
  mov di2,di

  mov di,di3
  mov [es:di],al
  dec di
  mov di3,di

  mov di,di4
  mov [es:di],al
  sub di,320
  mov di4,di

  mov di,di5
  mov [es:di],al
  add di,320
  mov di5,di

  mov di,di6
  mov [es:di],al
  dec di
  mov di6,di

  mov di,di7
  mov [es:di],al
  inc di
  mov di7,di

  mov di,di8
  mov [es:di],al
  add di,320
  mov di8,di
  {/\}
  add si,bx
  inc bx
  add si,bx
  {conditia:}
  cmp si,cx
  jna @exitc
  add cx,dx
  add cx,dx
  inc cx
  dec dx
  {Decrementeaza a doar pentru puncte:}
  mov di,di1
  dec di
  mov di1,di

  mov di,di2
  add di,320
  mov di2,di

  mov di,di3
  add di,320
  mov di3,di

  mov di,di4
  inc di
  mov di4,di

  mov di,di5
  inc di
  mov di5,di

  mov di,di6
  sub di,320
  mov di6,di

  mov di,di7
  sub di,320
  mov di7,di

  mov di,di8
  dec di
  mov di8,di
  {/\}
@exitc:
  {inchei ciclul:}
  cmp dx,bx
  jnb @loop
end;

Procedure GCircle(x,y,r:word;col:byte);assembler;
var di1,di2,di3,di4,di5,di6,di7,di8:word;
  {Astea-s salvarile registrului DS}
asm
  {Calculeaza pozitia centrului\/}
  mov ax,where
  mov es,ax
  mov ax,y
  mov di,ax
  mov ah,al
  mov al,0
  shl di,6
  add di,ax
  add di,x
  {/\}
  {pune primele puncte\/}
  mov al,col
  mov si,di
  add si,r
  mov [es:si],al
  sub si,320
  mov di1,si
  add si,640
  mov di8,si
  mov si,di
  sub si,r
  mov [es:si],al
  sub si,320
  mov di4,si
  add si,640
  mov di5,si
  {calculeaza diferenta in bytes pe verticala}
  mov cx,r
  mov dx,cx
  mov ch,cl
  mov cl,0
  shl dx,6
  add dx,cx
  mov si,di
  sub si,dx
  mov [es:si],al
  inc si
  mov di2,si
  sub si,2
  mov di3,si
  mov si,di
  add si,dx
  mov [es:si],al
  dec si
  mov di6,si
  add si,2
  mov di7,si
  {/\}
  {Initzializarea variabilelor:\/}
  mov bx,1  {b}
  mov dx,r  {a}
  mov cx,dx {c}
  mov si,bx {d}
  {/\}
  {Urmeaza ciclul}
@loop:
  {pune punctele si face inc(b) numai in puncte,nu incrementeaza bx\/}
  mov di,di1
  mov [es:di],al
  sub di,320
  mov di1,di

  mov di,di2
  mov [es:di],al
  inc di
  mov di2,di

  mov di,di3
  mov [es:di],al
  dec di
  mov di3,di

  mov di,di4
  mov [es:di],al
  sub di,320
  mov di4,di

  mov di,di5
  mov [es:di],al
  add di,320
  mov di5,di

  mov di,di6
  mov [es:di],al
  dec di
  mov di6,di

  mov di,di7
  mov [es:di],al
  inc di
  mov di7,di

  mov di,di8
  mov [es:di],al
  add di,320
  mov di8,di
  {/\}
  add si,bx
  inc bx
  add si,bx
  {conditia:}
  cmp si,cx
  jna @exitc
  add cx,dx
  add cx,dx
  inc cx
  dec dx
  {Decrementeaza a doar pentru puncte:}
  mov di,di1
  mov [es:di],al
  dec di
  mov di1,di

  mov di,di2
  mov [es:di],al
  add di,320
  mov di2,di

  mov di,di3
  mov [es:di],al
  add di,320
  mov di3,di

  mov di,di4
  mov [es:di],al
  inc di
  mov di4,di

  mov di,di5
  mov [es:di],al
  inc di
  mov di5,di

  mov di,di6
  mov [es:di],al
  sub di,320
  mov di6,di

  mov di,di7
  mov [es:di],al
  sub di,320
  mov di7,di

  mov di,di8
  mov [es:di],al
  dec di
  mov di8,di
  {/\}
@exitc:
  {inchei ciclul:}
  cmp dx,bx
  jnb @loop
end;


procedure FillCircle;assembler;
var di3,di4,di5,di6,rbx,rsi,rcx:word;
asm
  cld
  mov ax,where
  mov es,ax
  mov ax,y
  mov di,ax
  mov ah,al
  mov al,0
  shl di,6
  add di,ax
  add di,x
  mov si,di
  sub si,320
  sub si,r
  mov di4,si
  add si,640
  mov di5,si
  mov si,di

  mov al,col
  sub di,r

  mov cx,r
  add cx,cx
  inc cx
  cmp     cx,3
  ja      @1jmpq
  rep stosb
  jmp @1jmp01
@1jmpq:
  mov     ah,al
  push    ax
  push    ax

  db      66h
  pop     ax

  mov     bx,x
  and     bx,00000011b
  jz      @1jmp1
  shr     bx,1
  jnc     @1jmp2
  jz      @1jmp3
  stosb
  dec cx
  jmp      @1jmp1
@1jmp3:
  stosb
  dec cx

@1jmp2:
  stosw
  sub      cx,2
@1jmp1:

  mov      bx,cx
  shr      cx,2

  db       0f3h,066h
  stosw

  and     bx,00000011b
  jz      @1jmp01
  shr     bx,1
  jnc     @1jmp02
  jnz      @1jmp03
  stosb
  jmp      @1jmp01
@1jmp03:
   stosb

@1jmp02:
   stosw
@1jmp01:


  mov cx,r
  mov dx,cx
  mov ch,cl
  mov cl,0
  shl dx,6
  add dx,cx
  mov di,si
  sub di,dx

  dec di
  mov di3,di
  mov di,si
  add di,dx

  dec di
  mov di6,di


  mov bx,1
  mov dx,r
  mov cx,dx
  mov si,bx


@loop:


  mov rbx,bx
  mov rsi,si
  mov rcx,cx

  mov di,di4
  mov si,di
  sub di,320
  mov di4,di

  mov di,di5
  add di,320
  mov di5,di
  sub di,320

  mov cx,dx
  add cx,cx
  inc cx
  mov bx,cx
  cmp     cx,3
  ja      @2jmpq
  rep stosb
  mov cx,bx
  mov di,si
  rep stosb
  jmp @2jmp01
@2jmpq:

  mov     bx,di
  and     bx,00000011b
  jz      @2jmp1
  shr     bx,1
  jnc     @2jmp2
  jz      @2jmp3
  stosb
  mov [es:si],al
  inc si
  dec cx
  jmp      @2jmp1
@2jmp3:
  stosb
  mov [es:si],al
  inc si
  dec cx

@2jmp2:
  stosw
  mov [es:si],ax
  add si,2
  sub      cx,2
@2jmp1:

  mov      bx,cx
  shr      cx,2

  db       0f3h,066h
  stosw

  mov cx,bx
  xchg di,si
  shr      cx,2

  db       0f3h,066h
  stosw

  and     bx,00000011b
  jz      @2jmp01
  shr     bx,1
  jnc     @2jmp02
  jnz     @2jmp03
  stosb
  mov [es:si],al
  jmp      @2jmp01
@2jmp03:
  stosb
  mov [es:si],al
  inc si

@2jmp02:
  stosw
  mov [es:si],ax
@2jmp01:

  mov bx,rbx

  mov di,di3
  dec di
  mov di3,di


  mov di,di6
  dec di
  mov di6,di

  mov bx,rbx

  mov si,rsi
  mov cx,rcx

  add si,bx
  inc bx
  add si,bx

  cmp si,cx
  jna @exitc
  add cx,dx
  add cx,dx
  inc cx
  dec dx


  mov rbx,bx
  mov rsi,si
  mov rcx,cx

  mov di,di4
  inc di
  mov di4,di

  mov di,di5
  inc di
  mov di5,di

  mov di,di6
  sub di,320
  mov di6,di
  add di,321

  mov si,di3
  add si,320
  mov di3,si
  sub si,319

  mov cx,bx
  dec cx
  add cx,cx
  inc cx
  mov bx,cx
  cmp     cx,3
  ja      @3jmpq
  rep stosb
  mov cx,bx
  mov di,si
  rep stosb
  jmp @3jmp01
@3jmpq:

    mov     bx,di
    and     bx,00000011b
    jz      @3jmp1
    shr     bx,1
    jnc     @3jmp2
    jz      @3jmp3
    stosb
    mov [es:si],al
    inc si
    dec cx
    jmp      @3jmp1
@3jmp3:
    stosb
    mov [es:si],al
    inc si
    dec cx

@3jmp2:
    stosw
    mov [es:si],ax
    add si,2
    sub      cx,2
@3jmp1:

    mov      bx,cx
    shr      cx,2

    db       0f3h,066h
    stosw

    mov cx,bx
    xchg di,si
    shr      cx,2

    db       0f3h,066h
    stosw


    and     bx,00000011b
    jz      @3jmp01
    shr     bx,1
    jnc     @3jmp02
    jnz     @3jmp03
    stosb
    mov [es:si],al
    jmp      @3jmp01
@3jmp03:
    stosb
    mov [es:si],al
    inc si

@3jmp02:
    stosw
    mov [es:si],ax
@3jmp01:

  mov bx,rbx

  mov si,rsi
  mov cx,rcx

  @exitc:
  cmp dx,bx
  jnb @loop
end;



Procedure Rectangle;
begin
  HLine(x1,x2,y1,color);
  Hline(x1,x2,y2,color);
  Vline(y1,y2,x1,color);
  Vline(y1,y2+1,x2,color);
end;


procedure Bar;assembler;
var rbx,l2:word;
asm
  mov ax,x1
  mov bx,x2
  cmp ax,bx
  jb @j1
  mov x1,bx
  mov x2,ax
@j1:
  mov ax,y1
  mov bx,y2
  cmp ax,bx
  jb @j2
  mov y1,bx
  mov y2,ax
@j2:
  mov dx,y2
  sub dx,y1
  inc dx
  mov [l2],dx
  mov bx,x2
  sub bx,x1
  inc bx
  cld
  mov ax,where
  mov es,ax
  mov ax,y1
  mov si,ax
  mov ah,al
  mov al,0
  shl si,6
  add si,ax
  add si,x1
  mov al,col
  mov ah,al
  push ax
  push ax
  db 66h;pop ax
  mov [rbx],bx
@loapa:
  mov di,si
  mov     cx,rbx
  cmp     cx,3
  ja      @jmpq
  rep stosb
  jmp @jmp01
@jmpq:
  mov     bx,x1
  and     bx,00000011b
  jz      @jmp1
  shr     bx,1
  jnc     @jmp2
  jz      @jmp3
  stosb
  dec cx
  jmp      @jmp1
@jmp3:
  stosb
  dec cx
@jmp2:
  stosw
  sub      cx,2
@jmp1:
  mov      bx,cx
  shr      cx,2
  db       0f3h,066h
  stosw
  and     bx,00000011b
  jz      @jmp01
  shr     bx,1
  jnc     @jmp02
  jnz     @jmp03
  stosb
  jmp     @jmp01
@jmp03:
   stosb
@jmp02:
   stosw
@jmp01:
   add si,320
   dec dx
   jnz @loapa
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
  if maxavail<64000 then begin
                          settext;
                          writeln(' Eroare de executie !');
                          writeln(' Insuficienta memorie pentru a rula acest program !');
                          halt(2);
                         end
                    else GetMem (VirScr,64000);
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
    {$I-}reset(f,1){$I+};
    if ioresult<>0 then begin
                          settext;
                          writeln(' Eroare de executie !');
                          writeln(' Fisierul '+filename+' este inexistent');
                          halt(1);
                        end;
    l:=filesize(f);close(f);
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
    {$I-}reset(f,64000){$I+};
    if ioresult<>0 then begin
                          settext;
                          writeln(' Eroare de executie !');
                          writeln(' Fisierul '+filename+' este inexistent');
                          halt(1);
                        end;
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

Procedure ScreenScrollUp(where1,where2,lin1,lin2:word);assembler;
asm
 push ds
 mov ax,where1
 mov es,ax
 mov ds,ax

 mov ax,lin2
 mov bx,ax
 shl ax,8
 shl bx,6
 add bx,ax    { bx=320*lin2 }

 mov ax,lin1
 mov dx,ax
 shl ax,8
 shl dx,6
 add dx,ax    { dx=320*lin1 }

 mov di,dx
 mov si,di
 add si,320
 mov cx,bx
 sub cx,dx
 shr cx,2
 db $f3,$66,$a5  { rep movsd }

 mov ax,seg @Data
 mov ds,ax
 mov ax,ds:[ssu]

 mov cx,where2
 mov ds,cx

 mov si,ax
 mov di,bx
 mov cx,80
 db $f3,$66,$a5 { rep movsd }

 add ax,320
 cmp ax,64000
 jnz @l1
 xor ax,ax
 @l1: mov bx,seg @Data
 mov ds,bx
 mov ds:[ssu],ax
 pop ds
end;



Procedure ResetScrScrollUp;assembler;
asm
  push ds
  mov ax,Seg @Data
  mov ds,ax
  mov ax,sst
  mov ds:ssu,ax
  pop ds
end;

Procedure ROLBox;
var f:word;
    p:byte;
begin
  For f := y1 to y2 do
              begin
                p:=getpixel(x1,f);
                move (mem[SegA000:x1+(f*320)+1],mem[SegA000:x1+(f*320)],x2-x1-1);
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
                move (mem[SegA000:x1+(f*320)],mem[SegA000:x1+(f*320)+1],x2-x1-1);
                putpixel(x1,f,p);
              end;
end;

Procedure LoadFont;
var f:file;
begin
  if font<>nil then freemem(font,15872);
  getmem(font,15872);
  assign(f,filename);
  {$I-}reset(f,15872);{$I+}
  if ioresult<>0 then begin
                        settext;
                        writeln(' Eroare de executie !');
                        writeln(' Fisierul '+filename+' este inexistent');
                        halt(1);
                      end;
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

Procedure MediaScreen(scr1,scr2,scr:virtualscreen;nrp,i1,i2:byte);assembler;
asm
 push ds
 les di,scr
 lds si,scr1
 db $0f,$b4,$5e,$10            { lfs bx,[bp+16] <=> lfs bx,scr2 }
 mov cx,64000
 @l1: xor ah,ah
 mov al,ds:[si]
 mul i1
 mov dx,ax
 xor ah,ah
 db $64,$8a,$07                { mov al,fs:[bx] }
 mul i2
 add ax,dx
 div nrp
 stosb
 inc si
 inc bx
 loop @l1
 pop ds
end;

Procedure MediaPal(var pal1,pal2,pal:palettetype;nrp,i1,i2:byte);assembler;
asm
 push ds
 les di,pal
 lds si,pal1
 db $0f,$b4,$5e,$10            { lfs bx,[bp+16] <=> lfs bx,pal2}
 mov cx,768
 @l1: xor ah,ah
 mov al,ds:[si]
 mul i1
 mov dx,ax
 xor ah,ah
 db $64,$8a,$07                { mov al,fs:[bx] }
 mul i2
 add ax,dx
 div nrp
 stosb
 inc si
 inc bx
 loop @l1
 pop ds
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


Procedure Rescale(scr1:virtualscreen;xx1,yy1,xx2,yy2:word;scr2:virtualscreen;x1,y1,x2,y2:word);
const MaxScreenLineLength=1600;
type TLA=array[1..MaxScreenLineLength+8] of word;
var LA:^TLA;LAR:word;
var poss,posd:word;
    line,realline,preline,postline,line4:word;
var c1,c2,count,t,linesourc:word;
var source,destination:word;
label _exit,exit1,jmp1,exit2,jmp2;
begin
  source:=seg(scr1^);
  destination:=seg(scr2^);
  linesourc:=xx2-xx1+1;
  new(LA);
  if ofs(LA^)>0 then LAR:=seg(LA^)+1
               else LAR:=seg(LA^);
  asm
  {calcularea pozitiei primului punct scris pe ecran}
    mov ax,y1
    mov di,ax
    mov ah,al
    mov al,0
    shl di,6
    add di,ax
    add di,x1
    mov [posd],di
  {calcularea pozitiei primului punct citit din ecran}
    mov ax,yy1
    mov di,ax
    mov ah,al
    mov al,0
    shl di,6
    add di,ax
    add di,xx1
    mov [poss],di
  end;
  {Zooming se realizeaza pe baza algoritmului liniei}
  line:=x2-x1+1;
  if (x2-x1)<=(xx2-xx1) then {micsorare pe x}
    asm
    {Creare vectorului LA}
      xor di,di
      mov ax,LAR
      mov es,ax
        {es:di poiteaza la inceputul vectorului LA}
      mov cx,xx2
      sub cx,xx1
        {cx=dx si registru loop}
      mov bx,x2
      sub bx,x1
      add bx,bx
        {bx=c1}
      mov dx,bx
      sub dx,cx
        {dx=t}
      mov si,bx
      sub si,cx
      sub si,cx
        {si=c2}
      mov ax,0
      stosw
      inc ax
        {a pus primul element}
      {urmeaza ciclul}
@loop:or dx,dx
        {if t<0}
      js @then
        {then}
      add dx,si
      stosw
      jmp @ifend
@then:add dx,bx
@ifend:inc ax
      dec cx
      jnz @loop
    end
       else {marire pe x}
    asm
    {Creare vectorului LA}
      xor di,di
      mov ax,LAR
      mov es,ax
        {es:di poiteaza la inceputul vectorului LA}
      mov cx,x2
      sub cx,x1
        {cx=dx si registru loop}
      mov bx,xx2
      sub bx,xx1
      add bx,bx
        {bx=c1}
      mov dx,bx
      sub dx,cx
        {dx=t}
      mov si,bx
      sub si,cx
      sub si,cx
        {si=c2}
      mov ax,0
      stosw
        {a pus primul element}
      {urmeaza ciclul}
@loop:or dx,dx
        {if t<0}
      js @then
        {then}
      add dx,si
      inc ax
      jmp @ifend
@then:add dx,bx
@ifend:stosw
      dec cx
      jnz @loop
    end;

  asm
    {potriveste realline,preline,postline si line4}
    mov bx,line
    mov realline,bx
    xor ax,ax
    mov preline,ax
    mov postline,ax
    mov cx,x1
    and cx,00000011b
    jz @jmp
    sub cx,4
    neg cx
    mov preline,cx
    sub bx,cx
    mov realline,bx
@jmp:
    shr bx,2
    mov line4,bx
    mov cx,realline
    and cx,0000000000000011b
    mov postline,cx
  end;

  if (y2-y1)<=(yy2-yy1) then {micsorare pe y}
      asm
        {ciclul 2}
        mov cx,postline
        db 66h;shl cx,16
        mov cx,preline {pune in ecx postline:preline}
        mov di,posd
        mov dx,line4
        db 66h;shl dx,16
        mov dx,poss    {pune in edx line4:poss}
        mov ax,destination
        mov es,ax
        mov ax,source
        db 08eh,0e0h     {mov fs,ax}
        mov ax,LAR
        db 08eh,0e8h     {mov gs,ax}
        mov bx,0
        push bp
        mov bp,dx {in acest moment eu nu mai am acces la variabile}
        db 66h;shr dx,16  {dx=line4}
        or cx,cx
        jz @asalt1
@aloop1:db 65h;mov si,[bx]  {mov si,gs:[bx]}
        add bx,2
        db 64h;mov al,[bp+si]  {mov al,fs:[bp+si]}
        mov [es:di],al
        inc di
        dec cx
        jnz @aloop1
@asalt1:
        {ciclu cu dx=line4}
        or dx,dx
        jz @asalt2
@aloop2:db 66h,65h;mov si,[bx]  {mov esi,gs:[bx]}
        add bx,4
        db 64h;mov al,[bp+si]
        db 66h;shr si,16
        db 64h;mov ah,[bp+si]
        db 66h;rol ax,16
        db 66h,65h;mov si,[bx]  {mov esi,gs:[bx]}
        add bx,4
        db 64h;mov al,[bp+si]
        db 66h;shr si,16
        db 64h;mov ah,[bp+si]
        db 66h;ror ax,16
        db 66h;mov [es:di],ax            {stosd}
        add di,4
        dec dx
        jnz @aloop2
@asalt2:
        db 66h;shr cx,16 {cx=postline}
        or cx,cx
        jz @asalt3
@aloop3:db 65h;mov si,[bx]  {mov si,gs:[bx]}
        add bx,2
        db 64h;mov al,[bp+si]
        mov [es:di],al
        inc di
        dec cx
        jnz @aloop3
 @asalt3:
        pop bp
          {trece pe linia urmatoare}
        mov di,poss
        add di,320
        mov poss,di

        mov di,posd
        add di,320
        mov posd,di

        mov cx,yy2
        sub cx,yy1
          {cx=dx si registru loop}
        mov bx,y2
        sub bx,y1
        add bx,bx
        mov c1,bx
          {bx=c1}
        mov dx,bx
        sub dx,cx
          {dx=t}
        mov si,bx
        sub si,cx
        sub si,cx
        mov c2,si
          {si=c2}
@loopq:   {if}
        or dx,dx
        jns @else
          {then}
        add dx,c1
  @jmp1:{iesirea din if-then-else}
        {trece pe linia urmatoare}
        mov di,poss
        add di,320
        mov poss,di
        dec cx
        jnz @loopq
        jmp @exit1
          {else}
  @else:add dx,c2
        mov t,dx
        mov count,cx
        {ciclul 2}
        mov cx,postline
        db 66h;shl cx,16
        mov cx,preline {pune in ecx postline:preline}
        mov di,posd
        mov dx,line4
        db 66h;shl dx,16
        mov dx,poss    {pune in edx line4:poss}
        mov ax,destination
        mov es,ax
        mov ax,source
        db 08eh,0e0h     {mov fs,ax}
        mov ax,LAR
        db 08eh,0e8h     {mov gs,ax}
        mov bx,0
        push bp
        mov bp,dx {in acest moment eu nu mai am acces la variabile}
        db 66h;shr dx,16  {dx=line4}
        or cx,cx
        jz @salt1
@loop1:db 65h;mov si,[bx]  {mov si,gs:[bx]}
        add bx,2
        db 64h;mov al,[bp+si]  {mov al,fs:[bp+si]}
        mov [es:di],al
        inc di
        dec cx
        jnz @loop1
@salt1:
        {ciclu cu dx=line4}
        or dx,dx
        jz @salt2
@loop2:db 66h,65h;mov si,[bx]  {mov esi,gs:[bx]}
        add bx,4
        db 64h;mov al,[bp+si]
        db 66h;shr si,16
        db 64h;mov ah,[bp+si]
        db 66h;rol ax,16
        db 66h,65h;mov si,[bx]  {mov esi,gs:[bx]}
        add bx,4
        db 64h;mov al,[bp+si]
        db 66h;shr si,16
        db 64h;mov ah,[bp+si]
        db 66h;ror ax,16
        db 66h;mov [es:di],ax            {stosd}
        add di,4
        dec dx
        jnz @loop2
@salt2:
        db 66h;shr cx,16 {cx=postline}
        or cx,cx
        jz @salt3
@loop3:db 65h;mov si,[bx]  {mov si,gs:[bx]}
        add bx,2
        db 64h;mov al,[bp+si]
        mov [es:di],al
        inc di
        dec cx
        jnz @loop3
 @salt3:
        pop bp

          {trece pe linia urmatoare}
        mov di,posd
        add di,320
        mov posd,di
          {restaureaza cx si dx}
        mov dx,t
        mov cx,count
        jmp @jmp1
  @exit1:
      end
        else
      asm
        {ciclul 2}
        mov cx,postline
        db 66h;shl cx,16
        mov cx,preline {pune in ecx postline:preline}
        mov di,posd
        mov dx,line4
        db 66h;shl dx,16
        mov dx,poss    {pune in edx line4:poss}
        mov ax,destination
        mov es,ax
        mov ax,source
        db 08eh,0e0h     {mov fs,ax}
        mov ax,LAR
        db 08eh,0e8h     {mov gs,ax}
        mov bx,0
        push bp
        mov bp,dx {in acest moment eu nu mai am acces la variabile}
        db 66h;shr dx,16  {dx=line4}
        or cx,cx
        jz @qsalt1
@qloop1:db 65h;mov si,[bx]  {mov si,gs:[bx]}
        add bx,2
        db 64h;mov al,[bp+si]  {mov al,fs:[bp+si]}
        mov [es:di],al
        inc di
        dec cx
        jnz @qloop1
@qsalt1:
        {ciclu cu dx=line4}
        or dx,dx
        jz @qsalt2
@qloop2:db 66h,65h;mov si,[bx]  {mov esi,gs:[bx]}
        add bx,4
        db 64h;mov al,[bp+si]
        db 66h;shr si,16
        db 64h;mov ah,[bp+si]
        db 66h;rol ax,16
        db 66h,65h;mov si,[bx]  {mov esi,gs:[bx]}
        add bx,4
        db 64h;mov al,[bp+si]
        db 66h;shr si,16
        db 64h;mov ah,[bp+si]
        db 66h;ror ax,16
        db 66h;mov [es:di],ax            {stosd}
        add di,4
        dec dx
        jnz @qloop2
@qsalt2:
        db 66h;shr cx,16 {cx=postline}
        or cx,cx
        jz @qsalt3
@qloop3:db 65h;mov si,[bx]  {mov si,gs:[bx]}
        add bx,2
        db 64h;mov al,[bp+si]
        mov [es:di],al
        inc di
        dec cx
        jnz @qloop3
 @qsalt3:
        pop bp

          {trece pe linia urmatoare}
        mov di,poss
        add di,320
        mov poss,di

        mov di,posd
        add di,320
        mov posd,di

        mov cx,y2
        sub cx,y1
          {cx=dx si registru loop}
        mov bx,yy2
        sub bx,yy1
        add bx,bx
        mov c1,bx
          {bx=c1}
        mov dx,bx
        sub dx,cx
          {dx=t}
        mov si,bx
        sub si,cx
        sub si,cx
        mov c2,si
          {si=c2}
  @loop:  {if}
        or dx,dx
        jns @else
          {then}
        add dx,c1
        {copiaza ultima linie in linie noua}
        mov count,cx
        push ds
        mov ax,destination
        mov es,ax
        mov ds,ax
        mov si,posd
        mov di,si
        sub si,320

        mov cx,preline
        rep movsb

        mov cx,line4
        rep
        db 66h;movsw

        mov cx,postline
        rep movsb

        pop ds
        mov cx,count
   jmp2:{iesirea din if-then-else}
        {trece pe linia urmatoare }
        mov di,posd
        add di,320
        mov posd,di

        dec cx
        jnz @loop
        jmp exit2
          {else}
  @else:add dx,c2
        mov t,dx
        mov count,cx
        {ciclul 2}
        mov cx,postline
        db 66h;shl cx,16
        mov cx,preline {pune in ecx postline:preline}
        mov di,posd
        mov dx,line4
        db 66h;shl dx,16
        mov dx,poss    {pune in edx line4:poss}
        mov ax,destination
        mov es,ax
        mov ax,source
        db 08eh,0e0h     {mov fs,ax}
        mov ax,LAR
        db 08eh,0e8h     {mov gs,ax}
        mov bx,0
        push bp
        mov bp,dx {in acest moment eu nu mai am acces la variabile}
        db 66h;shr dx,16  {dx=line4}
        or cx,cx
        jz @asalt1
@aloop1:db 65h;mov si,[bx]  {mov si,gs:[bx]}
        add bx,2
        db 64h;mov al,[bp+si]  {mov al,fs:[bp+si]}
        mov [es:di],al
        inc di
        dec cx
        jnz @aloop1
@asalt1:
        {ciclu cu dx=line4}
        or dx,dx
        jz @asalt2
@aloop2:db 66h,65h;mov si,[bx]  {mov esi,gs:[bx]}
        add bx,4
        db 64h;mov al,[bp+si]
        db 66h;shr si,16
        db 64h;mov ah,[bp+si]
        db 66h;rol ax,16
        db 66h,65h;mov si,[bx]  {mov esi,gs:[bx]}
        add bx,4
        db 64h;mov al,[bp+si]
        db 66h;shr si,16
        db 64h;mov ah,[bp+si]
        db 66h;ror ax,16
        db 66h;mov [es:di],ax            {stosd}
        add di,4
        dec dx
        jnz @aloop2
@asalt2:
        db 66h;shr cx,16 {cx=postline}
        or cx,cx
        jz @asalt3
@aloop3:db 65h;mov si,[bx]  {mov si,gs:[bx]}
        add bx,2
        db 64h;mov al,[bp+si]
        mov [es:di],al
        inc di
        dec cx
        jnz @aloop3
 @asalt3:
        pop bp

          {trece pe linia urmatoare pe disc}
       mov di,poss
       add di,320
       mov poss,di

          {restaureaza cx si dx}
        mov dx,t
        mov cx,count
        jmp jmp2
  exit2:
      end;

_exit:
  dispose(LA)
end;


Procedure ZoomIn;
var i,j,temp2:word;
begin
  for i:=0 to 199 do for j:=0 to 319 do
    scr2^[i,j]:=scr1^[y1+(i div scaray),x1+(j div scarax)];
end;


Procedure GEllipse(x,y:word;a,b:longint;col:byte);assembler;
var di1,di2,di3,di4,di5,di6,di7,di8:word;
    a2,b2,a22,b22:longint;
  {Astea-s salvarile registrului DS}
asm
  {Calculeaza pozitia centrului\/}
  mov ax,where
  mov es,ax
  mov ax,y
  mov di,ax
  mov ah,al
  mov al,0
  shl di,6
  add di,ax
  add di,x
  {/\}
  {pune primele puncte\/}
  mov al,col    {de ce cred eu ca primele puncte se pun tot in ciclu?}
  mov si,di
  add si,word ptr[a]
  mov di1,si
  mov di8,si
  mov si,di
  sub si,word ptr[a]
  mov di4,si
  mov di5,si
  {calculeaza diferenta in bytes pe verticala}
  mov cx,word ptr[b]
  mov dx,cx
  mov ch,cl
  mov cl,0
  shl dx,6
  add dx,cx
  mov si,di
  sub si,dx
  mov di2,si
  mov di3,si
  mov si,di
  add si,dx
  mov di6,si
  mov di7,si
  {/\}
  {Initzializarea variabilelor pe 32 biti:\/}
  db 66h;mov ax,0;dw 0       {mov eax,0}
  db 66h;mov bx,ax           {mov ebx,eax}
  db 66h;mov cx,ax           {mov ecx,eax}
  db 66h;mov dx,ax           {mov edx,eax}
  db 66h;mov si,ax           {mov esi,eax}
  db 66h;mov di,ax           {mov edi,eax}

  db 66h;mov ax,word ptr[b]  {mov ax,b}
  db 66h;mul ax              {mul eax}
  db 66h;mov word ptr [b2],ax{mov b2,eax}
  db 66h;add ax,ax           {add eax,eax}
  db 66h;mov di,ax           {mov edi,eax}
  db 66h;mul word ptr[a]     {mul a}
  db 66h;mov bx,ax           {mov ebx,eax}
  db 66h;mov ax,word ptr[a]  {mov eax,a}
  db 66h;mul ax              {mul eax}
  db 66h;mov word ptr [a2],ax{mov a2,eax}
  db 66h;mov si,ax           {mov esi,eax}
  db 66h;mov cx,di           {mov ecx,edi}
  db 66h;shr cx,3            {shr ecx,2}
  db 66h;mov ax,bx           {mov eax,ebx}
  db 66h;shr ax,1            {shr eax,1}
  db 66h;sub cx,ax           {add ecx,eax}
  db 66h;add cx,word ptr [a2]{sub ecx,a2}
  db 66h;mov dx,bx           {mov edx,ebx}
  db 66h;xor bx,bx           {xor ebx,ebx}
  {/\}
  mov al,col
  db 66h;mov word ptr [b22],di{mov b22,edi}          {pune la pastrare}
  {Urmeaza ciclul}
@loop1:
  db 66h;cmp dx,bx           {cmp edx,ebx}
  jng @exit1                 {while edx>ebx}
  {pune punctele si face inc(b) numai in puncte,nu incrementeaza bx\/}

  mov di,di1
  mov [es:di],al
  sub di,320
  mov di1,di

  mov di,di4
  mov [es:di],al
  sub di,320
  mov di4,di

  mov di,di5
  mov [es:di],al
  add di,320
  mov di5,di

  mov di,di8
  mov [es:di],al
  add di,320
  mov di8,di

  db 66h;mov di,word ptr [b22]{mov edi,b22}
  {/\}
  db 66h;add bx,si        {dy+=2*b^2}
  db 66h;add bx,si
  {conditia:}
  db 66h;or cx,cx         {or ecx,ecx}
  jns @else1
  db 66h;add cx,bx        {add ecx,ebx}
  db 66h;add cx,si        {add ecx,esi}
  jmp @loop1
@else1:
  db 66h;sub dx,di        {sub edx,edi}
  db 66h;add cx,bx        {add ecx,ebx}
  db 66h;add cx,si        {edd ecx,esi}
  db 66h;sub cx,dx        {sub ecx,edx}
  {Decrementeaza a doar pentru puncte:}
  mov di,di1
  mov [es:di],al
  dec di
  mov di1,di

  mov di,di4
  mov [es:di],al
  inc di
  mov di4,di

  mov di,di5
  mov [es:di],al
  inc di
  mov di5,di

  mov di,di8
  mov [es:di],al
  dec di
  mov di8,di
  jmp @loop1                  {./\.}
  {/\}
@exit1:
  mov di,di1
  mov [es:di],al

  mov di,di4
  mov [es:di],al

  mov di,di5
  mov [es:di],al

  mov di,di8
  mov [es:di],al

  {partea ][:}
  {Initzializarea variabilelor pe 32 biti:\/}
  db 66h;mov ax,0;dw 0       {mov eax,0}
  db 66h;mov bx,ax           {mov ebx,eax}
  db 66h;mov cx,ax           {mov ecx,eax}
  db 66h;mov dx,ax           {mov edx,eax}
  db 66h;mov si,ax           {mov esi,eax}
  db 66h;mov di,ax           {mov edi,eax}

  db 66h;mov ax,word ptr[a]  {mov ax,b}
  db 66h;mul ax              {mul eax}
  db 66h;mov word ptr [a2],ax{mov b2,eax}
  db 66h;add ax,ax           {add eax,eax}
  db 66h;mov di,ax           {mov edi,eax}
  db 66h;mul word ptr[b]     {mul a}
  db 66h;mov bx,ax           {mov ebx,eax}
  db 66h;mov ax,word ptr[b]  {mov eax,a}
  db 66h;mul ax              {mul eax}
  db 66h;mov word ptr [b2],ax{mov a2,eax}
  db 66h;mov si,ax           {mov esi,eax}
  db 66h;mov cx,di           {mov ecx,edi}
  db 66h;shr cx,3            {shr ecx,2}
  db 66h;mov ax,bx           {mov eax,ebx}
  db 66h;shr ax,1            {shr eax,1}
  db 66h;sub cx,ax           {add ecx,eax}
  db 66h;add cx,word ptr [b2]{sub ecx,a2}
  db 66h;mov dx,bx           {mov edx,ebx}
  db 66h;xor bx,bx           {xor ebx,ebx}
  {/\}
  mov al,col
  db 66h;mov word ptr [a22],di{mov b22,edi}          {pune la pastrare}
  {Urmeaza ciclul}
@loop2:
  db 66h;cmp dx,bx           {cmp edx,ebx}
  jng @exit2                 {while edx>ebx}
  {pune punctele si face inc(b) numai in puncte,nu incrementeaza bx\/}

  mov di,di2
  mov [es:di],al
  inc di
  mov di2,di

  mov di,di3
  mov [es:di],al
  dec di
  mov di3,di

  mov di,di6
  mov [es:di],al
  dec di
  mov di6,di

  mov di,di7
  mov [es:di],al
  inc di
  mov di7,di

  db 66h;mov di,word ptr [a22]{mov edi,b22}
  {/\}
  db 66h;add bx,si
  db 66h;add bx,si
  {conditia:}
  db 66h;or cx,cx         {or ecx,ecx}
  jns @else2
  db 66h;add cx,bx        {add ecx,ebx}
  db 66h;add cx,si        {add ecx,esi}
  jmp @loop2
@else2:
  db 66h;sub dx,di        {sub edx,edi}
  db 66h;add cx,bx        {add ecx,ebx}
  db 66h;add cx,si        {edd ecx,esi}
  db 66h;sub cx,dx        {sub ecx,edx}
  {Decrementeaza a doar pentru puncte:}
  mov di,di2
  mov [es:di],al
  add di,320
  mov di2,di

  mov di,di3
  mov [es:di],al
  add di,320
  mov di3,di

  mov di,di6
  mov [es:di],al
  sub di,320
  mov di6,di

  mov di,di7
  mov [es:di],al
  sub di,320
  mov di7,di

  jmp @loop2                  {./\.}
  {/\}
@exit2:
  mov di,di2
  mov [es:di],al

  mov di,di3
  mov [es:di],al

  mov di,di6
  mov [es:di],al

  mov di,di7
  mov [es:di],al
end;

Procedure SetBWZone(zona:byte);
begin
  BWZone:=zona;
end;

Procedure CreateUniformPal(var pal:palettetype);
var i,r,g,b:byte;
begin
for i:=0 to 251 do begin
  r:=i div 42;
  g:=(i-r*42) div 6;
  b:=i-r*42-g*6;
  pal[i,1]:=round(12.6*r);
  pal[i,2]:=round(10.5*g);
  pal[i,3]:=round(12.6*b);
 end;
end;


Procedure CreateBWPal(var pal:palettetype);
var f:word;
    a:byte;
begin
for f:=0 to 63 do begin
    a:=f+bwzone;
    pal[a,1]:=f;
    pal[a,2]:=f;
    pal[a,3]:=f;
                  end;
end;


Procedure CreateBWScreen(scrsursa:virtualscreen;palsursa:palettetype;
                         var scrdest:virtualscreen);
var f:word;
    t:byte;
    ltpal:array[0..255] of byte;
begin
 for f:=0 to 255 do ltpal[f]:=round(0.3*palsursa[f,1]+0.59*palsursa[f,2]+0.11*palsursa[f,3]);
 for f:=0 to 63999 do
   begin
     t:=linear(scrsursa^)[f];
     linear(scrdest^)[f]:=bwzone+ltpal[t];
   end;
end;


Procedure ChangeScreenPal(scr1:virtualscreen;pal1:palettetype;scr2:virtualscreen;pal2:palettetype);
var dist,savedist,dx,dy,dz:longint;
    f:integer;a,b:byte;
function findclosest(pa1,pa2:palettetype;chkcol:byte):byte;
var i:byte;
    savecol:byte;
begin
  savedist:=200000;
  for i:=0 to 255 do begin
   		dx:=pa2[i,1]-pa1[chkcol,1];
                dy:=pa2[i,2]-pa1[chkcol,2];
                dz:=pa2[i,3]-pa1[chkcol,3];
		dist:=dx*dx+dy*dy+dz*dz;
		if dist < savedist then
			begin
			  savedist:=dist;
			  savecol:=i;
			end;
                    end;
  findclosest:=savecol;
end;
procedure replacebyte(sc1,sc2:virtualscreen;by1,by2:byte);assembler;
asm
 push ds
 lds si,sc1
 les di,sc2
 mov bl,by1
 mov bh,by2
 mov cx,64000
 cld
 @l1:
 mov al,ds:[si]
 cmp al,bl
 jne @l2
 mov es:[di],bh
 @l2:
 inc si
 inc di
 loop @l1
 pop ds
end;
begin
 for f:=0 to 255 do replacebyte(scr1,scr2,f,findclosest(pal1,pal2,f));
end;

end.
