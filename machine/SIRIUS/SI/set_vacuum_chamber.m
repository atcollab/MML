function the_ring = set_vacuum_chamber(the_ring,mode)

if ~exist('mode','var'), mode = 'S05'; end
% y = +/- y_lim * (1 - (x/x_lim)^n)^(1/n);

bc_vchamber    = [0.012 0.004 100]; % n = 100: ~rectangular
other_vchamber = [0.012 0.012 2];   % n = 2;   circular/eliptica
idb_vchamber   = [0.004 0.00225 2];   
ida_vchamber   = [0.012 0.004 2];
if strcmpi(mode,'S05'), idp_vchamber = idb_vchamber;
else                    idp_vchamber = ida_vchamber;
end
inj_vchamber   = [0.030 0.012 2];

% Set ordinary Vacuum Chamber
for i=1:length(the_ring)
    the_ring{i}.VChamber = other_vchamber;
end

% Shift the ring to do not begin between id markers
BPM = findcells(the_ring,'FamName','BPM');
the_ring = circshift(the_ring,[0,-BPM(1)]);

% Set bc vacuum chamber
bcs = findcells(the_ring, 'FamName','mc');
for i=1:length(bcs)
    for j=(bcs(i)-8):(bcs(i)+8)
        the_ring{j}.VChamber = bc_vchamber;
    end
end

% Set in-vacuum ids vacuum chamber
idb = findcells(the_ring, 'FamName', 'id_endb');
idb_ini = idb(1:2:end);  idb_end = idb(2:2:end);
for i=1:length(idb_ini)
    for j=idb_ini(i):idb_end(i)
     the_ring{j}.VChamber = idb_vchamber;
    end
end

% Set other ids vacuum chamber
ida = findcells(the_ring, 'FamName', 'id_enda');
ida_ini = ida(1:2:end);  ida_end = ida(2:2:end);
for i=1:length(ida_ini)
    for j=ida_ini(i):ida_end(i)
     the_ring{j}.VChamber = ida_vchamber;
    end
end

% Set other ids vacuum chamber
idp = findcells(the_ring, 'FamName', 'id_endp');
idp_ini = idp(1:2:end);  idp_end = idp(2:2:end);
for i=1:length(idp_ini)
    for j=idp_ini(i):idp_end(i)
     the_ring{j}.VChamber = idp_vchamber;
    end
end

% Shift the ring back.
the_ring = circshift(the_ring,[0,BPM(1)]);

% Set injection vacuum chamber
inj = findcells(the_ring, 'FamName', 'InjSF');
kickin = findcells(the_ring, 'FamName', 'InjDpK');
if (inj(end) > kickin(1))
    for i=[inj(end):length(the_ring) 1:kickin(end)]
        the_ring{i}.VChamber = inj_vchamber;
    end
else
    for i=inj:kickin(1)
        the_ring{i}.VChamber = inj_vchamber;
    end
end