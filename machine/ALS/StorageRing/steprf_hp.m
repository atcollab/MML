function [RFam, VOLTS] = steprf_hp(deltaRFnew, WaitFlag)
%  [RFam, VOLTS] = steprf_hp(deltaRFnew, WaitFlag);
%
%  deltaRFnew = new RF frequency delta [MHz]
%  RFam = monitor value for the RF frequency  [MHz]
%  VOLTS = new EG HQMOFM voltage [V]
%
%     Set the RF frequency in one step
%
%  Notes:  1.  The RF must be connected to the user synthesizer for this function to work
%          2.  The HQMOFM miniIOC must be connected to the user synthesizer for this function to work

% Christoph Steier, November 2010

if nargin < 1
    error('RF frequency input is required.');
end

if nargin < 2
    WaitFlag=-2;
end

if WaitFlag

    RF0 = getrf_als;

    for i = 1:5
        HQMOFMold = getpv('EG______HQMOFM_AC01');
        RFold = getrf_als;
        
        deltarfHQMO = (RF0+deltaRFnew-RFold) / 4.988e-3*10;      
       
        % set rf or voltage
        setpv('EG______HQMOFM_AC01', '', HQMOFMold+deltarfHQMO, 0);
        pause(3.5);
        
        if abs(deltaRFnew+RF0-getrf_als)<1e-6
            break
        end
        
    end
    
    % set rf or voltage with a WaitFlag
    setpv('EG______HQMOFM_AC01', '', HQMOFMold+deltarfHQMO, WaitFlag);
    
    % Extra wait to make sure the RF GPIB commands got there
    if WaitFlag < 0
        pause(1.5);
    end
    
    
else
        HQMOFMold = getpv('EG______HQMOFM_AC01');
       
        deltarfHQMO = deltaRFnew / 4.988e-3*10;      
       
        % set rf or voltage
        setpv('EG______HQMOFM_AC01', '', HQMOFMold+deltarfHQMO, 0);    
end

if nargout >1
    RFam  = getpv('SR01C___FREQB__AM00');
end

if nargout >= 2
    VOLTS = getpv('EG______HQMOFM_AC01');
end

