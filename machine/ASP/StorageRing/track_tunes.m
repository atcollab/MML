function track_tunes(current_tunes,fixtunes2,varargin)
% track_tunes([curr_tunes curr_disp],[want_tunes want_disp],[calc_J,'increment'])
%
% Example: track_tunes([0.31 0.24 0.1],[0.290 0.216 0.1])
%          track_tunes([0.31 0.24 0.1],[0.290 0.216 0.1],1,'increment');
%
% The value calc_J asks track_tunes to calculate the jacobian from the
% loaded model. Default is to calculate.

calc_from_model = 1;
increment = 0;
if nargin > 3 && ischar(varargin{2}) && strcmpi(varargin{2},'increment')
    increment = 1;
end
if nargin > 2 && isnumeric(varargin{1})
    calc_from_model = varargin{1};
end

if length(current_tunes) ~= 3 && length(fixtunes2) ~= 3
    error('TRACK_TUNES requires 3 values [xtune ytune disp]');
end

% xtune_pv = 'CR01:GENERAL_ANALOG_02_MONITOR';
% xtune_handle = mcacheckopen(xtune_pv);
% ytune_pv = 'CR01:GENERAL_ANALOG_03_MONITOR';
% ytune_handle = mcacheckopen(ytune_pv);
% if xtune_handle == 0
%     error('Cant open channel to xtune');
% end
% if ytune_handle == 0
%     error('Cant open channel to xtune');
% end


% fixtunes2 = [0.29 0.216 0];
%  current_tunes = [mcaget(xtune_handle) mcaget(ytune_handle) 0];
% current_tunes = [0.2913 0.2145 0.00];
% current_tunes = [getam('TUNE')' 0];
delta_nu = fixtunes2(1:2) - current_tunes(1:2);
delta_nu(3) = fixtunes2(3) - current_tunes(3);

% fprintf('\n Current fractional tunes are: [%6.3f %6.3f] dispersion = %6.7f\n', current_tunes);
% fprintf(' Delta fractional tunes are: [%6.3f %6.3f]  dispersion = %6.7f\n', delta_nu);

if calc_from_model
    global THERING;
    delta = 1e-6;
    quadfam1 = 'QFA';
    quadfam2 = 'QDA';
    quadfam3 = 'QFB';
    % Fit the model
    fittunedisp2(current_tunes+[13 5 0],'QFA','QDA','QFB',1)
    
    % find indexes of the 2 quadrupole families use for fitting
    Q1I = findcells(THERING,'FamName',quadfam1);
    if isempty(Q1I); fprintf('Cannot find quadfamily: %s\n',quadfam1); return; end;
    Q2I = findcells(THERING,'FamName',quadfam2);
    if isempty(Q2I); fprintf('Cannot find quadfamily: %s\n',quadfam2); return; end;
    Q3I = findcells(THERING,'FamName',quadfam3);
    if isempty(Q3I); fprintf('Cannot find quadfamily: %s\n',quadfam3); return; end;


    InitialK1 = getcellstruct(THERING,'K',Q1I);
    InitialK2 = getcellstruct(THERING,'K',Q2I);
    InitialK3 = getcellstruct(THERING,'K',Q3I);
    InitialPolB1 = getcellstruct(THERING,'PolynomB',Q1I,2);
    InitialPolB2 = getcellstruct(THERING,'PolynomB',Q2I,2);
    InitialPolB3 = getcellstruct(THERING,'PolynomB',Q3I,2);

    % Compute initial tunes before fitting
    % [ LD, InitialTunes] = linopt(THERING,0);
    mach = machine_at;
    TempTunes = [mach.nux(end);mach.nuy(end)];
    TempDisp  = mach.etax(1);
    TempK1 = InitialK1;
    TempK2 = InitialK2;
    TempK3 = InitialK3;
    TempPolB1 = InitialPolB1;
    TempPolB2 = InitialPolB2;
    TempPolB3 = InitialPolB3;

    disp('Calculating Jacobian from current model');
    fprintf('Tunes and Dispersion: %14.10f (H) %14.10f (V) %14.10f (D)\n',...
        TempTunes(1),TempTunes(2),TempDisp);

    % Take Derivative
    THERING = setcellstruct(THERING,'K',Q1I,TempK1+delta);
    THERING = setcellstruct(THERING,'PolynomB',Q1I,TempPolB1+delta,2);
    mach = machine_at;
    Tunes_dK1 = [mach.nux(end);mach.nuy(end)];
    Disp_dK1 = mach.etax(1);
    THERING = setcellstruct(THERING,'K',Q1I,TempK1);
    THERING = setcellstruct(THERING,'PolynomB',Q1I,TempPolB1,2);

    THERING = setcellstruct(THERING,'K',Q2I,TempK2+delta);
    THERING = setcellstruct(THERING,'PolynomB',Q2I,TempPolB2+delta,2);
    mach = machine_at;
    Tunes_dK2 = [mach.nux(end);mach.nuy(end)];
    Disp_dK2 = mach.etax(1);
    THERING = setcellstruct(THERING,'K',Q2I,TempK2);
    THERING = setcellstruct(THERING,'PolynomB',Q2I,TempPolB2,2);

    THERING = setcellstruct(THERING,'K',Q3I,TempK3+delta);
    THERING = setcellstruct(THERING,'PolynomB',Q3I,TempPolB3+delta,2);
    mach = machine_at;
    Tunes_dK3 = [mach.nux(end);mach.nuy(end)];
    Disp_dK3 = mach.etax(1);
    THERING = setcellstruct(THERING,'K',Q3I,TempK3);
    THERING = setcellstruct(THERING,'PolynomB',Q3I,TempPolB3,2);


    %Construct the Jacobian
    change_dK = zeros(3);
    tempTunesDisp = zeros(3);

    change_dK(:,1) = [Tunes_dK1(1); Tunes_dK1(2); Disp_dK1];
    change_dK(:,2) = [Tunes_dK2(1); Tunes_dK2(2); Disp_dK2];
    change_dK(:,3) = [Tunes_dK3(1); Tunes_dK3(2); Disp_dK3];
    tempTunesDisp(:,1) = [TempTunes(1); TempTunes(2); TempDisp];
    tempTunesDisp(:,2) = [TempTunes(1); TempTunes(2); TempDisp];
    tempTunesDisp(:,3) = [TempTunes(1); TempTunes(2); TempDisp];


    J = (change_dK - tempTunesDisp)/delta;
    Jinv = inv(J);
    initk = [InitialK1(1) InitialK2(1) InitialK3(1)]';
else
    % Inverse Jacobian measured using the model.
    Jinv = [...
        0.130094898781898,0.000379003570963,0.100529311940219;...
        -0.105532343683691,-0.139777190998969,-0.004112213885454;...
        0.022078330803986,0.029242080859334,-0.054916466546098;];
    % Order QFA QDA QFB
    initk = [1.7619022 -1.0859714 1.5444376]';
    
    % -0.75 dispersion (9ps)
    % Jinv = [...
    %    0.220177508545285   0.000615853133914   0.062397330857094
    %   -0.083404182378964  -0.148030962548666   0.002243208844560
    %   -0.059742956049518   0.030032260554950  -0.041325062084519];
    % % % Order QFA QDA QFB
    % initk = [1.701360482635349  -1.072306322947120   1.576013680632028]';
end

% Fit the tunes but don't change the dispersion, therefore the last element
% is zero.
deltak = Jinv*[delta_nu]';

percentage_change = deltak./initk

% Read current setpoints
currentquads = [];
currentquads(:,1) = getsp('QFA','Hardware');
currentquads(:,2) = getsp('QDA','Hardware');
currentquads(:,3) = getsp('QFB','Hardware');

% Calculate percentage changes
deltacurrentquads(:,1) = percentage_change(1).*currentquads(:,1);
deltacurrentquads(:,2) = percentage_change(2).*currentquads(:,2);
deltacurrentquads(:,3) = percentage_change(3).*currentquads(:,3);

if max(percentage_change) > 0.05
    % If greater than 5% change then ask for confirmation
    switch questdlg('Change in quads > 5%%. Will force increment. Are you sure?','Tune Tracking Question',...
                'Yes','No','Yes');
        case 'Yes'
            increment = 1;
        case 'No'
            disp('No changes made. goodbye');
            return
    end
end
% fprintf(' Change in currents are: %6.3f (QFA) %6.3f (QDA) %6.3f (QFB)\n',...
%     deltacurrentquads(1,:));

if increment
    % In 10 incremental steps
    finished = 0;
    i = 0;
    while ~finished
        setsp('QFA',currentquads(:,1) + deltacurrentquads(:,1)*(i/10),'Hardware');
        setsp('QDA',currentquads(:,2) + deltacurrentquads(:,2)*(i/10),'Hardware');
        setsp('QFB',currentquads(:,3) + deltacurrentquads(:,3)*(i/10),'Hardware');
        switch questdlg(sprintf('Continue with tracking tunes? Applied %d/10',i),'Tune Tracking Question',...
                'Continue','Backstep','Finished','Continue');
            case 'Continue'
                i = i + 1;
            case 'Backstep'
                i = i - 1;
            case 'Finished'
                finished = 1;
        end
%         t = getliberatbt('DD1',[1 4]);
%         getfftspectrum(t.tbtx(1,:),499671948/360/64);
    end
else
%     switch questdlg('Apply new tunes?','Tune Tracking Question',...
%                 'Yes','No','No');
%         case 'Yes'
% Apply quad values completely
if max(percentage_change) > 0.05
    % Do in two steps
    setsp('QFA',currentquads(:,1) + deltacurrentquads(:,1)*0.5,'Hardware');
    setsp('QDA',currentquads(:,2) + deltacurrentquads(:,2)*0.5,'Hardware');
    setsp('QFB',currentquads(:,3) + deltacurrentquads(:,3)*0.5,'Hardware');
    pause(1);
    setsp('QFA',currentquads(:,1) + deltacurrentquads(:,1),'Hardware');
    setsp('QDA',currentquads(:,2) + deltacurrentquads(:,2),'Hardware');
    setsp('QFB',currentquads(:,3) + deltacurrentquads(:,3),'Hardware');
else
    setsp('QFA',currentquads(:,1) + deltacurrentquads(:,1),'Hardware');
    setsp('QDA',currentquads(:,2) + deltacurrentquads(:,2),'Hardware');
    setsp('QFB',currentquads(:,3) + deltacurrentquads(:,3),'Hardware');
end
fprintf('(%s): Tunes adjusted\n',datestr(now));

%         otherwise
%             disp('Not applying changes. Goodbye');
%     end
end
    
return



% Some measurements taken on the 11/10/06
mf = 1387.866895;
Initatunes = [407.4654	286.44708]./mf;
Finaltunes = [400.8038	289.77786]./mf;
% Delta Tune due to QFA
J(1:2,1) = ([492.95544	223.16226]-[325.3061	350.8421])./mf;
% Delta Dispersion due to QFA
J(3,1) = -0.003501+0.003327;

% Delta Tune due to QDA
J(1:2,2) = ([384.14996	354.1729] - [425.2295	225.3827])./mf;
% Delta Dispersion due to QDA
J(3,2) = 0.01104+0.02191;

% Delta Tune due to QFB
J(1:2,3) = ([548.800	190.400] - [277.7620	385.5622])./mf;
% Delta Dispersion due to QFB
J(3,3) = -0.1851-0.08853;
