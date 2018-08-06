% lecture et sauvegarde BPM


ds=3.5595;       % longueur maille
ncorrx=22;
nbpmx=22;

istart=27;
iend  =1000

% table BPM
clear loc
loc(1) =01;loc(2) =04;loc(3) =05;loc(4) =08;loc(5) =09;loc(6)=11;
loc(7) =13;loc(8) =14;loc(9) =17;loc(10)=18;loc(11)=21;
loc(12)=23;loc(13)=26;loc(14)=27;loc(15)=30;loc(16)=31;loc(17)=33;
loc(18)=35;loc(19)=36;loc(20)=39;loc(21)=40;loc(22)=43;
for i=1:nbpmx,
    s_bx(i)=ds*loc(i)   ; 
    s_cx(i)=(2*ds)*(i-1); 
end

clear Zm Xm
for i=1:22
    xm=0;
    zm=0;
        a=getbpmrawdata(i,'nodisplay','struct');
        for j=istart:iend,
           xm=xm+a.Data.X(j); % en mm
           zm=zm+a.Data.Z(j);
        end
        Xm(i)=xm/(iend-istart+1);
        Zm(i)=zm/(iend-istart+1);
end
Corr_X=getam('HCOR');
Corr_Z=getam('VCOR');

%save 'orbit_super' 'Xm' 'Zm' 'Corr_X' 'Corr_Z'

