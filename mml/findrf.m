function [DeltaRF, HCMEnergyChangeTotal, DeltaL] = findrf(varargin)
%FINDRF - Finds the RF frequency that minimizes the energy change due
%         to the horizonal correctors after the next orbit correction.
%         Hopefully this method also finds an optimal RF frequency setting.
%         As with anything, you should know what you are doing before
%         running this function.  How the optimal RF frequency setpoint
%         is found usually depends the type of accelerator.
%
%  INPUTS (optional)
%  1. 'Display' - Plot orbit information {Default unless there are outputs variables}
%     'NoDisplay' - No plot
%  2. 'SetRF'   - Set the RF frequency (prompts for a setpoint change if 'Display' is on)
%     'NoSetRF' - No RF frequency setpoint change
%  3. 'Position' {Default} or 'Phase' for the x-axis units (if display is on)
%  4. 'Online', 'Model', 'Manual', 'Hardware', 'Physics', etc. (the usual Units and Mode flags)
%
%  OUTPUTS
%  1. DeltaRF - Half the RF change that equates to the energy change of the horizontal correctors
%               This is a guess that seems to come close.  Iterating with orbit correction is required.
%               The exact scaling will depend on the accelerator (.35 workd well at the ALS).  It's 
%               better to use orbitcorrectionmethods with the RF frequency restricted to not change the energy.
%  2. DeltaEnergy - Total energy change due to the horizontal correctors
%  3. DeltaL - Path length change that equates to the total energy change (DeltaEnergy)
%
%  NOTES
%  1. Uses plotcm
% 
%  See also rmdisp, plotcm, findrf1, orbitcorrectionmethods

%  Written by Greg Portmann


if nargout == 0
    DisplayFlag = 'Display';
else
    DisplayFlag = 'NoDisplay';
end
XAxisFlag = 'Position';
ChangeRFFlag = 1;


% Input parsing
InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Position')
        XAxisFlag = 'Position';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Phase')
        XAxisFlag = 'Phase';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'SetRF')
        ChangeRFFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoSetRF')
        ChangeRFFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 'Display';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 'NoDisplay';
        varargin(i) = [];
    end
end


Family1 = gethcmfamily;
Family2 = getvcmfamily;

[DeltaRF, HCMEnergyChangeTotal, DeltaL] = plotcm(varargin{:}, DisplayFlag);
DeltaRF = DeltaRF/2;


% Set the RF frequency
if ChangeRFFlag
    if ~isempty(DeltaRF)
        % Half the energy change seems to be a good RF change

        if DisplayFlag
            [RFUnits, RFUnitsString] = getunits('RF');
            answer = inputdlg({strvcat(strvcat(sprintf('Recommend change in RF is %g %s (half the energy change is a guess)', DeltaRF, RFUnitsString), '  '), 'Change the RF frequency?')},'FINDRF',1,{sprintf('%g',DeltaRF)});
            if isempty(answer)
                fprintf('   No change was made to the RF frequency.\n');
                return
            end
            DeltaRF = str2num(answer{1});
        end
        steprf(DeltaRF, varargin{:});
        if DisplayFlag
            fprintf('   RF frequency change by %f %s.\n', DeltaRF, RFUnitsString);
        end
    else
        if DisplayFlag
            error('RF frequency not changed because of a problem converting the units for dispersion and orbit to RF frequency.');
        end
    end
end


