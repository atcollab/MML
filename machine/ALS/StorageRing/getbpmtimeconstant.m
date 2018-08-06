function [BPMTimeConstant, WarningFlag] = getbpmtimeconstant(varargin)
%GETBPMTIMECONSTANT - Sets the timeconstants for the Bergoz style BPMs.
% [BPMTimeConstant, WarningFlag] = getbpmtimeconstant(DeviceList)
%
%  INPUTS
%  1. DeviceList - BPM device list {Default: [1 2]}
%
%  OUTPUTS
%  1. BPMTimeConstant - Time constant [seconds]
%                       {Default: only IOC1 time constant}
%  2. WarningFlag - 0 -> All the BPM have the same time constant
%                   1 -> Not all the BPMs have the same time constant
%
%  NOTES
%  1. In Simlutor mode, BPMTimeConstant = 0
%  2. For non-Bergoz BPM, the output is NaN.
%  3. If there are 2 outputs, all the BPMs are checked for the same
%     time constant.  This check takes much longer since all BPM are read.
%
%  See also getbpmaverages, setbpmaverages, setbpmtimeconstant

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the Bergoz BPM Time Constant %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Mode = getfamilydata('BPMx','Monitor','Mode');


if nargin == 0
    DeviceList = [1 2];  %getbpmlist('Bergoz');
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
end


if strcmpi(Mode,'Simulator')

    BPMTimeConstant = 0 * ones(size(DeviceList,1),1);
    WarningFlag = 0;

else

    BPMTimeConstant = getpv('BPMx', 'TimeConstant', DeviceList);

    if nargout >= 2
        % Check if all the BPM have the same value
        BPMTimeConstantVec = getpv('BPMx','TimeConstant', getbpmlist('Bergoz'));
        if any( BPMTimeConstantVec(1) ~= BPMTimeConstantVec )
            fprintf('\n   Warning:  Not all the BPM time constants are the same.\n');
            fprintf(  '             Use setbpmtimeconstant, setbpmaverages or srinit to fix the problem.\n\n');
            BPMTimeConstant = BPMTimeConstant(1);
            WarningFlag = 1;
        else
            WarningFlag = 0;
        end
    end

end


% Bergoz BPMs (1 crate per sector)
% Example, ''SR09C___IBPM____AC00''
% for i = 1:12 % size(DeviceList, 1)
%    Name = sprintf(''SR%02dS___IBPM___AC00'', i);
%    BPMTimeConstant(i,1) = getpv(Name);
% end
%
% % Sector 4, 8, 12 "super bend" BPMs have a different crate
% % Example, ''SR08C___BPM__T_AC00''
% for i = [4 8 12]
%    Name = sprintf('''''SR%02dC___BPM__T_AC00'', i);
%    BPMTimeConstant = [BPMTimeConstant; getpv(Name)];
% end
%
%BPMTimeConstantVec = BPMTimeConstant;
%[BPMTimeConstant, i, j] = unique(BPMTimeConstant);



