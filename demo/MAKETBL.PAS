uses dos,mcga,gif;
var  scr1,scr2:virtualscreen;
     pal1,pal2:palettetype;
     f:word;ima:text;
     view:boolean;
     tabela:boolean;
var
     P: PathStr;
     D: DirStr;
     N: NameStr;
     E: ExtStr;

procedure aflaparam;
begin
  if paramcount=0 then
       begin
         writeln;writeln('--- Sintaxa : MAKETBL FILE.GIF [/V] [/T] ---');
         writeln('    (c) VMA soft');
         halt(1);
       end;
  for f:=1 to paramcount do begin
  If ((paramstr(f)='/v') or (paramstr(f)='/V') or (paramstr(f)='/view')or (paramstr(f)='/VIEW')) then view:=true;
  If ((paramstr(f)='/t') or (paramstr(f)='/T') or (paramstr(f)='/table')or (paramstr(f)='/tabela')) then tabela:=true;
  If copy (paramstr(f),1,1)<>'/' then p:=paramstr(f);FSplit(P, D, N, E);
  end;
end;

procedure scrie1(var fis:text;scr:virtualscreen);
var f:word;begin for f:=0 to 63999 do writeln(fis,linear(scr^)[f]);end;


procedure scrie2(var fis:text;scr:virtualscreen);
var i,j:word;
begin
 for i:=0 to 199 do
  begin for j:=0 to 319 do write(fis,scr^[i,j],' ');writeln(fis);end;
end;

begin
  view:=false;tabela:=false;
  aflaparam;
  setupvirtual(scr1);setupvirtual(scr2);
  loadgiffile(0,0,n+e,scr1,pal1);

if view then begin
  setmcga;setallpal(pal1);setvisualscreen(scr1);
  setcolor(255);print(23,11,'Apasati o tasta');
end;

  createbwpal(pal2);
  createbwscreen(scr1,pal1,scr2);

if view then begin
  readln;
  setallpal(pal2);setvisualscreen(scr2);
end;

  assign(ima,n+'.tbl');rewrite(ima);
  if tabela then scrie2(ima,scr2) else scrie1(ima,scr2);
  close(ima);

  shutdownvirtual(scr1);
  shutdownvirtual(scr2);
  if view then settext;
end.

