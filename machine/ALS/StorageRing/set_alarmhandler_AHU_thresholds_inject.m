function set_alarmhandler_AHU_thresholds_inject

% function set_alarmhandler_AHU_thresholds_inject
%
% This function changes some EPICS PV limit fields (.LOLO, .LOW, .HIGH, .HIHI)
% so that the alarm handler behaves properly (read: does not incessantly alarm!)
%
% 2006-03-24 created by T.Scarvie
%
% 2007-02-20 modified by C. Steier


%AHU Temps
try
    disp('   Setting AHU Temperature limits so that no false alarms happen during injection');
    scaput('SR01C___AHUT___AM00.HIGH', 23); scaput('SR01C___AHUT___AM00.HIHI', 24);
    scaput('SR03C___AHUT___AM00.HIGH', 23); scaput('SR03C___AHUT___AM00.HIHI', 24);
    scaput('SR04C___AHUT___AM00.HIGH', 23); scaput('SR04C___AHUT___AM00.HIHI', 24);
    scaput('SR06C___AHUT___AM00.HIGH', 23); scaput('SR06C___AHUT___AM00.HIHI', 24);
    scaput('SR07C___AHUT___AM00.HIGH', 23); scaput('SR07C___AHUT___AM00.HIHI', 24);
    scaput('SR08C___AHUT___AM00.HIGH', 23); scaput('SR08C___AHUT___AM00.HIHI', 24);
    scaput('SR09C___AHUT___AM00.HIGH', 24); scaput('SR09C___AHUT___AM00.HIHI', 25);
    scaput('SR11C___AHUT___AM00.HIGH', 25); scaput('SR11C___AHUT___AM00.HIHI', 26);
catch
    disp('   Trouble Setting AHU temp limits!');
end
