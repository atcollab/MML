function sirius_tb_settwissdata(ModeName)
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
        TwissData.Dispersion = [-0.0586, -0.2588,  0.0000,  0.0000]';
        TwissData.beta = [ 3.1667, 13.3117]';
        TwissData.alpha = [ 1.5073, -2.9245]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
    catch
         warning('Setting the twiss data parameters in the MML failed.');
    end

elseif strcmpi(ModeName, 'M2')
    try
        TwissData.Dispersion = [-0.0586, -0.2588,  0.0000,  0.0000]';
        TwissData.beta = [ 3.6036, 16.6264]';
        TwissData.alpha = [ 1.5671, -1.3144]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        setpvmodel('TwissData', '', TwissData); 
    catch
        warning('Setting the twiss data parameters in the MML failed.');
    end
elseif strcmpi(ModeName, 'M3')
    try
        TwissData.Dispersion = [-0.0586, -0.2588,  0.0000,  0.0000]';
        TwissData.beta = [ 3.2556, 19.6968]';
        TwissData.alpha = [ 1.0134, -3.6354]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        setpvmodel('TwissData', '', TwissData);  
    catch
         warning('Setting the twiss data parameters in the MML failed.');
    end
elseif strcmpi(ModeName, 'M4')
    try
        TwissData.Dispersion = [-0.0586, -0.2588,  0.0000,  0.0000]';
        TwissData.beta = [ 3.2421,  3.8668]';
        TwissData.alpha = [ 1.7275,  0.2114]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        setpvmodel('TwissData', '', TwissData);  
    catch
         warning('Setting the twiss data parameters in the MML failed.');
    end
elseif strcmpi(ModeName, 'M5')
    try
        TwissData.Dispersion = [-0.0586, -0.2588,  0.0000,  0.0000]';
        TwissData.beta = [ 0.4918, 21.7039]';
        TwissData.alpha = [-0.6437, -3.4604]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        setpvmodel('TwissData', '', TwissData);  
    catch
         warning('Setting the twiss data parameters in the MML failed.');
    end
elseif strcmpi(ModeName, 'M6')
    try
        TwissData.Dispersion = [-0.0586, -0.2588,  0.0000,  0.0000]';
        TwissData.beta = [ 2.9771, 11.0431]';
        TwissData.alpha = [ 1.0378, -0.8005]';
        TwissData.mu    = [0 0]';
        TwissData.ClosedOrbit = [0 0 0 0]';
        TwissData.dP = 0;
        TwissData.dL = 0;
        setpvmodel('TwissData', '', TwissData);  
    catch
         warning('Setting the twiss data parameters in the MML failed.');
    end
else
    error('Operational mode unknown');
end

end