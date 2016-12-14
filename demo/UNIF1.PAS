
{   Acesta este un program demonstrativ pentru procedura ChangeScreenPal   }
{   Scopul acestei proceduri este acela de a crea mai multe imagini cu o   }
{   singura paleta pentru a fi afisate simultan pe ecran. In acest scop se }
{   foloseste o paleta uniforma de culori.                                 }

uses mcga,viewbmp;

var  scr1:virtualscreen;
     pal1,pal2:palettetype;

begin
  setmcga;
  setupvirtual(scr1);

  loadscreen('..\mcga-img\screen1.scr',scr1);
  loadpal('..\mcga-img\paleta1.pal',pal1);
  setvisualscreen(scr1);

  loadpal('..\mcga-img\uniform.pal',pal2);
  setallpal(pal2);
  changescreenpal(scr1,pal1,vgascreen,pal2);
  readln;

  shutdownvirtual(scr1);
  settext;
end.