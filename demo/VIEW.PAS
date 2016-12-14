{$G+,X+,R-,F-,S-,D-,L-}
uses crt,mcga,viewbmp;
var scr:virtualscreen;
    pal:palettetype;
begin
    if paramcount=1
    then
    begin
     setmcga;
     setupvirtual(scr);
     print(12,12,'Asteptati putin !');
     setactivescreen(scr);cls(0);
     loadbmpfile(0,0,paramstr(1),scr,pal);
     waitretrace;setallpal(pal);
     waitretrace;setvisualscreen(scr);
     if readkey='s' then begin
                            savescreen('screen.scr',scr);
                            savepal('paleta.pal',pal);
                         end;
     fadedown(0,0,0);settext;
     Writeln(' Viewer by VMA soft');
     shutdownvirtual(scr);
    end
    else
    writeln(' Folosire : VIEW IMAGINE.BMP');
end.