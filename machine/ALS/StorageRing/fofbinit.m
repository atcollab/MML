function fofbinit
% function fofbinit
%
% This routine writes the configuration files, which are used
% by the fast feedback system and also sets up the cell controllers to
% export the new BPM data.
%
% This specific routine includes BPMs in the new cell controller, which is set up as sector 13
%
% Christoph Steier, Greg Portmann, September 2017

% Documentation of the configuration file format from Eric William's code ...
%
% **  There are three configuration files:
% **
% **   <rootFileName>.bpm
% **
% **      File which contains a list of BPM channels used in the FFB.
% **      Each line of the file contains the BPM PV channel name (string),
% **      and an optional sector number (integer).  If the sector number
% **      is missing, it will be divined from the channel name.
% **
% **   <rootFileName>.cm
% **
% **      File which contains a list of corrector magnet channels used
% **      in FFB. Each line of the file contains the corrector magnet PV channel
% **      name, and an optional sector number.
% **
% **   <rootFileName>.smat
% **
% **      File which contains the matrix coefficients.  Each line in the
% **      file contains the BPM PV name, the corrector magnet PV name,
% **      and the associated coefficient (double).


% To add new BPMs
% 1. srcontrol - the golden orbit PV write function is in 2 places.
%
%    write_goldenorbit_ffb_2planesb is needed for cell controllers
%    write_goldenorbit_ffb_2planes for just Bergoz
%
%    2389 uncomment
%    2390   comment
% 
%    2685 uncomment
%    2686   comment
% 
% 2. write_goldenorbit_ffb
%    uncomment lines 104-106 which write the golden orbit to PVs (at the end)
%    This function pre-initializes the golden orbit which will then get quickly overwriten in srcontrol
% 
% 3. run foftinit_1cell (13 crates with BPM data) or fofbinit_2cell (14 crates)
%    run load_config_ffb  (may need to run twice) (this makes it active on the cPCI)
% 
% 4. To restort the Bergoz only default:
%    run write_config_ffb_newml_test
%    run load_config_ffb  (may need to run twice) (this makes it active on the cPCI)

% Testing functions
% 1. test_corrector_update_glitch  -> used to find the cPCI intermittent errors on setpoint writes
%    Note: with 2 Cell Controllers, writes were failing about every 2-6 seconds
%    Note: loads around 70% appear to be a problem.  The load PVs are,
%          ffbsec01:LOAD, ffbsec02:LOAD, ...
%
% 2. Script, runFOFB_cPCI_Log.sh will show the state of the cPCI in sector 1.  All it does is,
%    cd /home/crconfs1/prod/FFB/screens/ffbsec01
%    tail -100 screenlog.0
% 
% 3. FOFB trip analysis (like finding the issue with SR04C___VCM4_AC00 low)
%    /home/crconfs1/prod/srdata/orbitfeedback_fast/log/trip
%    plotit('...bpm... .log', [], 0);
%    



checkforao;

% outputdir = '/home/als/physbase/matlab/als/alsdata';
if ispc
    outputdir = '\\als-filer\physbase\matlab\als\alsdata';
    %    outputdir = '\\als-filer\physbase\matlab\chris\commands';
else
    outputdir = '/home/als/physbase/matlab/als/alsdata';
    %   outputdir = '/home/als/physbase/chris/commands';
end

olddir = pwd;

cd(outputdir);

BPMlist = [
    12   9
    1   2
    1   3
    1   4
    % 1   5 % currently not in slow feedback (2011-08-28)
    1   6 % large 75 and 185 Hz (2011-08-28)
    % 1   7 % currently not in slow feedback (2011-08-28)
    1   8
    1   9
    1   10
    2   1
    2   3
    2   4 %FOFB tripping with non-physical reading from this BPM, 10-2-15, T.Scarvie
    2   5 
    % 2   6  % currently not in slow feedback, noisy BPM observed 5-15-16, T.Scarvie
    2   7
    2   8
    2   9   % large 20 Hz noise
    3   2
    3   3
    3   4
    3   5 
    3   6 
%    3   7  % currently not in slow feedback
    3   8
    3   9
    3   10
    3   11
    3   12
    4   1
    4   2
    4   3
    4   4
    % 4   5 % large 60 Hz noise (2014-10-31)
    % 4   6 % large 40 Hz noise
    4   7
    4   8
    4   9
    4   10
    5   1
    5   2
    5   3
%    5   4  % currently not in slow feedback
    % 5   5 % moderate 10+60 Hz noise
    % 5   6 % moderate <10 Hz noise
    5   7
    5   8
    5   9
    5   10
    5   11
    5  12 
    6   1
    6   2
    6   3
    6   4 
    % 6   5 % currently not in slow feedback (2011-08-28) - huge spikes
    % 6   6 % large 60+200 Hz noise
    % 6   7 % moderate 50 Hz noise 
    6   8
    6   9
    % 6   10 % moderate 90 Hz noise
    6   11
    6   12
    7   1
    7   2
    7   3
    7   4
    7   5
%    7   6  % currently not in slow feedback
    7   7
    7   8
    7   9
    7   10
    8   1
    8   2
    8   3
    8   4
    8   5
    8   6 
    8   7
    8   8
    8   9
%    8   10 % 120 and 140 Hz noise
    9   1
    9   2
%    9   3
    9   4
%    9   5  % currently not in slow feedback
    9   6
%    9   7  % 60 and 120 Hz noise
%    9   8
    9   9
    9   10
    10  1
    10  2
%    10  3
    10  4
%    10  5  low frequency and 60 Hz
    10  6 
    10  7
%    10  8
    10  9
    10  10
%    10  11 % 70+150 Hz noise
%    10  12 % large 120 Hz noise spike
    11  1  % Developed huge offset on 3/23/2013
    11  2
    11  3
    %   11  4 % large 120  Hz noise
    % 11  5 % large noise
    11  6
    11  7
    11  8
    11  9
    11  10 
    12  1 % bad 73 Hz noise
    12  2
    12  3
%    12  4
    12  5 
    12  6
    12  7
    12  8
    ];

% Golden orbit in the cell controller
% The waveform record contains 64 LONG data values in units of nanometers.  
% The first array entry is the desired x position of the BPM whose least significant 
% five bits of fast orbit feedback index are equal to 0, the second array entry the 
% desired y position of the that BPM, the third array entry the desired x position of the 
% BPM whose least significant five bits of fast orbit feedback index are equal to 1, and so on.
%
% Golden BPM difference is applied in the cell controller
% BPMsetpoint: wavefrom x1,y1, x2,y2,   ... up to 32 BPMs (x,y pairs) per cell controller
% Note: 300 tap filter for the BPM data going to the cell controller is applied in the BPM.
%

% Zero all FOFB setpoint
    PV = [
        'SR01:CC:BPMsetpoints'
        'SR02:CC:BPMsetpoints'
        'SR03:CC:BPMsetpoints'
        'SR04:CC:BPMsetpoints'
        'SR05:CC:BPMsetpoints'
        'SR06:CC:BPMsetpoints'
        'SR07:CC:BPMsetpoints'
        'SR08:CC:BPMsetpoints'
        'SR09:CC:BPMsetpoints'
        'SR10:CC:BPMsetpoints'
        'SR11:CC:BPMsetpoints'
        'SR12:CC:BPMsetpoints'
        ];
    for i = 1:12
        a = getpvonline(PV(i,:));
        setpvonline(PV(i,:), 0*a);
    end

% MML family BPM (fields XGoldenSetpoint & YGoldenSetpoint) is setup to hide the details.
% Changing this field will change the "Golden Setpoint" in the cell controller
Dev = family2dev('BPM');
setpv('BPM', 'XGoldenSetpoint', getgolden('BPMx',Dev), Dev);
setpv('BPM', 'YGoldenSetpoint', getgolden('BPMy',Dev), Dev);
    
% Split BPM list into two lists, containing the Bergoz as well as the new
% BPMs
    
nonBergozlist =  getbpmlist('nonBergoz');

FullBPMlist=getlist('BPMx');
for loop=length(BPMlist):-1:1
    if isempty(findrowindex(BPMlist(loop,:),FullBPMlist))
        fprintf('Removing BPM %d,%d from list, not in full BPM list\n',BPMlist(loop,1),BPMlist(loop,2));
        BPMlist(loop,:)=[];
    end
end

nonBergozind = findrowindex(nonBergozlist,BPMlist);

BPMlistBergoz = BPMlist;
BPMlistBergoz(nonBergozind,:)=[];
BPMlistnonBergoz = BPMlist(nonBergozind,:);

% Fast Orbit Feedback List
% The waveform record (NAME="$(P)$(R)FOFBlist") specifies the BPMs whose values will be multicast 
% to the old cPCI-based fast orbit feedback system by this cell controller.  DTYP=asynInt32ArrayOut 
% and OUT="@asyn($(PORT) 1)", where $(PORT) expands to the port name in the bpmccConfigure command.  
% The waveform record contains up to 16 LONG values between 0 and 511.  The number of values contained 
% in the fast orbit feedback SECTOR packets multicast by this cell controller is equal to the number 
% of values written to this record.  The first value in this record specifies the fast orbit feedback 
% index of the BPM whose values will be placed in the first entry in the fast orbit feedback SECTOR 
% packet, the second value (if present) specifies the index of the BPM whose values will be sent second, 
% and so on.   Since all cell controllers contain position offset information from all BPMs there is no 
% restriction on which BPMs can be multicast by any particular cell controller.  To inhibit multicasts 
% from a cell controller set all 16 entries to values outside the range [0, 511].

% The following puts the new BPMs contained in above defined BPMlist in the cell controller for that sector.
% Make sure .NORD isn't larger than the number in index list
% 
if 0
    % Turn off cell controller data to the cPCI
    for i = 1:12
        setpv(sprintf('SR%02d:CC:FOFBlist',i), -1*ones(1,16));
    end    
else
    for i = 1:12
        sectorind = find(BPMlistnonBergoz(:,1)==i);
        FOFBIndex = getpv('BPM','FOFBIndex', BPMlistnonBergoz(sectorind,:));
        %fprintf('SR%02d:CC:FOFBlist\n', i);
        setpv(sprintf('SR%02d:CC:FOFBlist', i), FOFBIndex(:)');
    end
end

% Correctors to be used for fast orbit feedback

HCMlist = [
   1   8
   2   1
   2   8
   3   1
   3   8
   4   1
   4   8
   5   1
   5   8
   6   1
   6   8
   7   1
   7   8
   8   1
   8   8
   9   1
   9   8
   10  1
   10  8
   11  1
   11  8
   12  1
];

VCMlist = [
   1   8
   2   1
   2   8
   3   1
   3   8
   4   1
   4   8    % This power supply had been bad/oscillatory but was replaced on 2018-1-10 with a repaired power supply, so included in FOFB again - C. Steier
   5   1
   5   8
   6   1
   6   8
   7   1
   7   8
   8   1
   8   8
   9   1
   9   8
   10  1
   10  8
   11  1
   11  8
   12  1
];


bpmfile=fopen('19ffbconfig.bpm','w+');

for loop=1:size(BPMlist,1)
   if (BPMlist(loop,2)>=10)
      sector = BPMlist(loop,1)+1;
   else
      sector = BPMlist(loop,1);
   end
   if ~isempty(findrowindex(BPMlist(loop,:),nonBergozlist))
       sector = BPMlist(loop,1)+12;
       
       % the following are fictional PV names, which work with the current
       % version of the fast orbit feedback code, but should be migrated to
       % real PV names by updating that code
       
       if (BPMlist(loop,2)==2)
           paramname=sprintf('SR%02dS___IBPM0XRAM00',sector);
       elseif (BPMlist(loop,2)==3)
           paramname=sprintf('SR%02dS___IBPM1XRAM00',sector);
       elseif (BPMlist(loop,2)==8)
           paramname=sprintf('SR%02dS___IBPM2XRAM00',sector);
       elseif (BPMlist(loop,2)==9)
           paramname=sprintf('SR%02dS___IBPM3XRAM00',sector);
       end           
           fprintf(bpmfile,'%s\t%d\n',paramname,sector);
   else
       paramname=getname('BPMx',BPMlist(loop,:));
       changeindex=findstr(paramname,'X_AM');
       if ~isempty(changeindex)
           paramname(changeindex:(changeindex+3))='XRAM';
           fprintf(bpmfile,'%s\t%d\n',paramname,sector);
       else
           changeindex=findstr(paramname,'XT_AM');
           paramname(changeindex:(changeindex+4))='XTRAM';
           fprintf(bpmfile,'%s\t%d\n',paramname,sector);
       end
   end
end
for loop=1:size(BPMlist,1)
   if (BPMlist(loop,2)>=10)
      sector = BPMlist(loop,1)+1;
   else
      sector = BPMlist(loop,1);
   end
   if ~isempty(findrowindex(BPMlist(loop,:),nonBergozlist))
       sector = BPMlist(loop,1)+12;
       if (BPMlist(loop,2)==2)
           paramname=sprintf('SR%02dS___IBPM0YRAM00',sector);
       elseif (BPMlist(loop,2)==3)
           paramname=sprintf('SR%02dS___IBPM1YRAM00',sector);
       elseif (BPMlist(loop,2)==8)
           paramname=sprintf('SR%02dS___IBPM2YRAM00',sector);
       elseif (BPMlist(loop,2)==9)
           paramname=sprintf('SR%02dS___IBPM3YRAM00',sector);
       end           
           fprintf(bpmfile,'%s\t%d\n',paramname,sector);
   else
       paramname=getname('BPMy',BPMlist(loop,:));
       changeindex=findstr(paramname,'Y_AM');
       if ~isempty(changeindex)
           paramname(changeindex:(changeindex+3))='YRAM';
           fprintf(bpmfile,'%s\t%d\n',paramname,sector);
       else
           changeindex=findstr(paramname,'YT_AM');
           paramname(changeindex:(changeindex+4))='YTRAM';
           fprintf(bpmfile,'%s\t%d\n',paramname,sector);
       end
   end   
end

fclose(bpmfile);

corfile=fopen('19ffbconfig.cm','w+');

for loop=1:size(HCMlist,1)
   sector = HCMlist(loop,1);
   fprintf(corfile,'%s\t%d\n',getname('HCM','Trim',HCMlist(loop,:),1),sector);
end
for loop=1:size(VCMlist,1)
   sector = VCMlist(loop,1);
   fprintf(corfile,'%s\t%d\n',getname('VCM','Trim',VCMlist(loop,:),1),sector);
end

fclose(corfile);

Xivec = [1:12];
Yivec = [1:14];

% Xivec = [1:12];
% Yivec = [1:12];
% Xivec = [1:12];
% Yivec = [1:15];

% Sensitivity matrix
% Sx1 = getrespmat('BPMx', BPMlistBergoz, 'HCM', HCMlist);
% Sy1 = getrespmat('BPMy', BPMlistBergoz, 'VCM', VCMlist);
% 
% Sx3 = getdisp('BPMx', BPMlistBergoz, 'Hardware', 'Numeric')/100;
Sx1 = getrespmat('BPMx', BPMlist, 'HCM', HCMlist);
Sy1 = getrespmat('BPMy', BPMlist, 'VCM', VCMlist);

Sx3 = getdisp('BPMx', BPMlist, 'Hardware', 'Numeric')/100;

Sx = [Sx1 Sx3];
% Sy = [Sy1 Sy3];
% Sy = [Sy1];
% Sx = Sx1;
Sy = Sy1;
% Sx = [[Sx1;Sx1b]  [Sx3;Sx3b]];
% Sy = [Sy1;Sy1b];
% Sy = [[Sy1;Sy1b] [Sy3;Sy3b]];
%        Sx = [[Sx1;Sx1b] [Sx2;Sx2b] [Sx3;Sx3b]];
%        Sy = [[Sy1;Sy1b] [Sy2;Sy2b]];
%	Sy = [[Sy1;Sy1b] [Sy2;Sy2b] [Sy3;Sy3b]];
%	Sy = [Sy1 Sy2];

if length(Sx)<length(Xivec)
   %   Xivec=[1:(length(Sx)-1)];
   Xivec=[1:(length(Sx))];
end
if length(Sy)<length(Yivec)
   % Yivec=[1:(length(Sy)-1)];
   Yivec=[1:(length(Sy))];
end

[Ux,SVx,Vx]=svd(Sx);
[Uy,SVy,Vy]=svd(Sy);

% Remove singular values greater than the actual number of singular values
i = find(Xivec>length(diag(SVx)));
if ~isempty(i)
   disp('  Horizontal E-vector scaled since there were more elements in the vector than singular values.');
   pause(0);
   Xivec(i) = [];
end
i = find(Yivec>length(diag(SVy)));
if ~isempty(i)
   disp('  Vertical E-vector scaled since there were more elements in the vector than singular values.');
   pause(0);
   Yivec(i) = [];
end

Ax = Sx*Vx(:,Xivec);
Tx = inv(Ax'*Ax)*Ax';

Ay = Sy*Vy(:,Yivec);
Ty = inv(Ay'*Ay)*Ay';


figure;
subplot(2,1,1);
semilogy(diag(SVx),'b');
hold on;
semilogy(diag(SVx(Xivec,Xivec)),'xr');
ylabel('Horizontal');
title('Response Matrix Singular Values');
hold off;
subplot(2,1,2);
semilogy(diag(SVy),'b');
hold on;
semilogy(diag(SVy(Yivec,Yivec)),'xr');
xlabel('Singular Value Number');
ylabel('Vertical');
hold off;
drawnow;

prompt={'Enter the horizontal E-vector numbers (Matlab vector format):','Enter the vertical E-vector numbers (Matlab vector format):'};
def={sprintf('[%d:%d]',1,Xivec(end)),sprintf('[%d:%d]',1,Yivec(end))};
titlestr='SVD Orbit Feedback';
lineNo=1;
answer=inputdlg(prompt,titlestr,lineNo,def);
if ~isempty(answer)
   XivecNew = fix(str2num(answer{1}));
   if isempty(XivecNew)
      disp('  Horizontal E-vector cannot be empty.  No change made.');
   else
      if any(XivecNew<=0) | max(XivecNew)>length(diag(SVx))
         disp('  Error reading horizontal E-vector.  No change made.');                        
      else
         Xivec = XivecNew;
      end
   end
   YivecNew = fix(str2num(answer{2}));
   if isempty(YivecNew)
      disp('  Vertical E-vector cannot be empty.  No change made.');
   else
      if any(YivecNew<=0) | max(YivecNew)>length(diag(SVy))
         disp('  Error reading vertical E-vector.  No change made.');                        
      else
         Yivec = YivecNew;
      end
   end
end

subplot(2,1,1);
hold off;
semilogy(diag(SVx),'b');
hold on;
semilogy(diag(SVx(Xivec,Xivec)),'xr');
ylabel('Horizontal');
title('Response Matrix Singular Values');
hold off;
subplot(2,1,2);
hold off;
semilogy(diag(SVy),'b');
hold on;
semilogy(diag(SVy(Yivec,Yivec)),'xr');
xlabel('Singular Value Number');
ylabel('Vertical');
hold off;
drawnow;

Ax = Sx*Vx(:,Xivec);
Tx = inv(Ax'*Ax)*Ax';

Ay = Sy*Vy(:,Yivec);
Ty = inv(Ay'*Ay)*Ay';


Bx = -Vx(:,Xivec)*Tx;
By = -Vy(:,Yivec)*Ty;

smatfile=fopen('19ffbconfig.smat','w+');

for loop=1:size(BPMlist,1)
    for loop2=1:size(HCMlist,1)
        if ~isempty(findrowindex(BPMlist(loop,:),nonBergozlist))
            sector = BPMlist(loop,1)+12;
            if (BPMlist(loop,2)==2)
                paramname=sprintf('SR%02dS___IBPM0XRAM00',sector);
            elseif (BPMlist(loop,2)==3)
                paramname=sprintf('SR%02dS___IBPM1XRAM00',sector);
            elseif (BPMlist(loop,2)==8)
                paramname=sprintf('SR%02dS___IBPM2XRAM00',sector);
            elseif (BPMlist(loop,2)==9)
                paramname=sprintf('SR%02dS___IBPM3XRAM00',sector);
            end
        else
            paramname=getname('BPMx',BPMlist(loop,:));
            changeindex=findstr(paramname,'X_AM');
            if ~isempty(changeindex)
                paramname(changeindex:(changeindex+3))='XRAM';
            else
                changeindex=findstr(paramname,'XT_AM');
                paramname(changeindex:(changeindex+4))='XTRAM';
            end
        end
%         if ~isempty(findrowindex(BPMlist(loop,:),nonBergozlist))
%             fprintf(smatfile,'%s\t%s\t%g\n',paramname,...
%                 getname('HCM','Trim',HCMlist(loop2,:),1),0);
%         else
%             BPMindtmp=findrowindex(BPMlist(loop,:),BPMlistBergoz);
%             fprintf(smatfile,'%s\t%s\t%g\n',paramname,...
%                 getname('HCM','Trim',HCMlist(loop2,:),1),Bx(loop2,BPMindtmp));
%         end
             fprintf(smatfile,'%s\t%s\t%g\n',paramname,...
                 getname('HCM','Trim',HCMlist(loop2,:),1),Bx(loop2,loop));
    end
end
for loop=1:size(BPMlist,1)
    for loop2=1:size(VCMlist,1)
        if ~isempty(findrowindex(BPMlist(loop,:),nonBergozlist))
            sector = BPMlist(loop,1)+12;
            if (BPMlist(loop,2)==2)
                paramname=sprintf('SR%02dS___IBPM0YRAM00',sector);
            elseif (BPMlist(loop,2)==3)
                paramname=sprintf('SR%02dS___IBPM1YRAM00',sector);
            elseif (BPMlist(loop,2)==8)
                paramname=sprintf('SR%02dS___IBPM2YRAM00',sector);
            elseif (BPMlist(loop,2)==9)
                paramname=sprintf('SR%02dS___IBPM3YRAM00',sector);
            end
        else
            paramname=getname('BPMy',BPMlist(loop,:));
            changeindex=findstr(paramname,'Y_AM');
            if ~isempty(changeindex)
                paramname(changeindex:(changeindex+3))='YRAM';
            else
                changeindex=findstr(paramname,'YT_AM');
                paramname(changeindex:(changeindex+4))='YTRAM';
            end
        end
%         if ~isempty(findrowindex(BPMlist(loop,:),nonBergozlist))
%             fprintf(smatfile,'%s\t%s\t%g\n',paramname,...
%                 getname('VCM','Trim',VCMlist(loop2,:),1),0);
%         else
%             BPMindtmp=findrowindex(BPMlist(loop,:),BPMlistBergoz);
%             fprintf(smatfile,'%s\t%s\t%g\n',paramname,...
%                 getname('VCM','Trim',VCMlist(loop2,:),1),By(loop2,BPMindtmp));
%         end
            fprintf(smatfile,'%s\t%s\t%g\n',paramname,...
                getname('VCM','Trim',VCMlist(loop2,:),1),By(loop2,loop));
    end
end

fclose(smatfile);

if min(size(Bx))>1    
    figure
    subplot(2,1,1)
    mesh(Bx);
    subplot(2,1,2)
    mesh(By);    
end

save 'ffb_bpm_cm_config' BPMlist HCMlist VCMlist Xivec Yivec

% write_alarms_ffb

cd(olddir);