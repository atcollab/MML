% efficacité injection sur tune


clear
dt=4;

kx0=-6.;  kx1=5;  dkx=1.0;
kz0=-6.;  kz1=5;  dkz=1.0;
ksix=kx0;
ksiz=kz0;

rendement=[];
ksixv=[];
i=0; j=0;
for kx=-6:1:5
    i=i+1;
    ksix=ksix+dkx;
    ksixv=[ ksixv ksix];
    ksizv=[];
    ksiz=kz0;
    j=0;
    for kz=-6:1:5
        j=j+1;
        ksiz=ksiz+dkz;
        ksizv=[ksizv ksiz];
        tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigEvent',int32(5));     
        
        temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');anscur0=temp.value;
        tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');pause(dt)
        
        temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');anscur=temp.value;dcur=anscur-anscur0;
        temp=tango_read_attribute2('BOO-C01/DG/DCCT','qExt'); boocharge=-temp.value;
        r=int16(dcur/boocharge*0.524*416/184*100);pause(dt)
        rendement(i,j)=r;
        
        stepchro([0,dkz],'Physics');pause(2*dt)
        
        tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigEvent',int32(3));
        fprintf('%g   %g  Rendement = %g\n',ksix,ksiz,r);pause(dt)
    end
    pause(dt)
    stepchro([dkx,-11.0],'Physics');pause(dt)
    
end