function [Ax,Ay,As,Bx,By,Bs] = AxAyAsBxByBsOfID(template,ID,Si,s,Uc)
%function [Ax,Ay,As,Bx,By,Bs] = AxAyAsBxByBsOfID(TPS,ID,Si,s,Uc)
% TPS: Ax,Ay,As,Bx,By,Bs
% double: s, Uc(1:OSIP.NumberOfVariables)
% structure: ID = DataOfID = IDofNSRRC(NameOfID,GapOrPhaseOrCurrentOfID)
% Purpose: Obtain the Magnetic Field and Vector Potential of ID at location s with reference orbit Uc.
% Note: Linear end-poles model is used.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 12-Jun-2003
% Updated Date:
%  13-Jun-2003
%  11-Jul-2003
%  15-Jul-2003
%  02-Sep-2003
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%------------------------------------------------------------------------------
global OSIP

[Ax,Ay,As,Bx,By,Bs] = LinearEndPole(TPS,ID,Si,s,Uc);