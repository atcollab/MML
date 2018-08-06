function setskewq
%  setskewq
%  This function set the skew quardrupoles and corrects the orbit.
%  Note:  The BPMs must be calibrated for this program to work.


fprintf('   This program sets skew quadrupoles with orbit correction.\n');
%fprintf('  SQSF1 is presently %.3f amps.\n', getsp('SQSF',1));
%fprintf('  SQSF2 is presently %.3f amps.\n', getsp('SQSF',2));
%fprintf('  SQSD1 is presently %.3f amps.\n', getsp('SQSD',1));
fprintf('   SQSD2 is presently %.3f amps.\n', getsp('SQSD',[1 2]));


% Which BPMs to use
ButtonName = questdlg('Use all BPMs or only Bergoz style BPMs?','SETSKEWQ','All','Bergoz','Bergoz');
switch ButtonName,
    case 'All'
        BPMDevList = getbpmlist;
    case 'Bergoz'
        BPMDevList = getbpmlist('Bergoz');
    otherwise
        fprintf('   No changes to the lattice made.\n');
        return
end

BPMs = getspos('BPMx', BPMDevList);



%SQnumber = menu('Which Skew Quadrupole?','         SQSF1         ','         SQSF2         ','         SQSD1         ','         SQSD2         ');
SQnumber = 1;

%if SQnumber == 1
%   Quad0 = getsp('SQSF', 1);
%   titlestr=sprintf('SQSF1 is presently at %.3f amps', Quad0);
%elseif SQnumber == 2
%   Quad0 = getsp('SQSF', 2);
%   titlestr=sprintf('SQSF2 is presently at %.3f amps', Quad0);
%elseif SQnumber == 3
%   Quad0 = getsp('SQSD', 1);
%   titlestr=sprintf('SQSD1 is presently at %.3f amps', Quad0);
%elseif SQnumber == 4
%   Quad0 = getsp('SQSD', 2);
%   titlestr=sprintf('SQSD2 is presently at %.3f amps', Quad0);
%end
if SQnumber == 1
    Quad0 = getsp('SQSD', [1 2]);
    titlestr = sprintf('SQSD(1,2) is presently at %.3f amps', Quad0);
end

prompt={'Enter the new skew quadrupole current'};
def={num2str(Quad0)};
lineNo=1;
answer=inputdlg(prompt,titlestr,lineNo,def);
if isempty(answer)
    fprintf('   No changes to the lattice made.\n');
    return
end
QuadNew = str2num(answer{1});
if isempty(QuadNew)
    fprintf('   No changes to the lattice made.\n');
    return
end
if QuadNew == Quad0
    fprintf('   The desired setpoint is the same as the present setpoint,\n');
    fprintf('   hence, no change has been made to the lattice.\n');
    return
end


% Starting orbit
x0 = getx(BPMDevList);
y0 = gety(BPMDevList);


% Set the skew quadrupole
%if SQnumber == 1
%   setsp('SQSF', QuadNew, [1 1], -2);
%   fprintf('  SQSF1: Correcting the orbit using HCM #4 and VCM #4 in each sector.'\n);
%   HCMDevList = getcmlist('HCM', '4');                  % Corrector magnet list
%   VCMDevList = getcmlist('VCM', '4');                  % Corrector magnet list
%elseif SQnumber == 2
%   setsp('SQSF', QuadNew, [1 2], -2);
%   fprintf('  SQSF2: Correcting the orbit using HCM #5 and VCM #5 in each sector.'\n);
%   HCMDevList = getcmlist('HCM', '5');                  % Corrector magnet list
%   VCMDevList = getcmlist('VCM', '5');                  % Corrector magnet list
%elseif SQnumber == 3
%   setsp('SQSD', QuadNew, [1 1], -2);
%   fprintf('  SQSD1: Correcting the orbit using HCM #3 and VCM #2 in each sector.'\n);
%   HCMDevList = getcmlist('HCM', '3');                  % Corrector magnet list
%   VCMDevList = getcmlist('VCM', '2');                  % Corrector magnet list
%elseif SQnumber == 4
%   setsp('SQSD', QuadNew, [1 2], -2);
%   fprintf('  SQSD2: Correcting the orbit using HCM #6 and VCM #7 in each sector.'\n);
%   HCMDevList = getcmlist('HCM', '6');                  % Corrector magnet list
%   VCMDevList = getcmlist('VCM', '7');                  % Corrector magnet list
%end
if SQnumber == 1
    setsp('SQSD', QuadNew, [1 2], -2);
    fprintf('   SQSD(1,2): Correcting the orbit using HCM #6 and VCM #7 in each sector.\n');
    HCMDevList = getcmlist('HCM', '6');                  % Corrector magnet list
    VCMDevList = getcmlist('VCM', '7');                  % Corrector magnet list
end


x1 = getx(BPMDevList);
y1 = gety(BPMDevList);


% Setup figures
Fig1 = gcf;
%Buffer = .03;
%HeightBuffer = .07;
%set(Fig1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);


figure(Fig1);
clf reset
subplot(2,1,1);
plot(BPMs, x1-x0,'b');
ylabel('Horizontal [mm]');
title('Skew Quad Change (blue)');
hold on

subplot(2,1,2);
plot(BPMs, y1-y0,'b');
ylabel('Vertical [mm]');
xlabel('BPM Position')
hold on



% SVD orbit correction
ivec = [1:12]; %input('     E-vector numbers ([1 2 3 etc]) = ');
fprintf('   Using %d BPMs and %d singular vectors.\n', size(BPMDevList,1), length(ivec));

% Response matrix
Ax = getrespmat('BPMx', BPMDevList, 'HCM', HCMDevList);
Ay = getrespmat('BPMy', BPMDevList, 'VCM', VCMDevList);

HCMsp0 = getsp('HCM', HCMDevList);
VCMsp0 = getsp('VCM', VCMDevList);

for i = 1:3
    % Orbt correction: In the model it works better to correct the
    %                  vertical orbit first
    
    % Compute vertical correction
    [U,S,V] = svd(Ay);
    A = Ay * V(:,ivec);
    b = inv(A'*A)*A' * (y0-gety(BPMDevList));
    Y = V(:,ivec) * b;                     % corrector strengths
    stepsp('VCM', Y, VCMDevList, -2);
    VCMsp1 = getsp('VCM', VCMDevList);
    pause(0);
    sleep(.5);

    % Compute horizontal correction
    [U,S,V] = svd(Ax);
    A = Ax * V(:,ivec);
    b = inv(A'*A)*A' * (x0-getx(BPMDevList));
    X = V(:,ivec) * b;                     % corrector strengths
    stepsp('HCM', X, HCMDevList, -2);
    HCMsp1 = getsp('HCM', HCMDevList);
    pause(0);


    figure(Fig1);
    x2 = getx(BPMDevList);
    y2 = gety(BPMDevList);
    subplot(2,1,1);
    plot(BPMs, x2-x0, 'g');
    ylabel('Delta BPMx [mm]');
    title('After Skew Quad Change (blue), Correction 1 & 2 (grn)');

    subplot(2,1,2);
    plot(BPMs, y2-y0, 'g');
    ylabel('Delta BPMy [mm]');
    xlabel('BPM Position [meters]')
end


figure(Fig1);
subplot(2,1,1);
plot(BPMs, x2-x0,'r');
ylabel('Delta BPMx [mm]');
title('After Skew Quad Change (blue), Correction 1 & 2 (grn), Correction 3 (red)');
hold off

subplot(2,1,2);
plot(BPMs, y2-y0,'r');
ylabel('Delta BPMy [mm]');
xlabel('BPM Position [meters]')
hold off


% Reset?
ButtonName = questdlg('Keep Skew Quad Setting and Orbit Correction or Reset?','SETSKEWQ','Keep','Reset','Keep');
switch ButtonName,
    case 'Reset'
        setsp('SQSD', Quad0, [1 2], -2);
        setsp('HCM', HCMsp0, HCMDevList, -2);
        setsp('VCM', VCMsp0, VCMDevList, -2);
        fprintf('   Final analog monitor for SQSD(1,2) is %.3f amps.\n', getam('SQSD',[1 2]));
        fprintf('   Setskew and correctors reset.\n');
    otherwise
        fprintf('   Final analog monitor for SQSD(1,2) is %.3f amps.\n', getam('SQSD',[1 2]));
        fprintf('   Setskewq complete.\n');
end

