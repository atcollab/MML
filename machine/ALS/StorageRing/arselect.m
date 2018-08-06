function [y, ivec, iNotFound] = arselect(ChanName, OneChannelFlag)
%ARSELECT - Return the archived data for a group on channel names
%  [y, ivec] = arselect(ChannelName, OneChannelFlag)
%
%  INPUTS
%  1. ChannelName - name of channel to find (multiple names listed by rows)
%  2. OneChannelFlag - 0, add wild card to the end of ChannelName (default)
%                      else, search for first occurrance of ChannelName
%
%  OUTPUTS
%  1. y - data
%  2. ivec - indices in the ARChanNames matrix which match ChannelName
%
%  NOTES
%  1. If a channel name match is not found, ivec will be null and y=NaN*ones(size(ARt)).
%  2. Bad floating point data points (1.2345e-37) are converted to NaN. 
%  3. Bad booleans (256?) are left as is.

%  Written by Greg Portmann


global ARt ARData ARChanNamesCell ARNumAnalog ARNumBinary


if size(ChanName,1) > 1
    % Get data for each row
    y = [];
    ivec = [];
    iNotFound = [];
    for i = 1:size(ChanName,1)
        [ynew, ivecnew, NotFound] = arselect(ChanName(i,:));
        if NotFound
            ynew = NaN * ones(1,size(ARt,2));
            y = [y; ynew];

            iNotFound = [iNotFound; i];
        else
            y = [y; ynew];
            ivec = [ivec; ivecnew];
        end
    end
    return
end


y=[];
ivec = [];
iNotFound = [];
j = 0;
ChannelName = deblank(ChanName);
StrSize = size(ChannelName,2);

if nargin == 1
    OneChannelFlag = 0;
end

ivec=find(strncmp(ChannelName, ARChanNamesCell, StrSize));
y = ARData(ivec,:);

if OneChannelFlag
    if min(size(y))>0
        y = y(1,:);
        ivec = ivec(1);
    end
end

if isempty(ivec)
    disp(['  No match found for ', ChanName]);
    %disp('  Output data filled with NaN.');
    y = NaN * ones(1,size(ARt,2));
    iNotFound = 1;
else
    % Look for bad data (Bad floating point data = 1.2345e-37)
    for i = 1:max(size(ivec))
        ibad = find(y(i,:)>1.2344999e-37);
        iibad = find(y(i,ibad)<1.2345001e-37);
        y(i,ibad(iibad))=NaN*ones(size(iibad));

        if  isempty(iibad)==0
            disp(['  Warning:  ', num2str(max(size(iibad))),' bad data point(s) removed from ', ARChanNamesCell{ivec(i)}]);
            %ibad(iibad);
        end
    end
end


% Order the result
if length(ivec) > 1
    [NameSort, iSort] = sortrows(ARChanNamesCell(ivec));
    y = y(iSort,:);
    ivec = ivec(iSort);
end



