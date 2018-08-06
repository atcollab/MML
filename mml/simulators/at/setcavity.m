function ATCavityIndex = setcavity(InputString)
%SETCAVITY - Set the RF cavity state
%  ATCavityIndex = setcavity(InputString)
%
%  INPUTS
%  1. 'On', 'Off', or PassMethod {Default: no change}
%
%  OUTPUTS
%  1. ATCavityIndex - AT Index of the RF cavities
%
%  NOTES
%  1. For more than one cavity, the InputString can have more than one row.
%
%  See also getcavity, setradiation

%  Written by Greg Portmann

global THERING

if nargin == 0
    InputString = '';
end

ATCavityIndex = findcells(THERING, 'Frequency');

if isempty(InputString)
    return;
end

if isempty(ATCavityIndex)
    %fprintf('   No cavities were found in the lattice (setcavity).\');
    return
end


ATCavityIndex =ATCavityIndex(:)';
for iCavity = 1:length(ATCavityIndex)

    if size(InputString,1) == 1
        CavityString = deblank(InputString);
    elseif size(InputString,1) == length(ATCavityIndex)
        CavityString = deblank(InputString(iCavity,:));
    else
        error('Number of rows in the input string must be 1 row or equal to the number of cavities.');
    end        
    
    if strcmpi(CavityString,'off')
            if THERING{ATCavityIndex(iCavity)}.Length == 0;
                THERING{ATCavityIndex(iCavity)}.PassMethod = 'IdentityPass';
            else
                THERING{ATCavityIndex(iCavity)}.PassMethod = 'DriftPass';
            end

    elseif strcmpi(CavityString,'on')

            %if THERING{ATCavityIndex(iCavity)}.Length == 0;
            %    THERING{ATCavityIndex(iCavity)}.PassMethod = 'ThinCavityPass';
            %else
                THERING{ATCavityIndex(iCavity)}.PassMethod = 'CavityPass';
            %end
            
    else
        THERING{ATCavityIndex(iCavity)}.PassMethod = CavityString;
    end
end