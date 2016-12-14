{$x+,r-,s+,d-,l-}
uses mcga,crt,dos;
const  screen        : string  = '..\mcga-img\screen2.scr';
       paleta        : string  = '..\mcga-img\paleta2.pal';
var    a             : byte;
       scr           : virtualscreen;
       pal           : palettetype;

{$f+}
Procedure Sunet;
begin
  if keypressed then ScrollBreak:=true;
end;
{$f-}

procedure AsteaptaOTasta;
const
  Esc = #27;
var
  Ch : char;
begin
  repeat until KeyPressed;
  Ch := ReadKey;
  if ch = #0 then ch := readkey;
  if Ch = Esc then
    begin settext;Halt(0);end;
end;

procedure SareInDirector;
 var nume           : namestr;
     extensie       : extstr;
     catalog        : dirstr;
 begin
   fsplit(fexpand(paramstr(0)),catalog,nume,extensie);
   if nume<>'DEMO1' then
         begin
           writeln('   Programul nu functioneaza decit cu numele DEMO.EXE');
           halt(1);
         end;
   delete(catalog,length(catalog),1);
   chdir(catalog);
 end;

begin
if (paramstr(1)='/autor') or (paramstr(1)='/?') or (paramstr(1)='/help') then
  begin
     clrscr;
     textcolor(yellow);
     writeln('           ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
     writeln('           ³ Autorul acestui program este Marian Veteanu   ³');
     write  ('           ³');
     textcolor(lightred);
     write('                (c) VMA soft 1996              ');
     textcolor(yellow);
     writeln('³');
     writeln('           ³                                               ³');
     writeln('           ³ Sintaxa : DEMO [/1] sau                       ³');
     writeln('           ³           DEMO [/2] sau                       ³');
     writeln('           ³           DEMO [/3] sau                       ³');
     writeln('           ³           DEMO [/?]                           ³');
     writeln('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
     halt(0);
  end;
if paramstr(1)='/1'then begin screen:='screen1.scr';paleta:='paleta1.pal';end;
if paramstr(1)='/2'then begin screen:='screen2.scr';paleta:='paleta2.pal';end;
if paramstr(1)='/3'then begin screen:='screen3.scr';paleta:='paleta3.pal';end;

sareindirector;
setmcga;setupvirtual(scr);
loadfont('..\mcga-img\soft.fnt');
setactivescreen(scr);
loadscreen(screen,scr);loadpal(paleta,pal);setallpal(pal);
  SetScrollStyle(0,1,true);
  ScrollProc:=sunet;
  setvisualscreen(scr);
  setactivescreen(vgascreen);
rectangle(52,157,268,179);
outtextxy(30,100,5,'VMA SOFT 1996');
for a:=1 to 108 do begin
                     waitretrace;
                     shlbox(53,158,160,179,0);
                     shrbox(160,158,267,179,0);
                   end;
  a:=2;
  repeat
   SHLText(55,265,160,
   'ACEST PROGRAM ESTE REALIZAT DE MARIAN VETEANU DE LA VMA SOFT 1996 !  '+
   'DACA DORITI SA REALIZATI ASEMENEA EFECTE FOLOSITI UNITUL PASCAL MCGA '+
   'REALIZAT DE VETEANU MARIAN ADRIAN         ');
  dec (a);
  until keypressed or (a=0);
freefont;
fadedown(0,0,0);
setvisualscreen(scr);fadeup(pal);
setcolor(236);print(2,10,'Apelati cu incredere');
          print(4,05,'la serviciile oferite de firma');
          print(6,12,'V M A   s o f t');
setcolor(210);print(10,02,#16' executie de programe la comanda;');
              print(12,02,#16' consultanta in domeniul hardware');
              print(13,04,'si software: programare & utilizare;');
              print(15,02,#16' vinzari de programe utilitare si');
              print(16,04,'de documentatii;');
              print(18,02,#16' asistenta tehnica pentru produsele');
              print(19,04,'cumparate de clienti');
AsteaptaOTasta;AsteaptaOTasta;
fadedown(0,0,0);
shutdownvirtual(scr);
settext;
end.
