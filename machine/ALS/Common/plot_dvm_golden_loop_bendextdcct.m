function plot_dvm_golden_loop(InputFile)
% plot_dvm_golden_loop('InputFile')


% '/home/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070119/coordinated_ramp_B_QF_QD_20070119_4kHz_1.txt'
% '/home/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070129/new_Bend_profile_with_quads_6.txt'
% '/home/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070612/BENDandQF_analog_QD_new_controller_4kHz_51.txt'
% '/home/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070618/QD-digital_BendQF-analog_45.txt'
% '/home/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070702/BQFQD_1.txt'
% '/home/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070707/BQFQD_24.txt'
% '../BR_B_noise_after_DCCTmoves_20070813/B_DCCTmoved_externalDCCT_8000Hz_1.txt'
% '../BQFQD_ramping_20071014/QD-digital_BendQF-analog_2.txt'
% 'BR_BQFQD_golden_20081106.txt'
% 'BQFQD_20071210_1.txt'
% 'BR_BQFQD_ref_20081103.txt'


if nargin<1
    %InputFile = 'BQFQD_golden_2008106.txt';
    InputFile = 'BR_BQFQD_last_shot.txt';
end

if ispc
    %PathName = 'm:\matlab\srdata\powersupplies\';
    PathName = '\\Als-filer\physdata\matlab\srdata\powersupplies\BQFQD_ramping_20071031\';
else
    % PathName = '/home/physdata/matlab/srdata/powersupplies/';
    PathName = '/home/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20071031/';
end


GoldenFileName = 'BR_BQFQD_20091120.txt';     % updated on 11-20-09 for different tuning after Christoph retuned 11-18 for better multibunch capture in BR - T.Scarvie
% GoldenFileName = 'BR_BQFQD_after_retuning_QD_20090824.txt';     % updated on August 24, after reyuning QD (larger offset curren) - hopefully reducing frequency of QD 'jumps' - C. Steier
% GoldenFileName = 'BR_BQFQD_golden_after_bend_jump_20090818.txt';     % updated on August 18, after recovering from one more step change in booster bend magnet supply - C. Steier
% GoldenFileName = 'BR_BQFQD_ramping_20090714.txt';  %updated July 14, 2009, after recovering from booster tuning problems that started after July 4th shutdown - C. Steier
% GoldenFileName = 'BQFQD_ramping_20090331.txt';  %updated 3-31-09 with data taken during 9am fill - T.Scarvie
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

Golden2FileName = 'BR_B_external_DCCT_before_conversion_20101015.txt';     

if ispc
    Golden2PathName = '\\Als-filer\physdata\matlab\srdata\powersupplies\BR_B_ramping_20101025\';
else
    Golden2PathName = '/home/physdata/matlab/srdata/powersupplies/BR_B_ramping_20101025/';
end

try
    GoldData2 = readdvmfile_local([Golden2PathName, Golden2FileName]);
catch
    fprintf('%s\n', lasterr);
    error('Golden trace data file open error');
end

% For testing
%PathName  = GoldenPathName
%InputFile = GoldenFileName


while 1
    try
        SkipFlag = 0;
        NewData = readdvmfile_local([PathName,InputFile]);
        DirData = dir([PathName,InputFile]);
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
            125*10/10*NewData.Data(1:endind,1),60*10/10*NewData.Data(1:endind,2)./(125*10/10*NewData.Data(1:endind,1)),'b', ...
            125*10/10*NewData.Data(1:endind,1),60*NewData.Data(1:endind,3)./(125*10/10*NewData.Data(1:endind,1)),'r','LineWidth',1.5);
        plot([25 25],[0 1],'k','LineWidth',2);
        hold off;
        xlabel('I_{Bend} [A]');
        ylabel('I_{Quad}/I_{Bend}');
        title(DirData.date,'FontSize',16);
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
            125*10/10*NewData.Data(1:endind,1),60*10/10*NewData.Data(1:endind,2)./(125*10/10*NewData.Data(1:endind,1)),'b', ...
            125*10/10*NewData.Data(1:endind,1),60*NewData.Data(1:endind,3)./(125*10/10*NewData.Data(1:endind,1)),'r','LineWidth',1.5);
        plot([25 25],[0 1],'k','LineWidth',2);
        hold off;
        xlabel('I_{Bend} [A]');
        ylabel('I_{Quad}/I_{Bend}');
        legend('QD_{golden}','QF_{golden}','QD','QF','Location','EastOutside');
        
        if 1
            figure(12);
            subplot(2,2,1);
            plot((1:endind)*NewData.TimeStep,125*10/10*NewData.Data(1:endind,1),'g',(1:endindold)*GoldData2.TimeStep,125*10/10*GoldData2.Data(1:endindold,1),'k')
            hold on;
            plot([0.014 0.014],[0 1050],'r','LineWidth',2);
            axis([0 0.5 0 1050])
            hold off;
            legend('BEND (present data)','BEND (golden)','Location','Best');
            ylabel('I [A]');
            xlabel('t [s]');
            
            subplot(2,2,2);
            plot((1:endind)*NewData.TimeStep,125*10/10*NewData.Data(1:endind,1),'g',(1:endindold)*GoldData2.TimeStep,125*10/10*GoldData2.Data(1:endindold,1),'k')
            hold on;
            plot([0.014 0.014],[0 1000],'r','LineWidth',2);
            axis([0 0.01 5 10])
            hold off;
            legend('BEND (present data)','BEND (golden)','Location','Best');
            ylabel('I [A]');
            xlabel('t [s]');
            
            subplot(2,1,2)
            if (NewData.TimeStep == GoldData2.TimeStep)
                plot((1:endind)*NewData.TimeStep,(125*10/10*NewData.Data(1:endind,1)-125*10/10*GoldData2.Data(1:endind,1))./(125*10/10*GoldData2.Data(1:endind,1)),'k');
            else
                plot((1:endind)*NewData.TimeStep,(125*10/10*NewData.Data(1:endind,1)'-interp1((1:endindold)*GoldData2.TimeStep,125*10/10*GoldData2.Data(1:endindold,1),(1:endind)*NewData.TimeStep,'linear','extrap'))./interp1((1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),(1:endind)*NewData.TimeStep,'linear','extrap'),'k');
            end
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
            plot((1:endind)*NewData.TimeStep, (125*10/10*NewData.Data(1:endind,1)), 'g', (1:endind)*NewData.TimeStep, 60*10/10*NewData.Data(1:endind,2), 'b', (1:endind)*NewData.TimeStep, 60*NewData.Data(1:endind,3), 'r');
            hold on
            plot([0.014 0.014],[0 100],'k','LineWidth',2);
            hold off;
            xlabel('Time [Seconds]');
            legend('BEND', 'QD','QF');
            axis(gca, [0 .06 0 60]);
            
            subplot(3,1,2)
            if (NewData.TimeStep == GoldData.TimeStep)
                plot((1:endind)*NewData.TimeStep, ((125*10/10*NewData.Data(1:endind,1))-125*10/10*GoldData.Data(1:endind,1))./(125*10/10*GoldData.Data(1:endind,1)), 'g', (1:endind)*NewData.TimeStep, (60*10/10*NewData.Data(1:endind,2)-60*10/10*GoldData.Data(1:endind,2))./(60*10/10*GoldData.Data(1:endind,2)), 'b', (1:endind)*NewData.TimeStep, (60*NewData.Data(1:endind,3)-60*10/10*GoldData.Data(1:endind,3))./(60*10/10*GoldData.Data(1:endind,3)),'r');
                hold on
                plot([0.014 0.014],[-1 1],'k','LineWidth',2);
                hold off
                axis(gca, [0 0.075 -0.04 0.04])
            else
                plot((1:endind)*NewData.TimeStep, (125*10/10*NewData.Data(1:endind,1)- ...
                    interp1((1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),(1:endind)*NewData.TimeStep,'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),(1:endind)*NewData.TimeStep,'linear','extrap')', 'g', ...
                    (1:endind)*NewData.TimeStep, (60*10/10*NewData.Data(1:endind,2)- ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),(1:endind)*NewData.TimeStep,'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),(1:endind)*NewData.TimeStep,'linear','extrap')', 'b', ...
                    (1:endind)*NewData.TimeStep, (60*NewData.Data(1:endind,3)- ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),(1:endind)*NewData.TimeStep,'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),(1:endind)*NewData.TimeStep,'linear','extrap')','r');
                hold on;
                plot([0.014 0.014],[-1 1],'k','LineWidth',2);
                hold off
                axis(gca, [0 0.075 -0.04 0.04])
            end
            xlabel('Time [Seconds]');
            ylabel('(I_{present}-I_{golden})/I_{golden}');
            legend('\Delta I / I_{BEND}', '\Delta I / I_{QD}','\Delta I / I_{QF}','Location','EastOutside');
            
            subplot(3,1,3)
            if (NewData.TimeStep == GoldData.TimeStep)
                plot((1:endind)*NewData.TimeStep, ((125*10/10*NewData.Data(1:endind,1))-125*10/10*GoldData.Data(1:endind,1))./(125*10/10*GoldData.Data(1:endind,1)), 'g', (1:endind)*NewData.TimeStep, (60*10/10*NewData.Data(1:endind,2)-60*10/10*GoldData.Data(1:endind,2))./(60*10/10*GoldData.Data(1:endind,2)), 'b', (1:endind)*NewData.TimeStep, (60*NewData.Data(1:endind,3)-60*10/10*GoldData.Data(1:endind,3))./(60*10/10*GoldData.Data(1:endind,3)),'r');
                hold on
                plot([0.014 0.014],[-1 1],'k','LineWidth',2);
                hold off
                axis(gca, [0 0.5 -0.04 0.04])
            else
                plot((1:endind)*NewData.TimeStep, (125*10/10*NewData.Data(1:endind,1)- ...
                    interp1((1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),(1:endind)*NewData.TimeStep,'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),(1:endind)*NewData.TimeStep,'linear','extrap')', 'g', ...
                    (1:endind)*NewData.TimeStep, (60*10/10*NewData.Data(1:endind,2)- ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),(1:endind)*NewData.TimeStep,'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),(1:endind)*NewData.TimeStep,'linear','extrap')', 'b', ...
                    (1:endind)*NewData.TimeStep, (60*NewData.Data(1:endind,3)- ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),(1:endind)*NewData.TimeStep,'linear','extrap')')./ ...
                    interp1((1:endindold)*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),(1:endind)*NewData.TimeStep,'linear','extrap')','r');
                hold on
                plot([0.014 0.014],[-1 1],'k','LineWidth',2);
                hold off
                axis(gca, [0 0.5 -0.04 0.04])
            end
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

