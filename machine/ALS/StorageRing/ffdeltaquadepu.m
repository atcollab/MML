function [DelQF, DelQD] = ffdeltaquadepu(Sector, Gap, Shift, mode, GeV)
% function [DelQF, DelQD] = ffdeltaquadepu(Sector, Gap, Shift, mode, GeV)
%
% Inputs:
% Sector
% Gap
% Shift
% Mode
% GeV
%
% Tom Scarvie, Christoph Steier, 2007

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
    Gap = getsp('ID', Sector);
end

if nargin < 3
    Shift = [];
end
if isempty(Shift)
    Shift = getsp('EPU', Sector);
end

if nargin < 4
    mode = [];
end
if isempty(mode)
    mode = 0;
end

if nargin < 5
    GeV = [];
end
if isempty(GeV)
    GeV = getenergy;   % or getfamilydata('Energy'); to assume production energy
end


if size(Sector,1) ~= size(Gap,1)
    if size(Gap,1) == 1
        Gap = ones(size(Sector,1),1) * Gap;
        Shift = ones(size(Sector,1),1) * Shift;
        mode = ones(size(Sector,1),1) * mode;
    else
        error('Rows of Sector & Gap & Shift must equal.');
    end
end


% FF method
FFTypeFlag = 'Global'; % 'Local' or 'Global'


% Load lattice set for tune feed forward
ConfigSetpoint = getproductionlattice;
QFsp = ConfigSetpoint.QF.Setpoint.Data;
QDsp = ConfigSetpoint.QD.Setpoint.Data;

QFsp = QFsp * ones(1,size(Gap,2));
QDsp = QDsp * ones(1,size(Gap,2));

SR_Mode = getfamilydata('OperationalMode');


% Tune response matrix
% gettuneresp is too slow for orbit feedback
TuneResponseMat = [0.1641 -0.0245
                   -0.1149 0.1477];
%TuneResponseMat = gettuneresp({'QF','QD'}, {[],[]}, GeV);
%TuneResponseMat = gettuneresp;  %('NoEnergyScaling'); or scale at the operational energy


% Initialize
DelQF  = zeros(length(QFsp), size(Gap,2));
DelQD  = zeros(length(QDsp), size(Gap,2));

TuneW16Min = gap2tune(5, 13.23, 1.8909);

for i = 1:size(Sector,1);

    if strcmp(SR_Mode, '1.9 GeV, High Tune') ||  strcmp(SR_Mode, '1.9 GeV, Inject at 1.23') || strcmp(SR_Mode, '1.9 GeV, Two-Bunch')

        % SR11 epu skew quadrupole feed forward
        % scale= -0.06;    % for nu_y = 8.20 lattice
        %               scale = -0.063;
        %               mid = ceil(length(epu_shift5)/2);

        %               if getsp('SR11U___ODS1M__DC00')==0
        %                  gap=getid(11);
        %                  shift=getepu(11);
        %                  [gapmin,gapmax] = gaplimit(11);
        %                  if gap < (gapmin-1)
        %                     gap = gapmax;
        %                  end
        %                  corrval=sqrt(shift2tune(11,gap,25)/shift2tune(11,15.67,25))* ...
        %                     scale*interp1(epu_shift5,int_epu_grad5-int_epu_grad5(mid),shift,'spline');
        %                  setsp('SR11U___Q______AC01',corrval);
        %               end

        if strcmp(FFTypeFlag,'Local')
            % Change in tune and [QF;QD] from maximum gap
            DeltaNuY = gap2tune(Sector(i,:), Gap(i,:), GeV);
            fraccorr = 1.15 * DeltaNuY / TuneW16Min;

            % Find which quads to change
            QuadList = [Sector(i,1)-1 1;Sector(i,1)-1 2;Sector(i,1) 1;Sector(i,1) 2];
            QuadElem = dev2elem('QF', QuadList);

            if (Sector(i,1)==7) | (Sector(i,1)==10) | (Sector(i,1)==11)
                QFfac = ([2.227520/2.237111; 2.239570/2.237111; 2.239570/2.237111; 2.227520/2.237111]-1) * fraccorr;
                QDfac = ([2.432264/2.511045; 2.543089/2.511045; 2.543080/2.511045; 2.432264/2.511045]-1) * fraccorr;
            elseif (Sector(i,1)==5) | (Sector(i,1)==9)
                QFfac = ([2.208418/2.219784; 2.225926/2.219784; 2.231777/2.237111; 2.233775/2.237111]-1) * fraccorr;
                QDfac = ([2.386512/2.483259; 2.545907/2.483259; 2.474571/2.511045; 2.491079/2.511045]-1) * fraccorr;
            elseif (Sector(i,1)==4) | (Sector(i,1)==8) | (Sector(i,1)==12)
                QFfac = ([2.233775/2.237111; 2.231777/2.237111; 2.225926/2.219784; 2.208418/2.219784]-1) * fraccorr;
                QDfac = ([2.491079/2.511045; 2.474571/2.511045; 2.545907/2.483259; 2.386512/2.483259]-1) * fraccorr;
            else
                QFfac = zeros(4,size(Gap,2));
                QDfac = zeros(4,size(Gap,2));
            end

            DelQF(QuadElem,:) = DelQF(QuadElem,:) + QFfac.*QFsp(QuadElem,:);
            DelQD(QuadElem,:) = DelQD(QuadElem,:) + QDfac.*QDsp(QuadElem,:);

        elseif strcmp(FFTypeFlag,'Global')
            % Change in tune and [QF;QD] from maximum gap
            
            DeltaNuX = 0;
            DeltaNuY = gap2tune(Sector(i,:), Gap(i,:), GeV);

            if (Sector(i,1) == 4) | (Sector(i,1) == 11)
                if Sector(i,2)==2
                    longshift=3;
                else
                    longshift=0;
                end
                if mode(i)==0
                    DeltaNuX = shift2tune(Sector(i,1),Gap(i,:),Shift(i,:)+longshift,GeV)+0.0015;
                    DeltaNuY = 0;   % vertical tune shift of EPUs is very small
                else
                    DeltaNuX = 0;
                    DeltaNuY = 0;
                end
            else
                DeltaNuX = 0;
            end
            
         
            fraccorr = DeltaNuY ./ TuneW16Min;

            % Find which quads to change
            QuadList = [Sector(i,1)-1 2; Sector(i,1) 1];
            QuadElem = dev2elem('QF',QuadList);
            
            DeltaAmps = inv(TuneResponseMat) * [(fraccorr*6.23e-4); fraccorr*(-0.05301)];    %  DelAmps =  [QF; QD];
%             if Sector(i,1)==5
%                 DeltaAmps
%             end           
            for j = 1:size(Gap,2)
                DelQF(:,j) = DelQF(:,j) + DeltaAmps(1,j);
                DelQD(:,j) = DelQD(:,j) + DeltaAmps(2,j);
            end
            %DelQF = DelQF + (DeltaAmps(1,:)' * ones(1,size(DelQF,1)))';  % Not any faster
            %DelQD = DelQD + (DeltaAmps(2,:)' * ones(1,size(DelQD,1)))';

            DeltaAmpsLocal = 12*inv(TuneResponseMat) * [-0.8*DeltaNuX;0];                       %  DelAmps =  [QF; QD];
            DelQF(QuadElem) = DelQF(QuadElem)+DeltaAmpsLocal(1,1);
            DelQD(QuadElem) = DelQD(QuadElem)+DeltaAmpsLocal(2,1);

            if (Sector(i,1)==6) | (Sector(i,1)==7) | (Sector(i,1)==10) | (Sector(i,1)==11)
                QFfac = ([2.243127/2.237111; 2.243127/2.237111]-1) * fraccorr;
                QDfac = ([2.556392/2.511045; 2.556392/2.511045]-1) * fraccorr;
            elseif (Sector(i,1)==5) | (Sector(i,1)==9)
                QFfac = ([2.225965/2.219784; 2.243096/2.237111]-1) * fraccorr;
                QDfac = ([2.528950/2.483259; 2.556345/2.511045]-1) * fraccorr;
            elseif (Sector(i,1)==4) | (Sector(i,1)==8) | (Sector(i,1)==12)
                QFfac = ([2.243096/2.237111; 2.225965/2.219784]-1) * fraccorr;
                QDfac = ([2.556345/2.511045; 2.528950/2.483259]-1) * fraccorr;
            else
                QFfac = zeros(2,size(Gap,2));
                QDfac = zeros(2,size(Gap,2));
            end

            DelQF(QuadElem,:) = DelQF(QuadElem,:) + QFfac.*QFsp(QuadElem,:);
            DelQD(QuadElem,:) = DelQD(QuadElem,:) + QDfac.*QDsp(QuadElem,:);

        else
            error('Unknown type selected for tune FF');
        end

    else

        % SR11 epu skew quadrupole feed forward

        %               scale= -0.06;  % for nu_y = 8.20 lattice
        % scale = -0.063;  % for nu_y = 9.20 lattice
        %               mid = ceil(length(epu_shift5)/2);

        %               if getsp('SR11U___ODS1M__DC00')==0
        %                  gap=getid(11);
        %                  shift=getepu(11);
        %                  corrval=shift2tune(11,gap,25)/shift2tune(11,15.67,25)* ...
        %                     scale*interp1(epu_shift5,int_epu_grad5-int_epu_grad5(mid),shift,'spline');
        %                  setsp('SR11U___Q______AC01',corrval);
        %               end
        
        % Change in tune and [QF;QD] from maximum gap
        DeltaNuY = gap2tune(Sector(i,:), Gap(i,:), GeV);

        if (Sector(i,1)==7) | (Sector(i,1)==10) | (Sector(i,1)==11)
            DeltaAmps = inv(TuneResponseMat/12) * [zeros(size(DeltaNuY)); -DeltaNuY];    %  DelAmps =  [QF; QD];
            DeltaAmpsQF = [DeltaAmps(1,:); DeltaAmps(1,:)];
            DeltaAmpsQD = [DeltaAmps(2,:); DeltaAmps(2,:)];
        elseif (Sector(i,1)==5) | (Sector(i,1)==9)
            DeltaAmpsQF = [-1.0637; -0.5132] * DeltaNuY / 0.0181 * 0.37;
            DeltaAmpsQD = [-6.6328; -3.3434] * DeltaNuY / 0.0181 * 0.37;
        elseif (Sector(i,1)==4) | (Sector(i,1)==8) | (Sector(i,1)==12)
            DeltaAmpsQF = [-0.5132; -1.0637] * DeltaNuY / 0.0181 * 0.37;
            DeltaAmpsQD = [-3.3434; -6.6328] * DeltaNuY / 0.0181 * 0.37;
        else
            DeltaAmpsQF = zeros(2,size(Gap,2));
            DeltaAmpsQD = zeros(2,size(Gap,2));
        end

        % Find which quads to change
        QuadList = [Sector(i,1)-1 1;Sector(i,1) 2];
        QuadElem = dev2elem('QF', QuadList);

        DelQF(QuadElem,:) = DelQF(QuadElem,:) + DeltaAmpsQF;
        DelQD(QuadElem,:) = DelQD(QuadElem,:) + DeltaAmpsQD;
    end
end
