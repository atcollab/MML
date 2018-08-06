function [N, T, WarningFlag] = getbpmaverages(varargin)
%GETBPMAVERAGES - Gets the BPM averages
%  [N, T, WarningFlag] = getbpmaverages(DeviceList)
%
%  INPUTS
%  1. DeviceList - BPM device list {Default: [1 2]}
%
%  OUTPUTS
%  1. N - Number of averages
%  2. T - Sampling period after averaging [seconds]
%  3. WarningFlag - Warning if all BPM sampling periods are not the same
%
%  NOTES
%  1. In Simlutor mode, N = 1 and T = 0
%  2. For Bergoz BPM's the sampling period is an effective sampling period.
%  3. If there are 3 or more outputs, all the BPMs are checked for the same
%     effective number of averages.  This check takes much longer since all BPM are read.

%  See also setbpmaverages, getbpmtimeconstant, setbpmtimeconstant

%  Written by Greg Portmann


Mode = getfamilydata('BPMx','Monitor','Mode');
DeviceList = [];

if strcmpi(Mode,'Simulator')

        if length(varargin) >= 1
            if ischar(varargin{1})
                varargin(1) = [];
            end
        end
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                DeviceList = varargin{1};
            else
                error('DeviceList not found');
            end
        end
        if isempty(DeviceList)
            DeviceList = family2dev('BPMx');
        end

        N = 1 * ones(size(DeviceList,1),1);
        T = 0 * ones(size(DeviceList,1),1);

        N = 1;
        T = 0;
else

    if nargin == 0
        % Make the zero input case fast since it is used alot
        BPMTimeConstant = getpv('BPMx', 'TimeConstant', [1 2]);
        T = 2.5 * BPMTimeConstant;
        N = 1;
    else
        if length(varargin) >= 1
            if ischar(varargin{1})
                varargin(1) = [];
            end
        end
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                DeviceList = varargin{1};
            else
                error('DeviceList not found');
            end
        end
        if isempty(DeviceList)
            DeviceList = family2dev('BPMx');
        end


        BPMNumAveragesPerOneSecondPeriod_OldStyle = 2 * 190;
        % BPMNumAveragesPerOneSecondPeriod_Bergoz = 2 * 2700;   % Bergoz BPMs used to have averaging (in the good old days)

        N = getpv('BPMx', 'NumberOfAverages', DeviceList);
        T = N / BPMNumAveragesPerOneSecondPeriod_OldStyle;


        % Get the Bergoz style BPM's
        i = find(isnan(N));
        if ~isempty(i)
            % Bergoz style BPM - set time constant
            % 2.5 Time constants in T seconds should give reasonable results
            % since data is not considered fresh for 2.2*T (ie, 5.5 time constants)
            T(i) = 2.5 * getpv('BPMx', 'TimeConstant', DeviceList(i,:));
            N(i) = 1;
        end
    end


    if nargout >= 3
        % Check if all the BPM have the same value
        [tmp, T_All] = getbpmaverages([]);
        if any(T_All(1) ~= T_All)
            fprintf('\n   Warning:  Not all the BPM number of averages are the same.\n');
            fprintf(  '             Use setbpmaverages or srinit to fix the problem.\n\n');
            WarningFlag = 1;
        else
            WarningFlag = 0;
        end
    end

    
    % I'm adding extra delay because the BPM processing time seems a little long (GP)
    % Note: The delay used in setpv is 2.2 * T
    T	= 1.2 * T;
end

