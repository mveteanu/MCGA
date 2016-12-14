{
    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ³        Acesta este un unit care vine in ajutorul celor care        ³
    ³      doresc sa foloseasca memoria expandata in programele lor      ³
    ³                         (c) VMA soft 1996                          ³
    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
}

Unit EMS;
interface
Type
 ST3  = string[3];
 ST80 = string[80];
 ST5  = string[5];
Const
 STATUS_OK = 0;

Function  Hex_String (Number: Integer): ST5;
Function  EmmInstalled: Boolean;
Function  EMMPagesAvailable(Var Total_EMM_Pages, Pages_Available: Integer): Integer;
Function  AllocateEMSPages(Pages_Needed: Integer; Var Handle: Integer): Integer;
Function  MapEMSPages(Handle, Logical_Page, Physical_Page: Integer): Integer;
Function  GetPageAddress(Var Page_Frame_Address: Integer): Integer;
Function  DeallocateEMSPages(Handle: Integer): Integer;
Function  GetVersionNumber (Var Version_String: ST3): Integer;
Procedure Error (Error_Message: ST80; Error_Number: Integer);


implementation
uses dos;
          Const
            EMM_INT                    = $67;
            DOS_Int                    = $21;
            GET_PAGE_FRAME             = $41;
            GET_UNALLOCATED_PAGE_COUNT = $42;
            ALLOCATE_PAGES             = $43;
            MAP_PAGES                  = $44;
            DEALLOCATE_PAGES           = $45;
            GET_VERSION                = $46;


            Function Hex_String (Number: Integer): ST5;
              Function Hex_Char (Number: Integer): Char;
                Begin
                  If Number < 10 then
                    Hex_Char := Char (Number + 48)
                  else
                    Hex_Char := Char (Number + 55);
                end;

            Var
              S: ST5;

            Begin
              S := '';
              S := Hex_Char ((Number shr 1) div 2048);
              Number := (((Number shr 1) mod 2048) shl 1) + (Number and 1);
              S := S + Hex_Char (Number div 256);
              Number := Number mod 256;
              S := S + Hex_Char (Number div 16);
              Number := Number mod 16;
              S := S + Hex_Char (Number);
              Hex_String := S + 'h';
            end;


            Function EmmInstalled: Boolean;
              Var
                Emm_Device_Name   : string[8];
                Int_67_Device_Name: string[8];
                Position          : integer;
                Regs              : Registers;

              Begin
                Int_67_Device_Name := '';
                Emm_Device_Name    := 'EMMXXXX0';
                with Regs do
                  Begin
                    AH := $35;
                    AL := EMM_INT;
                    Intr (DOS_Int, Regs);
                    For Position := 0 to 7 do
                      Int_67_Device_Name :=
                        Int_67_Device_Name + Chr (mem[ES:Position + $0A]);
                    EmmInstalled := True;
                    If Int_67_Device_Name <> Emm_Device_Name
                      then EmmInstalled := False;
                  end;
              end;


            Function EMMPagesAvailable
              (Var Total_EMM_Pages, Pages_Available: Integer): Integer;
              Var
                Regs: Registers;

              Begin
                with Regs do
                  Begin
                    AH := GET_UNALLOCATED_PAGE_COUNT;
                    Intr (EMM_INT, Regs);
                    Pages_Available := BX;
                    Total_EMM_Pages := DX;
                    EMMPagesAvailable := AH;
                  end;
              end;

            Function AllocateEMSPages
              (Pages_Needed: Integer; Var Handle: Integer): Integer;
              Var
                Regs: Registers;
              Begin
                with Regs do
                  Begin
                    AH := ALLOCATE_PAGES;
                    BX := Pages_Needed;
                    Intr (EMM_INT, Regs);
                    Handle := DX;
                    AllocateEMSPages := AH;
                  end;
              end;

            Function MapEMSPages
              (Handle, Logical_Page, Physical_Page: Integer): Integer;
              Var
                Regs: Registers;

              Begin
                with Regs do
                  Begin
                    AH := MAP_PAGES;
                    DX := Handle;
                    BX := Logical_Page;
                    AL := Physical_Page;
                    Intr (EMM_INT, Regs);
                    MapEMSPages := AH;
                  end;
              end;

            Function GetPageAddress
              (Var Page_Frame_Address: Integer): Integer;
              Var
                Regs: Registers;

              Begin
                with Regs do
                  Begin
                    AH := GET_PAGE_FRAME;
                    Intr (EMM_INT, Regs);
                    Page_Frame_Address := BX;
                    GetPageAddress := AH;
                  end;
              end;

            Function DeallocateEMSPages
              (Handle: Integer): Integer;
              Var
                Regs: Registers;
              Begin
                with Regs do
                  Begin
                    AH := DEALLOCATE_PAGES;
                    DX := Handle;
                    Intr (EMM_INT, Regs);
                    DeallocateEMSPages := AH;
                  end;
              end;

            Function GetVersionNumber (Var Version_String: ST3): Integer;
              Var
                Regs: Registers;
                Integer_Part, Fractional_Part: Char;

              Begin
                with Regs do
                  Begin
                    AH := GET_VERSION;
                    Intr (EMM_INT, Regs);
                    If AH=STATUS_OK then
                      Begin
                        Integer_Part    := Char (AL shr 4  + 48);
                        Fractional_Part := Char (AL and $F + 48);
                        Version_String  := Integer_Part + '.' +
                                                          Fractional_Part;
                      end;
                    GetVersionNumber := AH;
                  end;
              end;

            Procedure Error (Error_Message: ST80; Error_Number: Integer);
              Begin
                Writeln (Error_Message);
                Writeln ('Error_Number = ', Hex_String (Error_Number));
                Writeln ('Program aborting.');
                Halt (1);
              end;


end.