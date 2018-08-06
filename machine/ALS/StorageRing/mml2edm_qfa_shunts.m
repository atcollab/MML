function mml2edm_qfa_shunts(Directory)

DirStart = pwd;

if nargin < 1
    if ispc
        cd \\Als-filer\physbase\hlc\SR
    else
        cd /home/als/physbase/hlc/SR
    end
else
    cd(Directory);
end




%%%%%%%%%%%%%%%%%%%%%%%
% Main Power Supplies %
%%%%%%%%%%%%%%%%%%%%%%%
FileName = 'MML2EDM_QFA_SHUNTS.edl';
TitleBar = 'SR - QFA Shunts';
EyeAide = 'On';
WindowLocation = [120 60];
GoldenSetpoints = 'On';
MotifWidget = 'Off';
fprintf('   Building %s (%s)\n', TitleBar, FileName);

DeviceList = family2dev('QFA', 0, 0);

[x11, y11]= mml2edm(...
    'QFA', ...
    'Fields', {'Shunt1Control', 'Shunt1', 'Shunt2Control', 'Shunt2'}, ...
    'DeviceList', DeviceList, ...
    'ScaleColumnWidth', 1.75, ...
    'EyeAide', EyeAide, ...
    'FileName', FileName, ...
    'xStart', 0, ...
    'yStart', 0, ...
    'WindowLocation', WindowLocation, ...
    'GoldenSetpoints', GoldenSetpoints, ...
    'MotifWidget', MotifWidget, ...
    'TableTitle', 'QFA Shunts', ...
    'TitleBar', TitleBar);


%%%%%%%%%%%%%%%
% Exit Button %
%%%%%%%%%%%%%%%
%ExitButton = EDMExitButton(x11-68, 3, 'FileName', FileName,'ExitProgram');
                    


% % Update the header
% xmax = max([x11 x12]);
% ymax = max([y11 y12]);
% Width  = xmax + 10;
% Height = ymax + 10;
% Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', Width, 'Height', Height);


cd(DirStart);



% if  ymax > 1200 %  I'm not sure when the slider appears
%     % To account for a window slider
%     Width  = xmax+30;
%     Height = 1220;
% else
%     Width  = xmax + 10;
%     Height = ymax + 10;
% end



