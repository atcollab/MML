function turnOnPs
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/turnOnPs.m 1.3 2007/04/24 13:37:46CST summert Exp  $
% ----------------------------------------------------------------------------------------------

button = questdlg('Are you sure you want to proceed? All BTS and SR1 supplies will reset.', ...
    'Confirmation','Yes','No ','No ');

if button == 'Yes'
    fprintf('Turning on SR1 QFAs\n')
    %setpv('QFA','On',1);
    fprintf('Turning on SR1 QFBs\n')
    %setpv('QFB','On',1);
    fprintf('Turning on SR1 QFCs\n')
    %setpv('QFC','On',1);
    fprintf('Turning on SR1 HCMs\n')
    %setpv('HCM','On',1);
    fprintf('Turning on SR1 VCMs\n')
    %setpv('VCM','On',1);
    fprintf('Turning on SR1 BEND\n')
    %setpv('BEND','On',1);

    fprintf('Turning on SR1 SDs\n')
    %setpv('SD','On',1);
    fprintf('Turning on SR1 SFs\n')
    %setpv('SF','On',1);

    fprintf('Turning on BTS Kickers\n')
    %setpv('BTSKICK','On',1, 1);
    %setpv('BTSKICK','On',1, 2);
    %setpv('BTSKICK','On',1, 3);
    %setpv('BTSKICK','On',1, 4);

    fprintf('Turning on BTS Quads\n')
    %setpv('BTSQUADS','On',1);
    fprintf('Turning on BTS Steering\n')
    %setpv('BTSSTEER','On',1);
    fprintf('Turning on BTS Bends\n')
    %setpv('BTSBEND','On',1);
    fprintf('Turning on BTS Septums\n')
    %setpv('BTSSEPT','On',1, 1);

    fprintf('   Completed \n')
else
    fprintf('   Cancelled \n')
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/turnOnPs.m  $
% Revision 1.3 2007/04/24 13:37:46CST summert 
% Added confirmation dialogue.
% Revision 1.2 2007/03/02 09:17:32CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
