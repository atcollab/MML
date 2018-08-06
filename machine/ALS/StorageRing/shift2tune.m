function [Dnux, Beff, Bmax, Lambda, IDLength, B10, B30, B50] = shift2tune(Sector, Gap, EPUshift, GeV)
%SHIFT2TUNE - Computes the horizontal tune shift for a EPU gap and horizontal shift
%             Harmonic B-contents based on measured tune shifts (beta-function is hardcoded)
%
%  [Dnux, Beff, Bmax, Lambda, IDLength, B10, B30, B50] = shift2tune(Sector, Gap, PhaseShift, GeV)
%
%  INPUTS
%  1. Sector - Insertion device list (i.e. [7 1])
%  2. Gap - Vertical gap [mm]
%  3. PhaseShift - Horizontal phase shift [mm]
%  4. GeV - Storage ring energy [GeV]
%
%  OUTPUTS
%  1. Dnux - Horizontal tune shift
%  2. Beff - Effective field in T
%  3. Bmax
%  4. Lambda
%  5. IDLength
%  6. B10
%  7. B30
%  8. B50
%
%  See also getid, getff, getusergap, gap2tune, gap2tune

%  Writen by Christoph Steier (2000/07/10)


% Added new middle layer functionality 2006-01-24:  G. Portmann


if nargin < 1
    Sector = [];
end
if isempty(Sector)
    Sector = family2dev('EPU');
end
if size(Sector,2) == 1
    %Sector = elem2dev('EPU', Sector);
    Sector = [Sector ones(size(Sector))];
end

if nargin < 2
    Gap = [];
end
if isempty(Gap)
    Gap = getsp('ID', Sector);
end

if nargin < 3
    EPUshift = [];
end
if isempty(EPUshift)
    EPUshift = getsp('EPU', Sector);
end

if nargin < 4
    GeV = [];
end
if isempty(GeV)
    GeV = getenergy;   % or getfamilydata('Energy'); to assume production energy
end

if size(Sector,1) ~= size(Gap,1)
    if size(Gap,1) == 1
        Gap = ones(size(Sector,1),1) * Gap;
    else
        error('Rows of Sector & Gap must equal (or Gap must be a scalar or row vector).');
    end
end


% Beta at straight section center
BetaX = 13.5;
BetaY = 2.25;


for i = 1:size(Sector,1)

    if Sector(i,:)==[4 1] 
        Lambda(i,1) = 50;
        IDLength(i,1) = 1.85;

        B10(i,1) = 0.7656;
        B30(i,1) = 6.8663;
        B50(i,1) = 5.3628;

    elseif Sector(i,:)==[11 1] 
        Lambda(i,1) = 50;
        IDLength(i,1) = 0; % after shimming ID tune shift for 11 1 has changed ... new data needs to be fitted

        B10(i,1) = 0.7656;
        B30(i,1) = 6.8663;
        B50(i,1) = 5.3628;

    elseif Sector(i,:)==[11 2] 
        Lambda(i,1) = 50;
        IDLength(i,1) = 1.85;

        B10(i,1) = 0.7656;
        B30(i,1) = 6.8663;
        B50(i,1) = 5.3628;


    else

        fprintf('   WARNING:  Unknown insertion device, EPU(%d,%d) (shift2tune).  NaN returned.\n', Sector(i,:));

        Lambda(i,1) = NaN;
        IDLength(i,1) = NaN;
        B10(i,1) = NaN;
        B30(i,1) = NaN;
        B50(i,1) = NaN;

        %Dnux = NaN;
        %Beff = NaN;
        %return

    end


    if nargout > 2
        Bmax(i,:) = B10(i)*exp(-pi*Gap(i,:)/Lambda(i)) + B30(i)*exp(-3*pi*Gap(i,:)/Lambda(i)) + B50(i)*exp(-5*pi*Gap(i,:)/Lambda(i));
    end

    Beff(i,:) = sqrt((B10(i)*exp(-pi*Gap(i,:)/Lambda(i))).^2 + (B30(i)*exp(-3*pi*Gap(i,:)/Lambda(i))).^2 + (B50(i)*exp(-5*pi*Gap(i,:)/Lambda(i))).^2);

%	 if Sector(i,:)==[4 1]
%		  Dnux(i,:) = ___ ;
%	 else
	     Dnux(i,:) = (1/(8*pi)*BetaX*IDLength(i)*0.2998^2*(Beff(i,:)./GeV).^2)*1.05.*(0.6+(cos(pi*(1/25)*EPUshift(i,:))-1));
%	 end

    %Dnuy(i,:) = 1/(8*pi)*BetaY*IDLength(i)*0.2998^2*(Beff(i)./GeV).^2;
end
