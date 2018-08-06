function correctorCheck(offset)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/correctorCheck.m 1.2 2007/03/02 09:02:32CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

%start with the Horizontal correctors
delay = 0.00;
for i=1:12
    for j=1:4
        setval = j * 1000000 * offset;
        setsp('HCM',setval,[i j]);
        fprintf(' setting HCM [%d %d] to %d >\n ',i,j,setval);
        pause(delay);
        %getval = getam('HCM',[i j]);
        %fprintf(' rcvd %d\n',getval);
        
        %if((setval - 1000) > getval || (setval + 10000) < getval)
        %    fprintf('HCM [%d %d] did NOT set correctly should be %d and is %d\n',i,j,setval,getval);
        %end    
    end
end


for i=1:12
    for j=1:4
        setval = j * 1000000 * offset;
        setsp('VCM',setval,[i j]);
        fprintf(' setting VCM [%d %d] to %d > \n',i,j,setval);
        pause(delay);
        %getval = getam('VCM',[i j]);
        %fprintf(' rcvd %d\n',getval);
        
        %if((setval - 1000) > getval || (setval + 10000) < getval)
        %    fprintf('VCM [%d %d] did NOT set correctly should be %d and is %d\n',i,j,setval,getval);
        %end    
    end
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/correctorCheck.m  $
% Revision 1.2 2007/03/02 09:02:32CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
