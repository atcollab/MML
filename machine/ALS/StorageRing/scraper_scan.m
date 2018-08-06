function scrascan_2013(ScraperStr, FileName, PosVector)
%  scrascan_2013(ScraperStr, Filename, PosVector)
%
%  FileName = input or output filename
%  ScraperStr = which scraper (horizontal, top, bottom, new)
%  Scraper Positions (vector)
%
%  Inputs left blank will be prompted for at run time.
%

if nargin < 1
    ScraperStr = input('  Which scraper (hor, top, bot, jh12_6t, jh01_1t, jh01_1b, jh02_1t, jh02_1b, jh02_6t)? ','s');
end

%set labca retry count to avoid timeouts for scrapers
retry0 = lcaGetRetryCount;
retry = 200;
fprintf('  Setting LabCA retry count to %i to prevent scraper timeouts\n', retry);
lcaSetRetryCount(retry);

try
    setpv('SR12C___SCRAP6TAC01.VELO',.5);
    setpv('SR01C___SCRAP1TAC01.VELO',.5);
    setpv('SR01C___SCRAP1BAC01.VELO',.5);
    setpv('SR02C___SCRAP1TAC01.VELO',.5);
    setpv('SR02C___SCRAP1BAC01.VELO',.5);
    setpv('SR02C___SCRAP6TAC01.VELO',.5);
catch
    disp('Trouble setting velocities to 0.5mm/s');
end

if strcmp(ScraperStr,'hor')
    PosVector = [52 53 54:0.5:56 56.2:0.2:57.6 57.6:0.1:60]*1000;
    % PosVector = [-25:10:-15 -10:2:-8 -7:0.5:-6.0 -5.5:0.1:-1.0];
    % PosVector = -1./sqrt([0.002:0.002:0.10]);
elseif strcmp(ScraperStr,'top')
    PosVector = [11.5 12.5 13.5:0.5:16.5 16.7:0.2:17.5]*1000;
    % PosVector = [11.5 12.5 13.5:0.5:16.5 16.7:0.2:17.5 17.6 17.7 17.75 17.8 17.81:0.01:17.85 17.855:0.005:18]*1000;
    % PosVector = [6 5.5 5 4.5:-0.5:3 2.8:-0.2:1.4 1.2:-0.1:-1.0];
    % PosVector = 1./sqrt([0.011 0.05 0.1:0.2:2.9  3.0:0.5:30])-0.6;
elseif strcmp(ScraperStr,'bot')
    PosVector = ([11.5 12.5 13.5:0.5:16 16.2:0.2:17.4 17.6:0.1:19.0]+3)*1000;
    % PosVector = [-7:2:-5 -4.5:0.5:-3 -2.8:0.2:-1.6 -1.4:0.1:1.0];
    % PosVector = [-6 -5.5 -5 -4.5:0.5:-3 -2.8:0.2:-1.4 -1.2:0.1:1.0]-1.4;
    % PosVector = -1./sqrt([0.011 0.05 0.1:0.2:2.9  3.0:0.5:30])+0.6;
elseif strcmp(ScraperStr,'jh12_6t')
    PosVector = [4.5 3.5 2.5 2.0 1.5 1.0 0.5 0];
elseif strcmp(ScraperStr,'jh01_1t')
    PosVector = [4.5 3.5 2.5 2.0 1.5 1.0 0.5 0];
elseif strcmp(ScraperStr,'jh01_1b')
    PosVector = [6.0 5.0 4.0 3.0 2.5 2.0 1.5 1.0 0.5 0];
elseif strcmp(ScraperStr,'jh02_1t')
    PosVector = [5.5 4.5 3.5 2.5 2 1.5 1 0.5 0];
elseif strcmp(ScraperStr,'jh02_1b')
    PosVector = [4.5 3.5 2.5 2.0 1.5 1.0 0.5 0];
elseif strcmp(ScraperStr,'jh02_6t')
    PosVector = [8.5 7.5 6.5 5.5 4.5 3.5 2.5 2 1.5 1 0.5 0];
else
    disp('Wrong input argument (must be ''hor'',''bot'', ''top'', or ''jhxx_x'')' );
end

if nargin < 2
    FileName = input('  Output file name (no file extension) = ','s');
end

if nargin < 3
    disp(' '); disp(['  Default position vector:  ']); PosVector
    PosVectorInput = input('  Input scraper position vector (return for default) = ');
    if ~isempty(PosVectorInput)
        PosVector = PosVectorInput;
    end
end

Time2 = [];
DCCT2 = [];
PressIG = [];
PressIP = [];
LossRate =[];

TimeOfExperiment = clock;
DateOfExperiment = date;

my_setscrap;  % open all scrapers
Scraper0 = my_getscrap(ScraperStr);


% For scaIII startup
getx;gety;getdcct;

setpv('IonGauge','Status',0,[12 1]);
setpv('IonPump','Status',0,[11 6]);

n=0;


for NewPosH = PosVector
    
    n=n+1;
    % Change Scraper Position
    try
        err=my_setscrap(ScraperStr, NewPosH);
    catch
        disp('  Scraper seems to have hit limit switch ... Ending measurement');
        break;
    end;
    
    if err == 1
        disp('  Scraper seems to have hit limit switch ... Ending measurement');
        break;
    end;
    
    sleep(1.);
    
    fprintf('%s scraper at %g mm\n', ScraperStr, my_getscrap(ScraperStr)/1000);
    
    x(:,n) = getam('BPMx',getbpmlist('Bergoz'));
    y(:,n) = getam('BPMy',getbpmlist('Bergoz'));
    TimeS(n) = gettime;
    
    tmpcurr = getdcct2;
    
    if tmpcurr < 10
        lifetime = getlife2(0.01);
    else
        lifetime = getlife2(0.01);
    end
    
    Lifetime(n) = lifetime;
    InitialC(n)  = tmpcurr;
    %     Lifeerror(n) = c;
    %     Time2 = [Time2, d'];
    %     DCCT2 = [DCCT2, e'];
    
    Scraper(n,1) = my_getscrap(ScraperStr);
    PressIG = [PressIG; getpressure(1)];
    PressIP = [PressIP; getpressure(2)];
    %LossRate = [LossRate; getblm];
    
    % save data
    save(FileName,'Lifetime','TimeS','x','y','Scraper','PressIG','PressIP','InitialC');
    
    figure(1); clf
    plot(Scraper,Lifetime,'x');
    xlabel('Scraper Position [mm]');
    ylabel('Lifetime [h]');
    title(sprintf('Scraper %s', ScraperStr));
    
    % Break out of the program if the current drops below a 0.5 mA
    if (getdcct < .5)
        disp('  Beam current dropped to zero');
        break;
    end;
end

my_setscrap(ScraperStr, PosVector(1));

% reset all scrapers
my_setscrap

try
    setpv('SR12C___SCRAP6TAC01.VELO',.1);
    setpv('SR01C___SCRAP1TAC01.VELO',.1);
    setpv('SR01C___SCRAP1BAC01.VELO',.1);
    setpv('SR02C___SCRAP1TAC01.VELO',.1);
    setpv('SR02C___SCRAP1BAC01.VELO',.1);
    setpv('SR02C___SCRAP6TAC01.VELO',.1);
catch
    disp('Trouble setting velocities to 0.5mm/s');
end
try
    eval(['load ', FileName]);
    
    % Plot data
    figure(1); clf
    plot(Scraper,Lifetime,'x');
    xlabel('Scraper Position [mm]');
    ylabel('Lifetime [h]');
    axis tight
    title(sprintf('Scraper %s', ScraperStr));
    orient tall
catch
    disp('  Error loading file for analysis...');
end

fprintf('  Setting LabCA retry count back to %i \n', retry);
lcaSetRetryCount(retry0);

disp('  Measurement complete.');
soundtada