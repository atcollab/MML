function varargout=watch_klystron_output(varargin)
% function varargout=watch_klystron_output(varargin)
%
% Temporary watchdog to protect RF overpower conditions

disp('Monitoring cavity power levels, klystron output and beam current to watch for overpower condition ...');
while 1
    Rfoutput = getpvonline('SR03S___RFAMP__AM01');
    beamcurr = getdcct;
    cav1pow = getpvonline('SR03S___C1CELL_AM03');
    cav2pow = getpvonline('SR03S___C2CELL_AM03');
    if (cav1pow>50) | (cav2pow>50) | ((beamcurr<20) & (Rfoutput>160))
        setpvonline('SR03S___RFAMP__AC01',0);
        setpvonline('SR03S___RFCONT_BC23',0);
        warning('Power interlock tripped ... setting RF amplitude to zero and turning RF power OFF!');
        soundchord;soundchord;soundchord;
    end
    pause(0.1);
end