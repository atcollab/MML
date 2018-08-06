function quadalign(sx,sz)
%QUADALIGN - Locates quadrupoles in AO and apply random alignment
%quadalign(sx,sz);  sx and sz are sigma values for randn;
% units are meters
%
% INPUTS
% 1. sx sigma for vertical plane
% 2. sz sigma for horizontal plane

% Written by SPEAR3
% Modified by Laurent S. Nadolski

% TO DO - cut off for errors at n sigmas see randncut


if nargin<2
    error('Error in quadalign - must supply alignment sigma values for both planes');
end

global THERING
AO = getao;

ATindx=[];   %indices of quadrupoles
mx=[];
my=[];
len = findspos(THERING,length(THERING)+1);


QuadList = findmemberof('Quad');

for ii=1:length(QuadList),
    Family = QuadList{ii};
    indx=AO.(Family).AT.ATIndex;

    %assign random alignment error to first magnet
    mx=[mx; sx*randn];
    my=[my; sz*randn];

    % assign random error to rest of family
    tol=1e-6; %tolerance for spacing between magnets
    for jj=2:length(indx)

        %check for split magnets
        if AO.(Family).Position(jj)-THERING{indx(jj)}.Length - AO.(Family).Position(jj-1)<tol   %magnet split
            disp(['   Split magnet ' AO{ii}.FamilyName ' found in function quadalign with index  ', num2str(indx(jj))]);
            mx=[mx; -mx(end)];
            my=[my; -my(end)];
        else   %magnet not split
            mx=[mx; sx*randn];
            my=[my; sz*randn];
        end

    end

    %check if first/last element split in THERING
    if abs(AO.(Family).Position(1))  < tol  && ...    %first element near zero
            abs((len - AO.(Family).Position(end) - THERING{indx(end)}.Length < tol))      %last element near end
        disp(['   Split magnet ' AO.(Family).FamilyName ' found in function quadalign with index  ',...
            num2str(indx(1)), ' ',num2str(indx(end))]);
        mx(end)=-mx(end-length(indx)+1);       %error on last quad same as error on first quad in family
        my(end)=-my(end-length(indx)+1);
    end

    ATindx=[ATindx; indx];
end  %end loop over families

% my=sz*randn(1,length(ATindx));
% mx=sx*randn(1,length(ATindx));
setshift(ATindx,mx,my);

