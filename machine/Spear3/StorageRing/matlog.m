function matlog

%%%%% SET THESE PARAMETERS FOR EACH SCRAPER RUN %%%%
%pre-allocate memory
imax=2*60*60;             %maximum number of data points (2hr, will be reduced below)
comment='User_xscraper_28mA_Nb1';
plane='x';
iwvfm=nan(imax,100); %Keithley current
twvfm=nan(imax,100); %Keithley time
iavg=nan(imax,1);    %DCCT current
pos=nan(imax,1);     %device position or voltage
POSpv='01S-SCRAPER1:XMotor.RBV';  %device position readback PV
MOVFlag=nan(imax,4); %Flag set by code indicates device moving
                     %char value stored in SPEAR:ConfigMode
DMOV=nan(imax,1);    %Scraper stop flag (integer)
DMOVpv='01S-SCRAPER1:XMotor.DMOV';
t=nan(imax,6);       %computer timestamp
delay=0.7;           %pause/delay between acquisition cycles (sec)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iwhile=1;
istep=0;
while iwhile==1
    [cur, estamp_1]=lcaget('SPEAR:DcctTrace.VAL');
    [time,estamp_2]=lcaget('SPEAR:DcctTrace.TVAL');
    if estamp_1==estamp_2
      istep=istep+1;
      ic=find(cur); cur=cur(ic); time=time(ic); len=length(ic);
      iwvfm(istep,1:len)=cur;
      twvfm(istep,1:len)=time;
      iavg(istep)=getpv('SPEAR:BeamCurrAvg');
      pos(istep)=getscraper(plane);
      MOVFlag(istep,:)=getpv('SPEAR:ConfigMode');   %'move' or 'stop' - use 'char' to evaluate
      %char(MOVFlag(istep,:))
      DMOV(istep,:)=getpv(DMOVpv);
      t(istep,:)=clock;
    else
      disp('  inconsistent EPICS timestamp in Keithley - data index does not advance')
    end
    
    iquit=getpv('SPEAR:ConfigName');
    if strcmpi(iquit,'quit') %&& istep==3
        iwhile=0;
    end
    
    
    disp(['  data acquisition step ' num2str(istep)])
    pause(delay)
end

%build data structure
    mlog.comment=comment;
    mlog.plane=plane;
    mlog.iwvfm=iwvfm(1:istep,:);
    mlog.twvfm=twvfm(1:istep,:);
    mlog.iavg=iavg(1:istep);
    mlog.pos=pos(1:istep);
    mlog.MOVFlag=MOVFlag(1:istep,:);   %'move' or 'stop' - use 'char' to evaluate
    mlog.DMOV=DMOV(1:istep,:);
    mlog.t=t(1:istep,:);


% archive data
    DirStart = pwd;
    FileName = appendtimestamp([mlog.comment '_' mlog.plane], clock);
    DirectoryName = getfamilydata('Directory','ScraperData');
    if isempty(DirectoryName)
        DirectoryName = [getfamilydata('Directory','DataRoot') 'Scraper\'];
    end
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    save(FileName, 'mlog');
    cd(DirStart);
    disp(['   Data saved in file... ' DirectoryName, '   ', FileName])
%     clear mlog
%     load(FileName)
    
