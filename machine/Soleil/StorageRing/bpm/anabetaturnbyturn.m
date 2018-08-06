function [bxmeas bzmeas nux nuz] = anabetaturnbyturn(varargin)
% ANABETATURNBYTURN - Compute beta function at BPM location using turn by turn data
%
%  INPUTS
%  Optional input arguments
%  1. Optional display
%     'Display'   - Plot the beta function {Default if no outputs exist}
%     'NoDisplay' - Bpmdata will not be plotted {Default if outputs exist}
%  2. 'File'      - Get from File (interactive)
%
%  OUTPUTS
%  1. bxmeas - Horizontal beta funtion at BPM location
%  2. bzmeas - Vertical beta funtion at BPM location
%  3. nux - H-Tune determined by FFT
%  4. nuz - V-Tune determined by FFT
%
%  See Also getbpmrawdata, findfreq

%
% Written by Laurent S. Nadolski

FileFlag = 0;   % Get data from a file
DisplayFlag = 1;
FileName = '';

% if no output variable, display results
if nargout > 0
    DisplayFlag = 0;
end

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'File')
        FileFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Struct')
        StructureFlag = 1;
        varargin(i) = [];
    end
end

% Get File by asking users
if FileFlag
    DirectoryName = getfamilydata('Directory','BPMData');
    pwd_old = pwd;
    cd(DirectoryName);
    Filename = uigetfile('BPMTurnByTurn*');
    cd(pwd_old);
    if  isequal(FileName,0)
        disp('User pressed cancel')
        exit(0);
    else
        a = load(fullfile(DirectoryName, Filename));
        AM = getfield(a, 'AM');
    end
else % Online data
    AM = getbpmrawdata('Struct');
end

istart = 1500;
iend = istart + 1024 - 1 ;
Xpos = AM.Data.X(:,istart:iend)';
Zpos = AM.Data.Z(:,istart:iend)';

if DisplayFlag
    figure
    subplot(2,1,1)
    plot(Xpos)
    ylabel('X [mm]')
    subplot(2,1,2)
    plot(Zpos)
    ylabel('Z [mm]')
    xlabel('Turn number');
    suptitle('Turn by turn data')
end
%%
%refreshthering;
%steptune([0.005 0.0125],'Model');
[bxm bzm] = modelbeta('BPMx');
%%
ind = (1:120);
[nux nuz ampx ampz] = findfreq(Xpos(:,ind),Zpos(:,ind));

% fit average beta values to model
factx  = mean(bxm)/mean(ampx.*ampx);
factz  = mean(bzm)/mean(ampz.*ampz);
bxmeas = (ampx.*ampx*factx)';
bzmeas = (ampz.*ampz*factz)';

if DisplayFlag
    figure
    clf
    av = getspos('BPMx');
    %av = [av(1:30); av(1:30); av(1:30); av(1:30)]; 
    subplot(2,1,1)
    plot(av,bxmeas,'b*',av,bxm,'k.-'); hold on;
    ylabel('betax [m]'); grid on;
    subplot(2,1,2)
    plot(av,bzmeas,'b*',av,bzm,'k.-')
    grid on; ylabel('betaz [m]');
    xlabel('s [m]');
    suptitle('Beta function fitted at BPM position from turn by turn data (blue stars) and theory (black)')
end

tmp = bxmeas(74);  bxmeas(74) = bxmeas(75) ; bxmeas(75) = tmp;
addlabel(sprintf('H-betabeat %3.2f %% rms V-betabeat %3.2f %% rms',std((bxmeas - bxm)./bxm)*100,std((bzmeas - bzm)./bzm)*100))