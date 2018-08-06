
ChannelCell = {
'LN______MD1____BM05', 'KY1 FOCUS'
'LN______MD1____BM07', 'PFN TUBE FIL T/O'
'LN______MD1____BM06', 'KY1 FIL. TIMEOUT'
'LN______MD1TRG_BM02', 'TRIGGER ON'
'LN______MD1HV__BM03', 'MD1HV ON MONITOR'
'LN______MD1INT_BM06', 'TRIGGER READY'
'LN______MD1____BM05', 'KY1 FOCUS'
'GTL_____SHB1_HVBM19', 'HV READY'
'GTL_____SHB1_PHBM16', 'PULSING ON'

% mod
'LN______MD1HV__BM04', 'MD1HV READY'
'LN______MD1RST_BC23', 'RESET'
'LN______MD1____BC23', 'MOD1 START/STOP'
'LN______MD1HV__AC02', 'HV CHARGE REF'
'LN______MD1HV__BC22', 'MD1HV ON/OFF'
'LN______MD1TRG_BC21', 'TRIGGER ON/OFF'


% reset
'LN______MD1RST_BC23', 'RESET'
'LN______MD1RST_BM05', 'RESET FAULT???'

% eg_HV
'EG______HV_____BM14', 'HV_ON_BM'
'EG______HV_____BM15', 'HV_RDY_BM1'
'EG______HV_____AC00', 'LI0130_P65_C'
'EG______HV_____AM00', 'LI0147_TS1_4'
'EG______HV_____BC23', 'HV_ON/OFF'

% sub_harmonic
'GTL_____SHB1_HVAC01', '125MHZ HV REF.'
'GTL_____SHB1_HVAM01', '125MHZ HV MON.'
'GTL_____SHB1_HVBC23', 'HV ON/OFF'
'GTL_____SHB1_PHBC22', 'PULSING ON/OFF'
'GTL_____SHB1_PHBM16', 'PULSING ON'
'GTL_____SHB1_PHBM17', 'PULSING READY'
};


ChannelNames = cell2mat(ChannelCell(:,1));

% Print starting point
DataChar = getpv(ChannelNames, 'char');
fprintf('   Starting Values\n');
for i = 1:size(ChannelNames,1)
    fprintf('%20s  %s  (%s)\n', ChannelCell{i,2}, DataChar(i,:), ChannelCell{i,1})
end


T = 3*60;    % Total time [seconds]
dt = 1;      % Update period [seconds]

t = 0:dt:T;
t0 = clock;

% Just a warm up
Data = getpv(ChannelNames);

fprintf('\n   Monitoring for %f minutes\n\n', t(end)/60);

t00 = gettime;
for i = 1:length(t)

    Data(:,i) = getpv(ChannelNames);
    tout(1,i) = gettime-t00;
    
    if i < length(t)
        pause(t(i+1) - (gettime-t00));
    end
end

tend = clock;

% Print end point
DataChar = getpv(ChannelNames, 'char');
fprintf('   End Values\n');
for i = 1:size(ChannelNames,1)
    fprintf('%20s  %s  (%s)\n', ChannelCell{i,2}, DataChar(i,:), ChannelCell{i,1})
end





