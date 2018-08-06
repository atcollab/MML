function firstturnscorrection(Xcod,varargin)
% FIRSTTURNSCORRECTION
%
%  INPUTS
%  1. Xcod - Orbit reading (H or V)
%  Optionnal
%  2. Fact - Fractional of correction to apply
%  Flags
%  'Display' {Default} 'NoDisplay' - Do not show menu
%  'Horizontal' {Default} : Horizontal correction
%  'Vertical' {Default} : Horizontal correction
%

%
%% Written by Laurent S. Nadolski

DisplayFlag = 1;
PlaneFlag = 1; % 1 - Horizontal
% 0 - Vertical

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i)   = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i)   = [];
    elseif strcmpi(varargin{i},'Horizontal')
        PlaneFlag = 1;
        varargin(i)   = [];
    elseif strcmpi(varargin{i},'Vertical')
        PlaneFlag = 0;
        varargin(i)   = [];
    end
end

if isempty(varargin)
    Fact = 1; % Percentage of correction to apply
else
    Fact = varargin{1};
end

% Backup measure COD orbit
XcodOld = Xcod;


% BPM Families
BPMxFamily = 'BPMx';
BPMyFamily = 'BPMz';

% Corrector Families
HCMFamily  = 'HCOR';
VCMFamily  = 'VCOR';

% Get list of BPMs et corrector magnets
[HCMlist VCMlist BPMlist] = getlocallist;

% SVD orbit correction singular values
%Xivec = [1:56];
Xivec = [1:4];
Yivec = [1:10];

% initialize RFCorrFlag
RFCorrFlag = 'No';

% Goal orbit
Xgoal = getgolden(BPMxFamily, BPMlist, 'numeric');
Ygoal = getgolden(BPMyFamily, BPMlist, 'numeric');

% get Sensitivity matrices
Sx = getrespmat(BPMxFamily, BPMlist, HCMFamily, HCMlist);
Sy = getrespmat(BPMyFamily, BPMlist, VCMFamily, VCMlist);

% Compute SVD
[Ux, SVx, Vx] = svd(Sx);
[Uy, SVy, Vy] = svd(Sy);

% Remove singular values greater than the actual number of singular values
i = find(Xivec>length(diag(SVx)));
if ~isempty(i)
    disp('   Horizontal singular value vector scaled since there were more elements in the vector than singular values.');
    pause(0);
    Xivec(i) = [];
end
i = find(Yivec>length(diag(SVy)));
if ~isempty(i)
    disp('   Vertical singular value vector scaled since there were more elements in the vector than singular values.');
    pause(0);
    Yivec(i) = [];
end

if DisplayFlag
    % Display singular value plot
    %figure(h_fig1);
    h_fig1 = figure;
    subplot(2,1,1);
    semilogy(diag(SVx),'b');
    hold on;
    semilogy(diag(SVx(Xivec,Xivec)),'xr');
    ylabel('Horizontal');
    title('Response Matrix Singular Values');
    hold off;
    subplot(2,1,2);
    semilogy(diag(SVy),'b');
    hold on;
    semilogy(diag(SVy(Yivec,Yivec)),'xr');
    xlabel('Singular Value Number');
    ylabel('Vertical');
    hold off;
    drawnow;

    EditFlag = -1;

    while EditFlag ~= 6
        % Build up menu edition
        EditFlag = menu('Change Parameters?','Singular Values','HCM List','VCM List', ...
            'BPM List','Change the Goal Orbit', 'Continue');

        % Begin SOFB edition switchyard
        switch EditFlag
            case 1
                prompt = {'Enter the horizontal singular value number (Matlab vector format):', ...
                    'Enter the vertical singular value numbers (Matlab vector format):'};
                def = {sprintf('[%d:%d]',1,Xivec(end)),sprintf('[%d:%d]',1,Yivec(end))};
                titlestr='SVD Orbit Feedback';
                lineNo=1;
                answer=inputdlg(prompt,titlestr,lineNo,def);
                if ~isempty(answer)
                    XivecNew = fix(str2num(answer{1}));
                    if isempty(XivecNew)
                        disp('   Horizontal singular value vector cannot be empty.  No change made.');
                    else
                        if any(XivecNew<=0) | max(XivecNew)>length(diag(SVx))
                            disp('   Error reading horizontal singular value vector.  No change made.');
                        else
                            Xivec = XivecNew;
                        end
                    end
                    YivecNew = fix(str2num(answer{2}));
                    if isempty(YivecNew)
                        disp('   Vertical singular value vector cannot be empty.  No change made.');
                    else
                        if any(YivecNew<=0) | max(YivecNew)>length(diag(SVy))
                            disp('   Error reading vertical singular value vector.  No change made.');
                        else
                            Yivec = YivecNew;
                        end
                    end
                end


            case 2 % Horizontal corrector list edition
                List= getlist(HCMFamily);
                CheckList = zeros(96,1);
                Elem = dev2elem(HCMFamily, HCMlist);
                CheckList(Elem) = ones(size(Elem));
                CheckList = CheckList(dev2elem(HCMFamily,List));

                newList = editlist(List, HCMFamily, CheckList);

                if isempty(newList)
                    fprintf('   Horizontal corrector magnet list cannot be empty.  No change made.\n');
                else
                    HCMlist = newList;
                end


            case 3 % Vertical corrector list edition
                List = getlist(VCMFamily);
                CheckList = zeros(96,1);
                Elem = dev2elem(VCMFamily, VCMlist);
                CheckList(Elem) = ones(size(Elem));
                CheckList = CheckList(dev2elem(VCMFamily,List));

                newList = editlist(List, VCMFamily, CheckList);

                if isempty(newList)
                    fprintf('   Vertical corrector magnet cannot be empty.  No change made.\n');
                else
                    VCMlist = newList;
                end


            case 4 % BPM List edition
                % Back present BPM list and goal orbit
                ListOld = BPMlist;
                XgoalOld = Xgoal;
                YgoalOld = Ygoal;

                List = family2dev(BPMxFamily);

                %Check BPM already in the list CheckList(i) = 1
                %      BPM not in the list CheckList(i) = 0
                CheckList = zeros(size(List,1),1);
                if ~isempty(BPMlist)
                    for i = 1:size(List,1)
                        k = find(List(i,1)==BPMlist(:,1));
                        l = find(List(i,2)==BPMlist(k,2));

                        if isempty(k) | isempty(l)
                            % Item not in list
                        else
                            CheckList(i) = 1;
                        end
                    end
                end

                % User edition of the BPM list
                newList = editlist(List, 'BPM', CheckList);
                if isempty(newList)
                    fprintf('   BPM list cannot be empty.  No change made.\n');
                else
                    BPMlist = newList;
                end

                % Set the goal orbit to the golden orbit
                Xgoal = getgolden(BPMxFamily, BPMlist);
                Ygoal = getgolden(BPMyFamily, BPMlist);

                [a idx]=intersect(family2dev('BPMx'),BPMlist,'rows');
                Xcod = XcodOld(idx); 
                %if a new BPM is added, then set the goal orbit to
                %the golden orbit.
                % Otherwise keep the present goal orbit
                for i = 1:size(BPMlist,1)

                    % Is it a new BPM?
                    k = find(BPMlist(i,1)==ListOld(:,1));
                    l = find(BPMlist(i,2)==ListOld(k,2));

                    if isempty(k) | isempty(l)
                        % New BPM
                    else
                        % Use the old value for old BPM
                        Xgoal(i) = XgoalOld(k(l));
                        Ygoal(i) = YgoalOld(k(l));
                    end
                end

            case 5 % Goal orbit edition
                ChangeList = editlist(BPMlist, 'Change BPM', zeros(size(BPMlist,1),1));

                for i = 1:size(ChangeList,1)

                    k = find(ChangeList(i,1)==BPMlist(:,1));
                    l = find(ChangeList(i,2)==BPMlist(k,2));

                    prompt={sprintf('Enter the new horizontal goal orbit for BPMx(%d,%d):', ...
                        BPMlist(k(l),1),BPMlist(k(l),2)), ...
                        sprintf('Enter the new vertical goal orbit for BPMz(%d,%d):', ...
                        BPMlist(k(l),1),BPMlist(k(l),2))};
                    def={sprintf('%f',Xgoal(k(l))),sprintf('%f',Ygoal(k(l)))};
                    titlestr='CHANGE THE GOAL ORBIT';
                    lineNo=1;
                    answer = inputdlg(prompt, titlestr, lineNo, def);

                    if isempty(answer)
                        % No change
                        fprintf('   No change was made to the golden orbit.\n');
                    else
                        Xgoalnew = str2num(answer{1});
                        if isempty(Xgoalnew)
                            fprintf('   No change was made to the horizontal golden orbit.\n');
                        else
                            Xgoal(k(l)) = Xgoalnew;
                        end

                        Ygoalnew = str2num(answer{2});
                        if isempty(Ygoalnew)
                            fprintf('   No change was made to the vertical golden orbit.\n');
                        else
                            Ygoal(k(l)) = Ygoalnew;
                        end
                    end
                end
                if ~isempty(ChangeList)
                    fprintf('   Note:  Changing the goal orbit for "Slow Orbit Feedback" does not change the goal orbit for "Orbit Correction."\n');
                    fprintf('          Re-running srcontrol will restart the goal orbit to the golden orbit."\n');
                end
        end
    end
end

%% recompute matrices with final BPM and CM lists
% get Sensitivity matrices
Sx = getrespmat(BPMxFamily, BPMlist, HCMFamily, HCMlist);
Sy = getrespmat(BPMyFamily, BPMlist, VCMFamily, VCMlist);

% Compute SVD
[Ux, SVx, Vx] = svd(Sx);
[Uy, SVy, Vy] = svd(Sy);

% Remove singular values greater than the actual number of singular values
i = find(Xivec>length(diag(SVx)));
if ~isempty(i)
    disp('   Horizontal singular value vector scaled since there were more elements in the vector than singular values.');
    pause(0);
    Xivec(i) = [];
end
i = find(Yivec>length(diag(SVy)));
if ~isempty(i)
    disp('   Vertical singular value vector scaled since there were more elements in the vector than singular values.');
    pause(0);
    Yivec(i) = [];
end

if PlaneFlag  % Horizontal plane
    Smat = Sx;
    V  = Vx;
    SVDIndex = Xivec;
    GoalOrbitVec = Xgoal*0;
    CMFamily  = HCMFamily;
    BPMFamily = BPMxFamily;
    CMlist = HCMlist;
else % Vertical plane
    Smat = Sy;
    V  = Vy;
    SVDIndex = Yivec;
    GoalOrbitVec = Ygoal*0;
    CMFamily  = VCMFamily;
    BPMFamily = BPMyFamily;
    CMlist = VCMlist;
end

Orbit0Vec = Xcod(:);
BPMWeight = ones(size(BPMlist,1),1);

Smod = Smat * V(:, SVDIndex);  %  Note: SmatMod = U(:,Ivec) * S(Ivec,Ivec) = Smat * V(:,Ivec)
% T = inv(Smod'*Smod)*Smod';
% B = T * (BPMWeight .* (GoalOrbitVec - Orbit0Vec));
B     = Smod\(BPMWeight.*(GoalOrbitVec - Orbit0Vec));
Delcm = -V(:,SVDIndex)*B;

figure
subplot(2,1,1)
bar(Delcm*Fact);
ylabel('Current Increment (A)')
subplot(2,1,2)
bar(Delcm*Fact+getam(CMFamily,CMlist));
suptitle(CMFamily)
ylabel('Total Current aftercorrection (A)')
xlabel('Corrector Number')

tmp = questdlg('Apply orbit correction?','SETORBIT','Yes','No','No');
if strcmpi(tmp,'No')
    fprintf('   Orbit not corrected\n');
else
    stepsp(CMFamily,Fact*Delcm, CMlist)
end



function [HCMlist, VCMlist, BPMlist] = getlocallist

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Edit the following lists to change default configuration of Orbit Correction %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

HCMlist = [
    1     1
    1     4
    1     7
    2     1
    2     4
    2     5
    2     8
    3     1
    3     4
    3     5
    3     8
    4     1
    4     4
    4     7
    5     1
    5     4
    5     7
    6     1
    6     4
    6     5
    6     8
    7     1
    7     4
    7     5
    7     8
    8     1
    8     4
    8     7
    9     1
    9     4
    9     7
    10     1
    10     4
    10     5
    10     8
    11     1
    11     4
    11     5
    11     8
    12     1
    12     4
    12     7
    13     1
    13     4
    13     7
    14     1
    14     4
    14     5
    14     8
    15     1
    15     4
    15     5
    15     8
    16     1
    16     4
    16     7];

VCMlist = [
    1     2
    1     4
    1     6
    2     2
    2     3
    2     6
    2     7
    3     2
    3     3
    3     6
    3     7
    4     2
    4     4
    4     6
    5     2
    5     4
    5     6
    6     2
    6     3
    6     6
    6     7
    7     2
    7     3
    7     6
    7     7
    8     2
    8     4
    8     6
    9     2
    9     4
    9     6
    10     2
    10     3
    10     6
    10     7
    11     2
    11     3
    11     6
    11     7
    12     2
    12     4
    12     6
    13     2
    13     4
    13     6
    14     2
    14     3
    14     6
    14     7
    15     2
    15     3
    15     6
    15     7
    16     2
    16     4
    16     6
    ];
BPMlist = [
    1     2
    1     3
    1     4
    1     5
    1     6
    1     7
    2     1
    2     2
    2     3
    2     4
    2     5
    2     6
    2     7
    2     8
    3     1
    3     2
    3     3
    3     4
    3     5
    3     6
    3     7
    3     8
    4     1
    4     2
    4     3
    4     4
    4     5
    4     6
    4     7
    5     1
    5     2
    5     3
    5     4
    5     5
    5     6
    5     7
    6     1
    6     2
    6     3
    6     4
    6     5
    6     6
    6     7
    6     8
    7     1
    7     2
    7     3
    7     4
    7     5
    7     6
    7     7
    7     8
    8     1
    8     2
    8     3
    8     4
    8     5
    8     6
    8     7
    9     1
    9     2
    9     3
    9     4
    9     5
    9     6
    9     7
    10     1
    10     2
    10     3
    10     4
    10     5
    10     6
    10     7
    10     8
    11     1
    11     2
    11     3
    11     4
    11     5
    11     6
    11     7
    11     8
    12     1
    12     2
    12     3
    12     4
    12     5
    12     6
    12     7
    13     1
    13     2
    13     3
    13     4
    13     5
    13     6
    13     7
    14     1
    14     2
    14     3
    14     4
    14     5
    14     6
    14     7
    14     8
    15     1
    15     2
    15     3
    15     4
    15     5
    15     6
    15     7
    15     8
    16     1
    16     2
    16     3
    16     4
    16     5
    16     6
    16     7
    1     1
    ];

