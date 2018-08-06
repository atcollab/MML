function lattice = lattice_parser(option, lattice_file_name)
% lattice = lattice_parsere(option, lattice_file_name)
% The option is a string as 'MAD8', 'TRACY', 'OPA', 'BETA', or Peace's 'APAP';
% which specifies the lattice input format.
% The lattice_file_name is a string to specify the selected lattice iput file.
% NOTE: At this moment, ONLY simple MAD8 format is accepted.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science Park, Hsinchu 30076, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Terminology and Category: MATLAB
% 2012-Jan
%--------------------------------------------------------------------------
% 1 DRIFT	drift space
% 2 BEND	bending magnet
% 3 QUADRUPOLE	quadrupole magnet
% 4 SEXTUPOLE	sextupole magnet
% 5 OCTUPOLE	octupole
% 6 MULTIPOLE	thin-lens multipole
% 7 CORRECTOR	corrector
% 8 CAVITY	RF cavity
% 9 SOLENOID	solenoid
% 10 MONITOR	beam position monitor
% 11 ROTATION	coordinate transformation rotation matrix
% 12 SHIFT	coordinate transformation shift vextor
% 13 LIMITATION	physical aperture limitation (chamber)
% 14 INSERTION	insertion device
% 15 MARKER	marker
% 16 INJECTION	injection element
%--------------------------------------------------------------------------
% ASCII code
% ascii = char(reshape(0:127, 32, 4)')
% (000~032) tabs(ASCII-9), carriage-returns(ASCII-13), and white-space(ASCII-32)
% (033~047) ! " # $ % & ' ( ) * + , - . /
% (048~057) 0 1 2 3 4 5 6 7 8 9
% (058~064) : ; < = > ? @
% (065~090) A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
% (091~096) [ \ ] ^ _ '
% (097~122) a b c d e f g h i j k l m n o p q r s t u v w x y z
% (123~126) { | } ~
% (127)
% White spaces in ASCII are [009-013, 32]:
% space, newline, carriage return, tab, vertical tab, or formfeed characters.
% Matrix(row,column): ex. a=zeros(row,column);
% <1-row*3-column cell> t={'a' 'b' 'c'} or t={'a','b','c'}; 
% <3-row*1-column cell> t={'a';'b';'c'};
% a = zeros(row,column); 
% t = {'a' 'b' 'c'} or t = {'a','b','c'}; <1x3 cell>
% t = {'a';'b';'c'}; <3x1 cell>
% Coordinate systems: (x,y,s) or (x,s,z)
%--------------------------------------------------------------------------
% function r = f(varargin)
% nargin := length((varargin)
%--------------------------------------------------------------------------

% Lattice database
global Lattice_DB

% ROPTION is used to select the lattice grammar and return the database of keywords.
% Lattice_DB.OptionNameIndex{1} = [ (1x5 double) Index-array ... ];
% Lattice_DB.OptionNameIndex{2} = { (1x5 cell) Name-array ... };
Lattice_DB.OptionNameIndex = { ...
      [1 2 3 4 5]; ...
	  {'MAD8', ...     % 1
	   'APAP', ...     % 2
	   'BETA', ...     % 3
	   'OPA',  ...     % 4
	   'TRACY', ...    % 5
	 }};
% Index of element-types
Lattice_DB.drift = 1;
Lattice_DB.bending = 2;
Lattice_DB.quadrupole = 3;
Lattice_DB.sextupole = 4;
Lattice_DB.octupole = 5;
Lattice_DB.multipole = 6; % thinlens
Lattice_DB.corrector = 7;
Lattice_DB.rfcavity = 8;
Lattice_DB.solenoid = 9;
Lattice_DB.monitor = 10;
Lattice_DB.marker = 11; % instrument
Lattice_DB.rotation = 12; % x-rotation, y-rotation, and s-rotation
Lattice_DB.shift = 13; % coordinate
Lattice_DB.limitation = 14; % aperture, el-separator, e-collimator
Lattice_DB.insertion = 15;
Lattice_DB.injection = 16;
Lattice_DB.matrix = 17;
% Lattice_DB element type and corresponding index
% Lattice_DB.eTypeNameIndex{1} = [ (1x16 double) Index-array ... ];
% Lattice_DB.eTypeNameIndex{2} = { (1x16 cell) Name-array ... };
Lattice_DB.eTypeNameIndex = { ...
    [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18]; ...
    {'DRIFT', ...       % 1
     'BEND', ...        % 2
     'QUADRUPOLE', ...  % 3
     'SEXTUPOLE', ...   % 4
     'OCTUPOLE', ...    % 5
     'MUTIPOLE', ...    % 6
     'CORRECTOR', ...   % 7
     'CAVITY', ...      % 8
     'SOLENOID', ...    % 9
     'MONITOR', ...     % 10
     'MARKER', ...      % 11
     'ROTATION', ...    % 12
     'SHIFT', ...       % 13
     'LIMITATION', ...  % 14
     'INSERTION', ...   % 15
     'INJECTION', ...   % 16
     'MATRIX', ...      % 17
     'OTHERS' ...       % 18
    };
	{{'drift','ds','sd'}; ... % 1 (AP)
     {'bending','bend','sbend','rbend','bh','bv','di','sq','dv'}; ... % 2 (AP)
     {'quadrupole','quad','qp','qg','qk','co','cv'}; ... % 3 (AP)
     {'sextupole','sext','sx'}; ... % 4 (AP)
     {'octupole','octu','oct'}; ... % 5 (AP)
     {'multipole','thinlens','multi','ld','lt'}; ... % 6 (AP)
     {'corrector','kicker','hkicker','vkicker','hc','vc'}; ... % 7 (AP)
     {'cavity','rfcavity','accelerator','accel','ca'}; ... % 8 (AP)
     {'solenoid','so'}; ... % 9 (AP)
     {'monitor','hmonitor','vmonitor','bpm','hbpm','vbpm','pu','hp','vp'}; ... % 10 (AP)
     {'rotation','yrotation','srotation','srot','yrot','ro'}; ... % 11 (AP)
     {'shift','vector','coordinate','de','df'}; ... % 12 (AP)
     {'limitation','aperture','chamber','collimator','ecollimator','rcollimator','elseparator','cl'}; ... % 13 (AP)
     {'insertion','undulator','wiggler','ce_id','id_pl','id','un','wi'}; ... % 14 (AP)
     {'marker','opticsmarker','ob'}; ... % 15 (AP)
     {'injection','septum','inj_kicker','ki','se','kv'}; ... % 16 (AP)
	 {'matrix'}; ... % 17 (AP)
	 {'instrument','beambeam','lump','fe'} ... % 18 (AP)
	}};
Lattice_DB.eTypeKeyWords = { ...
	{{'DRIFT'}; ... % 1 MAD8
	 {'SBEND','RBEND'}; ... % 2 MAD8
	 {'QUADRUPOLE'}; ... % 3 MAD8
	 {'SEXTUPOLE'}; ... % 4 MAD8
	 {'OCTUPOLE'}; ... % 5 MAD8
	 {'MULTIPOLE'}; ... % 6 MAD8
     {'HKICKER','VKICKER','KICKER'}; ... % 7 MAD8
	 {'RFCAVITY'}; ... % 8 MAD8
	 {'SOLENOID'}; ... % 9 MAD8
     {'HMONITOR','VMONITOR', 'MONITOR'}; ... % 10 MAD8
	 {'YROT','SROT'}; ... % 11 MAD8
	 {'no_shift_keyword'}; ... % 12
	 {'MARKER'}; ... % 13 MAD8
	 {'ECOLLIMATOR','RCOLLIMATOR','ELSEPARATOR'}; ... % 14 MAD8
	 {'no_insertion_keyword'}; ... % 15
	 {'no_injection_keyword'}; ... % 16
	 {'MATRIX'}; ... % 17 MAD8
	 {'INSTRUMENT','LUMP','BEAMBEAM'} ... % 18 MAD8
    }; ...
	{{'DRIFT'}; ... % 1 APAP
     {'SBEND'}; ... % 2 APAP
	 {'QUADRUPOLE'}; ... % 3 APAP
	 {'SEXTUPOLE'}; ... % 4 APAP
	 {'no_octupole_keyword'}; ... % 5
	 {'THINLENS'}; ... % 6 APAP (multipole)
	 {'HKICKER','VKICKER','KICKER'}; ... % 7 APAP
	 {'ACCELERATOR'}; ... % 8 APAP (RF cavity)
	 {'no_solenoid_keyword'}; ... % 9
     {'HMONITOR','VMONITOR','MONITOR'}; ... % 10 APAP
	 {'no_rotation_keyword'}; ... % 11
	 {'no_shift_keyword'}; ... % 12
	 {'MARKER'}; ... % 13 APAP
	 {'no_limitation'}; ... % 14
	 {'CE_ID','ID_PL'}; ... % 15 APAP (insertions)
	 {'no_matrix_keyword'}; ... % 16
	 {'no_injection_keyword'}; ... % 17
	 {'no_others_keyword'} ... % 18
	}; ...
    {{'SD'}; ... % 1 BETA (drift space)
	 {'BH','BV','DI','CO','DV','CV','SQ'}; ... % 2 BETA (bends, edges, sector)
	 {'QP','QG','QK'}; ... % 3 BETA (quadrupoles)
	 {'SX'}; ... % 4 BETA (sextupole)
	 {'no_octupole_keyword'}; ... % 5
	 {'LD','LT','CC'}; ... % 6 BETA (multipoles)
	 {'HC','VC','KI'}; ... % 7 BETA (correctors, kicker)
     {'CA','CH'}; ... % 8 BETA (cavities)
	 {'SO','SF','SR'}; ... % 9 BETA (solenoids)
	 {'HP','VP','PU'}; ... % 10 BETA (pickups, monitors)
	 {'RO'}; ... % 11 BETA (rotation)
	 {'DE','DF'}; ... % 12 BETA (shift, misalignment)
	 {'OB'}; ... % 13 BETA (markers, observation point)
	 {'CL'}; ... % 14 BETA (colimator)
	 {'ID','UN','WI'}; ... % 15 BETA (insetion, undulator, wiggler)
	 {'no_matrix_keyword'}; ... % 16
	 {'SE','KV'}; ... % 17 BETA (injections, kickers, septum)
     {'ST','FA','FE','CI','BM'} ... % 18 BETA (other components)
    }; ...
    {{'DRIFT'}; ... % 1 OPA
	 {'BENDING','LONGGRADBEND'}; ... % 2 OPA(3)
	 {'QUADRUPOLE'}; ... % 3 OPA
	 {'SEXTUPOLE'}; ... % 4 OPA
	 {'OCTUPOLE'}; ... % 5 OPA(3)
	 {'COMBINED','DECAPOLE'}; ... % 6 OPA(3) (multipole, combined, decapole)
	 {'H-CORRECTOR','V-CORRECTOR'}; ... % 7 OPA(3)
	 {'no_cavity_keyword'}; ... % 8
     {'SOLENOID'}; ... % 9 OPA
     {'MONITOR'}; ... % 10 OPA(3)
	 {'no_rotation_keyword'}; ... % 11
	 {'no_shift_keyword'}; ... % 12
     {'MARKER','OPTICSMARKER'}; ... % 13 OPA
	 {'no_limitation'}; ... % 14
	 {'UNDULATOR'}; ... % 15 OPA
	 {'MATRIX'}; ... % 16 OPA
	 {'KICKER', 'SEPTUM'}; ... % 17 OPA
	 {'PHASEKICK','PHOTONBEAM'} ... % 18 OPA
	}; ...
... %ElemType_TRACY = ...
    {{'DRIFT'}; ... % 1 TRACY
	 {'BENDING'}; ... % 2 TRACY
	 {'QUADRUPOLE'}; ... % 3 TRACY
	 {'SEXTUPOLE'}; ... % 4 TRACY
	 {'no_octupole_keyword'}; ... % 5
	 {'MULTIPOLE'}; ... % 6 TRACY
	 {'CORRECTOR'}; ... % 7 TRACY
	 {'CAVITY'}; ... % 8 TRACY
	 {'no_solenoid_keyword'}; ... % 9
	 {'BEAM POSITION MONITOR'}; ... % 10 TRACY (???)
	 {'no_rotation_keyword'}; ... % 11
	 {'no_shift_keyword'}; ... % 12
     {'MARKER'}; ... % 13 TRACY
	 {'no_limitation'}; ... % 14
	 {'WIGGLER'}; ... % 15 TRACY
	 {'no_matrix_keyword'}; ... % 16
	 {'no_injection_keyword'}; ... % 17
	 {'no_others_keyword'} ... % 18
	}};
% AT
Lattice_DB.eD_V6 = zeros(1,6); % [0 0 0 0 0 0]
Lattice_DB.V6_AT = { ...
    {}; ... % 1
    {'BendingAngle','EntranceAngle','ExitAngle','ByError','K'}; ... % 2
    {'K'}; ... % 3 K1
    {'K'}; ... % 4 K2
    {'K'}; ... % 5 K3
    {'BendingAngle'}; ... % 6
    {'KickAngle'}; ... % 7, [0 0]
    {'Voltage','Frequency','HarmNumber','PhaseLag'}; ... % 8
    {'K'}; ... % 9, KS
    {'Name'}; ... % 10, [HBPM VBPM BPM]
    {}; ... % 11
    {}; ... % 12
    {'Limits'}; ... % 13, [0 0 0 0]
    {}; ... % 14
    {}; ... % 15
    {}; ... % 16
	{}; ... % 17
	{} % 18
	};
% Magnets: soleonid/sextupole/quadrupole/multipole/bend(rbend,sbend)
Lattice_DB.eD_S6 = struct( ...
    'MaxOrder', 3, ...
    'NumIntSteps', 1, ...
    'R1', diag(ones(6,1)), ...
    'R2', diag(ones(6,1)), ...
    'T1', zeros(1,6), ...
    'T2', zeros(1,6));
Lattice_DB.eD_P2 = struct( ...
    'PolynomA', [0 0 0 0], ... % skew [dipo quad sext oct]
    'PolynomB', [0 0 0 0]);    % nomal
Lattice_DB.eDtype = { ...
    []; ... 						% 1
    struct('BendingAngle',0,'EntranceAngle',0, ...
    'ExitAngle',0,'ByError',0,'K',0); ...		% 2
    struct('K',0); ...					% 3
    []; ...					% 4
    []; ...					% 5
    struct('BendingAngle',0); ... 			% 6
    struct('KickAngle',[0 0]); ... 			% 7
    struct('Voltage',0,'Frequency',0, ...
    'HarmNumber',0,'PhaseLag',0); ... 			% 8
    struct('K',0); ... 					% 9
    struct('Name',0); ... 						% 10
    []; ... 						% 11
    []; ... 						% 12
    struct('Limits',[-0.1 0.1 -0.1 0.1]); ... 		% 13
    []; ... 						% 14
    []; ... 						% 15
    []};
% Element data
Lattice_DB.eData = struct( ...
    'FamName','', ...
    'Length',0, ...
    'MAD_Type','', ... % (MAD)
    'PassMethod','', ... % (AT)
    'Pt',[], ...     % Lattice_DB.eDtype{Lattice_DB.e.Type}; (AT)
    'V6',[], ...	% Type 2,6,7,8,9,13
    'P2',[], ...	% Type 2,3,4,5,6; (AT)
    'S6',[]);		% Type 2,3,4,5,6; (AT)
% Element
Lattice_DB.e = struct( ...
    'FamName','', ...
    'Type',[], ...
    'TypeName','', ...
    'TPSA',[], ... % TPS for TPSA calculation
    'NumKids',0, ...
    'KidsList',[], ...
    'ElemData',Lattice_DB.eData);
% Followings are parameters for each type.
Lattice_DB.eTypeFields = { ...
 {'type';'l'}; ... % 1
 {'type';'l';{'angle','t'};'k0';{'e1','t1','ei'};{'e2','t2','eo'};'k1';'k2';'k3';'tilt';'h1';'h2';'fint'}; ... % 2
 {'type';'l';{'k1','k'};'tilt'}; ... % 3
 {'type';'l';{'k2','k'};'tilt'}; ... % 4
 {'type';'l';{'k3','k'};'tilt'}; ... % 5
 {'type';'k0l';'k1l';'k2l';'k3l';'sk0l';'sk1l';'sk2l';'sk3l'}; ... % 6
 {'type';'l';{'hkick','kx'};{'vkick','ky'};{'kick','k0','k'}}; ... % 7
 {'type';'l';{'volt','v','vg'};{'frequency','f'};{'harmon','hn','h'};{'lag','pl','p'}}; ... % 8
 {'type';'l';'ks'}; ... % 9
 {'type';'l'}; ... % 10
 {'type';'angle'}; ... % 11
 {'type';{'dx','x'};{'dpx','px'};{'dy','y'};{'dpy','py'}}; ... % 12
 {'type';'l';{'xsize','x'};{'ysize','y'};'xmin';'xmax';'ymin';'ymax'}; ... % 13
 {'type';'l';{'npole','n'};{'bmax','b0','b'};{'nstep'};{'nmesh'};{'nhharm'};{'nvharm'};'bx';'by'}; ... % 14
 {'type'}; ... % 15
 {'type';'l'}; ... % 16
 {'type';'r11';'r12';'r13';'r14';'r15';'r16';'r21';'r22';'r23';'r24';'r25';'r26';
         'r31';'r32';'r33';'r34';'r35';'r36';'r41';'r42';'r43';'r44';'r45';'r46';
		 'r51';'r52';'r53';'r54';'r55';'r56';'r61';'r62';'r63';'r64';'r65';'r66'}; ... % 17
 {'type'} ... % 18
 };
Lattice_DB.Field = struct('Name','','Data',[]);
Lattice_DB.BlockType = {'line';'ceid'};
Lattice_DB.Block = struct( ...
    'Name', '', ... % lower(label)
    'Type', [], ... % 1: line; 2: ce_id
    'TypeName', '', ... %
    'List', [], ... % element-list
    'n', 0); % number of element in "List"
Lattice_DB.Commands = { ...
    'title'; ...
    'use'; ...
    'stop'; ...
    'particle'; ...
    'pipesize'; ...
    'beam'; ...
    'orbit_0'; ...
    'strength_err'; ...
    'random_seed'; ...
    'iteration'; ...
    'esp_value'};
% Definition of word's character set = [a-z, A-Z, _, 0-9]
Lattice_DB.WordCharSet = ...
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789';
Lattice_DB.WordHead = 52;
% Definition of numeric character set [0-9, ., +, -, d, D, e, E]
Lattice_DB.NumCharSet = '0123456789.+-dDeE';
Lattice_DB.NumHead = 13;
Lattice_DB.C0 = 299792458; % speed of light (m/sec)
Lattice_DB.Particle = { ... % mass (eV/c^2), charge 1 := 4.803242e-10 (esu) or 1.6021892e-19 (coulomb)
    struct('Name', 'electron', 'Mass', 0.5110034e+6, 'Charge', -1.0); ... % electron
    struct('Name', 'proton', 'Mass', 938.2796e+6, 'Charge', 1.0); ... % proton mass
    struct('Name', 'positron', 'Mass', 0.5110034e+6, 'Charge', 1.0) ... % positron
    };
% Decide which lattice input format is specified by 'option'
% Select the corresponding keyword-list of element types
% default lattice format is (AP)
Lattice_DB.format = 6;
OP = upper(option);
id = strmatch(OP,Lattice_DB.OptionNameIndex{2},'exact')
%l = length(id);
if length(id) ~= 1
   display(['lattice = lattice_parser(option, lattice_file_name)']);
   error(['The lattice format specified by the option (' option ') is not defined yet!']);
else
   Lattice_DB.format = id;
end
if id > 2
   display(['lattice = lattice_parser(option, lattice_file_name)']);
   error(['The specified lattice format (' option ') has not been implemented completely yet!']);
end
Lattice_DB.elem_type = Lattice_DB.eTypeKeyWords{Lattice_DB.format};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decode the specified input lattice file and construct the lattice
global lattice

% Try to open the specified lattice file.
fid = 0;
if ~isempty(lattice_file_name)
    fid = fopen(lattice_file_name,'r');
end
while fid < 1
    display(['Can not open the file: ' lattice_file_name]);
    lattice_file_name = input(' Open an other lattice file: ', 's');
    [fid,message] = fopen(lattice_file_name,'r');
    if fid == -1
        error(message);
    end
end
% Start to build up the lattice data structure from the lattice input file.
lattice.Name = lattice_file_name;
lattice.Title = 'Title: the description of this lattice.';
lattice.Global = struct('C0', 299792458, ... % Speed of light [m/sec]
						'E0', 0.0e0, ...     % Energy [eV]
						'L0', 0.0e0);        % Design length [m]
lattice.Global.LightSpeed = lattice.Global.C0; % [m/sec]
lattice.Global.Energy = lattice.Global.E0; % (GeV)
lattice.Global.Circumference = lattice.Global.L0; % [m]
lattice.Particle = struct('Q', -1, ...            % e
						  'M', 0.5110034e+6);  % eV
lattice.Particle.Chagre = lattice.Particle.Q; % electron: -1; proton and positron: 1
lattice.Particle.Mass = lattice.Particle.M; % electron and positron: 0.5110034e+6; proton: 938.2796e+6
lattice.RF = struct('v', 5.0e+6, ...   % Gap voltage [eV]
					'f', 500.0e+6, ... % Frequency [Hz]
					'h', 864, ...      % Harmonic number
					'l', 0);           % Cavity length (not the wavelength)
lattice.RF.Voltage = lattice.RF.v;
lattice.RF.Frequency = lattice.RF.f;
lattice.RF.Harmonic = lattice.RF.h;
lattice.RF.Length = lattice.RF.l;
% RF_frequency = HarmNumber*Speed_of_light/Circumference;

% lattice.Variable :
% lattice.Variable{i}.Name
% lattice.Variable{i}.Value
latticeVariableN = 0;

% lattice.Element : objects of ap_element class
% lattice.Element(i)
lattice.ElementN = 0;

% lattice.Block :
% lattice.Block(i).Name
% lattice.Block(i).Type
% lattice.Block(i).TypeName
% lattice.Block(i).List
% lattice.Block(i).n
lattice.BlockN = 0;
lattice.BeamLine = Lattice_DB.Block'';
lattice.BeamLine.TypeName = 'THERING';
% USE, LineName; (i.e. one of the lattice.Block(i).Name)

error_flag = 0;
while (feof(fid) == 0 && error_flag == 0)
    line = fgetl(fid);
    % Leading character shows it is a comment-line ?
    [yc c rc] = white_line(line);
    [yw w rw] = wanted_word(line,'',0);
    
    % skip the empty or comment line
    if yc == 1 % skip the white line and continue
        continue;
    end
    % no a white line, then check if it is a comment line ?
    if c == '!' % Standard comment-line of MAD and APAP
        continue
    elseif c == '{' % OPA's comment-line ?
        [yy cc] = last_char(line);
        if ~((yy == 1) && (cc == '}'))
           display(['lattice_parser ERROR: ' line]);
           error('The line starting with { character is not ended with }.');
        end
        continue
    elseif ((c == '/') && (rc(1) == '/')) % C++ type comment-line //
        continue
    end
    
    % it seems not a white line or a comment line, then check the first word
    if (yw == 0) % What's happened?
        display(['lattice_parser ERROR: ' line]);
        error('A "word" taken as "label" or "command" is needed!');
    end
    idx = search_keyword2(lower(w),Lattice_DB.Commands);
    if idx(1) > 0
        switch idx(1) % If idx(1) > 0, it's a command line.
            case 1 % 'title'
                y1 = 1;
                while y1 > 0
                    [y1 c1 r1] = wanted_char(rw,',&!=');
                    if (y1 == 1) || (y1 == 4) % skip the character ','
                       rw = r1;
                    elseif y1 == 2
                        rw = fgetl(fid);
                        next = 1;
                    elseif (y1 == 3) && (next == 1)
                        rw = fgetl(fid);
                    else % TITLE title-string
                        next = 0;
                        lattice.Title = strtrim(rw);
                    end
                end
            case 2 % 'use'
                [y1 c1 r1] = wanted_char(rw,',');
                if (y1 == 1) && (c1 == ',')
                    [y2 w2 r2] = wanted_word(r1,'',0);
                    if y2 ~= 1
                        display('lattice_parser ERROR: use');
                        error('Need a name of block/line defined previously.');
                    else
                        line_name = lower(w2);
                        lattice.BeamLine.Name = line_name;
                        if lattice.BlockN > 0
                            is_find = 0;
                            for b = 1:lattice.BlockN
                                block_id = strmatch(line_name,lattice.Block(b).Name,'exact');
                                if ~isempty(block_id)
                                    lattice.BeamLine.List = lattice.Block(b).List;
                                    lattice.BeamLine.n = lattice.Block(b).n;
                                    is_find = 1;
                                    break
                                end
                            end
                            if is_find == 0
                                display('lattice_parser ERROR: use');
                                error('The name of beam-line has not defined.');
                            end
                        else
                            display('lattice_parser ERROR: use');
                            error('No line/block has been defined.');
                        end
                    end
                else
                    display(['lattice_parser ERROR: ' w '@' line]);
                    error('Command "use" error.');
                end
            case 3 % 'stop'
                % stop for MAD and TRACY but continue for APAP
            case 4 % 'particle'
                y1 = 1;
                while y1 == 1
                    [y1 c1 r1] = wanted_char(rw,',;');
                    if y1 == 1
                         [y1 w1 r1] = wanted_word(r1,'',0);
                         if (y1 == 1) && ((w1 == 'Q') || (w1 == 'M'))
                              [y1 c1 r1] = wanted_char(r1,'=');
                              [y2 n2 r2] = wanted_number(r1);
                              if (y1 == 1) && (y2 == 1)
                                  if w1 == 'Q'
                                      lattice.Particle.Q = n1;
                                  elseif w1 == 'M'
                                      lattice.Particle.M = n1;
                                  end
                              else
                                  display(['lattice_parser ERROR: ' w ' ' w1 '@' line]);
                                  error('Command "particle" error.');
                              end
                         else
                            display(['ERROR: ' w '@' line]);
                            error('Command error.');
                         end
                    end
                end
            % otherwise case 5,6,7,8,9,10,11 % under developement
        end
    else % The first word of line is not a "command", it is a "label".
        [y1 c1 r1] = wanted_char(rw,':;');
        if y1 == 0
            display(['lattice_parser ERROR: ' w ' ' c1 '@' line]);
            error('Statement error.');
        end
        if y1 == 2
            display(['lattice_parser WARNING: ' w ' ;@' line]);
            display('A dummy word only.');
        end
        if y1 == 1  % Block, Element-Type, or Variable
            [y2 c2 r2] = wanted_char(r1,'=');
            if y2 == 1 % Variable := value;
                latticeVariableN = latticeVariableN+1;
                lattice.Variable{latticeVariableN}.Name = w;
                [y2 n2 r2] = wanted_number(r2);
                if y2 == 1
                     lattice.Variable{latticeVariableN}.Value = n2;
                else
                    display(['lattice_parser ERROR: ' w ' ' c2 ' ' r2 '@' line]);
                    error('Variable error.');
                end
            else  % Block or Element-Type
                rk = r1; % recover the remainder string
                [yk wk r2] = wanted_word(rk,'',0);
                if (yk == 0) || (isempty(wk))
                    display(['lattice_parser ERROR: ' w ': (???)@' line]);
                    error('Element error or Block error.');
                end
                kw = search_keyword2(wk,Lattice_DB.BlockType);
                f = search_keyword2(wk,Lattice_DB.elem_type);
                if (kw(1) == 0) && (f(1) == 0)
                    disp(line)
                    display(['lattice_parser ERROR: label = ' w ' , keyword = ' wk ' , kw = ' num2str(kw) ' , f = ' num2str(f)]);
                    error('Element or Block is without right KEYWORD.');
                end
                if kw(1) ~= 0 % Block
                    lattice.BlockN = lattice.BlockN +1;
                    lattice.Block(lattice.BlockN) = Lattice_DB.Block;
                    lattice.Block(lattice.BlockN).Name = lower(w);
                    lattice.Block(lattice.BlockN).Type = kw(1);
                    lattice.Block(lattice.BlockN).TypeName = Lattice_DB.BlockType{kw(1)};
                    % decode line/block
                    rr = r2;
                    [list rr] = new_block(0,rr,fid,lattice.ElementN,lattice.Element,lattice.BlockN-1,lattice.Block);
                    %display(list)
                    lattice.Block(lattice.BlockN).List = list;
                    lattice.Block(lattice.BlockN).n = length(lattice.Block(lattice.BlockN).List );
                end
                if f(1) ~= 0 % Lattice Element
                    str = r2;
                    lattice.ElementN = lattice.ElementN+1;
                    new_e = new_element(lower(w),f,str,fid);
                    lattice.Element(lattice.ElementN) = new_e;
                end
            end
        end
    end
end
fclose(fid);
%lattice.RF.f = lattice.RF.h*lattice.Global.C0/lattice.Global.L0;

% Translate the lattice data to the AT
display('You may declare "global FAMLIST THERING GLOBVAL" before using lattice_parser');
global FAMLIST THERING GLOBVAL

% Extract the GLOBVAL data
% One may add more needed GLOBVAL data here.
% Check the energy
if lattice.Global.Energy == 0
	GLOBVAL.E0 = 3e9; % default energy 3 GeV
else
	GLOBVAL.E0 = lattice.Global.Energy*1e9; % Unit is eV
end
GLOBVAL.LatticeFile = lattice.Name;

% Extract the element list (FAMLIST)
e_list = lattice.Element;
for i=1:length(e_list)
    FAMLIST{i}.FamName  = e_list(i).FamName;
    FAMLIST{i}.NumKids  = e_list(i).NumKids;
    FAMLIST{i}.KidsList = e_list(i).KidsList;
    if ~isempty(e_list(i).ElemData.S6) % 2, 3, 4, 5, 6
        ElemData.MaxOrder = e_list(i).ElemData.S6.MaxOrder;
        ElemData.NumIntSteps = e_list(i).ElemData.S6.NumIntSteps;
        ElemData.R1 = e_list(i).ElemData.S6.R1;
        ElemData.R2 = e_list(i).ElemData.S6.R2;
        ElemData.T1 = e_list(i).ElemData.S6.T1;
        ElemData.T2 = e_list(i).ElemData.S6.T2;
    end
    if ~isempty(e_list(i).ElemData.P2)
        ElemData.PolynomA = e_list(i).ElemData.P2.PolynomA;
        ElemData.PolynomB = e_list(i).ElemData.P2.PolynomB;
    end
    switch e_list(i).Type(1)
        case 1
            ElemData.PassMethod = 'DriftPass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
        case 2
            ElemData.PassMethod = 'BendLinearPass';
            %ElemData.PassMethod = 'MPoleSymplectic4Pass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
            if ~isempty(e_list(i).ElemData.V6)
                ElemData.BendingAngle = e_list(i).ElemData.V6(1);
                ElemData.EntranceAngle = e_list(i).ElemData.V6(2);
                ElemData.ExitAngle = e_list(i).ElemData.V6(3);
                ElemData.ByError = e_list(i).ElemData.V6(4);
                ElemData.K = e_list(i).ElemData.V6(5);
            end
            if ~isempty(e_list(i).ElemData.Pt)
                ElemData.BendingAngle = e_list(i).ElemData.Pt.BendingAngle;
                ElemData.EntranceAngle = e_list(i).ElemData.Pt.EntranceAngle;
                ElemData.ExitAngle = e_list(i).ElemData.Pt.ExitAngle;
                ElemData.ByError = e_list(i).ElemData.Pt.ByError;
                ElemData.K = e_list(i).ElemData.Pt.K;
            end
        case 3
            ElemData.PassMethod = 'QuadLinearPass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
            if ~isempty(e_list(i).ElemData.V6)
                ElemData.K = e_list(i).ElemData.V6(1); 
            end
            if ~isempty(e_list(i).ElemData.Pt)
                ElemData.K = e_list(i).ElemData.Pt.K;
            end
        case 4
            ElemData.PassMethod = 'StrMPoleSymplectic4Pass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
            if ~isempty(e_list(i).ElemData.V6)
                ElemData.K = e_list(i).ElemData.V6(1);
            end
            if ~isempty(e_list(i).ElemData.Pt)
                ElemData.K = e_list(i).ElemData.Pt.K;
            end
        case 5 % OCTUPOLE
            if e_list(i).ElemData.Length ~= 0
                ElemData.PassMethod = 'StrMPoleSymplectic4Pass';
            else
                ElemData.PassMethod = 'ThinMPolePass';
            end
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
            if ~isempty(e_list(i).ElemData.V6)
                ElemData.K = e_list(i).ElemData.V6(1);
            end
            if ~isempty(e_list(i).ElemData.Pt)
                ElemData.K = e_list(i).ElemData.Pt.K;
            end
        case 6 % MULTIPOLE
            ElemData.PassMethod = 'StrMPoleSymplectic4Pass';
            %ElemData.PassMethod = 'ThinMPolePass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
            if ~isempty(e_list(i).ElemData.V6)
                ElemData.K = e_list(i).ElemData.V6(1);
            end
            %if ~isempty(e_list(i).ElemData.Pt)
            %    ElemData.K = e_list(i).ElemData.Pt.K;
            %end
        case 7
            ElemData.PassMethod = 'CorrectorPass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
            if ~isempty(e_list(i).ElemData.V6)
                ElemData.KickAngle = [e_list(i).ElemData.V6(1:2)];
            end
            if ~isempty(e_list(i).ElemData.Pt)
                ElemData.KickAngle = e_list(i).ElemData.Pt.KickAngle;
            end
        case 8
            ElemData.PassMethod = 'CavityPass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
            if ~isempty(e_list(i).ElemData.V6)
                ElemData.Voltage = e_list(i).ElemData.V6(1);
                ElemData.Frequency = e_list(i).ElemData.V6(2);
                ElemData.HarmNumber = e_list(i).ElemData.V6(3);
                ElemData.PhaseLag = e_list(i).ElemData.V6(4);
            end
            if ~isempty(e_list(i).ElemData.Pt)
                ElemData.Voltage = e_list(i).ElemData.Pt.Voltage;
                ElemData.Frequency = e_list(i).ElemData.Pt.Frequency;
                ElemData.HarmNumber = e_list(i).ElemData.Pt.HarmNumber;
                ElemData.PhaseLag = e_list(i).ElemData.Pt.PhaseLag;
            end
        case 9
            ElemData.PassMethod = 'SolenoidLinearPass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
            if ~isempty(e_list(i).ElemData.V6)
                ElemData.K = e_list(i).ElemData.V6(1);
            end
            if ~isempty(e_list(i).ElemData.Pt)
                ElemData.K = e_list(i).ElemData.Pt.K;
            end
        case 10
            ElemData.PassMethod = 'DriftPass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
            if ~isempty(e_list(i).ElemData.V6)
                ElemData.Name = e_list(i).ElemData.V6(1);
            end
            if ~isempty(e_list(i).ElemData.Pt)
                ElemData.Name = e_list(i).ElemData.Pt.Name;
            end
        case 11 % ROTATION
            display('TYPE 11 (ROTATION) is not available in AT');
        case 12 % SHIFT
            display('TYPE 12 (SHIFT) is not available in AT');
        case 13
            ElemData.PassMethod = 'DriftPass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
            if ~isempty(e_list(i).ElemData.V6)
                ElemData.Limits = [e_list(i).ElemData.V6(1:4)];
            end
            if ~isempty(e_list(i).ElemData.Pt)
                ElemData.Limits = e_list(i).ElemData.Pt.Limits;
            end
        case 14 % INSERTION (wiggler)
            ElemData.PassMethod = 'LieMapPass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length;
            if ~isempty(e_list(i).ElemData.V6)
                if e_list(i).ElemData.V6(1) > 0
                    ElemData.Lw = e_list(i).ElemData.Length/e_list(i).ElemData.V6(1);
                else
                    ElemData.Lw = e_list(i).ElemData.Length;
                end
                ElemData.Bmax = e_list(i).ElemData.V6(2);
                ElemData.Nstep = e_list(i).ElemData.V6(3);
                ElemData.Nmeth = e_list(i).ElemData.V6(4);
                ElemData.NHharm = e_list(i).ElemData.V6(5);
                ElemData.NVharm = e_list(i).ElemData.V6(6);
            end
            if ~isempty(e_list(i).ElemData.Pt)
                ElemData.Lw = e_list(i).ElemData.Pt.Lw;
                ElemData.Bmax = e_list(i).ElemData.Pt.Bmax;
                ElemData.Nstep = e_list(i).ElemData.Pt.Nstep;
                ElemData.Nmeth = e_list(i).ElemData.Pt.Nmeth;
                ElemData.NHharm = e_list(i).ElemData.Pt.NHharm;
                ElemData.NVharm = e_list(i).ElemData.Pt.NVharm;
            end
        case 15
            ElemData.PassMethod = 'IdentityPass';
            ElemData.FamName = e_list(i).FamName;
            ElemData.Length = e_list(i).ElemData.Length; % = 0
        case 16 % INJECTION (KICKER -> CORRECTOR ?)
            display('TYPE 16 (INJECTION) is not available in AT');
        otherwise
            display('TYPE is not available in AP and AT');
    end
    FAMLIST{i}.ElemData = ElemData;
end

% Extract the particle beam line (THERING)
beam_line = lattice.BeamLine.List;
THERING=cell(size(beam_line));
for i=1:length(THERING)
   THERING{i} = FAMLIST{beam_line(i)}.ElemData;
   FAMLIST{beam_line(i)}.NumKids=FAMLIST{beam_line(i)}.NumKids+1;
   FAMLIST{beam_line(i)}.KidsList = [FAMLIST{beam_line(i)}.KidsList i];
end





