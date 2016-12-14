Program
  trei_metode_de_a_pune_un_pixel_pe_ecran_sau_oricare_alt_screen_virtual;
uses mcga;
begin
setmcga;

  PutPixel(160,50,15);           { Screen-ul este vazut in mod obisnuit    }
  VGAScreen^[150,80]:=15;        { Screen-ul este vazut ca o matrice       }
  Linear(VGAScreen^)[48240]:=15; { Screen-ul este vazut linear             }

readln;
settext;
end.
