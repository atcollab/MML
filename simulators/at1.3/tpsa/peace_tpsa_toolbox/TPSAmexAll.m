%TPSAmexAll.m
% Purpose:
% 1) TPSAmexAll.m builds all TPSA platform dependent mex-files from C-sources.
% 2) On UNIX platform, the GNU gcc compiler must be installed and properly configured.
% 3) On Windows, Microsoft Visual C++ is required.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@srrc.gov.tw
%
% Created Date: 11-Dec-2002
% Updated Date: 12-May-2003
%
% Terminology and Category:
%  Object Oriented Programming (OOP)
%  Truncated Power Series Algebra (TPSA)
%  Truncated Power Series (TPS): The basic class of TPSA.
%  One-Step Index Pointer (OSIP): The nerves of TPSA.
%
% Description:
%  OSIP is the nerves of TPSA and TPS class is the basic package of TPSA.
%  Note that the OSIP is unique in one's program/package/project.
% PS:
%  This file is referred to the Accelerator Toolbox.
%------------------------------------------------------------------------------

TPSAroot = which('TPSAmexAll');

switch computer
case 'PCWIN'
    TPSAroot = strrep(TPSAroot,'\TPSAmexAll.m','');  
case {'GLNX86', 'ALPHA', 'SOL2'}
    TPSAroot = strrep(TPSAroot,'/TPSAmexAll.m','');  
otherwise
    error('Unsupported platform!');
end

% Navigate to the directory that contains OSIP 
cd(TPSAroot)
cd OSIP
disp(['Current directory:', pwd]);

MEXCOMMAND = ['mex mxNumberOfMonomials.c'];
disp(MEXCOMMAND);
eval(MEXCOMMAND);

disp('ALL mex-files created successfully')
clear TPSAroot MEXCOMMAND