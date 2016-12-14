Program Demonstratie_la_unitul_Math;
uses crt,math;
var sintab:lookuptable;
    costab:lookuptable;

begin
 clrscr;

 CreateSinTable(sintab,1,1,0);             {   Procedura CreateSINTable    }
 CreateCosTable(costab,1,2,0);             {creaza o tabela pentru functia:}
 writeln('Conform tabelei virtuale:');     {       Ÿ(x)=A*sin(ì*t+í)       }
 writeln('-------------------------');     {                               }
 writeln('  SIN (30ø)=',sintab^[30]:1:2);  {  In exemplul dat se creaza o  }
 writeln('  COS (60ø)=',costab^[30]:1:2);  {tabela pentru functia:         }
 writeln;                                  {    f(x)=1*sin(1*x+0)=sin(x)   }
 DistroyTable(sintab);                     {  Analog pentru functia COS    }
 DistroyTable(costab);                     {este procedura CreateCOSTable. }

 writeln('Conform metodei obisnuite:');
 writeln('-------------------------');
 writeln('  SIN (30ø)=',sin(pi/6):1:2);
 writeln('  COS (60ø)=',cos(pi/3):1:2);

end.


