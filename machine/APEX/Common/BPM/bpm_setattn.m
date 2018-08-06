function bpm_setattn(Prefix, RFAttn)

if nargin < 1 || isempty(Prefix)
    Prefix = getfamilydata('BPM','BaseName');
end
if nargin < 2  || isempty(RFAttn)
    % Just a start
    if getdcct < 40
       RFAttn = 0;    % Multibunch
      % RFAttn = 12;   % 2-bunch
    elseif getdcct < 60
        RFAttn = 4;
    elseif getdcct < 100
        RFAttn = 8;
    elseif getdcct < 350
        RFAttn = 19;
    elseif getdcct < 510
        RFAttn = 22;
    else
        RFAttn = 31;
    end
    
    % For the new BPMs compared to the old 3A
    %RFAttn = RFAttn - 8;
end

if ischar(Prefix)
    bpm_setattn1(Prefix, RFAttn)
elseif iscell(Prefix)
    for i = 1:length(Prefix)
        bpm_setattn1(Prefix{i}, RFAttn)
    end
else
    % DeviceList input
    DeviceList = Prefix;
    Prefix =  getfamilydata('BPM','BaseName', DeviceList);
    for i = 1:length(Prefix)
        bpm_setattn1(Prefix{i}, RFAttn)
    end
end



function bpm_setattn1(Prefix, RFAttn)

% Attenuation tweaks
if length(Prefix)>=10 && strcmpi(Prefix, 'SR01C:BPM4') 
    % DAT removed on channel A=c3
     RFAttn = 0;
     fprintf('        %s attenuation set to 0 (%d)\n', Prefix, RFAttn);
elseif length(Prefix)>=10 && strcmpi(Prefix, 'SR04C:BPM7') 
    % 2 amp modified (all BPMs will eventually be 2 Amps)
     RFAttn = RFAttn - 6;
     fprintf('        Decreasing %s attenuation by 6 (%d)\n', Prefix, RFAttn);
elseif length(Prefix)>=10 && strcmpi(Prefix(10), '8')    %|| strcmpi(Prefix{i}, 'SR01C{BPM:1}') || strcmpi(Prefix{i}, 'SR02C{BPM:8}') || strcmpi(Prefix{i}, 'SR03C{BPM:1}')
     RFAttn = RFAttn + 2;
     fprintf('        Increasing %s attenuation by 2 (%d)\n', Prefix, RFAttn);
end
RFAttn = round(RFAttn);
if RFAttn < 0
    RFAttn = 0;
elseif RFAttn > 31
    RFAttn = 31;
end
if ~isempty(RFAttn)
    setpvonline([Prefix,':attenuation'], RFAttn);
end




