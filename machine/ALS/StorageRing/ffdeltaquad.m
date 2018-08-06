function [DelQF, DelQD, DelSQSF, DelSQSD] = ffdeltaquad(Sector, Gap, GeV)
% function [DelQF, DelQD, DelSQSF, DelSQSD] = ffdeltaquad(Sector, Gap, GeV)
%
% Sector
% Gap
% GeV
%
% Updated, 2011-02-14, C. Steier
% copied actual FF algorithm from srcontrol

EPUlist = [];

if nargin < 1
    Sector = [];
end
if isempty(Sector)
    Sector = family2dev('ID');
    EPUlist = find((Sector(:,1)==4) | (Sector(:,1)==11));    
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
    GeV = [];
end
if isempty(GeV)
    GeV = getenergy;   % or getfamilydata('Energy'); to assume production energy
end

if isempty(EPUlist)
    EPUlist = find((Sector(:,1)==4) | (Sector(:,1)==11));
end

if size(Sector,1) ~= size(Gap,1)
    if size(Gap,1) == 1
        Gap = ones(size(Sector,1),1) * Gap;
    else
        error('Rows of Sector & Gap must equal.');
    end
end


% FF method
FFTypeFlag = 'Global'; % 'Local' or 'Global'

SR_Mode = getfamilydata('OperationalMode');
Energy  = getfamilydata('Energy');
SR_GeV  = getenergy;

% Load lattice set for tune feed forward
ConfigSetpoint = getproductionlattice;
QFsp = ConfigSetpoint.QF.Setpoint.Data;
QDsp = ConfigSetpoint.QD.Setpoint.Data;
TuneW16Min = gap2tune([5 1], 13.23, 1.8909);

% Tune response matrix
SR_TUNE_MATRIX = gettuneresp({'QF','QD'}, {[],[]}, getenergy('Production'));
%SR_TUNE_MATRIX = [0.1838   -0.0246
%                 -0.1237    0.1443];

SQSFsp = amp2k('SQSF','Setpoint',ConfigSetpoint.SQSF.Setpoint.Data);
SQSDsp = amp2k('SQSD','Setpoint',ConfigSetpoint.SQSD.Setpoint.Data);

% tune FF for EPUs (data exist for 4.1,11.1 and 11.2 parallel and antiparallel
% as well as 4.2 parallel (MERLIN is not supposed to be used in
% antiparallel mode)
if ispc
    % load 'm:\matlab\srdata\epu\tuneshift_2d_tables\epu_tunetables_2d_20070723.mat'
    load 'm:\matlab\srdata\epu\tuneshift_2d_tables\epu_tunetables_2d_20090204.mat'
else
    % load '/home/als/physdata/matlab/srdata/epu/tuneshift_2d_tables/epu_tunetables_2d_20070723.mat'
    load '/home/als/physdata/matlab/srdata/epu/tuneshift_2d_tables/epu_tunetables_2d_20090204.mat'
end
dnux41p = nux41p-nux41p(1,11);
dnuy41p = nuy41p-nuy41p(1,11);
dnux41a = nux41a-nux41a(1,11);
dnuy41a = nuy41a-nuy41a(1,11);
dnux42p = nux42p-nux42p(1,11);
dnuy42p = nuy42p-nuy42p(1,11);
dnux111p = nux111p-nux111p(1,11);
dnuy111p = nuy111p-nuy111p(1,11);
dnux111a = nux111a-nux111a(1,11);
dnuy111a = nuy111a-nuy111a(1,11);
dnux112p = nux112p-nux112p(1,11);
dnuy112p = nuy112p-nuy112p(1,11);
dnux112a = nux112a-nux112a(1,11);
dnuy112a = nuy112a-nuy112a(1,11);

% ID tune compensation does not work in the injection lattice, so ...
if abs(Energy - bend2gev)>  0.05     % Don't use this routine for the injection lattice
    warning('   This routine should only be used for the production energy: Orbit feedback aborted\n');
end


addQFsp = zeros(24,1);
addQDsp = zeros(24,1);

% The vectorized gets were put outside of loop for speed reasons
%
% should also set up QFfac, Quadelem, Quadlist structures outside loop
actualgap = getid(Sector);
[gapmin,gapmax] = gaplimit(Sector);
corrind = find(actualgap<(gapmin-1));
actualgap(corrind)=gapmax(corrind);
Shift=zeros(size(actualgap));
Shift(EPUlist)=getpv('EPU');

% EPUs excite nux = .25 resonance in vertical linear polarization mode!
% therefore with EPU tune feedforward
% running, we want to move our nominal working point away (just below) the .25 resonance.
%
% The following tune correction moves nominal
% nu_x from .25 to .245 - this should be enough for well set up lattices.
%
% 24 QF+ 24 QD
DeltaAmps = inv(SR_TUNE_MATRIX) * [-0.005;0];    %  DelAmps =  [QF; QD];
addQFsp = addQFsp + DeltaAmps(1,:);
addQDsp = addQDsp + DeltaAmps(2,:);

for gapnum = 1:length(actualgap)
    % Change in tune and [QF;QD] from maximum gap
    if (Sector(gapnum,1) == 4) || (Sector(gapnum,1) == 11)
        if Sector(gapnum,2) == 1
            modenamestr = sprintf('SR%02dU___ODS1M__DC00',Sector(gapnum,1));
        else % if Sector(gapnum,2) == 2
            modenamestr = sprintf('SR%02dU___ODS2M__DC00',Sector(gapnum,1));
        end
        epumode = getpv(modenamestr);
        if (Sector(gapnum,1) == 4) && (Sector(gapnum,2) == 1)
            if (epumode == 0)
                DeltaNuX = interp2(gap41p',shift41p',dnux41p',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap41p',shift41p',dnuy41p',actualgap(gapnum),Shift(gapnum),'linear',0);
            elseif (epumode == 1)
                DeltaNuX = interp2(gap41a',shift41a',dnux41a',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap41a',shift41a',dnuy41a',actualgap(gapnum),Shift(gapnum),'linear',0);
            else
                DeltaNux = 0;
                DeltaNuY = gap2tune(Sector(gapnum, :), actualgap(gapnum), SR_GeV);
            end
        elseif (Sector(gapnum,1) == 4) && (Sector(gapnum,2) == 2)
            if (epumode == 0)
                DeltaNuX = interp2(gap42p',shift42p',dnux42p',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap42p',shift42p',dnuy42p',actualgap(gapnum),Shift(gapnum),'linear',0);
            else
                DeltaNux = 0;
                DeltaNuY = 0;
                disp('WARNING: EPU 4.2 is not in parallel polarization mode! It should always be operated in mode 0!');
            end
        elseif (Sector(gapnum,1) == 11) && (Sector(gapnum,2) == 1)
            if (epumode == 0)
                DeltaNuX = interp2(gap111p',shift111p',dnux111p',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap111p',shift111p',dnuy111p',actualgap(gapnum),Shift(gapnum),'linear',0);
            elseif (epumode == 1)
                DeltaNuX = interp2(gap111a',shift111a',dnux111a',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap111a',shift111a',dnuy111a',actualgap(gapnum),Shift(gapnum),'linear',0);
            else
                DeltaNuX = 0;
                DeltaNuY = gap2tune(Sector(gapnum,:), actualgap(gapnum), SR_GeV);   % variation of vertical tune shift with phase is small for EPUs
            end
        elseif (Sector(gapnum,1) == 11) && (Sector(gapnum,2) == 2)
            if (epumode == 0)
                DeltaNuX = interp2(gap112p',shift112p',dnux112p',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap112p',shift112p',dnuy112p',actualgap(gapnum),Shift(gapnum),'linear',0);
            elseif (epumode == 1)
                DeltaNuX = interp2(gap112a',shift112a',dnux112a',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap112a',shift112a',dnuy112a',actualgap(gapnum),Shift(gapnum),'linear',0);
            else
                DeltaNuX = 0;
                DeltaNuY = gap2tune(Sector(gapnum,:), actualgap(gapnum), SR_GeV);   % variation of vertical tune shift with phase is small for EPUs
            end
        else
            DeltaNuX = 0;
            DeltaNuY = gap2tune(Sector(gapnum,:), actualgap(gapnum), SR_GeV);
        end
        
    else
        DeltaNuX = 0;
        DeltaNuY = gap2tune(Sector(gapnum,:), actualgap(gapnum), SR_GeV);
    end
    
    DelQF = zeros(length(QFsp),1);
    DelQD = zeros(length(QFsp),1);
    
    fraccorr = 0.8*DeltaNuY ./ TuneW16Min;
    
    % Find which quads to change (local beta beating correction
    % (horizontal for EPU, vertical otherwise)
    QuadList = [Sector(gapnum,1)-1 2; Sector(gapnum,1) 1];
    QuadElem = dev2elem('QF',QuadList); % in reality use QF and QD ...
    
    % global vertical tune correction
    % 24 QF+ 24 QD
    DeltaAmps = inv(SR_TUNE_MATRIX) * [(fraccorr*6.23e-4); fraccorr*(-0.05301)];    %  DelAmps =  [QF; QD];
    DelQF = DelQF + DeltaAmps(1,:);
    DelQD = DelQD + DeltaAmps(2,:);
    
    % local horizontal tune correction (is also nearly a beta beating correction) only nonzero for EPUs!
    % 2 QF + 2 QD
    DeltaAmpsLocal = 12*inv(SR_TUNE_MATRIX) * [-DeltaNuX;0];                       %  DelAmps =  [QF; QD];
    DelQF(QuadElem) = DelQF(QuadElem)+DeltaAmpsLocal(1,1);
    DelQD(QuadElem) = DelQD(QuadElem)+DeltaAmpsLocal(2,1);
    
    % local vertical beta beating correction (should be used together with above global tune correction)
    % set to zero for EPUs, since their vertical tune shift is small
    % 2 QF + 2QD
    if (Sector(gapnum,1)==6) || (Sector(gapnum,1)==7) || (Sector(gapnum,1)==10) || (Sector(gapnum,1)==11)
        QFfac = ([2.243127/2.237111; 2.243127/2.237111]-1) * fraccorr;
        QDfac = ([2.556392/2.511045; 2.556392/2.511045]-1) * fraccorr;
    elseif (Sector(gapnum,1)==5) || (Sector(gapnum,1)==9)
        QFfac = ([2.225965/2.219784; 2.243096/2.237111]-1) * fraccorr;
        QDfac = ([2.528950/2.483259; 2.556345/2.511045]-1) * fraccorr;
    elseif (Sector(gapnum,1)==4) || (Sector(gapnum,1)==8) || (Sector(gapnum,1)==12)
        QFfac = ([2.243096/2.237111; 2.225965/2.219784]-1) * fraccorr;
        QDfac = ([2.556345/2.511045; 2.528950/2.483259]-1) * fraccorr;
    else
        QFfac = zeros(2,1);
        QDfac = zeros(2,1);
    end
    
    DelQF(QuadElem,:) = DelQF(QuadElem,:) + QFfac.*QFsp(QuadElem,:);
    DelQD(QuadElem,:) = DelQD(QuadElem,:) + QDfac.*QDsp(QuadElem,:);
    
    % add all tune and beta beating corrections for this one ID to the summed up correction vectors for all IDs
    addQFsp = addQFsp+DelQF;
    addQDsp = addQDsp+DelQD;
    
    % Skew FF for IVID
    if (Sector(gapnum,1)==6)
        scale=(gap2tune([6 1])/0.005)*0.18;
        [SQSFincr, SQSDincr] = set_etaywave_nuy9_20skews_skewFF(scale);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % should add a limit check here %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        setpv('SQSF', 'Setpoint', SQSFsp+SQSFincr, [], 0, 'Physics');
%        setpv('SQSD', 'Setpoint', SQSDsp+SQSDincr, [], 0, 'Physics');
    end
end

DelQF = addQFsp;
DelQD = addQDsp;
DelSQSF = k2amp('SQSF','Setpoint',SQSFincr);
DelSQSD = k2amp('SQSD','Setpoint',SQSDincr);
