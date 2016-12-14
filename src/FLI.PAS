(*
    ÚÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍ»
    ³                                                               ºMCGAº
    ³                       ===<<<    FLI   >>>===                  ÈÍÍÍÍ¹
    ³                                                                    º
    ³                       Autor : Marian Veteanu                       º
    ³                       Email : vma@electra.upit.ro                  º
    ³                                                                    º
    ³   Acesta este un unit PASCAL 7.0 care vine in ajutorul celor care  º
    ³   au placi grafice VGA si doresc sa foloseasca modul 320x200x256   º
    ³   pentru dezvoltarea de programe de animatie in special jocuri si  º
    ³   demonstratii.                                                    º
    ³   Unitul face parte din biblioteca MCGA si nu trebuie distribuit   º
    ³   in afara acestei biblioteci. Alaturi de grafica 320x200x256      º
    ³   biblioteca are suport si pentru grafica SVGA cat si pentru       º
    ³   utilizarea placii de sunet, a EMS, a XMS, etc.                   º
    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*)


{$G+,X+,R-,F-,S-,D-,L-}
unit fli;

interface
 uses crt;
 procedure PlayFli    (name:string);
 procedure PlayFliOnce(name:string);

implementation
const gg:longint=256*256*256;
                        g:longint=256*256;
type
        bff=array[1..64000]of byte;
var f:file;
                buff:^bff;
                l:longint;
                idx,w:word;
var size_ch:longint;
                tip_ch:word;

procedure initmode(m:boolean);
begin
if m=true then
             asm
               mov        ax,0013h
               int        10h
             end
          else
             asm
               mov        ax,0003h
               int        10h
             end;
end;

function getlong:longint;
var a,b,c,d:byte;
begin
                 blockread(f,l,4);
                 getlong:=l;
end;

function getword:word;
var a,b:byte;
begin
                 blockread(f,w,2);
                 getword:=w;
end;
var
                length:longint;
                nr_frame,width,height:word;
                depth,flags,speed:word;
                next,frit:longint;

procedure getFLIantet;
begin
                 length:=getlong;
                 getword;
{                if (getword<>$af11)or(getword<>$af10) then begin
                                        writeln('Wrong antet !');
                                        halt;
                                        end
                                         else writeln('Antet OK!');}
     nr_frame:=getword;{writeln('Nr frames :',nr_frame);}
                 width:=getword;height:=getword;
{                writeln('Scr. width :',width:4,' height :',height:4);}
                 depth:=getword;{writeln('Nr. max color :',1 shl depth);}
                 flags:=getword;{writeln('Flags :',flags);}
                 speed:=getword;{writeln('Speed :',speed);}
                 next:=getlong;{writeln('Next :',next);}
                 frit:=getlong;{writeln('Frit :',frit);}
                 seek(f,128);
end;
var framesize:longint;
                chunks:word;

procedure getFRAMEantet;
var gwsh,zz:word;
begin
                 framesize:=getlong;
                 gwsh:=getword;
                 if (gwsh<>$f1fa) then
                                        begin
                                        textmode($80);
          writeln('Error: animation file is damaged !');
          writeln('could not play animation !');
          writeln('press <return> to continue');
          repeat until readkey=#13;
          initmode(true);
          halt;
                                        end;
                 chunks:=getword;
                 seek(f,filepos(f)+8);
end;
procedure getchunksheader;
begin
                 size_ch:=getlong-6;
                 tip_ch:=getword;
                 blockread(f,buff^[30],size_ch);
end;

procedure setcolor(c,r,g,b:byte);assembler;
   asm
      mov    dx,3c8h
      mov    al,[c]
      out    dx,al
      inc    dx
      mov    al,[r]
      out    dx,al
      mov    al,[g]
      out    dx,al
      mov    al,[b]
      out    dx,al
   end;


procedure fli_color;
var i,c,cmax,col,nr_p:word;
                sgg,off,nr_c:word;
begin
                 nr_p:=buff^[30]+256*buff^[31];
                 idx:=32;col:=0;
                 for i:=1 to nr_p do begin
                         col:=col+buff^[idx];inc(idx);
                         cmax:=buff^[idx];inc(idx);
                         if cmax=0 then cmax:=256;

                         sgg:=seg(buff^);
                         off:=ofs(buff^)+idx-1;
                         nr_c:=cmax-col;
                         asm
                                        push    ds
                                        push    bp
                                        mov     ax,sgg
                                        mov     es,ax
                                        mov     dx,off
                                        mov     bx,col
                                        mov     cx,nr_c
                                        mov     ax,$1012
                                        int     $10
                                        pop     bp
                                        pop     ds
                         end;
                         end;
end;
procedure fli_lc;
var cx,l,p,fl,ll,sgg,off:word;
                nr_p,i,f,x,k,skip_count,size_count:byte;
label for1,for2,negativ,pozitiv,end_for1,end_for2;
begin
{
ds:si = buff
ds:00 dw fl
         02    nrl
         04    l
         06    cx
         08    nr_p
         10    p
         12    skip_count
         14    size_count
         16    f
         18    x

es:di = mem video
}
        sgg:=seg(buff^);off:=ofs(buff^);

asm
         push    ds
         push    bp
         mov     ax,off
         push    ax
         mov     ax,sgg
         push    ax
         pop     ds
         pop     si
         add     si,29

         mov     ax,$a000
         mov     es,ax
         xor     di,di

         lodsw
         mov     word ptr ds:[0],ax
         lodsw
         mov     word ptr ds:[2],ax
         xor     cx,cx

for1:
         push    cx
         add     cx,word ptr ds:[00]
         mov     word ptr ds:[04],cx
         mov     word ptr ds:[06],0
         lodsb
         mov     byte ptr ds:[08],al
         or      al,al
         jz      end_for1
         mov     cl,al
         xor     ch,ch

for2:
         push    cx
         lodsb
         mov     byte ptr ds:[12],al
         xor     ah,ah
         add     word ptr ds:[06],ax
         lodsb
         mov     byte ptr ds:[14],al
         or      al,al
         jz      end_for2
         cmp     al,127
         ja      negativ
pozitiv:
         mov     cl,al
         xor     ch,ch
         push    cx
         mov     bx,320
         mov     ax,word ptr ds:[04]
         mul     bx
         add     ax,word ptr ds:[06]
         mov     di,ax
         rep     movsb
         pop     cx
         add     word ptr ds:[06],cx
         jmp     end_for2

negativ:
         mov    cl,$ff
         sub    cl,al
         inc    cl
         xor    ch,ch
         push   cx
         mov    bx,320
         mov    ax,word ptr ds:[04]
         mul    bx
         add    ax,word ptr ds:[06]
         mov    di,ax
         lodsb
         rep    stosb
         pop    cx
         add    word ptr ds:[06],cx

end_for2:
         pop    cx
         loop   for2
end_for1:
         pop    cx
         inc    cx
         cmp    cx,word ptr ds:[02]
         jnz    for1

         pop    bp
         pop    ds
end;
end;

procedure fli_brun;
var size_count:byte;
    sgg,off,pp,j,nr_p,x,f,k:word;
label for1,for2,end_for1,end_for2,negativ,pozitiv;
begin
        sgg:=seg(buff^);off:=ofs(buff^);
{
00      -l
02      -nr_p
04      -size_count
}
asm
   push    ds
   push    bp
   mov     ax,off
   push    ax
   mov     ax,sgg
   push    ax
   pop     ds
   pop     si
   add     si,29
   mov     ax,$a000
   mov     es,ax
   xor     di,di
   xor     cx,cx
for1:
   push    cx
   lodsb
   xor     ah,ah
   mov     word ptr ds:[02],ax
   mov     cx,ax
for2:
   push    cx
   lodsb
   xor     ah,ah
   mov     word ptr ds:[04],ax
   or      al,al
   jz      end_for2
   cmp     al,127
   ja      negativ
pozitiv:
   mov     cx,ax
   lodsb
   rep     stosb
   jmp     end_for2
negativ:
   mov     cx,$100
   sub     cx,ax
   rep     movsb
end_for2:
   pop     cx
   loop    for2
end_for1:
   pop     cx
   inc     cx
   cmp     cx,200
   jnz     for1
   pop     bp
   pop     ds
end;

{     idx:=30;pp:=0;
     for k:=1 to 200 do begin
         nr_p:=buff^[idx];inc(idx);
         for x:=1 to nr_p do begin
                         size_count:=buff^[idx];inc(idx);
             if size_count>127 then begin
                                    size_count:=256 - size_count;
                                                for j:=1 to size_count do begin
                                                         mem[$a000:pp]:=buff^[idx];
                                                         inc(pp);
                                                         inc(idx);
                                                                                end;
                                                end
                                                 else begin
                                                f:=buff^[idx];inc(idx);
                                                for j:=1 to size_count do begin
                                                         mem[$a000:pp]:=f;
                                                         inc(pp);
                                                                                end;
                                                end;
                                         end;
                        end;
}
end;
var i:word;
procedure fli_black;
var k:word;
begin
                 for k:=0 to 15999 do meml[$a000:k]:=0;
end;

{procedure fli_copy;
var i:word;
begin
                 for i:=1 to 64000 do mem[$a000:i-1]:=buff^[i];
end;}

procedure fli_copy;assembler;
  asm
    push    ds
    mov     ax, $A000
    mov     es, ax
    lds     si,buff
    xor     di, di
    mov     cx, 16000
    db      $F3,$66,$A5  { REP MOVSD }
    pop     ds
  end;

procedure proceschunks;
var p:pointer;
begin
                 case tip_ch of
                 11:fli_color;
                 12:fli_lc;
                 13:fli_black;
                 15:fli_brun;
                 16:fli_copy;
                        else
                        begin
                         getmem(p,size_ch);
                         blockread(f,p^,size_ch);
                         freemem(p,size_ch);
                        end;
                 end;
end;

procedure dochunks;
begin
                 getchunksheader;
                 proceschunks;
end;

var
 nr_f,nr_c:word;

procedure playfli(name:string);
var ff:boolean;
                time:longint;
begin
     new(buff);
                 assign(f,name);
                 {$I-}
                 reset(f,1);
                 {$i+}
                 if ioresult<>0 then
                 begin
      textmode($10);
      writeln('Error : Animation FILE NOT FOUND!');
      writeln('      : '+name+' not found or could not access ...');
      writeln('Press <return>');
      readkey;
      initmode(true);
      halt;
     end;

                 ff:=true;
                 getFLIantet;
                 if not ff then
      begin
       initmode(false);
       writeln('FLI error!');
       halt;
      end
       else initmode(true);
                 ff:=false;
                 repeat
                                for nr_f:=1 to nr_frame do begin
                                time:=meml[0:$46c];
                                                         getFRAMEantet;
                                                         if chunks<>0 then for nr_c:=1 to chunks do dochunks;
               {delay(speed*7);}
               repeat until meml[0:$46c]>=time+speed div 3;
                                                         if keypressed then nr_f:=nr_frame;
                                                         end;
                                seek(f,128);
                 until keypressed;
                 close(f);initmode(false);
     dispose(buff);
end;

procedure playfliOnce(name:string);

var ff:boolean;
                time:longint;
begin
     new(buff);
                 assign(f,name);
                 {$I-}
                 reset(f,1);
                 {$i+}
                 if ioresult<>0 then
                 begin
      textmode($10);
      writeln('Error : Animation FILE NOT FOUND!');
      writeln('Press <return>');
      readkey;
      initmode(true);
      halt;
     end;

                 ff:=true;
                 getFLIantet;
                 if not ff then
      begin
       initmode(false);
       writeln('FLI error!');
       halt;
      end
       else initmode(true);
                 ff:=false;
                                for nr_f:=1 to nr_frame do begin
                                time:=meml[0:$46c];
                                                         getFRAMEantet;
                                                         if chunks<>0 then for nr_c:=1 to chunks do dochunks;
              {delay(speed*7);}
               repeat until meml[0:$46c]>=time+speed div 3;
                                                         if keypressed then nr_f:=nr_frame;
                                                         end;
                 close(f);initmode(false);
     dispose(buff);
end;

end.