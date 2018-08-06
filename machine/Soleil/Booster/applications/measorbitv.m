% Appel en série orbit_bump
% Mesure orbite et taille faisceau sur perte dans la chambre veticale au
% droit de chaque QP verticale

step =1;   % pas en mm
borne=11;   % max en mm

scanz=-borne:step:borne;
nmax=21;
NQP=[1 : nmax];
table=[];

%orbit_bump(QP,dz(1));
fprintf('******** Mesure orbite **********   \n');
for i=nmax:nmax  % on saute le premier QPV = orbite à l'injection
    setsp('VCOR',vcor0); 
    QP=i;
    fprintf('QP = %g   ',QP);
    R=[];
    for dz=scanz
       setsp('VCOR',vcor0);
       orbit_bump(QP,dz);pause(2)
       tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
       pause(1.5)
       temp=tango_read_attribute2('LT1/DG/MC','qIct2');        lt1charge=temp.value;
       temp=tango_read_attribute2('BOO-C01/DG/DCCT','qExt');   boocharge=-temp.value;
       if lt1charge==0
          r=-1;
       else
          r=(boocharge+0.09)/lt1charge*100;
       end
       if r<0
           r=0;
       end
       R=[R r];
       fprintf(' %6.2f ',r);
       
    end
    fprintf('\n');
    setam('VCOR',vcor0);
    [estimates, model] = fitprofil(scanz, R);
    fprintf('Sig=%g  Dz=%g \n',estimates(1),estimates(2));
    [sse, FittedCurve] = model(estimates);
    plot(scanz, R, '*', scanz, FittedCurve, 'r'); 
    ylim([0 100])
    grid on
    fprintf('\n');
end

