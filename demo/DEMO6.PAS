uses mcga,crt;
var a:byte;
    scr:virtualscreen;
begin
setmcga;
loadfont('..\mcga-img\soft.fnt');
loadvisualpal('..\mcga-img\pallette.pal');
setupvirtual(scr);


 SetScroll(50+20,260-20,100-50,1,false,'MA NUMESC MARIAN VETEANU   ');

 SetScroll(50+20,260-19,130-50,1,true,
   'ACEST PROGRAM ESTE REALIZAT DE MARIAN VETEANU DE LA VMA SOFT 1996 !  '+
   'DACA DORITI SA REALIZATI ASEMENEA EFECTE FOLOSITI UNITUL PASCAL MCGA '+
   'REALIZAT DE VETEANU MARIAN ADRIAN            ');

 SetScroll(50+20,260-20,160-50,1,false,'CUMPARATI PRODUSELE FIRMEI VMA SOFT   ');

 rectangle(70,45,242,130);

 setactivescreen(scr);cls(0);

  repeat
    SHRTextOnce(1);
    SHLTextOnce(2);
    SHRTextOnce(3);
    WaitRetrace;
    ScreenTrans(72,50,170,80,$A000,ScreenAddr(scr));
  until keypressed;

freefont;
fadedown(0,0,0);
ShutDownVirtual(scr);
settext;
end.
