uses mcga,viewbmp;

var  scr1,scr2:virtualscreen;
     pal1,pal2:palettetype;

begin
  setmcga;
  setupvirtual(scr1);
  setupvirtual(scr2);

  loadbmpfile(0,0,'..\mcga-img\amber.bmp',scr1,pal1);
  setallpal(pal1);
  setvisualscreen(scr1);

  createbwpal(pal2);
  createbwscreen(scr1,pal1,scr2);
  readln;

  waitretrace;
  setallpal(pal2);
  setvisualscreen(scr2);
  readln;

  shutdownvirtual(scr1);
  shutdownvirtual(scr2);
  settext;
end.