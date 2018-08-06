function [DelHCM, DelVCM, DelQF, DelQD] = ffdeltasp(Sector, Gap, LongitudinalGap, GeV)
% [DelHCM, DelVCM, DelQF, DelQD] = ffdeltasp(Sector, Gap, LongitudinalGap, GeV)
%
% Inputs:
%   Sector (column vector)
%   Gap and LongitudinalGap must have the same number of columns
%   Sector, Gap, and LongitudinalGap must have the same number of rows
%
% Defaults:
%   if 0 or 1 inputs, then Gap=getid and LongitudinalGap=getepu
%   if 2 inputs, then LongitudinalGap = zeros(size(Gap))
%
% Outputs
%   Each column corresponds to the sum of all the sectors
%   DelHCM, DelVCM, DelQF, DelQD are sized to the full family size
%   Note:  if Sector has more than one element then HCM, VCM, QF, QD and their
%          associated lists correspond to only the last element.  It does not make
%          sense to sum corrections from different sectors.

% Revision History:
%
% 2003-02-25, Christoph Steier
%		Added quadrupole feed forward for EPU in sector 11 and longitudinal dipole feed forward
% 2005-12-21, Greg Portmann
%		Changed for new middle layer.  Copies srcontrol5 for tune correction.


HCMelem = dev2elem('HCM', family2dev('HCM'));
VCMelem = dev2elem('VCM', family2dev('VCM'));


if nargin < 1
    Sector = [];
end
if isempty(Sector)
    Sector = family2dev('ID');
end
if size(Sector,2) == 1
    %Sector = elem2dev('ID', Sector);
    Sector = [Sector ones(size(Sector))];
end

if nargin < 2
    Gap = [];
end
if isempty(Gap)
    Gap = getid(Sector);
end

if nargin < 3
    LongitudinalGap = [];
end
if isempty(LongitudinalGap)
    LongitudinalGap = getepu(Sector);
end

if nargin < 4
    GeV = [];
end
if isempty(GeV)
    GeV = getenergy('Production');  % was getenergy, changed by GJP 2/13/2007
end


if size(Sector,1) ~= size(Gap,1)
    error('Rows of Sector & Gap must equal.');
end
if any(size(Gap) ~= size(LongitudinalGap))
    error('Sector and LongitudinalGap must be the same size');
end



% Initialize
HCMDeviceList = family2dev('HCM');
VCMDeviceList = family2dev('VCM');
DelHCM = zeros(size(HCMDeviceList,1), size(Gap,2));
DelVCM = zeros(size(VCMDeviceList,1), size(Gap,2));
HCM    = zeros( 4, size(Gap,2));
VCM    = zeros( 4, size(Gap,2));


for i = 1:size(Sector,1);
    if any(Sector(i,1) == [4 6 11])
        if Sector(i,2) == 1
            HCMlist1 = [
                Sector(i,1)-1  8;
                Sector(i,1)-1 10;
                Sector(i,1)-1  2;  % ???
                Sector(i,1)    7]; % ???

            VCMlist1 = [
                Sector(i,1)-1  8;
                Sector(i,1)-1 10;
                Sector(i,1)-1  2;  % ???
                Sector(i,1)    7]; % ???
        else
            HCMlist1 = [
                Sector(i,1)-1 10;
                Sector(i,1)    1;
                Sector(i,1)-1  2;  % ???
                Sector(i,1)    7]; % ???

            VCMlist1 = [
                Sector(i,1)-1 10;
                Sector(i,1)    1;
                Sector(i,1)-1  2;  % ???
                Sector(i,1)    7]; % ???
        end
    else
        HCMlist1 = [
            Sector(i,1)-1 8;
            Sector(i,1)   1;
            Sector(i,1)-1 2;
            Sector(i,1)   7];

        VCMlist1 = [
            Sector(i,1)-1 8;
            Sector(i,1)   1;
            Sector(i,1)-1 2;
            Sector(i,1)   7];
    end

    iHCM = findrowindex(HCMlist1, HCMDeviceList);
    iVCM = findrowindex(VCMlist1, VCMDeviceList);


    % Read the vertical FF table
    [tableHCM, tableVCM, tableQ] = fftable(Sector(i,1), GeV);
    if (Sector(i,1) == 4) || (Sector(i,1) == 11)
        [GapsLongitudinal, Gaps, HCMtable1, HCMtable2, VCMtable1, VCMtable2] = fftableepu(Sector(i,1), GeV);
        %[GapsLongitudinal, Gaps, HCMtable1, HCMtable2, VCMtable1, VCMtable2] = fftableepu;
    end

    for j = 1:size(Gap,2)
        % just to make table1 work without errors
        tmpgap = Gap(i,j);
        if tmpgap >= tableHCM(1,1)
            tmpgap = tableHCM(1,1);
        end
        if tmpgap <= tableHCM(size(tableHCM,1),1)
            tmpgap = tableHCM(size(tableHCM,1),1);
        end

        HCM(1:2,j) = [
            interp1(tableHCM(:,1), tableHCM(:,2), tmpgap);
            interp1(tableHCM(:,1), tableHCM(:,3), tmpgap)];

        VCM(1:2,j) = [
            interp1(tableVCM(:,1), tableVCM(:,2), tmpgap);
            interp1(tableVCM(:,1), tableVCM(:,3), tmpgap)];


        % Read the longitudinal FF table
        if (Sector(i,1) == 4) || (Sector(i,1) == 11)
            % just to make table1 work without errors
            tmpgap = Gap(i,j);
            if tmpgap >= Gaps(1)
                tmpgap = Gaps(1);
            end
            if tmpgap <= Gaps(end)
                tmpgap = Gaps(end);
            end

            tmpLongitudinalGap = LongitudinalGap(i,j);
            if tmpLongitudinalGap < GapsLongitudinal(1)
                tmpLongitudinalGap = GapsLongitudinal(1);
            end
            if tmpLongitudinalGap > GapsLongitudinal(end)
                tmpLongitudinalGap = GapsLongitudinal(end);
            end

            hcm1 = interp2(GapsLongitudinal, Gaps, HCMtable1, tmpLongitudinalGap, tmpgap);
            hcm2 = interp2(GapsLongitudinal, Gaps, HCMtable2, tmpLongitudinalGap, tmpgap);
            vcm1 = interp2(GapsLongitudinal, Gaps, VCMtable1, tmpLongitudinalGap, tmpgap);
            vcm2 = interp2(GapsLongitudinal, Gaps, VCMtable2, tmpLongitudinalGap, tmpgap);

            HCM(:,j) = HCM(:,j) + [hcm1;hcm2;0;0];
            VCM(:,j) = VCM(:,j) + [vcm1;vcm2;0;0];
        end

        DelHCM(iHCM,j) = DelHCM(iHCM,j) + HCM(:,j);
        DelVCM(iVCM,j) = DelVCM(iVCM,j) + VCM(:,j);
    end
end



% Tune feed forward
if nargout >= 3
    [DelQF, DelQD] = ffdeltaquad(Sector, Gap, GeV);
end





