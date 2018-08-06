function svdorbY(Yresp, numsingular, scale)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/svdorbY.m 1.2 2007/03/02 09:18:08CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% SVDORBY(Yresp, NUMSINGULAR, SCALE)
%   Yresp is the Y-response matrix.
%   NUMSINGULAR is the number of singular values to use.
%   SCALE is a scaling factor applied to the calculated change in the
%   corrector values.
%
%   eg. >> svdorbY(Yresp_1, 48, -1)
%    or >> svdorbY(Yresp_1, 40, -1)   <-- using less singular values
%    or >> svdorbY(Yresp_1, 48, -0.5) <-- scale the change in corrector
%                                         values
% ----------------------------------------------------------------------------------------------

[tmp timeout error] = getam('VCM');
if error
    disp('Problem getting data from the VCM')
    return
else
    numcor = length(tmp);
end

newYcor = [];
Sy = Yresp;
Yinit = gety; % Gets the initial BPM readings
Y = Yinit;

%%%%% Eugene 7/12 zero out problem BPMs

Y = Y - 0e-3;
%Y([1, numcor]) = 0;
%Y(48) = 0.00;
%Y(1) = 0.00;
%Y(48) = .0025;
%Y(1:39) = 0;
%Y(42:48) = 0;

% points = [9:40];
% Y(points) = Yinit(points);

% [U,S,V] = svd(Sy);
% Deltakick = -V(:,Ivec)*((U(:,Ivec)*S(Ivec,Ivec))\Y);
[invSy problem] = invertresponsematrix(Sy, numsingular);
if problem
    return
end
Deltakick = -invSy*Y;

initvcor=getsp('VCM');
for i=1:numcor
    newYcor(i) = initvcor(i) + (scale * Deltakick(i));
end
%plot the previous VCM setpoints verses the new ones
figure; plot(1:numcor,scale * Deltakick,'.-b');
title('Change in correctors'); pause(0.5)
figure; plot(1:numcor,newYcor,'.-r');
title('Corrector values after full correction')
accept=input('Apply these corrections?  (y/n): ','s');

% Store changes for undo function rather than just subtracting the
% appropriate fraction of Deltakick.
changes_so_far = zeros(numcor, 10);
numchanges = 1;  % If user says yes then this will constitute one change.
clsScale = 0.1;  % So first application is 0.1 of the total change in correctors.
while ~strcmpi(accept,'n')
    
    if strcmpi(accept,'y')        
        
        changes_so_far(:, numchanges) = initvcor(:) + (scale * clsScale * Deltakick(:));
        
        fprintf('Applying %f of correction changes \n\n',clsScale);
		for i=1:numcor
            setpv('VCM','Setpoint',initvcor(i) + (scale * clsScale * Deltakick(i)),i);
            pause(0.01); 
		end
        
    elseif strcmpi(accept,'u')
        
        fprintf('Undoing last change made. Back to %f of correction changes\n\n', clsScale);
        if numchanges == 0
            % Restore the initial corrector pattern
            for i=1:numcor
                setpv('VCM','Setpoint', initvcor(i),i);
                pause(0.01); 
            end 
        else
            for i=1:numcor
                setpv('VCM','Setpoint', changes_so_far(i, numchanges),i);
                pause(0.01); 
            end 
        end
        
    else
        disp('Nothing done. Maybe you typed the wrong input?')
    end
    
    accept=input(['At ' num2str(clsScale) ' of changes. Apply these corrections (y)es, (n)o or (u)ndo?  (y/n/u): '],...
        's');
    
    % Decide to return or not and increment the various indices as
    % appropriate.
    if strcmpi(accept,'y')
        numchanges = numchanges + 1;
        clsScale = numchanges*0.1;
    elseif strcmpi(accept,'u')
        numchanges = numchanges - 1;
        % Do not allow undos past zero
        if numchanges < 0
            numchanges = 0;
        end
        clsScale = numchanges*0.1;
    elseif strcmpi(accept,'n')
        return;
    end
     
    % Exit program if the full correction has been applied
    if clsScale > 1.0
        fprintf('Full correction achieved \n');
        return
    end
    
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/svdorbY.m  $
% Revision 1.2 2007/03/02 09:18:08CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
