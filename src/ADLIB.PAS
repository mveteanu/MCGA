unit adlib;
interface

function AdlibExists:boolean;


implementation
uses crt;

const ADLIB_FM_ADDRESS=$388;
const ADLIB_FM_DATA   =$389;

procedure WriteFM(reg,value:integer);
var i:integer;t:byte;
begin
 port[ADLIB_FM_ADDRESS]:=byte(reg);
 for i := 0 to 5 do t:=port[ADLIB_FM_ADDRESS];
 port[ADLIB_FM_DATA]:=byte(value);
 for i := 0 to 34 do t:=port[ADLIB_FM_ADDRESS];
end;

function ReadFM:integer;
begin
 ReadFM:=port[ADLIB_FM_ADDRESS];
end;

function AdlibExists:boolean;
var stat1,stat2:integer;
begin
 WriteFM($04, $60);            { reset both timers        }
 WriteFM($04, $80);            { enable timer interrupts  }
 stat1 := ReadFM;              { read status register     }
 WriteFM($02, $FF);
 WriteFM($04, $21);            { start timer 1            }
 delay(80);                    { could do something useful}
 stat2 := ReadFM;              { read status register     }
 WriteFM($04, $60);            { reset both timers        }
 WriteFM($04, $80);            { enable timer interrupts  }

 if (((stat1 and $E0) = 0) and ((stat2 and $E0) = $C0))
  then AdlibExists:=true
  else AdlibExists:=false;
end;

end.

