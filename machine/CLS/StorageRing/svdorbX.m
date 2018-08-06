function svdorbX(Xresp, numsingular, scale, offset)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/svdorbX.m 1.2 2007/03/02 09:17:23CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% SVDORBX(Xresp, NUMSINGULAR, SCALE, offset)
%   Xresp is the X-response matrix.
%   NUMSINGULAR is the number of singular values to use.
%   SCALE is a scaling factor applied to the calculated change in the
%   corrector values.
%   SCALE:  the scaling factor for the correction
%   OFFSET: rthe offset that is subtracted globally to the entire orbit
%       
%   eg. >> svdorbX(Xresp_1, 48, -1)
%    or >> svdorbX(Xresp_1, 40, -1)   <-- using less singular values
%    or >> svdorbX(Xresp_1, 48, -0.5) <-- scale the change in corrector
%                                         values
% ----------------------------------------------------------------------------------------------

[tmp timeout error] = getam('HCM');
if error
    disp('Problem getting data from the HCM')
    return
else
    numcor = length(tmp);
end

newXcor = [];
Sx = Xresp;
Xinit = getx;
X = Xinit;

%%%%% Eugene 7/12 zero out problem BPMs
%X(:) = 0;
X = X + offset;

% [U,S,V] = svd(Sx);
% Deltakick = -V(:,Ivec)*((U(:,Ivec)*S(Ivec,Ivec))\X);
[invSx problem] = invertresponsematrix(Sx, numsingular);
if problem
    return
end
Deltakick = -invSx*X;

inithcor=getsp('HCM');
for i=1:numcor
    newXcor(i) = inithcor(i) + (scale * Deltakick(i));
end
%plot the previous HCM setpoints verses the new ones
figure; plot(1:numcor,scale * Deltakick,'.-b');
title('Change in correctors'); pause(0.5)
figure; plot(1:numcor,newXcor,'.-r');
title('Corrector values after full correction')
accept=input('Apply these corrections?  (y/n): ','s');

% Store changes for undo function rather than just subtracting the
% appropriate fraction of Deltakick.
changes_so_far = zeros(numcor, 10);
numchanges = 1;  % If user says yes then this will constitute one change.
clsScale = 0.1;  % So first application is 0.1 of the total change in correctors.
while ~strcmpi(accept,'n')
    
    if strcmpi(accept,'y')        
        
        changes_so_far(:, numchanges) = inithcor(:) + (scale * clsScale * Deltakick(:));
        
        fprintf('Applying %f of correction changes \n\n',clsScale);
		for i=1:numcor
            setpv('HCM','Setpoint',inithcor(i) + (scale * clsScale * Deltakick(i)),i);
            pause(0.01); 
		end
        
    elseif strcmpi(accept,'u')
        
        fprintf('Undoing last change made. Back to %f of correction changes\n\n', clsScale);
        if numchanges == 0
            % Restore the initial corrector pattern
            for i=1:numcor
                setpv('HCM','Setpoint', inithcor(i),i);
                pause(0.01); 
            end 
        else
            for i=1:numcor
                setpv('HCM','Setpoint', changes_so_far(i, numchanges),i);
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
% $Log: MatlabApplications/acceleratorcontrol/cls/svdorbX.m  $
% Revision 1.2 2007/03/02 09:17:23CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
