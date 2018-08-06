function sirius_set_field_profile
% Save the initial field profile of the magnets in accelerator object (AO)
%
% 2015-10-22 Luana

global THERING;

Families = findmemberof('Magnet');

for l=1:size(Families, 1)
    Family    = deblank(Families{l});
    ATIndex   = family2atindex(Family, [1,1]);
    ExcData   = getfamilydata(Family, 'ExcitationCurves');
    ElemIndex = dev2elem(Family,[1,1]);
    nr_harmonics = ExcData.harmonics{ElemIndex}(end);
    [ProfileA, ProfileB] = get_field_profile(THERING, ATIndex, nr_harmonics);
    setfamilydata(ProfileA, Family, 'AT', 'FieldProfileA')
    setfamilydata(ProfileB, Family, 'AT', 'FieldProfileB')
end

end


function [ProfileA, ProfileB] = get_field_profile(Ring, Index, nr_harmonics)

Nsplit = length(Index);

for j=1:Nsplit
    % resize PolynomB and PolynomA 
    LenA = (nr_harmonics + 1) - length(Ring{Index(j)}.PolynomA);
    LenB = (nr_harmonics + 1) - length(Ring{Index(j)}.PolynomB);
    Ring{Index(j)}.PolynomA = [Ring{Index(j)}.PolynomA, zeros(1,LenA)];
    Ring{Index(j)}.PolynomB = [Ring{Index(j)}.PolynomB, zeros(1,LenB)];     
end 

ProfileA = zeros(Nsplit, nr_harmonics + 1);
ProfileB = zeros(Nsplit, nr_harmonics + 1);
if Nsplit == 1
    ProfileA(:,:) = 1;
    ProfileB(:,:) = 1;
else
    for j=1:Nsplit
        for n = 0:nr_harmonics
            ProfileA(j,n+1) = Ring{Index(j)}.PolynomA(n+1)*Ring{Index(j)}.Length;
            if isfield(Ring{Index(j)}, 'BendingAngle') && n == 0
                ProfileB(j,n+1) = Ring{Index(j)}.PolynomB(n+1)*Ring{Index(j)}.Length + Ring{Index(j)}.BendingAngle;
            else
                ProfileB(j,n+1) = Ring{Index(j)}.PolynomB(n+1)*Ring{Index(j)}.Length;
            end
        end
    end

    for n=0:nr_harmonics
        sumA = sum(ProfileA(:,n+1)); 
        sumB = sum(ProfileB(:,n+1));
        if sumA ~= 0
            ProfileA(:,n+1) = ProfileA(:,n+1)/sumA;
        else
            ProfileA(:,n+1) = 1/Nsplit;
        end

        if sumB ~= 0 
            ProfileB(:,n+1) = ProfileB(:,n+1)/sumB;
        else
            ProfileB(:,n+1) = 1/Nsplit;
        end            
    end
end

end