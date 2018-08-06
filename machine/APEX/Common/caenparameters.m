function [Caen, BaseName] = caenparameters(Section, DevName)
%CAENPARAMETERS - Returns the setup parameters for the Caen power supplies
%
% caenparameters('APEX')
%
% Written by Greg Portmann


if nargin < 1 || strcmpi(Section,'APEX')
    
    PIDScaleFactor = 1;
    
    % BaseName,   {PID},  {R L}, Limit, SlewRate
    BaseName = {
        'Sol1'
        'Sol2'
        'Sol3'
        
        'Sol1Quad1'
        'Sol1Quad2'
        'Sol2Quad1'
        'Sol2Quad2'
        'Sol1SQuad1'
        'Sol1SQuad2'
        'Sol2SQuad1'
        'Sol2SQuad2'
        
        'HCM0'
        'HCM1'
        'HCM2'
        'HCM3'
        'HCM4'
        'HCM5'
        'HCM6'
        'HCM7'
        'HCM8'
        'HCM9'

        'VCM0'
        'VCM1'
        'VCM2'
        'VCM3'
        'VCM4'
        'VCM5'
        'VCM6'
        'VCM7'
        'VCM8'
        'VCM9'
        
        %'EMHCM1'
        %'EMHCM2'
        %'EMVCM1'
        %'EMVCM2'
        
        'Quad1'
        'Quad2'
        'Quad3'
        'Quad4'
        'Quad5'

        'MPSol1'
        
       %'SpecBend1'
        };
    
    Data = [
        % Sol 1-3
        0.0010  0.0001   0  2.0  .045 -10.000 10.000 5  
        0.0010  0.0001   0  2.0  .045 -10.000 10.000 5
        0.0010  0.0001   0  2.0  .045 -10.000 10.000 5
        
        % Sol correctors
        0.0010  0.0001   0  1.15 .000018 -2.000 2.000 5
        0.0010  0.0001   0  1.15 .000018 -2.000 2.000 5
        0.0010  0.0001   0  1.15 .000018 -2.000 2.000 5
        0.0010  0.0001   0  1.15 .000018 -2.000 2.000 5
        0.0010  0.0001   0  1.15 .000018 -2.000 2.000 5
        0.0010  0.0001   0  1.15 .000018 -2.000 2.000 5
        0.0010  0.0001   0  1.15 .000018 -2.000 2.000 5
        0.0010  0.0001   0  1.15 .000018 -2.000 2.000 5
        
        % HCM
        0.0010  0.0001   0  0.54 .000018 -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        
        % VCM
        0.0010  0.0001   0  0.54 .000018 -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        0.0010  0.0001   0  0.65 .0015   -5.000 5.000 5
        
        % EMHCM
        %0.0010  0.0001   0  0.1 .00002 -16.50 16.50 5
        %0.0010  0.0001   0  0.1 .00002 -16.50 16.50 5
        %0.0010  0.0001   0  0.1 .00002 -16.50 16.50 5
        %0.0010  0.0001   0  0.1 .00002 -16.50 16.50 5
        
        % Quads
        0.0010  0.0001   0  0.143 .0005 -30.0 30.0 10 % Inductance???
        0.0010  0.0001   0  0.143 .0005 -30.0 30.0 10 % Inductance???
        0.0010  0.0001   0  0.143 .0005 -30.0 30.0 10 % Inductance???
        0.0010  0.0001   0  0.143 .0005 -30.0 30.0 10 % Inductance???
        0.0010  0.0001   0  0.143 .0005 -30.0 30.0 10 % Inductance???
        
        % MPSol
        0.0010  0.0001   0  0.143 .0005 -20.0 20.0 5 % Inductance???

        % SpecBend        
        %0.0010  0.0001   0  0.143 .0005 -30.0 30.0 5 % Inductance???
        
        ];
    PID = PIDScaleFactor * Data(:,1:3);
    R = Data(:,4);
    L = Data(:,5);
    Range = Data(:,6:7);
    SlewRate = Data(:,8);
    
    PS_Model = 'SY3634';
    Location = 'APEX';
    
else
    error('Accelerator section not defined.');
end


% Convert to structure output
for i = 1:size(BaseName,1)
    Caen(i,1).Name = BaseName{i};
    Caen(i,1).SN = NaN;
    Caen(i,1).R = R(i,1);
    Caen(i,1).L = L(i,1);
    Caen(i,1).Kp = PID(i,1);
    Caen(i,1).Ki = PID(i,2);
    Caen(i,1).Kd = PID(i,3);
    Caen(i,1).Limit    = abs(max(Range(i,:)));
    Caen(i,1).SlewRate = abs(SlewRate(i,1));
    Caen(i,1).Model    = PS_Model;
    Caen(i,1).Location = Location;
end


if nargin >= 2
    % Select power supplies
    
    if isempty(DevName) || (iscell(DevName) && isempty(DevName{1}))
        % Select from the whole list
        [BaseName, Index, CloseFlag] = editlist(BaseName, '', 0);
        if CloseFlag || isempty(Index)
            fprintf('   Nothing selected in %s\n', Section);
            Caen = [];
            BaseName = '';
            return
        end
        Caen = Caen(Index);
    elseif ischar(DevName)
        % Only if in the list
        %Index = findrowindex(DevName, BaseName);
        Index = find(strcmpi(DevName, BaseName));
        if isempty(Index)
            fprintf('   No BaseName match in section %s\n', Section);
            Caen = [];
            BaseName = '';
            return
        end
        Caen = Caen(Index);
    elseif iscell(DevName)
        % Only if in the list
        Index = [];
        for i = 1:length(DevName)
            i = find(strcmpi(DevName{i}, BaseName));
            if ~isempty(i)
                Index = [Index; i];
            end
        end
        if isempty(Index)
            fprintf('   No BaseName match in section %s\n', Section);
            Caen = [];
            BaseName = '';
            return
        end
        Caen = Caen(Index);
    end
end



