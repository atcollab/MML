function bendalign(sx,sy);
%locate bend magnets in AO and return alignment to zero
%function bendalign(sx,sy);  sx and sy are sigma values for randn; 
%units are meters
if nargin<2
    disp('Error in bendalign - must supply alignment spreads');
    return
end

global THERING
AO = getao;

ATindx=[];   %indices of bend magnets
mx=[];
my=[];
len=findspos(THERING,length(THERING)+1);

for ii=1:length(AO)
    if strcmp(lower(AO{ii}.FamilyType),'bend')
        indx=AO{ii}.AT.ATIndex;
        
        %assign random alignment error to first magnet
        mx=[mx; sx*randn];
        my=[my; sy*randn];

        % assign random error to rest of family
        tol=1e-6; %tolerance for spacing between magnets
        for jj=2:length(indx)
            
            %check for split magnets
            if AO{ii}.Position(jj)-THERING{indx(jj)}.Length - AO{ii}.Position(jj-1)<tol   %magnet split
               disp(['   Split magnet ' AO{ii}.FamilyName ' found in function bendalign with index  ', num2str(indx(jj))]);
               mx=[mx; -mx(end)];
               my=[my; -my(end)];
           else   %magnet not split
               mx=[mx; sx*randn];   
               my=[my; sy*randn];
           end
           
        end
        
        %check if first/last element split in THERING
        if abs(AO{ii}.Position(1))  < tol  & ...    %first element near zero
           abs((len - AO{ii}.Position(end) - THERING{indx(end)}.Length < tol))      %last element near end
           disp(['   Split magnet ' AO{ii}.FamilyName ' found in function bendalign with index  ',...
           num2str(indx(1)), ' ',num2str(indx(end))]);
           mx(end)=-mx(end-length(indx)+1);       %error on last quad same as error on first quad in family
           my(end)=-my(end-length(indx)+1);
        end
        
        ATindx=[ATindx; indx];
    end  %end quad condition
end  %end loop over families

%set polynomials to mimic dipole misalignment errors
for ii=1:length(ATindx)
    
    rho=THERING{ATindx(ii)}.Length/THERING{ATindx(ii)}.BendingAngle;
    dB=THERING{ATindx(ii)}.PolynomB(2)*mx(ii)*rho;                              %dB = (gradB/B*rho)*dx*rho
    THERING{ATindx(ii)}.PolynomB(1)=THERING{ATindx(ii)}.PolynomB(1)+dB;         %horizontal

    THERING{ATindx(ii)}.PolynomA(1)=THERING{ATindx(ii)}.PolynomA(1)+dB;         %vertical
end
