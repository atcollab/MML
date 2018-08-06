function rstruct = mcagetmore(varargin)
%NOT IMPLEMENTED in MCA6.1
%MCAGETMORE read value and additional information such as time stamp and alarm 
%   status from an EPICS record PV's
%   MCAGETMORE(HANDLE,OPTIONSTRING)
%   
% Returns a structure where the fields depend on the OPTIONSTRING
% Only 'STS' and 'TIME' options are implemented 
% 
%  OPTIONSTRING     Fields
%
%   none            VAL     PV value
%
%   'STS'           all of the above plus 
%                   STAT    Alarm status
%                   SEVR    Alarm severity
%
%   'TIME'          all of the above plus
%                   TIME    EPICS time (1-by-2) vector  
% 
%   See also: MCAGET

if nargin==1
    rstruct.VAL = mcaget(varargin{1});
elseif nargin ==2
    switch lower(varargin{2})
    case 'sts'
        OptionCode = 1;
    case 'time'
        OptionCode = 2;
    otherwise
        OptionCode = 0;
    end
    % NOT IMPLEMENTED
    % rstruct = mcamain(60,varargin{1},OptionCode);    
end