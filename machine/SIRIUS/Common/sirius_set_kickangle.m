function NewRing = sirius_set_kickangle(OldRing, kicks, ind, plane)

NewRing = OldRing;
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

nrsegs = size(ind,2);

for ii=1:size(ind,1)
    if strcmp(NewRing{ind(ii,1)}.PassMethod, 'CorrectorPass')
        NewRing = setcellstruct(NewRing, 'KickAngle', ind(ii,:), kicks(ii)/nrsegs, 1, pl);
        
    elseif  strcmp(NewRing{ind(ii,1)}.PassMethod, 'ThinMPolePass')
        if pl == 1
            PolynomB = getcellstruct(NewRing, 'PolynomB', ind(ii,:), 1, 1);
            if isfield(NewRing{ind(ii,1)}, 'CH')
                errors = PolynomB - getcellstruct(NewRing, 'CH', ind(ii,:));
                NewRing = setcellstruct(NewRing, 'CH', ind(ii,:), (-kicks(ii)/nrsegs), 1, 1);
            else
                errors = zeros(1, size(ind,2));
            end
            
            for j=1:size(ind, 2)
                NewRing = setcellstruct(NewRing, 'PolynomB', ind(ii,j), (-kicks(ii)/nrsegs) + errors(j), 1,1);
            end

        else
            PolynomA = getcellstruct(NewRing, 'PolynomA', ind(ii,:), 1, 1);
            if isfield(NewRing{ind(ii,1)}, 'CV')
                errors = PolynomA - getcellstruct(NewRing, 'CV', ind(ii,:));
                NewRing = setcellstruct(NewRing, 'CV', ind(ii,:), (+kicks(ii)/nrsegs), 1, 1);
            else
                errors = zeros(1, size(ind,2));
            end
            
            for j=1:size(ind, 2)
                NewRing = setcellstruct(NewRing, 'PolynomA', ind(ii,j), (+kicks(ii)/nrsegs) + errors(j), 1,1);
            end
        end
        
    elseif any(strcmp(NewRing{ind(ii,1)}.PassMethod, { ...
            'BndMPoleSymplectic4Pass', 'BndMPoleSymplectic4RadPass', ...
            'StrMPoleSymplectic4Pass', 'StrMPoleSymplectic4RadPass'}))
        % in this case we chose to model corrector with uniform diolar
        % field. This is equivalent to hard-edge model of the corrector.
        lens = getcellstruct(NewRing, 'Length', ind(ii,:));
        if pl == 1
            PolynomB = getcellstruct(NewRing, 'PolynomB', ind(ii,:), 1, 1);
            if isfield(NewRing{ind(ii,1)}, 'CH')
                errors = PolynomB - getcellstruct(NewRing, 'CH', ind(ii,:));
                NewRing = setcellstruct(NewRing, 'CH', ind(ii,:), -kicks(ii)/sum(lens), 1, 1);
            else
                errors = zeros(1, size(ind,2));
            end
            
            for j=1:size(ind, 2)
                NewRing = setcellstruct(NewRing, 'PolynomB', ind(ii,j), -kicks(ii)/sum(lens) + errors(j), 1,1);
            end
        else
            PolynomA = getcellstruct(NewRing, 'PolynomA', ind(ii,:), 1, 1);
            if isfield(NewRing{ind(ii,1)}, 'CV')
                errors = PolynomA - getcellstruct(NewRing, 'CV', ind(ii,:));
                NewRing = setcellstruct(NewRing, 'CV', ind(ii,:), +kicks(ii)/sum(lens), 1, 1);
            else
                errors = zeros(1, size(ind,2));
            end
            
            for j=1:size(ind, 2)
                NewRing = setcellstruct(NewRing, 'PolynomA', ind(ii,j), +kicks(ii)/sum(lens) + errors(j), 1,1);
            end          
        end
        
    else
        error('Element cannot be used as corrector.')
    end
    
end
