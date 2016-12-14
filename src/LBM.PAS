(*
    ฺอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออป
    ณ                                                               บMCGAบ
    ณ                       ===<<<    LBM   >>>===                  ศออออน
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

UNIT LBM;

INTERFACE

uses mcga;

procedure LoadLBMFile(filename : string;
                       scr : VirtualScreen;var pal:palettetype);

          { Doar imagini 320x200x256 mai mici de 65535 bytes }

IMPLEMENTATION

TYPE
        string4 = string[4];
TYPE
        pBuffer = ^tBuffer;
        tBuffer = array[1..64000] of byte;

VAR
        CMAP : array[1..256*3] of byte;
        Config : RECORD
                width,
                height        : word;
                depth         : byte;
                compressed    : word;
                screenwidth,
                screenheight  : word;
        end;


(*---------------------------------------------------*)
(*            LOW LEVEL ILBM/IFF FUNCTIONS           *)
(*---------------------------------------------------*)

Procedure IFFbmhd(src : pBuffer; i : word);
 Function getword(p : pointer) : word;
 Begin
        getword:= Swap( word(p^) ); {get a word the motorola way...}
 End;
Begin
        Config.width       :=getword( @src^[i] );
        Config.height      :=getword( @src^[i+2] );
        Config.depth       :=src^[i+8];
        Config.compressed  :=getword( @src^[i+10] );
        Config.screenwidth :=getword( @src^[i+16] );
        Config.screenheight:=getword( @src^[i+18] );
End;

Procedure IFFcmap(src : pBuffer; i, clength : word);
{extract colour map from file buffer}
Var
        j : integer;
Begin
        for j:=1 to clength do begin
                CMAP[j]:=src^[i] SHR 2;
                inc(i);
        end;
End;

Procedure IFFbody(VAR dst,src; VAR done : boolean);
{Decompress packed image from file buffer}
Var
        ImageSize : word;
Begin
        ImageSize := Config.Width * Config.Height;
        if ImageSize=0 then exit;

        If Config.Compressed<>$100 then
                Move( src, dst, ImageSize )
        else asm
                push    ds
                les     di,[dst]
                lds     si,[src]
                xor     dx,dx
                cld
                @IFF_loop:
                xor     ah,ah
                lodsb
                or      al,al
                js      @IFF_lower
                inc     ax
                add     dx,ax
                mov     cx,ax
                rep     movsb
                cmp     dx,[ImageSize]
                jb      @IFF_loop
                jmp     NEAR PTR @IFF_done
                @IFF_lower:
                neg     al
                inc     ax
                add     dx,ax
                mov     cx,ax
                lodsb
                rep     stosb
                cmp     dx,[ImageSize]
                jb      @IFF_loop
                @IFF_done:
                pop     ds
        end;
        done:=TRUE;
End;


(*---------------------------------------------------*)
(*                   MISC FUNCTIONS                  *)
(*---------------------------------------------------*)

Function GetChunkName(v : pBuffer; VAR i : word) : string4;
Begin
        GetChunkName:=ConCat(char(v^[i]),char(v^[i+1]),char(v^[i+2]),char(v^[i+3]));
        inc(i,4);
End;

Function GetChunkSize(v : pBuffer; VAR i : word) : word;
Var
        size : word;
Begin
        size:=v^[i] SHL 8;
        inc(size,v^[i+1]); size:=size SHL 8;
        inc(size,v^[i+2]); size:=size SHL 8;
        inc(size,v^[i+3]);
        inc(i,4);
        GetChunkSize:=size;
End;

Procedure ConvertPlanearIFF( src : VirtualScreen );
{Stupid way of putting things. Planear bitmaps works fine on Amiga :),
 but it's a bitch to handle on PCs}
Var
        temp : array[0..319] of byte;
        pos : word;
        x,y,z : byte;
        i,j : word;
Begin
        if (Config.Width > 320) OR (Config.Depth<>8) then exit;

        pos:=0;
        for i:=1 to Config.Height do begin
                Move( linear(src^)[pos], temp, Config.Width );
                x:=$80;
                y:=0;
                for j:=0 to Config.Width-1 do begin
                        z:=j SHR 3;
                        linear(src^)[pos+j]:=(((temp[z] AND x) SHL y) SHR 7) OR
                                                         (((temp[z+40]  AND x) SHL y) SHR 6) OR
                                                         (((temp[z+80]  AND x) SHL y) SHR 5) OR
                                                         (((temp[z+120] AND x) SHL y) SHR 4) OR
                                                         (((temp[z+160] AND x) SHL y) SHR 3) OR
                                                         (((temp[z+200] AND x) SHL y) SHR 2) OR
                                                         (((temp[z+240] AND x) SHL y) SHR 1) OR
                                                         ( (temp[z+280] AND x) SHL y);
                        asm ror [x],1; end;
                        y:=(y+1) AND 7;
                end;
                Inc( pos, Config.Width );
        end;
End;


(*---------------------------------------------------*)
(*           HIGH LEVEL ILBM/IFF FUNCTIONS           *)
(*---------------------------------------------------*)

Procedure ConvertIFF(dst : VirtualScreen; src : pBuffer);
{scan through ilbm-structure.
 'CMAP' and 'BODY' structures are pinned out and processed}
Var
        i : word;
        done : boolean;
        flength : word;
        clength : word;
        imagesize : word;
        chunkname : string4;
Begin
        i:=1;
        done:=FALSE;
        FillChar( Config, SizeOf(Config), 0);
        if (GetChunkName(src,i)<>'FORM') then exit;
        flength:=GetChunkSize(src,i);

        chunkname:=GetChunkName(src,i);
        if chunkname='PBM ' then begin
                repeat
                        chunkname:=GetChunkName(src,i);
                        clength:=GetChunkSize(src,i);
                        if (chunkname='BMHD') then IFFbmhd( src, i );
                        if (chunkname='CMAP') then IFFcmap( src, i, clength );
                        if (chunkname='BODY') then IFFbody( dst^, src^[i], done );
                        if Odd(clength) then inc(clength);
                        inc(i,clength);
                until (i > flength) OR done;
        end
        else if chunkname='ILBM' then begin
                repeat
                        chunkname:=GetChunkName(src,i);
                        clength:=GetChunkSize(src,i);
                        if (chunkname='BMHD') then IFFbmhd( src, i );
                        if (chunkname='CMAP') then IFFcmap( src, i, clength );
                        if (chunkname='BODY') then IFFbody( dst^, src^[i], done );
                        if Odd(clength) then inc(clength);
                        inc(i,clength);
                until (i > flength) OR done;
                ConvertPlanearIFF( dst );
        end;
End;


Procedure LoadLBMFile;
Var
        pFileMem: pBuffer;
        FileHandle : file;
        size : longint;
Begin
        Assign(FileHandle, filename);
        Reset(FileHandle, 1);
        size := FileSize(FileHandle);
        if (size > 65535) then exit;
        if (size > MaxAvail) then exit;
        GetMem(pFileMem, size);
        BlockRead(FileHandle, pFileMem^, size);
        Close(FileHandle);
        ConvertIFF(scr, pFileMem);
        move(cmap,pal,768);
        FreeMem(pFileMem, size);
End;


End.
