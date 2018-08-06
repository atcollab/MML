function EPBI = getepbiwaveform(SectorList)
%GETEPBIWAVEFORM 
%
%  See also plotepbiwaveform publish_epbi getepbichannelnames
 
%  Written by Greg Portmann

if nargin < 1
    SectorList = [5 6 7 8 9 10 11 12];
end

% Point 1000? is the trip point
% Note: the waveform sampling isn't changed by throttle --  so 50 Hz
% Add odd sectors



for Sector = SectorList(:)'
 
    % Waveform data recorder (assuming a trip occured)
    % Note: DataTime is last point in the waveform
    
    FieldName = sprintf('Sector%d', Sector);
    
    if any(Sector == [5 6 7 8 9 10 11 12])
    % Standard up, down, IG
        
        if Sector==5
            SectorName = sprintf('SR%02dW___', Sector);
        else
            SectorName = sprintf('SR%02dS___', Sector);
        end
        
        
        % Upper TCs
        try
            for i = 1:9
                [EPBI.(FieldName).Upper.WF(i,:), tmp, EPBI.(FieldName).Upper.TimeStamp(i,1)] = getpv(sprintf('%sTCUP%d_WF_AM', SectorName, i-1));
                [EPBI.(FieldName).Lower.WF(i,:), tmp, EPBI.(FieldName).Lower.TimeStamp(i,1)] = getpv(sprintf('%sTCDN%d_WF_AM', SectorName, i-1));
                
                EPBI.(FieldName).Upper.Limit(i,1) = getpv(sprintf('%sTCUP%d_limit', SectorName, i-1));
                EPBI.(FieldName).Lower.Limit(i,1) = getpv(sprintf('%sTCDN%d_limit', SectorName, i-1));
                
                EPBI.(FieldName).Upper.Label{i,1} = sprintf('Sector %d Upper TC%d', Sector, i-1);
                EPBI.(FieldName).Lower.Label{i,1} = sprintf('Sector %d Lower TC%d', Sector, i-1);
            end

            EPBI.(FieldName).Upper.Throttle = getpv(sprintf('%sUP_throttle', SectorName));
            EPBI.(FieldName).Lower.Throttle = getpv(sprintf('%sDN_throttle', SectorName));

            [EPBI.(FieldName).IG.WF(1,:), tmp, EPBI.(FieldName).IG.TimeStamp(1,1)] = getpv(sprintf('%sTCUP%d_WF_AM', SectorName, 9));
            EPBI.(FieldName).IG.Limit(1,1) = getpv(sprintf('%sTCUP%d_limit', SectorName, 9));
            EPBI.(FieldName).IG.Label{1,1} = sprintf('Sector %d IG1', Sector);
            EPBI.(FieldName).IG.Throttle = EPBI.(FieldName).Upper.Throttle;
        catch
        end
    else
    end
end


% Other types

% Sector 5 C
if any(SectorList == 5)
    Sector = 5;
    FieldName = sprintf('Sector%d', Sector);
    if Sector==5
        SectorName = sprintf('SR%02dW___', Sector);
    else
        SectorName = sprintf('SR%02dS___', Sector);
    end
    
    
    % ID
    try
        for i = 1:3
            [EPBI.(FieldName).IDUpper.WF(i,:), tmp, EPBI.(FieldName).IDUpper.TimeStamp(i,1)] = getpv(sprintf('%sTCIUP%d_WF_AM', SectorName, i-1));
            EPBI.(FieldName).IDUpper.Limit(i,1) = getpv(sprintf('%sTCIUP%d_limit', SectorName, i-1));
            EPBI.(FieldName).IDUpper.Label{i,1} = sprintf('Sector %d ID Upper TC%d', Sector, i-1);
            
            [EPBI.(FieldName).IDLower.WF(i,:), tmp, EPBI.(FieldName).IDLower.TimeStamp(i,1)] = getpv(sprintf('%sTCIDN%d_WF_AM', SectorName, i-1));
            EPBI.(FieldName).IDLower.Limit(i,1) = getpv(sprintf('%sTCIDN%d_limit', SectorName, i-1));
            EPBI.(FieldName).IDLower.Label{i,1} = sprintf('Sector %d ID Lower TC%d', Sector, i-1);
        end
        
        EPBI.(FieldName).IDUpper.Throttle = getpv(sprintf('%s03_throttle', SectorName));
        EPBI.(FieldName).IDLower.Throttle = EPBI.(FieldName).IDUpper.Throttle;
    catch
    end
    
    % Exit Flange
    try
        for i = 1:2
            [EPBI.(FieldName).EF.WF(i,:), tmp, EPBI.(FieldName).EF.TimeStamp(i,1)] = getpv(sprintf('%sTCEFL%d_WF_AM', SectorName, i-1));
            EPBI.(FieldName).EF.Limit(i,1) = getpv(sprintf('%sTCEFL%d_limit', SectorName, i-1));
            EPBI.(FieldName).EF.Label{i,1} = sprintf('Sector %d Exit Flange %d', Sector, i-1);
            EPBI.(FieldName).EF.Throttle = getpv(sprintf('%s03_throttle', SectorName));
        end
    catch
    end
end


    

if nargout == 0
    plotepbiwaveform(EPBI);
end


