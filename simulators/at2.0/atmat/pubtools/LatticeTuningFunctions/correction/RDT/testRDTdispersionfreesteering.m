% test errors and correction functions
close all
clear all

addpath('/mntdirect/_machfs/liuzzo/CODE/LatticeTuningFunctions');
addpath('/mntdirect/_machfs/liuzzo/CODE/LatticeTuningFunctions/correction/response matrix')
addpath('/mntdirect/_machfs/liuzzo/CODE/LatticeTuningFunctions/correction/');
addpath('/mntdirect/_machfs/liuzzo/CODE/LatticeTuningFunctions/errors/');

% load lattice
load ESRFLattice.mat
r0=ring;
%% get RM
speclab='RDTESRF';

modelrmfile=fullfile(pwd,['RMmodel' speclab '.mat']);%

if ~exist([modelrmfile],'file')
    
    %ModelRM=getresponsematrices(ring,[],[],[],[],indQCor,[0 0 0 0 0 0]',7);

    ModelRM...
        =getresponsematrices(...
        ring,...
        indBPM,...
        indHCor,...
        indVCor,...
        indSCor,...
        indQCor,...
        [],...
        [0 0 0 0 0 0]',...
        [10 11 12]); % dispersion rm to quadrupoles
    
    save([modelrmfile],'ModelRM');
else
    load([modelrmfile],'ModelRM');
end

% set errors
ind=find(atgetcells(ring,'Class','Quadrupole','Sextupole'));
dx=5e-6*randn(size(ind));
dy=5e-6*randn(size(ind));
dr=5e-6*randn(size(ind));

rerr=atsetshift(ring,ind,dx,dy);
rerr=atsettilt(rerr,ind,dr);

%% apply correction
inCOD=[0 0 0 0 0 0]';

% use fitted dispersion
[rcor,inCOD,hs,vs]=atRDTdispersioncorrection(...
    rerr,...
    r0,...
    indBPM,...
    indQCor,...
    indSCor,...
    inCOD,...
    [... several correction iterations with different number of eigenvector
    [15 30];...
    [30 60];...
    ],...
    [true],...
    1.0,...
    [0.8 0.1 0.8],...
    ModelRM);

% use fitted dispersion
[rcor,inCOD,hs,vs]=atRDTdispersioncorrection(...
    rerr,...
    r0,...
    indBPM,...
    indQCor,...
    indSCor,...
    inCOD,...
    [... several correction iterations with different number of eigenvector
    [15 30];...
    [30 60];...
    ],...
    [true],...
    1.0,...
    [0.0 0.0 0.0],...
    ModelRM);


return

% use measured dispersion
[rcor,inCOD,hs,vs]=atRDTdispersionmeasuredcorrection(...
    rerr,... % lattice for dispersion ( lattice with errors )
    rerr,... % lattice for beta ( model lattice with fitted errors)
    r0,...
    indBPM,...
    indQCor,...
    indSCor,...
    inCOD,...
    [... several correction iterations with different number of eigenvector
    [15 30];...
    [30 60];...
    ],...
    [true],...
    1.0,...
    [0.8 0.1 0.8],...
    ModelRM);


%% apply correction splitted
inCOD=[0 0 0 0 0 0]';


[rcor,inCOD]=atQuadRDTdispersioncorrection(...
    rerr,...
    r0,...
    indBPM,...
    indQCor,...
    inCOD,...
    [... several correction iterations with different number of eigenvector
    [15];...
    [30];...
    ],...
    [true],...
    1.0,...
    [0.8 0.1],...
    ModelRM);


[rcor,inCOD]=atSkewRDTdispersioncorrection(...
    rerr,...
    r0,...
    indBPM,...
    indSCor,...
    inCOD,...
    [... several correction iterations with different number of eigenvector
    [30];...
    [60];...
    ],...
    [true],...
    1.0,...
    [0.8],...
    ModelRM);
