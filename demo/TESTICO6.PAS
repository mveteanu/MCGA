Program Demo_cu_frameuri;
uses MCGA,ViewBMP,Mouse,Crt;
var scr1 : VirtualScreen;
    x,y,i: integer;
    p    : pointer;
    pal  : PaletteType;
    mar  : word;

begin
  SetMcga;
  SetUpVirtual(scr1);
  LoadBMPFile(0,0,'..\mcga-img\AMBER.BMP',scr1,pal);
  SetAllPal(pal);
  initmouse;
  setarea(90,40,560,160);
  mar:=geticosize(0,0,90,90);
  SetVisualScreen(scr1);showmouse;
  repeat
   x:=mousex div 2;y:=mousey;
   getmem(p,mar);
   setactivescreen(scr1);getico(x-40,y-40,x+40,y+40,p);
   setactivescreen(vgascreen);
   putframe(0,0,p);putframe(240,0,p);
   putframe(0,120,p);putframe(240,120,p);
   freemem(p,mar);
  until leftpressed;
  hidemouse;
  for i:=1 to 50 do
  begin
    waitretrace;
    rescale(scr1,0,0,319,199,vgascreen,160-i*16 div 10,100-i,160+i*16 div 10,100+i);
  end;
  fadedown(0,0,0);
  ShutDownVirtual(scr1);
  SetText;
end.
