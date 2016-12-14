{$R-,G+,L-,D-}
Unit SB;

Interface
{$I SBCONST.INC}

FUNCTION  SbReset : BOOLEAN;
PROCEDURE SbWriteLoop    (t: WORD);
PROCEDURE SbWriteByte    (t: WORD; b: BYTE);
PROCEDURE SbReadLoop     (t: WORD);
FUNCTION  SbReadByte     (t: WORD) : BYTE;

PROCEDURE SbWriteMixerReg (Reg, Val: BYTE);
FUNCTION  SbReadMixerReg  (Reg: BYTE) : BYTE;

FUNCTION  SbRegDetect : BOOLEAN;
PROCEDURE SbRegInit;
PROCEDURE SbRegDone;

PROCEDURE SbGetDSPVersion;
PROCEDURE SbGetCopyrightString;
PROCEDURE SbSetTimeConst    (tc: BYTE);
PROCEDURE SbUpdateTimeConst;
PROCEDURE SbStartSampleLS   (Len: WORD; Cont: BOOLEAN);
PROCEDURE SbStartSampleHS   (Len: WORD; Cont: BOOLEAN);
PROCEDURE SbPlaySample      (Len: WORD; Cont: BOOLEAN);

FUNCTION MixerDetect : BOOLEAN;

PROCEDURE MixerSetVolume(Reg: TMixerVolume; VolLeft, VolRight: BYTE);
FUNCTION  MixerGetVolume(Reg: TMixerVolume; VAR VolLeft, VolRight: BYTE) : BOOLEAN;

FUNCTION  SbProDetect : BOOLEAN;
PROCEDURE SbProInit;
PROCEDURE SbProDone;

PROCEDURE SbProSetStereo (Stereo: BOOLEAN);
PROCEDURE SbProSetFilter (Filter: BOOLEAN);

FUNCTION  Sb16Detect : BOOLEAN;
PROCEDURE Sb16Init;
PROCEDURE Sb16Done;

PROCEDURE Sb16StartSample(Len: WORD; Cont: BOOLEAN);



IMPLEMENTATION

uses math;

CONST
  Debug      : BOOLEAN = TRUE; { Set to FALSE to deactivate the debugging output. }
  Offs       : WORD = 0;
  ScrSegment : WORD = $B800;

PROCEDURE DirectWriteAttr(offs: WORD; s: STRING; a: BYTE); ASSEMBLER;
  ASM
        MOV     BX,offs
        MOV     AX,ScrSegment
        MOV     ES,AX
        PUSH    DS
        LDS     SI,s
        MOV     AH,a
        MOV     CL,[DS:SI]
@@lp:   AND     CL,CL
        JZ      @@fin
        INC     SI
        MOV     AL,[DS:SI]
        MOV     [ES:BX],AX
        INC     BX
        INC     BX
        DEC     CL
        JMP     @@lp
@@fin:  POP     DS
  END;

PROCEDURE WriteChar(c: CHAR; a: BYTE);
  BEGIN
    IF Debug THEN
      BEGIN
        Offs := Offs AND 8191;
        DirectWriteAttr(Offs, c, a);
        INC(Offs, 2);
      END;
  END;

PROCEDURE WriteSNum(w: WORD; a: BYTE);
  VAR
    s : STRING[4];
    i : WORD;
  BEGIN
    IF Debug THEN
      BEGIN
        s := HexWord(w);
        FOR i := 1 TO 4 DO WriteChar(s[i], a);
      END;
  END;


FUNCTION SbReset : BOOLEAN;
  CONST
    ready = $AA;
  VAR
    ct, stat : BYTE;
  BEGIN
    PORT[DSPResetPort] := 1;
    FOR ct := 1 TO 100 DO;
    PORT[DSPResetPort] := 0;

    stat := 0;
    ct   := 0;
    WHILE (stat <> ready) AND (ct < 100) DO BEGIN
      stat := PORT[DSPRStatPort];
      stat := PORT[DSPReadPort];
      INC(ct);
    END;

    SbReset := stat = ready;
  END;


PROCEDURE SbWriteLoop(t: WORD); ASSEMBLER;
  ASM

                MOV     BX,t
                MOV     DX,[DSPWritePort]
@@lp:            DEC    BX
                 JZ     @@fin
                 IN     AL,DX
                 ADD    AL,AL
                 JC     @@lp
@@fin:          OR      BL,BH
                MOV     [SbWorksOk],BL
  END;


PROCEDURE SbWriteByte(t: WORD; b: BYTE); ASSEMBLER;
  ASM

                MOV     AL,b
                XOR     AH,AH
                PUSH    AX
                PUSH    $60
                CALL    WriteSNum

                MOV     AX,t
                PUSH    AX
                CALL    SbWriteLoop
                JNZ     @@ya

                MOV     DX,[DSPLifePort]
                IN      AL,DX

                MOV     AX,t
                PUSH    AX
                CALL    SbWriteLoop

@@ya:           MOV     AL,b
                OUT     DX,AL

                MOV     AL,[SbWorksOk]
                ADD     AL,'A'
                XOR     AH,AH
                PUSH    AX
                PUSH    $40
                CALL    WriteChar

  END;


PROCEDURE SbReadLoop(t: WORD); ASSEMBLER;
  ASM

                MOV     BX,t
                MOV     DX,[DSPRStatPort]
@@lp:            DEC    BX
                 JZ     @@fin
                 IN     AL,DX
                 ADD    AL,AL
                 JNC    @@lp
@@fin:          OR      BL,BH
                MOV     [SbWorksOk],BL
                MOV     DX,[DSPReadPort]
  END;


FUNCTION SbReadByte(t: WORD) : BYTE; ASSEMBLER;
  ASM
                MOV     AX,t
                PUSH    AX
                CALL    SbReadLoop
                JNZ     @@ya
{
                MOV     DX,[DSPLifePort]
                IN      AL,DX

                MOV     AX,t
                PUSH    AX
                CALL    SbReadLoop
}
@@ya:           IN      AL,DX
  END;


PROCEDURE SbWriteMixerReg(Reg, Val: BYTE); ASSEMBLER;
  ASM

                MOV     DX,[MixAddrPort]
                MOV     AL,[Reg]
                OUT     DX,AL

                MOV     DX,[MixDataPort]
                MOV     AL,[Val]
                OUT     DX,AL

  END;


FUNCTION SbReadMixerReg(Reg: BYTE) : BYTE; ASSEMBLER;
  ASM

                MOV     DX,[MixAddrPort]
                MOV     AL,[Reg]
                OUT     DX,AL

                MOV     DX,[MixDataPort]
                IN      AL,DX

  END;


FUNCTION SbRegDetect : BOOLEAN;
  VAR
    Port, Lst : WORD;
  BEGIN

    SbRegDetect := SbRegDetected;

    IF SbRegDetected THEN EXIT;

    IF SbPort < $8000 THEN
      BEGIN
        Port := SbPort;
        Lst  := SbPort;
      END
    ELSE
      BEGIN
        Port := $210;
        Lst  := $280;
      END;

    WHILE (NOT SbRegDetected) AND (Port <= Lst) DO BEGIN
      CMS1DataPort := Port + CMS1DataPortOffset;
      CMS1AddrPort := Port + CMS1AddrPortOffset;
      CMS2DataPort := Port + CMS2DataPortOffset;
      CMS2AddrPort := Port + CMS2AddrPortOffset;

      MixAddrPort  := Port + MixAddrPortOffset;
      MixDataPort  := Port + MixDataPortOffset;

      FMStatPort   := Port + FMStatPortOffset;
      FMAddrPort   := Port + FMAddrPortOffset;
      FMDataPort   := Port + FMDataPortOffset;

      LFMStatPort  := Port + LFMStatPortOffset;
      LFMAddrPort  := Port + LFMAddrPortOffset;
      LFMDataPort  := Port + LFMDataPortOffset;

      RFMStatPort  := Port + RFMStatPortOffset;
      RFMAddrPort  := Port + RFMAddrPortOffset;
      RFMDataPort  := Port + RFMDataPortOffset;

      DSPResetPort := Port + DSPResetPortOffset;
      DSPReadPort  := Port + DSPReadPortOffset;
      DSPLifePort  := Port + DSPLifePortOffset;
      DSPWStatPort := Port + DSPWStatPortOffset;
      DSPWritePort := Port + DSPWritePortOffset;
      DSPRStatPort := Port + DSPRStatPortOffset;
      DSP8AckPort  := Port + DSP8AckPortOffset;
      DSP16AckPort := Port + DSP16AckPortOffset;

      CDDataPort   := Port + CDDataPortOffset;
      CDCmdPort    := Port + CDCmdPortOffset;
      CDStatPort   := Port + CDStatPortOffset;
      CDResetPort  := Port + CDResetPortOffset;
      CDEnablePort := Port + CDEnablePortOffset;

      SbRegDetected := SbReset;

      IF NOT SbRegDetected THEN INC(Port, $10);
    END;

    SbRegDetect := SbRegDetected;

  END;


PROCEDURE SbRegInit;
  BEGIN

    IF NOT SbRegDetect THEN EXIT;

    IF NOT SbRegInited THEN
      BEGIN
(*
        SbWriteByte(SbDefTimeout, $E0);
        SbWriteByte(SbDefTimeout, $AA);
        SbResponse1 := SbReadByte (SbDefTimeout); { $55 }
        SbWriteByte(SbDefTimeout, $E4);
        SbWriteByte(SbDefTimeout, $AA);
        SbWriteByte(SbDefTimeout, $E8);
        SbResponse2 := SbReadByte (SbDefTimeout); { $AA }
*)
        SbGetDSPVersion;

        DoHiSpeed := (SbVersion > $200) AND SbHiSpeed {AND FALSE};
{
        IF DoHiSpeed THEN
          BEGIN
            SbWriteByte(SbDefTimeout, $48);
            SbWriteByte(SbDefTimeout, $00);
            SbWriteByte(SbDefTimeout, $00);
            SbWriteByte(SbDefTimeout, $91);
          END;
}
        SbWriteByte(SbDefTimeout, sdcTurnOnSpeaker);

      END;

    SbRegInited := TRUE;

  END;


PROCEDURE SbRegDone;
  BEGIN
    IF NOT (SbRegDetected AND SbRegInited) THEN EXIT;
{    SbWriteByte(SbDefTimeout, sdcTurnOffSpeaker);}
    SbRegDetected := FALSE;
    SbRegInited   := FALSE;
  END;




PROCEDURE SbGetDSPVersion;
  VAR
    i : WORD;
    t : WORD;
    s : STRING[2];
  BEGIN
    SbWriteByte(SbDefTimeout, sdcGetDSPVersion); { Send command. }
    t := 0;
    REPEAT
      SbVersionMaj := SbReadByte($FFFF);
      INC(t);
    UNTIL ((SbVersionMaj <> $AA) AND SbWorksOk) OR (t >= 10);
    SbVersionMin := SbReadByte(SbDefTimeout);

    STR(SbVersionMaj, SbVersionStr);
    SbVersionStr := SbVersionStr + '.';
    STR(SbVersionMin, s);
    IF SbVersionMin > 9 THEN SbVersionStr := SbVersionStr +       s
                        ELSE SbVersionStr := SbVersionStr + '0' + s;
  END;


PROCEDURE SbGetCopyrightString;
  VAR
    t : WORD;
  BEGIN
    SbWriteByte(SbDefTimeout, sdcGetCopyright); { Send command. }
    t := 0;
    REPEAT
      SbCopyright := CHAR(SbReadByte($FFFF));
      INC(t);
    UNTIL ((SbCopyright[1] <> #$AA) AND SbWorksOk) OR (t = 10);

    WHILE SbWorksOk AND (Length(SbCopyright) < 80) DO
      SbCopyright := SbCopyright + CHAR(SbReadByte(SbDefTimeout));

    DEC(SbCopyright[0]);
  END;


PROCEDURE SbSetTimeConst(tc: BYTE);
  BEGIN
    IF Sb16Detected THEN
      BEGIN
        IF Sb16Bit THEN
          SbWriteByte(SbDefTimeout, $D9)  { Send time constant command.             }
        ELSE
          SbWriteByte(SbDefTimeout, $DA); { Send time constant command.             }
      END;
    SbWriteByte(SbDefTimeout,   sdcSetTimeConst); { Send time constant command.             }
    SbWriteByte(SbDefTimeout*4, tc);              { Send the time constant.                 }
    TimeConst := 0;                               { Reset time constant to already changed. }
    IF Sb16Detected THEN
      IF Sb16Bit THEN
        SbWriteByte(SbDefTimeout, $47)  { Send time constant command.             }
      ELSE
        SbWriteByte(SbDefTimeout, $45); { Send time constant command.             }
  END;


PROCEDURE SbUpdateTimeConst;
  BEGIN
    IF TimeConst = 0 THEN EXIT;                 { If not changed then do nothing.         }
    SbSetTimeConst(TimeConst);
  END;


PROCEDURE SbStartSampleLS(Len: WORD; Cont: BOOLEAN);
  BEGIN
    HSBlockSpecified := 0;   { Reset Hi-speed block specifier, just in case. }

    SbWriteByte(SbDefTimeout, sdcStartLSpeedDMA); { Start DMA low speed command.   }
    SbWriteByte(SbDefTimeout, LO(Len));           { Low & high bytes of size.      }
    SbWriteByte(SbDefTimeout, HI(Len));
  END;


PROCEDURE SbStartSampleHS(Len: WORD; Cont: BOOLEAN);
  BEGIN
    IF HSBlockSpecified <> Len THEN Cont := FALSE;
    IF NOT Cont THEN
      BEGIN
        SbWriteByte(SbDefTimeout, sdcSetHSpeedSize);  { Set hi speed DMA block command. }
        SbWriteByte(SbDefTimeout, LO(Len));           { Low & high bytes of size.       }
        SbWriteByte(SbDefTimeout, HI(Len));
        HSBlockSpecified := Len;
      END;

    IF NOT (Sb16Detected AND Cont) THEN
      SbWriteByte(SbDefTimeout, sdcStartHSpeedDMA); { Start DMA in hi speed mode.    }
  END;


PROCEDURE SbPlaySample(Len: WORD; Cont: BOOLEAN);
  BEGIN

    IF Len < 10 THEN EXIT;   { Too short -> Discard. It wouldn't sound anyway. }

    IF SbStereo THEN INC(Len, Len); { Twice as big a buffer if stereo mode. }
    DEC(Len);                       { DMA sizes are always size - 1.        }

    IF Sb16Detected AND (SbStereo OR Sb16Bit) THEN
      Sb16StartSample(Len, Cont)
    ELSE IF DoHiSpeed THEN
      SbStartSampleHS(Len, Cont)
    ELSE
      SbStartSampleLS(Len, Cont);
  END;


FUNCTION MixerDetect : BOOLEAN;
  VAR
    SaveReg : WORD;
    NewReg  : WORD;
  BEGIN
    MixerDetect := MixerDetected;
    IF NOT SbRegDetect OR MixerDetected THEN EXIT;

    SaveReg := SbReadMixerReg($22);
    SbWriteMixerReg($22, 243);
    NewReg  := SbReadMixerReg($22);

    IF NewReg = 243 THEN
      MixerDetected := TRUE;

    SbWriteMixerReg($22, SaveReg);

    MixerDetect := MixerDetected;
  END;




PROCEDURE MixerSetVolume(Reg: TMixerVolume; VolLeft, VolRight: BYTE);
  VAR
    Addr   : BYTE;
    VolMax : BYTE;
  BEGIN
    IF NOT MixerDetected THEN EXIT;

    IF Sb16Detected THEN Addr := Sb16Regs [Reg]
                    ELSE Addr := SbProRegs[Reg];

    IF VolLeft > VolRight THEN VolMax := VolLeft
                          ELSE VolMax := VolRight;

    CASE Reg OF
      mvMicrophone : BEGIN
                       IF Sb16Detected THEN SbWriteMixerReg(Addr, VolMax)
                                       ELSE SbWriteMixerReg(Addr, VolMax SHR 5);
                     END;
      mvSpeaker    : BEGIN
                       IF Sb16Detected THEN SbWriteMixerReg(Addr, VolMax);
                     END;
    ELSE

      IF Sb16Detected THEN
        BEGIN
          SbWriteMixerReg(Addr,     VolLeft);
          SbWriteMixerReg(Addr + 1, VolRight);
        END
      ELSE
        SbWriteMixerReg(Addr, (VolLeft  AND $F0) +
                              (VolRight SHR   4));

    END;

  END;


FUNCTION MixerGetVolume(Reg: TMixerVolume; VAR VolLeft, VolRight: BYTE) : BOOLEAN;
  VAR
    Addr   : BYTE;
    VolMax : BYTE;
  BEGIN
    MixerGetVolume := FALSE;

    IF NOT MixerDetected THEN EXIT;

    IF Sb16Detected THEN Addr := Sb16Regs [Reg]
                    ELSE Addr := SbProRegs[Reg];

    VolLeft  := 0;
    VolRight := 0;

    MixerGetVolume := TRUE;

    CASE Reg OF
      mvMicrophone : BEGIN
                       IF Sb16Detected THEN VolLeft := SbReadMixerReg(Addr)
                                       ELSE VolLeft := SbReadMixerReg(Addr) SHL 5;
                       VolRight := VolLeft;
                     END;
      mvSpeaker    : BEGIN
                       IF Sb16Detected THEN VolLeft := SbReadMixerReg(Addr)
                                       ELSE MixerGetVolume := FALSE;
                       VolRight := VolLeft;
                     END;
    ELSE

      IF Sb16Detected THEN
        BEGIN
          VolLeft  := SbReadMixerReg(Addr);
          VolRight := SbReadMixerReg(Addr + 1);
        END
      ELSE
        BEGIN
          VolLeft  := SbReadMixerReg(Addr);
          VolRight := VolLeft SHL 4;
          VolLeft  := VolLeft AND $F0;
        END;

    END;

  END;


FUNCTION SbProDetect : BOOLEAN;
  BEGIN
    SbProDetect := SbProDetected;
    IF SbProDetected THEN EXIT;

    IF NOT SbRegInited THEN SbRegInit;

    SbProDetected := SbRegDetect AND MixerDetect AND (SbVersion < $400);
    SbProDetect   := SbProDetected;
  END;


PROCEDURE SbProInit;
  BEGIN
    IF NOT SbProDetect THEN EXIT;
    SbProInited := TRUE;
  END;


PROCEDURE SbProDone;
  BEGIN
    SbRegDone;
  END;




PROCEDURE SbProSetStereo(Stereo: BOOLEAN);
  VAR
    i : BYTE;
  BEGIN
    IF NOT SbProDetected THEN EXIT;
    SbStereo := Stereo;
    i := SbReadMixerReg(mxrOutSetting);
    SbWriteMixerReg(mxrOutSetting, (i      AND NOT mxoStereoOn) +
                                   (BYTE(Stereo) * mxoStereoOn));
  END;


PROCEDURE SbProSetFilter(Filter: BOOLEAN);
  VAR
    i : BYTE;
  BEGIN
    IF NOT SbProDetected THEN EXIT;
    SbFilter := Filter;
    i := SbReadMixerReg(mxrOutSetting);
    SbWriteMixerReg(mxrOutSetting, (i      AND NOT mxoFilterNeg) +
                                   (BYTE(Filter) * mxoFilterNeg));
  END;


FUNCTION Sb16Detect : BOOLEAN;
  BEGIN
    Sb16Detect := Sb16Detected;
    IF Sb16Detected THEN EXIT;

    IF NOT SbRegInited THEN SbRegInit;

    Sb16Detected := SbRegDetect AND MixerDetect AND (SbVersion >= $400);
    Sb16Detect   := Sb16Detected;
  END;


PROCEDURE Sb16Init;
  BEGIN
    IF NOT Sb16Detect THEN EXIT;

    SbGetCopyrightString;

    Sb16Inited := TRUE;
  END;


PROCEDURE Sb16Done;
  BEGIN
    SbRegDone;
  END;




PROCEDURE Sb16StartSample(Len: WORD; Cont: BOOLEAN);
  BEGIN

    IF (NOT Cont) OR (Sb16BlockSpecified <> Len){ OR TRUE }THEN
      BEGIN
        IF Sb16Bit THEN
          SbWriteByte(SbDefTimeout, $B6)
        ELSE
          SbWriteByte(SbDefTimeout, $C6);
        IF SbStereo THEN
          SbWriteByte(SbDefTimeout, $20)
        ELSE
          SbWriteByte(SbDefTimeout, $00);
        SbWriteByte(SbDefTimeout, LO(Len));
        SbWriteByte(SbDefTimeout, HI(Len));
        Sb16BlockSpecified := Len;
      END
    ELSE
      BEGIN
        IF Sb16Bit THEN
          SbWriteByte(SbDefTimeout, $47)
        ELSE
          SbWriteByte(SbDefTimeout, $45);
      END;

  END;

END.
