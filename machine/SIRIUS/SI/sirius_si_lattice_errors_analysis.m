function machine = sirius_si_lattice_errors_analysis()

fprintf('\n')
fprintf('Lattice Errors Run\n');
fprintf('==================\n');

% first step is to initialize global auxiliary structures
name = 'CONFIG'; name_saved_machines = name;
initializations();

% next a nominal model is chosen for the study 
the_ring = create_nominal_model();
family_data = sirius_si_family_data(the_ring);

% application of errors to the nominal model
machine  = create_apply_errors(the_ring, family_data);

%application of BPM offset errors
machine = create_apply_bpm_errors(machine, family_data);

%inserts IDs into lattice and sets its configuration
%machine = set_ids_dipolar_errors(machine);

% orbit correction is performed
machine  = correct_orbit(machine, family_data);

% fast orbit correction is performed
%machine  = fast_correct_orbit(machine, family_data);

% tune correction
machine  = correct_tune(machine);

% next, coupling correction
machine  = correct_coupling(machine, family_data);

% lattice symmetrization
machine = correct_optics(machine, family_data);

% at last, multipole errors are applied
machine  = create_apply_multipoles(machine, family_data);

% finalizations are done
finalizations();


%% Initializations
    function initializations()
        
        fprintf('\n<initializations> [%s]\n\n', datestr(now));
        
        % seed for random number generator
        seed = 131071;
        fprintf('-  initializing random number generator with seed = %i ...\n', seed);
        RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));
        
        % sends copy of all output to a diary in a file
        fprintf('-  creating diary file ...\n');
        diary([name, '_summary.txt']);
        
    end

%% finalizations
    function finalizations()
        
        % closes diary and all open plots
        diary 'off'; fclose('all');
        
    end

%% Definition of the nominal AT model
    function the_ring = create_nominal_model()
        
        fprintf('\n<nominal model> [%s]\n\n', datestr(now));
        
        % loads nominal ring as the default lattice for a particular
        % lattice version. It is assumed that sirius MML structure has been
        % loaded with 'sirius' command the appropriate lattice version.
        fprintf('-  loading model ...\n');
        fprintf('   file: %s\n', which('sirius_si_lattice'));
        the_ring = sirius_si_lattice();
        
        % sets cavity and radiation off for 4D trackings
        fprintf('-  turning radiation and cavity off ...\n');
        the_ring = setcavity('off', the_ring);
        the_ring = setradiation('off', the_ring);
        
        % saves nominal lattice to file
        save([name,'_the_ring.mat'], 'the_ring');
        ind = findcells(the_ring,'MaxOrder');
        the_ring = setcellstruct(the_ring,'MaxOrder',ind,3);
        
    end

%% Magnet Errors:
    function machine = create_apply_errors(the_ring, family_data)
        
        fprintf('\n<error generation and random machines creation> [%s]\n\n', datestr(now));
        
        % constants
        um = 1e-6; mrad = 0.001; percent = 0.01;

        % <quadrupoles> alignment, rotation and excitation errors
        config.fams.quads.labels     = {'QFA','QDA',...
                                        'QDB2','QFB','QDB1',...
                                        'QDP2','QFP','QDP1',...
                                        'Q1','Q2','Q3','Q4','FCQ',...
                                        };
        config.fams.quads.sigma_x    = 40 * um * 1;
        config.fams.quads.sigma_y    = 40 * um * 1;
        config.fams.quads.sigma_roll = 0.30 * mrad * 1;
        config.fams.quads.sigma_e    = 0.05 * percent * 1;
        
        % <sextupoles> alignment, rotation and excitation errors
        config.fams.sexts.labels     = {'SFA0','SFB0','SFP0',...
                                        'SFA1','SFB1','SFP1',...
                                        'SFA2','SFB2','SFP2',...
                                        'SDA0','SDB0','SDP0',...
                                        'SDA1','SDB1','SDP1',...
                                        'SDA2','SDB2','SDP2',...
                                        'SDA3','SDB3','SDP3',...
                                        };
        config.fams.sexts.sigma_x    = 40 * um * 1;
        config.fams.sexts.sigma_y    = 40 * um * 1;
        config.fams.sexts.sigma_roll = 0.30 * mrad * 1;
        config.fams.sexts.sigma_e    = 0.05 * percent * 1;
        
        %ERRORS FOR DIPOLES B1 AND B2 ARE DEFINED IN GIRDERS AND IN THE
        %MAGNET BLOCKS
        
        % <dipoles with only one piece> alignment, rotation and excitation errors
        config.fams.bc.labels     = {'BC'};
        config.fams.bc.sigma_y    = 40 * um * 1;
        config.fams.bc.sigma_x    = 40 * um * 1;
        config.fams.bc.sigma_roll = 0.30 * mrad * 1;
        config.fams.bc.sigma_e    = 0.05 * percent * 1;
        config.fams.bc.sigma_e_kdip = 0.10 * percent * 1;  % quadrupole errors due to pole variations
        
        % <girders> alignment and rotation
        config.girder.girder_error_flag = true;
        config.girder.correlated_errors = false;
        config.girder.sigma_x     = 80 * um * 1;
        config.girder.sigma_y     = 80 * um * 1;
        config.girder.sigma_roll  = 0.30 * mrad * 1;
        
        % sets number of segmentations for each family
        families = fieldnames(config.fams);
        for i=1:length(families)
            family = families{i};
            labels = config.fams.(family).labels;
            config.fams.(family).nrsegs = zeros(1,length(labels));
            for j=1:length(labels)
                config.fams.(family).nrsegs(j) = family_data.(labels{j}).nr_segs;
            end
        end
        
        % <dipole pieces> alignment, rotation and excitation
        % errors for each 
        config.fams.bendblocks.labels       = {'B1','B2'};
        B1_nrsegs = family_data.B1.nr_segs;
        B2_nrsegs = family_data.B2.nr_segs;
        if mod(B1_nrsegs,2) || mod(B2_nrsegs,3)
            error('nrsegs of B1/B2 must be a multiple of 2/3.');
        end
        config.fams.bendblocks.nrsegs       = [B1_nrsegs/2,B2_nrsegs/3];
        config.fams.bendblocks.sigma_x      = 40 * um * 1;
        config.fams.bendblocks.sigma_y      = 40 * um * 1;
        config.fams.bendblocks.sigma_roll   = 0.30 * mrad * 1;
        config.fams.bendblocks.sigma_e      = 0.05 * percent * 1;
        config.fams.bendblocks.sigma_e_kdip = 0.10 * percent * 1;  % quadrupole errors due to pole variations

        
        % generates error vectors
        nr_machines   = 20;
        rndtype       = 'gaussian';
        cutoff_errors = 1;
        fprintf('-  generating errors ...\n');
        errors        = lnls_latt_err_generate_errors(name, the_ring, config, nr_machines, cutoff_errors, rndtype);
        
        % applies errors to machines
        fractional_delta = 1;
        fprintf('-  creating %i random machines and applying errors ...\n', nr_machines);
        fprintf('-  finding closed-orbit distortions with sextupoles off ...\n\n');
        machine = lnls_latt_err_apply_errors(name, the_ring, errors, fractional_delta);
        
    end

%% BPM and Correctors Errors
    function machine = create_apply_bpm_errors(machine, family_data)
        % BPM  anc Corr errors are treated differently from magnet errors:
        % constants
        um = 1e-6;
        
        control.bpm.idx = family_data.BPM.ATIndex;
        control.bpm.sigma_offsetx   = 20 * um * 1; % BBA precision
        control.bpm.sigma_offsety   = 20 * um * 1;
        
        cutoff_errors = 1;
        machine = lnls_latt_err_generate_apply_bpmcorr_errors(name, machine, control, cutoff_errors);
    end


%% Cod Correction
    function machine = correct_orbit(machine, family_data)
        
        fprintf('\n<closed-orbit distortions correction> [%s]\n\n', datestr(now));
        
        % parameters for slow correction algorithms
        orbit.bpm_idx = sort(family_data.BPM.ATIndex);
        orbit.hcm_idx = sort(family_data.CH.ATIndex);
        orbit.vcm_idx = sort(family_data.CV.ATIndex);
        
        % parameters for SVD correction
        orbit.sext_ramp         = [0 1];
        orbit.svs               = 'all';
        orbit.max_nr_iter       = 50;
        orbit.tolerance         = 1e-5;
        orbit.correct2bba_orbit = true;
        orbit.simul_bpm_err     = true;
        orbit.ind_bba           = get_bba_ind(the_ring, orbit.bpm_idx, sort([family_data.QN.ATIndex(:);family_data.QS.ATIndex(:)]));
        
        % calcs nominal cod response matrix, if chosen
        use_respm_from_nominal_lattice = true; 
        if use_respm_from_nominal_lattice
            fprintf('-  calculating orbit response matrix from nominal machine ...\n');
            lattice_symmetry = 5;  
            orbit.respm = calc_respm_cod(the_ring, orbit.bpm_idx, orbit.hcm_idx, orbit.vcm_idx, lattice_symmetry, true); 
            orbit.respm = orbit.respm.respm;
        end 
        
        % loops over random machine, correcting COD...
        machine = lnls_latt_err_correct_cod(name, machine, orbit);
        
        % saves results to file
        name_saved_machines = [name_saved_machines,'_machines_cod_corrected'];
        save2file(name_saved_machines,machine);
        
    end

%% Fast Cod Correction
    function machine = fast_correct_orbit(machine, family_data)
        
        fprintf('\n<fast closed-orbit distortions correction> [%s]\n\n', datestr(now));
        
        % parameters for fast correction algorithms
        orbit.bpm_idx = sort(family_data.rBPM.ATIndex);
        orbit.hcm_idx = sort(family_data.FCH.ATIndex);
        orbit.vcm_idx = sort(family_data.FCV.ATIndex);
        
        % parameters for SVD correction
        orbit.sext_ramp         = [0 1];
        orbit.svs               = 'all';
        orbit.max_nr_iter       = 50;
        orbit.tolerance         = 1e-5;
        orbit.correct2bba_orbit = false;
        orbit.simul_bpm_err     = false;
        orbit.ind_bba           = get_bba_ind(the_ring, orbit.bpm_idx, sort([family_data.QN.ATIndex(:);family_data.QS.ATIndex(:)]));
        
        % calcs nominal cod response matrix, if chosen
        use_respm_from_nominal_lattice = true; 
        if use_respm_from_nominal_lattice
            fprintf('-  calculating orbit response matrix from nominal machine ...\n');
            lattice_symmetry = 5;  
            orbit.respm = calc_respm_cod(the_ring, orbit.bpm_idx, orbit.hcm_idx, orbit.vcm_idx, lattice_symmetry, true); 
            orbit.respm = orbit.respm.respm;
        end 
        
        % loops over random machine, correcting COD...
        machine = lnls_latt_err_correct_cod(name, machine, orbit);
        
        % saves results to file
        name_saved_machines = [name_saved_machines,'_machines_cod_corrected'];
        save2file(name_saved_machines,machine);
        
    end

%% Symmetrization of the optics
    function machine = correct_optics(machine, family_data)
        
        fprintf('\n<optics symmetrization> [%s]\n\n', datestr(now));
        
        optics.bpm_idx = sort(family_data.BPM.ATIndex);
        optics.hcm_idx = sort(family_data.CH.ATIndex);
        optics.vcm_idx = sort(family_data.CV.ATIndex);
        optics.kbs_idx = sort(family_data.QN.ATIndex);
        
        optics.symmetry           = 5;
        optics.svs                = 156;
        optics.max_nr_iter        = 50;
        optics.tolerance          = 1e-5;
        optics.simul_bpm_corr_err = false;
        
        % calcs optics symmetrization matrix
        machine = lnls_latt_err_correct_optics_loco(name, machine, optics, the_ring);
        
        name_saved_machines = [name_saved_machines '_symm'];
        save2file(name_saved_machines,machine);
    end

%% Coupling Correction
    function machine = correct_coupling(machine, family_data)
        
        fprintf('\n<coupling correction> [%s]\n\n', datestr(now));
         
        coup.scm_idx = family_data.QS.ATIndex;
        coup.bpm_idx = family_data.BPM.ATIndex;
        coup.hcm_idx = family_data.CH.ATIndex;
        coup.vcm_idx = family_data.CV.ATIndex;
        coup.svs           = 80;
        coup.max_nr_iter   = 50;
        coup.tolerance     = 1e-5;
        coup.simul_bpm_corr_err = false;
        
        % calcs coupling symmetrization matrix
        fname = [name '_info_coup.mat'];
        lattice_symmetry = 5;
        if ~exist(fname, 'file')
            [respm, info] = calc_respm_coupling(the_ring, coup, lattice_symmetry);
            coup.respm = respm;
            save(fname, 'info');
        else
            data = load(fname);
            [respm, ~] = calc_respm_coupling(the_ring, coup, lattice_symmetry, data.info);
            coup.respm = respm;
        end
        machine = lnls_latt_err_correct_coupling(name, machine, coup);
        
        name_saved_machines = [name_saved_machines '_coup'];
        save2file(name_saved_machines,machine);
    end

%% Tune Correction
    function machine = correct_tune(machine)
        
        fprintf('\n<tune correction> [%s]\n\n', datestr(now));
        
        tune.families        = {'QFA','QDA','QDB2','QFB','QDB1','QDP2','QFP','QDP1'};
        [~, tune.goal]       = twissring(the_ring,0,1:length(the_ring)+1);
        tune.method          = 'svd';
        tune.variation       = 'add';
        tune.max_iter        = 10;
        tune.tolerance       = 1e-6;
     
        % faz correcao de tune
        machine = lnls_latt_err_correct_tune_machines(tune, machine);
        
        name_saved_machines = [name_saved_machines '_tune'];
        save2file(name_saved_machines,machine);
    end

%% Multipoles insertion
    function machine = create_apply_multipoles(machine, family_data)
        
        fprintf('\n<application of multipole errors> [%s]\n\n', datestr(now));

        % QUADRUPOLES
        multi.quadsM.labels = {'QFA','QDA',...
                               'QDB2','QFB','QDB1',...
                               'QDP2','QFP','QDP1',...
                               'Q1','Q2','Q3','Q4',...
                               };
        multi.quadsM.main_multipole = 2;% positive for normal negative for skew
        multi.quadsM.r0 = 12e-3;
        multi.quadsM.order     = [ 3   4   5   6]; % 1 for dipole
        multi.quadsM.main_vals = ones(1,4)*1.5e-4;
        multi.quadsM.skew_vals = ones(1,4)*0.5e-4;
        
        % SEXTUPOLES
        multi.sexts.labels = {'SFA0','SFB0','SFP0',...
                              'SFA1','SFB1','SFP1',...
                              'SFA2','SFB2','SFP2',...
                              'SDA0','SDB0','SDP0',...
                              'SDA1','SDB1','SDP1',...
                              'SDA2','SDB2','SDP2',...
                              'SDA3','SDB3','SDP3',...
                              };
        multi.sexts.main_multipole = 3;% positive for normal negative for skew
        multi.sexts.r0 = 12e-3;
        multi.sexts.order     = [4   5   6   7 ]; % 1 for dipole
        multi.sexts.main_vals = ones(1,4)*1.5e-4;
        multi.sexts.skew_vals = ones(1,4)*0.5e-4;
        
        % DIPOLES
        multi.bends.labels = {'B1','B2','BC'};
        multi.bends.main_multipole = 1;% positive for normal negative for skew
        multi.bends.r0 = 12e-3;
        multi.bends.order = [ 3   4   5   6]; % 1 for dipole
        multi.bends.main_vals = ones(1,4)*1.5e-4;
        multi.bends.skew_vals = ones(1,4)*0.5e-4;
        
        % sets number of segmentations for each family
        families = fieldnames(multi);
        for i=1:length(families)
            family = families{i};
            labels = multi.(family).labels;
            multi.(family).nrsegs = zeros(1,length(labels));
            for j=1:length(labels)
                multi.(family).nrsegs(j) = family_data.(labels{j}).nr_segs;
            end
        end
        
        % adds systematic multipole errors to random machines
        for i=1:length(machine)
            machine{i} = sirius_si_multipole_systematic_errors(machine{i},family_data);
        end
        fname = which('sirius_si_multipole_systematic_errors');
        copyfile(fname, [name '_multipole_systematic_errors.m']);
        
        cutoff_errors = 2;
        multi_errors  = lnls_latt_err_generate_multipole_errors(name, the_ring, multi, length(machine), cutoff_errors);
        machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);
        
        name_saved_machines = [name_saved_machines '_multi'];
        save2file(name_saved_machines,machine);
    end

%% Auxiliary functions
    function save2file(name,machine)
        for i=1:length(machine)
            for ii=1:length(machine{i})
                if isfield(machine{i}{ii},'MaxOrder')
                    machine{i}{ii}.MaxOrder = max([length(machine{i}{ii}.PolynomA),length(machine{i}{ii}.PolynomB)])-1;
                end
            end
        end
        save([name '.mat'], 'machine');
    end
end

function [machine, ids] = insert_ids(machine0)
    
    indices = find_indices(machine0{1});
    
    for j=1:length(machine0)
        machine{j} = machine0{j};
        idx = indices.ids(2:end); idx(2) = [];
        indices_ids_coup = sort([idx-2, idx-1, idx+1, idx+2]);
        InjNLK = [findcells(machine{j}, 'FamName', 'InjNLK'); findcells(machine{j}, 'FamName', 'pmm');];
        for i=indices_ids_coup
            len = machine{j}{i}.Length;
            fam = machine{j}{i}.FamName;
            machine{j}{i} = machine{j}{InjNLK};
            machine{j}{i}.Length = len;
            machine{j}{i}.FamName = fam;
            machine{j}{i}.PolynomA = 0 * machine{j}{i}.PolynomA;
            machine{j}{i}.PolynomB = 0 * machine{j}{i}.PolynomB;
        end
    end
    ids.indices_ids_coup = reshape(indices_ids_coup,4,[])';
    
end

function machine = set_ids_dipolar_errors(machine0)

    [machine, ids] = insert_ids(machine0);
    
    ids.ss = {'mib','mib','mia','mib','mip','mib','mia','mib','mip','mib','mia','mib','mip','mib','mia','mib','mip','mib'};
    ids.max_kickx = 10e-6 * ones(1,18);
    ids.max_kicky = 10e-6 * ones(1,18);
    
    for j=1:length(machine)
        kickx = 2*(rand(1,length(ids.max_kickx))-0.5) .* ids.max_kickx;
        kicky = 2*(rand(1,length(ids.max_kicky))-0.5) .* ids.max_kicky;
        for i=1:length(kickx)
            machine{j} = lnls_set_kickangle(machine{j}, kickx(i), ids.indices_ids_coup(i,:), 'x');
            machine{j} = lnls_set_kickangle(machine{j}, kicky(i), ids.indices_ids_coup(i,:), 'y');
        end
    end
    
end

function indices = find_indices(the_ring)

    
    % --- builds vectors with various indices ---
    data = sirius_si_family_data(the_ring);
    indices.mia = findcells(the_ring, 'FamName', 'mia');
    indices.mib = findcells(the_ring, 'FamName', 'mib');
    indices.mip = findcells(the_ring, 'FamName', 'mip');
    indices.mic = findcells(the_ring, 'FamName', 'mc');
    indices.ids = sort([indices.mia, indices.mib, indices.mip]);
    indices.all = sort([indices.ids, indices.mic]);
    B2_seg_idx   = 8;  % corresponds to 13 mrad (correct value : ~16 mrad)
    if exist('B2_selection','var')
        indices.B2  = data.B2.ATIndex(B2_selection,B2_seg_idx);
    else
        indices.B2  = data.B2.ATIndex(:,B2_seg_idx);
    end
    indices.QS  = data.QS.ATIndex;
    indices.pos = findspos(the_ring, 1:length(the_ring)+1);

    famnames = unique(getcellstruct(the_ring, 'FamName', data.QS.ATIndex(:,1)));
    indices.QS_fams = cell(1,length(famnames));
    for i=1:length(famnames)
        idx = findcells(the_ring, 'FamName', famnames{i});
        indices.QS_fams{i} = reshape(intersect(idx, data.QS.ATIndex(:)), [], size(data.QS.ATIndex,2));
    end

end
