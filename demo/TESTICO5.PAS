uses mcga;
var f:word;
    frame1,frame2:pointer;
    l:word;
begin
setmcga;
 l:=geticosize(0,0,31,31);
 getmem(frame1,l);getmem(frame2,l);
 circle(15,15,15);
 getico(0,0,31,31,frame1);saveicon('framet.icn',frame1);
 loadicon('framet.icn',frame2);putico(100,150,frame2);
readln;
freemem(frame1,l);
freemem(frame2,l);
settext;
end.