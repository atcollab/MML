function [a, tout, DataTime, ErrorFlag] = getbpm_als(Family, varargin)
% [Amps, tout, DataTime, ErrorFlag] = getbpm_als(Family, DeviceList)
% [Amps, tout, DataTime, ErrorFlag] = getbpm_als(Family, Field, DeviceList)
%

if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

tout = [];
DataTime = [];
ErrorFlag = 0;


% Remove the Field input
if length(varargin) >= 1
    if ischar(varargin{1})
        % Remove and ignor the Field string
        varargin(1) = [];
    end
end
if length(varargin) >= 1
    Dev = varargin{1};
else
   Dev = getlistbpm;
end

pv = family2channel(Family, 'Monitor', Dev);

[DevNSLS2, DevOther, i, inot] = getbpmlist_nsls2(Dev);

[a, tout, DataTime, ErrorFlag] = getpvonline(pv);

DataTime = labca2datenum(DataTime);



% Check for sign error
% Use, SR01C{BPM:2}Pos:FA-X-I
if ~isempty(DevNSLS2)
    pause(.1);
    if strcmpi(Family, 'BPMx')
        pvfa = strcat(pv(i,1:12), 'Pos:FA-X-I');
    else
        pvfa = strcat(pv(i,1:12), 'Pos:FA-Y-I');
    end
    b = getpvonline(pvfa);
    
    ii = find(sign(a(i)) ~= sign(b));
    
    if ~isempty(ii)
        % Debug
        %c=[a(i) b];
        %c(ii,:)
        %pvfa(ii,:)
        
        a(i(ii)) = -1 * a(i(ii));
    end
end