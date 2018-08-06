function quadroll(sr)
%locate quadrupoles in AO and apply random roll about s-axis
%function quadroll(sr);  sr is the sigma value for randn;
%units are radians

if nargin<1
    disp('Error in quadroll - must supply alignment spreads');
    return
end

global THERING
AO = getao;

ATindx=[];   %indices of quadrupoles
mr=[];
len=findspos(THERING,length(THERING)+1);

QuadList = findmemberof('QUAD');

for ii=1:length(QuadList)
    Family = QuadList{ii};
    indx = family2atindex(Family);

    %assign random roll error to first magnet
    mr=[mr; sr*randn];

    % assign random error to rest of family
    tol=1e-6; %tolerance for spacing between magnets
    for jj=2:length(indx)

        %check for split magnets
        if AO.(Family).Position(jj)-THERING{indx(jj)}.Length - AO.(Family).Position(jj-1)<tol   %magnet split
            disp(['   Split magnet ' AO.(Family).FamilyName ' found in function quadroll with index  ', num2str(indx(jj))]);
            mr=[mr; -mr(end)];
        else   %magnet not split
            mr=[mr; sr*randn];
        end

    end

    %check if first/last element split in THERING
    if abs(AO.(Family).Position(1))  < tol  && ...    %first element near zero
            abs((len - AO.(Family).Position(end) - THERING{indx(end)}.Length < tol))      %last element near end
        disp(['   Split magnet ' AO.(Family).FamilyName ' found in function quadroll with index  ',...
            num2str(indx(1)), ' ',num2str(indx(end))]);
        mr(end)=-mr(end-length(indx)+1);       %error on last quad same as error on first quad in family
    end

    ATindx=[ATindx; indx];
end

% my=sy*randn(1,length(ATindx));
% mx=sx*randn(1,length(ATindx));
settilt(ATindx,mr);

