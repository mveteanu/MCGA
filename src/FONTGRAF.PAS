Unit fontgraf;
{$I-}
interface
 uses dos;
 procedure cod_eroare;
 procedure SetSize(factor:word);
 procedure SetAngle(ung:integer);
 procedure SetMirror(mirror:boolean);
 procedure SetItalic(italic:boolean);
 procedure LoadFont(fontnumber:word; dir:string);
 procedure TextToScreen(sir:string);
 procedure TextToScreenXY(x,y:integer; sir:string);
implementation
 uses math,graph;
 type
     tipfont = record
                  nume:string[8];
                  marime, ofset, adresachr:word;
                  constanta:byte;
                end;
 const
    fontini: array [1..10] of tipfont = (
(nume:'TRIP.CHR'; marime:16677; ofset:$92; adresachr:$32d; constanta:66),
(nume:'LITT.CHR'; marime:5131;  ofset:$92; adresachr:$32d; constanta:66),
(nume:'SANS.CHR'; marime:13596; ofset:$b0; adresachr:$38a; constanta:34),
(nume:'GOTH.CHR'; marime:18063; ofset:$92; adresachr:$32d; constanta:66),
(nume:'SCRI.CHR'; marime:10987; ofset:$92; adresachr:$32d; constanta:66),
(nume:'BOLD.CHR'; marime:14670; ofset:$92; adresachr:$330; constanta:66),
(nume:'EURO.CHR'; marime:8439;  ofset:$92; adresachr:$32d; constanta:66),
(nume:'LCOM.CHR'; marime:12083; ofset:$92; adresachr:$32d; constanta:66),
(nume:'SIMP.CHR'; marime:8437;  ofset:$92; adresachr:$32d; constanta:66),
(nume:'TSCR.CHR'; marime:17355; ofset:$92; adresachr:$32d; constanta:66));
{ofset este deplasarea in fisierul fontului la care incepe tabela de
 deplasari ale caracterelor iar adresachr este deplasarea in fisierul
 fontului la care incepe descrierea caracterelor}
var minfont, maxfont, currentfont, scale:byte;
    mod_setat,ind_italic:boolean;
    errorind,theta : integer;
    pfont:pointer; {Variabila indica spre adresa la care se incarca fisierul fontului curent}
    base_segment,adresaofs,adr,o:word; {segmente si offseturi}
    cursorx,cursory :integer; {Coordonatele CP}
    st,ct:lookuptable;


procedure rotatie(xcentru,ycentru,xini,yini:integer; unghi:integer; var x,y:integer);
{(xcentru,ycentru) = coordonatele centrului de rotatie;
 (xini,yini) = punctul initial;
 (x,y) = coordonatele punctului dupa rotire; unghi = unghiul de rotatie}
var razax,razay:integer;
begin
 razax:=xini-xcentru; razay:=ycentru-yini;
 unghi:=abs(unghi) mod 360;
 if (razax=0) and (razay=0) then
    begin
      x:=xini;
      y:=yini
    end
     else
    begin
      x:=round(xcentru+razax*ct^[unghi]-razay*st^[unghi]);
      y:=round(ycentru-razay*ct^[unghi]-razax*st^[unghi]);
    end;
end;

procedure rotatie_italic(xc,yc,xi,yi:integer; var x:integer);
var unghi:integer;
begin
 unghi:=abs((330+theta)) mod 360;
 if (yc-yi)<>0 then x:=round(xc+(xi-xc)*ct^[unghi]-(yc-yi)*st^[unghi]);
end;

procedure cod_eroare;
var s:string[45];
begin
  if errorind>0 then
    begin
      case errorind of
        0 : s:='Nici o eroare';
        1 : s:='Numar gresit de font';
        2 : s:='Cale invalida pentru fisierul de font';
        3 : s:='Eroare la incarcarea fisierului de font';
        4 : s:='N-a fost ales vreun font';
      end;
      writeln; writeln(errorind,': ',s);
    end;
end;

procedure SetSize(factor:word);
begin
  if errorind <> 0 then exit;
  scale:= factor;
end;

procedure SetAngle(ung:integer);
begin
  if errorind<>0 then exit;
  if ung>360 then
     theta:=ung mod 360
         else
     theta:=ung;
end;

procedure SetMirror(mirror:boolean);
begin
 if errorind<>0 then exit;
 mod_setat:=mirror;
end;

procedure SetItalic(italic:boolean);
begin
 if errorind>0 then exit;
 ind_italic:=italic;
end;

procedure LoadFont(fontnumber: word; dir: string);
{alege si incarca fontul; stabileste adresa sb:oab a tabelei de deplasari
 si adresa sb:ocb a tabelei de caractere}
 var calefont: string; fontfile:file;
 begin
   if errorind<>0 then exit;
   if (fontnumber<minfont) or (fontnumber>maxfont) then
     begin
       errorind:= 1;
       exit;
     end;
   if currentfont<>0 then freemem(pfont,fontini[currentfont].marime);
   currentfont:=fontnumber;
   with fontini[currentfont] do
      begin
         calefont:= fexpand(dir);
         if calefont[length(calefont)] <> '\' then
              calefont:= calefont+'\';
          calefont:= calefont + nume;
          assign(fontfile,calefont); reset(fontfile,1);
          if ioresult <> 0 then
             begin
               errorind:= 2;
               exit;
             end;
           getmem(pfont,marime);
           blockread(fontfile, pfont^, marime);
           if ioresult <> 0 then
              begin
                errorind:= 3;
                exit;
              end;
           base_segment:= seg(pfont^);
           adresaofs:=ofs(pfont^) + ofset; adr:=ofs(pfont^) + adresachr;
        end;
end;

procedure initial(c:char; var coordx,coordy:byte);
{gaseste prima pereche de coordonate comenzi pentru un caracter dat}
var con:byte;
begin
  if adresaofs+adr = 0 then
    begin
       errorind:= 4;
       exit;
    end;
    con:=fontini[currentfont].constanta;
    o:=adr+memw[base_segment:adresaofs + 2*ord(c) - con];
    coordx:=mem[base_segment:o];
    coordy:=mem[base_segment:o+1];
    o:=o+2;
end;

procedure urmator(var cx,cy:byte);
{gaseste urmatoarea pereche de coordonate}
begin
  cx:=mem[base_segment:o];
  cy:=mem[base_segment:o+1];
  o:=o+2;
end;

procedure interpretare(cx,cy:byte; var x,y:integer; var creion:byte);
{Descompune cx,cy in coordonate si comanda pentru creion}
var x1,y1,ytemp : integer;
begin
 x1:=cursorx + round((cx and $7f)*scale/4);
 creion:=cy shr 7;
 ytemp:=round((shortint(cy shl 1) shr 1)*scale/4);
 if not mod_setat then
      y1:=cursory - ytemp
          else
      y1:=cursory + ytemp;
 if theta=0 then
    begin x:=x1; y:=y1; end
       else
    rotatie(cursorx,cursory,x1,y1,theta,x,y);
 if ind_italic then
    rotatie_italic(cursorx,cursory,x1,y1,x);
end;

procedure texttoscreen(sir:string);
{afiseaza sirul s la pozitia CP; directia e data de theta}
var
   penita:byte;
   contor,maxim:byte;
   punctx,puncty:byte; x,y:integer;
begin
  if errorind <> 0 then exit;
  maxim:=length(sir); contor:=1;
  while contor<=maxim do
    begin
      cursorx:=getx; cursory:=gety;
      initial(sir[contor],punctx,puncty);
      while punctx+puncty<>0 do
        begin
          interpretare(punctx,puncty,x,y,penita);
          if penita=0 then moveto(x,y) else lineto(x,y);
          urmator(punctx,puncty);
        end;
        inc(contor);
    end;
end;

procedure texttoscreenxy(x,y:integer; sir:string);
{afiseaza sirul s la pozitia x,y}
begin
  if errorind<>0 then exit;
  moveto(x,y);
  texttoscreen(sir);
end;

begin
 pfont:=nil;
 minfont:=1;
 maxfont:=10;
 currentfont:=0;
 scale:=4;
 theta:=0;
 mod_setat:=false;
 ind_italic:=false;
 errorind:=0;
 CreateSINTable(st,1,1,0);
 CreateCOSTable(ct,1,1,0);
end.
