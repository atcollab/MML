function meascentralfrequency
%MEASCENTRALFREQUENCY - Measures central frequency using sextupole (chromaticites)

%
% Written by Laurent S. Nadolski

DisplayFlag = 1;
t0 = clock;
stepxi = 1;
stepfreq = 100e-6;

kn = 3;
tune1 = zeros(2,2*kn+1);
tune2 = zeros(2,2*kn+1);
tune3 = zeros(2,2*kn+1);
tune4 = zeros(2,2*kn+1);

stepchro([0 -1.5], 'Physics');
disp('step1 for chro');
tune1 = local_steprf(kn,stepfreq);
stepchro([0.5 1.5], 'Physics');
disp('step2 for chro');
tune2 = local_steprf(kn,stepfreq);
stepchro([1.0 1.5], 'Physics');
disp('step3 for chro');
tune3 = local_steprf(kn,stepfreq);
stepchro([1.5 -2.5], 'Physics');
disp('step4 for chro');

tune4 = local_steprf(kn,stepfreq);
stepchro([-3 0], 'Physics');

fprintf('Measurement duration %f s\n',etime(clock,t0))

%if DisplayFlag
    figure
    subplot(2,1,1)
    rfv = (-kn*stepfreq:stepfreq:kn*stepfreq)*1e6;
    plot(rfv,tune1(1,:),'b.-')
    hold on
    plot(rfv,tune2(1,:),'b.-')
    plot(rfv,tune3(1,:),'b.-')
    plot(rfv,tune4(1,:),'b.-')
    grid on
    ylabel('nux')
    subplot(2,1,2)
    plot(rfv,tune1(2,:),'r.-')
    hold on
    plot(rfv,tune2(2,:),'r.-')
    plot(rfv,tune3(2,:),'r.-')
    plot(rfv,tune4(2,:),'r.-')
    grid on
    ylabel('nuz')
    xlabel('RF Frequency (Hz)')
%end

function tune = local_steprf(kn,stepfreq)

stepfreq = 100e-6;

for k = 1:kn,
    steprf(-stepfreq);
    pause(2);
end

for k = 1:(2*kn+1),
    %stepchro([0, stepxi*k],'Physics')
    pause(4);
    tune(:,k) = gettune;    
    steprf(stepfreq);
end

for k = 1:(kn+1),
    steprf(-stepfreq);
    pause(2);
end

