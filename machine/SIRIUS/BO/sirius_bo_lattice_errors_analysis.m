function machine = sirius_bo_lattice_errors_analysis()

fprintf('\n')
fprintf('Lattice Errors Run\n');
fprintf('==================\n');

% first step is to initialize global auxiliary structures
name = 'CONFIG'; name_saved_machines = name;
initializations();

% next a nominal model is chosen for the study 
the_ring = create_nominal_model();
family_data = sirius_bo_family_data(the_ring);

% application of errors to the nominal model
machine  = create_apply_errors(the_ring, family_data);

%application of bpm offset errors
machine = create_apply_bpm_errors(machine, family_data);

% orbit correction is performed
machine  = correct_orbit(machine, family_data);

% tune correction
machine  = correct_tune(machine);

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
        the_ring = sirius_bo_lattice();

                
        % sets cavity and radiation off for 4D trackings
        fprintf('-  turning radiation and cavity off ...\n');
        the_ring = setcavity('off', the_ring);
        the_ring = setradiation('off', the_ring);
        
        % saves nominal lattice to file
        save([name,'_the_ring.mat'], 'the_ring');
        
    end

%% Magnet Errors:
    function machine = create_apply_errors(the_ring, family_data)
        
        fprintf('\n<error generation and random machines creation> [%s]\n\n', datestr(now));
        
        % constants
        um = 1e-6; mrad = 0.001; percent = 0.01;

        % <quadrupoles> alignment, rotation and excitation errors
        config.fams.quads.labels     = {'qf','qd'};
        config.fams.quads.sigma_x    = 160 * um * 1;
        config.fams.quads.sigma_y    = 160 * um * 1;
        config.fams.quads.sigma_roll = 0.800 * mrad * 1;
        config.fams.quads.sigma_e    = 0.3 * percent * 1;
        
        % <sextupoles> alignment, rotation and excitation errors
        config.fams.sexts.labels     = {'sd','sf'};
        config.fams.sexts.sigma_x    = 160 * um * 1;
        config.fams.sexts.sigma_y    = 160 * um * 1;
        config.fams.sexts.sigma_roll = 0.800 * mrad * 1;
        config.fams.sexts.sigma_e    = 0.3 * percent * 1;
        
        % <dipoles with more than one piece> alignment, rotation and excitation errors
        config.fams.b.labels       = {'b'};
        config.fams.b.sigma_x      = 160 * um * 1;
        config.fams.b.sigma_y      = 160 * um * 1;
        config.fams.b.sigma_roll   = 0.800 * mrad * 1;
        config.fams.b.sigma_e      = 0.15 * percent * 1;
        config.fams.b.sigma_e_kdip = 2.4 * percent * 1;  % quadrupole errors due to pole variations
        
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
        
        % generates error vectors
        nr_machines   = 20;
        rndtype       = 'gaussian';
        cutoff_errors = 1;
        fprintf('-  generating errors ...\n');
        % I have to do this for the booster, because the lattice begins at 
        % the middle of the quadrupole:
        idx = findcells(the_ring,'FamName','bpm'); idx = idx(end)-1;
        the_ring = circshift(the_ring,[0,-idx]);
        
        errors        = lnls_latt_err_generate_errors(name, the_ring, config, nr_machines, cutoff_errors, rndtype);
        
        % applies errors to machines
        fractional_delta = 1;
        fprintf('-  creating %i random machines and applying errors ...\n', nr_machines);
        fprintf('-  finding closed-orbit distortions with sextupoles off ...\n\n');
        machine = lnls_latt_err_apply_errors(name, the_ring, errors, fractional_delta);
        for i=1:length(machine)
            machine{i} = circshift(machine{i},[0,idx]);
        end
    end

%% BPM and Correctors Errors
    function machine = create_apply_bpm_errors(machine, family_data)
        % BPM  anc Corr errors are treated differently from magnet errors:
        % constants
        um = 1e-6; mrad = 0.001; percent = 0.01;
        
        control.bpm.idx = family_data.bpm.ATIndex;
        control.bpm.sigma_offsetx   = 300 * um * 1;
        control.bpm.sigma_offsety   = 300 * um * 1;
        
        cutoff_errors = 1;
        machine = lnls_latt_err_generate_apply_bpmcorr_errors(name, machine, control, cutoff_errors);
    end


%% Cod Correction
    function machine = correct_orbit(machine, family_data)
        
        fprintf('\n<closed-orbit distortions correction> [%s]\n\n', datestr(now));
        
        % parameters for slow correction algorithms
        orbit.bpm_idx = family_data.bpm.ATIndex;
        orbit.hcm_idx = family_data.ch.ATIndex;
        orbit.vcm_idx = family_data.cv.ATIndex;
        
        % parameters for SVD correction
        orbit.sext_ramp         = [0 1];
        orbit.svs               = 'all';
        orbit.max_nr_iter       = 50;
        orbit.tolerance         = 1e-5;
        orbit.correct2bba_orbit = false;
        orbit.simul_bpm_err     = true;
        
        % calcs nominal cod response matrix, if chosen
        use_respm_from_nominal_lattice = true; 
        if use_respm_from_nominal_lattice
            fprintf('-  calculating orbit response matrix from nominal machine ...\n');
            lattice_symmetry = 1;  
            orbit.respm = calc_respm_cod(the_ring, orbit.bpm_idx, orbit.hcm_idx, orbit.vcm_idx, lattice_symmetry, true); 
            orbit.respm = orbit.respm.respm;
        end 
        
        % loops over random machine, correcting COD...
        machine = lnls_latt_err_correct_cod(name, machine, orbit);
        
        % saves results to file
        name_saved_machines = [name_saved_machines,'_machines_cod_corrected'];
        save([name_saved_machines '.mat'], 'machine');
        
    end

%% Tune Correction
    function machine = correct_tune(machine)
        
        fprintf('\n<tune correction> [%s]\n\n', datestr(now));
        
        tune.correction_flag = false;
        tune.families        = {'qf','qd'};
        [~, tune.goal]       = twissring(the_ring,0,1:length(the_ring)+1);
        tune.max_iter        = 10;
        tune.tolerance       = 1e-6;
     
        % faz correcao de tune
        machine = lnls_latt_err_correct_tune_machines(tune, machine);
        
        name_saved_machines = [name_saved_machines '_tune'];
        save([name_saved_machines '.mat'], 'machine');
    end

%% Multipoles insertion
    function machine = create_apply_multipoles(machine, family_data)
        
        fprintf('\n<application of multipole errors> [%s]\n\n', datestr(now));
        
        % QUADRUPOLES
        multi.quads.labels = {'qd','qf'};
        multi.quads.main_multipole = 2;% positive for normal negative for skew
        multi.quads.r0 = 17.5e-3;
        multi.quads.order     = [3, 4, 5, 6, 7, 8, 9]; % 1 for dipole
        multi.quads.main_vals = [7.0, 4*ones(1,6)]*1e-4;
        multi.quads.skew_vals = [10, 5, ones(1,5)]*1e-4;
        
        % SEXTUPOLES
        multi.sexts.labels = {'sd','sf'};
        multi.sexts.main_multipole = 3;% positive for normal negative for skew
        multi.sexts.r0 = 17.5e-3;
        multi.sexts.order     = [4, 5, 6, 7, 8, 9, 10]; % 1 for dipole
        multi.sexts.main_vals = ones(1,7)*4e-4; 
        multi.sexts.skew_vals = ones(1,7)*1e-4; 
        
        % DIPOLES
        multi.bends.labels = {'b'};
        multi.bends.main_multipole = 1;% positive for normal negative for skew
        multi.bends.r0 = 17.5e-3;
        multi.bends.order = [3, 4, 5, 6, 7]; % 1 for dipole
        multi.bends.main_vals = [5.5, 4*ones(1,4)]*1e-4;
        multi.bends.skew_vals = ones(1,5)*1e-4;
        
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
         
        % I have to do this for the booster, because the lattice begins at 
        % the middle of the quadrupole:
        idx = findcells(the_ring,'FamName','bpm'); idx = idx(end)-1;
        the_ring = circshift(the_ring,[0,-idx]);
        for i=1:length(machine)
            machine{i} = circshift(machine{i},[0,-idx]);
        end
        
        % adds systematic multipole errors to random machines
        for i=1:length(machine)
            machine{i} = sirius_bo_multipole_systematic_errors(machine{i});
        end
        fname = which('sirius_bo_multipole_systematic_errors');
        copyfile(fname, [name '_multipole_systematic_errors.m']);
        
        cutoff_errors = 2;
        multi_errors  = lnls_latt_err_generate_multipole_errors(name, the_ring, multi, length(machine), cutoff_errors);
        machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);
        
        for i=1:length(machine)
            machine{i} = circshift(machine{i},[0,idx]);
        end
        
        name_saved_machines = [name_saved_machines '_multi'];
        save([name_saved_machines '.mat'], 'machine');
    end
end