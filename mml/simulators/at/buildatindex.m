function ATIndexDev = buildatindex(Family, FamName)
%BUILDATINDEX - Finds the AT indices from the AT lattice for a given Family
%  ATIndexDev = buildatindex(Family, FamName);
%  ATIndexDev = buildatindex(Family, ATindex);
%  ATIndexDev = buildatindex(DeviceList, FamName);
%  ATIndexDev = buildatindex(DeviceList, ATindex);
%
%  INPUTS
%  1. Family  - MML Family name
%  2. FamName - AT Family name {optional if same as Family}
%
%  OUTPUTS
%  1. ATIndexDev - AT index (multiple columns for split magnets)
%
%  EXAMPLES
%  1. buildatindex('Q1')
%  2. buildatindex('BPMx','BPM')
%     BPMx - MML name
%     BPM  -  AT name
%
%  NOTES
%  1. FamName can be a cell array of AT FamNames
%  2. This function is usually used to setup the MML.  
%     Use family2atindex once the MML is working.
%
%  See also findcells, family2atindex


%  Written by Greg Portmann
%  Modified by Laurent S. Nadolski
%  add FamName per default


global THERING

if nargin < 2
    FamName = Family;
end

if iscell(FamName)
    ATIndexList = [];
    for i = 1:length(FamName)
        tmp = findcells(THERING, 'FamName', FamName{i});
        ATIndexList = [ATIndexList; tmp(:)];
    end
    ATIndexList = sort(ATIndexList);
elseif ischar(FamName)
    ATIndexList = findcells(THERING, 'FamName', FamName)';
else
    ATIndexList = FamName;
end

ATIndexList = ATIndexList(:);


if ischar(Family)
    Ndev = size(family2dev(Family,0),1);
else
    Ndev = size(Family,1);
end

N = length(ATIndexList);
Nmag = N / Ndev;


if rem(Nmag,1) == 0
    % Assume the number of splits are the same for each magnet
    for i = 1:Nmag
        ATIndexDev(:,i) = ATIndexList(i:Nmag:end);
    end
else
    % Find the splits based on positions
    pos1 = findspos(THERING, ATIndexList);
    pos2 = findspos(THERING, ATIndexList+1);
    
    Nmax = 1;
    j = 1;
    ATIndexCell{j} = ATIndexList(1);
    for i = 2:length(ATIndexList)        
        if  pos1(i) ~= pos2(i-1)
            j = j + 1;
            ATIndexCell{j,1} = [];
        end
        ATIndexCell{j,1} = [ATIndexCell{j} ATIndexList(i)];
        if length(ATIndexCell{j}) > Nmax
            Nmax = length(ATIndexCell{j});
        end
    end
    
    ATIndexDev = NaN * ones(Ndev, Nmax);
    for i = 1:Ndev
        ATIndexDev(i,1:length(ATIndexCell{i})) = ATIndexCell{i};
    end
end
