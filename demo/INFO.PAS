Program care_da_informatii_despre_SoundBlaster;
uses crt,adlib,SB;
begin
  clrscr;writeln;

  if not SB16Detect then
                      writeln(' Nu aveti SoundBlaster16')
                    else
                      begin
                        Writeln(' Aveti SoundBlaster16');
                        SbGetDSPVersion;SbGetCopyrightString;
                        writeln(' Versiune SB : '+sbversionstr);
                        writeln(' '+SbCopyright);
                      end;

  if not SBProDetect then writeln(' Nu aveti SoundBlasterPro')
                     else writeln(' Aveti SoundBlasterPro');

  if not AdlibExists then writeln(' Nu aveti Adlib')
                     else writeln(' Aveti Adlib')

end.
