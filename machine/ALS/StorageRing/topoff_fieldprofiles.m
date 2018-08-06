function [x, f, Families] = topoff_fieldprofiles(Family)
%  [x, f] = topoff_fieldprofiles(Family)
%
%  EXAMPLES
%  1. BEND Magnet #1
%     [x,f]=topoff_fieldprofiles('B1');
%     plot(x, f);
%     xlabel('Horizontal Position [meters]');
%     ylabel('Integrated Field [Gauss-CM]');
%
%  NOTES
%  1. This function assumes that the top-off directory is at the same level as mml root.
%
%  See also topoff_apertures, topoff_readtrackingfile, topoff_plottrackingfile

if nargin < 1
    Family = 'All';
end

if iscell(Family) || strcmpi(Family,'All') || nargout == 0
    if strcmpi(Family,'All')
        %Families = {'B1','QFA1','QDA1','QF1','QD1','SF1','SD1','HCM1','HCSF1','HCSD1'};
        %Families = {'B1','QFA1','QDA1','QF1','QD1','SF1','SD1'};
        %Families = {'B1','QFA1','QF1','QD1','SF1','SD1','HCM1','HCSF1','HCSD1'};
        Families = {'B1','QFA1','QF1','QD1','SF1','SD1'};
        %Families = {'HCM1','HCSF1','HCSD1'};
    else
        if iscell(Family)
            Families =Family;
        else
            Families = {Family};
        end
    end
    %Families = {'B1','QFA1','SF1','HCM1','HCSF1'};
    %clf reset;
    for i = 1:length(Families)
        [x{i},f{i}] = topoff_fieldprofiles(Families{i});
        hold on
        plot(x{i}, f{i}, 'color', nextline);
    end
    hold off;
    if length(Families) == 1
        title([Families{1}, ':  Maximum Kick Profile']);
    else
        if strcmpi(Family,'All')
            %legend({'BEND','QFA','QDA','QF','QD','SF','SD','HCM','HCSF','HCSD'});
            %legend({'BEND','QFA','QDA','QF','QD','SF','SD'});
            %legend({'BEND','QFA','QF','QD','SF','SD','HCM','HCSF','HCSD'});
            legend({'BEND','QFA','QF','QD','SF','SD'});
            %legend({'HCM','HCSF','HCSD'});
        else
            legend(Families);
        end
        title('Maximum Kick Profile');
    end
    xlabel('Horizontal Position [Meters]');
    ylabel('Integrated Kick Strength [Radians]');
    grid on;
    return;
else
    Families = {Family};
end


RootDir = pwd;
cd(getmmlroot);
cd ..
cd top-off
%cd Top-Off
cd Simulator
cd Data
cd diag
a = importdata(['1D_Prof_SR03C_', Family, '.csv'],',');
cd(RootDir);

x = a.data(:,1);
f = a.data(:,2);

Family = Family(1:end-1);

% Convert to radian kick
if strcmpi(Family,'SF')
    % K * Table
    Kmax = 16; % Nominal is 15.2347 (getkleff('SF'))
    f = Kmax * f;
elseif strcmpi(Family,'SD')
    % K * Table
    Kmax = -12; % Nominal is -10.5628 (getkleff('SD'))
    f = Kmax * f;
elseif strcmpi(Family,'HCM')
    % K * L * Table
    KLmax = .0025; 
    f = KLmax * f;
elseif strcmpi(Family,'HCSF')
    % K * L * Table
    KLmax = .0022 + .0004 + .00157; 
    f = KLmax * f;
elseif strcmpi(Family,'HCSD')
    % K * L * Table
    KLmax = .00225 + .0004; 
    f = KLmax * f;
elseif strcmpi(Family,'QF')
    % K * L * Table
    KLmax = 1.442 * 2.237111 * .448; 
    f = KLmax * f;
elseif strcmpi(Family,'QD')
    % K * L * Table
    KLmax = 1.292 * -2.511045 * .187; 
    f = KLmax * f;
elseif strcmpi(Family,'QDA')
    % K * L * Table
    KLmax = 1.802 * -1.779475 * .187; 
    f = KLmax * f;
elseif strcmpi(Family,'QFA')
    % K * L * Table
    KLmax = 1.072 * 2.954352 * .344; 
    f = KLmax * f;
elseif strcmpi(Family,'B')
    % L * Table
    Leff = 0.86514;
    f = Leff * f;
else
    error('Unknown family');
end


