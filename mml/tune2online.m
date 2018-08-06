function tune2online
%TUNE2ONLINE - Sets the TUNE family to online mode
%
% See also tune2manual, tune2sim

% Make sure there is a tune family
if isfamily('TUNE')
    setfamilydata('Online','TUNE','Monitor','Mode');
    disp('   Middlelayer TUNE has been switched to online mode.');
else
    disp('   TUNE is not a family');
end


