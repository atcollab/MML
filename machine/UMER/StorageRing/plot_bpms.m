function fig = plot_bpms(bpms,field1,field2,h)
% Plots x,y position from bpm object
%
% INPUT1:
%   1. bpms - cell array of bpm objects
%   2. field1 - field in bpm object to plot
%   3. field2 - field in bpm object to plot
%       options: 'X','Y','sum'
%   4. h - figure handle to use
%
% INPUT2:
%   1. bpms1 - cell array of bpm objects
%   2. bpms2 - cell array of bpm objects
%   3. field - field in bpm objects to plot for both bpm sets
%       options: 'X','Y','sum
%   4. h - figure handle to use
%
% INPUT3:
%   1. bpms - a cell array of a cell array of bpms. i.e. multiple sets of
%   bpm readings
%   2. field1
%       options: 'Movie'
%
% OUTPUT:
%   1. fig - figure handle
%
%
% NOTES
%   'sum' will plot the current of the beam (i.e. converts from mV to mA)
%
%
%
conv = 4.9240;
bpmxticks = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
bpmxlabels = {'RC1','RC2','RC3','RC5','RC6','RC7','RC8','RC9','RC11','RC12','RC13','RC14','RC15','RC17'};

if nargin == 4
    fig = figure(h);
else
    fig = figure('units','pixels','pos',[10,10,750,300]);
end

method = 1;
if iscell(field1)
    % method 2
    method = 2;
    field = field2;
    bpms1 = bpms;
    bpms2 = field1;
elseif nargin < 3
    % must be method 1
    % no field2
    field2 = false;
    method = 1;
end

if method == 1
    if field2
        % plot field 1
        subplot(211)
        if strcmpi(field1,'X')
            X = cellfun( @(S) S.X, bpms, 'uni', false);
            Xs = zeros(length(X),length(X{1}));
            for i = 1:length(X)
                Xs(i,:) = X{i};
            end
            plot(Xs,'.-')
            axis([0,15,-10,10])
            legend({'turn1','turn2','turn3','turn4'})
            xlabel('BPMs')
            set(gca,'xtick',bpmxticks);
            set(gca,'xticklabel',bpmxlabels);
            ylabel('X pos (mm)')
        elseif strcmpi(field1,'Y')
            Y = cellfun( @(S) S.Y, bpms, 'uni', false);
            Ys = zeros(length(Y),length(Y{1}));
            for i = 1:length(Y)
                Ys(i,:) = Y{i};
            end
            plot(Ys,'.-')
            axis([0,15,-10,10])
            legend({'turn1','turn2','turn3','turn4'})
            set(gca,'xtick',bpmxticks);
            set(gca,'xticklabel',bpmxlabels);
            xlabel('BPMs')
            ylabel('Y pos (mm)')
        elseif field1 == 'sum'
            bpmsum = cellfun( @(S) S.sum, bpms, 'uni', false);
            sums = zeros(length(bpmsum),length(bpmsum{1}));
            for i = 1:length(bpmsum)
                sums(i,:) = bpmsum{i};
            end
            plot(sums,'.-')
            xlim([0,15])
            legend({'turn1','turn2','turn3','turn4'})
            xlabel('BPMs')
            ylabel('Sum (mV)')
        end
        
        % plot field 2
        subplot(212)
        if strcmpi(field2,'X')
            X = cellfun( @(S) S.X, bpms, 'uni', false);
            Xs = zeros(length(X),length(X{1}));
            for i = 1:length(X)
                Xs(i,:) = X{i};
            end
            plot(Xs,'.-')
            axis([0,15,-10,10])
            legend({'turn1','turn2','turn3','turn4'})
            set(gca,'xtick',bpmxticks);
            set(gca,'xticklabel',bpmxlabels);
            xlabel('BPMs')
            ylabel('X pos (mm)')
        elseif strcmpi(field2,'Y')
            Y = cellfun( @(S) S.Y, bpms, 'uni', false);
            Ys = zeros(length(Y),length(Y{1}));
            for i = 1:length(Y)
                Ys(i,:) = Y{i};
            end
            plot(Ys,'.-')
            axis([0,15,-10,10])
            legend({'turn1','turn2','turn3','turn4'})
            set(gca,'xtick',bpmxticks);
            set(gca,'xticklabel',bpmxlabels);
            xlabel('BPMs')
            ylabel('Y pos (mm)')
        elseif field2 == 'sum'
            bpmsum = cellfun( @(S) S.sum, bpms, 'uni', false);
            sums = zeros(length(bpmsum),length(bpmsum{1}));
            for i = 1:length(bpmsum)
                sums(i,:) = bpmsum{i};
            end
            plot(sums,'.-')
            xlim([0,15])
            legend({'turn1','turn2','turn3','turn4'})
            xlabel('BPMs')
            ylabel('Sum (mV)')
        end
    else
        subplot(111)
        if strcmpi(field1,'X')
            X = cellfun( @(S) S.X, bpms, 'uni', false);
            Xs = zeros(length(X),length(X{1}));
            for i = 1:length(X)
                Xs(i,:) = X{i};
            end
            plot(Xs,'.-')
            axis([0,15,-5,5])
            legend({'turn1','turn2','turn3','turn4'})
            set(gca,'xtick',bpmxticks);
            set(gca,'xticklabel',bpmxlabels);
            xlabel('BPMs')
            ylabel('X pos (mm)')
        elseif strcmpi(field1,'Y')
            Y = cellfun( @(S) S.Y, bpms, 'uni', false);
            Ys = zeros(length(Y),length(Y{1}));
            for i = 1:length(Y)
                Ys(i,:) = Y{i};
            end
            plot(Ys,'.-')
            axis([0,15,-5,5])
            legend({'turn1','turn2','turn3','turn4'})
            set(gca,'xtick',bpmxticks);
            set(gca,'xticklabel',bpmxlabels);
            xlabel('BPMs')
            ylabel('Y pos (mm)')
        elseif strcmpi(field1,'sum')
            X1 = cellfun( @(S) S.sum, bpms, 'uni', false);
            Xs1 = zeros(length(X1),length(X1{1}));
            
            for i = 1:length(X1)
                Xs1(i,:) = X1{i};
            end
            plot(Xs1./conv,'.-')
            legend({'turn1','turn2','turn3','turn4'})
            set(gca,'xtick',bpmxticks);
            set(gca,'xticklabel',bpmxlabels);
            xlabel('BPMs')
            ylabel('sum (mA)')
        elseif strcmpi(field1,'Movie')
            % only used right now with rcds stuff
            global g_data
            subplot(313);
            try
                plot(g_data(:,end),'.-'); hold on; grid on;
            end
            for i = 1:length(bpms)
                X = cellfun( @(S) S.X, bpms{i}, 'uni', false);
                Y = cellfun( @(S) S.Y, bpms{i}, 'uni', false);
                for ii = 1:length(X)
                    Xs(ii,:) = X{ii};
                end
                for ii = 1:length(Y)
                    Ys(ii,:) = Y{ii};
                end
                subplot(311)
                plot(Xs,'.-')
                grid on
                axis([0,15,-5,5])
                set(gca,'xtick',bpmxticks);
                set(gca,'xticklabel',bpmxlabels);
                legend({'turn1','turn2','turn3','turn4'})
                title(['iteration ',num2str(i)]);
                subplot(312)
                plot(Ys,'.-')
                grid on;
                axis([0,15,-5,5])
                set(gca,'xtick',bpmxticks);
                set(gca,'xticklabel',bpmxlabels);
                legend({'turn1','turn2','turn3','turn4'})
                subplot(313)
                try
                    plot(1:i,g_data(1:i,end),'r')
                end
                pause(0.011)
            end
        end
    end
else
    % method 2
    if strcmpi(field,'X')
        X1 = cellfun( @(S) S.X, bpms1, 'uni', false);
        Xs1 = zeros(length(X1),length(X1{1}));
        X2 = cellfun( @(S) S.X, bpms2, 'uni', false);
        Xs2 = zeros(length(X2),length(X2{1}));
        
        for i = 1:length(X1)
            Xs1(i,:) = X1{i};
            Xs2(i,:) = X2{i};
        end
        subplot(211)
        plot(Xs1,'.-')
        axis([0,15,-5,5])
        legend({'turn1','turn2','turn3','turn4'})
        set(gca,'xtick',bpmxticks);
        set(gca,'xticklabel',bpmxlabels);
        xlabel('BPMs')
        ylabel('X pos (mm)')
        subplot(212)
        plot(Xs2,'.-')
        axis([0,15,-5,5])
        legend({'turn1','turn2','turn3','turn4'})
        set(gca,'xtick',bpmxticks);
        set(gca,'xticklabel',bpmxlabels);
        xlabel('BPMs')
        ylabel('X pos (mm)')
    elseif strcmpi(field,'Y')
        X1 = cellfun( @(S) S.Y, bpms1, 'uni', false);
        Xs1 = zeros(length(X1),length(X1{1}));
        X2 = cellfun( @(S) S.Y, bpms2, 'uni', false);
        Xs2 = zeros(length(X2),length(X2{1}));
        
        for i = 1:length(X1)
            Xs1(i,:) = X1{i};
            Xs2(i,:) = X2{i};
        end
        subplot(211)
        plot(Xs1,'.-')
        axis([0,15,-5,5])
        legend({'turn1','turn2','turn3','turn4'})
        set(gca,'xtick',bpmxticks);
        set(gca,'xticklabel',bpmxlabels);
        xlabel('BPMs')
        ylabel('Y pos (mm)')
        subplot(212)
        plot(Xs2,'.-')
        axis([0,15,-5,5])
        legend({'turn1','turn2','turn3','turn4'})
        set(gca,'xtick',bpmxticks);
        set(gca,'xticklabel',bpmxlabels);
        xlabel('BPMs')
        ylabel('Y pos (mm)')
    elseif strcmpi(field,'sum')
        X1 = cellfun( @(S) S.sum, bpms1, 'uni', false);
        Xs1 = zeros(length(X1),length(X1{1}));
        X2 = cellfun( @(S) S.sum, bpms2, 'uni', false);
        Xs2 = zeros(length(X2),length(X2{1}));
        
        for i = 1:length(X1)
            Xs1(i,:) = X1{i};
            Xs2(i,:) = X2{i};
        end
        subplot(211)
        plot(Xs1./conv,'.-')
        legend({'turn1','turn2','turn3','turn4'})
        set(gca,'xtick',bpmxticks);
        set(gca,'xticklabel',bpmxlabels);
        xlabel('BPMs')
        ylabel('sum (mA)')
        subplot(212)
        plot(Xs2./conv,'.-')
        legend({'turn1','turn2','turn3','turn4'})
        set(gca,'xtick',bpmxticks);
        set(gca,'xticklabel',bpmxlabels);
        xlabel('BPMs')
        ylabel('sum (mA)')
    end
end

