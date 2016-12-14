{
    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ³        Acesta este un unit care vine in ajutorul celor care        ³
    ³         doresc sa detecteze tipul æP-ului in programele lor        ³
    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
}

Unit CPUType;
Interface

const CPU_8088    =  0;
      CPU_80186   =  1;
      CPU_80286   =  2;
      CPU_80386   =  3;
      CPU_80486   =  4;
      CPU_UNKNOWN = -1;

Var cpu : integer;
function Isa8088 : boolean;
function Isa80186 : boolean;
function Isa80286 : boolean;
function Isa80386 : boolean;
function Isa80486 : boolean;

Implementation

Uses Dos;

var OldIntr6Handler : procedure;
      valid_op_code : boolean;

procedure Intr6Handler;
interrupt;
begin
  valid_op_code := false;
  asm
    add word ptr ss:[bp + 18], 3
  end;
end;

function Isa8088 : boolean;
var sp1, sp2 : word;
begin
  asm
    mov sp1, sp
    push sp
    pop sp2
  end;
  if sp1 <> sp2 then
    Isa8088 := true
  else
    Isa8088 := false;
end;

function Isa80186 : boolean;
begin
  if Isa8088 then
    Isa80186 := false
  else
    begin
      valid_op_code := true;
      GetIntVec(6, @OldIntr6Handler);
      SetIntVec(6, Addr(Intr6Handler));
      inline($C1/$E2/$05);  { shl dx, 5 }
      SetIntVec(6, @OldIntr6Handler);
      Isa80186 := valid_op_code;
    end;
end;

function Isa80286 : boolean;
begin
  if Isa8088 then
    Isa80286 := false
  else
    begin
      valid_op_code := true;
      GetIntVec(6, @OldIntr6Handler);
      SetIntVec(6, Addr(Intr6Handler));
      inline($0F/$01/$E2);  { smsw dx }
      SetIntVec(6, @OldIntr6Handler);
      Isa80286 := valid_op_code;
    end;
end;

function Isa80386 : boolean;
begin
  if Isa8088 then
    Isa80386 := false
  else
    begin
      valid_op_code := true;
      GetIntVec(6, @OldIntr6Handler);
      SetIntVec(6, Addr(Intr6Handler));
      inline($0F/$20/$C2);  { mov edx, cr0 }
      SetIntVec(6, @OldIntr6Handler);
      Isa80386 := valid_op_code;
    end;
end;

function Isa80486 : boolean;
begin
  if Isa8088 then
    Isa80486 := false
  else
    begin
      valid_op_code := true;
      GetIntVec(6, @OldIntr6Handler);
      SetIntVec(6, Addr(Intr6Handler));
      inline($0F/$C1/$D2);  { xadd dx, dx }
      SetIntVec(6, @OldIntr6Handler);
      Isa80486 := valid_op_code;
    end;
end;


begin
  if Isa8088 then
    cpu := CPU_8088
  else if Isa80486 then
    cpu := CPU_80486
  else if Isa80386 then
    cpu := CPU_80386
  else if Isa80286 then
    cpu := CPU_80286
  else if Isa80186 then
    cpu := CPU_80186
  else
    cpu := CPU_UNKNOWN;
end.
