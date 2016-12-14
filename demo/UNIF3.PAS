
{   Acesta este un program demonstrativ pentru procedura ChangeScreenPal   }
{   Scopul acestei proceduri este acela de a crea mai multe imagini cu o   }
{   singura paleta pentru a fi afisate simultan pe ecran                   }
{   Acest program afiseaza pe ecran 2 imagin cu o singura paleta           }
{   OBS : Imaginile NU sunt prelucrate anterior                            }

uses mcga,viewbmp;

var  scr1,scr2,scr3:virtualscreen;
     palu,pal1,pal2:palettetype;
     f:byte;

begin
  setmcga;
  print(12,12,'Asteptati putin !');
  setupvirtual(scr1);setupvirtual(scr2);setupvirtual(scr3);
  loadpal('..\mcga-img\uniform.pal',palu);

  loadscreen('..\mcga-img\screen1.scr',scr1);
  loadpal('..\mcga-img\paleta1.pal',pal1);
  print(14,8,'Se lucreaza la imaginea 1');
  changescreenpal(scr1,pal1,scr2,palu);

  loadscreen('..\mcga-img\screen2.scr',scr3);
  loadpal('..\mcga-img\paleta2.pal',pal2);
  print(14,8,'Se lucreaza la imaginea 2');
  changescreenpal(scr3,pal2,scr1,palu);

  setallpal(palu);
  for f:=0 to 159 do begin
    waitretrace;
    rescale(scr1,0,0,319,199,vgascreen,0,0,f,199);
    rescale(scr2,0,0,319,199,vgascreen,319-f,0,319,199);
  end;
  readln;

  shutdownvirtual(scr1);shutdownvirtual(scr2);shutdownvirtual(scr3);
  settext;
end.