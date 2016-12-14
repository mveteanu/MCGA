uses mcga,crt;
const  screen        : string  = '..\mcga-img\screen3.scr';
       paleta        : string  = '..\mcga-img\paleta3.pal';
var    scr           : virtualscreen;
       pal           : palettetype;
       f:word;

begin
setmcga;
loadpal(paleta,pal);setallpal(pal);
loadscreen(screen,vgascreen);
repeat
 f:=0;
   repeat
     if keypressed then break;
     waitretrace;
     split(f);
     inc(f,3);
   until f>398;
 f:=400;
   repeat
     if keypressed then break;
     waitretrace;
     split(f);
     dec(f,3);
   until f<2;
until keypressed;
fadedown(0,0,0);
settext;
end.
