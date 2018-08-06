%% Get data

clear

PlotData = 0;
Npts = 26000;
tmon = (0:131071)/97656.25;
TimeString = 'yyyy-mm-dd HH:MM:SS.FFF';

WaveCounterLast = getpvonline('ztec13:Inp1WaveCount');
for j = 1:100000
    SaveFlag = 0;
    
    [Iref, ~, IrefTs] = getpvonline('BR1:QD:RAMPSET', 0, 'int32');
    IrefTs = labca2datenum(IrefTs);
    fprintf(' Iref %s\n', datestr(IrefTs,TimeString));
    
    for i = 1:50
        % Wait for a new trace
        WaveCounterStart(i,1) = getpvonline('ztec13:Inp1WaveCount');
        while getpvonline('ztec13:Inp1WaveCount') <= WaveCounterLast
            pause(.1);
        end
        
        % This might be enough for the DPSC to write it's waverforms
        % Note: .5 seconds will occassionally miss a BR cycle
        %pause(.25);
        
        WaveCounter(i,1) = getpvonline('ztec13:Inp1WaveCount');
        WaveCounterLast = WaveCounter(i,1);
        
        tic
        tlocal(i,1) = now;
        %[QDwave, ~, QDTs] = getpvonline('BR1:QD:RAMPI_COND', 0, 'int32');
        [Imon(i,:), ~, ImonTs(i,1)] = getpvonline('BR1:QD:RAMPI', 0, 'int32');
        
        [t(i,:),    ~, tTs(i,1)]    = getpvonline('ztec13:InpScaledTime',  'double', Npts);
        [Vout(i,:), ~, VoutTs(i,1)] = getpvonline('ztec13:Inp1ScaledWave', 'double', Npts);
        [Iext(i,:), ~, IextTs(i,1)] = getpvonline('ztec13:Inp2ScaledWave', 'double', Npts);
        [VDEM(i,:), ~, VDEMTs(i,1)] = getpvonline('ztec13:Inp3ScaledWave', 'double', Npts);
        [Iint(i,:), ~, IintTs(i,1)] = getpvonline('ztec13:Inp4ScaledWave', 'double', Npts);
        toc
        
        %Imon = 60*(Imon*10/2^23)*1.228+9.25;
        %Iref = 60*(Iref*10/2^23)*1.228+9.25;
        
        ImonTs(i,1) = labca2datenum(ImonTs(i,1));
        VoutTs(i,1) = labca2datenum(VoutTs(i,1));
        IextTs(i,1) = labca2datenum(IextTs(i,1));
        VDEMTs(i,1) = labca2datenum(VDEMTs(i,1));
        IintTs(i,1) = labca2datenum(IintTs(i,1));
               
        fprintf(' Imon %s\n', datestr(ImonTs(i,1),TimeString));
        fprintf(' Vout %s\n', datestr(VoutTs(i,1),TimeString));
        fprintf(' Iext %s\n', datestr(IextTs(i,1),TimeString));
        fprintf(' VDEM %s\n', datestr(VDEMTs(i,1),TimeString));
        fprintf(' Iint %s\n', datestr(IintTs(i,1),TimeString));
          
        if PlotData
            figure(1);
            clf reset

            h = subplot(2,1,1);
            plot(tmon, [Imon(i,:); Iref]/1e6);
            hold on
            plot(t(i,:), -1*Iext(i,:), 'r');
            plot(t(i,:),    Iint(i,:), 'k');
            hold off
            
            legend('Imon','Iref','Ioutext','Ioutinternal');
            
            h(2) = subplot(2,1,2);
            plot(t(i,:), Vout(i,:), 'b');
            hold on
            plot(t(i,:), 3*VDEM(i,:), 'g');
            hold off
            
            legend('Vout','VDEM');
            linkaxes(h, 'x');
        end   
        
        fprintf(' min(Iint)=%f\n',min(Iint(i,:)))
        %Test = 60*(Imon(i,:)*10/2^23)*1.228+9.25;
        %if any(Test<-5)
        if any(Iint<-0.5)
            SaveFlag = 1;
        end
    end
    
    if SaveFlag
        filestr=sprintf('BR_QD_Ramp_Set_%s',datestr(now,30));
        fprintf('\n   File save %s\n', filestr);
        tic
        save(filestr);
        toc
    end
    
    fprintf('\n\n');
    
end
return


%%


i = 0;

%%
i = i + 1;
figure(i);
clf reset

h = subplot(2,1,1);
plot(tmon, [Imon(i,:); Iref]/1e6);
hold on
plot(t(i,:), -1*Iext(i,:), 'r');
plot(t(i,:),    Iint(i,:), 'k');
hold off

legend('Imon','Iref','Ioutext','Ioutinternal');

h(2) = subplot(2,1,2);
plot(t(i,:), Vout(i,:), 'b');
hold on
plot(t(i,:), 3*VDEM(i,:), 'g');
hold off

legend('Vout','VDEM');

linkaxes(h, 'x');




%%

