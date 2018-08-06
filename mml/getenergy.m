function [Energy, HCMEnergy] = getenergy(varargin)
%GETENERGY - Returns the beam energy base on the bend magnet
%  [Energy, HCMEnergy] = getenergy(Keyword)
%
%  Keyword can be:
%  'Production'         - Energy of the production lattice
%  'Injection'          - Energy of the injection lattice
%  'Model' or Simulator - Energy based on the model bend magnet (bend2gev('Model'))
%  'Online'             - Energy based on the online bend magnet (bend2gev('Online'))
%  'Present'            - Energy based on the present bend magnet mode (bend2gev)   {Default}
%
%  OUTPUTS
%  1. Energy - Main storage ring energy (usually based on the BEND magnet) [GeV]
%  2. HCMEnergy - Energy change due to all the horizontal corrector magnets [dE/E]
%                 Algorithm:  dE/E = sum(-HCM * DxHCM / getmcf / L)
%
%  See also bend2gev, gev2bend, plotcm

%  Written by Greg Portmann


for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Production')
        
        Energy = getfamilydata('Energy');

        if nargout >= 2
            HCMEnergy = [];
            %Family = gethcmfamily;
            %SP = getproductionlattice;
            %HCMEnergy = gethcmenergylocal(SP.(Family).Setpoint);
        end
        return

    elseif strcmpi(varargin{i},'Injection')
        
        Energy = getfamilydata('InjectionEnergy');

        if nargout >= 2
            HCMEnergy = [];
            %Family = gethcmfamily;
            %SP = getinjectionlattice;
            %HCMEnergy = gethcmenergylocal(SP.(Family).Setpoint);
        end
        return
    
    elseif strcmpi(varargin{i},'Present')
        
        Energy = bend2gev;

        if nargout >= 2
            HCMEnergy = [];
            %HCMEnergy = gethcmenergylocal;
        end
        return
    
    elseif strcmpi(varargin{i},'Model') || strcmpi(varargin{i},'Simulator')
        
        Energy = bend2gev('Model');

        if nargout >= 2
            HCMEnergy = [];
            %Family = gethcmfamily;
            %HCMEnergy = gethcmenergylocal(getsp(Family, 'Model', 'Struct'));
        end
        return
        
    elseif strcmpi(varargin{i},'Online')
        
        Energy = bend2gev('Online');
        
        if nargout >= 2
            HCMEnergy = [];
            %Family = gethcmfamily;
            %HCMEnergy = gethcmenergylocal(getsp(Family, 'Online', 'Struct'));
        end
        return
        
    end
end


% Default
Energy = bend2gev;
%Energy = getfamilydata('Energy');

Energy = Energy(1);

if nargout >= 2
    HCMEnergy = [];
    %HCMEnergy = gethcmenergylocal;
 end



% function HCMEnergy = gethcmenergylocal(HCMStruct)
% 
% if nargin == 0
%     % Get the energy change of the horizontal correctors
%     Family = gethcmfamily;
%     HCMStruct = getsp(Family, 'Struct');
% end
% 
% % Compute the energy change due to the correctors
% L = getfamilydata('Circumference');
% 
% HCM = hw2physics(HCMStruct);
% HCM = HCM.Data;
% 
% [DxHCM, DyHCM] = modeldisp([], HCMStruct.FamilyName, HCMStruct.DeviceList, 'Physics');
% HCMEnergyChange = -1 *HCM.*DxHCM / getmcf / L;
% HCMEnergy = sum(HCMEnergyChange);
