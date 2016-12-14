USES
	crt,mcga;

CONST
	NUMBER_FACES = 6;
	NUMBER_COORDS = 8;
	box = 100; {size of boxes}

TYPE
	SlopeType = array[0..200*2] of integer;
	FaceType = RECORD
		l1,l2,l3,l4 : byte;
	end;

VAR
	slope,zslope : SlopeType;
	face : array[1..NUMBER_FACES] of FaceType;
	cbuffer : array[0..NUMBER_COORDS*4-1] of integer;
        ytabel : array[0..240] of word; {ytabel with mul #80}
	miny,maxy,i : integer;
	sinustabel : array[0..639] of integer;
	v1,v2,v3:word;
	xadd : word;
	cos1,sin1,cos2,sin2,cos3,sin3 : integer;

	scr : virtualscreen;


const
	coords : array[0..NUMBER_COORDS*3-1] of integer =
		(box,box,-box, -box,box,-box, -box,-box,-box, box,-box,-box,
		box,box,box, -box,box,box, -box,-box,box, box,-box,box);

function LongMul(x, y : integer) : longint;inline($5A/$58/$F7/$EA);
function LongDiv(x : longint; y : integer) : integer;inline($59/$58/$5A/$F7/$F9);

procedure SetupSinus;
var
	i : integer;
	v, vadd : real;
begin
	v:=0.0;
	vadd:=(2.0*pi/512.0);
	for i:=0 to 639 do begin
		sinustabel[i]:=round(sin(v)*32767);
		v:=v+vadd;
	end;
end;

procedure SetupCoords;
begin
	with face[1] do begin l1:=3; l2:=2; l3:=1; l4:=0; end;
	with face[2] do begin l1:=4; l2:=5; l3:=6; l4:=7; end;
	with face[3] do begin l1:=0; l2:=1; l3:=5; l4:=4; end;
	with face[4] do begin l1:=1; l2:=2; l3:=6; l4:=5; end;
	with face[5] do begin l1:=2; l2:=3; l3:=7; l4:=6; end;
	with face[6] do begin l1:=3; l2:=0; l3:=4; l4:=7; end;
end;

procedure InitDemo;
var
	i : integer;
	r,g,b : byte;
begin
	SetupSinus;
	SetupCoords;

	SetUpVirtual(scr);
	setactivescreen(scr);cls(255);

	v1:=0; v2:=0; v3:=0;
	xadd:=40;
        for i:=0 to 200 do ytabel[i]:=i*320;

        SetPal(0,0,0,0);
        SetPal(255,0,0,0);

	r:=63; g:=0; b:=0;
	for i:=1 to 127 do
	      begin
		SetPal(i,r,g,b);
		if (i AND 1) = 0 then dec(r);
	      end;
end;


procedure UninitDemo;
begin
	ShutDownVirtual(scr);
end;


procedure CopyScreen; assembler;
const
	COPYWIDTH = 320; {width of window}
	COPYHEIGHT = 112; {height of window}
asm
	push	ds

	mov	es,SEGA000
	mov	di,((100-(COPYHEIGHT/2))*320)+(160-(COPYWIDTH/2))
	lds	si,scr
	add	si,((100-(COPYHEIGHT/2))*320)+(160-(COPYWIDTH/2))
	db $66; mov ax,$FFFF; DW $FFFF
	mov	bx,-4
	mov	dx,COPYHEIGHT
	cld
	@yloop:
	mov	cx,COPYWIDTH/16
	@xloop:
        db $66,$a5; {movsd}
	db $66; mov [si+bx],ax
	db $66,$a5; {movsd}
	db $66; mov [si+bx],ax
	db $66,$a5; {movsd}
	db $66; mov [si+bx],ax
	db $66,$a5; {movsd}
	db $66; mov [si+bx],ax
	dec	cx
	jnz	@xloop
	add	si,320-COPYWIDTH
	add	di,320-COPYWIDTH
	dec	dx
	jnz	@yloop
	pop	ds
end;



procedure ClearSlope; assembler;
asm
	mov	ax,ds
	mov	es,ax
	lea	di,slope
	db $66; mov ax,$8000; DW $8000;
	cld
	mov	cx,TYPE(SlopeType)/4
	rep; db $66; stosw
end;

procedure CalcSlope(l1,l2 : integer); assembler;
var
	z1,z2,zadd : word;
	xlowadd : word;
	ysize : integer;
asm
	lea	si,cbuffer
	db $66; xor cx,cx
	mov	bx,l1		   {get first coords}
	shl	bx,3
	mov	ax,[si+bx+4]	   {get z value}
	mov	z2,ax
	mov	dx,[si+bx]         {get x/y coords}
	mov	cx,[si+bx+2]

	mov	ax,l2		   {get second coords}
	shl	ax,3
	add	si,ax
	mov	ax,[si+4]	   {get z value}
	mov	z1,ax
	mov	ax,[si]		   {get x/y coords}
	mov	bx,[si+2]

	cmp	bx,cx		   {make sure we go downwards...}
	jle	@noswap
	mov	si,z1		   {swap z}
	xchg	z2,si
	mov	z1,si
	xchg	ax,dx		   {swap x}
	xchg	bx,cx		   {sway y}
@noswap:

	cmp	bx,miny		   {record miny and maxy}
	jae	@miny
	mov	miny,bx
@miny:
	cmp	cx,maxy
	jbe	@maxy
	mov	maxy,cx
@maxy:

	sub	cx,bx
	jcxz	@zero
	mov	ysize,cx
	add	bx,bx
	add	bx,bx
	lea	si,slope
	add	si,bx

	push	ax
	sub	dx,ax

	mov	ax,dx
	db $66; shl ax,16
	DB $66,$99 {cdq}
	db $66; idiv	cx
	db $66; mov	dx,ax
	db $66; shr	dx,16
	mov	xlowadd,ax

	push	dx		   {also calc z-slope run}
	mov	dh,BYTE PTR z1
	mov	ah,BYTE PTR z2
	sub	ah,dh
	xor	al,al
	cwd
	idiv	cx
	mov	zadd,ax
	pop	dx
@one:
	pop	cx

	xor	bx,bx
	mov	ah,BYTE PTR z1	   {prepare also z-slope run. z1:=z1*256}
	xor	al,al
	mov	di,$8000
@loop:
	cmp	[si],di		   {is 1st slot filled?}
	jne	@other		 {yes, put it in next one}
	mov	[si+TYPE(SlopeType)],ah {insert z-coord}
	mov	[si],cx		 {insert x-coord}
	add	bx,xlowadd	 {add to x-run}
	adc	cx,dx
	add	ax,zadd		 {add to z-run}
	add	si,4		 {next slot...}
	dec	ysize
	jnz	@loop
	jmp	NEAR PTR @zero
@other:
	mov	[si+TYPE(SlopeType)+2],ah
	mov	[si+2],cx
	add	bx,xlowadd
	adc	cx,dx
	add	ax,zadd
	add	si,4
	dec	ysize
	jnz	@loop
@zero:
end;


procedure CalcAngle(v1,v2,v3 : word);
begin
	sin1:=sinustabel[v1]; cos1:=sinustabel[v1+128];
	sin2:=sinustabel[v2]; cos2:=sinustabel[v2+128];
	sin3:=sinustabel[v3]; cos3:=sinustabel[v3+128];
end;

procedure RotateAllCoords; assembler;
var
	xkoord,ykoord,zkoord,
	n : integer;
asm
	mov	ax,ds
	mov	es,ax
	lea	si,coords
	lea	di,cbuffer
	mov	n,NUMBER_COORDS
	cld
@loop:
	lodsw
	mov	xkoord,ax
	lodsw
	mov	ykoord,ax
	lodsw
	mov	zkoord,ax

	mov	ax,xkoord          {rotate around Z-axis}
	push	ax
	imul	Cos1
	add	ax,ax
	adc	dx,dx
	mov	bx,dx
	mov	ax,ykoord
	imul	Sin1
	add	ax,ax
	adc	dx,dx
	sub	bx,dx
	mov	xkoord,bx
	pop	ax
	imul	Sin1
	add	ax,ax
	adc	dx,dx
	mov	bx,dx
	mov	ax,ykoord
	imul	Cos1
	add	ax,ax
	adc	dx,dx
	add	bx,dx
	mov	ykoord,bx

	mov	ax,ykoord          {rotate around Y-axis}
	push	ax
	imul	Cos2
	add	ax,ax
	adc	dx,dx
	mov	bx,dx
	mov	ax,zkoord
	imul	Sin2
	add	ax,ax
	adc	dx,dx
	sub	bx,dx
	mov	ykoord,bx
	pop	ax
	imul	Sin2
	add	ax,ax
	adc	dx,dx
	mov	bx,dx
	mov	ax,zkoord
	imul	Cos2
	add	ax,ax
	adc	dx,dx
	add	bx,dx
	mov	zkoord,bx

	mov	ax,xkoord          {rotate around X-axis}
	push	ax
	imul	Cos3
	add	ax,ax
	adc	dx,dx
	mov	bx,dx
	mov	ax,zkoord
	imul	Sin3
	add	ax,ax
	adc	dx,dx
	sub     bx,dx
	mov	xkoord,bx
	pop	ax
	imul	Sin3
	add	ax,ax
	adc	dx,dx
	mov	bx,dx
	mov	ax,zkoord
	imul	Cos3
	add	ax,ax
	adc	dx,dx
	add	bx,dx
	mov	zkoord,bx

	add	bx,800
	and	bx,bx
	jnz	@zero
	mov	bl,1
@zero:

	mov	ax,xkoord
	cwd
	mov	dl,ah
	mov	ah,al
	xor	al,al
	idiv	bx
	add	ax,160
	stosw

	mov	ax,ykoord
	cwd
	mov	dl,ah
	mov	ah,al
	xor	al,al
	idiv	bx
	add	ax,100
	stosw

	mov	ax,bx		   {ajust z coord so it's ranging [1..127]}
	sub	ax,390
	shr	ax,2
	cmp	ax,0
	jg	@zgreat
	mov	ax,1
@zgreat:
	cmp	ax,128
	jl	@zless
	mov	ax,127
@zless:
	stosw
	add	di,2

	dec	n
	jnz	@loop
end;

function FaceShown(i : integer; l1,l2,l3 : byte) : boolean;
var
	a,b : longint;
begin
	a := LongMul(cbuffer[l1]-cbuffer[l2],cbuffer[l3+1]-cbuffer[l2+1]);
	b := LongMul(cbuffer[l1+1]-cbuffer[l2+1],cbuffer[l3]-cbuffer[l2]);
	FaceShown := (a-b) > 0;
end;


procedure FillShape(y,ysize : integer; colour : byte); assembler;
asm
	cmp	ysize,200
	jae	@done
	mov	ax,y
	add	ax,ax
	mov	bx,ax
	mov	di,[bx+OFFSET ytabel]
	lea	si,slope
	add	ax,ax
	add	si,ax

	mov	es,WORD PTR scr+2
	cld
@yloop:
	mov	bh,[si+TYPE(slopetype)] {fetch z value}
	lodsw									{fetch first xpos}
	mov	dx,ax
	mov	bl,[si+TYPE(slopetype)] {fetch second z value}
	lodsw									{fetch second xpos}
	cmp	ax,dx	  {make sure we go from left to right...}
	jle	@exchange
	xchg	ax,dx
	xchg	bl,bh
@exchange:

	cmp	dx,0
	jl	@filledout_fast
	cmp	ax,320
	jge	@filledout_fast
	cmp	ax,0
	jge	@cut1
	xor	ax,ax
@cut1:
	cmp	dx,319
	jle	@cut2
	mov	dx,319
@cut2:
	push	ds
	push	si
	push	di

	add	di,ax

	mov	cx,dx			{calc size of line}
	sub	cx,ax
	jcxz	@filledout

	xor	al,al			{prepare z-run}
	mov	ah,bh
	sub	ah,bl
	cwd
	idiv	cx
	mov	si,ax

	mov	dh,bl
	xor	dl,dl

	mov	ax,es			{copy ES to DS}
	mov	ds,ax

	mov	bl,colour

	shr	cx,1				{if linewidth is odd, we draw the first pixel}
	jnc	@notOdd
	add	dx,si				{add to z-slope run}
	cmp	dh,[es:di]		{is this z-coord lower than the one in buffer?}
	ja	@nodraw			{no, don't exchange}
	mov	al,dh				{yes}
	add	al,bl				{add colour to z-coord}
	mov	[es:di],al		{store it in buffer instead of old one}
@nodraw:
	inc	di
@notOdd:

	jcxz	@FilledOut		{now do the rest of the line...}
@loop:						{does two bytes instead of one!}
	mov	ax,[es:di]
	add	dx,si
	cmp	al,dh
	jbe	@nodraw1
	mov	al,dh
	add	al,bl
@nodraw1:
	add	dx,si
	cmp	ah,dh
	jbe	@nodraw2
	mov	ah,dh
	add	ah,bl
@nodraw2:
	stosw
	dec	cx
	jnz	@loop

@filledout:
	pop	di
	pop	si
	pop	ds
@filledout_fast:
	add	di,320
	dec	ysize
	jnz	@yloop
@done:
end;


begin
	SetMcga;
	InitDemo;
	repeat

	WaitRetrace;
	CopyScreen;
	CalcAngle(v1,v2,v3);RotateAllCoords;
        for i:=0 to NUMBER_COORDS do inc(cbuffer[(i shl 2)],LongDiv(sinustabel[xadd],300));
	for i:=1 to NUMBER_FACES do begin
		with face[i] do if FaceShown(i, l1 SHL 2,l2 SHL 2,l3 SHL 2) then begin
			ClearSlope;
			miny := 200; maxy := 0;
			CalcSlope(l1,l2);CalcSlope(l2,l3);
			CalcSlope(l3,l4);CalcSlope(l4,l1);
			FillShape(miny, maxy-miny, 0);
		end;
	end;
	v1:=(v1+3) AND 511;v2:=(v2-3) AND 511;v3:=(v3+3) AND 511;
        xadd:=(xadd+2) AND 511;
	until Keypressed;
	SetText;
end.
