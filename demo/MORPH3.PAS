{$G+}
uses mcga,viewbmp,crt;


var  scr1,scr2,scr3,scr4:virtualscreen;
     pal,pal1,pal2:palettetype;
     f:file;
var  a,b:word;
Const finete : word = 40;

begin
  setmcga;
  loadfont('..\mcga-img\soft.fnt');
  setupvirtual(scr1);setupvirtual(scr2);
  setupvirtual(scr3);setupvirtual(scr4);
  setactivescreen(scr4);cls(0);outtextxy(5,100,2,'VMA SOFTWARE 1996');
  outtextxy(50,60,3,'DEMONSTRATIE');outtextxy(50,140,3,'DEMONSTRATIE');
  loadbmpfile(0,0,'..\mcga-img\plasma.bmp',scr1,pal1);
  setallpal(pal1);
  loadbmpfile(0,0,'..\mcga-img\2fc-vga.bmp',scr2,pal2);

  repeat

  for a:=0 to finete do begin
                      mediascreen(scr1,scr2,scr3,finete,finete-a,a);
                      screentranstransp(0,60,320,96,seg(scr3^),seg(scr4^));
                      mediapal(pal1,pal2,pal,finete,finete-a,a);
                      waitretrace;setallpal(pal);setvisualscreen(scr3);
                      if keypressed then break;
                    end;


  for a:=0 to finete do begin
                      mediascreen(scr2,scr1,scr3,finete,finete-a,a);
                      screentranstransp(0,60,320,96,seg(scr3^),seg(scr4^));
                      mediapal(pal2,pal1,pal,finete,finete-a,a);
                      waitretrace;setallpal(pal);setvisualscreen(scr3);
                      if keypressed then break;
                    end;

  until keypressed;

  fadedown(0,0,0);

  shutdownvirtual(scr1);shutdownvirtual(scr2);
  shutdownvirtual(scr3);shutdownvirtual(scr4);
  settext;
end.