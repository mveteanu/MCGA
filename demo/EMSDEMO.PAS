          Program EMS_Demo;
          Uses Ems,Crt;

          Const
            APPLICATION_PAGE_COUNT = 1;
          Var
            Emm_handle,
            Page_Frame_Base_Address,
            Pages_Needed,
            Physical_Page,
            Logical_Page,
            Offset,
            Error_Code,
            Pages_EMM_Available,
            Total_EMM_Pages,
            Available_EMM_Pages: Integer;
            Version_Number,
            Pages_Number_String: ST3;
            Verify: Boolean;



          Begin
            ClrScr;
            Window (5,2,77,22);
            If not (EmmInstalled) then
              Begin
                Writeln ('LIM EMM ne este instalat.');
                Halt (1);
              end
            else
              Begin
                Error_Code   := GetVersionNumber(Version_Number);
                If Error_Code <> STATUS_OK then
                  Error ('Eroare la  obtinerea versiunii EMM.', Error_Code)
                else
                  Writeln ('LIM Expanded Memory Manager, versiunea ',
                           Version_Number, ' este gata de folosire.');
              end;
            Writeln;
            Pages_Needed := APPLICATION_PAGE_COUNT;
            Error_Code   := EMMPagesAvailable (Total_EMM_Pages,
                                                 Available_EMM_Pages);
            If Error_Code <> STATUS_OK then
              Error ('Eroare la determinarea paginilor EMM disponibile.',
                     Error_Code);
            Writeln ('Sunt in total  ', Total_EMM_Pages,
                     ' pagini de memorie expandata prezente in sistem.');
            Writeln ('  ', Available_EMM_Pages,
                     ' dintre acestea sunt disponibile pentru folosire.');
            Writeln;
            If Pages_Needed > Available_EMM_Pages then
              Begin
                Str (Pages_Needed, Pages_Number_String);
                Error ('Avem nevoie de ' + Pages_Number_String +
                       ' pagini EMS si nu sunt atitea disponibile  .',
                       Error_Code);
              end;

            Error_Code :=
              AllocateEMSPages (Pages_Needed, Emm_Handle);
            Str (Pages_Needed, Pages_Number_String);
            If Error_Code <> STATUS_OK then
              Error ('Programul de test EMM a esuat in alocarea a '
                     + Pages_Number_String
                     + ' de pagini pentru folosire.', Error_Code);
            Writeln (APPLICATION_PAGE_COUNT,
                     ' de pagini EMM alocate de programul de test.');
            Writeln;

            Logical_Page  := 0;
            Physical_Page := 0;
            Error_Code := MapEMSPages (Emm_Handle,
                                                     Logical_Page,
                                                     Physical_Page);
            If Error_Code <> STATUS_OK then
              Error ('Programul de test a esuat in incercarea '
                     + 'de a mapa paginile logice in cele fizice.',
                     Error_Code);

            Writeln ('Pagina logica ',
                     Logical_Page,
                     ' mapata cu succes in pagina fizica ',
                     Physical_Page);
            Writeln;

            Error_Code := GetPageAddress
                            (Page_Frame_Base_Address);
            If Error_Code <> STATUS_OK then
              Error ('EMM test program unable to get the base Page'
                     + ' Frame Address.',
                     Error_Code);
            Writeln ('Adresa paginii EMM este = '
                     + Hex_String (Page_Frame_Base_Address));
            Writeln;

            For Offset := 0 to 16382 do
              Begin
                Mem[Page_Frame_Base_Address:Offset] := Offset mod 256;
              end;

            Writeln ('Testeaza memoria EMM .');

            Offset := 1;
            Verify := True;
            while (Offset <= 16382) and (Verify = True) do
              Begin
                If Mem[Page_Frame_Base_Address:Offset] <> Offset mod 256
                  then Verify := False;
                Offset := Succ (Offset);
              end;

            If not Verify then
              Error ('Ce s-a scris in EMM nu s-a mai gasit dupa'
                     + ' testul de verificare.',
                     0);
            Writeln ('Testul de memorie EMM s-a incheiat cu succes.');
            Writeln;

            Error_Code := DeallocateEMSPages (Emm_Handle);
            If Error_Code <> STATUS_OK then
              Error ('Programul de test nu mai poate sa elibereze paginile '
                     + 'de EMM folosite.',
                     Error_Code);
            Writeln (APPLICATION_PAGE_COUNT,
                     ' pages(s) deallocated.');
            Writeln;
            Writeln ('Programul de test EMM este complet.');

          end.

