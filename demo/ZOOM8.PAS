{$g+,x+}
uses mcga,viewbmp,crt;
var pal:palettetype;
    scr,scr2,scr3,scr4:virtualscreen;

var i:word;
begin
 SetMcga;
 loadfont('..\mcga-img\soft.fnt');
 SetUpVirtual(scr);SetUpVirtual(scr2);SetUpVirtual(scr3);SetUpVirtual(scr4);
 SetActiveScreen(scr2);cls(0);
 outtextxy(30,50,5,'VMA SOFT 1996');
 outtextxy(20,90,5,'MARIAN VETEANU');
 outtextxy(40,130,5,'DEMONSTRATIE');

 SetActiveScreen(scr3);cls(0);
 SetActiveScreen(scr4);cls(0);
 SetActiveScreen(scr);
 LoadScreen('..\mcga-img\screen2.scr',scr);LoadPal('..\mcga-img\paleta2.pal',pal);
 SetAllPal(pal);
 SetVisualScreen(scr);

 repeat
  for i:=1 to 100 do
  begin
     rescale(scr2,0,0,319,199,scr3,160-i*16 div 10,100-i,160+i*16 div 10,100+i);
     flip(seg(scr^),seg(scr4^));
     fliptransp(seg(scr3^),seg(scr4^));
     flip(seg(scr4^),$A000);
     if keypressed then break;
  end;
  setactivescreen(scr3);cls(0);
  for i:=100 downto 1 do
  begin
     rescale(scr2,0,0,319,199,scr3,160-i*16 div 10,100-i,160+i*16 div 10,100+i);
     flip(seg(scr^),seg(scr4^));
     fliptransp(seg(scr3^),seg(scr4^));
     flip(seg(scr4^),$A000);
     if keypressed then break;
  end;
  setactivescreen(scr3);cls(0);
 until keypressed;

 FadeDown(0,0,0);
 ShutDownVirtual(scr);ShutDownVirtual(scr2);
 ShutDownVirtual(scr3);ShutDownVirtual(scr4);
 SetText;
end.
