function varargout = restoreorbit(varargin)
%RESTOREORBIT - Reads saved data from file
%load structures sys, bpm, cor, rsp for return
%no graphics in this routine
%
% INPUTS
% 1. Directory name
% 2. Filename
% 3. 'auto' - for non interactif
% 4. SYS structure
% 5. BPM structure
% 6. COR structutre
% 7. RSP strucutre
%
% See also soleilrestore, readwrite, orbgui('SaveSet'), orbgui('SaveSystem')

%
% Written by William J. Corbett
% Modified by Laurent S. Nadolski

%% Get input arguments

DirSpec = char(varargin(1)); 
FileName= char(varargin(2)); 
auto    = char(varargin(3)); 
sys     = varargin{4};    
bpm     = varargin{5};    
cor     = varargin{6};    
rsp     = varargin{7};    

%=================================
%% check automatic file load request
%=================================
if ~strcmp(auto,'auto') == 1
    answer = input('Load Restore File? Y/N [Y]: ','s');
    if isempty(answer), answer ='n'; end
    if answer =='n' || answer == 'N'
        disp('WARNING: Restore File NOT LOADED');
        fclose(fid);
        return
    end
end

%===========================
%% execute script in save file
%===========================
disp(['   Loading restore file... ', FileName]);

%save file is a script - contains sys, bpm, cor, rsp, bpmx, bpmz, corx,
%corz
run([DirSpec FileName]);     

if ~strcmpi(filetype,'Restore')
    disp(['Warning: improper file specification - ' upper(filetype)]);
    return
else
    clear filetype
end

sys.xlimax = sys.maxs;           %...scaling for abcissa

%=========================================================
%% load BPM to Corrector response matrices
%=========================================================

% automatically load golden response
temp = getbpmresp('struct');    

% Transform to orbit format
rsp = response2rsp(temp,rsp);

% read golden eta function (HW, frequency units)
rsp(1).eta = getphysdata(bpm(1).AOFamily,'Dispersion');
rsp(2).eta = getphysdata(bpm(2).AOFamily,'Dispersion');

%=======================================================================
%% load BPM and COR data from cell arrays acquired while running save file
%=======================================================================
%horizontal BPM
for ii = 1 : size(bpmx,1),
    bpm(1).ifit(ii) = bpmx{ii}{3};     %convert from cell to real
    bpm(1).wt(ii)   = bpmx{ii}{4};
    bpm(1).etawt(ii)= bpmx{ii}{5};
end
bpm(1).ifit = find(bpm(1).ifit);       %compress fitting vector

%horizontal corrector
for ii = 1:size(corx,1),
    cor(1).ifit(ii)=corx{ii}{3};       %convert from cell to real
    cor(1).wt(ii)  =corx{ii}{4};
end
cor(1).ifit = find(cor(1).ifit);       %compress fitting vector

%vertical BPM
for ii = 1:size(bpmz,1),
    bpm(2).ifit(ii)  = bpmz{ii}{3};    %convert from cell to real
    bpm(2).wt(ii)    = bpmz{ii}{4};
    bpm(2).etawt(ii) = bpmz{ii}{5};
end
bpm(2).ifit = find(bpm(2).ifit);       %compress fitting vector

%vertical corrector
for ii = 1:size(corz,1),
    cor(2).ifit(ii) = corz{ii}{3};     %convert from cell to real
    cor(2).wt(ii)   = corz{ii}{4};
end
cor(2).ifit = find(cor(2).ifit);       %compress fitting vector

%==========================================================
%% load corrector limits and response matrix kicks via AO
%==========================================================
AO = getao;

%good = find(getfamilydata(cor(1).AOFamily,'Status'));
cor(1).lim = abs(AO.(cor(1).AOFamily).Setpoint.Range(:,1));  %corrector limits
%cor(1).lim = cor(1).lim(good); 
cor(1).ebpm=AO.(cor(1).AOFamily).Setpoint.DeltaRespMat;      %kicks for response matrix
%cor(1).ebpm = cor(1).ebpm(good); 

cor(2).lim =abs(AO.(cor(2).AOFamily).Setpoint.Range(:,1));
%cor(2).lim = cor(2).lim(good); 
cor(2).ebpm=AO.(cor(2).AOFamily).Setpoint.DeltaRespMat;
%cor(2).ebpm = cor(2).ebpm(good); 

disp(['   Finished loading restore file... ',FileName]);

varargout{1} = sys;
varargout{2} = bpm;
varargout{3} = cor;
varargout{4} = rsp;
