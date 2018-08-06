function plot_dvm_golden_loop_test(varargin)
% function plot_dvm_golden_loop_test(varargin)

GoldenFileName = 'BR_BQFQD_20091120.txt';     % updated on 11-20-09 for different tuning after Christoph retuned 11-18 for better multibunch capture in BR - T.Scarvie

if ispc
    GoldenPathName = '\\Als-filer\physdata\matlab\srdata\powersupplies\BQFQD_ramping_20071031\';
else
    GoldenPathName = '/home/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20071031/';
end

try
    GoldData = readdvmfile_local([GoldenPathName, GoldenFileName]);
catch
    fprintf('%s\n', lasterr);
    error('Golden trace data file open error');
end

while 1
    try
        SkipFlag = 0;
        NewData = get_dpsc_current_waveforms;
        tmp=NewData.Data(:,2);
        NewData.Data(:,2)=NewData.Data(:,3);
        NewData.Data(:,3)=tmp;
        DirData.date=now;
        [dummy,endind]    = max(NewData.Data(:,1));
        [dummy,endindold] = max(GoldData.Data(:,1));
    catch
        SkipFlag = 1;
        disp('File is currently busy ... skipping one file read cycle');
    end

    if ~SkipFlag

        if ((now-datenum(DirData.date))*24*60*60)>30
            soundtada;
            warningstr = sprintf('Data file %s has not been update in %g seconds. Need to start Labview app',[PathName,InputFile],(now-datenum(DirData.date))*24*60*60);
            warning(warningstr);
        end

        figure(11)
        subplot(2,1,1);
        plot(...
            125*10/10*GoldData.Data(1:endindold,1),60*10/10*GoldData.Data(1:endindold,2)./(125*10/10*GoldData.Data(1:endindold,1)),'c', ...
            125*10/10*GoldData.Data(1:endindold,1),60*GoldData.Data(1:endindold,3)./(125*10/10*GoldData.Data(1:endindold,1)),'m');
        hold on;
        plot(...
            NewData.Data(1:endind,1),NewData.Data(1:endind,2)./(NewData.Data(1:endind,1)),'b', ...
            NewData.Data(1:endind,1),NewData.Data(1:endind,3)./(NewData.Data(1:endind,1)),'r','LineWidth',1.5);
        plot([25 25],[0 1],'k','LineWidth',2);
        hold off;
        xlabel('I_{Bend} [A]');
        ylabel('I_{Quad}/I_{Bend}');
        title(datestr(DirData.date),'FontSize',16);
        axis(gca, [0 1000 0.45 0.6]);
        %axis(gca, [0 800 0.35 0.57]);
        
        subplot(2,1,2);
        plot(...
            125*10/10*GoldData.Data(1:endindold,1),60*10/10*GoldData.Data(1:endindold,2)./(125*10/10*GoldData.Data(1:endindold,1)),'c', ...
            125*10/10*GoldData.Data(1:endindold,1),60*GoldData.Data(1:endindold,3)./(125*10/10*GoldData.Data(1:endindold,1)),'m');
        hold on;
        %%axis(gca, [0 100 0.46 0.56]);
        axis(gca, [20 80 0.475 0.585]);
        plot(...
            NewData.Data(1:endind,1),NewData.Data(1:endind,2)./(NewData.Data(1:endind,1)),'b', ...
            NewData.Data(1:endind,1),NewData.Data(1:endind,3)./(NewData.Data(1:endind,1)),'r','LineWidth',1.5);
        plot([25 25],[0 1],'k','LineWidth',2);
        hold off;
        xlabel('I_{Bend} [A]');
        ylabel('I_{Quad}/I_{Bend}');
        legend('QD_{golden}','QF_{golden}','QD','QF','Location','EastOutside');
        
        if 1
            figure(12);
            subplot(2,2,1);
            plot(NewData.Timevec(1:endind),NewData.Data(1:endind,1),'g',(1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),'k')
            hold on;
            plot([0.014 0.014],[0 1050],'r','LineWidth',2);
            axis([0 0.5 0 1050])
            hold off;
            legend('BEND (present data)','BEND (golden)','Location','Best');
            ylabel('I [A]');
            xlabel('t [s]');
            
            subplot(2,2,2);
            plot(NewData.Timevec(1:endind),NewData.Data(1:endind,1),'g',(1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),'k')
            hold on;
            plot([0.014 0.014],[0 1000],'r','LineWidth',2);
            axis([0 0.01 5 10])
            hold off;
            legend('BEND (present data)','BEND (golden)','Location','Best');
            ylabel('I [A]');
            xlabel('t [s]');
            
            subplot(2,1,2)
            plot(NewData.Timevec(1:endind),(NewData.Data(1:endind,1)'-interp1((1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),NewData.Timevec(1:endind),'linear','extrap'))./interp1((1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),NewData.Timevec(1:endind),'linear','extrap'),'k');
            hold on
            plot([0.014 0.014],[-1 1],'r','LineWidth',2);
            hold off;
            legend('(present-gold)/gold','Location','Best');
            xlabel('t [s]');
            ylabel('\Delta I / I');
            axis(gca, [0 0.5 -0.02 0.02])
            drawnow
            
            
            figure(13)
            clf
            subplot(3,1,1)
            plot(NewData.Timevec(1:endind), (NewData.Data(1:endind,1)), 'g', NewData.Timevec(1:endind), NewData.Data(1:endind,2), 'b', NewData.Timevec(1:endind), NewData.Data(1:endind,3), 'r');
            hold on
            plot([0.014 0.014],[0 100],'k','LineWidth',2);
            hold off;
            xlabel('Time [Seconds]');
            legend('BEND', 'QD','QF');
            axis(gca, [0 .06 0 60]);
            
            subplot(3,1,2)
                plot(NewData.Timevec(1:endind), (NewData.Data(1:endind,1)- ...
                    interp1((1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),NewData.Timevec(1:endind),'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),NewData.Timevec(1:endind),'linear','extrap')', 'g', ...
                    NewData.Timevec(1:endind), (NewData.Data(1:endind,2)- ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),NewData.Timevec(1:endind),'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),NewData.Timevec(1:endind),'linear','extrap')', 'b', ...
                    NewData.Timevec(1:endind), (NewData.Data(1:endind,3)- ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),NewData.Timevec(1:endind),'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),NewData.Timevec(1:endind),'linear','extrap')','r');
                hold on;
                plot([0.014 0.014],[-1 1],'k','LineWidth',2);
                hold off
                axis(gca, [0 0.075 -0.04 0.04])
            xlabel('Time [Seconds]');
            ylabel('(I_{present}-I_{golden})/I_{golden}');
            legend('\Delta I / I_{BEND}', '\Delta I / I_{QD}','\Delta I / I_{QF}','Location','EastOutside');
            
            subplot(3,1,3)
                plot(NewData.Timevec(1:endind), (NewData.Data(1:endind,1)- ...
                    interp1((1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),NewData.Timevec(1:endind),'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),NewData.Timevec(1:endind),'linear','extrap')', 'g', ...
                    NewData.Timevec(1:endind), (NewData.Data(1:endind,2)- ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),NewData.Timevec(1:endind),'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),NewData.Timevec(1:endind),'linear','extrap')', 'b', ...
                    NewData.Timevec(1:endind), (NewData.Data(1:endind,3)- ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),NewData.Timevec(1:endind),'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),NewData.Timevec(1:endind),'linear','extrap')','r');
                hold on
                plot([0.014 0.014],[-1 1],'k','LineWidth',2);
                hold off
                axis(gca, [0 0.5 -0.04 0.04])
            %legend('\Delta_{BEND}', '\Delta{QD}','\Delta{QF}');
            xlabel('Time [Seconds]');
            ylabel('(I_{present}-I_{golden})/I_{golden}');
        end
    end
    
    drawnow
    pause(3);
end


function data = readdvmfile_local(FileName)

fid = fopen(FileName, 'r');
data.TimeStep = fscanf(fid, '%f', 1);
data.Line2    = fscanf(fid, '%f', 1);
data.Data     = fscanf(fid, '%f %f %f', [3 inf])';
fclose(fid);

