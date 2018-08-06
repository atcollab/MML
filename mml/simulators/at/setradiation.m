function [PassMethod, ATIndex, FamName, PassMethodOld, ATIndexOld, FamNameOld] = setradiation(InputString)
%SETRADIATION - Sets the model PassMethod to include or exclude radiation ('On' / 'Off' {Default})
%  [PassMethod, ATIndex, FamName, PassMethodOld, ATIndexOld, FamNameOld] = setradiation('On' or 'Off')
%
%  INPUTS
%  1. 'On' or 'Off'
%
%  OUTPUTS
%  New AT model parameters
%  1. PassMethod - AT PassMethod field (cell array)
%  2. ATIndex    - AT index in THERING
%  3. FamName    - AT family name (cell array)
%  Old AT model parameters
%  4. PassMethodOld - AT PassMethod field (cell array)
%  5. ATIndexOld    - AT index in THERING
%  6. FamNameOld    - AT family name (cell array)
%
%  NOTE
%  1. setpassmethod(ATIndexOld, PassMethodOld) can be used to restore old PassMethods.
%  2. This function is machine specific so it is prone to being out-of-date.  All machine get the 
%     same passmethods for radiation on. The potential confusion occurs when turning the radiation off.
%     The following is the list for how this function is programmed.  Please email me if 
%     it is not correct for your accelerator.
%
%  1. Spear, Diamond, Soleil, TLS, TPS, SESAME, SSRF, MLS, Bessy II, and the X-Ray ring
%     Quadrupole magnets pass methods:
%     a. QuadLinearPass             - Radiation off
%     b. StrMPoleSymplectic4RadPass - Radiation on
%
%     Bend magnet pass methods:
%     a. BendLinearPass             - Radiation off
%     b. BndMPoleSymplectic4RadPass - Radiation on
%
%     Sextupoles magnets pass methods:
%     a. StrMPoleSymplectic4Pass    - Radiation off
%     b. StrMPoleSymplectic4RadPass - Radiation on
%
%  2. PLS, ASP
%     Quadrupole magnets pass methods:
%     a. QuadLinearPass             - Radiation off
%     b. StrMPoleSymplectic4RadPass - Radiation on
%
%     Bend magnet pass methods:
%     a. BndMPoleSymplectic4Pass    - Radiation off
%     b. BndMPoleSymplectic4RadPass - Radiation on
%
%     Sextupoles magnets pass methods:
%     a. StrMPoleSymplectic4Pass    - Radiation off
%     b. StrMPoleSymplectic4RadPass - Radiation on
%
%  3. ALS, CLS, ALBA, CAMD, ELSA, LNLS, NSLS2, VUV ring and any ring not mentioned above
%     Quadrupole magnets pass methods:
%     a. StrMPoleSymplectic4Pass    - Radiation off
%     b. StrMPoleSymplectic4RadPass - Radiation on
%
%     Bend magnet pass methods:
%     a. BndMPoleSymplectic4Pass    - Radiation off
%     b. BndMPoleSymplectic4RadPass - Radiation on
%
%     Sextupoles magnets pass methods:
%     a. StrMPoleSymplectic4Pass    - Radiation off
%     b. StrMPoleSymplectic4RadPass - Radiation on
%
%  See also setpassmethod, getpassmethod, getcavity, setcavity

%  Written by Greg Portmann



global THERING

if nargin == 0
    InputString = 'Off';
end

ATIndex = [];
PassMethod = {};
FamName = {};

% Old passmethods
if nargout > 3
    ATIndexOld = [];
    PassMethodOld = {};
    FamNameOld = {};
    localindex = findcells(THERING,'PassMethod','QuadLinearPass');
    if ~isempty(localindex)
        ATIndexOld = [ATIndexOld localindex(:)'];
        PassMethodOld = [PassMethodOld; getcellstruct(THERING,'PassMethod',localindex)];
        FamNameOld    = [FamNameOld;    getcellstruct(THERING,'FamName',   localindex)];
    end
    localindex = findcells(THERING,'PassMethod','StrMPoleSymplectic4Pass');
    if ~isempty(localindex)
        ATIndexOld = [ATIndexOld localindex(:)'];
        PassMethodOld = [PassMethodOld; getcellstruct(THERING,'PassMethod',localindex)];
        FamNameOld    = [FamNameOld;    getcellstruct(THERING,'FamName',   localindex)];
    end
    localindex = findcells(THERING,'PassMethod','StrMPoleSymplectic4RadPass');
    if ~isempty(localindex)
        ATIndexOld = [ATIndexOld localindex(:)'];
        PassMethodOld = [PassMethodOld; getcellstruct(THERING,'PassMethod',localindex)];
        FamNameOld    = [FamNameOld;    getcellstruct(THERING,'FamName',   localindex)];
    end

    localindex = findcells(THERING,'PassMethod','BendLinearPass');
    if ~isempty(localindex)
        ATIndexOld = [ATIndexOld localindex(:)'];
        PassMethodOld = [PassMethodOld; getcellstruct(THERING,'PassMethod',localindex)];
        FamNameOld    = [FamNameOld;    getcellstruct(THERING,'FamName',   localindex)];
    end
    localindex = findcells(THERING,'PassMethod','BndMPoleSymplectic4Pass');
    if ~isempty(localindex)
        ATIndexOld = [ATIndexOld localindex(:)'];
        PassMethodOld = [PassMethodOld; getcellstruct(THERING,'PassMethod',localindex)];
        FamNameOld    = [FamNameOld;    getcellstruct(THERING,'FamName',   localindex)];
    end
    localindex = findcells(THERING,'PassMethod','BndMPoleSymplectic4RadPass');
    if ~isempty(localindex)
        ATIndexOld = [ATIndexOld localindex(:)'];
        PassMethodOld = [PassMethodOld; getcellstruct(THERING,'PassMethod',localindex)];
        FamNameOld    = [FamNameOld;    getcellstruct(THERING,'FamName',   localindex)];
    end
    ATIndexOld = ATIndexOld(:);
    if length(PassMethodOld) == 1
        PassMethodOld = PassMethodOld{1};
        FamNameOld    = FamNameOld{1};
    end
end


% Main 
switch lower(InputString)
    case 'off'
        MachineName = lower(getfamilydata('Machine'));
        if any([findstr(MachineName,'spear') findstr(MachineName,'SESAME') findstr(MachineName,'bessy2') findstr(MachineName,'x-ray') findstr(MachineName,'diamond') findstr(MachineName,'soleil') findstr(MachineName,'ssrf') findstr(MachineName,'lnls') findstr(MachineName,'tls') findstr(MachineName,'tps') findstr(MachineName,'mls') findstr(MachineName,'sps')])

            localindex = findcells(THERING,'PassMethod','StrMPoleSymplectic4RadPass');
            if ~isempty(localindex)
                for i = 1:length(localindex)
                    if isfield(THERING{localindex(i)},'K')
                        % Quadupoles
                        THERING = setcellstruct(THERING,'PassMethod', localindex(i), 'QuadLinearPass');
                    else
                        % Sextupoles, etc.
                        THERING = setcellstruct(THERING,'PassMethod', localindex(i), 'StrMPoleSymplectic4Pass');
                    end
                    PassMethod{i,1} = THERING{localindex(i)}.PassMethod;
                    FamName{i,1}    = THERING{localindex(i)}.FamName;
                end
                ATIndex = localindex(:)';
            end

            % Bends
            localindex = findcells(THERING,'PassMethod','BndMPoleSymplectic4RadPass');
            if ~isempty(localindex)
                THERING = setcellstruct(THERING,'PassMethod',localindex, 'BendLinearPass');
                ATIndex = [ATIndex localindex(:)'];
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end
            
            % Output
            localindex = findcells(THERING,'PassMethod','QuadLinearPass');
            if ~isempty(localindex)
                ATIndex = [ATIndex localindex(:)'];
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end
            localindex = findcells(THERING,'PassMethod','StrMPoleSymplectic4Pass');
            if ~isempty(localindex)
                ATIndex = [ATIndex localindex(:)'];
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end
            localindex = findcells(THERING,'PassMethod','BendLinearPass');
            if ~isempty(localindex)
                ATIndex = [ATIndex localindex(:)'];
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end

        elseif any([findstr(MachineName,'pls') findstr(MachineName,'asp')])

            localindex = findcells(THERING,'PassMethod','StrMPoleSymplectic4RadPass');
            if ~isempty(localindex)
                for i = 1:length(localindex)
                    if isfield(THERING{localindex(i)},'K')
                        % Quadupoles
                        THERING = setcellstruct(THERING,'PassMethod', localindex(i), 'QuadLinearPass');
                    else
                        % Sextupoles, etc.
                        THERING = setcellstruct(THERING,'PassMethod', localindex(i), 'StrMPoleSymplectic4Pass');
                    end
                    PassMethod{i,1} = THERING{localindex(i)}.PassMethod;
                    FamName{i,1}    = THERING{localindex(i)}.FamName;
                end
                ATIndex = localindex(:)';
            end

            % Bends
            localindex = findcells(THERING,'PassMethod','BndMPoleSymplectic4RadPass');
            if ~isempty(localindex)
                THERING = setcellstruct(THERING,'PassMethod',localindex, 'BndMPoleSymplectic4Pass');
                ATIndex = [ATIndex localindex(:)'];
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end

            % Output
            localindex = findcells(THERING,'PassMethod','QuadLinearPass');
            if ~isempty(localindex)
                ATIndex = [ATIndex localindex(:)'];
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end
            localindex = findcells(THERING,'PassMethod','StrMPoleSymplectic4Pass');
            if ~isempty(localindex)
                ATIndex = [ATIndex localindex(:)'];
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end
            localindex = findcells(THERING,'PassMethod','BndMPoleSymplectic4Pass');
            if ~isempty(localindex)
                ATIndex = [ATIndex localindex(:)'];
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end

        else

            % Quadupoles, Sextupoles, etc.
            localindex = findcells(THERING,'PassMethod','StrMPoleSymplectic4RadPass');
            if ~isempty(localindex)
                THERING = setcellstruct(THERING,'PassMethod',localindex, 'StrMPoleSymplectic4Pass');
                ATIndex = localindex(:)';
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end

            % Bends
            localindex = findcells(THERING,'PassMethod','BndMPoleSymplectic4RadPass');
            if ~isempty(localindex)
                THERING = setcellstruct(THERING,'PassMethod',localindex, 'BndMPoleSymplectic4Pass');
                ATIndex = [ATIndex localindex(:)'];
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end

            % Output
            localindex = findcells(THERING,'PassMethod','StrMPoleSymplectic4Pass');
            if ~isempty(localindex)
                ATIndex = [ATIndex localindex(:)'];
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end
            localindex = findcells(THERING,'PassMethod','BndMPoleSymplectic4Pass');
            if ~isempty(localindex)
                ATIndex = [ATIndex localindex(:)'];
                PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
                FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
            end

        end


    case 'on'
        
        % Sextupoles, etc.
        localindex = findcells(THERING,'PassMethod','StrMPoleSymplectic4Pass');
        if ~isempty(localindex)
            THERING = setcellstruct(THERING,'PassMethod',localindex, 'StrMPoleSymplectic4RadPass');
        end

        % Quadupoles
        localindex = findcells(THERING,'PassMethod','QuadLinearPass');
        if ~isempty(localindex)
            THERING = setcellstruct(THERING,'PassMethod',localindex, 'StrMPoleSymplectic4RadPass');
        end

        % Bends
        localindex = findcells(THERING,'PassMethod','BndMPoleSymplectic4Pass');
        if ~isempty(localindex)
            THERING = setcellstruct(THERING,'PassMethod',localindex, 'BndMPoleSymplectic4RadPass');
        end

        localindex = findcells(THERING,'PassMethod','BendLinearPass');
        if ~isempty(localindex)
            THERING = setcellstruct(THERING,'PassMethod',localindex, 'BndMPoleSymplectic4RadPass');
        end

        % Output
        localindex = findcells(THERING,'PassMethod','StrMPoleSymplectic4RadPass');
        if ~isempty(localindex)
            ATIndex = [ATIndex localindex(:)'];
            PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
            FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
        end
        localindex = findcells(THERING,'PassMethod','BndMPoleSymplectic4RadPass');
        if ~isempty(localindex)
            ATIndex = [ATIndex localindex(:)'];
            PassMethod = [PassMethod; getcellstruct(THERING,'PassMethod',localindex)];
            FamName    = [FamName;    getcellstruct(THERING,'FamName',   localindex)];
        end
        %disp(['PassMethod was changed to include radiation in ',num2str(length(ATIndex)),  ' elements'])
end


ATIndex = ATIndex(:);


if length(PassMethod) == 1
    PassMethod = PassMethod{1};
    FamName    = FamName{1};
end

