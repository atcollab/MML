function set_param

%       D   QF   QD
target=[545 203  155];
%target=[0  0  0];
step  =[50  50   50];

DIP=tango_read_attribute2('BOO/AE/D.1','currentSetPoint');
x     =[DIP.value    getsp('QF')     getsp('QD')];

dt    =0;  % Pause en seconde


step=sign(target-x).*step
[C,I]=max((target-x)./step)

setpt=[0 0 0];
for i=1:3
    if ( abs(target(i)-x(i)) <= abs(step(i)))
            setpt(i)=1;
    end
end
DIPcurrent=x(1);
QFcurrent =x(2);
QDcurrent =x(3);
fprintf('status = %g %g %g \n',DIPcurrent,QFcurrent,QDcurrent)
while ( abs(target(I)-x(I)) >= abs(step(I)) )
    x=x+step;
    if (setpt(1)==0)
        DIPcurrent=x(1);
        %tango_write_attribute2('BOO/AE/Dipole','current', DIPcurrent)
    end
    if (abs(target(1)-x(1)) <= abs(step(1)))
        setpt(1)=1;
    end
    if (setpt(2)==0)   
        QFcurrent=x(2);
        %setsp('QF', QFcurrent);
    end
    if (abs(target(2)-x(2)) <= abs(step(2)))
        setpt(2)=1;        
    end
    
    if (setpt(3)==0)
        QDcurrent=x(3);
        %setsp('QD', QDcurrent);
    end    
    if (abs(target(3)-x(3)) <= abs(step(3)))
        setpt(3)=1 ;            
    end
    
    fprintf('status = %g %g %g \n',DIPcurrent,QFcurrent,QDcurrent)
    pause(dt)
end
DIPcurrent=target(1); %tango_write_attribute2('BOO/AE/Dipole','current', DIPcurrent);
QFcurrent=target(2);  %setsp('QF', QFcurrent);
QDcurrent=target(3);  %setsp('QD', QDcurrent);
fprintf('status = %g %g %g \n',DIPcurrent,QFcurrent,QDcurrent)