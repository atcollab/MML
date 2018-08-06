% sysinv BW 100
% Zero the error for a longer
% Adjust the first point

if 1
    clear
    %FileName = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_current/RampTableQD.txt';
    FileName = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_current/RampTableQD.txt';
    %FileName = 'BEND_QF_QD.txt';
    
    % Input
    fid = fopen(FileName, 'r');
    if fid == -1
        fprintf('  File open error.\n');
        return;
    end
    
    T = fscanf(fid, '%f\n', 1);
    N = fscanf(fid, '%f\n', 1);
    Data = fscanf(fid, '%f %f %f', [3 inf]);
    fclose(fid);

    Data = Data';

    QF   =  60 * Data(:,1);  %  60->New Quad, 48->Old Quad
    QD   =  60 * Data(:,2);  %  60->New Quad, 48->Old Quad
    BEND = 125 * Data(:,3);  % 125->New BEND, 80->Old BEND


    % Filter the BEND
    [b,a] = fir1(5,.1);
    BEND = filtfilt(b, a, BEND);


    fs = 1/T;
    t = (0:(length(QF)-1))' / fs;


    % Goal
    QFratio = QF./BEND - .520;
    QFratio0 = QFratio;
    
    % Zero the error until the system can be controlled (old bend)
    i = find(t < .04);
    QFratio(i) = 0;

    % Power supply TF
    w = 2 * pi * 7.8;
    sys = tf(1,[1/w 1]);
    %bode(H)

    % The inverse system
    Fc = 2 * pi * 100;      % High frequency poles for the compensation (avoid phase delay!!!)
    sysinv = tf([1/w 1], conv([1/Fc 1],[1/Fc 1]));


    ComputeDelay = 1;
    Fig1 = 1;
else
    Fig1 = 2;
    ComputeDelay = 0;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compensation Transfer Function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1 %ComputeDelay

    % Wait a time constant or 2 before computing the RMS
    Nrms = min(find(t>=3/w));

    %dT = 0:.001:.1;
    dT = 0:.0002:1./w;
    for i = 1:length(dT)
        
        QFratioErr = -QFratio;
        N = min(find(t>=dT(i)));
        QFratioErr = [QFratioErr(N:end); zeros(N-1,1)];

        %QFratioErr = -QFratio;
        [QFratioErr, tinv, xinv] = lsim(sysinv, QFratioErr, t);
        

        % Power supply output
        [QFout,t1] = lsim(sys, QFratioErr, t);
        %[QFout2,t1] = lsim(sys, QFratioErr2, t);

        %[b,a] = fir1(20, .1);
        %QFcommand = filtfilt(b, a, QFcommand);


        RMSError(i) = std(QFratio(Nrms:end)+QFout(Nrms:end));
        MaxError(i) = max(abs(QFratio(Nrms:end)+QFout(Nrms:end)));
    end

    figure(10);
    clf reset
    subplot(2,1,1);
    plot(dT, RMSError,'.-');
    subplot(2,1,2);
    plot(dT, MaxError,'.-');

end


% Best case
[RMSmin, dTi] = min(RMSError);
fprintf('   Delay in the input by %f seconds (Tc=%f).\n', dT(dTi), 1/w);

%Gain = .5;

QFratioErr = -QFratio;
N = min(find(t>=dT(dTi)));
N1 = min(find(t>=.01));
if N > N1
    N = N1
end
QFratioErr = [QFratioErr(N:end); zeros(N-1,1)];
QFratioErr = -QFratio;

[QFratioErr, tinv, xinv] = lsim(sysinv, QFratioErr, t);
QFratioErr_old = QFratioErr;

% Filter the command
[b,a] = fir1(50,.005);
%freqz(b,a,4096,4000)
QFratioErr = filtfilt(b, a, QFratioErr);

[QFout,t1] = lsim(sys, QFratioErr, t);


figure(Fig1);
clf reset
plot(t1, [QFratio(:) QFout(:) QFratioErr(:) QFratioErr_old(:) QFratio+QFout(:)]);
hold on
plot(t1, QFratio0,'b');
hold off

QFratio = QFratio + QFout(:);
