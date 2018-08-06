function plotBpm(plane)

% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/plotBpmx.m 1.2 2007/03/02 09:02:41CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

if ~exist('plane')
	figure;
	for i = 1:1000
        if strcmpi(Plane, 'h')
            p = getam('BPMx');
        else
            p = getam('BPMy');    
        end    

        plot(p);
        pause(1.0);
	end    
end    

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/plotBpmx.m  $
% Revision 1.2 2007/03/02 09:02:41CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
