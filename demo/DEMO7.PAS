uses mcga,crt;
var a:byte;
    scr,scr2,scr3:virtualscreen;
begin
setmcga;
loadfont('..\mcga-img\soft.fnt');
loadvisualpal('..\mcga-img\paleta1.pal');
setupvirtual(scr);setupvirtual(scr2);setupvirtual(scr3);
LoadScreen('..\mcga-img\screen1.scr',scr2);Flip(seg(scr2^),seg(scr^));
SetVisualScreen(scr2);

 SetScroll(50+20,260-20,100-50,1,false,'MA NUMESC MARIAN VETEANU   ');

 SetScroll(50+20,260-19,130-50,1,true,
   'ACEST PROGRAM ESTE REALIZAT DE MARIAN VETEANU DE LA VMA SOFT 1996 !  '+
   'DACA DORITI SA REALIZATI ASEMENEA EFECTE FOLOSITI UNITUL PASCAL MCGA '+
   'REALIZAT DE VETEANU MARIAN ADRIAN            ');

 SetScroll(50+20,260-20,160-50,1,false,'CUMPARATI PRODUSELE FIRMEI VMA SOFT   ');

 SetActiveScreen(scr3);CLS(0);

  repeat
    ScreenTrans(72,50,170,80,ScreenAddr(scr),ScreenAddr(scr2));
    SHRTextOnce(1);
    SHLTextOnce(2);
    SHRTextOnce(3);
    ScreenTransTransp(72,50,170,80,ScreenAddr(scr),ScreenAddr(scr3));
    WaitRetrace;
    ScreenTrans(72,50,170,80,$A000,ScreenAddr(scr));
  until keypressed;

freefont;
fadedown(0,0,0);
ShutDownVirtual(scr);
ShutDownVirtual(scr2);
ShutDownVirtual(scr3);
settext;
end.
