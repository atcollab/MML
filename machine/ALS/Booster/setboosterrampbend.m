function setboosterrampbend(T, Waveform, TableName, egul, eguf, IOCName)
%SETBOOSTERRAMPBEND - Set the booster BEND magnet ramp table (miniIOC)
%  setboosterrampbend(T, Waveform, TableName, egul, eguf, IOCName)
%  setboosterrampbend('Zero') -> Zero the BEND table
%
%  INPUTS
%  1. T         - Time period for the Waveform [seconds]
%                 The maximum period for a 10,000 point table is
%                 2^15*10000*10e-9 = 3.2768 seconds
%  2. Waveform  - BEND waveform relative to egul, eguf
%  3. TableName - Optional input to specify a table name [string]
%  4. egul      - Lower voltage minimum {Default:-10}
%  5. eguf      - Upper voltage maximum {Default: 10}
%  6. IOCName   - Optional override of 'BE0101-1.als.lbl.gov'
%
%  NOTES
%  1. Calls rampgentableload.c which in turn call the subroutine
%     rampgenTableLoad.  mex rampgentableload.c will recompile both.
%
%  See also setboosterrampsf, setboosterrampsd, setboosterrampqf, setboosterrampqd, setboosterramprf

%  Written by Greg Portmann

NewControllerFlag = 1;

% Time period of the ramp [seconds]
% Tdefault =  .8;  % 1 second ramp period
Tdefault =  1.17;  % 1 second ramp period
% Tdefault = 1.6;  % 2 second ramp period


if nargin < 1
    T = Tdefault;
end


% String commands
DisplayOnly = 0;
DisplayFlag = 1;
if ischar(T)
    %     if any(strcmpi(T, {'Zero','Zeros','Stop'}))
    %         setboosterrampbend(.8, zeros(1,10000), 'Zero table set by Matlab', -10, 10);
    %     elseif strcmpi(T, 'Off')
    %         setpv('BE0101-1:ENABLE_RAMP', 0);
    %         fprintf('   Ramping for BEND disabled (BE0101-1:ENABLE_RAMP=0).\n');
    %     elseif strcmpi(T, 'On')
    %         setpv('BE0101-1:ENABLE_RAMP', 1);
    %         fprintf('   Ramping for BEND enabled (BE0101-1:ENABLE_RAMP=1).\n');
    %     else
    if strcmpi(T, 'DisplayOnly')
        DisplayOnly = 1;
        T = Tdefault;
    elseif strcmpi(T, 'Display')
        DisplayFlag = 1;
        T = Tdefault;
    elseif strcmpi(T, 'NoDisplay')
        DisplayFlag = 0;
        T = Tdefault;
    else
        error('Unknown command');
    end
    %     end
    %     return;
end


if NewControllerFlag
    % New power supply controller
    % Make a table
       
    [BEND_Ramp_Table] = getgoldenramptablebend;
      
    % Plot
    if DisplayFlag
        Npts = length(BEND_Ramp_Table);
        t = (0:Npts-1)/97560;  % Table running at 97.56 kHz, 10.25us
        plot(t, BEND_Ramp_Table);
        xlabel('Time [Seconds]');
        ylabel('[DAC Counts]');
        title(sprintf('BEND Waveform, %d Points in Table', Npts));
        drawnow;
    end
    
    if DisplayOnly
        return;
    end
    
    fprintf('   Updating the BR BEND table ... ');
    tic;
    % save -ascii 'booster_bend_ramptable.txt' BEND_Ramp_Table
        lcaPut('BR1:B:SET_TABLE_LEN',length(BEND_Ramp_Table));
        lcaPut('BR1:B:RAMPSET', BEND_Ramp_Table, 'native');
% With new controller epics interface by Eric Norum, SWAP_TABLE is not necessary anymore, C. Steier, 2011-07-14
    % setpv('BR1:B:SWAP_TABLE', 1);
    fprintf(' complete (%.1f sec to download table) %s\n', toc, datestr(now,31));
    
else
    
    
    % Default waveform
    if nargin < 2
        % For testing
        %Amp = 9;
        %Npts = 10000;
        %Waveform = Amp * triang(Npts) + 0.05;
        
        Waveform = load('/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20071031/minioc_waveform_data_20081008.mat', 'bend_new2');
        Waveform = Waveform.bend_new2/.9 - 0.0059;
    end
    
    Npts = length(Waveform);
    
    if nargin < 3
        TableName = sprintf('BEND Table from Matlab (%s)', computer);
    end
    
    if nargin < 4
        egul = -10;
    end
    
    if nargin < 5
        eguf = 10;
    end
    
    if nargin < 6
        IOCName = 'be0101-1.als.lbl.gov';
    end
    Channel = 0;
    
    
    % Sample period = Ndelay*10 nanosecond
    % Ndalay must be an integer < 2^15
    Ndelay = T / Npts / 10e-9;
    
    if abs(round(Ndelay) - Ndelay) > 1e-10
        % Only warn on small issues, not really small issues.
        fprintf('   Rounding the number of 10 nsec delay steps to an integer.\n');
    end
    Ndelay = round(Ndelay);
    
    if Ndelay > (2^15 - 500)   % The 500 is just some margin
        error('The number of delay counts between table points is too large, %d, (greater than 2^15)', Ndelay);
    end
    
    
    % Make a table
    t = linspace(0, T, Npts);
    
    
    % Plot
    if DisplayFlag
        plot(t, Waveform);
        xlabel('Time [Seconds]');
        ylabel('[Volts]');
        title(sprintf('BEND Waveform, %d Points in Table,  %d Delay Counts', Npts, Ndelay));
    end
    
    if DisplayOnly
        return;
    end
    
    % Last chance to say no
    % tmp = questdlg('Change the booster BEND ramp table?','setboosterrampbend','Yes','No','No');
    % if ~strcmpi(tmp,'Yes')
    %     fprintf('   No change made to booster BEND ramp table.\n');
    %     return
    % end
    
    
    %%%%%%%%%%%%%%
    % Initialize %
    %%%%%%%%%%%%%%
    
    % Disable the ramp so that the number of points can be changed and the DAC can be enabled
    setpv('BE0101-1:ENABLE_RAMP', 0);
    %pause(.25);
    
    % Enable the DAC
    setpv('BR1_____B_IE_REBC00', 1);
    
    % Set the gain
    Gain = 0.2;
    % setpv('BR1_____B_IE_GNAC00', Gain);
    
    % The the number of points and number of delay steps between points
    % Don't change the Npts without the ramp disabled
    setpv('BE0101-1:SET_TABLE_LEN',   Npts);
    setpv('BE0101-1:SET_TABLE_DELAY', Ndelay);
    
    % Enable the ramping
    setpv('BE0101-1:ENABLE_RAMP', 1);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Set the BEND ramp table %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % If egul = 10 & eguf= -10, the waveform is in volts
    rampgentableload(Waveform, IOCName, Channel, TableName, egul, eguf)
    
    
    % Swap the tables
    %pause(.25);
    setpv('BE0101-1:SWAP_TABLE', 1);
    %pause(.25);
    
    
    
    % Check the final states
    fprintf('   BR1_____B_IE_REBC00      = %d\n', getpv('BR1_____B_IE_REBC00'));
    fprintf('   BR1_____B_IE_GNAC00      = %d\n', getpv('BR1_____B_IE_GNAC00'));
    fprintf('   BE0101-1:ENABLE_RAMP     = %d\n', getpv('BE0101-1:ENABLE_RAMP'));
    fprintf('   BE0101-1:SET_TABLE_LEN   = %d\n', getpv('BE0101-1:SET_TABLE_LEN'));
    fprintf('   BE0101-1:SET_TABLE_DELAY = %d\n', getpv('BE0101-1:SET_TABLE_DELAY'));
    fprintf('   BE0101-1:SWAP_TABLE      = %d\n', getpv('BE0101-1:SWAP_TABLE'));
end