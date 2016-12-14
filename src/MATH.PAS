unit Math;
interface

TYPE
   Table      = array[0..360] of real;
   LookUpTable= ^Table;
TYPE
  THexPString = STRING[9];
  THexLString = STRING[8];
  THexWString = STRING[4];
  THexBString = STRING[2];
  THexNString = CHAR;


Procedure CreateSINTable(var st:lookuptable;a,omega,fi:real);
Procedure CreateCOSTable(var ct:lookuptable;a,omega,fi:real);
Procedure DistroyTable(var tab:lookuptable);
Function  HexPtr  (p: POINTER) : THexPString; { Converteste POINTER in hexazecimal. }
Function  HexLong (l: LONGINT) : THexLString; { Converteste WORD    in hexazecimal. }
Function  HexWord (w: WORD)    : THexWString; { Converteste WORD    in hexazecimal. }
Function  HexByte (b: BYTE)    : THexBString; { Converteste BYTE    in hexazecimal. }
Function  HexDigit(d: BYTE)    : THexNString; { Converteste nibble  in hexazecimal. }


implementation

Procedure CreateSINTable;
var f:word;
begin
  new(st);
  for f:=0 to 360 do st^[f]:=a*sin((omega*f*pi/180)+fi);
end;

Procedure CreateCOSTable;
var f:word;
begin
  new(ct);
  for f:=0 to 360 do ct^[f]:=a*cos((omega*f*pi/180)+fi);
end;

Procedure DistroyTable;
begin
  dispose(tab);
end;

CONST
  HexTabla : STRING[16] = '0123456789ABCDEF';

FUNCTION HexPtr(p: POINTER) : THexPString;
  BEGIN
    HexPtr := HexWord(SEG(p^)) + ':' + HexWord(OFS(p^));
  END;


FUNCTION HexLong(l: LONGINT) : THexLString;
  BEGIN
    HexLong := HexWord(SEG(POINTER(l)^)) + HexWord(OFS(POINTER(l)^));
  END;


FUNCTION HexWord(w: WORD) : THexWString;
  BEGIN
    HexWord[0] := #4;
    HexWord[1] := HexTabla[ (w SHR 12)         + 1];
    HexWord[2] := HexTabla[((w SHR  8) AND $F) + 1];
    HexWord[3] := HexTabla[((w SHR  4) AND $F) + 1];
    HexWord[4] := HexTabla[( w         AND $F) + 1];
  END;


FUNCTION HexByte(b: BYTE) : THexBString;
  BEGIN
    HexByte[0] := #2;
    HexByte[1] := HexTabla[((b SHR  4) AND $F) + 1];
    HexByte[2] := HexTabla[( b         AND $F) + 1];
  END;


FUNCTION HexDigit(d: BYTE) : THexNString;
  BEGIN
    HexDigit := HexTabla[(d AND $F) + 1];
  END;

end.


