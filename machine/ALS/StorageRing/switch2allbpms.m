function switch2allbpms(DisplayFlag)
%SWITCH2ALLBPMS - Set BPMx & BPMy status flag to ALL BPMs
%
%  NOTES
%  1. switch2allbpms; may do more than reverse switch2bergoz;
%     because switch2allbpms makes all status values 1. 

setfamilydata(ones(size(family2dev('BPMx',0),1),1), 'BPMx','Status');
setfamilydata(ones(size(family2dev('BPMy',0),1),1), 'BPMy','Status');

if nargin >= 1 && strcmpi(DisplayFlag,'Display')
    disp('   Using all BPM''s.');
end