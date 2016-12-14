(*
    ฺอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออป
    ณ                                                               บMCGAบ
    ณ                       ===<<<   UKBD   >>>===                  ศออออน
    ณ                                                                    บ
    ณ                       Autor : Marian Veteanu                       บ
    ณ                       Email : vma@electra.upit.ro                  บ
    ณ                                                                    บ
    ณ   Acesta este un unit PASCAL 7.0 pentru gestionarea tastaturii.    บ
    ณ   Unitul face parte din biblioteca MCGA si nu trebuie distribuit   บ
    ณ   in afara acestei biblioteci. Alaturi de grafica 320x200x256      บ
    ณ   biblioteca are suport si pentru grafica SVGA cat si pentru       บ
    ณ   utilizarea placii de sunet, a EMS, a XMS, etc.                   บ
    ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*)

UNIT UKbd;

interface

Function  KbdKeyPressed:boolean;
Function  KbdReadKey:word;       { Asteapta o tasta si apoi returneaza ascii in Lo}
Procedure KbdFlush;              { byte si codul scan in byte-ul Hi.              }
Function  GetExtCode(var ext:boolean):char;
Function  KbdCaps(code:word):word;


Const

 {kbXXXX Number Key Codes}

  kb0        = $0B30;   kb5        = $0635;
  kb1        = $0231;   kb6        = $0736;
  kb2        = $0332;   kb7        = $0837;
  kb3        = $0433;   kb8        = $0938;
  kb4        = $0534;   kb9        = $0A39;

 {kbXXXX KeyPad Number Key Codes}

  kbNum0     = $5230;   kbNum5     = $4C35;
  kbNum1     = $4F31;   kbNum6     = $4D36;
  kbNum2     = $5032;   kbNum7     = $4737;
  kbNum3     = $5133;   kbNum8     = $4838;
  kbNum4     = $4B34;   kbNum9     = $4939;

 {kbXXXX Small Letter Key Codes}

  kba        = $1E61;   kbn        = $316E;
  kbb        = $3062;   kbo        = $186F;
  kbc        = $2E63;   kbp        = $1970;
  kbd        = $2064;   kbq        = $1071;
  kbe        = $1265;   kbr        = $1372;
  kbf        = $2166;   kbs        = $1F73;
  kbg        = $2267;   kbt        = $1474;
  kbh        = $2368;   kbu        = $1675;
  kbi        = $1769;   kbv        = $2F76;
  kbj        = $246A;   kbw        = $1177;
  kbk        = $256B;   kbx        = $2D78;
  kbl        = $266C;   kby        = $1579;
  kbm        = $326D;   kbz        = $2C7A;


 {kbXXXX Ctrl-Letter Key Codes}

  kbCtrlA    = $1E01;   kbCtrlN   = $310E;
  kbCtrlB    = $3002;   kbCtrlO   = $180F;
  kbCtrlC    = $2E03;   kbCtrlP   = $1910;
  kbCtrlD    = $2004;   kbCtrlQ   = $1011;
  kbCtrlE    = $1205;   kbCtrlR   = $1312;
  kbCtrlF    = $2106;   kbCtrlS   = $1F13;
  kbCtrlG    = $2207;   kbCtrlT   = $1414;
  kbCtrlH    = $2308;   kbCtrlU   = $1615;
  kbCtrlI    = $1709;   kbCtrlV   = $2F16;
  kbCtrlJ    = $240A;   kbCtrlW   = $1117;
  kbCtrlK    = $250B;   kbCtrlX   = $2D18;
  kbCtrlL    = $260C;   kbCtrlY   = $1519;
  kbCtrlM    = $320D;   kbCtrlZ   = $2C1A;

 {kbXXXX Alt-Letter Key Codes}

  kbAltA     = $1E00;   kbAltN    = $3100;
  kbAltB     = $3000;   kbAltO    = $1800;
  kbAltC     = $2E00;   kbAltP    = $1900;
  kbAltD     = $2000;   kbAltQ    = $1000;
  kbAltE     = $1200;   kbAltR    = $1300;
  kbAltF     = $2100;   kbAltS    = $1F00;
  kbAltG     = $2200;   kbAltT    = $1400;
  kbAltH     = $2300;   kbAltU    = $1600;
  kbAltI     = $1700;   kbAltV    = $2F00;
  kbAltJ     = $2400;   kbAltW    = $1100;
  kbAltK     = $2500;   kbAltX    = $2D00;
  kbAltL     = $2600;   kbAltY    = $1500;
  kbAltM     = $3200;   kbAltZ    = $2C00;

 {kbXXXX Special Key Codes}

  kbAltEqual = $8300;  kbEnd      = $4F00;
  kbAltMinus = $8200;  kbEnter    = $1C0D;
  kbAltSpace = $0200;  kbEsc      = $011B;
  kbBack     = $0E08;  kbGrayMinus= $4A2D;
  kbCtrlBack = $0E7F;  kbHome     = $4700;
  kbCtrlDel  = $0600;  kbIns      = $5200;
  kbCtrlEnd  = $7500;  kbLeft     = $4B00;
  kbCtrlEnter= $1C0A;  kbNoKey    = $0000;
  kbCtrlHome = $7700;  kbPgDn     = $5100;
  kbCtrlIns  = $0400;  kbPgUp     = $4900;
  kbCtrlLeft = $7300;  kbGrayPlus = $4E2B;
  kbCtrlPgDn = $7600;  kbRight    = $4D00;
  kbCtrlPgUp = $8400;  kbShiftDel = $0700;
  kbCtrlPrtSc= $7200;  kbShiftIns = $0500;
  kbCtrlRight= $7400;  kbShiftTab = $0F00;
  kbDel      = $5300;  kbTab      = $0F09;
  kbDown     = $5000;  kbUp       = $4800;

 {kbXXXX Alt-Number Key Codes}

  kbAlt1     = $7800;   kbAlt6    = $7D00;
  kbAlt2     = $7900;   kbAlt7    = $7E00;
  kbAlt3     = $7A00;   kbAlt8    = $7F00;
  kbAlt4     = $7B00;   kbAlt9    = $8000;
  kbAlt5     = $7C00;   kbAlt0    = $8100;

 {kbXXXX Function Key Codes}

  kbF1       = $3B00;   kbF6      = $4000;
  kbF2       = $3C00;   kbF7      = $4100;
  kbF3       = $3D00;   kbF8      = $4200;
  kbF4       = $3E00;   kbF9      = $4300;
  kbF5       = $3F00;   kbF10     = $4400;

 {kbXXXX Shift-Function Key Codes}

  kbShiftF1  = $5400;   kbShiftF6 = $5900;
  kbShiftF2  = $5500;   kbShiftF7 = $5A00;
  kbShiftF3  = $5600;   kbShiftF8 = $5B00;
  kbShiftF4  = $5700;   kbShiftF9 = $5C00;
  kbShiftF5  = $5800;   kbShiftF10= $5D00;

 {kbXXXX Ctrl-Function Key Codes}

  kbCtrlF1   = $5E00;   kbCtrlF6  = $6300;
  kbCtrlF2   = $5F00;   kbCtrlF7  = $6400;
  kbCtrlF3   = $6000;   kbCtrlF8  = $6500;
  kbCtrlF4   = $6100;   kbCtrlF9  = $6600;
  kbCtrlF5   = $6200;   kbCtrlF10 = $6700;

 {kbXXXX Alt-Function Key Codes}

  kbAltF1    = $6800;   kbAltF6   = $6D00;
  kbAltF2    = $6900;   kbAltF7   = $6E00;
  kbAltF3    = $6A00;   kbAltF8   = $6F00;
  kbAltF4    = $6B00;   kbAltF9   = $7000;
  kbAltF5    = $6C00;   kbAltF10  = $7100;


IMPLEMENTATION
uses crt;

VAR
  KbHead : WORD ABSOLUTE 0:$41A;
  KbTail : WORD ABSOLUTE 0:$41C;

FUNCTION KbdKeyPressed : BOOLEAN; ASSEMBLER;
  ASM
        XOR     AX,AX
        MOV     ES,AX
        MOV     AX,[ES:KbHead]
        SUB     AX,[ES:KbTail]
        JZ      @@1
        MOV     AX,1
        @@1:    STI
  END;


FUNCTION KbdReadKey : WORD; ASSEMBLER;
  ASM
        XOR     AX,AX
        INT     $16
  END;

Function KbdCaps(code:word):word;
begin
 KbdCaps:=Code-$20;
end;

PROCEDURE KbdFlush;
  BEGIN
    KbHead := KbTail;
  END;

Function GetExtCode(var ext:boolean):char;
var c:char;
         begin
              c:=readkey;
              ext:=false;
              if c=#0 then begin
                          ext:=true;
                          GetExtCode:=readkey
                          end
                       else GetExtCode:=c;
         end;

END.
