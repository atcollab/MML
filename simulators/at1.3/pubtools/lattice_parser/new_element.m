function  e = new_element(label,type,varargin)
%NEW_ELEMENT: construct an Accelerator Physics Element
% e = new_element(label,type,varargin)
% label: the element-name at the begining of the element-definition line.
% type : the element-type after the label in the element-definition line.
% varargin{1}: remainder of the element-definition line.
% varargin{2}: file identity (fid) given by the caller.
%-------------------------------------------------------------------------------
% nargin := length(varargin)+2(label and type)
% If the element-data is given from an file-id, the varargin{2} may be '&'.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science Park, Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
%  lattice/@ap_element/ap_element.m
% Terminology and Category: OOP in MATLAB
%--------------------------------------------------------------------------
global Lattice_DB

if (nargin ~= 4)
    error('NEW_ELEMENT ERROR: check nargin".');
end

% nargin == 4 (label, type, varargin{1}, varargin{2})
str = varargin{1};
fid = varargin{2};
if fid == -1
    error('NEW_ELEMENT ERROR: check "varargin".');
end

t_id = 0;
if ischar(type)
    t = lower(type);
    t_id = search_keyword2(t,Lattice_DB.eTypeNameIdx{3});
    if t_id(1) == 0
        display(['Label: ' name ' Type: ' type]);
        error('NEW_ELEMENT ERROR: No such type is defined!');
    end
elseif isnumeric(type)
    t_id = type;
else
    error('NEW_ELEMENT ERROR: "type" = "keyword" or "type_id" (interger).')
end
e = Lattice_DB.e;
e.FamName = label;
e.Type = t_id;
e.TypeName = Lattice_DB.eTypeNameIndex{2}{t_id(1)};
e.ElemData.FamName = e.FamName;
e.ElemData.Pt = Lattice_DB.eDtype{t_id(1)}; % for AT
%e.ElemData.TPSA = TPS(); % for Hamiltonian Dynamics and Lie Algebra Method
switch e.Type(1)
    case 1 % drift space (1)
    case 2 % bending magnet (2)
        e.ElemData.P2 = Lattice_DB.eD_P2;
        e.ElemData.V6 = Lattice_DB.eD_V6;
        e.ElemData.S6 = Lattice_DB.eD_S6;
    case 3 % quadrupole magnet (3)
        e.ElemData.P2 = Lattice_DB.eD_P2;
        e.ElemData.S6 = Lattice_DB.eD_S6;
    case 4 % sextupole magnet (4)
        e.ElemData.P2 = Lattice_DB.eD_P2;
        e.ElemData.S6 = Lattice_DB.eD_S6;
    case 5 % octupole (5)
        e.ElemData.P2 = Lattice_DB.eD_P2;
        e.ElemData.S6 = Lattice_DB.eD_S6;
    case 6 % thin-lens multipole (6)
        e.ElemData.P2 = Lattice_DB.eD_P2;
        e.ElemData.V6 = Lattice_DB.eD_V6;
        e.ElemData.S6 = Lattice_DB.eD_S6;
    case 7 % corrector (7)
        e.ElemData.V6 = Lattice_DB.eD_V6;
    case 8 % RF cavity (8)
        e.ElemData.V6 = Lattice_DB.eD_V6;
    case 9 % solenoid (9)
        e.ElemData.V6 = Lattice_DB.eD_V6;
    case 10 % beam position monitor (10)
        e.ElemData.V6 = Lattice_DB.eD_V6;
    case 11 % coordinate rotation matrix (11)
        e.ElemData.P2 = Lattice_DB.eD_P2;
    case 12 % coordinate shift vector (12)
        e.ElemData.S6 = Lattice_DB.eD_S6;
    case 13 % physical aperture limitation (chamber) (13)
        e.ElemData.V6 = Lattice_DB.eD_V6;
    case 14 % insertion device (14)
        e.ElemData.V6 = Lattice_DB.eD_V6;
        e.ElemData.P2 = Lattice_DB.eD_P2;
        e.ElemData.S6 = Lattice_DB.eD_S6;
    case 15 % marker (15)
        e.ElemData.V6 = Lattice_DB.eD_V6;
    case 16 % injection element (16)
        e.ElemData.V6 = Lattice_DB.eD_V6;
    otherwise
end
e = elem_data(e,str,fid);
%e = class(e,'new_element'); % OOP in MATLAB