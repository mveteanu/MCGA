uses    crt,mcga;

const   width = 320;
        stars = 1400;

type    coord = record x,y,z : integer;end;

var	taller				: integer;
	ytabel				: array [0..255] of integer;
	sinustabel			: array [0..639] of integer;

	StarXY,ClearTabel       	: array [1..stars] of coord;

	starpos,starcount		: integer;
	vinkelx, vinkely, vinkelz 	: integer;
	vxadd, vyadd, vzadd		: integer;





procedure SetupDemo;
var i:integer;

procedure setupsinus;
var
	i : integer;
	v, vadd : real;
begin
	v:=0.0;
	vadd:=(2.0*pi/512.0);
	for i:=0 to 639 do
	begin
		sinustabel[i]:=round(sin(v)*32767);
		v:=v+vadd;
	end;
end;
procedure SetupCoords;
var
	i : integer;
begin
 for i:=1 to stars do
  begin
    ClearTabel[i].x:=0;ClearTabel[i].y:=0;ClearTabel[i].z:=0;
  end;
 randomize;
 for i:=1 to stars do
  begin
    starXY[i].x := random(65535)-$8000;
    starXY[i].y := random(65535)-$8000;
    starXY[i].z := random(512);
  end;
end;
begin
 vinkelx:=0; vinkely:=0; vinkelz:=0;
 SetupSinus;
 SetupCoords;
 for i:=0 to 255 do ytabel[i]:=i*width;
end;


procedure OpenScreen;
var
   i, color : integer;
begin
   SetMcga;
   color := 64;
   for i:=0 to 63 do
   begin
    SetPal(i, color,color,color);
    dec(color);
   end;
end;


procedure SetVinkel;
begin
	vinkelx:=(vinkelx+1) mod 512;
	vinkely:=(vinkely+1) mod 512;
	vinkelz:=(vinkelz+2) mod 512;

	vxadd:=sinustabel[vinkelx]*3;
	vyadd:=sinustabel[vinkely]*3;
	vzadd:=sinustabel[vinkelz] DIV 180;
end;


procedure ClearStars;assembler;
asm
 mov     ax,SEGA000
 mov     es,ax
 lea     si,ClearTabel    {point at record array}
 mov     ax,6             {record size}
 xor     dl,dl
 mov     cx,stars
 @ClearLoop:
 mov     bx,[si]
 mov     es:[bx],dl
 add     si,ax
 loop    @ClearLoop
end;


procedure PlotStars;
begin
	starcount := stars;
	starpos := 0;
     asm
	mov     ax,SEGA000
	mov     es,ax
	@starloop:
	lea     si,starXY
	add     si,starpos
	mov     bx,[si]
	mov     ax,[si+2]
	mov     cx,[si+4]
	add     bx,vxadd
	add     ax,vyadd
	add     cx,vzadd
	and     cx,511
	inc     cx

	cwd
	idiv    cx
	xchg    bx,ax
	cwd
	idiv    cx
	add     ax,160
	cmp     ax,319
	ja      @StarLoopAgain
	add     bx,100
	cmp     bx,199
	ja      @StarLoopAgain

	shl	  bx,1
	add	  bx,OFFSET ytabel
	mov     bx,[bx]
	add     bx,ax
	lea     si,ClearTabel
	add     si,starpos
	mov     [si],bx

	shr     cx,3
	and     cl,63
	mov     es:[bx],cl
	@StarLoopAgain:
	add     starpos,6
	dec     StarCount
	jnz     @StarLoop
	end;
end;


begin
SetupDemo;
OpenScreen;
repeat
  WaitRetrace;
  ClearStars;
  PlotStars;
  SetVinkel;
until keypressed;
SetText;
end.
