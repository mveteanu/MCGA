Program demonstrativ_de_animatie;
uses mcga,gif,crt;

VAR frame1,frame2,frame3 :  pointer;
    scr1,scr2,scr3       :  virtualscreen;
    pal                  :  palettetype;

begin

setmcga;
setupvirtual(scr1);setactivescreen(scr1);cls(0);
setupvirtual(scr2);setactivescreen(scr2);cls(0);

loadgiffile(10,50,'..\mcga-img\m1.gif',scr1,pal);
loadgiffile(10,50,'..\mcga-img\m2.gif',scr2,pal);
setallpal(pal);

repeat
  waitretrace;setvisualscreen(scr1);delay(100);
  waitretrace;setvisualscreen(scr2);delay(100);
until keypressed;

shutdownvirtual(scr1);
shutdownvirtual(scr2);
fadedown(0,0,0);
settext;
end.