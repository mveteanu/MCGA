
{   Acesta este un program demonstrativ pentru procedura ChangeScreenPal   }
{   Scopul acestei proceduri este acela de a crea mai multe imagini cu o   }
{   singura paleta pentru a fi afisate simultan pe ecran                   }
{   La inceput se va fisa o imagine lasand paleta de culori neschimbata    }
{   asa cum este ea la setarea modului grafic, apoi se va incerca cautarea }
{   in aceasta paleta a unor culori cat mai apropiate de cele ale paletei  }
{   imaginii.Observati modul in care se aproximeaza culorile !             }

uses mcga,viewbmp;

var  scr1:virtualscreen;
     pal1,pal2:palettetype;

begin
  setmcga;
  setupvirtual(scr1);

  loadscreen('..\mcga-img\screen3.scr',scr1);
  loadpal('..\mcga-img\paleta3.pal',pal1);
  setvisualscreen(scr1);readln;

  getallpal(pal2);
  changescreenpal(scr1,pal1,vgascreen,pal2);
  readln;

  shutdownvirtual(scr1);
  settext;
end.