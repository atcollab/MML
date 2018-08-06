function [k, B] = amp2k(Family, Field, Amps, DeviceList, Energy, BranchFlag)
%[k, B] = amp2k(Family, Field, Amps, DeviceList, Energy, BranchFlag)
%AMP2K - Converts control system Ampss to the AT simulator Ampss
%  [K, B] = amp2k(Family, Field, Amps, DeviceList, Energy, BranchFlag)
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. Amps - Control system Amps
%  4. DeviceList - Device list (Amps and DeviceList must have the same number of rows)
%  5. Energy - Energy in GeV {Default: getenergy}
%              If Energy is a vector, each output column will correspond to that energy.
%              Energy can be anything getenergy accepts, like 'Model' or 'Online'.
%              (Note: If Energy is a vector, then Amps can only have 1 column)
%
%  OUTPUTS
%  1. K and B - K-Amps and field in AT convention
%     For dipole:      K = B / Brho
%     For quadrupole:  K = B'/ Brho
%     For sextupole:   K = B"/ Brho / 2
%
%  See also k2amp, hw2physics, physics2hw
%  set to nsls2 sr by Xi Yang


if nargin < 3
    error('At least 3 input required');
end

if isempty(Field)
    Field = 'Setpoint';
end

if nargin < 4
    DeviceList = [];
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end

if nargin < 5
    Energy = [];
end
if isempty(Energy)
    Energy = getenergy;
elseif ischar(Energy)
    Energy = getenergy(Energy);
end

% Hysteresis branch
if nargin < 6
    BranchFlag = [];
else
    if char(BranchFlag)
        if strcmpi(BranchFlag, 'Lower')
            % Lower branch
            BranchFlag = 1;
        elseif strcmpi(BranchFlag, 'Upper')
            % Upper branch
            BranchFlag = 2;
        end
    end
end
if isempty(BranchFlag)
    if strcmpi(getfamilydata('HysteresisBranch'),'Lower')
        % Lower branch
        BranchFlag = 1;
    else
        % Upper branch (default)
        BranchFlag = 2;
    end
end

if size(Amps,1) == 1 && length(DeviceList) > 1
    Amps = ones(size(DeviceList,1),1) * Amps;
elseif size(Amps,1) ~= size(DeviceList,1)
    error('Rows in Amps must equal rows in DeviceList or be a scalar');
end


if all(isnan(Amps))
    k = Amps;
    return
end


% Force Energy and Amps to have the same number of columns
if all(size(Energy) > 1)
    error('Energy can only be a scalar or vector');
end
Energy = Energy(:)';

if length(Energy) > 1
    if size(Amps,2) == size(Energy,2)
        % OK
    elseif size(Amps,2) > 1
        error('If Energy is a vector, then Amps can only have 1 column.');
    else
        % Amps has one column, expand to the size of Energy
        Amps = Amps * ones(1,size(Energy,2));
    end
else
    Energy = Energy * ones(1,size(Amps,2));
end

AD=getad;
%%%%%%%%%%%%%%%%%%%%%
% dipole,QUAD,sext,cor Magnets %
%%%%%%%%%%%%%%%%%%%%%
% Conversions factors
% QF:   B' = G(I) = kg4*I.^4+kg3*I.^3+kg2*I.^2+kg1*I+kg0 (Tesla-meters)
% K = B' / Brho
 k=[];
if any(strcmpi(Field, {'Setpoint','Monitor'}))
     Brho = getbrho(Energy);
     if strcmpi(Family, 'QH1')
        id=dev2elem('QH1',DeviceList);
        for i=1:size(DeviceList,1)
            xit=AD.QH1.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.QH1.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=-interp1(xit, yit, Amps(i))/Brho;            
        end
    elseif strcmpi(Family, 'QH2')        
        id=dev2elem('QH2',DeviceList);
        for i=1:size(DeviceList,1)
            xit=AD.QH2.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.QH2.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=interp1(xit, yit, Amps(i))/Brho;
        end
    elseif strcmpi(Family, 'QH3')
        id=dev2elem('QH3',DeviceList);       
        for i=1:size(DeviceList,1)          
            xit=AD.QH3.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.QH3.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=-interp1(xit, yit, Amps(i))/Brho;
        end
    elseif strcmpi(Family, 'QL1')
        id=dev2elem('QL1',DeviceList);           
        for i=1:size(DeviceList,1)              
            xit=AD.QL1.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.QL1.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=-interp1(xit, yit, Amps(i))/Brho;
        end
    elseif strcmpi(Family, 'QL2')
        id=dev2elem('QL2',DeviceList);           
        for i=1:size(DeviceList,1)       
            xit=AD.QL2.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.QL2.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=interp1(xit, yit, Amps(i))/Brho;
        end
    elseif strcmpi(Family, 'QL3')
        id=dev2elem('QL3',DeviceList);          
        for i=1:size(DeviceList,1)       
            xit=AD.QL3.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.QL3.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=-interp1(xit, yit, Amps(i))/Brho;
        end
    elseif strcmpi(Family, 'QM1')
        id=dev2elem('QM1',DeviceList);            
        for i=1:size(DeviceList,1)   
            xit=AD.QM1.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.QM1.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=-interp1(xit, yit, Amps(i))/Brho;
        end
    elseif strcmpi(Family, 'QM2')
        id=dev2elem('QM2',DeviceList);  
        for i=1:size(DeviceList,1)               
            xit=AD.QM2.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.QM2.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=interp1(xit, yit, Amps(i))/Brho;
        end
    elseif strcmpi(Family, 'SH1')
        id=dev2elem('SH1',DeviceList);       
        for i=1:size(DeviceList,1)               
            xit=AD.SH1.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.SH1.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=interp1(xit, yit, Amps(i))/Brho/2;
        end
    elseif strcmpi(Family, 'SH3')
        id=dev2elem('SH3',DeviceList);        
        for i=1:size(DeviceList,1)
            xit=AD.SH3.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.SH3.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=-interp1(xit, yit, Amps(i))/Brho/2;
        end
    elseif strcmpi(Family, 'SH4')
        id=dev2elem('SH4',DeviceList);         
        for i=1:size(DeviceList,1)
            xit=AD.SH4.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.SH4.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=-interp1(xit, yit, Amps(i))/Brho/2;
        end
    elseif strcmpi(Family, 'SL1')
            id=dev2elem('SL1',DeviceList);           
        for i=1:size(DeviceList,1)         
            xit=AD.SL1.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.SL1.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=-interp1(xit, yit, Amps(i))/Brho/2;
        end
    elseif strcmpi(Family, 'SL2')
             id=dev2elem('SL2',DeviceList);        
        for i=1:size(DeviceList,1)              
            xit=AD.SL2.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.SL2.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=interp1(xit, yit, Amps(i))/Brho/2;
        end
    elseif strcmpi(Family, 'SL3')
            id=dev2elem('SL3',DeviceList);         
        for i=1:size(DeviceList,1)              
            xit=AD.SL3.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.SL3.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=-interp1(xit, yit, Amps(i))/Brho/2;
        end   
    elseif strcmpi(Family, 'SM1')
            id=dev2elem('SM1',DeviceList);         
        for i=1:size(DeviceList,1)              
            xit=AD.SM1.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.SM1.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=-interp1(xit, yit, Amps(i))/Brho/2;
        end
    elseif strcmpi(Family, 'SM2') 
        id=dev2elem('SM2',DeviceList);  
        for i=1:size(DeviceList,1)              
            xit=AD.SM2.MagnetTable(:,(id(i)-1)*2+1);
            yit=AD.SM2.MagnetTable(:,(id(i)-1)*2+2);
            k(i,1)=interp1(xit, yit, Amps(i))/Brho/2;
        end         
    elseif strcmpi(Family, 'SQ') 
        Amps=0.;
        k = 0.00397*Amps/Brho/2.;
     end
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setpoint and Monitor Fields %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if any(strcmpi(Field, {'Setpoint','Monitor'}))
%    error('amp2k conversion needs to be programmed for %s.%s\n', Family, Field);
%    return
%end


% If you made it to here, I don't know how to convert it
k = Amps;
B = Amps;
return

