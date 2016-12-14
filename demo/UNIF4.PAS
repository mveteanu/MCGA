
{   Acesta este un program demonstrativ pentru procedura ChangeScreenPal   }
{   Scopul acestei proceduri este acela de a crea mai multe imagini cu o   }
{   singura paleta pentru a fi afisate simultan pe ecran                   }
{   Acest program afiseaza pe ecran 2 imagin cu o singura paleta           }
{   OBS : Imaginile au fost prelucrate anterior                            }

{$x+,r-,s-,d-,l-}
uses mcga,gif,crt,dos;
var    f                   : word;
       scr1,scr2           : virtualscreen;
       pal                 : palettetype;

begin
setmcga;setupvirtual(scr1);setupvirtual(scr2);
loadgiffile(0,0,'..\mcga-img\papaga.gif',scr1,pal);
loadgiffile(0,0,'..\mcga-img\pante.gif',scr2,pal);
setallpal(pal);

for f:=0 to 159 do begin
  waitretrace;
  rescale(scr1,0,0,319,199,vgascreen,0,0,f,199);
  rescale(scr2,0,0,319,199,vgascreen,319-f,0,319,199);
end;
readln;
shutdownvirtual(scr1);shutdownvirtual(scr2);
settext;
end.
