function Kicks = sirius_get_kickangle(Ring, ind, plane)

Kicks = zeros(1,size(ind,1));
if ischar(plane) 
    if plane == 'x'
        pl = 1;
    elseif plane == 'y'
        pl = 2;
    else
        error('Value assigned to plane is not valid');
    end
elseif isnumeric(plane)
    if any(plane == [1,2])
        pl = plane;
    else
        error('Value assigned to plane is not valid');
    end
end

for ii=1:size(ind,1)
    if strcmp(Ring{ind(ii,1)}.PassMethod, 'CorrectorPass')
        Kicks(ii) = sum(Ring{ind(ii,:)}.KickAngle(pl));
    elseif  strcmp(Ring{ind(ii,1)}.PassMethod, 'ThinMPolePass')
        if pl == 1
            Kicks(ii) = -sum(getcellstruct(Ring, 'PolynomB', ind(ii,:), 1, 1));
        else
            Kicks(ii) = +sum(getcellstruct(Ring, 'PolynomA', ind(ii,:), 1, 1));
        end
    elseif any(strcmp(Ring{ind(ii,1)}.PassMethod, { ...
            'BndMPoleSymplectic4Pass', 'BndMPoleSymplectic4RadPass', ...
            'StrMPoleSymplectic4Pass', 'StrMPoleSymplectic4RadPass'}))
        Len = getcellstruct(Ring, 'Length', ind(ii,:));
        if pl == 1
            if isfield(Ring{ind(ii,1)}, 'CH')
                Kicks(ii) = -sum(getcellstruct(Ring, 'CH', ind(ii,:), 1, 1) .* Len);
            else
                Kicks(ii) = -sum(getcellstruct(Ring, 'PolynomB', ind(ii,:), 1, 1) .* Len);
            end
        else
            if isfield(Ring{ind(ii,1)}, 'CV')
                Kicks(ii) = +sum(getcellstruct(Ring, 'CV', ind(ii,:), 1, 1) .* Len);
            else
                Kicks(ii) = +sum(getcellstruct(Ring, 'PolynomA', ind(ii,:), 1, 1) .* Len);
            end
        end
    else
        error('Element cannot be used as corrector.')
    end
end