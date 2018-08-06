% Appel en série orbit_bump
% Mesure orbite et taille faisceau sur perte dans la chambre veticale au
% droit de chaque QP verticale

step =1;   % pas en mm
borne=6;   % max en mm

scanz=-borne:step:borne;
nmax=12;

NQP=[1 : nmax];
table=[];

fprintf('******** Mesure orbite **********   \n');
for i=nmax:nmax  % on saute le premier QPV = orbite à l'injection
    setsp('HCOR',hcor0);
    QP=i;
    fprintf('QP = %g   ',QP);
    R=[];
    for dz=scanz
       setsp('HCOR',hcor0);
       orbit_bumph(QP,dz);pause(1)
       tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
       pause(1.5)
       temp=tango_read_attribute2('LT1/DG/MC','qIct2');        lt1charge=temp.value;
       temp=tango_read_attribute2('BOO-C01/DG/DCCT','qExt');   boocharge=-temp.value;
       if lt1charge==0
          r=-1;
       else
          r=boocharge/lt1charge*100;
       end
       R=[R r];
       fprintf(' %6.2f ',r);
       
    end
    fprintf('\n');
    orbit_bumph(QP,-borne)
    [estimates, model] = fitprofil(scanz, R);
    fprintf('Sig=%g  Dz=%g \n',estimates(1),estimates(2));
    plot(scanz, R, '*')
    hold on
    [sse, FittedCurve] = model(estimates);
    plot(scanz, FittedCurve, 'r'); hold off
    fprintf('\n');
end

