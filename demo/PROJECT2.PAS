uses MCGA,crt,viewbmp;
var f    : file;
    scr  : VirtualScreen;
    scr3 : VirtualScreen;
    pal  : PaletteType;
    size : word;
    imag : pointer;
    x,y  : integer;
    px,py: integer;

begin
  SetMcga;
  SetUpVirtual(scr);SetUpVirtual(scr3);
  LoadFont('..\mcga-img\soft.fnt');

  SetActiveScreen(Scr);
  Size:=GetIcoSize(90,40,230,160);
  LoadQuickBMPFile('..\mcga-img\2FC-VGA.BMP',scr,pal);SetAllPal(pal);
  Outtextxy(40,60,5,'VMA SOFT 1996');
  Outtextxy(15,130,5,'MARIAN VETEANU');
  Outtextxy(115,95,5,'DEMO');
  SetVisualScreen(scr);

  SetActiveScreen(scr3);Cls(0);
  SphericalProjection(scr,scr3,60);
  GetMem(imag,size);GetIco(90,40,230,160,imag);
  Flip(seg(scr^),seg(scr3^));

 x:=4;y:=4;
repeat
 setactivescreen(scr3);
 putico(x,y,imag);
 inc(x,px);inc(y,py);
 if x>170 then px:=-2;
 if y>70 then py:=-2;
 if x<6 then px:=2;
 if y<6 then py:=2;
 waitretrace;
 rotatepal(pal,1,255);setallpal(pal);
 quickscreentrans(x-4,y-4,148,128,$A000,seg(scr3^));
 quickscreentrans(x-4,y-4,148,128,seg(scr3^),seg(scr^));
until keypressed;

  ShutDownVirtual(scr);ShutDownVirtual(scr3);
  SetText;
end.