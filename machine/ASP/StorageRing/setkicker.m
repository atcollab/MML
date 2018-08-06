function varargout = setkicker(varargin)

if nargin > 0 && ischar(varargin{1})
    cmd = varargin{1};
else
    error('Usage : setkicker (on/off)');
end

pvname = {...
    'SR14KPS01:OFF_ON_CMD';
    'SR01KPS01:OFF_ON_CMD';
    'SR01KPS02:OFF_ON_CMD';
    'SR02KPS01:OFF_ON_CMD';};

switch cmd
    case 'on'
        kval = 2;
    case 'off'
        kval = 1;
    otherwise
        error(sprintf('Unknown option: %s',cmd));
end

% Turn trigger off first before turning on or off the kickers
trigh = mcaopen('SR00TRG01:INJ_TRIGGER_CMD');
mcaput(trigh,2);
% Turn off septum
seph = mcaopen('PS-SEP-3:OFF_CMD');
seih = mcaopen('PS-SEI-3:OFF_CMD');
mcaput(seph,1); pause(0.2); mcaput(seph,0);
mcaput(seih,1); pause(0.2); mcaput(seih,0);
pause(0.2);
mcaclose(seph);
mcaclose(seih);

pause(1.5);
for i=1:length(pvname)
    hh = mcaopen(pvname{i});
    mcaput(hh,kval);        % Doesn't always turn on the kicker at first attempt
    if (hh ~= kval)         % but after three attempts its almost always going.
        mcaput(hh,kval);
    end
    if (hh ~= kval)
        mcaput(hh,kval);
    end
    if (hh ~= kval)
        mcaput(hh,kval);
    end
    if (hh ~= kval)
        mcaput(hh,kval);
    end
    pause(0.2);
    mcaclose(hh);
end
pause(1.5);
% Turn on septum
seph = mcaopen('PS-SEP-3:ON_CMD');
seih = mcaopen('PS-SEI-3:ON_CMD');
mcaput(seph,1); pause(0.2); mcaput(seph,0);
mcaput(seih,1); pause(0.2); mcaput(seih,0);
pause(0.2);
mcaclose(seph);
mcaclose(seih);
pause(3);
mcaput(trigh,1);
mcaclose(trigh);