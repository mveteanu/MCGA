UNIT PLAYHSC;

INTERFACE

TYPE
  HSC_obj = OBJECT

    Address    : Pointer;
    Music_Load : BOOLEAN;
    Music_Size : LONGINT;
    Music_Run  : BOOLEAN;
    Music_Fade : BOOLEAN;


    CONSTRUCTOR Init (AdlibAddress : WORD);
    PROCEDURE Start;
    PROCEDURE Stop;
    PROCEDURE Fade;
    PROCEDURE LoadMem (Music_Address : Pointer);
    FUNCTION LoadFile (FileName : STRING):BOOLEAN;
    DESTRUCTOR Done;

  END;

IMPLEMENTATION

USES CRT;



{$F+}                               
{$L HSCOBJ.OBJ}                     
PROCEDURE _HscPlayer; EXTERNAL;     
{$F-}                               

FUNCTION  DetectAdlib (SuggestedPort : WORD) : WORD; ASSEMBLER;
  ASM
    MOV  AH,4
    MOV  BX,SuggestedPort
    CALL _HscPlayer
    JNC  @GoOn
    MOV  AX,0FFh
  @GoOn:
  END;

PROCEDURE GetPlayerState (VAR Destination); ASSEMBLER;
  ASM
    MOV  AH,7
    LES  SI,DWORD PTR Destination
    CALL _HscPlayer
  END;

PROCEDURE StartMusic (Song : POINTER; Polling, OldIRQ : BOOLEAN); ASSEMBLER;
  ASM
    MOV  AH,0
    MOV  BL,Polling
    MOV  BH,OldIRQ
    CMP  BH,1
    JE   @Invert
    MOV  BH,1
    JMP  @GoOn
  @Invert:
    XOR  BH,BH
  @GoOn:
    LES  SI,DWORD PTR Song
    CALL _HscPlayer
  END;

PROCEDURE StopMusic; ASSEMBLER;
  ASM
    MOV  AH,2
    CALL _HscPlayer
  END;


CONSTRUCTOR HSC_obj.Init (AdlibAddress : WORD);
VAR
  Dummy : WORD;
BEGIN
  Music_Load := FALSE;
  Music_Run  := FALSE;
  Music_Fade := FALSE;
  Address    := NIL;

  Dummy := DetectAdlib (0);
  Delay (30);
END;

PROCEDURE HSC_obj.Start;
BEGIN
  IF NOT Music_Run THEN BEGIN
    IF Address <> NIL THEN BEGIN
      StartMusic (Address,FALSE,TRUE);
      Music_Run := TRUE;
    END;
  END;
END;

PROCEDURE HSC_obj.Stop;
BEGIN
  IF Music_Run THEN BEGIN
    StopMusic;
    Music_Run := FALSE;
  END;
END;

PROCEDURE HSC_obj.Fade;
BEGIN
  IF Music_Run THEN BEGIN
    ASM
      MOV  AH,3
      CALL _HscPlayer
    END;
    Music_Fade := TRUE;
    Music_Run  := FALSE;
  END;
END;

PROCEDURE HSC_Obj.LoadMem (Music_Address : Pointer);
BEGIN
  IF Music_Fade or Music_Run THEN BEGIN
    StopMusic;
    Music_Run  := FALSE;
    Music_Fade := FALSE;
    IF Music_Load THEN FreeMem (Address,Music_Size);
  END;
  Music_Load := FALSE;
  Address    := Music_Address;
END;

FUNCTION HSC_Obj.LoadFile (Filename : STRING):BOOLEAN;
VAR
  f : FILE;
BEGIN
  IF FileName <> '' THEN BEGIN
    Assign (F,FileName);
    {$I-} RESET (F,1); {$I+}
  END;

  IF (IORESULT <> 0) OR (FileName = '') THEN BEGIN
    Music_Load := FALSE;
    LoadFile   := FALSE;
  END ELSE BEGIN
    IF Music_Fade or Music_Run THEN BEGIN
      StopMusic;
      Music_Run  := FALSE;
      Music_Fade := FALSE;
      IF Music_Load THEN FreeMem (Address,Music_Size);
    END;
    Music_Size := FileSize (F);
    IF MaxAvail < Music_Size THEN BEGIN
      LoadFile   := FALSE;
      Music_Load := FALSE;
    END ELSE BEGIN
      GetMem (Address,Music_Size);
      BlockRead (f,Address^,Music_Size);
      LoadFile   := TRUE;
      Music_Load := TRUE;
    END;
  Close (f);
  END;
END;

DESTRUCTOR HSC_obj.Done;
BEGIN
  IF Music_Run OR Music_Fade THEN StopMusic;
  IF Music_Load THEN FREEMEM (Address,Music_Size);
END;

END.