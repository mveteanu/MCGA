{
          ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          ³   Acesta este un unit care vine in ajutorul celor    ³
          ³    care au monitoare SVGA cu placi grafice MXIC      ³
          ³             Autor : Marian Veteanu                   ³
          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
}
unit MXIC;
interface
var WriteMode:byte;

procedure SetVideoMode(VideoCode:byte);
procedure SetColorRegister(RegColor:word;RedValue,GreenValue,BlueValue:byte);
procedure ReadColorRegister(RegColor:word;var RedValue,GreenValue,BlueValue:byte);
procedure OpenGraph320x200x256;       { pentru orice monitor cu modul MCGA }
procedure OpenGraph800x600x16;        { doar pe placi grafice MXIC }
procedure OpenGraph1024x768x16;       { doar pe placi grafice MXIC }
procedure OpenGraph640x350x256;       { doar pe placi grafice MXIC }
procedure OpenGraph640x400x256;       { doar pe placi grafice MXIC }
procedure OpenGraph640x480x256;       { doar pe placi grafice MXIC }
procedure OpenGraph800x600x256;       { doar pe placi grafice MXIC }
procedure CloseGraph;
function  GetVideoMode:byte;
procedure SetBkColor(c:byte);
function  GetBkColor:byte;
function  GetMaxX:integer;
function  GetMaxY:integer;
function  GetMaxColor:byte;
function  GetX:integer;
function  GetY:integer;
procedure SetColor(c:byte);
function  GetColor:byte;
procedure SetWriteMode(modul:byte);
procedure PutPixel(x,y:integer;pixel:byte);
procedure MoveTo(x,y:integer);
procedure MoveRel(dx,dy:integer);
function  GetPixel(x,y:integer):byte;
procedure Line0(a,b:integer);
procedure Line(x0,y0,x1,y1:integer);
procedure LineTo(x,y:integer);
procedure LineRel(dx,dy:integer);
procedure CLine(x0,y0,x1,y1:integer;c:byte);
procedure Rectangle(x11,y11,x22,y22:integer);
procedure Circle(x,y,r:integer);
procedure Box(x1,y1,x2,y2:integer;c:byte);
procedure Bar(x1,y1,x2,y2:integer;c,m:byte);
procedure Bar3D(x1,y1,x2,y2,adinc:integer;c,m:byte;capac:boolean);
procedure ClearView(x1,y1,x2,y2:integer);
procedure ClearDevice;
procedure ReverseY(x1,y1,x2,y2:integer); {face flip vertical  la o fereastra}
procedure ReverseX(x1,y1,x2,y2:integer); {face flip orizontal la o fereastra}
procedure PrintAt(x,y:byte);
procedure Advance;                    { pentru scrierea de texte }
procedure PrintC(a:char);             { pentru scrierea de texte }
procedure PrintS(s:string);           { pentru scrierea de texte }
procedure Print(n:integer);           { pentru scrierea de texte }

implementation
const maxareaforfill=400;
var   color       : byte;
      bkcolor     : byte;
      xpoz,ypoz,
      cmax,lbmp   : integer;
      filled      : longint;

function Min(x,y:integer):integer;
begin
  if x<y then min:=x else min:=y;
end;

function Max(x,y:integer):integer;
begin
  if x>y then max:=x else max:=y;
end;

procedure SetVideoMode ; assembler ;
asm
  mov al,VideoCode
  xor ah,ah
  int 10h
end;

function GetVideoMode:byte;
begin
  GetVideoMode:=mem[0:$449];
end;

procedure SetColorRegister;assembler;
asm
  mov ax , 1010h
  mov bx , RegColor
  mov ch , GreenValue
  mov cl , BlueValue
  mov dh , RedValue
  int 10h
end;

procedure ReadColorRegister;assembler;
asm
  mov ax , 1015h
  mov bx , RegColor
  int 10h
  les bx , RedValue
  mov byte ptr es:[bx] , dh
  les bx , GreenValue
  mov byte ptr es:[bx] , ch
  les bx , BlueValue
  mov byte ptr es:[bx] , cl
end;

procedure MoveTo;
begin
  xpoz:=x;
  ypoz:=y;
end;

procedure MoveRel;
begin
  MoveTo(getx+dx,gety+dy);
end;

procedure PutPixel(x,y:integer;pixel:byte);
begin
  if WriteMode=1 then pixel:=pixel XOR GetPixel(x,y);
  asm
    mov al,pixel
    mov ah,0ch
    mov cx,x
    mov dx,y
    int 10h
  end
end;

function GetPixel(x,y:integer):byte;assembler;
asm
  mov ah,0dh
  mov cx,x
  mov dx,y
  int 10h
end;

procedure OpenGraph320x200x256;
begin
  SetVideoMode(19);
  cmax:=256;
  WriteMode:=0;
end;

procedure OpenGraph800x600x16;
begin
  SetVideoMode(85);
  cmax:=16;
  WriteMode:=0;
end;

procedure OpenGraph1024x768x16;
begin
  SetVideoMode(86);
  cmax:=16;
  WriteMode:=0;
end;

procedure OpenGraph640x350x256;
begin
  SetVideoMode(87);
  cmax:=256;
  WriteMode:=0;
end;

procedure OpenGraph640x400x256;
begin
  SetVideoMode(88);
  cmax:=256;
  WriteMode:=0;
end;

procedure OpenGraph640x480x256;
begin
  SetVideoMode(89);
  cmax:=256;
  WriteMode:=0;
end;

procedure OpenGraph800x600x256;
begin
  SetVideoMode(90);
  cmax:=256;
  WriteMode:=0;
end;

function GetMaxX:Integer;
begin
  GetMaxX:=memw[0:$44a]*8;
end;

function GetMaxY:Integer;
begin
  GetMaxY:=(mem[0:$484]+1)*memw[0:$485];
end;

function GetMaxColor;
begin
  GetMaxColor:=cmax;
end;

procedure SetColor;
begin
  Color:=c;
end;

function GetColor:byte;
begin
  GetColor:=color;
end;

procedure SetBkColor;
begin
  BkColor:=c;
end;

function GetX;
begin
  GetX:=xpoz;
end;

function GetY;
begin
  GetY:=ypoz;
end;

function GetBkColor:byte;
begin
  GetBkColor:=bkcolor;
end;

procedure SetWriteMode(modul:byte);
begin
  WriteMode:=modul;
end;

procedure Box;
var i,j:integer;
begin
for i:=x1 to x2 do
 for j:=y1 to y2 do
  putpixel(i,j,c);
end;

procedure Line0(a,b:integer);
var x,y,r:integer;
begin
  x:=0;y:=0;r:=0;
  while (x<=b) do
                 begin
                   PutPixel(x,y,GetColor);
                   inc(r,a);
                   while (r>=b) do
                                   begin
                                     Dec(r,b);
                                     Inc(y);
                                   end;
                  inc(x);
                  end;
end;

procedure Line(x0,y0,x1,y1:integer);
var a,b,c,a2,b2,ab2,ds,xinc,yinc,u,v,i:integer;
begin
  c:=GetColor;
  u:=x0;v:=y0;
  a:=abs(y1-y0);b:=abs(x1-x0);
  a2:=a*2;b2:=b*2;
  if x0<x1 then xinc:=1 else xinc:=-1;
  if y0<y1 then yinc:=1 else yinc:=-1;
  PutPixel(u,v,c);
  if (b>a) then begin
                  ds:=a2-b;ab2:=a2-b2;
                  for i:=1 to b do begin
                  if (ds>=0) then
                                begin
                                  inc(v,yinc);
                                  inc(ds,ab2);
                                end
                             else inc(ds,a2);
                             inc(u,xinc);
                             PutPixel(u,v,c);
                  end;end
           else begin
                  ds:=b2-a;ab2:=b2-a2;
                  for i:=1 to a do begin
                  if (ds>=0) then
                                begin
                                  inc(u,xinc);
                                  inc(ds,ab2)
                                end
                             else inc(ds,b2);
                             inc(v,yinc);
                             putpixel(u,v,c);
                end;
     end;
end;

procedure LineTo;
begin
  Line(getx,gety,x,y);
  MoveTo(x,y);
end;

procedure LineRel;
begin
  Line(getx,gety,getx+dx,gety+dy);
  MoveTo(getx+dx,gety+dy);
end;

procedure Cline;
var cc:byte;
begin
  cc:=GetColor;
  SetColor(c);
  Line(x0,y0,x1,y1);
  SetColor(cc);
end;

procedure Rectangle(x11,y11,x22,y22:integer);
var x1,y1,x2,y2:integer;
begin
  x1:=min(x11,x22);y1:=min(y11,y22);
  x2:=max(x11,x22);y2:=max(y11,y22);
  cline(x1,y1,x2,y1,color);
  cline(x2,y1,x2,y2,color);
  cline(x1,y1,x1,y2,color);
  cline(x1,y2,x2,y2,color);
end;

procedure Bar(x1,y1,x2,y2:integer;c,m:byte);
var cc:byte;
begin
  cc:=GetColor;
  box(x1,y1,x2,y2,c);
  SetColor(m);
  Rectangle(x1,y1,x2,y2);
  SetColor(cc);
end;

procedure Bar3D(x1,y1,x2,y2,adinc:integer;c,m:byte;capac:boolean);
begin
  bar(x1,y1,x2,y2,c,m);
  if (capac) then
                begin
                  cline(x1,y1,x1+adinc,y1-adinc,c);
                  cline(x2,y1,x2+adinc,y1-adinc,c);
                  cline(x1+adinc,y1-adinc,x2+adinc,y1-adinc,c);
                end;
   cline(x2,y2,x2+adinc,y2-adinc,c);
   cline(x2+adinc,y2-adinc,x2+adinc,y1-adinc,c);
end;

procedure ClearView(x1,y1,x2,y2:integer);
begin
  box(x1,y1,x2,y2,getbkcolor);
end;

procedure ClearDevice;
begin
  setvideomode(getvideomode);
end;

procedure CloseGraph;
begin
  setvideomode(3);
end;

procedure Circle(x,y,r:integer);
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

procedure ReverseX(x1,y1,x2,y2:integer);
var i,j,aux:integer;
begin
    for j:=y1 to y2 do
     for i:=x1 to (x1+x2) div 2 do
     begin
       aux:=getpixel(i,j);
       putpixel(i,j,getpixel(x1+x2-i,j));
       putpixel(x1+x2-i,j,aux);
     end;
end;


procedure ReverseY(x1,y1,x2,y2:integer);
var i,j,aux:integer;
begin
    for i:=x1 to x2 do
     for j:=y1 to (y1+y2) div 2 do
     begin
       aux:=getpixel(i,j);
       putpixel(i,j,getpixel(i,y1+y2-j));
       putpixel(i,y1+y2-j,aux);
     end;
end;

procedure PrintAt;
begin
  asm
    push     bp
    mov ah , $02
    mov dh , y
    mov dl , x
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

procedure Print;
var s:string[10];
begin
  str(n,s);
  prints(s);
end;

end.




