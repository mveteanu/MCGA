(*
    ฺอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออป
    ณ                                                               บMCGAบ
    ณ                       ===<<<    UMB   >>>===                  ศออออน
    ณ                                                                    บ
    ณ                       Autor : Marian Veteanu                       บ
    ณ                       Email : vma@electra.upit.ro                  บ
    ณ                                                                    บ
    ณ   Acesta este un unit care vine in ajutorul celor care doresc sa   บ
    ณ   foloseasca blocurile de memorie UMB in programele lor.           บ
    ณ   Unitul face parte din biblioteca MCGA si nu trebuie distribuit   บ
    ณ   in afara acestei biblioteci. Alaturi de grafica 320x200x256      บ
    ณ   biblioteca are suport si pentru grafica SVGA cat si pentru       บ
    ณ   utilizarea placii de sunet, a EMS, a XMS, etc.                   บ
    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*)

UNIT UMB;

INTERFACE


FUNCTION  DOSAllocate (VAR Buf: POINTER; Size: LONGINT) : LONGINT;
PROCEDURE DOSFree     (VAR Buf: POINTER);

FUNCTION  UMBLink     (DoLink: BOOLEAN)                 : BOOLEAN;
FUNCTION  UMBAllocate (VAR Buf: POINTER; Size: LONGINT) : LONGINT;
PROCEDURE UMBFree     (VAR Buf: POINTER);


IMPLEMENTATION

FUNCTION DOSAllocate(VAR Buf: POINTER; Size: LONGINT) : LONGINT;
  VAR
    SizeP    : WORD;
  BEGIN
    SizeP := Size SHR 4;

    ASM

        MOV     BX,SizeP
        MOV     AH,$48
        INT     21H
        JNC     @@Ok
        MOV     SizeP,BX
        MOV     AH,$48
        INT     21H
        JNC     @@Ok
        MOV     AX,0
        MOV     SizeP,AX
@@Ok:   LES     DI,Buf
        MOV     [ES:DI+2],AX
        XOR     AX,AX
        MOV     [ES:DI],AX
    END;

    DOSAllocate := LONGINT(SizeP) SHL 4;
  END;


PROCEDURE DOSFree(VAR Buf: POINTER); ASSEMBLER;
  ASM
        LES     DI,Buf
        MOV     AX,[ES:DI+2]
        XOR     BX,BX
        MOV     [ES:DI+2],BX
        MOV     [ES:DI],BX
        MOV     ES,AX
        MOV     AH,$49
        INT     $21
  END;




FUNCTION UMBLink(DoLink: BOOLEAN) : BOOLEAN; ASSEMBLER;
  ASM
        MOV     AX,$5802
        INT     21H
        MOV     AH,0
        JC      @@Fin
        MOV     AH,AL
        PUSH    AX
        MOV     AX,5803H
        XOR     BH,BH
        MOV     BL,DoLink
        INT     21H
        POP     AX
@@Fin:
        MOV     AL,AH
  END;


FUNCTION UMBAllocate(VAR Buf: POINTER; Size: LONGINT) : LONGINT;
  VAR
    SaveLink : BOOLEAN;
  BEGIN
    SaveLink    := UMBLink(TRUE);
    UMBAllocate := DOSAllocate(Buf, Size);
    UMBLink(SaveLink);
  END;


PROCEDURE UMBFree(VAR Buf: POINTER);
  VAR
    SaveLink : BOOLEAN;
  BEGIN
    SaveLink := UMBLink(TRUE);
    DOSFree(Buf);
    UMBLink(SaveLink);
  END;

END.

