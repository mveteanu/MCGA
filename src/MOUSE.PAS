{
    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ³        Acesta este un unit care vine in ajutorul celor care        ³
    ³           doresc sa utilizeze mouse-ul in programele lor           ³
    ³                         (c) VMA soft 1995                          ³
    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
}

unit mouse;
interface
  procedure showmouse;
  procedure hidemouse;
  procedure initmouse;
  function  mousex:integer;
  function  mousey:integer;
  function  leftpressed:boolean;
  function  leftpressed1:boolean;
  function  rightpressed:boolean;
  function  rightpressed1:boolean;
  function  midpressed:boolean;
  function  existmouse:boolean;
  procedure movemouse(x,y:integer);
  procedure setareax(x,y:integer);
  procedure setareay(x,y:integer);
  procedure setarea(x,y,z,t:integer);
  procedure selectcursor(s:string);

implementation
uses dos;

var re:registers;
    existm,ml,mr:boolean;

procedure initmouse;
  begin
    re.ax:=0;
    intr($33,re);
    if re.ax=$ffff then existm:=true else exit;
  end;

procedure showmouse;
  begin
    if not existm then exit;
    re.ax:=1;
    intr($33,re);
  end;

procedure hidemouse;
  begin
    if not existm then exit;
    re.ax:=2;
    intr($33,re);
  end;

function leftpressed;
  begin
    if not existm then exit;
    re.ax:=3;
    intr($33,re);
    if re.bx and 1 <> 0 then leftpressed:=true else leftpressed:=false;
  end;

function leftpressed1;
  begin
    if not existm then exit;
    re.ax:=3;
    intr($33,re);
    if (re.bx and 1<>0) and ml then begin leftpressed1:=false;exit; end;
    ml:=false;
    re.ax:=3;
    intr($33,re);
    if re.bx and 1 <> 0 then begin ml:=true;leftpressed1:=true;end else leftpressed1:=false;
  end;

function rightpressed1;
  begin
    if not existm then exit;
    re.ax:=3;
    intr($33,re);
    if (re.bx and 2<>0) and mr then begin rightpressed1:=false;exit; end;
    mr:=false;
    re.ax:=3;
    intr($33,re);
    if re.bx and 2 <> 0 then begin mr:=true;rightpressed1:=true;end else rightpressed1:=false;
  end;

function rightpressed;
  begin
    if not existm then exit;
    re.ax:=3;
    intr($33,re);
    if re.bx and 2 <> 0 then rightpressed:=true else rightpressed:=false;
  end;

function midpressed;
  begin
    if not existm then exit;
    re.ax:=3;
    intr($33,re);
    if re.bx and 4 <> 0 then midpressed:=true else midpressed:=false;
  end;

function mousex;
  begin
    if not existm then exit;
    re.ax:=3;
    intr($33,re);
    mousex:=re.cx
  end;

function mousey;
  begin
    if not existm then exit;
    re.ax:=3;
    intr($33,re);
    mousey:=re.dx
  end;

function existmouse;
begin
  existmouse:=existm;
end;

procedure movemouse;
  begin
    if not existm then exit;
    hidemouse;
    re.ax:=4;
    re.cx:=x;
    re.dx:=y;
    intr($33,re);
    showmouse;
  end;

procedure setareax(x,y:integer);
  begin
    re.ax:=7;
    re.cx:=x;re.dx:=y;
    intr($33,re);
  end;

procedure setareay(x,y:integer);
  begin
    re.ax:=8;
    re.cx:=x;re.dx:=y;
    intr($33,re);
  end;

procedure setarea(x,y,z,t:integer);
  begin
    setareax(x,z);setareay(y,t);
  end;


procedure selectcursor;
type tip=array[1..32] of word;
     mous=record
                data:tip;
                x,y:integer;
               end;
var q:tip;
    m:mous;
    fis:file of mous;
    re:registers;
begin
  assign(fis,s);
  {$i-}reset(fis);{$i+}
  if ioresult=0 then
                   begin
                      read(fis,m);
                      close(fis);
                      q:=m.data;
                      re.ax:=9;
                      re.bx:=m.x;
                      re.cx:=m.y;
                      re.es:=seg(q);
                      re.dx:=ofs(q);
                      intr($33,re);
                    end
               else
                   begin
                      initmouse;
                      showmouse;
                   end;
end;


begin
  existm:=false;
  initmouse;
end.

