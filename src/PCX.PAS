(*
    ฺอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออป
    ณ                                                               บMCGAบ
    ณ                       ===<<<    PCX   >>>===                  ศออออน
    ณ                                                                    บ
    ณ                       Autor : Marian Veteanu                       บ
    ณ                       Email : vma@electra.upit.ro                  บ
    ณ                                                                    บ
    ณ   Acesta este un unit PASCAL 7.0 care vine in ajutorul celor care  บ
    ณ   au placi grafice VGA si doresc sa foloseasca modul 320x200x256   บ
    ณ   pentru dezvoltarea de programe de animatie in special jocuri si  บ
    ณ   demonstratii.                                                    บ
    ณ   Unitul face parte din biblioteca MCGA si nu trebuie distribuit   บ
    ณ   in afara acestei biblioteci. Alaturi de grafica 320x200x256      บ
    ณ   biblioteca are suport si pentru grafica SVGA cat si pentru       บ
    ณ   utilizarea placii de sunet, a EMS, a XMS, etc.                   บ
    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*)


UNIT PCX;

INTERFACE

uses mcga;

Procedure LoadPCXFile(x,y:integer;filename:string;
                        scr:VirtualScreen;var pal:Palettetype);
       { Procedura suporta doar imagini 320x200x256 mai mici de 65535 bytes }

IMPLEMENTATION

{$I-}

TYPE
        pHeader = ^HeaderType;
        HeaderType = RECORD
                id : byte;
                ver : byte;
                compressed : boolean;
                bitpixel : byte;
                minx,miny,maxx,maxy : word;
                hdpi,vdpi : word;
                palette : array[1..48] of byte;
                reserved : byte;
                depth : byte;
                width : word;
                palette_type : word;
                hscr,vscr : integer;
                filler : array [74..127] of byte;
        end;
TYPE
        pBuffer = ^tBuffer;
        tBuffer = array[1..64000] of byte;

VAR
        CMAP : array[1..256*3] of byte;



Procedure ExtractCMAP(v : pBuffer; filesize : longint);
Var
        i,j : word;
Begin
        i:=filesize-(256*3)+1;
        for j:=1 to 256*3 do begin
                CMAP[j]:=v^[i] DIV 4;
                inc(i);
        end;
End;


Procedure DecompressPCX(p : VirtualScreen; v : pBuffer; h : pHeader);
Var
        xsize,ysize : integer;
Begin
        xsize:=h^.maxx-h^.minx+1;
        for ysize:=1 to h^.maxy-h^.miny+1 do asm
                push    ds
                lds     si,[v]
                les     di,[p]
                @bigloop:
                xor     bx,bx
                xor     cx,cx
                mov     dl,$C0
                mov     dh,$3F
                @loop:
                lodsb
                mov     cl,1
                mov     ah,al
                and     ah,dl
                cmp     ah,dl
                jne     @copy
                and     al,dh
                mov     cl,al
                lodsb
                @copy:
                add     bx,cx
                rep     stosb
                cmp     bx,[xsize]
                jb      @loop
                pop     ds
                mov     WORD PTR [v],si
                mov     ax,[xsize]
                add     WORD PTR [p],ax
        end;
End;

Procedure ConvertPCX(p : VirtualScreen; v : pBuffer; filesize : longint);
Var
        h : pHeader;
        i : longint;
Begin
        h := pHeader(v);
        with h^ do begin
                if (id<>$0A) then exit;
                if (NOT compressed) OR (bitpixel<>8) OR (depth<>$01) then exit;
        end;
        ExtractCMAP(v, filesize);
        if (h^.ver=$05) then DecompressPCX(p,@v^[129],h);
End;


Procedure LoadPCXFile;
Var
        pFileMem: pBuffer;
        FileHandle : file;
        size : longint;
Begin
        Assign(FileHandle, filename);
        Reset(FileHandle, 1);
        size := FileSize(FileHandle);
        if size > MaxAvail then exit;
        if size > 65535 then exit;
        GetMem(pFileMem, size);
        BlockRead(FileHandle, pFileMem^, size);
        Close(FileHandle);
        if IOResult=0 then begin
                ConvertPCX(scr, pFileMem, size);
                Move(cmap,pal,768);
        end;
        FreeMem(pFileMem, size);
End;

{$I+}

end.
