(*
    ÚÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍ»
    ³                                                               ºMCGAº
    ³                       ===<<<    XMS   >>>===                  ÈÍÍÍÍ¹
    ³                                                                    º
    ³                       Autor : Marian Veteanu                       º
    ³                       Email : vma@electra.upit.ro                  º
    ³                                                                    º
    ³   Acesta este un unit care vine in ajutorul celor care doresc sa   º
    ³   foloseasca memoria extinsa prin XMS                              º
    ³   Unitul face parte din biblioteca MCGA si nu trebuie distribuit   º
    ³   in afara acestei biblioteci. Alaturi de grafica 320x200x256      º
    ³   biblioteca are suport si pentru grafica SVGA cat si pentru       º
    ³   utilizarea placii de sunet, a EMS, a XMS, etc.                   º
    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*)


{$B-,D-,F-,D-,L-,R-,S-,V-}
unit XMS;
interface

var       XMSError:byte;
function  XMSInstalled:boolean;
procedure XMSInfo(var Version,InternalVersion:word;var HMAAvail:boolean);
procedure AllocHMA(bytes:word);
procedure FreeHMA;
procedure EnableAddrA20;
procedure DisableAddrA20;
procedure EnableDataA20;
procedure DisableDataA20;
function  A20Status:boolean;
procedure AllocExtMem(KBytes:word;var Handle:word);
procedure FreeExtMem(Handle:word);
procedure FreeExtMemInfo(var MaxFreeBlock,TotalFreeMem {in KBytes } :word);
procedure ReAllocExtMem(KBytes,handle:word);
procedure MoveExtMem(DestOffs:longint;DestHandle:word;SourceOffs:longint;SourceHandle:word;bytes:longint);
procedure ReadExtMem(bytes:longint;SourceHandle:word;SourceOffs:longint;var Dest);
procedure WriteExtMem(var src;bytes:longint;DestHandle:word;DestOffs:longint);
procedure GetHandleInfo(handle:word;var locked:boolean;var HLength {KBytes},FreeHandles:word);
function  GetProtectedMemory(handle:word):pointer;
procedure ReleaseProtectedMemory(handle:word);
procedure AllocSupMem(PagesRequested {16 bytes paragraphs}:word;var PagesAllocated:word;var BaseAddress:pointer);
procedure FreeSupMem(BaseAddress:pointer);

implementation
uses Dos;

var XMSAddr:pointer;
    _ax,_bx,_dx,_si:word;
    var buff:record
              TransferBytes:longint;
              source:word;
              SourceOffset:longint;
              destination:word;
              DestOffset:longint;
             end;

function XMSInstalled:boolean;
var regs:registers;
begin
 with regs do
  begin
    ax:=$4300;
    intr($2F,regs);
    if al<>$80 then XMSInstalled:=false
               else begin
                      ax:=$4310;
                      intr($2f,regs);
                      XMSAddr:=ptr(es,bx);
                      XMSInstalled:=true;
                    end;
  end;
end;

Procedure CallXms;assembler;
asm
 mov ax,[_ax]
 mov bx,[_bx]
 mov dx,[_dx]
 mov si,[_si]
 call [xmsaddr]
 mov [_ax],ax
 mov [_bx],bx
 mov [_dx],dx
end;

Procedure XMSInfo;
begin
_ax:=0;callxms;
version:=_ax;internalversion:=_bx;hmaavail:=_dx=1;
end;

procedure Freeextmeminfo;
begin
_ax:=$0800;callxms;
xmserror:=lo(_bx);
if xmserror=0 then
 begin
  maxfreeblock:=_ax;
  totalfreemem:=_dx;
 end;
end;

procedure AllocHma;
begin
_ax:=$0100;_dx:=bytes;
callxms;if _ax=1 then xmserror:=0 else xmserror:=lo(_bx)
end;

procedure FreeHma;
begin
_ax:=$0200;
callxms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

procedure EnableAddrA20;
begin
_ax:=$0300;
callxms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

procedure DisableAddrA20;
begin
_ax:=$0400;
callxms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

procedure EnableDataA20;
begin
_ax:=$0500;
callxms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

procedure DisableDataA20;
begin
_ax:=$0600;
callxms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

function A20Status;
begin
_ax:=$0700;
callxms;
a20status:=_ax=1;
end;

procedure AllocExtMem;
begin
_ax:=$0900;
_dx:=kbytes;
Callxms;
if _ax=1 then begin xmserror:=0;handle:=_dx;end
         else xmserror:=lo(_bx)
end;

procedure FreeExtMem;
begin
_ax:=$0a00;
_dx:=handle;
CallXms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

procedure MoveExtMem;
begin
move(bytes,buff,sizeof(buff));
_ax:=$0b00;
_si:=ofs(buff);
callxms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

procedure ReadExtMem;
begin
with buff do begin
transferbytes:=bytes;
source:=sourceHandle;
sourceoffset:=sourceoffs;
destination:=0;
destoffset:=longint(@dest)
end;
_ax:=$0b00;
_si:=ofs(buff);
callxms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

procedure WriteExtMem;
begin
with buff do begin
transferbytes:=bytes;
source:=0;
sourceoffset:=longint(@src);
destination:=desthandle;
destoffset:=destoffs;
end;
_ax:=$0b00;
_si:=ofs(buff);
callxms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

function GetProtectedMemory;
type SegOfs=record ofs,seg:word;end;
var linptr:pointer;
begin
_ax:=$0c00;
_dx:=handle;
callxms;
if _ax=1 then begin
 segofs(linptr).seg:=_dx;
 segofs(linptr).ofs:=_bx;
 xmserror:=0;
 end
 else begin
 linptr:=nil;
 xmserror:=lo(_bx)
 end;
 GetProtectedMemory:=LinPtr;
end;

Procedure ReleaseProtectedMemory;
begin
_ax:=$0d00;
_dx:=handle;
callxms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

procedure GetHandleInfo;
begin
_ax:=$0e00;
_dx:=handle;
callxms;
if _ax=1 then begin
 locked:=hi(_bx)=1;
 freehandles:=lo(_bx);
 hlength:=_dx;
 xmserror:=0;
 end
 else xmserror:=lo(_bx);
end;


procedure ReAllocExtMem;
begin
_ax:=$0f00;
_bx:=kbytes;
_dx:=handle;
callxms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

procedure AllocSupMem;
begin
_ax:=$1000;
_dx:=pagesrequested;
callxms;
if _ax=1 then begin
 pagesallocated:=_dx;
 baseaddress:=ptr(_bx,0);
 xmserror:=0;
 end
 else xmserror:=lo(_bx)
end;

procedure FreeSupMem;
begin
_ax:=$1100;
_dx:=seg(baseaddress^);
callxms;
if _ax=1 then xmserror:=0 else xmserror:=lo(_bx);
end;

end.











