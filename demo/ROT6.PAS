Program demonstrativ_de_desenat_linii;
uses mcga,viewbmp,crt;
const
  nrpasi=120;
  lungime=30;
var
  pxc,pyc,i,j:integer;
  x1,x2,y1,y2,culori,xcentru,ycentru,unghiuri:array[1..4] of integer;
  scr:virtualscreen;
  sc2:virtualscreen;
  pal:palettetype;

function rad(unghi:integer):real;
  begin
    rad:=unghi*pi/180;
  end;

procedure calculpunct(xc,yc:integer;unghi:integer);
  begin
    pxc:=xc+trunc(cos(rad(unghi))*lungime);
    pyc:=yc+trunc(sin(rad(unghi))*lungime);

  end;
begin
  setmcga;
  setupvirtual(scr);setupvirtual(sc2);
  setactivescreen(scr);cls(0);
  loadquickbmpfile('..\mcga-img\PLASMA.BMP',sc2,pal);setallpal(pal);

  culori[1]:=4;
  culori[2]:=100;
  culori[3]:=200;
  culori[4]:=150;

  repeat
    {initializarea datelor}
    for i:=1 to 4 do
      begin
        unghiuri[i]:=(i mod 4 )*45;
      end;

    xcentru[1]:=30;
    ycentru[1]:=30;
    xcentru[2]:=getmaxx-30;
    ycentru[2]:=30;
    xcentru[3]:=30;
    ycentru[3]:=getmaxy-30;
    xcentru[4]:=getmaxx-30;
    ycentru[4]:=getmaxy-30;

    for i:=1 to nrpasi do
      begin
        {calcularea coordonatelor}
        for j:=1 to 4 do
          begin
            calculpunct(xcentru[j],ycentru[j],unghiuri[j]);
            x1[j]:=pxc;
            y1[j]:=pyc;
            calculpunct(xcentru[j],ycentru[j],unghiuri[j]+180);
            x2[j]:=pxc;
            y2[j]:=pyc;
          end;

        {desenarea liniilor}
        for j:=1 to 4 do begin
        line(x1[j],y1[j],x2[j],y2[j],culori[j]);
        line(x1[j]+5,y1[j]+5,x2[j]+5,y2[j]+5,culori[j]);
        line(x1[j]+10,y1[j]+10,x2[j]+10,y2[j]+10,culori[j]);
        line(x1[j],y1[j],x1[j]+10,y1[j]+10,culori[j]);
        line(x2[j],y2[j],x2[j]+10,y2[j]+10,culori[j]);
        line((x1[j]+x2[j])div 2+5,(y1[j]+y2[j])div 2+5,160,0,3);
        end;
        rotatepal(pal,1,255);
        waitretrace;setvisualscreen(scr);setallpal(pal);

        {modificarea coordonatelor}
        xcentru[1]:=xcentru[1]+trunc(getmaxx/nrpasi);
        ycentru[1]:=ycentru[1]+trunc(getmaxy/nrpasi);
        xcentru[2]:=xcentru[2]-trunc(getmaxx/nrpasi);
        ycentru[2]:=ycentru[2]+trunc(getmaxy/nrpasi);
        xcentru[3]:=xcentru[3]+trunc(getmaxx/nrpasi);
        ycentru[3]:=ycentru[3]-trunc(getmaxy/nrpasi);
        xcentru[4]:=xcentru[4]-trunc(getmaxx/nrpasi);
        ycentru[4]:=ycentru[4]-trunc(getmaxy/nrpasi);

        flip(seg(sc2^),where);

        for j:=1 to 4 do
          begin
            unghiuri[j]:=unghiuri[j]+5;
            unghiuri[j]:=unghiuri[j] mod 360;
          end;
      end;
    {interschimabarea culorilor}
    i:=culori[1];
    culori[1]:=culori[4];
    culori[4]:=i;

    i:=culori[2];
    culori[2]:=culori[3];
    culori[3]:=i;

  until keypressed;
  fadedown(0,0,0);
  shutdownvirtual(scr);
  shutdownvirtual(sc2);
  settext;
end.