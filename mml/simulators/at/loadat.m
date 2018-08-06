function loadat
%LOADAT - reload AT model using AD.ATModel

AD = getappdata(0,'AcceleratorData');
eval(AD.ATModel)
disp(['   Finished loading AT model ',AD.ATModel]);
