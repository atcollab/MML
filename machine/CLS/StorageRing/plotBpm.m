function plotBpm(plane)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/plotBpm.m 1.2 2007/03/02 09:02:18CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

if exist('plane')
	figure;
	for i = 1:1000
        if strcmpi(plane, 'h')
            p = getam('BPMx');
        else
            p = getam('BPMy');    
        end    

        plot(p);
        pause(1.0);
	end    
end    

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/plotBpm.m  $
% Revision 1.2 2007/03/02 09:02:18CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
