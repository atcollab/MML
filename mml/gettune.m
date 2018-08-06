function [Tune, tout, DataTime, ErrorFlag] = gettune(varargin)
%GETTUNE - Returns the betatron tunes
%  | Higher Fractional Tune (X) |
%  |                            | = gettune(t, FreshDataFlag, TimeOutPeriod)
%  |  Lower Fractional Tune (Y) |
%
%  INPUTS
%  1. t, FreshDataFlag, TimeOutPeriod (see help getpv for details)
%  2. 'Struct'  - Output will be a response matrix structure
%     'Numeric' - Output will be a numeric matrix {default}
%  3. Optional override of the units:
%     'Physics'  - Use physics  units
%     'Hardware' - Use hardware units
%  4. Optional override of the mode:
%     'Online'    - Get data online  
%     'Simulator' - Get data on the simulated accelerator using AT
%     'Model'     - Same as 'Simulator'
%     'Manual'    - Get data manually
%
%  OUTPUTS
%  1. Fractional tune
%  2. tout     (see help getpv for details)
%  3. DataTime (see help getpv for details)
%  4. ErrorFlag =  0   -> no errors
%                 else -> error or warning occurred
%
%  NOTES
%  1. An easy way to measure N averaged tunes is mean(gettune(1:2:N)')' (2 seconds between measurements)
%
%  See also steptune, settune

% Written by Gregory J. Portmann
% Modified by Laurent S. Nadolski


DisplayFlag = 0;
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignore structures
    elseif iscell(varargin{i})
        % Ignore cells
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end
 
% Get betatron tunes
[Tune, tout, DataTime, ErrorFlag] = getpv('TUNE', 'Monitor', [1 1; 1 2], varargin{:});

% Complete structure
if isstruct(Tune)
    TuneUnitsString = getfamilydata('TUNE','Monitor','HWUnits');
    if isempty(TuneUnitsString)
        Tune.UnitsString = 'Fractional Tune';
    else
        Tune.UnitsString = TuneUnitsString;
    end
    Tune.DataDescriptor = 'TUNE';
    Tune.CreatedBy = 'gettune';
end

% Display to the screen
if DisplayFlag
   fprintf('\n  Horizontal Tune = %f\n', Tune(1));
   fprintf('    Vertical Tune = %f\n\n', Tune(2));
end


% % Get data at every point in time vector, t
% t_start = gettime;
% for i = 1:length(t)
%     T = t(i)-(gettime-t_start);
%     if T > 0
%         pause(T);
%     end
%     tout(i) = gettime - t_start;
%     
%     [Tune(:,i), ErrorFlag] = local_gettune;
%         
%     if FreshDataFlag
%         FreshDataCounter = FreshDataFlag;
%         t0 = gettime;
%         Tune0 = Tune(:,i);
%         while FreshDataCounter
%             [Tune(:,i), ErrorFlag] = local_gettune;
%             
%             if ~any((Tune(:,i)-Tune0)==0)
%                 FreshDataCounter = FreshDataCounter - 1;
%             end
%             
%             if (gettime-t0)> TimeOutPeriod
%                 error('Timed out waiting for fresh tune data.');
%                 %ErrorFlag = 1;
%                 %break
%             end
%         end
%     end
% end    
% 
% % if nargout == 0
% %     fprintf('\n   Horizontal Tune = %f\n', Tune(1,1));
% %     fprintf('     Vertical Tune = %f\n\n', Tune(2,1));
% % end
% 
% 
% 
% function [Tune, ErrorFlag] = local_gettune
% 
% ErrorFlag = 0;
% 
% [FamilyIndex, ACCELERATOR_OBJECT] = isfamily('TUNE');
% 
% if isfield(ACCELERATOR_OBJECT, 'Mode')
%     Mode = ACCELERATOR_OBJECT.Mode;
% else
%     Mode = 'Online';
% end
% 
% if strcmp(lower(Mode),'online')
%     
%     RFam = getam('TUNE');
%         
% elseif strcmp(lower(Mode),'simulator')
%     
%     global THERING
%     if isempty(THERING)
%         error('Simulator variable is not setup properly.');
%     end
%     
%     [TD, Tune1] = twissring(THERING,0,1:length(THERING)+1);
%     Tune = Tune1' + rand(2,1)*.0001;
%     
% elseif strcmp(lower(Mode),'manual')
%     
%     Tune(1,1) = input('   Input the horizontal tune = ');
%     Tune(2,1) = input('   Input the vertical   tune = ');
% 
% elseif strcmp(lower(Mode),'als')
%     
%     Tune = gettune_als;
% 
% else
% 
%     error(sprintf('Unknown mode for family %s.', ACCELERATOR_OBJECT.FamilyName));
%     
% end
