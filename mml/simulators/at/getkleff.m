function [KLeff, K, Leff] = getkleff(Family, varargin)
%GETKLEFF - Returns K * Leff in the AT deck
%  KLeff = getkleff(Family, DeviceList)
%
%  INPUTS
%  1. Family = Family Name 
%              Accelerator Object
%              Cell Array of Accelerator Objects or Family Names
%              AT FamName
%  2. DeviceList = [Sector Device #] or [element #] list {Default or empty list: entire family}
%
%  NOTES
%  1. If Family is a cell array, then DeviceList must also be a cell array
%  2. If using AT FamName, then DeviceList is index vector, ie,
%              Length = THERING{ATIndexList}.Length(DeviceList)

%  Written by Greg Portmann

global THERING

if nargin == 0,
    error('Must have at least one input (Family or Channel Name).');
end

ATIndexList = getfamilydata(Family, 'AT', 'ATIndex', varargin{:});

if isempty(ATIndexList)
    % Try an AT family
    % For split families, this will return all the magnets
    ATIndexList = findcells(THERING, 'FamName', Family);
    ATIndexList = ATIndexList(:);
    if nargin >= 2
        ATIndexList = ATIndexList(varargin{2});
    end
end


Leff = getleff(Family, varargin{:});


% For split magngets this assumes that all K-values are the same
for i=1:size(ATIndexList,1)
    if isfield(THERING{ATIndexList(i,1)},'K')
        % Could be QUAD or a BEND depend on the machine
        K(i,:) = THERING{ATIndexList(i,1)}.K;
        KLeff(i,:) = Leff(i) * K(i,:);
    elseif isfield(THERING{ATIndexList(i,1)},'KickAngle') && ismemberof(Family, 'HCM')
        % For correctors, KickAngle = B * Leff / Brho ???  (mradians)
        KLeff(i,:) = THERING{ATIndexList(i,1)}.KickAngle(1);
        if nargout >= 2
            K(i,:) = KLeff(i,:) ./ Leff;
        end
    elseif isfield(THERING{ATIndexList(i,1)},'KickAngle') && ismemberof(Family, 'VCM')
        % For correctors, KickAngle = B * Leff / Brho ???  (mradians)
        % Hence, even if Leff = 0 (thin lense corrector) K*Leff will be right
        KLeff(i,:) = THERING{ATIndexList(i,1)}.KickAngle(2);
        if nargout >= 2
            K(i,:) = KLeff(i,:) ./ Leff;
        end
    elseif isfield(THERING{ATIndexList(i,1)},'PolynomB') && ismemberof(Family, 'SEXT')
        K(i,:) = THERING{ATIndexList(i,1)}.PolynomB(3);
        KLeff(i,:) = Leff(i) * K(i,:);
    elseif isfield(THERING{ATIndexList(i,1)},'PolynomA') && ismemberof(Family, 'SKEWQUAD')
        K(i,:) = THERING{ATIndexList(i,1)}.PolynomA(2);
        KLeff(i,:) = Leff(i) * K(i,:);
    else
        error('Which field in THERING to use is not clear.');
    end
end

