Program demonstrativ_de_animatie;
uses mcga,crt;

VAR frame1,frame2,frame3 :  pointer;
    scr1,scr2,scr3       :  virtualscreen;
    paleta               :  palettetype;

begin

getmem(frame1,30*48+3);loadicon('..\mcga-img\frame1.icn',frame1); { Incarca iconurile de }
getmem(frame2,30*48+3);loadicon('..\mcga-img\frame2.icn',frame2); { pe disc in memorie   }
getmem(frame3,30*48+3);loadicon('..\mcga-img\frame3.icn',frame3);
loadpal ('..\mcga-img\paleta.pal',paleta);  { Incarca paleta de culori de pe disc        }

setmcga;                        { Initializeaza modul grafic 320x200x256     }
setallpal(paleta);
setupvirtual(scr1);             { Initializeaza screen-urile virtuale        }
setupvirtual(scr2);
setupvirtual(scr3);

setactivescreen(scr1);cls(0);
PutIco(100,100,frame1);         { Pune in fiecare screen cite un frame       }
PutIco(150,50,frame1);
PutIco(200,100,frame1);

setactivescreen(scr2);cls(0);
PutIco(100,100,frame2);         { Pune in fiecare screen cite un frame       }
PutIco(150,50,frame2);
PutIco(200,100,frame2);

setactivescreen(scr3);cls(0);
PutIco(100,100,frame3);         { Pune in fiecare screen cite un frame       }
PutIco(150,50,frame3);
PutIco(200,100,frame3);

repeat
  waitretrace;setvisualscreen(scr1);delay(50);  { Afiseaza screen-urile      }
  waitretrace;setvisualscreen(scr2);delay(50);  { virtuale unul dupa altul   }
  waitretrace;setvisualscreen(scr3);delay(50);
until keypressed;

shutdownvirtual(scr1);          { Elibereaza memoria ocupata de screen-urile }
shutdownvirtual(scr2);          { virtuale                                   }
shutdownvirtual(scr3);
freemem(frame1,30*48+3);        { Elibereaza memoria ocupata de iconuri      }
freemem(frame2,30*48+3);
freemem(frame3,30*48+3);
fadedown(0,0,0);                { Stinge paleta                              }
settext;                        { Revine in modul text                       }
end.