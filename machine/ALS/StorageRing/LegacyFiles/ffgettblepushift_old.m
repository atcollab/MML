function ffgettblepushift(Sector)
% function ffgettblepushift(Sector)
%
% This function generates the feed forward tables necessary for insertion device compensation
% (longitudinal motion) of the EPUs in sector 4 or 11 using the channels of the fast, local feed forward
% system. 
%
% It allows to generate tables both for the parallel mode (circular polarization) and the antiparallel
% mode (linear polarization).
%
% Since there are no access functions for those channels similar to the ones for all normal corrector
% channels this function is written exclusively for the EPUs in sector 4+11 and cannot be directly ported
% to other EPUs in the future !
%
% Christoph Steier, April 2000

% Revision History:
%	2002-06-18 Christoph Steier, Tom Scarvie
%
%  2003-04-25 C. Steier
%		IDBPMs in sectors 1 and 3 are not used anymore since they are noisy at low beam current
%		and therefore compromise the FF tables.

alsglobe

% srinit;
checkbpmavg(2);
checkidbpmavg(2);
sca_sleep(.5);

IDBPMTol = .0003;
IDBPMIter = 5;
Navg = 1;
IDVel = 4.0;
%IDVelEPU = 16.0; %4/15/04 - speeds over 3mm/s trip the horizontal amps - work is ongoing to fix this 
IDVelEPU = 2.0; % This velocity is reset below based on which EPU is being measured
FFDate = date;
FFClock = clock;
FFGeV = GeV;


% Check/Get inputs 
if exist('GeV') == 1
    if isempty(GeV)
        disp('  Storage ring energy is unknown.  Run alsinit then run ffgettblepushift.'); disp(' ');
        return;
    end
else
    disp('  Storage ring energy is unknown.  Run alsinit then run ffgettblepushift.'); disp(' ');
    return;
end

if nargin < 1
    Sector == 4
end

if size(Sector) == [1 1]
    % input ok
else
    disp('  ffgettblepushift aborted.  Input must to a scalar.');
    return;
end

[spos, svec] = sort(IDBPMs); % [2:24 1]; % used to sort data so that IDBPM(1,1) is shown at 194.4094m, where it should be (it is upstream from injection)

% Set shift velocity so that SR11 EPU amplifiers don't trip during table generation
if Sector == 4
    IDVelEPU = 10.0;
elseif Sector == 11
    IDVelEPU = 3.0;
else
    error('  No EPU in that Sector!');
end

modechanname = sprintf('SR%02dU___ODS1M__DC00',Sector);

ModeIn = menu(str2mat(sprintf('%.1f GeV Longitudinal Table',GeV),sprintf('EPU, Sector %d             ',Sector),' ','Start table generation?'),'parallel mode','anti-parallel mode','Cancel');   
if ModeIn == 1
    EPUmode = 0;
    scaput(modechanname,EPUmode);
elseif ModeIn == 2
    EPUmode = 1;
    scaput(modechanname,EPUmode);
else
    disp('  ffgettblepushift aborted.  No changes to correctors or insertion device.');
    return
end



% Minimum and maximum gap
[GAPmin, GAPmax] = gaplimit(Sector);

%%%%%%
% Temporary to ensure that FF generation doesn't bomb for EPU4 (min gap = 14mm, but nominal min = 15mm as of 12-04)
if Sector == 4
   EPU4min = scaget('sr04u1:Vgap_target_min');
   if EPU4min > GAPmin
      scaput('sr04u1:Vgap_target_min',GAPmin);
   end
end
%%%%%%

   
disp(['  The insertion device for sector ',num2str(Sector),' has been selected.']);
disp(['                    Maximum Gap = ',num2str(GAPmax),' mm']);
disp(['                    Mimimum Gap = ',num2str(GAPmin),' mm']);


disp(['  Data collection started.  Figures 1 and 2 show the difference orbits between the maximum']);
disp(['  gap and the current gap position after the feed forward correction has been applied. ']);
disp(['  Ideally, these plots should be a straight line thru zero, however, due to orbit drift, BPM']);
disp(['  noise, and feed forward imperfections one can expect 10 or 20 microns of combined errors']);
disp(['  to accumulate before minimum gap is reached (hopefully not any more than that).']);
disp([' ']);


% Change to gaptrack directory
DirStart = pwd;
gotodata
cd gaptrack


% Create output file names
tmp = clock;
year   = tmp(1);
month  = tmp(2);
day    = tmp(3);
hour   = tmp(4);
minute = tmp(5);
seconds= tmp(6);
matfn1  = sprintf('epu%02dm%01de%.0f', Sector, EPUmode, 10*GeV);
matfn2  = sprintf('epu%02dm%01de%.0f_%4d-%02d-%02d', Sector, EPUmode, 10*GeV, year, month, day);
textfn1 = sprintf('epu%02dm%01de%.0f.txt', Sector, EPUmode, 10*GeV);
textfn2 = sprintf('epu%02dm%01de%.0f_%4d-%02d-%02d.txt', Sector, EPUmode, 10*GeV, year, month, day);


% Setup figures
Buffer = .01;
HeightBuffer = .05;

h1=figure;
set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);

h2=figure(h1+1);
set(h2,'units','normal','position',[.5+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);


% BPM list

IDBPMlist1 = IDBPMlist;   
% Remove the IDBPMs in the sector where the ID is located (plus sectors 1 and 3 which are noisy at low current).
RemoveElem = sort([find(Sector==IDBPMlist(:,1));find(IDBPMlist(:,1)==1);find(IDBPMlist(:,1)==3)]);
IDBPMlist1(RemoveElem,:) = [];

% Set gap to maximum, set velocity to maximum, FF off
setff(Sector, 0, 0); 
setid(Sector, GAPmax, IDVel, 1, 0);  
setepu(Sector, 0, 0, 0, IDVelEPU, 1, 0);  
scasleep(1);

% zero additional VME channels
setsp('HCMFF',0,[Sector-1 8;Sector 1]);
setsp('VCMFF',0,[Sector-1 8;Sector 1]);


% Set the orbit
setbumps(Sector, 1);  % No sextupole correctors
scasleep(1);


% Starting orbit and corrector magnet
[x210a, y210a] = getbpm(1, Navg);
[IDx210a, IDy210a] = getidbpm(1, Navg);
HCM00 = getsp('HCMFF',[Sector-1 8; Sector 1])';
VCM00 = getsp('VCMFF',[Sector-1 8; Sector 1])';


% Orbit at longitudinal position zero
[IDx00, IDy00] = getidbpm(1, Navg);
IDxGoal00 = IDx00;
IDyGoal00 = IDy00;
IDxGoal00(RemoveElem) = [];
IDyGoal00(RemoveElem) = [];


% Main loop
if GAPmin < 17
    if abs(round(GAPmin)-GAPmin)<0.15
        Gaps = [210 120 80 50 40 35 30 27 24 21 19 17:-1:GAPmin];
    else
        Gaps = [210 120 80 50 40 35 30 27 24 21 19 17:-1:GAPmin GAPmin]; 
    end
else
    error('minimum EPU gaps should always be smaller than 17 mm');
end

GapsLongitudinal = -25:2.5:25;   

for i = 1:length(Gaps)
    
    % Change vectical gap
    setid(Sector, Gaps(i), IDVel, 1, 0);
    setepu(Sector, 0, 0, 0, IDVelEPU, 1, 0); 
    scasleep(2);
    
    % Equivalent to vertical FF 
    setidbpmepuvme(Sector, IDxGoal00, ...
        IDyGoal00, IDBPMlist1, IDBPMIter, IDBPMTol);
    
    scasleep(1);   
    fprintf('  Vertical Gap=%.3f, IDXrms=%.3f, IDYrms=%.3f \n', getid(Sector), std(IDx00-getidx), std(IDy00-getidy));
    
    
    % Corrector starting point
    HCM0 = getsp('HCMFF',[Sector-1 8; Sector 1])';
    VCM0 = getsp('VCMFF',[Sector-1 8; Sector 1])';
    
    
    % Orbit at longitudinal position zero
    [x0, y0] = getbpm(1, Navg);
    [IDx0, IDy0] = getidbpm(1, Navg);
    
    
    % IDBPM least squares
    IDxGoal = IDx0;
    IDxGoal(RemoveElem) = [];
    IDyGoal = IDy0;
    IDyGoal(RemoveElem) = [];
    
    
    for j = 1:length(GapsLongitudinal)
        
        % IDBPM least squares
        [IDxGoal, IDyGoal] = getidbpm(1, Navg);
        IDxGoal(RemoveElem) = [];
        IDyGoal(RemoveElem) = [];
        
        try
            setepu(Sector, GapsLongitudinal(j), 0, 0, IDVelEPU, 1, 0); 
        catch
            setepu(Sector, GapsLongitudinal(j), 0, 0, IDVelEPU, 1, 0); 
        end
        
        scasleep(2);
        
        [offs,offsa,offsb] = getepu(Sector);
        
        fprintf('  Vertical Gap=%.3f, A = %.3f, B = %.3f, IDXrms=%.3f, IDYrms=%.3f \n', getid(Sector), offsa,offsb,std(IDx0-getidx), std(IDy0-getidy));
        
        if GapsLongitudinal(j) == 0
            setsp('HCMFF',HCM0',[Sector-1 8; Sector 1]);
            setsp('VCMFF',VCM0',[Sector-1 8; Sector 1]);
            pause(5);
            
            IDXrmsGoal(i,j) = 0;
            IDYrmsGoal(i,j) = 0; 
            
            % Record data
            HCMtable1(i,j) = 0;
            HCMtable2(i,j) = 0;
            VCMtable1(i,j) = 0;
            VCMtable2(i,j) = 0;
        else       
            [STDfinal, IterOut] = setidbpmepuvme(Sector, IDxGoal, ...
                IDyGoal, IDBPMlist1, IDBPMIter, IDBPMTol);
            
            IDXrmsGoal(i,j) = STDfinal(1);
            IDYrmsGoal(i,j) = STDfinal(2); 
            
            % Record data
            hcm = (getsp('HCMFF',[Sector-1 8; Sector 1])'-HCM0);
            vcm = (getsp('VCMFF',[Sector-1 8; Sector 1])'-VCM0);
            HCMtable1(i,j) = hcm(1);
            HCMtable2(i,j) = hcm(2);
            VCMtable1(i,j) = vcm(1);
            VCMtable2(i,j) = vcm(2);
        end
        
        
        % Statistics
        [x, y] = getbpm(1, Navg);
        [IDx, IDy] = getidbpm(1, Navg);
        Xrms(i,j) = std(x0-x);
        Yrms(i,j) = std(y0-y);
        IDXrms(i,j) = std(IDx0-IDx);
        IDYrms(i,j) = std(IDy0-IDy);
        
        fprintf('  LGap=%.3f, IDXrms=%.3f, IDYrms=%.3f \n', getepu(Sector), IDXrms(i,j), IDYrms(i,j));
        
        % plot results
        figure(h1); % BPMs
        plot(BPMs,(x-x0)*1000,'r', BPMs,(y-y0)*1000,'g');
        title(['BPM Orbit Error at a ', num2str(GapsLongitudinal(j)),' mm Longitudinal Gap']);
        ylabel('X (red), Y (grn) Error [microns]');  
        xlabel('BPM Position [meters]');
        
        figure(h2); % IDBPMs
        %plot(IDBPMs(IDBPMelem),(IDx-IDx0)*1000,'r', IDBPMs(IDBPMelem),(IDy-IDy0)*1000,'g');
        sortIDx = (IDx-IDx0)*1000;
        sortIDy = (IDy-IDy0)*1000;
        plot(IDBPMs(IDBPMelem(svec)), sortIDx(svec),'r', IDBPMs(IDBPMelem(svec)), sortIDy(svec),'g');
        title(['IDBPM Orbit Error at a ', num2str(GapsLongitudinal(j)),' mm Longitudinal Gap']);
        ylabel('X (red), Y (grn) Error [microns]');  
        xlabel('IDBPM Position [meters]');   
        
        drawnow
        
    end
    try
        setepu(Sector, 0, 0, 0, IDVelEPU, 1, 0); 
    catch
        setepu(Sector, 0, 0, 0, IDVelEPU, 1, 0); 
    end
    setsp('HCMFF',HCM0',[Sector-1 8; Sector 1]);
    setsp('VCMFF',VCM0',[Sector-1 8; Sector 1]);
    pause(5);
    
end   


% Minimum gap orbits
[xmin, ymin] = getbpm(1, Navg);
[IDxmin, IDymin] = getidbpm(1, Navg);


%  Reset gap and correctors
disp('  The insertion device gap and the correctors are being reset.'); disp(' ');


% Go to max gap
setid(Sector, GAPmax, IDVel, 1, 0);
setsp('HCMFF',HCM00',[Sector-1 8; Sector 1]);
setsp('VCMFF',VCM00',[Sector-1 8; Sector 1]);

scaput(modechanname,0)

pause(4);

% Ending orbits
scasleep(2);
[x210b, y210b] = getbpm(1, Navg);
[IDx210b, IDy210b] = getidbpm(1, Navg);

% Save in /home/als/physdata/matlab/srdata/gaptrack
% Save in Matlab format (binary format)
CreatedGeV = GLOBAL_SR_GEV;
CreatedDateStr = date;
CreatedClock = clock;
CreatedByStr = 'ffgettblepushift';
ReadmeStr = sprintf('%.1f GeV feed forward table saved to %s.mat in directory %s', GLOBAL_SR_GEV, matfn1, pwd);
idbpmlist = IDBPMlist;
eval(['save ', matfn1,' CreatedGeV CreatedDateStr CreatedClock CreatedByStr ReadmeStr Sector Gaps GapsLongitudinal HCMtable1 VCMtable1 HCMtable2 VCMtable2 x210a y210a x210b y210b IDx210a IDy210a IDx210b IDy210b xmin ymin IDxmin IDymin idbpmlist Xrms Yrms IDXrms IDYrms IDXrmsGoal IDYrmsGoal FFDate FFClock FFGeV']);


% Save in text format
fid = fopen(textfn1,'wt');
fprintf(fid,'# EPU%02d %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f\n', Sector, GeV, month, day, year, hour, minute, seconds);

fprintf(fid,'#\n# Sector %d, HCM4(Vertical Gap, Longitudinal Gap)  \n', Sector-1);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', HCMtable1(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, HCM1(Vertical Gap, Longitudinal Gap)  \n', Sector);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', HCMtable2(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, VCM4(Vertical Gap, Longitudinal Gap)  \n', Sector-1);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', VCMtable1(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, VCM1(Vertical Gap, Longitudinal Gap)  \n', Sector);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', VCMtable2(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);
fprintf('  Data saved to %s\n', [pwd, '/', textfn1]);


% Save in matlab/srdata/gaptrack/archive with the date in the file name
% Save in Matlab format (binary format)
cd archive
eval(['save ', matfn2,' CreatedGeV CreatedDateStr CreatedClock CreatedByStr ReadmeStr Sector Gaps GapsLongitudinal HCMtable1 VCMtable1 HCMtable2 VCMtable2 x210a y210a x210b y210b IDx210a IDy210a IDx210b IDy210b xmin ymin IDxmin IDymin idbpmlist Xrms Yrms IDXrms IDYrms IDXrmsGoal IDYrmsGoal FFDate FFClock FFGeV']);


% Save in text format
fid = fopen(textfn2,'wt');
fprintf(fid,'# EPU%02d %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f\n', Sector, GeV, month, day, year, hour, minute, seconds);

fprintf(fid,'#\n# Sector %d, HCM4(Vertical Gap, Longitudinal Gap)  \n', Sector-1);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', HCMtable1(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, HCM1(Vertical Gap, Longitudinal Gap)  \n', Sector);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', HCMtable2(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, VCM4(Vertical Gap, Longitudinal Gap)  \n', Sector-1);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', VCMtable1(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, VCM1(Vertical Gap, Longitudinal Gap)  \n', Sector);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', VCMtable2(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);
fprintf('  Data saved to %s\n', [pwd, '/', textfn2]);
cd ..


% Close figures then ffanal
close(h1); 
close(h2);
FigureHandles = ffanalepu(Sector, GeV, '.', EPUmode);


disp(['  Measurement complete.  The gap position and correctors have been set back to their original']);
disp(['  setpoints.  A new table has been generated and archived to w:\public\matlab\gaptrack.']);
disp(['  If the table has been successfully generated, the RMS error over the full range of gap positions']);
disp(['  will be below 50 microns horizontally and 25 microns vertically (see Fig. 2).']);
disp(['           Figure ', num2str(FigureHandles(1)),'  ->  Corrector strength verses gap position.']);
disp(['           Figure ', num2str(FigureHandles(2)),'  ->  RMS orbit distortion verses gap position.']);
disp(['           Figure ', num2str(FigureHandles(3)),'  ->  Orbit drift during table generation verses BPM position.']);
disp(['           Figure ', num2str(FigureHandles(4)),'  ->  Rate of Change of the Corrector Magnets.']);


CPTableFlag = questdlg(sprintf('Copy %.1f GeV Table to the IOC?',GeV),'Feed Forward Table Complete','Yes','No','No');
if strcmp(CPTableFlag,'No')
    fprintf('  Use ffcopy(%d,%.1f) to copy the table over to the feed forward program.\n', Sector, GeV);
    fprintf('  Use ffread(%d) (or the "Undulator Server" application) to force the IOC to read the new table.\n', Sector);
else
    ffcopy(textfn1);
    fprintf('  For the IOC to read the new table use the "Undulator Server"\n');
    fprintf('  application or run ffread(%d) from Matlab.\n', Sector);
end


% Return of original directory
eval(['cd ', DirStart]);


% Close figures
%for i = 1:length(FigureHandles)
%   close(FigureHandles(i));
%end


fprintf('  ffgettblepushift function complete.\n');

