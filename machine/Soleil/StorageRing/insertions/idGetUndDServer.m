function [DServName, StandByStr] = idGetUndDServer(idName)

DServName = '';
StandByStr = ''; %String to search in the return of "Status" command of DServer

if strcmp(idName, 'HU80_TEMPO')
    DServName = 'ANS-C08/EI/M-HU80.2'; %Name of Level 2 DServer
    StandByStr = 'ANS-C08/EI/M-HU80.2_MotorsControl : STANDBY'; 
elseif strcmp(idName, 'HU80_PLEIADES')
    %DServName = 'ANS-C04/EI/M-HU80.2'; %Name of Level 2 DServer
    %StandByStr = 'ANS-C04/EI/M-HU80.2_MotorsControl : STANDBY'; 
    DServName = 'ANS-C04/EI/M-HU80.1'; %Name of Level 2 DServer
    StandByStr = 'ANS-C04/EI/M-HU80.1_MotorsControl : STANDBY'; 
elseif strcmp(idName, 'HU80_CASSIOPEE')
    DServName = 'ANS-C15/EI/M-HU80.1'; %Name of Level 2 DServer
    StandByStr = 'ANS-C15/EI/M-HU80.1_MotorsControl : STANDBY'; 
elseif strcmp(idName, 'U20_PROXIMA1')
    DServName = 'ANS-C10/EI/C-U20'; %Name of Level 2 DServer
    StandByStr = 'ANS-C10/EI/C-U20_MOTORSCONTROL: 	STANDBY'; 
elseif strcmp(idName, 'U20_SWING')
    DServName = 'ANS-C11/EI/C-U20'; %Name of Level 2 DServer
    StandByStr = 'ANS-C11/EI/C-U20_MOTORSCONTROL: 	STANDBY'; 
elseif strcmp(idName, 'U20_CRISTAL')
    DServName = 'ANS-C06/EI/C-U20'; %Name of Level 2 DServer
    StandByStr = 'ANS-C06/EI/C-U20_MOTORSCONTROL: 	STANDBY';
elseif strcmp(idName, 'HU640_DESIRS')
    DServName = 'ANS-C05/EI/L-HU640'; %Name of Level 2 DServer
    %StandByStr = '- ANS-C05/EI/L-HU640_PS1: 	ON\n- ANS-C05/EI/L-HU640_PS2: 	ON\n- ANS-C05/EI/L-HU640_PS3: 	ON'; 
    StandByStr = '- ANS-C05/EI/L-HU640_PS1: 	ON'; %to correct later!!!
end

