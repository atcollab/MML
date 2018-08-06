function ErrorFlag = setpvonline(ChannelNames, NewSP, DataType)
%SETPVONLINE - Set the online value via OPC control
%
%  ErrorFlag = setpvonline(ChannelNames, NewSP, DataType)
%
%  INPUTS
%  1. ChannelNames
%  2. NewSP - New setpoint value
%  3. DataType - 'Double', 'String', 'Vector' or 'Waveform', 'Matrix' (Presently not functional)
%
%  OUTPUTS
%  1. ErrorFlag (Presently not functional.  All errors will cause a Matlab error.)
%
%  See also setopc, getpvonline
 


if nargin < 2
    error('Must have at least two inputs');
end


% Vectorized put

% There can be multiple channel names due to "ganged" power supplies
[ChannelNames, i] = unique(ChannelNames, 'rows');

% if size(ChannelNames,1) == size(NewSP,1)
%     % ChannelNames equals the number of power supplies
% else
NewSP = NewSP(i,:);
% end


%if size(ChannelNames,1) ~= size(NewSP,1)
%    error('Size of NewSP must be equal to the DeviceList, a scalar, or the number of unique channelnames in the family');
%end


% Remove ' ' and fill with NaN latter (' ' should always be the first row)
if isempty(deblank(ChannelNames(1,:)))
    ChannelNames(1,:) = [];
    NewSP(1,:) = [];
end

% 20120726 Tip edit for uA unit from PLC
inxv=strfind(ChannelNames(1,:),'STV');
inxh=strfind(ChannelNames(1,:),'STH');

inxMPW=strfind(ChannelNames(1,:),'MPW');
inxSWLS=strfind(ChannelNames(1,:),'SWLS');

if ~isempty(inxv)||~isempty(inxh)
    
    if ~isempty(inxMPW) || ~isempty(inxSWLS)
        NewSP = NewSP;
    else
        NewSP = 1E+6*NewSP;
    end
end
%End edit

% Put data
ErrorFlag = setopc(ChannelNames, NewSP);
    
