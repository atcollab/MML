function sirius_li_settwissdata(ModeName)
% Set TwissData at the start of the storage ring
%
% TwisData is a structure array with fields:
%       beta        - [betax, betay] horizontal and vertical Twiss parameter beta
%       alpha       - [alphax, alphay] horizontal and vertical Twiss parameter alpha
%       mu          - [mux, muy] horizontal and vertical betatron phase
%       ClosedOrbit - closed orbit column vector with 
%                     components x, px, y, py (momentums, NOT angles)						
%       dP          - momentum deviation
%       dL          
%       Dispersion  - dispersion orbit position 4-by-1 vector with 
%                     components [eta_x, eta_prime_x, eta_y, eta_prime_y]'
%                     calculated with respect to the closed orbit with 
%                     momentum deviation DP
%
% 2015-10-23 Luana

if strcmpi(ModeName, 'M1')
    try
        % TB twiss parameters at the input
        TwissData.alpha = [0 0]';
        TwissData.beta  = [7.0 7.0]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        TwissData.Dispersion  = [0 0 0 0]';
        setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
    catch
         warning('Setting the twiss data parameters in the MML failed.');
    end

elseif strcmpi(ModeName, 'M2')
    try
        TwissData.alpha = [0 0]';
        TwissData.beta  = [10.0 10.0]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        TwissData.Dispersion  = [0 0 0 0]';
        setpvmodel('TwissData', '', TwissData); 
    catch
        warning('Setting the twiss data parameters in the MML failed.');
    end
elseif strcmpi(ModeName, 'M3')
    try
        TwissData.alpha = [-1.0 -1.0]';
        TwissData.beta  = [ 7.0  7.0]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        TwissData.Dispersion  = [0 0 0 0]';
        setpvmodel('TwissData', '', TwissData);  
    catch
         warning('Setting the twiss data parameters in the MML failed.');
    end
elseif strcmpi(ModeName, 'M4')
    try
        TwissData.alpha = [1.0 1.0]';
        TwissData.beta  = [7.0 7.0]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        TwissData.Dispersion  = [0 0 0 0]';
        setpvmodel('TwissData', '', TwissData);  
    catch
         warning('Setting the twiss data parameters in the MML failed.');
    end
elseif strcmpi(ModeName, 'M5')
    try
        TwissData.alpha = [1.0 -1.0]';
        TwissData.beta  = [7.0  7.0]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        TwissData.Dispersion  = [0 0 0 0]';
        setpvmodel('TwissData', '', TwissData);  
    catch
         warning('Setting the twiss data parameters in the MML failed.');
    end
elseif strcmpi(ModeName, 'M6')
    try
        TwissData.alpha = [-1.0 1.0]';
        TwissData.beta  = [ 7.0 7.0]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        TwissData.Dispersion  = [0 0 0 0]';
        setpvmodel('TwissData', '', TwissData);  
    catch
         warning('Setting the twiss data parameters in the MML failed.');
    end
else
    error('Operational mode unknown');
end

end