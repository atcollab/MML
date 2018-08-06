function tune2sim
%TUNE2SIM - Sets the TUNE family to simulator mode
%
%  See also tune2manual, tune2online

% Make sure there is a tune family
if isfamily('TUNE')
    setfamilydata('Simulator','TUNE','Monitor','Mode');
    disp('   Middlelayer TUNE has been switched to simulator mode.');
else
    disp('   TUNE is not a family');
end
