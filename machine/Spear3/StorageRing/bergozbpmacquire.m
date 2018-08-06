function bpmData = bergozbpmacquire( crateNum, delay )
% function bpmData = bergozbpmacquire( crateNum, delay )
% bergozbpmacquire obtains data from the crate in one of the pits
%  with a set delay after the trigger
% the data is returned in a three dimensional array
%   first dimension is the data type for each bpm
%   second dimension is the bpm number
%   third dimension is the time
% 
% crateNum   0=116; 1=132
% delay      delay from start of buffer;  1 is minimum number
% bpmData    three dimensional array of data returned

if ( (crateNum ~= 0) && (crateNum ~= 1) ),
    error( 'crateNum must be 0 (116) or 1 (132)' );
end % if ( (crateNum ~= 0) && (crateNum ~= 1) ),
if ( (delay < 1) || (delay > 4000) ),
    error( 'delay limits are 1 and 4000' );
end % if ( (delay < 1) || (delay > 4000) ),

if ( crateNum == 0 ),
    queryString = '116-BPM:history';
else
    queryString = '132-BPM:history';
end % if ( crateNum == 0 ),

lcaPut( [queryString, '.RARM'], 1 );
bpmData = lcaGet( queryString );
bpmData = reshape( bpmData, [4, 56, 4000] );