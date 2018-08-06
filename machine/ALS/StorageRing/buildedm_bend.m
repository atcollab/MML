function buildedm_bend(Directory)


% Was under development but Haris's SuperBendDetails.edl is better



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
FileName = 'MML2EDM_BEND_EXTRA.edl';
TitleBar = 'SR - BEND';

EyeAide = 'On';
WindowLocation = [120 60];
GoldenSetpoints = 'Off';
MotifWidget = 'Off';

fprintf('   Building %s (%s)\n', TitleBar, FileName);


NameCell = {
    'SR01C___B______AC01' % ao       896.815000       DAC out             Normal successful completion
    'SR01C___B______AC00' % ao       896.815000       Set Current         Normal successful completion
    'SR01C___B______AC02' % ao         0.00000E+000   Time Constant       Normal successful completion
    'SR01C___B______AC03' % ao        10.500000       Ramp Rate           Normal successful completion
    'SR01C___B______AM00' % ai       897.591883       PS_CURRENT_MON      Normal successful completion
    'SR01C___B____R_BC22' % bo         OFF            PS_RESET_CNTRL      Normal successful completion
    'SR01C___B______BC23' % bo         ON             PS_ON/OFF_CNTRL     Normal successful completion
    'SR01C___B______BM18' % bi         ON             PS_READY_MON        Normal successful completion
    'SR01C___B______BM19' % bi         ON             PS_ON_MON           Normal successful completion
    'SR01C___B______BM00' % bi         ON             CNTRL_PWR_ON_MON    Normal successful completion
    'SR01C___B______BM01' % bi         ON             XFMR_T1_O/T         Normal successful completion
    'SR01C___B______BM02' % bi         ON             XFMR_T2_O/T         Normal successful completion
    'SR01C___B______BM03' % bi         ON             CHOKE_O/T           Normal successful completion
    'SR01C___B______BM04' % bi         ON             AC_OVER_CURRENT     Normal successful completion
    'SR01C___B______BM05' % bi         ON             DC_OVER_CURRENT     Normal successful completion
    'SR01C___B______BM06' % bi         ON             GND_FAULT_RELAY     Normal successful completion
    'SR01C___B______BM07' % bi         ON             SCR_FUSE            Normal successful completion
    'SR01C___B______BM08' % bi         ON             FILTER_CAP          Normal successful completion
    'SR01C___B______BM09' % bi         ON             DOOR_INTLK          Normal successful completion
    'SR01C___B______BM10' % bi         ON             SMOKE_DETC_ALARM    Normal successful completion
    'SR01C___B______BM12' % bi         ON             SCR_O/T             Normal successful completion
    'SR01C___B______BM13' % bi         ON             PS_H2O_FLO          Normal successful completion
    'SR01C___B______BM14' % bi         ON             MAGNET_O/T          Normal successful completion
    'SR01C___B______BM15' % bi         ON             MAGNET_H2O_FLO      Normal successful completion
    'SR01C___B______BM16' % bi         ON             SAFETY_CHAIN        Normal successful completion
    'SR01C___B____TRBM18' % bi         ON             Ready Off Notification  Normal successful completion
    'SR01C___B____TRBM19' % bi         ON             PS Off Unexpectedly  Normal successful completion
    'SR01C___B____HWBC23' % bo         ON             Hardware PS On/Off  Normal successful completion
    'SR01C___B______GS00' %  genSub                   Power Supply Control  unsupported type
    };



[x11, y11]= mml2edm( ...
    NameCell, ...
    'ColumnLabels', {''}, ...
    'ChannelLabels', NameCell, ...
    'FileName', FileName, ...
    'xStart', 5, ...
    'yStart', 5, ...
    'WindowLocation', [120 60], ...
    'MotifWidget', MotifWidget, ...
    'TitleBar', TitleBar);


