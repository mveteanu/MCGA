Program pentru_o_mini_demonstratie;
uses mcga;
var scr:virtualscreen;

Procedure DisplayScreen(adr:virtualscreen);assembler;
label data_361,data_374;
asm
  push    ds
  mov     ax,cs
  mov     ds,ax
  mov     es,ax
  mov     si,offset data_374
  call    @sub_22
  jmp     @iesire
@sub_22:
  mov     byte ptr data_361,0
@loc_48:
  mov     bx,word ptr data_361
  xor     ax,ax
  mov     al,[bx+si]
  push    si
  call    @sub_23
  pop     si
  call    waitretrace
  inc     byte ptr data_361
  cmp     byte ptr data_361,0A0h
  jne     @loc_48
  retn
@sub_23:
  push    ax
  mov     ax,0A000h
  mov     es,ax
  pop     ax
  lds     si,adr
  xor     di,di
  mov     cl,4
  ror     ax,cl
  mov     bl,ah
  mov     cl,4
  shr     bx,cl
  mov     cx,140h
  mul     cx
  mov     cx,14h
  mul     cx
  add     si,ax
  add     di,ax
  mov     ax,bx
  mov     cx,14h
  mul     cx
  add     si,ax
  add     di,ax
  xor     bx,bx
@loc_51:
  mov     cx,14h
  rep     movsb
  add     si,12Ch
  add     di,12Ch
  inc     bx
  cmp     bx,14h
  jne     @loc_51
  mov     ax,cs
  mov     ds,ax
  retn
data_361:
  dw      0
data_374:
  db       90h
  db       80h, 91h, 70h, 81h, 92h, 60h, 71h, 82h, 93h, 50h, 61h, 72h
  db       83h, 94h, 40h, 51h, 62h, 73h, 84h, 95h, 30h, 41h, 52h, 63h
  db       74h, 85h, 96h, 20h, 31h, 42h, 53h, 64h, 75h, 86h, 97h, 10h
  db       21h, 32h, 43h, 54h, 65h, 76h, 87h, 98h, 00h, 11h, 22h, 33h
  db       44h, 55h, 66h, 77h, 88h, 99h, 01h, 12h, 23h, 34h, 45h, 56h
  db       67h, 78h, 89h, 9Ah, 02h, 13h, 24h, 35h, 46h, 57h, 68h, 79h
  db       8Ah, 9Bh, 03h, 14h, 25h, 36h, 47h, 58h, 69h, 7Ah, 8Bh, 9Ch
  db       04h, 15h, 26h, 37h, 48h, 59h, 6Ah, 7Bh, 8Ch, 9Dh, 05h, 16h
  db       27h, 38h, 49h, 5Ah, 6Bh, 7Ch, 8Dh, 9Eh, 06h, 17h, 28h, 39h
  db       4Ah, 5Bh, 6Ch, 7Dh, 8Eh, 9Fh, 07h, 18h, 29h, 3Ah, 4Bh, 5Ch
  db       6Dh, 7Eh, 8Fh, 08h, 19h, 2Ah, 3Bh, 4Ch, 5Dh, 6Eh, 7Fh, 09h
  db       1Ah, 2Bh, 3Ch, 4Dh, 5Eh, 6Fh, 0Ah, 1Bh, 2Ch, 3Dh, 4Eh, 5Fh
  db       0Bh, 1Ch, 2Dh, 3Eh, 4Fh, 0Ch, 1Dh, 2Eh, 3Fh, 0Dh, 1Eh, 2Fh
  db       0Eh, 1Fh, 0Fh
@iesire:
  pop      ds
end;

begin
setmcga;
setupvirtual(scr);
loadvisualpal('..\mcga-img\paleta1.pal');
loadscreen('..\mcga-img\screen1.scr',scr);
displayscreen(scr);
readln;
shutdownvirtual(scr);
settext;
end.