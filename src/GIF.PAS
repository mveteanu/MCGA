(*
    ÚÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍ»
    ³                                                               ºMCGAº
    ³                       ===<<<    GIF   >>>===                  ÈÍÍÍÍ¹
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


{$G+,X+,R-,F-,S-,D-,L-,I-}
unit GIF;

interface
uses mcga;


Procedure LoadGIFFile(x,y:integer;filename:string;
                        scr:VirtualScreen;var pal:Palettetype);

Procedure LoadGIF (x,y:integer;var F:File;
                      scr:VirtualScreen;var pal:Palettetype);


Const
{Error constants}
         geNoError = 0;         { no errors found }
         geNoFile = 1;          { gif file not found }
         geNotGIF = 2;          { file is not a gif file }
         geNoGlobalColor = 3;   { no Global Color table found }
         geImagePreceded = 4;   { image descriptor preceeded by other unknown data }
         geEmptyBlock = 5;      { Block has no data }
         geUnExpectedEOF = 6;   { unexpected EOF }
         geBadCodeSize = 7;     { bad code size }
         geBadCode = 8;         { Bad code was found }
         geBitSizeOverflow = 9; { bit size went beyond 12 bits }



IMPLEMENTATION

Const
{ terminates stream of data blocks }
        BlockTerminator: byte = 0;
        ExtensionIntroducer: byte = $21;
        ImageSeperator: byte = $2C;
        Trailer: byte = $3B;             { indicates the end of the GIF data stream }
{misc settings}
        MAXSCREENWIDTH = 800;
        MAXCODES = 4095;        { the maximum number of different codes 0 inclusive }
{ logical screen descriptor packed field masks }
        lsdGlobalColorTable = $80;       { set if global color table follows L.S.D. }
        lsdColorResolution = $70;        { Color resolution - 3 bits }
        lsdSort = $08;                   { set if global color table is sorted - 1 bit }
        lsdColorTableSize = $07;         { size of global color table - 3 bits }

                         { Actual size = 2^value+1    - value is 3 bits }
{ image descriptor bit masks }
        idLocalColorTable = $80;         { set if a local color table follows }
        idInterlaced = $40;              { set if image is interlaced }
        idSort = $20;                    { set if color table is sorted }
        idReserved = $0C;                { reserved - must be set to $00 }
        idColorTableSize = $07;  { size of color table as above }
{ other extension blocks not currently supported by this unit
                  - Graphic Control extension
                  - Comment extension           I'm not sure what will happen if these blocks
                  - Plain text extension        are encountered but it'll be interesting
                  - application extension }


Type
         pGifScreen = ^GifScreen;
         GifScreen = array[0..199, 0..319] of byte;

         TExtensionBlock = record
                                Introducer: byte;       { fixed value of ExtensionIntroducer }
                                ExtensionLabel: byte;
                                BlockSize: byte;
         end;

         PCodeItem = ^TCodeItem;
         TCodeItem = record
                                Code1, Code2: byte;
         end;

         TLogicalScreenDescriptor = record
                                ScreenWidth: word;      { logical screen width }
                                ScreenHeight: word;     { logical screen height }
                                PackedFields: byte;     { packed fields - see below }
                                BackGroundColorIndex: byte;     { index to global color table }
                                AspectRatio: byte;      { actual ratio = (AspectRatio + 15) / 64 }
         end;

         TColorItem = record     { one item in a color table }
                                Red: byte;
                                Green: byte;
                                Blue: byte;
         end;

         TColorTable = array[0..255] of TColorItem;      { the color table }

         TDataSubBlock = record
                                Size: byte;                  { size of the block -- 0 to 255 }
                                Data: array[1..255] of byte; { the data }
         end;

         TImageDescriptor = record
                                Seperator: byte;        { fixed value of ImageSeperator }
                                ImageLeftPos: word;     { Column in pixels in respect to left edge of logical screen }
                                ImageTopPos: word;      { row in pixels in respect to top of logical screen }
                                ImageWidth: word;       { width of image in pixels }
                                ImageHeight: word;      { height of image in pixels }
                                PackedFields: byte;     { see below }
          end;

         THeader = record
                                Signature: array[0..2] of char; { contains 'GIF' }
                                Version: array[0..2] of char;   { '87a' or '89a' }
         end;


Var
        { These are the actual GIF variables }
        Header : THeader;                         { gif file header }
        LogicalScreen: TLogicalScreenDescriptor;  { gif screen descriptor }
        GlobalColorTable: TColorTable;            { global color table }
        LocalColorTable: TColorTable;             { local color table }
        ImageDescriptor: TImageDescriptor;        { image descriptor }
        UseLocalColors: boolean;                  { true if local colors in use }
        Interlaced: boolean;                      { true if image is interlaced }
        LZWCodeSize: byte;                        { minimum size of the LZW codes in bits }
        ImageData: TDataSubBlock;                 { variable to store incoming gif data }
        TableSize: word;                          { number of entrys in the color table }
        BitsLeft, BytesLeft: integer;{ bits left in byte - bytes left in block }
        BadCodeCount: word;          { bad code counter }
        CurrCodeSize: integer;       { Current size of code in bits }
        ClearCode: integer;          { Clear code value }
        EndingCode: integer;         { ending code value }
        Slot: word;         { position that the next new code is to be added }
        TopSlot: word;      { highest slot position for the current code size }
        HighCode: word;     { highest code that does not require decoding }
        NextByte: integer;  { the index to the next byte in the datablock array }
        CurrByte: byte;     { the current byte }
        DecodeStack: array[0..MAXCODES] of byte;  { stack for the decoded codes }
        Prefix: array[0..MAXCODES] of word;       { array for code prefixes }
        Suffix: array[0..MAXCODES] of byte;       { array for code suffixes }
        LineBuffer: array[0..MAXSCREENWIDTH] of byte; { array for buffer line output }
        CurrentX, CurrentY: integer;              { current screen locations }
        meux,meuy:integer;
        Status: word;                             { status of the decode }
        InterlacePass: byte;    { interlace pass number }

        destination : pGifScreen;


Procedure LoadGif;

Function Power(A, N: real): real;       { returns A raised to the power of N }
begin
        Power := exp(N * ln(A));
end;

Procedure Error(What: integer);
begin
        Status := What;
end;

Procedure InitGraphics;
Var
         I, J : integer;
Begin
        { the following loop sets up the RGB palette }
        J:=0;
        if not UseLocalColors then
                for I := 0 to TableSize - 1 do begin
                        pal[j,1]:=GlobalColorTable[I].Red SHR 2;
                        pal[j,2]:=GlobalColorTable[I].Green SHR 2;
                        pal[j,3]:=GlobalColorTable[I].Blue SHR 2;
                        Inc(J)
                end
        else
                for I := 0 to TableSize - 1 do begin
                        pal[j,1]:=LocalColorTable[I].Red SHR 2;
                        pal[j,2]:=LocalColorTable[I].Green SHR 2;
                        pal[j,3]:=LocalColorTable[I].Blue SHR 2;
                        Inc(J);
                end;
end;

Procedure DrawLine;
Var
        I: integer;
Begin
         for I := CurrentX to ImageDescriptor.ImageWidth+CurrentX do
                destination^[CurrentY,I]:=LineBuffer[I-CurrentX];
         Inc(CurrentY);

         if InterLaced then begin    { Interlace support }
                  case InterlacePass of
                         0: CurrentY := CurrentY + 7;
                         1: CurrentY := CurrentY + 7;
                         2: CurrentY := CurrentY + 3;
                         3: CurrentY := CurrentY + 1;
                  end;
                  if CurrentY >= ImageDescriptor.ImageHeight+meuy then begin
                         inc(InterLacePass);
                         case InterLacePass of
                                1: CurrentY := meuy+4;
                                2: CurrentY := meuy+2;
                                3: CurrentY := meuy+1;
                         end;
                  end;
         end;
end;


{ TGif }
Procedure Init;
begin
         BlockRead(F, Header, sizeof(Header));                                           { read the header }
         if Header.Signature <> 'GIF' then Error(geNotGIF);                              { is vaild signature }
         BlockRead(F, LogicalScreen, sizeof(LogicalScreen));
         if LogicalScreen.PackedFields and lsdGlobalColorTable = lsdGlobalColorTable then begin
                 TableSize := trunc(Power(2,(LogicalScreen.PackedFields and lsdColorTableSize)+1));
                 BlockRead(F, GlobalColorTable, TableSize*sizeof(TColorItem)); { read Global Color Table }
         end
         else
                 Error(geNoGlobalColor);
         BlockRead(F, ImageDescriptor, sizeof(ImageDescriptor)); { read image descriptor }
         { verify that it is the descriptor }
         if ImageDescriptor.Seperator <> ImageSeperator then Error(geImagePreceded);
         if ImageDescriptor.PackedFields and idLocalColorTable = idLocalColorTable then begin
                 { if local color table }
                 TableSize := trunc(Power(2,(ImageDescriptor.PackedFields and idColorTableSize)+1));
                 BlockRead(F, LocalColorTable, TableSize*sizeof(TColorItem)); { read Local Color Table }
                 UseLocalColors := True;
         end
         else
                 UseLocalColors := false;
         if ImageDescriptor.PackedFields and idInterlaced = idInterlaced then begin
                        Interlaced := true;
                        InterlacePass := 0;
         end;
         if IOResult <> 0 then Error(geNoFile);
         Status := 0;
end;



Procedure InitCompressionStream;
var
         I: integer;
begin
         BlockRead(F, LZWCodeSize, sizeof(byte));{ get minimum code size }
         { valid code sizes 2-9 bits }
         if not (LZWCodeSize in [2..9]) then Error(geBadCodeSize);

         CurrCodeSize := succ(LZWCodeSize); { set the initial code size }
         ClearCode := 1 SHL LZWCodeSize;    { set the clear code }
         EndingCode := succ(ClearCode);     { set the ending code }
         HighCode := pred(ClearCode);       { set the highest code not needing decoding }
         BytesLeft := 0;                    { clear other variables }
         BitsLeft := 0;
end;

Procedure ReadSubBlock;
begin
         BlockRead(F, ImageData.Size, sizeof(ImageData.Size)); { get the data block size }
         if ImageData.Size = 0 then Error(geEmptyBlock); { check for empty block }
         BlockRead(F, ImageData.Data, ImageData.Size);   { read in the block }
         NextByte := 1;                                  { reset next byte }
         BytesLeft := ImageData.Size;                    { reset bytes left }
end;

Const
        CodeMask: array[0..12] of longint = (  { bit masks for use with Next code }
                          0,
                          $0001, $0003,
                          $0007, $000F,
                          $001F, $003F,
                          $007F, $00FF,
                          $01FF, $03FF,
                          $07FF, $0FFF);

Function NextCode: word; { returns a code of the proper bit size }
var
                  Ret: longint;                             { temporary return value }
begin
  if BitsLeft = 0 then                            { any bits left in byte ? }
                  begin                                     { any bytes left }
                                if BytesLeft <= 0 then                { if not get another block }
                                          ReadSubBlock;
                                CurrByte := ImageData.Data[NextByte]; { get a byte }
                                inc(NextByte);                        { set the next byte index }
                                BitsLeft := 8;                        { set bits left in the byte }
                                dec(BytesLeft);                       { decrement the bytes left counter }
                  end;
                  ret := CurrByte shr (8 - BitsLeft);       { shift off any previosly used bits}
                  while CurrCodeSize > BitsLeft do          { need more bits ? }
                  begin
                                if BytesLeft <= 0 then                { any bytes left in block ? }
                                        ReadSubBlock;                      { if not read in another block }
                                CurrByte := ImageData.Data[NextByte]; { get another byte }
                                inc(NextByte);                        { increment NextByte counter }
                                ret := ret or (CurrByte shl BitsLeft);{ add the remaining bits to the return value }
                                BitsLeft := BitsLeft + 8;             { set bit counter }
                                dec(BytesLeft);                       { decrement bytesleft counter }
                  end;
                  BitsLeft := BitsLeft - CurrCodeSize;  { subtract the code size from bitsleft }
                  ret := ret and CodeMask[CurrCodeSize];{ mask off the right number of bits }
                  NextCode := ret;
end;

{ this procedure initializes the graphics mode and actually decodes the
  GIF image }
procedure Decode;
var
        SP: integer; { index to the decode stack }

 { local procedure that decodes a code and puts it on the decode stack }
 procedure DecodeCode(var Code: word);
 begin
          while Code > HighCode do            { rip thru the prefix list placing suffixes }
          begin                               { onto the decode stack }
                  DecodeStack[SP] := Suffix[Code]; { put the suffix on the decode stack }
                  inc(SP);                         { increment decode stack index }
                  Code := Prefix[Code];            { get the new prefix }
          end;
          DecodeStack[SP] := Code;            { put the last code onto the decode stack }
          inc(SP);                                                                     { increment the decode stack index }
 end;

var
         TempOldCode, OldCode: word;
         BufCnt: word;             { line buffer counter }
         Code, C: word;
         CurrBuf: word;            { line buffer index }
begin
         InitGraphics;             { Initialize the graphics mode and RGB palette }
         InitCompressionStream;    { Initialize decoding paramaters }
         OldCode := 0;
         SP := 0;
         BufCnt := ImageDescriptor.ImageWidth; { set the Image Width }
         CurrBuf := 0;

         C := NextCode;            { get the initial code - should be a clear code }
         while C <> EndingCode do  { main loop until ending code is found }
         begin
                  if C = ClearCode then { code is a clear code - so clear }
                  begin
                                CurrCodeSize := LZWCodeSize + 1;{ reset the code size }
                                Slot := EndingCode + 1;         { set slot for next new code }
                                TopSlot := 1 shl CurrCodeSize;  { set max slot number }
                                while C = ClearCode do C := NextCode; { read until all clear codes gone - shouldn't happen }
                                if C = EndingCode then begin
                                        Error(geBadCode);          { ending code after a clear code }
                                        break;                     { this also should never happen }
                                end;
                                { if the code is beyond preset codes then set to zero }
                                if C >= Slot then c := 0;
                                OldCode := C;
                                DecodeStack[sp] := C;           { output code to decoded stack }
                                inc(SP);                        { increment decode stack index }
                  end
                  else   { the code is not a clear code or an ending code so it must }
                  begin  { be a code code - so decode the code }
                                Code := C;
                                if Code < Slot then     { is the code in the table? }
                                begin
                                         DecodeCode(Code);                   { decode the code }
                                         if Slot <= TopSlot then begin       { add the new code to the table }
                                                  Suffix[Slot] := Code;           { make the suffix }
                                                  PreFix[slot] := OldCode;        { the previous code - a link to the data }
                                                  inc(Slot);                      { increment slot number }
                                                  OldCode := C;                   { set oldcode }
                                         end;
                                         if Slot >= TopSlot then { have reached the top slot for bit size }
                                         begin                   { increment code bit size }
                                                  if CurrCodeSize < 12 then { new bit size not too big? }
                                                  begin
                                                                 TopSlot := TopSlot shl 1;       { new top slot }
                                                                 inc(CurrCodeSize)               { new code size }
                                                  end
                                                  else
                                                                 Error(geBitSizeOverflow); { encoder made a boo boo }
                                         end;
                                end
                                else
                                begin           { the code is not in the table }
                                         if Code <> Slot then    { code is not the next available slot }
                                                        Error(geBadCode);  { so error out }

                                         { the code does not exist so make a new entry in the code table
                                          and then translate the new code }
                                         TempOldCode := OldCode;     { make a copy of the old code }
                                         while OldCode > HighCode do { translate the old code and place it }
                                         begin                                    { on the decode stack }
                                                        DecodeStack[SP] := Suffix[OldCode]; { do the suffix }
                                                        OldCode := Prefix[OldCode];         { get next prefix }
                                         end;
                                         DecodeStack[SP] := OldCode;     { put the code onto the decode stack }
                                                                         { but DO NOT increment stack index }
                                         { the decode stack is not incremented because because we are only
                                                translating the oldcode to get the first character }
                                         if Slot <= TopSlot then
                                         begin                             { make new code entry }
                                                        Suffix[Slot] := OldCode;     { first char of old code }
                                                        Prefix[Slot] := TempOldCode; { link to the old code prefix }
                                                        inc(Slot);                   { increment slot }
                                         end;
                                         if Slot >= TopSlot then { slot is too big }
                                         begin                   { increment code size }
                                                  if CurrCodeSize < 12 then begin
                                                                 TopSlot := TopSlot shl 1;{ new top slot }
                                                                 inc(CurrCodeSize){ new code size }
                                                  end
                                                  else
                                                                 Error(geBitSizeOverFlow);
                                         end;
                                         DecodeCode(Code); { now that the table entry exists decode it }
                                         OldCode := C;     { set the new old code }
                                end;
                  end;
                  { the decoded string is on the decode stack so pop it off and put it
                         into the line buffer }
                  while SP > 0 do begin
                                dec(SP);
                                LineBuffer[CurrBuf] := DecodeStack[SP];
                                inc(CurrBuf);
                                dec(BufCnt);
                                if BufCnt = 0 then begin { is the line full ? }
                                  DrawLine;
                                  CurrBuf := 0;
                                  BufCnt := ImageDescriptor.ImageWidth;
                                end;
                  end;
                  C := NextCode;  { get the next code and go at is some more }
         end;                { now that wasn't all that bad was it? }
end;



Procedure ConvertGIF(dst:VirtualScreen);
Begin
        with header do begin
                {safety check for correct GIF file}
                if Header.Signature <> 'GIF' then exit;
                if ImageDescriptor.ImageWidth > 320 then exit;
                if ImageDescriptor.ImageHeight > 240 then exit;
        end;
        destination:=pGifScreen(dst);
        Decode;
End;


Begin
        CurrentX := x;
        CurrentY := y;
        MeuX:=x;MeuY:=y;
        Init;
        ConvertGIF(scr);
End;


Procedure LoadGifFile;
var fis:file;
begin
  if Pos('.',FileName) = 0 then FileName := FileName + '.gif';
  Assign( Fis, FileName );
  {$I-}Reset( Fis, 1 );{$I+}
  if ioresult<>0 then begin
                        settext;
                        writeln(' Eroare de executie !');
                        writeln(' Fisierul '+FileName+' este inexistent');
                        halt(1);
                      end;
 LoadGIF(x,y,fis,scr,pal);
 Close(fis);
end;


end.

