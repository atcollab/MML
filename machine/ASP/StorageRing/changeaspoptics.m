function varargout = changeaspoptics(varargin)
% RING = CHANGEASPOPTICS([RING or 'model'],[number]) is used to change the
% optics of RING or if 'model' is specified then it will modify the lattice
% that is stored in the global variable THERING. If no string parameters
% are used then a list of options will be displayed for the user to
% interactively choose.

if nargin >= 1
    usemodel = 0;
    RING = {};
    if iscell(varargin{1})
        RING = varargin{1};
        FAMLIST = buildfamlist(RING);
    elseif strcmpi(varargin{1},'model')
        global THERING FAMLIST
        RING = THERING;
        usemodel = 1;
    end
else
    fprintf('\nRING not defined. See help below for more info\n\n');
    help changeaspoptics
    return
end

if nargin >= 2 & isnumeric(varargin{2})
    selection = varargin{2};
else
    selection = menu('Choose the optics for the ASP SR lattice',...
        '[13.3 5.2] 0.00 disp [0.0 0.0] chrom (+-14)',...
        '[13.3 5.2] 0.10 disp [0.0 0.0] chrom (+-14)',...
        '[13.3 5.2] 0.24 disp [0.0 0.0] chrom (+-14)',...
        '[13.3 5.2] 0.00 disp [1.0 1.0] chrom (+-14)',...
        '[13.3 5.2] 0.10 disp [1.0 1.0] chrom (+-14)',...
        '[13.3 5.2] 0.24 disp [1.0 1.0] chrom (+-14)');
end

% Make parameter groups for the major magnet families.
qfa = mkparamgroup(RING,'qfa','K');
qda = mkparamgroup(RING,'qda','K');
qfb = mkparamgroup(RING,'qfb','K');
sfa = mkparamgroup(RING,'sfa','K2');
sda = mkparamgroup(RING,'sda','K2');
sdb = mkparamgroup(RING,'sdb','K2');
sfb = mkparamgroup(RING,'sfb','K2');


switch selection
    case 1
        qfaval =  1.7617410683215;
        qdaval = -1.038377057025;
        qfbval =  1.5338016353322;
        sfaval =  1.400000e+001;
        sdaval = -1.400000e+001;
        sdbval = -7.0146346579091;
        sfbval =  7.1893457157312;
    case 2
        qfaval =  1.772006257777;
        qdaval = -1.038979133445;
        qfbval =  1.5282806930542;
        sfaval =  1.400000e+001;
        sdaval = -1.400000e+001;
        sdbval = -7.0943368258914;
        sfbval =  7.0061440937644;
    case 3
        qfaval =  1.788288337253;
        qdaval = -1.040097688513;
        qfbval =  1.5198075294908;
        sfaval =  1.400000e+001;
        sdaval = -1.400000e+001;
        sdbval = -7.719687342473;
        sfbval =  6.9366519209212;
    case 4
        qfaval =  1.7617410683215;
        qdaval = -1.038377057025;
        qfbval =  1.5338016353322;
        sfaval =  1.400000e+001;
        sdaval = -1.400000e+001;
        sdbval = -7.2625874274048;
        sfbval =  7.4301465642566;
    case 5
        qfaval =  1.772006257777;
        qdaval = -1.038979133445;
        qfbval =  1.5282806930542;
        sfaval =  1.400000e+001;
        sdaval = -1.400000e+001;
        sdbval = -7.4114847309303;
        sfbval =  7.3195664597002;
    case 6
        qfaval =  1.788288337253;
        qdaval = -1.040097688513;
        qfbval =  1.5198075294908;
        sfaval =  1.400000e+001;
        sdaval = -1.400000e+001;
        sdbval = -8.2576610441099;
        sfbval =  7.4837072741028;
    otherwise
        disp('Invalid selection!!');
end

RING = setparamgroup(RING,qfa,qfaval);
RING = setparamgroup(RING,qda,qdaval);
RING = setparamgroup(RING,qfb,qfbval);
RING = setparamgroup(RING,sfa,sfaval);
RING = setparamgroup(RING,sda,sdaval);
RING = setparamgroup(RING,sdb,sdbval);
RING = setparamgroup(RING,sfb,sfbval);

if usemodel
    THERING = RING;
else
    varargout{1} = RING;
end





function FAMLIST = buildfamlist(RING)

elnames = {};
elfamilies = {};
for i=1:length(RING)
    elnames{i} = RING{i}.FamName;
end
elfamilies = unique(elnames);

FAMLIST = {};
for i=1:length(elfamilies)
    FAMLIST{i}.FamName = elfamilies{i};
    FAMLIST{i}.KidsList = findcells(RING,'FamName',elfamilies{i});
    FAMLIST{i}.NumKids = length(FAMLIST{i}.KidsList);
    FAMLIST{i}.ElemData = RING{FAMLIST{i}.KidsList(1)};
end

