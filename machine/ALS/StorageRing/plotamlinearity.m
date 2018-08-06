function Data = plotamlinearity(FileName)
% Data = plotamlinearity(FileName)
%
%
% See also measamlinearity


if nargin < 1
    FileName = '';
end

if isempty(FileName)
    DirectoryName = [getfamilydata('Directory','DataRoot'), 'Magnets', filesep, 'Meas_Linearity', filesep];
    
    [FileName, DirectoryName] = uigetfile('*.mat', 'Select a Linearity File', DirectoryName);
    if isequal(FileName,0) || isequal(DirectoryName,0)
        Data = '';
        return
    end
    FileName = [DirectoryName, FileName];
end

load(FileName);


NPerFig = 4;
iFig = 0;


% Use linearity files
%Families = {'HCM','VCM','Q','BEND'};
%Families = {'VCM'};

%for j = 1:length(Families)

%Family = Families{j};
%load(['SR_', Family,'_Linearity']);


close all

Merit = SP - AM;

NRows = size(SP,1);

% Change to the real max/min
Max = maxsp(Family, DevList);
Min = minsp(Family, DevList);

s = getspos(Family, DevList);

for i = 1:NRows
    if mod(i-1,NPerFig) == 0
        if iFig ~= 0
            xlabel('Setpoint [Amps]');
            subplot(NPerFig,2,iSub-1);
            xlabel('Setpoint [Amps]');
        end
        
        iFig = iFig + 1;
        h = figure(iFig);
        set(h, 'Position', [100+(iFig-1)*50 40 600 800]);
        clf reset
        orient tall
        iSub = 0;
    end
    
    % Least-square fit: m = slope and b = Y-intercept
    if strcmpi(deblank(Name(i,:)),'SR07C___SQSF1__AM00')
        % Exception #1 - this Kepco has issues
        SPi = SP(i,5:end)';
        AMi = AM(i,5:end)';
    else
        %SPi = SP(i,3:end-2)';
        %AMi = AM(i,3:end-2)';
        SPi = SP(i,5:end-4)';
        AMi = AM(i,5:end-4)';
    end
    
    %if strcmpi(deblank(Name(i,:)),'SR10C___HCM1___AM00')
    %    asdfsa =1;
    %end
    
    X = [ones(size(SPi)) SPi];
    invX = (inv(X'*X) * X') * AMi;
    Offset(i,1) = invX(1);
    Slope(i,1)  = invX(2);
    
    % Should equal
    %b = X \merit(i,:)';
    %bhat1(i,:) = b';
    
    %         A = [ones(N,1) SP(i,:)'];
    %         b = A \ AM(i,:)';
    %         AO.(Family).Monitor.Offset(i,1) = b(1);
    %         if abs(b(2)) < 1e-6
    %             % Gain is very small
    %             %AO.(Family).Monitor.Offset(i,1) = 0;
    %             AO.(Family).Monitor.Gain(i,1) = 1;
    %         else
    %             AO.(Family).Monitor.Gain(i,1) = 1/b(2);
    %         end
    
    % Plot
    %AMcal = AO.(Family).Monitor.Gain(i,1) * AM(i,:) - AO.(Family).Monitor.Offset(i,1);
    
    a = SP(i,:);  %linspace(SP(i,1), SP(i,end), 25);
    AMhat = Offset(i,1) + Slope(i,1) * a;
    
    iSub = iSub + 1;
    subplot(NPerFig,2,iSub);
    C = nxtcolor;
    plot(SP(i,:), AM(i,:),'.-', 'Color', C);
    hold on;
    plot(a, AMhat,'-r');
    ylabel('AM [Amps]');
    %title(deblank(Name(i,:)), 'Interp','None');
    title(sprintf('%s  (%.1f m)',deblank(Name(i,:)),s(i)), 'Interp','None');
    axis tight;
    xaxis([Min(i) Max(i)]);
    
    iSub = iSub + 1;
    subplot(NPerFig,2,iSub);
    plot(SP(i,:), SP(i,:)-AM(i,:),'.-', 'Color', C);
    hold on;
    plot(a, SP(i,:)-AMhat,'.-r');
    ylabel('SP-AM [Amps]');
    title(sprintf('%s  (%.1f m)',deblank(Name(i,:)),s(i)), 'Interp','None');
    %yaxis([-.1 .1]);
    axis tight;
    xaxis([Min(i) Max(i)]);
end
%h = legend(family2common(Family));
%set(h, 'Interpreter', 'None');
%yaxesposition(1.10);
%end

xlabel('Setpoint [Amps]');
subplot(NPerFig,2,iSub-1);
xlabel('Setpoint [Amps]');


iFig = iFig + 1;
h = figure(iFig);
set(h, 'Position', [100+(iFig-1)*50 40 600 800]);
subplot(2,1,1);
plot(s, Offset);
ylabel('Offset [Amps]', 'Fontsize',14);
title([Family,'   (AM = Slope * SP + Offset)'], 'Interp','None', 'Fontsize',14);
subplot(2,1,2);
plot(s, Slope);
ylabel('Slope AM/SP', 'Fontsize',14);
xlabel('Magnet Location [meters]', 'Fontsize',14);


Data = [DevList Offset Slope EOFF_AM ESLO_AM];

for i = 1:size(Data,1)
    fprintf('%2d %2d %10.7f %10.7f %12.8f %16.12f\n', Data(i,:));
end




