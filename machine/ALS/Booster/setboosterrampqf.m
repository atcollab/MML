function setboosterrampqf(T, Waveform, TableName, egul, eguf, IOCName)
%SETBOOSTERRAMPQF - Set the booster QF magnet ramp table (miniIOC)
%  setboosterrampqf(T, Waveform, TableName, egul, eguf, IOCName)
%  setboosterrampqf('Zero') -> Zero the BEND table
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
%  See also setboosterrampsf, setboosterrampsd, setboosterrampqd, setboosterrampbend, setboosterramprf

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
    %     end
    %     return;
end


if NewControllerFlag
    % New power supply controller
	
	% The newest 100 point correction table PVs are BR1:QF:RAMPCORR, BR1:QD:RAMPCORR (16-bit)
	
    % Make a table    
    
    % Get the 100 point linearity correction table
    QFsmallnew = getpv('QF','ILCTrim');
    
    
    % New table
 %   BR_QF_SmallTable_New = round(((2^15-1)/3) * QFsmallnew);
 %   lcaPut('BR1:QF:RAMPCORR', BR_QF_SmallTable_New, 'int32');
 %   setpv('BR1:QF:SWAP_TABLE', 1);
 %   return

    
    
    % Scale the linearity correction to the first 4.4e4 points.
    % Linear ramp a delta on the setpoint every 440 points
    NN = 440;
    DelQF = zeros(1,131072);
    for i = 1:length(QFsmallnew)-1
        a = linspace(QFsmallnew(i), QFsmallnew(i+1), NN);
        DelQF(1+(i-1)*NN:i*NN) = a;
    end
    
    % Force the last point to be the same as the first by slowly ramping it
    %iNext = (length(QFsmallnew)-1)*NN + 1;
    %NN = length(DelQF) - iNext + 1;
    %a = linspace(QFsmallnew(end), QFsmallnew(1), NN);
    %DelQF(iNext:end) = a;

    % Force the last point to be the same as the first by ramping at the end, then constant
    NN = 5000;
    a = linspace(QFsmallnew(end), QFsmallnew(1), NN);
    DelQF(end-2*NN:end-NN-1) = a;
    DelQF(end-NN:end) = QFsmallnew(1);

    % Scale factor for 1 unit of Hiroshi's application
    DelQF = 10000 * DelQF;
    
    BR_QF_Ramp_Table = getgoldenramptablequad;
    
    %BR_QF_Ramp_Table_New = round(0.832/0.96993*(BR_QF_Ramp_Table + DelQF + 1.2e4));
    BR_QF_Ramp_Table_New = round(BR_QF_Ramp_Table + DelQF);    

    % Plot
    if DisplayFlag
        Npts = length(BR_QF_Ramp_Table_New);
        t = (0:Npts-1)/97560;  % Table running at 97.56 kHz, 10.25us
        plot(t, BR_QF_Ramp_Table_New);
        xlabel('Time [Seconds]');
        ylabel('[DAC Counts]');
        title(sprintf('QF Waveform, %d Points in Table', Npts));
        drawnow;
    end
    
    if DisplayOnly
        return;
    end
    
    fprintf('   Updating the BR QF table ... ');
    tic;
    %save -ascii 'booster_qf_ramptable.txt' BR_QF_Ramp_Table_New
    %lcaPut('BR1:QF:RAMPSET', BR_QF_Ramp_Table_New, 'long');
    lcaPut('BR1:QF:SET_TABLE_LEN',length(BR_QF_Ramp_Table_New));
    lcaPut('BR1:QF:RAMPSET', BR_QF_Ramp_Table_New, 'native');
% With new controller epics interface by Eric Norum, SWAP_TABLE is not necessary anymore, C. Steier, 2011-07-14
    %    setpv('BR1:QF:SWAP_TABLE', 1);
    fprintf(' complete (%.1f sec to download table) %s\n', toc, datestr(now,31));
    
else
    % Old mini-IOC controller
    
    % Default waveform
    if nargin < 2
        % For testing
        %Amp = 9;
        %Npts = 10000;
        %Waveform = Amp * triang(Npts) + 0.05;
        
        Waveform = load('/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20071031/minioc_waveform_data_20081008.mat','qf_ramp_20081008_2047');
        Waveform = Waveform.qf_ramp_20081008_2047;
    end
    
    Npts = length(Waveform);
    
    if nargin < 3
        TableName = sprintf('QF Table from Matlab (%s)', computer);
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
    Channel = 1;
    
    
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
        title(sprintf('QF Waveform, %d Points in Table,  %d Delay Counts', Npts, Ndelay));
    end
    
    if DisplayOnly
        return;
    end
    
    % Last chance to say no
    % tmp = questdlg('Change the booster QF ramp table?','setboosterrampqf','Yes','No','No');
    % if ~strcmpi(tmp,'Yes')
    %     fprintf('   No change made to booster QF ramp table.\n');
    %     return
    % end
    
    
    %%%%%%%%%%%%%%
    % Initialize %
    %%%%%%%%%%%%%%
    
    % Disable the ramp so that the number of points can be changed and the DAC can be enabled
    setpv('BE0101-1:ENABLE_RAMP', 0);
    %pause(.25);
    
    % Enable the DAC
    setpv('BR1_____QFIE_REBC01', 1);
    
    % Set the gain
    Gain = 0.2;
    % setpv('BR1_____QFIE_GNAC01', Gain);
    
    % The the number of points and number of delay steps between points
    % Don't change the Npts without the ramp disabled
    setpv('BE0101-1:SET_TABLE_LEN',   Npts);
    setpv('BE0101-1:SET_TABLE_DELAY', Ndelay);
    
    % Enable the ramping
    setpv('BE0101-1:ENABLE_RAMP', 1);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Set the QF ramp table %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % If egul = 10 & eguf= -10, the waveform is in volts
    rampgentableload(Waveform, IOCName, Channel, TableName, egul, eguf)
    
    
    % Swap the tables
    %pause(.25);
    setpv('BE0101-1:SWAP_TABLE', 1);
    %pause(.25);
    
    
    
    % Check the final states
    fprintf('   BR1_____QFIE_REBC01   = %d\n', getpv('BR1_____QFIE_REBC01'));
    fprintf('   BR1_____QFIE_GNAC01   = %d\n', getpv('BR1_____QFIE_GNAC01'));
    fprintf('   BE0101-1:ENABLE_RAMP     = %d\n', getpv('BE0101-1:ENABLE_RAMP'));
    fprintf('   BE0101-1:SET_TABLE_LEN   = %d\n', getpv('BE0101-1:SET_TABLE_LEN'));
    fprintf('   BE0101-1:SET_TABLE_DELAY = %d\n', getpv('BE0101-1:SET_TABLE_DELAY'));
    fprintf('   BE0101-1:SWAP_TABLE      = %d\n', getpv('BE0101-1:SWAP_TABLE'));
end

