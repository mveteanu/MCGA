uses mcga;
var  pal1:palettetype;
     f:word;ima:text;a:byte;

begin
  if (paramcount=0) or (not fileexist(paramstr(1))) then
      begin
         writeln;writeln('--- Sintaxa : VIEWTBL FILE.TBL ---');
         writeln('    (c) VMA soft');
         halt(1);
       end;
  setmcga;
  createbwpal(pal1);setallpal(pal1);

  assign(ima,paramstr(1));reset(ima);
  for f:=0 to 63999 do
   begin
    read(ima,a);
    linear(vgascreen^)[f]:=a;
   end;
  close(ima);

  readln;
  settext;
end.

