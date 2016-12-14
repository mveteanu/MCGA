Program CPU_Demo;
uses CPUType;
const mp:array[0..5] of string[6] = ('8088','80186','80286',
                                      '80386','80486','necunoscut');

begin
 writeln('Tipul procesorului : '+mp[cpu]);
end.
