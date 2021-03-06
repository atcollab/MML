function [NEWLATTICE, SHIFTEDKEEPINDEX, SHIFTEDREFINDEX] = combinelinear45(LATTICE,KEEPINDEX,REFINDEX) 
%COMBINELINEAR45 combines adjacent  elements that use 4-by-5 PassMethods
% [NEWLATTICE, SHIFTEDKEEPINDEX, SHIFTEDREF] = COMBINELINEAR45(LATTICE,KEEPINDEX,REFINDEX) 


% make a new (empty) lattice
OLDN = length(LATTICE);

I45 = findcells(LATTICE,'PassMethod','Linear45Pass');

D = diff(I45);

A = 1:length(LATTICE);
A(I45(find(~(D-1))))=0;

A = ~A;

% A has been constructed such that if 
%  A(i)=1 , LATTICE{i} should be combined with LATTICE{i+1}


if ~isempty(KEEPINDEX)
    A(KEEPINDEX)=0;
    K = KEEPINDEX-1;
    if K(1)<1
        A(K(2:end))=0;
    else
        A(K)=0;
    end
else
    SHIFTEDKEEPINDEX = [];
end

if ~isempty(REFINDEX)
    R = REFINDEX-1;
    if R(1)<1
        A(R(2:end))=0;
    else
        A(R)=0;
    end
else
    SHIFTEDREFINDEX = [];
end

CSA = cumsum(A);

SHIFTEDKEEPINDEX = KEEPINDEX-CSA(KEEPINDEX);

if ~isempty(REFINDEX)
    if REFINDEX(1)<2
        SHIFTEDREFINDEX = REFINDEX-[0 CSA(REFINDEX(2:end)-1)];
    else
        SHIFTEDREFINDEX = REFINDEX-CSA(R);
    end
end


SHIFTEDREFINDEX = REFINDEX-CSA(REFINDEX-1) ;


NEWN = CSA(end);
NEWLATTICE = cell(1,NEWN);

NEWLATTICE{1}=LATTICE{1};
writepos = 1; 
for i=2:OLDN
    if A(i-1)
        NEWLATTICE{writepos}.M45 = LATTICE{i}.M45(:,1:4)*NEWLATTICE{writepos}.M45;
        NEWLATTICE{writepos}.M45(:,5)=NEWLATTICE{writepos}.M45(:,5)+LATTICE{i}.M45(:,5);
        NEWLATTICE{writepos}.Length = NEWLATTICE{writepos}.Length+LATTICE{i}.Length;
    else
        writepos = writepos+1;
        NEWLATTICE{writepos}=LATTICE{i};
    end
end
