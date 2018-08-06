function sirius_survey(type,machine)

%% This Parameters are taken from lattest models

p.si_b1_rx_traj = 8.285/1000;     % initial rx of RK trajectory at center (s=0) of the magnet as measured in the magnet coordinate system
p.si_b1_rx_refp = 13.446574/1000; % rx position of the reference point (intesection point of asymptote lines) as measured in the magnet coordinate system

p.si_b2_rx_traj = 7.920/1000;     % initial rx of RK trajectory at center (s=0) of the magnet as measured in the magnet coordinate system
p.si_b2_rx_refp = 19.239210/1000; % rx position of the reference point (intesection point of asymptote lines) as measured in the magnet coordinate system

p.si_bc_rx_traj = 0.000/1000;     % initial rx of RK trajectory at center (s=0) of the magnet as measured in the magnet coordinate system
p.si_bc_rx_refp = 7.618772/1000;  % rx position of the reference point (intesection point of asymptote lines) as measured in the magnet coordinate system

p.bo_b_rx_traj = 9.045/1000;      % initial rx of RK trajectory at center (s=0) of the magnet as measured in the magnet coordinate system
p.bo_b_rx_refp = 28.198720/1000;  % rx position of the reference point (intesection point of asymptote lines) as measured in the magnet coordinate system


%% Process arguments
if exist('machine','var')
    sirius(machine)
end

if ~exist('type','var')
    ad = getad();
    if strcmpi(ad.MachineType,'StorageRing')
        type = 'si_ssectors_refp_dipoles';
    elseif strcmpi(ad.MachineType,'Booster')
        type = 'bo_ssectors_refp_dipoles';
    end
end

type = 'bo_ssectors_refp_dipoles';


%% take surkey
if strcmpi(type, 'si_ssectors_centerof_dipoles')
    si_survey_ssectors_centerof_dipoles(p)
elseif strcmpi(type, 'si_ssectors_refp_dipoles')
    si_survey_ssectors_refp_dipoles(p)
elseif strcmpi(type, 'si_radiation_points')
    si_survey_radiation_points
elseif strcmpi(type, 'si_quadrupoles_sextupoles')
    si_survey_quadrupoles_sextupoles
elseif strcmpi(type, 'bo_ssectors_refp_dipoles')
    bo_survey_ssectors_refp_dipoles(p)
else
    si_survey_girders
end


function si_survey_girders

global THERING

[pos, vel] = lnls_build_ref_orbit(THERING, 'B2', 'sirius');
girders = unique(getcellstruct(THERING, 'Girder', findcells(THERING, 'Girder')));


fprintf('- Girder 001 starts at 01M2\n');
fprintf('- Dipoles are also in girders\n');
fprintf('\n');

% print girder info
for i=1:length(girders)
    fprintf('girder %s: ', girders{i});
    idx = findcells(THERING, 'Girder', girders{i});
    elements = {};
    for j=1:length(idx)
        if ~strcmpi(THERING{idx(j)}.PassMethod, {'IdentityPass','DriftPass'}) | strcmpi(THERING{idx(j)}.FamName, 'BPM')
            elements = [elements THERING{idx(j)}.FamName];
            %fprintf('%s ', THERING{idx(j)}.FamName);
        end
    end
    elements = unique(elements);
    for j=1:length(elements)
        fprintf('%s ', elements{j});
    end
    fprintf('\n');
end

% print girder locations
fprintf('\n');
for i=1:length(girders)
    idx = findcells(THERING, 'Girder', girders{i});
    p = pos(:,idx(1)); v = vel(:,idx(1));
    fprintf('%10s: point(X,Y)= %+12.4f %+12.4f    versor(X,Y)= %+.6e %+.6e\n', ['start ', girders{i}], 1000*p(2), 1000*p(1), v(2), v(1));
    p = pos(:,idx(end)); v = vel(:,idx(end));
    fprintf('%10s: point(X,Y)= %+12.4f %+12.4f    versor(X,Y)= %+.6e %+.6e\n', ['end ', girders{i}], 1000*p(2), 1000*p(1), v(2), v(1));
end

function si_survey_ssectors_centerof_dipoles(p)

global THERING
the_ring = THERING;

[pos, vel] = lnls_build_ref_orbit(the_ring, 'B2', 'sirius');

mia = findcells(the_ring, 'FamName', 'mia');
mib = findcells(the_ring, 'FamName', 'mib');
mip = findcells(the_ring, 'FamName', 'mip');
mB1 = findcells(the_ring, 'FamName', 'mB1');
mB2 = findcells(the_ring, 'FamName', 'mB2');
mBC = findcells(the_ring, 'FamName', 'mc');
tmp = getfamilydata('B1','AT','ATIndex'); lB1 = sort(reshape([tmp(:,1), tmp(:,end)+1],1,[]));
tmp = getfamilydata('B2','AT','ATIndex'); lB2 = sort(reshape([tmp(:,1), tmp(:,end)+1],1,[]));
tmp = getfamilydata('BC','AT','ATIndex'); lBC = sort(reshape([tmp(:,1), tmp(:,end)+1],1,[]));
the_ring = setcellstruct(the_ring, 'FamName', lB1, 'line');
the_ring = setcellstruct(the_ring, 'FamName', lB2, 'line');
the_ring = setcellstruct(the_ring, 'FamName', lBC, 'line');

the_ring = setcellstruct(the_ring, 'FamName', mB1, 'B1');
the_ring = setcellstruct(the_ring, 'FamName', mB2, 'B2');
the_ring = setcellstruct(the_ring, 'FamName', mBC, 'BC');

idx = sort([mia,mib,mip,mB1,mB2,mBC,lB1,lB2,lBC]);
dr = zeros(1,length(the_ring));
dr(mB1) = -p.si_b1_rx0; % this displacement from the RK trajectory at s=0 for the B1 dipole to the origin of the coordinate system of the magnet.
dr(mB2) = -p.si_b2_rx0; % this displacement from the RK trajectory at s=0 for the B2 dipole to the origin of the coordinate system of the magnet.
dr(mBC) = -p.si_bc_rx0; % this displacement from the RK trajectory at s=0 for the BC dipole to the origin of the coordinate system of the magnet.

fprintf('%5s: point(X,Y) is the center of SA straight sectors [mm]\n', the_ring{mia(1)}.FamName);
fprintf('%5s: point(X,Y) is the center of SB straight sectors [mm]\n', the_ring{mib(1)}.FamName);
fprintf('%5s: point(X,Y) is the center of SP straight sectors [mm]\n', the_ring{mip(1)}.FamName);
fprintf('%5s: point(X,Y) is the origin of coordinate system of B1 dipoles [mm]\n', the_ring{mB1(1)}.FamName);
fprintf('%5s: point(X,Y) is the origin of coordinate system of B2 dipoles [mm]\n', the_ring{mB2(1)}.FamName);
fprintf('%5s: point(X,Y) is the origin of coordinate system of BC dipoles [mm]\n', the_ring{mBC(1)}.FamName);
fprintf('\n')
fprintf('versor(X,Y) is a versor pointing to the tangent direction of the element\n');
fprintf('\n')

for i=1:length(idx)
    ind = idx(i);
    famname = the_ring{ind}.FamName;
    p0 = pos(:,ind);
    v = dr(ind) * [0, 1; -1, 0] * vel(:,ind);
    p = p0 + v;
    fprintf('%5s: point(X,Y)= %+12.4f %+12.4f    versor(X,Y)= %+.6e %+.6e\n', famname, 1000*p(2), 1000*p(1), vel(2,ind), vel(1,ind));
end

function si_survey_ssectors_refp_dipoles(p)

global THERING
the_ring = THERING;

[pos, vel] = lnls_build_ref_orbit(the_ring, 'B2', 'sirius');

mia = findcells(the_ring, 'FamName', 'mia');
mib = findcells(the_ring, 'FamName', 'mib');
mip = findcells(the_ring, 'FamName', 'mip');
mB1 = findcells(the_ring, 'FamName', 'mB1');
mB2 = findcells(the_ring, 'FamName', 'mB2');
mBC = findcells(the_ring, 'FamName', 'mc');
tmp = getfamilydata('B1','AT','ATIndex'); lB1 = sort(reshape([tmp(:,1), tmp(:,end)+1],1,[]));
tmp = getfamilydata('B2','AT','ATIndex'); lB2 = sort(reshape([tmp(:,1), tmp(:,end)+1],1,[]));
tmp = getfamilydata('BC','AT','ATIndex'); lBC = sort(reshape([tmp(:,1), tmp(:,end)+1],1,[]));
the_ring = setcellstruct(the_ring, 'FamName', lB1, 'line');
the_ring = setcellstruct(the_ring, 'FamName', lB2, 'line');
the_ring = setcellstruct(the_ring, 'FamName', lBC, 'line');

the_ring = setcellstruct(the_ring, 'FamName', mB1, 'B1');
the_ring = setcellstruct(the_ring, 'FamName', mB2, 'B2');
the_ring = setcellstruct(the_ring, 'FamName', mBC, 'BC');


% moves from center of dipolos to the reference points (intersection of
% straight lines)
pos = move_from_traj_to_refp(pos, vel, mB1, p.si_b1_rx_refp-p.si_b1_rx_traj);
pos = move_from_traj_to_refp(pos, vel, mB2, p.si_b2_rx_refp-p.si_b2_rx_traj);
pos = move_from_traj_to_refp(pos, vel, mBC, p.si_bc_rx_refp-p.si_bc_rx_traj);

idx = sort([mia,mib,mip,mB1,mB2,mBC,lB1,lB2,lBC]);

fprintf('%5s: point(X,Y) is the center of SA straight sectors [mm]\n', the_ring{mia(1)}.FamName);
fprintf('%5s: point(X,Y) is the center of SB straight sectors [mm]\n', the_ring{mib(1)}.FamName);
fprintf('%5s: point(X,Y) is the center of SP straight sectors [mm]\n', the_ring{mip(1)}.FamName);
fprintf('%5s: point(X,Y) is the position of the B1 dipole reference point [mm]\n', the_ring{mB1(1)}.FamName);
fprintf('%5s: point(X,Y) is the position of the B2 dipole reference point [mm]\n', the_ring{mB2(1)}.FamName);
fprintf('%5s: point(X,Y) is the position of the BC dipole reference point [mm]\n', the_ring{mBC(1)}.FamName);
fprintf('\n')
fprintf('versor(X,Y) is a versor pointing to the tangent direction of the element\n');
fprintf('\n')

for i=1:length(idx)
    ind = idx(i);
    famname = the_ring{ind}.FamName;
    p = pos(:,ind);
    fprintf('%5s: point(X,Y)= %+12.4f %+12.4f    versor(X,Y)= %+.6e %+.6e\n', famname, 1000*p(2), 1000*p(1), vel(2,ind), vel(1,ind));
end

function bo_survey_ssectors_refp_dipoles(p)

global THERING
the_ring = THERING;

[pos, vel] = lnls_build_ref_orbit(the_ring, 'B', 'booster');

mS = findcells(the_ring, 'FamName', 'mQF');
mB = findcells(the_ring, 'FamName', 'mB');
tmp = getfamilydata('B','AT','ATIndex'); lB = sort(reshape([tmp(:,1), tmp(:,end)+1],1,[]));
the_ring = setcellstruct(the_ring, 'FamName', lB, 'line');
the_ring = setcellstruct(the_ring, 'FamName', mB, 'B');

% moves from center of dipolos to the reference points (intersection of
% straight lines)
pos = move_from_traj_to_refp(pos, vel, mB, p.bo_b_rx_refp-p.bo_b_rx_traj);

idx = sort([mS,mB,lB]);

fprintf('%5s: point(X,Y) is the center of straight sectors [mm]\n', the_ring{mS(1)}.FamName);
fprintf('%5s: point(X,Y) is the position of the B dipole reference point [mm]\n', the_ring{mB(1)}.FamName);
fprintf('\n')
fprintf('versor(X,Y) is a versor pointing to the tangent direction of the element\n');
fprintf('\n')

for i=1:length(idx)
    ind = idx(i);
    famname = the_ring{ind}.FamName;
    p = pos(:,ind);
    fprintf('%5s: point(X,Y)= %+12.4f %+12.4f    versor(X,Y)= %+.6e %+.6e\n', famname, 1000*p(2), 1000*p(1), vel(2,ind), vel(1,ind));
end

function si_survey_quadrupoles_sextupoles


global THERING
the_ring = THERING;

[pos, vel] = lnls_build_ref_orbit(the_ring, 'B2', 'sirius');

quad_famnames = findmemberof('quad');
sext_famnames = findmemberof('sext');
idx = [];
for i=1:length(quad_famnames)
    idx = [idx findcells(the_ring, 'FamName', quad_famnames{i})];
end
for i=1:length(sext_famnames)
    idx = [idx findcells(the_ring, 'FamName', sext_famnames{i})];
end

idx = sort(idx);

for i=1:length(idx)
    ind = idx(i);
    famname  = the_ring{ind}.FamName;
    p_begin  = pos(:,ind);
    p_end    = pos(:,ind+1);
    p_center =  0.5*(p_begin + p_end);
    fprintf('%5s: point(X,Y)= %+12.4f %+12.4f    versor(X,Y)= %+.6e %+.6e\n', famname, 1000*p_center(2), 1000*p_center(1), vel(2,ind), vel(1,ind));
end

function si_survey_radiation_points()

global THERING
the_ring = THERING;

[pos, vel] = lnls_build_ref_orbit(the_ring, 'B2', 'sirius');

mia = findcells(the_ring, 'FamName', 'mia');
mib = findcells(the_ring, 'FamName', 'mib');
mip = findcells(the_ring, 'FamName', 'mip');
mBC = findcells(the_ring, 'FamName', 'mc');
%tmp = getfamilydata('BC','AT','ATIndex'); lBC = sort(reshape([tmp(:,1), tmp(:,end)+1],1,[]));
%the_ring = setcellstruct(the_ring, 'FamName', lBC, 'line');
the_ring = setcellstruct(the_ring, 'FamName', mBC, 'BC');

idx = sort([mia,mib,mip,mBC]);

fprintf('%5s: point(X,Y) is the center of SA straight sectors [mm]\n', the_ring{mia(1)}.FamName);
fprintf('%5s: point(X,Y) is the center of SB straight sectors [mm]\n', the_ring{mib(1)}.FamName);
fprintf('%5s: point(X,Y) is the center of SP straight sectors [mm]\n', the_ring{mip(1)}.FamName);
fprintf('%5s: point(X,Y) is the position of the BC dipole reference point [mm]\n', the_ring{mBC(1)}.FamName);
fprintf('\n')
fprintf('versor(X,Y) is a versor pointing to the tangent direction of the element\n');
fprintf('\n')

for i=1:length(idx)
    ind = idx(i);
    famname = the_ring{ind}.FamName;
    p = pos(:,ind);
    fprintf('%5s: point(X,Y)= %+12.4f %+12.4f    versor(X,Y)= %+.6e %+.6e\n', famname, 1000*p(2), 1000*p(1), vel(2,ind), vel(1,ind));
end


function posf = move_from_traj_to_refp(pos, vel, idx, dx)

posf = pos;
for ind=idx
    p0 = posf(:,ind);
    v = dx * [0, 1; -1, 0] * vel(:,ind);
    posf(:,ind) = p0 + v;
end


