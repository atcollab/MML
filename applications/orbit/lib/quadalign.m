function quadalign(sx,sy);
%locate quadrupoles in AO and apply random alignment
%function quadalign(sx,sy);  sx and sy are sigma values for randn; 
%units are meters
if nargin<2
    disp('Error in quadalign - must supply alignment spreads');
    return
end

global THERING
AO = getao;

ATindx=[];   %indices of quadrupoles
mx=[];
my=[];
len=findspos(THERING,length(THERING)+1);

aofields=fieldnames(AO);
for ii=1:length(aofields)
    if strcmpi(AO.(aofields{ii}).FamilyType,'quad')
        indx=AO.(aofields{ii}).AT.ATIndex;
        
        %assign random alignment error to first magnet
        mx=[mx; sx*randn];
        my=[my; sy*randn];

        % assign random error to rest of family
        tol=1e-6; %tolerance for spacing between magnets
        for jj=2:length(indx)
            
            %check for split magnets
            if AO.(aofields{ii}).Position(jj)-THERING{indx(jj)}.Length - AO.(aofields{ii}).Position(jj-1)<tol   %magnet split
               disp(['   Split magnet ' AO{ii}.FamilyName ' found in function quadalign with index  ', num2str(indx(jj))]);
               mx=[mx; -mx(end)];
               my=[my; -my(end)];
           else   %magnet not split
               mx=[mx; sx*randn];   
               my=[my; sy*randn];
           end
           
        end
        
        %check if first/last element split in THERING
        if abs(AO.(aofields{ii}).Position(1))  < tol  & ...    %first element near zero
           abs((len - AO.(aofields{ii}).Position(end) - THERING{indx(end)}.Length < tol))      %last element near end
           disp(['   Split magnet ' AO.(aofields{ii}).FamilyName ' found in function quadalign with index  ',...
           num2str(indx(1)), ' ',num2str(indx(end))]);
           mx(end)=-mx(end-length(indx)+1);       %error on last quad same as error on first quad in family
           my(end)=-my(end-length(indx)+1);
        end
        
        ATindx=[ATindx; indx];
    end  %end quad condition
end  %end loop over families

% my=sy*randn(1,length(ATindx));
% mx=sx*randn(1,length(ATindx));
setshift(ATindx,mx,my);

