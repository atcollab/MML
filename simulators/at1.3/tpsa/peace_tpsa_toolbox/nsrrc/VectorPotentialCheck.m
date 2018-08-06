function [Em,Ep] = VectorPotentialCheck(ID,Cuts,k,j)
%function [Em,Ep] = VectorPotentialCheck(ID,Cuts,k,j)
% double: Em, Ep
% structure: ID = DataOfID = getIDofNSRRC(NameOfID,Gap_Or_Phase_Or_Current_Of_ID)
% Purpose: Calculate the ampltitude difference of vector potential.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 05-Sep-2003
% Updated Date:
%  09-Sep-2003
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%------------------------------------------------------------------------------
fac = 0.5/ID.M;
if j ~= Cuts
    if k <= ID.M
        if k < 1
            Em = 0; Ep = 0;
        end
        if k == 1
            Em = fac; Ep = fac;
        end
        if k == 2
            Em = 3*fac; Ep = 3*fac;
        end
    elseif k > ID.NumberOfPoles-ID.M
        if k == (ID.NumberOfPoles-ID.M+1)
            Em = 1-fac; Ep = 1-fac;
        end
        if k == (ID.NumberOfPoles-ID.M+2)
            Em = 1-3*fac; Ep = 1-3*fac;
        end
        if (k > ID.NumberOfPoles)
            Em = 0; Ep = 0;
        end
    else
        Em = 1; Ep = 1;
    end
else
    if k <= ID.M
        if k == 0
            Em = 0; Ep = fac;
        elseif k == 1
            if k == ID.M
                Em = fac; Ep = 1;
            end
            if k < ID.M
                Em = fac; Ep = 3*fac;
            end
        elseif k == 2
            Em = 3*fac; Ep = 1;
        else
            disp('Error')
        end
    elseif k >= (ID.NumberOfPoles-ID.M)
        if k == ID.NumberOfPoles-ID.M
            Em = 1; Ep = 1-fac;
        elseif k == ID.NumberOfPoles-ID.M+1
            if ID.M == 1
                Em = 1-fac; Ep = 0;
            end
            if ID.M > 1
                Em = 1-fac; Ep = 1-3*fac;
            end
        elseif k == ID.NumberOfPoles-ID.M+2
            Em = 1-3*fac; Ep = 0;
        else
            disp('Error')
        end
    else
        Em = 1; Ep = 1;
    end
end
clear fac