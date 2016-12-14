Program demonstrativ;
uses mcga,crt;

VAR frame1,p1:  pointer;
    scr1     :  virtualscreen;
    paleta,p :  palettetype;


begin

getmem(frame1,30*48+3);
loadicon('..\mcga-img\frame1.icn',frame1);

setmcga;
  loadvisualpal('..\mcga-img\paleta.pal');
  putico(0,0,frame1);rectangle(0,0,48,30);
  getmem(p1,GetIcoSize(0,0,49,31));GetIco(0,0,49,31,p1);
  PutIco(100,100,p1);
  readln;
freemem(frame1,30*48+3);
freemem(p1,geticosize(0,0,49,31));
settext;
end.
