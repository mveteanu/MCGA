{$A+,B-,D-,E-,F-,G+,I+,L-,N+,O-,P+,Q-,R-,S-,T-,V-,X+,Y-}

program MORPHING_1;
uses mcga,crt,
     adlib,playhsc;

var  scr1,scr2,scr3,scr4:virtualscreen;
     pal,pal1,pal2:palettetype;
     f:file;
var  a,b:word;
     l1,l2:longint;
Const finete : word = 40;

Const
  SBDet : boolean = false;
Var
  Music : HSC_obj;

begin
  setmcga;
  assign(f,'..\mcga-img\selectii.img');
  reset(f,1);

  loadfont('..\mcga-img\soft.fnt');
  setupvirtual(scr1);setupvirtual(scr2);
  setupvirtual(scr3);setupvirtual(scr4);
  setactivescreen(scr4);cls(0);outtextxy(5,100,2,'VMA SOFTWARE 1996');
  outtextxy(50,60,3,'DEMONSTRATIE');outtextxy(50,140,3,'DEMONSTRATIE');

  If AdlibExists then SBDet:=true;
  If SBDet then Music.Init(0);
  If SBDet and  Music.LoadFile ('..\mcga-img\EMPTYNES.HSC') then Music.Start;

  randomize;

  repeat

  l1:=64768*(round(random(17)));
  repeat l2:=64768*(round(random(17)));until l2<>l1;
  seek(f,l1);blockread(f,scr1^,64000);blockread(f,pal1,768);
  seek(f,l2);blockread(f,scr2^,64000);blockread(f,pal2,768);

  for a:=0 to finete do begin
                      mediascreen(scr1,scr2,scr3,finete,finete-a,a);
                      screentranstransp(0,60,320,96,seg(scr3^),seg(scr4^));
                      mediapal(pal1,pal2,pal,finete,finete-a,a);
                      waitretrace;setallpal(pal);setvisualscreen(scr3);
                      if keypressed then break;
                    end;

  for a:=0 to 255 do begin
                      rotatepal(pal,0,255);
                      WaitRetrace;
                      setallpal(pal);
                      if keypressed then break;
                    end;

  until keypressed;

  If SBDet then Music.Fade;
  fadedown(0,0,0);
  shutdownvirtual(scr1);shutdownvirtual(scr2);
  shutdownvirtual(scr3);shutdownvirtual(scr4);
  settext;
  If SBDet then Music.Done;
end.
