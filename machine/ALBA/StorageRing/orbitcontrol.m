function orbitcontrol(action, Input2, Input3)
%ORBITCONTROL - GUI for orbit correction and SOFB
%
%  INPUTS
%  None to launch the programme
%  1. action - Callback to execute
%  2. Input2 - First argument for callback function
%  3. Input3  First argument for callback function
%
%  OUPUTS
%  None
%
%  NOTES
%  1. Settings for SOFB and manual orbit correction are often different
%  2. Manual Correction : 3 iterations are done in a row

%
%  See Also setorbit


%
%  Written by Laurent S. Nadolski (inspired by ALS srcontrol programme)
%  TODO
%  Weight edition ?
%  HWarnNum, VwarnNum
%  SOFB seems not interruptable ?? matlab SP2 BUG ???

% Check if the AO exists
checkforao;

% Arguments
if nargin < 1
    action = 'Initialize';
end

if nargin < 2
    Input2 = 0;
end

if nargin < 3
    Input3 = 0;
end

% Common variables
SR_GEV = getenergy('Energy');

% BPM Families
BPMxFamily = gethbpmfamily;
BPMyFamily = getvbpmfamily;

% Corrector Families
HCMFamily  = gethcmfamily;
VCMFamily  = getvcmfamily;

% Minimum stored current to allow correction
DCCTMIN = 2; % mA

%%%%%%%%%%%%%%%%
%% Main Program
%%%%%%%%%%%%%%%%

switch(action)

    case 'StopOrbitFeedback'

        setappdata(findobj(gcbf,'Tag','ORBITCTRLFig1'),'FEEDBACK_STOP_FLAG', 1);
        set(findobj(gcbf,'Tag','ORBITCTRLStaticTextInformation'),'String','SOFB STOP');
        pause(0);

    case 'Initialize'

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % GUI  CONSTRUCTION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ButtonWidth = 200;
        ButtonHeight  = 25;

        Offset1 = 2*(ButtonHeight+3); % Frame around Text information
        Offset2 = Offset1 + 2*(ButtonHeight+3); % Frame around SOFB
        Offset3 = Offset2 + 11*(ButtonHeight+3); % Manual Orbit
        FigWidth = ButtonWidth + 6;
        FigHeight  = Offset3 + 5.5*(ButtonHeight+3);
        ButtonWidth = 200-6;

        % Change figure position
        set(0,'Units','pixels');
        p = get(0,'screensize');

        orbfig = findobj(allchild(0),'tag','ORBITCTRLFig1');

        if ~isempty(orbfig)
            return; % IHM already exists
        end

        h0 = figure( ...
            'Color',[0.8 0.8 0.8], ...
            'HandleVisibility','Off', ...
            'Interruptible', 'on', ...
            'MenuBar','none', ...
            'Name','SOLEIL ORBIT CONTROL', ...
            'NumberTitle','off', ...
            'Units','pixels', ...
            'Position',[30 p(4)-FigHeight-40 FigWidth FigHeight], ...
            'Resize','off', ...
            'HitTest','off', ...
            'IntegerHandle', 'off', ...
            'Tag','ORBITCTRLFig1');

        % Frame Box I
        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ListboxTop',0, ...
            'Position',[3 Offset3 ButtonWidth+6 4.5*ButtonHeight+25], ...
            'Style','frame');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontSize',10, ...
            'ListboxTop',0, ...
            'Position',[6 3 + 4*(ButtonHeight+3)+Offset3  ButtonWidth .6*ButtonHeight], ...
            'String','Manual Orbit Correction', ...
            'Style','text');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Enable','on', ...
            'Interruptible', 'on', ...
            'Position',[26 3 + 3*(ButtonHeight+3) + Offset3 ButtonWidth-32 .8*ButtonHeight], ...
            'String','H-plane', ...
            'Style','checkbox', ...
            'Value',1,...
            'Tag','ORBITCTRLCheckboxHcorrection');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Enable','on', ...
            'Interruptible', 'on', ...
            'Position',[26 3+2*(ButtonHeight+3)+Offset3 ButtonWidth-32 .8*ButtonHeight], ...
            'String','V-plane', ...
            'Style','checkbox', ...
            'Value',1,...
            'Tag','ORBITCTRLCheckboxVcorrection');

        uicontrol('Parent',h0, ...
            'Callback','orbitcontrol(''OrbitCorrection'');', ...
            'Interruptible','Off', ...
            'Enable','On', ...
            'Position',[6 3+1*(ButtonHeight+3)+Offset3 ButtonWidth ButtonHeight], ...
            'String','Correct Orbit', ...
            'Tag','ORBITCTRLButtonOrbitCorrection');

        uicontrol('Parent',h0, ...
            'CreateFcn','orbitcontrol(''OrbitCorrectionSetup'',1);', ...
            'callback','orbitcontrol(''OrbitCorrectionSetup'',0);', ...
            'Enable','on', ...
            'Interruptible', 'off', ...
            'Position',[6 3+Offset3 ButtonWidth 0.8*ButtonHeight], ...
            'String','Edit BPM, CM Lists', ...
            'Style','PushButton', ...
            'Value',0,...
            'Tag','ORBITCTRLButtonOrbitCorrectionSetup');

        % Frame Box II
        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ListboxTop',0, ...
            'Position',[3 Offset2 ButtonWidth+6 11*ButtonHeight+5], ...
            'Style','frame');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontSize',10, ...
            'ListboxTop',0, ...
            'Position',[6 3+9*(ButtonHeight+3)+ Offset2 ButtonWidth .55*ButtonHeight], ...
            'String','Orbit Feedback', ...
            'Style','text');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Enable','on', ...
            'Interruptible', 'on', ...
            'Position',[26 3 + 8*(ButtonHeight+3) + Offset2 ButtonWidth-32 .8*ButtonHeight], ...
            'String','H-plane', ...
            'Style','checkbox', ...
            'Value',1,...
            'Tag','ORBITCTRLCheckboxHSOFB');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Enable','on', ...
            'Interruptible', 'on', ...
            'Position',[26 3+7*(ButtonHeight+3)+Offset2 ButtonWidth-32 .8*ButtonHeight], ...
            'String','V-plane', ...
            'Style','checkbox', ...
            'Value',1,...
            'Tag','ORBITCTRLCheckboxVSOFB');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Enable','on', ...
            'Interruptible', 'on', ...
            'Position',[26 3+6*(ButtonHeight+3)+Offset2 ButtonWidth-32 .8*ButtonHeight], ...
            'String','Slow Orbit Correction', ...
            'Style','checkbox', ...
            'Value',1,...
            'Tag','ORBITCTRLCheckboxSOFB');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Enable','on', ...
            'Interruptible', 'on', ...
            'Position',[26 3+5*(ButtonHeight+3)+Offset2 ButtonWidth-32 .8*ButtonHeight], ...
            'String','Fast Orbit Correction (Not implemented)', ...
            'Style','checkbox', ...
            'Value',0,...
            'Tag','ORBITCTRLCheckboxFOFB');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Enable','on', ...
            'Interruptible', 'on', ...
            'Position',[26 3+4*(ButtonHeight+3)+Offset2 ButtonWidth-32 .8*ButtonHeight], ...
            'String','Correct RF Frequency', ...
            'Style','checkbox', ...
            'Value',1,...
            'Tag','ORBITCTRLCheckboxRF');

        uicontrol('Parent',h0, ...
            'callback','orbitcontrol(''Feedback'');', ...
            'Enable','on', ...
            'FontSize',12, ...
            'Interruptible', 'on', ...
            'ListboxTop',0, ...
            'Position',[8 3+3*(ButtonHeight+3)+ Offset2 .5*ButtonWidth-6 1.0*ButtonHeight], ...
            'String','Start FB', ...
            'Value',0, ...
            'Tag','ORBITCTRLPushbuttonStart');

        uicontrol('Parent',h0, ...
            'callback','orbitcontrol(''StopOrbitFeedback'');pause(0);', ...
            'Enable','off', ...
            'FontSize',12, ...
            'Interruptible', 'on', ...
            'ListboxTop',0, ...
            'Position',[.5*FigWidth+3 3+3*(ButtonHeight+3)+Offset2 .5*ButtonWidth-6 1.0*ButtonHeight], ...
            'String','Stop FB', ...
            'Value',0, ...
            'Tag','ORBITCTRLPushbuttonStop');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[14 3 + 2*(ButtonHeight)+Offset2 ButtonWidth-14 .75*ButtonHeight], ...
            'String','Horizontal RMS = _____ mm', ...
            'Style','text', ...
            'Tag','ORBITCTRLStaticTextHorizontal');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[26 3 + 1*(ButtonHeight) + Offset2 ButtonWidth-26 .75*ButtonHeight], ...
            'String','Vertical RMS = _____ mm', ...
            'Style','text', ...
            'Tag','ORBITCTRLStaticTextVertical');

        uicontrol('Parent',h0, ...
            'CreateFcn','orbitcontrol(''FeedbackSetup'',1);', ...
            'callback','orbitcontrol(''FeedbackSetup'',0);', ...
            'Enable','on', ...
            'Interruptible', 'off', ...
            'Position',[8 3 + Offset2 ButtonWidth-5 .75*ButtonHeight], ...
            'String','Edit SOFB Setup', ...
            'Style','PushButton', ...
            'Value',0,...
            'Tag','ORBITCTRLButtonFeedbackSetup');

        % Frame Box III
        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ListboxTop',0, ...
            'Position',[3 Offset1  ButtonWidth+6 ButtonHeight+12], ...
            'Style','frame');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','center', ...
            'ListboxTop',0, ...
            'Position',[6 Offset1 + 0.7*ButtonHeight ButtonWidth .7*ButtonHeight], ...
            'String','Experimental Interface', ...
            'Style','text', ...
            'Tag','ORBITCTRLStaticTextHeader');

        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ForegroundColor','b', ...
            'HorizontalAlignment','center', ...
            'ListboxTop',0, ...
            'Position',[6 3 + Offset1 + .05*ButtonHeight ButtonWidth .7*ButtonHeight], ...
            'String','   Startup', ...
            'Style','text', ...
            'Tag','ORBITCTRLStaticTextInformation');

        % Frame Box "Close"
        uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ListboxTop',0, ...
            'Position',[3 8 ButtonWidth+6 ButtonHeight+8], ...
            'Style','frame');

        uicontrol('Parent',h0, ...
            'Callback', 'close(gcbf);', ...
            'Enable','On', ...
            'Interruptible','Off', ...
            'Position',[6 13 ButtonWidth ButtonHeight], ...
            'String','Close', ...
            'Tag','ORBITCTRLClose');
        
    case 'OrbitCorrectionSetup'
        % NOTES setting for SOFB and manual orbit correction are often
        % different

        InitFlag = Input2;  % Input #2: if InitFlag, then initialize variables

        if InitFlag % just at startup

            % Setup orbit correction elements : DEFAULT configuration
            %disp('Orbit correction condition: InitFlag=1 -- debugging message');

            % Get list of BPMs et corrector magnets
            [HCMlist VCMlist BPMlist] = getlocallist;

            % SVD orbit correction singular values
            Xivec = 1:88;
            Yivec = 1:88;

            % initialize RFCorrFlag
            %RFCorrFlag = 'No';
            RFCorrFlag = 'Yes';

            % Goal orbit
            Xgoal = getgolden(BPMxFamily, BPMlist, 'numeric');
            Ygoal = getgolden(BPMyFamily, BPMlist, 'numeric');


        else % For orbit correction Configuration
            % Get vector for orbit correction
            FB = get(findobj(gcbf,'Tag','ORBITCTRLButtonOrbitCorrectionSetup'),'Userdata');
            BPMlist = FB.BPMlist;
            HCMlist = FB.HCMlist;
            VCMlist = FB.VCMlist;
            Xivec = FB.Xivec;
            Yivec = FB.Yivec;
            Xgoal = FB.Xgoal;
            Ygoal = FB.Ygoal;
            RFCorrFlag = FB.RFCorrFlag;

            % Add button to change #ivectors, CMs, IDBPMs,
            EditFlag = 0;
            h_fig1 = figure;

            while EditFlag ~= 7

                % get Sensitivity matrices
                Sx = getrespmat(BPMxFamily, BPMlist, HCMFamily, HCMlist, [], SR_GEV);
                Sy = getrespmat(BPMyFamily, BPMlist, VCMFamily, VCMlist, [], SR_GEV);

                % Computes SVD to get singular values
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

                % Display singular value plot for both planes

                figure(h_fig1);

                subplot(2,1,1);
                semilogy(diag(SVx),'b');
                hold on;
                semilogy(diag(SVx(Xivec,Xivec)),'xr');
                ylabel('Horizontal');
                title('Response Matrix Singular Values');
                hold off; grid on;

                subplot(2,1,2);
                semilogy(diag(SVy),'b');
                hold on;
                semilogy(diag(SVy(Yivec,Yivec)),'xr');
                xlabel('Singular Value Number');
                ylabel('Vertical');
                hold off; grid on;
                drawnow;

                % End of display

                if strcmpi(RFCorrFlag,'No')
                    RFCorrState = 'NOT CORRECTED';
                elseif strcmp(RFCorrFlag,'Yes')
                    RFCorrState = 'CORRECTED';
                else
                    RFCorrState = '???';
                end

                EditFlag = menu('Change Parameters?','Singular Values',  ...
                    'Horizontal corrector magnet list', ...
                    'Vertical corrector magnet list','BPM List','Goal Orbit value',...
                    sprintf('RF Frequency (currently %s)',RFCorrState),'Return');

                % Edition switchyard for orbit correction
                switch EditFlag
                    case 1 % Singular value edition

                        % Build up matlab prompt
                        prompt = {'Enter the horizontal singular value vector (Matlab vector format):', ...
                            'Enter the vertical singular value vector (Matlab vector format):'};
                        % default values
                        def = {sprintf('[%d:%d]',1,Xivec(end)),sprintf('[%d:%d]',1,Yivec(end))};
                        titlestr = 'SVD Orbit Correction';
                        lineNo = 1;

                        answer = inputdlg(prompt,titlestr,lineNo,def);

                        % Answer parsing
                        if ~isempty(answer)
                            % Horizontal plane
                            XivecNew = fix(str2num(answer{1}));
                            if isempty(XivecNew)
                                disp('   Horizontal singular value number cannot be empty.  No change made.');
                            else
                                if any(XivecNew<=0) || max(XivecNew)>length(diag(SVx))
                                    disp('   Error reading horizontal singular value vector  No change made.');
                                else
                                    Xivec = XivecNew;
                                end
                            end
                            % Vertical plane
                            YivecNew = fix(str2num(answer{2}));
                            if isempty(YivecNew)
                                disp('   Vertical singular value vector cannot be empty.  No change made.');
                            else
                                if any(YivecNew<=0) || max(YivecNew)>length(diag(SVy))
                                    disp('   Error reading vertical singular value vector.  No change made.');
                                else
                                    Yivec = YivecNew;
                                end
                            end
                        end

                    case 2 % Horizontal corrector list edition
                        List = getlist(HCMFamily);
                        CheckList = zeros(size(List,1));
                        Elem = dev2elem(HCMFamily, HCMlist);
                        CheckList(Elem) = ones(size(Elem));
                        CheckList = CheckList(dev2elem(HCMFamily,List));
                        newList = editlist(List, HCMFamily, CheckList);
                        if isempty(newList)
                            fprintf('   Horizontal corrector magnet list cannot be empty.  No change made.\n');
                        else
                            HCMlist = newList;
                        end

                    case 3 % vertical corrector list edition
                        List = getlist(VCMFamily);
                        CheckList = zeros(size(List,1));
                        Elem = dev2elem(VCMFamily, VCMlist);
                        CheckList(Elem) = ones(size(Elem));
                        CheckList = CheckList(dev2elem(VCMFamily,List));
                        newList = editlist(List, VCMFamily, CheckList);
                        if isempty(newList)
                            fprintf('   Vertical corrector magnet cannot be empty.  No change made.\n');
                        else
                            VCMlist = newList;
                        end

                    case 4 % BPM list edition
                        % Backup element before edition
                        ListOld = BPMlist;
                        XgoalOld = Xgoal;
                        YgoalOld = Ygoal;

                        % Get full BPM list
                        List = family2dev(BPMxFamily);

                        % Check BPM already in the list CheckList(i) = 1
                        %       BPM not in the list CheckList(i) = 0
                        CheckList = zeros(size(List,1),1);
                        if ~isempty(BPMlist)
                            for i = 1:size(List,1)
                                k = find(List(i,1) == BPMlist(:,1));
                                l = find(List(i,2) == BPMlist(k,2));
                                if isempty(k) || isempty(l)
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


                        % If a new BPM is added, then set the goal orbit to the golden orbit
                        % For other BPMs, present goal orbit is kept
                        for i = 1:size(BPMlist,1)

                            % Is it a new BPM?
                            k = find(BPMlist(i,1) == ListOld(:,1));
                            l = find(BPMlist(i,2) == ListOld(k,2));

                            if isempty(k) || isempty(l)
                                % New BPM
                            else
                                % Use the old value for old BPM
                                Xgoal(i) = XgoalOld(k(l));
                                Ygoal(i) = YgoalOld(k(l));
                            end
                        end

                    case 5 % Golden orbit manual edition

                        % Ask user to select BPM for modifying golden orbit
                        ChangeList = editlist(BPMlist, 'Change BPM', ...
                            zeros(size(BPMlist,1),1));

                        % Ask the new golden orbit for each selected BPM
                        for i = 1:size(ChangeList,1)

                            k = find(ChangeList(i,1) == BPMlist(:,1));
                            l = find(ChangeList(i,2) == BPMlist(k,2));

                            prompt = {sprintf('Enter the new horizontal goal orbit for BPMx(%d,%d):', ...
                                BPMlist(k(l),1), BPMlist(k(l),2)), ...
                                sprintf('Enter the new vertical goal orbit for BPMz(%d,%d):', ...
                                BPMlist(k(l),1),BPMlist(k(l),2))};
                            def = {sprintf('%f',Xgoal(k(l))),sprintf('%f',Ygoal(k(l)))};
                            titlestr = 'CHANGE THE GOAL ORBIT';
                            lineNo = 1;
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
                            fprintf('   Note:  changing the goal orbit for "Orbit Correction" does not change the goal orbit for "Slow Orbit Feedback."\n');
                            fprintf('          Re-running soleilinit will restart the goal orbit to the golden orbit."\n');
                        end

                    case 6 % RF flag edition
                        RFCorrFlag = questdlg(sprintf('Set RF Frequency during Orbit Correction?'),'RF Frequency','Yes','No', 'No');
                        if strcmp(RFCorrFlag,'No')
                            disp('   RF Frequency will not be included in global orbit correction.');
                        elseif strcmp(RFCorrFlag,'Yes')
                            disp('   RF Frequency will be included in global orbit correction.');
                        end
                        FB.RFCorrFlag = RFCorrFlag;
                end
            end
            close(h_fig1);

        end
        % END of switchyard for orbit correction edition

        % This part is common for case 'orbit correction edition'

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Build up Orbit correction Structures   %
        %  for setorbit programme : OCSx and OCSy%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  ORBIT CORRECTION STRUCTURE (OCS)
        %    OCS.BPM (data structure)
        %    OCS.CM  (data structure)
        %    OCS.GoalOrbit
        %    OCS.NIter
        %    OCS.SVDIndex
        %    OCS.IncrementalFlag = 'Yes'/'No'
        %    OCS.BPMWeight
        %    OCS.Flags = { 'FitRF' , etc.  }

        % Horizontal plane
        OCSx.BPM = getx(BPMlist, 'struct');
        OCSx.GoalOrbit = Xgoal;
        OCSx.CM  = getsp(HCMFamily, HCMlist, 'struct','Model');
        OCSx.NIter = 1; % Number of iterations
        OCSx.SVDIndex = Xivec; % number of eigenvector for correction
        OCSx.IncrementalFlag = 'No';
        if strcmp(RFCorrFlag,'Yes')
            OCSx.FitRF = 1; % take RF as a corrector
        else
            OCSx.FitRF = 0;
        end
        % Vertical plane
        OCSy.BPM = gety(BPMlist, 'struct');
        OCSy.CM  = getsp(VCMFamily, VCMlist, 'struct','Model');
        OCSy.GoalOrbit = Ygoal;
        OCSy.NIter = 1;
        OCSy.SVDIndex = Yivec;
        OCSy.IncrementalFlag = 'No';
        OCSy.FitRF = 0;

        % Save structures for later orbit correction
        FB.OCSx = OCSx;
        FB.OCSy = OCSy;

        % List of BPM et correctors to be used
        FB.BPMlist = BPMlist;
        FB.HCMlist = HCMlist;
        FB.VCMlist = VCMlist;

        % List of singular values
        FB.Xivec = Xivec;
        FB.Yivec = Yivec;

        % Goal orbit
        FB.Xgoal = OCSx.GoalOrbit;
        FB.Ygoal = OCSy.GoalOrbit;

        % RF corrector flag
        FB.RFCorrFlag = RFCorrFlag;

        % save FB structure in application
        set(findobj(gcbf,'Tag','ORBITCTRLButtonOrbitCorrectionSetup'),'Userdata',FB);

    case 'OrbitCorrection' % Manual Orbit Correction

        try
            %look for already running SOFB
            %val = readattribute('ANS/DG/PUB-SOFB/state');
            %if val == 1
            %    error('SOFB already running. Stop SOFB first!')
            %end
        catch
            fprintf('\n  %s \n',lasterr);
            fprintf('   %s \n', datestr(clock));
            disp('   ********************************');
            disp('   **  Orbit Correction Aborted  **');
            disp('   ********************************');
            fprintf('\n');
            return
        end

        OrbitLoopIter = 3; % a 3 step iteration

        fprintf('\n');
        fprintf('   *********************************\n');
        fprintf('   **  Starting Orbit Correction  **\n');
        fprintf('   *********************************\n');
        fprintf('   %s \n', datestr(clock));

        StartFlag = questdlg(sprintf('Start orbit correction ?'),'Orbit Correction','Yes','No','No');
        if strcmp(StartFlag,'No')
            disp('   ********************************');
            disp('   **  Orbit Correction Aborted  **');
            disp('   ********************************');
            fprintf('\n');
            return
        end

        if getdcct < DCCTMIN    % Don't correct the orbit if the current is too small
            fprintf('   Orbit not corrected due to small current.\n');
            return
        end

        % get Structure for correction
        FB = get(findobj(gcbf,'Tag','ORBITCTRLButtonOrbitCorrectionSetup'),'Userdata');

        fprintf('   Starting horizontal and vertical global orbit correction (SVD method).\n');

        % Number of steerer magnet corrector
        N_HCM = size(FB.HCMlist,1);
        N_VCM = size(FB.VCMlist,1);


        for iloop = 1:OrbitLoopIter,
            try
                %%%%%%%%%%%%%%%%%
                % use the following to get corrector settings in OCS and
                % check everything seems Ok and gives back predicted correction
                %% V-plane checks
                if get(findobj(gcbf,'Tag','ORBITCTRLCheckboxHcorrection'),'Value') == 1
                    HOrbitCorrectionFlag = 1;
                    FB.OCSx = setorbit(FB.OCSx,'Nodisplay','Nosetsp');

                    HCMSP = getsp(HCMFamily, FB.HCMlist);  % present corrector values
                    HCMSP_next = HCMSP + FB.OCSx.CM.Delta(1:N_HCM);       % next corrector values, just slow correctors (no RF)

                    MaxSP = maxsp(HCMFamily,FB.HCMlist);
                    MinSP = minsp(HCMFamily,FB.HCMlist);

                    if any(MaxSP - HCMSP_next  < 0)
                        HCMnum = find(HCMSP_next > MaxSP);
                        % message to screen
                        fprintf('**One or more of the horizontal correctors is at its maximum positive value!! Stopping orbit feedback. \n');
                        fprintf('%s\n',datestr(now));
                        fprintf('**%s is one of the problem correctors.\n', ...
                            cell2mat(family2tango(HCMFamily,'Setpoint',FB.HCMlist(HCMnum(1),:))));
                        HOrbitCorrectionFlag = 0;
                    end

                    if any(MinSP - HCMSP_next  > 0)
                        HCMnum = find(HCMSP_next < MinSP);
                        % message to screen
                        fprintf('**One or more of the horizontal correctors is at its maximum negative value!! Stopping orbit feedback. \n');
                        fprintf('%s\n',datestr(now));
                        fprintf('**%s is one of the problem correctors.\n', ...
                            cell2mat(family2tango(HCMFamily,'Setpoint',FB.HCMlist(HCMnum(1),:))));
                        HOrbitCorrectionFlag = 0;
                    end

                    if any(HCMSP_next > MaxSP - 1)
                        HCMnum = find(HCMSP_next > MaxSP - 1);
                        for ik = 1:length(HCMnum)
                            fprintf('**Horizontal correctors %s is above %f! \n', ...
                                cell2mat(family2tango(HCMFamily,'Setpoint',FB.HCMlist(HCMnum(ik),:))), ...
                                MaxSP(HCMnum(ik)) - 1);
                        end
                        fprintf('%s\n',datestr(now));
                        fprintf('**The orbit correction is still working but this problem should be investigated. \n');
                    end

                    if any(HCMSP_next < MinSP + 1)
                        HCMnum = find(HCMSP_next < MinSP + 1);
                        for ik = 1:length(HCMnum)
                            fprintf('**Horizontal correctors %s is below %f! \n', ...
                                cell2mat(family2tango(HCMFamily,'Setpoint',FB.HCMlist(HCMnum(ik),:))), ...
                                MinSP(HCMnum(ik)) + 1);
                        end
                        fprintf('%s\n',datestr(now));
                        fprintf('**The orbit correction is still working but this problem should be investigated. \n');
                    end

                end

                %% V-plane checks
                if get(findobj(gcbf,'Tag','ORBITCTRLCheckboxVcorrection'),'Value') ==1
                    FB.OCSy = setorbit(FB.OCSy,'Nodisplay','Nosetsp');
                    VOrbitCorrectionFlag = 1;
                    VCMSP = getsp(VCMFamily,FB.VCMlist); % Get corrector values before correction
                    VCMSP_next = VCMSP + FB.OCSy.CM.Delta(1:N_VCM); % New corrector values to be set in

                    MaxSP = maxsp(VCMFamily,FB.VCMlist);
                    MinSP = minsp(VCMFamily,FB.VCMlist);

                    if any(MaxSP - VCMSP_next  < 0)
                        VCMnum = find(VCMSP_next > MaxSP);
                        % message to screen
                        fprintf('**One or more of the vertical correctors is at its maximum positive value!! Stopping orbit feedback. \n');
                        fprintf('%s\n',datestr(now));
                        fprintf('**%s is one of the problem correctors.\n', ...
                            cell2mat(family2tango(VCMFamily,'Setpoint',FB.VCMlist(VCMnum(1),:))));
                    end

                    if any(MinSP - VCMSP_next  > 0)
                        VCMnum = find(VCMSP_next < MinSP);
                        % message to screen
                        fprintf('**One or more of the vertical correctors is at its maximum negative value!! Stopping orbit feedback. \n');
                        fprintf('%s\n',datestr(now));
                        fprintf('**%s is one of the problem correctors.\n', ...
                            cell2mat(family2tango(VCMFamily,'Setpoint',FB.VCMlist(VCMnum(1),:))));
                    end

                    if any(VCMSP_next > MaxSP - 1)
                        VCMnum = find(VCMSP_next > MaxSP - 1);
                        for ik = 1:length(VCMnum)
                            fprintf('**Vertical correctors %s is above %f! \n', ...
                                cell2mat(family2tango(VCMFamily,'Setpoint',FB.VCMlist(VCMnum(ik),:))), ...
                                MaxSP(VCMnum(ik)) - 1);
                        end
                        fprintf('%s\n',datestr(now));
                        fprintf('**The orbit correction is still working but this problem should be investigated. \n');
                    end

                    if any(VCMSP_next < MinSP + 1)
                        VCMnum = find(VCMSP_next < MinSP + 1);
                        for ik = 1:length(VCMnum)
                            fprintf('**Vertical correctors %s is below %f! \n', ...
                                cell2mat(family2tango(VCMFamily,'Setpoint',FB.VCMlist(VCMnum(ik),:))), ...
                                MinSP(VCMnum(ik)) + 1);
                        end
                        fprintf('%s\n',datestr(now));
                        fprintf('**The orbit correction is still working but this problem should be investigated. \n');
                    end
                end

                %%%%%%%%%%%%%%%%%%%%%%


                if (get(findobj(gcbf,'Tag','ORBITCTRLCheckboxHcorrection'),'Value') == 1) && HOrbitCorrectionFlag 
                    % Correct horizontal orbit
                    FB.OCSx = setorbit(FB.OCSx,'NoDisplay');
                end

                if (get(findobj(gcbf,'Tag','ORBITCTRLCheckboxVcorrection'),'Value') == 1) && VOrbitCorrectionFlag
                    % Correct vertical orbit
                    FB.OCSy = setorbit(FB.OCSy,'NoDisplay');
                end

                % Check for current in machine - stop orbit correction if
                % DCCT < DCCTMIN
                if (getdcct < DCCTMIN)
                    error('**There is less than %d in the machine! Stopping orbit correction.', DCCTMIN);
                end

                % Residual orbit
                Horbit = getx(FB.OCSx.BPM.DeviceList);
                Vorbit = gety(FB.OCSy.BPM.DeviceList);
                
                x = FB.OCSx.GoalOrbit - Horbit;
                y = FB.OCSy.GoalOrbit - Vorbit;

                fprintf('   %d. Horizontal RMS = %.3f mm (absolute %.3f mm)\n', iloop, std(x), std(Horbit));
                fprintf('   %d.   Vertical RMS = %.3f mm (absolute %.3f mm)\n', iloop, std(y), std(Vorbit));
                
                pause(0);

            catch
                fprintf('   %s \n',lasterr);
                fprintf('   Orbit correction failed due to error condition!\n  Fix the problem, reload the lattice (refreshthering), and try again.  \n\n');
                return
            end
        end

        fprintf('   %s \n', datestr(clock));
        fprintf('   *********************************\n');
        fprintf('   **  Orbit Correction Complete  **\n');
        fprintf('   *********************************\n\n');

    case 'FeedbackSetup' % Slow orbit Feedback (SOFB)

        InitFlag = Input2;           % Input #2: if InitFlag, then initialize variables

        if InitFlag % Used only at startup
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Edit the following lists to change default configuration of Orbit Correction %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % WARNING CAN BE DIFFERENT FROM THE ORBIT CORRECTION
            % To start with same correctors and Bpms are used as in manual
            % coorection
            % Corrector magnets
            [HCMlist VCMlist BPMlist] = getlocallist;

            % Singular value number
            Xivec = 1:88;
            Yivec = 1:88;

            % Get goal orbit for SOFB
            Xgoal = getgolden(BPMxFamily, BPMlist);
            Ygoal = getgolden(BPMyFamily, BPMlist);

        else % use for SOFB Edition

            % Get FB structure
            FB = get(findobj(gcbf,'Tag','ORBITCTRLButtonFeedbackSetup'),'Userdata');

            BPMlist = FB.BPMlist;
            HCMlist = FB.HCMlist;
            VCMlist = FB.VCMlist;

            Xivec = FB.Xivec;
            Yivec = FB.Yivec;

            Xgoal = FB.Xgoal;
            Ygoal = FB.Ygoal;


            % Add button to change #ivectors, cm
            EditFlag = 0;
            h_fig1 = figure;

            while EditFlag ~= 6

                % get Sensitivity matrices
                Sx = getrespmat(BPMxFamily, BPMlist, HCMFamily, HCMlist, [], SR_GEV);
                Sy = getrespmat(BPMyFamily, BPMlist, VCMFamily, VCMlist, [], SR_GEV);

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

                % Display singular value plot
                figure(h_fig1);
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

                % Build up menu edition
                EditFlag = menu('Change Parameters?','Singular Values','HCM List','VCM List', ...
                    'BPM List','Change the Goal Orbit', 'Return');

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
                                if any(XivecNew<=0) || max(XivecNew)>length(diag(SVx))
                                    disp('   Error reading horizontal singular value vector.  No change made.');
                                else
                                    Xivec = XivecNew;
                                end
                            end
                            YivecNew = fix(str2num(answer{2}));
                            if isempty(YivecNew)
                                disp('   Vertical singular value vector cannot be empty.  No change made.');
                            else
                                if any(YivecNew<=0) || max(YivecNew)>length(diag(SVy))
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

                                if isempty(k) || isempty(l)
                                    % Item not in list
                                else
                                    CheckList(i) = 1;
                                end
                            end
                        end

                        % User edition of the BPM lsit
                        newList = editlist(List, 'BPM', CheckList);
                        if isempty(newList)
                            fprintf('   BPM list cannot be empty.  No change made.\n');
                        else
                            BPMlist = newList;
                        end

                        % Set the goal orbit to the golden orbit
                        Xgoal = getgolden(BPMxFamily, BPMlist);
                        Ygoal = getgolden(BPMyFamily, BPMlist);

                        %if a new BPM is added, then set the goal orbit to
                        %the golden orbit.
                        % Otherwise keep the present goal orbit
                        for i = 1:size(BPMlist,1)

                            % Is it a new BPM?
                            k = find(BPMlist(i,1)==ListOld(:,1));
                            l = find(BPMlist(i,2)==ListOld(k,2));

                            if isempty(k) || isempty(l)
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
            close(h_fig1);
        end

        % End of SOFB edition switchyard

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         Build up SOFB Structures       %
        %  for setorbit programme : OCSx and OCSy%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  ORBIT CORRECTION STRUCTURE (OCS)
        %    OCS.BPM (data structure)
        %    OCS.CM  (data structure)
        %    OCS.GoalOrbit
        %    OCS.NIter
        %    OCS.SVDIndex
        %    OCS.IncrementalFlag = 'Yes'/'No'
        %    OCS.BPMWeight
        %    OCS.Flags = { 'FitRF' , etc.  }

        OCSx.BPM = getx(BPMlist, 'struct');
        OCSx.CM =  getsp(HCMFamily, HCMlist, 'struct');
        OCSx.GoalOrbit = Xgoal;
        OCSx.NIter = 2;
        OCSx.SVDIndex = Xivec;
        OCSx.IncrementalFlag = 'No';
        %OCSx.BPMWeight = [];
        OCSx.FitRF = 0;
        OCSy.BPM = gety(BPMlist, 'struct');
        OCSy.CM = getsp(VCMFamily, VCMlist, 'struct');
        OCSy.GoalOrbit = Ygoal;
        OCSy.NIter = 2;
        OCSy.SVDIndex = Yivec;
        OCSy.IncrementalFlag = 'No';
        %OCSy.BPMWeight = [];
        OCSy.FitRF = 0;

        % Save SOFB strucutre
        FB.OCSx = OCSx;
        FB.OCSy = OCSy;

        % BPM and CM list
        FB.BPMlist = BPMlist;
        FB.HCMlist = HCMlist;
        FB.VCMlist = VCMlist;

        % Singular value number
        FB.Xivec = Xivec;
        FB.Yivec = Yivec;

        % Goal orbit list
        FB.Xgoal = Xgoal;
        FB.Ygoal = Ygoal;

        % save Feedback struture
        set(findobj(gcbf,'Tag','ORBITCTRLButtonFeedbackSetup'),'Userdata',FB);

    case 'Feedback'

        %FBloopIter = 3; % number of iterations for each loop

        FEEDBACK_STOP_FLAG = 0;

        % Warning Flag for stale correctors
        HWarnNum = 0;
        VWarnNum = 0;

        % Feedback loop setup
        LoopDelay = 10.0;    % Period of feedback loop [seconds], make sure the BPM averaging is correct

        % Percentage of correction to apply at each iteration
        Xgain  = 0.8;
        Ygain  = 0.8;

        % Minimum corrector strength for applying correction
        %dhcmStd = 0.0015/4;
        %dvcmStd = 0.0005/2;
        dhcmStd = 0.0015/15;
        dvcmStd = 0.0005/5;

        % Maximum allowed frequency shift during a single correction
        deltaRFmax = 1000e-6; % MHz
        deltaRFmin = 0.3e-16; % MHz 

        % Load lattice set for tune feed forward

        set(0,'showhiddenhandles','on');

        try
            fprintf('\n');
            fprintf('   *******************************\n');
            fprintf('   **  Starting Orbit Feedback  **\n');
            fprintf('   *******************************\n');
            fprintf('   %s \n', datestr(clock));
            fprintf('   Note: the Matlab command window will be used to display status information.\n');
            fprintf('         It cannot be used to enter commands during slow orbit feedback.\n');

            % Get SOFB Structure
            FB = get(findobj(gcbf,'Tag','ORBITCTRLButtonFeedbackSetup'),'Userdata');
            if get(findobj(gcbf,'Tag','ORBITCTRLCheckboxRF'),'Value') == 1
                FB.OCSx.FitRF = 1;
            else
                FB.OCSx.FitRF = 0;
            end

            % look for already running SOFB
            %val = readattribute('ANS/DG/PUB-SOFB/state');
            %if val == 1
            %    error('SOFB already running. Stop other application first!')
            %end
        catch
            fprintf('\n  %s \n',lasterr);
            fprintf('   %s \n', datestr(clock));
            fprintf('   *************************************************************\n');
            fprintf('   **  Orbit feedback could not start due to error condition  **\n');
            fprintf('   *************************************************************\n\n');
            set(0,'showhiddenhandles','off');
            pause(0);
            return
        end

        % Confirmation dialogbox
        StartFlag = questdlg('Start orbit feedback?', 'Orbit Feedback','Yes','No','No');
        set(findobj(gcbf,'Tag','ORBITCTRLStaticTextInformation'),'String','SOFB Started');

        if strcmp(StartFlag,'No')
            fprintf('   %s \n', datestr(clock));
            fprintf('   ***************************\n');
            fprintf('   **  Orbit Feedback Exit  **\n');
            fprintf('   ***************************\n\n');
            pause(0);
            return
        end

        set(0,'showhiddenhandles','on');

        % Display information

        if get(findobj(gcbf,'Tag','ORBITCTRLCheckboxHSOFB'),'Value') == 1
            fprintf('   Using %d singular values horizontally.\n', length(FB.Xivec));
        end
        if get(findobj(gcbf,'Tag','ORBITCTRLCheckboxVSOFB'),'Value') == 1
            fprintf('   Using %d singular values vertically.\n',   length(FB.Yivec));
        end
        fprintf('   Starting slow orbit correction every %.1f seconds.\n', LoopDelay);

        try
            % Compute residual closed orbit
            x = FB.Xgoal - getx(FB.BPMlist);
            y = FB.Ygoal - gety(FB.BPMlist);

            %STDx = norm(x)/sqrt(length(x));
            %STDy = norm(y)/sqrt(length(y));
            STDx = std(x);
            STDy = std(y);

            set(findobj(gcbf,'Tag','ORBITCTRLStaticTextHorizontal'),'String', ...
                sprintf('Horizontal RMS = %.4f mm',STDx),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','ORBITCTRLStaticTextVertical'),'String', ...
                sprintf('Vertical RMS = %.4f mm',STDy),'ForegroundColor',[0 0 0]);
            % SOFB Flag set to true in TANGO
            %tango_write_attribute2('ANS/DG/PUB-SOFB','state',uint8(1));
            pause(0);
        catch

            fprintf('\n  %s \n',lasterr);

            fprintf('   %s \n', datestr(clock));
            fprintf('   *************************************************************\n');
            fprintf('   **  Orbit feedback could not start due to error condition  **\n');
            fprintf('   *************************************************************\n\n');

            set(0,'showhiddenhandles','off');
            pause(0);
            return
        end


        % Disable buttons in GUI
        set(0,'showhiddenhandles','on');
        set(findobj(gcbf,'Tag','ORBITCTRLPushbuttonStart'),'Enable','off');
        set(findobj(gcbf,'Tag','ORBITCTRLPushbuttonStop'),'Enable','on');
        set(findobj(gcbf,'Tag','ORBITCTRLButtonOrbitCorrection'),'Enable','off');
        set(findobj(gcbf,'Tag','ORBITCTRLButtonOrbitCorrectionSetup'),'Enable','off');
        set(findobj(gcbf,'Tag','ORBITCTRLButtonFeedbackSetup'),'Enable','off');
        set(findobj(gcbf,'Tag','ORBITCTRLClose'),'Enable','off');
        set(findobj(gcbf,'Tag','ORBITCTRLCheckboxHSOFB'),'Enable','off');
        set(findobj(gcbf,'Tag','ORBITCTRLCheckboxVSOFB'),'Enable','off');
        set(findobj(gcbf,'Tag','ORBITCTRLCheckboxHcorrection'),'Enable','off');
        set(findobj(gcbf,'Tag','ORBITCTRLCheckboxVcorrection'),'Enable','off');
        set(findobj(gcbf,'Tag','ORBITCTRLCheckboxRF'),'Enable','off');
        set(findobj(gcbf,'Tag','ORBITCTRLCheckboxSOFB'),'Enable','off')
        set(findobj(gcbf,'Tag','ORBITCTRLCheckboxFOFB'),'Enable','off')
        pause(0);


        % Initialize feedback loop
        StartTime = gettime;
        StartErrorTime = gettime;

        % Get orbit before SOFB startup
        Xold = getx(FB.BPMlist);
        Yold = gety(FB.BPMlist);
        % Stale number
        RF_frequency_stalenum = 0;
        %pause(LoopDelay);

        % Number of steerer magnet corrector
        N_HCM = size(FB.HCMlist,1);
        N_VCM = size(FB.VCMlist,1);

        % Number of RF actuator
        N_RFMO = 1;

        %%%%%%%%%%%%%%%%%%%%%%%
        % Start feedback loop %
        %%%%%%%%%%%%%%%%%%%%%%%

        setappdata(findobj(gcbf,'Tag','ORBITCTRLFig1'),'FEEDBACK_STOP_FLAG',0);

        while FEEDBACK_STOP_FLAG == 0 % infinite loop
            try
                t00 = gettime;
                fprintf('Iteration time %s\n',datestr(clock));

                % Check if GUI has been closed
                if isempty(gcbf)
                    FEEDBACK_STOP_FLAG = 1;
                    lasterr('SRCONTROL GUI DISAPPEARED!');
                    error('SRCONTROL GUI DISAPPEARED!');
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Horizontal plane "feedback" %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Get orbit and check that the BPMs are different from the last update
                Xnew = getx(FB.BPMlist);

                if getdcct < DCCTMIN     % Don't feedback if the current is too small
                    FEEDBACK_STOP_FLAG = 1;
                    fprintf('%s         Orbit feedback stopped due to low beam current (<%d mA)\n',datestr(now), DCCTMIN);
                    break;
                end

                x = FB.Xgoal - Xnew;
                STDx = std(x);

                if get(findobj(gcbf,'Tag','ORBITCTRLCheckboxHSOFB'),'Value') == 1
                    if any(Xold == Xnew)
                        N_Stale_Data_Points = find((Xold==Xnew)==1);
                        for i = N_Stale_Data_Points'
                            fprintf('   Stale data: BPMx(%2d,%d), feedback step skipped (%s). \n', ...
                                FB.BPMlist(i,1), FB.BPMlist(i,2), datestr(clock));
                        end
                    else
                        % Compute horizontal correction
                        FB.OCSx = setorbit(FB.OCSx,'Nodisplay','Nosetsp');

                        X = Xgain .* FB.OCSx.CM.Delta;

                        % check for corrector values and next step values, warn or stop FB as necessary
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        HCMSP = getsp(HCMFamily, FB.HCMlist);  % present corrector values
                        HCMSP_next = HCMSP + X(1:N_HCM);       % next corrector values, just slow correctors (no RF)

                        MaxSP = maxsp(HCMFamily,FB.HCMlist);
                        MinSP = minsp(HCMFamily,FB.HCMlist);

                        if any(MaxSP - HCMSP_next  < 0)
                            HCMnum = find(HCMSP_next > MaxSP);
                            % message to screen
                            fprintf('**One or more of the horizontal correctors is at its maximum positive value!! Stopping orbit feedback. \n');
                            fprintf('%s\n',datestr(now));
                            fprintf('**%s is one of the problem correctors.\n', ...
                                cell2mat(family2tango(HCMFamily,'Setpoint',FB.HCMlist(HCMnum(1),:))));
                            FEEDBACK_STOP_FLAG = 1;
                        end

                        if any(MinSP - HCMSP_next  > 0)
                            HCMnum = find(HCMSP_next < MinSP);
                            % message to screen
                            fprintf('**One or more of the horizontal correctors is at its maximum negative value!! Stopping orbit feedback. \n');
                            fprintf('%s\n',datestr(now));
                            fprintf('**%s is one of the problem correctors.\n', ...
                                cell2mat(family2tango(HCMFamily,'Setpoint',FB.HCMlist(HCMnum(1),:))));
                            FEEDBACK_STOP_FLAG = 1;
                        end

                        pause(0);

                        if any(HCMSP_next > MaxSP - 1)
                            HCMnum = find(HCMSP_next > MaxSP - 1);
                            for ik = 1:length(HCMnum)
                                HWarnNum = HWarnNum+1;
                                fprintf('**Horizontal correctors %s is above %f! \n', ...
                                    cell2mat(family2tango(HCMFamily,'Setpoint',FB.HCMlist(HCMnum(ik),:))), ...
                                    MaxSP(HCMnum(ik)) - 1);
                            end
                            fprintf('%s\n',datestr(now));
                            fprintf('**The orbit feedback is still working but this problem should be investigated. \n');
                        end

                        if any(HCMSP_next < MinSP + 1)
                            HCMnum = find(HCMSP_next < MinSP + 1);
                            for ik = 1:length(HCMnum)
                                HWarnNum = HWarnNum+1;
                                fprintf('**Horizontal correctors %s is below %f! \n', ...
                                    cell2mat(family2tango(HCMFamily,'Setpoint',FB.HCMlist(HCMnum(ik),:))), ...
                                    MinSP(HCMnum(ik)) + 1);
                            end
                            fprintf('%s\n',datestr(now));
                            fprintf('**The orbit feedback is still working but this problem should be investigated. \n');
                        end

                        if getdcct < DCCTMIN     % Don't feedback if the current is too small
                            FEEDBACK_STOP_FLAG = 1;
                            fprintf('%s         Orbit feedback stopped due to low beam current (<%d mA)\n',datestr(now), DCCTMIN);
                            break;
                        end

                        % Apply new corrector values

                        if N_HCM > 0 && std(X(1:N_HCM)) > dhcmStd
                            profibus_sync(HCMFamily); pause(0.2);
                            stepsp(HCMFamily, X(1:N_HCM), FB.HCMlist, 0);
                            profibus_unsyncall(HCMFamily);
                        else
                            fprintf('No horizontal correction  applied, std corrector = %5.4f mA rms < threshold = %5.4f \n', ...
                                std(X(1:N_HCM)),dhcmStd);
                        end

                        % Apply RF correction

                        if FB.OCSx.FitRF
                            deltaRF = Xgain .* FB.OCSx.DeltaRF;
                            if N_RFMO > 0
                                RFfrequency_last = getrf;
                                fprintf('RF frequency shift to be applied is %5.1f Hz \n', hw2physics('RF','Setpoint', deltaRF));

                                if abs(deltaRF) > deltaRFmin % MHz
                                    if abs(deltaRF) < deltaRFmax % For avoiding too large RF step on orbit
                                        steprf(deltaRF); 
                                        fprintf('RF change applied by %5.1f Hz\n', ...
                                            hw2physics('RF','Setpoint', deltaRF));
                                    else
                                        warning('RF change too large: %5.1f Hz (max is %5.1f Hz)', ...
                                            hw2physics('RF','Setpoint', deltaRF), hw2physics('RF','Setpoint', deltaRFmax));
                                        steprf(deltaRFmax*sign(deltaRF));
                                        fprintf('RF change applied by %5.1f Hz\n', hw2physics('RF','Setpoint', deltaRFmax*sign(deltaRF)));
                                    end

                                    RFfrequency_now = getrf;

                                    % Check for stale RF feedback

                                    if RFfrequency_last == RFfrequency_now
                                        RF_frequency_stalenum = RF_frequency_stalenum + 1;
                                        if RF_frequency_stalenum == 30 % - warn and message if stale for 30 secs
                                            fprintf('**The RF is not responding to orbit feedback changes! \n');
                                            fprintf('%s\n',datestr(now));
                                            fprintf('**The orbit feedback is still working but this problem should be investigated. \n');
                                        end
                                        if rem(RF_frequency_stalenum,120)==0 % - message to screen every 2 minutes
                                            fprintf('**The RF is not responding to orbit feedback changes! (%s)\n',datestr(now));
                                        end
                                    else
                                        RF_frequency_stalenum = 0;
                                    end

                                    fprintf('RF Done: time = %f \n', gettime-t00);
                                end
                            end
                        end
                    end

                    Xold = Xnew;
                end % End horizontal correction


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Vertical plane "feedback" %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Get orbit and check that the BPMs are different from the last update
                Ynew = gety(FB.BPMlist);

                if getdcct < DCCTMIN     % Don't feedback if the current is too small
                    FEEDBACK_STOP_FLAG = 1;
                    fprintf('%s         Orbit feedback stopped due to low beam current (< %d mA)\n', datestr(now), DCCTMIN);
                    break;
                end

                y = FB.Ygoal - Ynew;
                STDy = norm(y)/sqrt(length(y));


                if get(findobj(gcbf,'Tag','ORBITCTRLCheckboxVSOFB'),'Value') == 1

                    if any(Yold == Ynew)
                        fprintf('Info: Stale vertical BPM data, feedback step skipped (%s). \n', datestr(clock));
                        N_Stale_Data_Points = find((Yold==Ynew)==1);
                        for i = N_Stale_Data_Points'
                            fprintf('   Stale data: BPMz(%2d,%d), feedback step skipped (%s). \n', ...
                                FB.BPMlist(i,1), FB.BPMlist(i,2), datestr(clock));
                        end

                    else

                        FB.OCSy = setorbit(FB.OCSy,'Nodisplay','Nosetsp');

                        % set to gains for correction
                        Y = Ygain .* FB.OCSy.CM.Delta;

                        % check for trim values+next step values, warn or stop FB as necessary

                        VCMSP = getsp(VCMFamily,FB.VCMlist); % Get corrector values before correction
                        VCMSP_next = VCMSP + Y(1:N_VCM); % New corrector values to be set in


                        pause(0);

                        if getdcct < DCCTMIN     % Don't feedback if the current is too small
                            fprintf('%s         Orbit feedback stopped due to low beam current (<%d mA)\n',datestr(now), DCCTMIN);
                            FEEDBACK_STOP_FLAG = 1;
                            break;
                        end

                        MaxSP = maxsp(VCMFamily,FB.VCMlist);
                        MinSP = minsp(VCMFamily,FB.VCMlist);

                        if any(MaxSP - VCMSP_next  < 0)
                            VCMnum = find(VCMSP_next > MaxSP);
                            % message to screen
                            fprintf('**One or more of the vertical correctors is at its maximum positive value!! Stopping orbit feedback. \n');
                            fprintf('%s\n',datestr(now));
                            fprintf('**%s is one of the problem correctors.\n', ...
                                cell2mat(family2tango(VCMFamily,'Setpoint',FB.VCMlist(VCMnum(1),:))));
                            FEEDBACK_STOP_FLAG = 1;
                        end

                        if any(MinSP - VCMSP_next  > 0)
                            VCMnum = find(VCMSP_next < MinSP);
                            % message to screen
                            fprintf('**One or more of the vertical correctors is at its maximum negative value!! Stopping orbit feedback. \n');
                            fprintf('%s\n',datestr(now));
                            fprintf('**%s is one of the problem correctors.\n', ...
                                cell2mat(family2tango(VCMFamily,'Setpoint',FB.VCMlist(VCMnum(1),:))));
                            FEEDBACK_STOP_FLAG = 1;
                        end

                        pause(0);

                        if any(VCMSP_next > MaxSP - 1)
                            VCMnum = find(VCMSP_next > MaxSP - 1);
                            for ik = 1:length(VCMnum)
                                VWarnNum = VWarnNum+1;
                                fprintf('**Vertical correctors %s is above %f! \n', ...
                                    cell2mat(family2tango(VCMFamily,'Setpoint',FB.VCMlist(VCMnum(ik),:))), ...
                                    MaxSP(VCMnum(ik)) - 1);
                            end
                            fprintf('%s\n',datestr(now));
                            fprintf('**The orbit feedback is still working but this problem should be investigated. \n');
                        end

                        if any(VCMSP_next < MinSP + 1)
                            VCMnum = find(VCMSP_next < MinSP + 1);
                            for ik = 1:length(VCMnum)
                                VWarnNum = VWarnNum+1;
                                fprintf('**Vertical correctors %s is below %f! \n', ...
                                    cell2mat(family2tango(VCMFamily,'Setpoint',FB.VCMlist(VCMnum(ik),:))), ...
                                    MinSP(VCMnum(ik)) + 1);
                            end
                            fprintf('%s\n',datestr(now));
                            fprintf('**The orbit feedback is still working but this problem should be investigated. \n');
                        end

                        % Apply vertical correction
                        if N_VCM > 0 && std(Y(1:N_VCM)) > dvcmStd
                            profibus_sync(VCMFamily); pause(0.2);
                            stepsp(VCMFamily, Y(1:N_VCM), FB.VCMlist, 0);
                            profibus_unsyncall(VCMFamily);
                        else
                            fprintf('No vertical correction  applied, std corrector = %5.4f mA rms < threshold = %5.4f \n', ...
                                std(Y(1:N_VCM)),dvcmStd);
                        end
                    end
                end

                Yold = Ynew;

                % Output info to screen
                set(findobj(gcbf,'Tag','ORBITCTRLStaticTextHorizontal'), ...
                    'String',sprintf('Horizontal RMS = %.4f mm',STDx), ...
                    'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','ORBITCTRLStaticTextVertical'), ...
                    'String',sprintf('Vertical RMS = %.4f mm',STDy),...
                    'ForegroundColor',[0 0 0]);
                pause(0);

                % Wait for next update time or stop request
                while (gettime-t00) < LoopDelay
                    pause(.1);
                    % Check if GUI has been closed
                    if isempty(gcbf)
                        FEEDBACK_STOP_FLAG = 1;
                        lasterr('SRCONTROL GUI DISAPPEARED!');
                        error('SRCONTROL GUI DISAPPEARED!');
                    end
                    if FEEDBACK_STOP_FLAG == 0
                        FEEDBACK_STOP_FLAG = getappdata(findobj(gcbf,'Tag','ORBITCTRLFig1'),'FEEDBACK_STOP_FLAG');
                    end
                end

                StartErrorTime = gettime;

            catch
                fprintf('\n  %s \n',lasterr);
                FEEDBACK_STOP_FLAG = 1;
            end

            % Check whether user asked for stopping SOFB
            if FEEDBACK_STOP_FLAG == 0
                FEEDBACK_STOP_FLAG = getappdata(findobj(gcbf,'Tag','ORBITCTRLFig1'),'FEEDBACK_STOP_FLAG');
                %pause(0.3);
                %disp('Pause to be removed bug SP2');
            end


        end  % End of feedback loop


        % End feedback, reset all parameters
        try

            % Enable buttons
            set(findobj(gcbf,'Tag','ORBITCTRLPushbuttonStart'),'Enable','on');
            set(findobj(gcbf,'Tag','ORBITCTRLPushbuttonStop'),'Enable','off');
            set(findobj(gcbf,'Tag','ORBITCTRLButtonOrbitCorrection'),'Enable','on');
            set(findobj(gcbf,'Tag','ORBITCTRLButtonOrbitCorrectionSetup'),'Enable','on');
            set(findobj(gcbf,'Tag','ORBITCTRLButtonFeedbackSetup'),'Enable','on');
            set(findobj(gcbf,'Tag','ORBITCTRLClose'),'Enable','on');
            set(findobj(gcbf,'Tag','ORBITCTRLCheckboxHSOFB'),'Enable','on');
            set(findobj(gcbf,'Tag','ORBITCTRLCheckboxVSOFB'),'Enable','on');
            set(findobj(gcbf,'Tag','ORBITCTRLCheckboxHcorrection'),'Enable','on');
            set(findobj(gcbf,'Tag','ORBITCTRLCheckboxVcorrection'),'Enable','on');
            set(findobj(gcbf,'Tag','ORBITCTRLCheckboxRF'),'Enable','on');
            set(findobj(gcbf,'Tag','ORBITCTRLCheckboxSOFB'),'Enable','on')
            set(findobj(gcbf,'Tag','ORBITCTRLCheckboxFOFB'),'Enable','on')
            set(findobj(gcbf,'Tag','ORBITCTRLStaticTextHorizontal'),'String',sprintf('Horizontal RMS = _____ mm'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','ORBITCTRLStaticTextVertical'),'String',sprintf('Vertical RMS = _____ mm'),'ForegroundColor',[0 0 0]);
            pause(0);

        catch

            % GUI must have been closed

        end

        fprintf('   %s \n', datestr(clock));
        fprintf('   ******************************\n');
        fprintf('   **  Orbit Feedback Stopped  **\n');
        fprintf('   ******************************\n\n');
        set(0,'showhiddenhandles','off');
        pause(0);
        % SOFB Flag set to false in TANGO
        %tango_write_attribute2('ANS/DG/PUB-SOFB','state',uint8(0));

    otherwise
        fprintf('   Unknown action name: %s.\n', action);

end


function [HCMlist, VCMlist, BPMlist] = getlocallist

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Edit the following lists to change default configuration of Orbit Correction %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

HCMlist = [
      1     1
     1     2
     1     3
     1     4
     1     5
     2     1
     2     2
     2     3
     2     4
     2     5
     2     6
     3     1
     3     2
     3     3
     3     4
     3     5
     3     6
     4     1
     4     2
     4     3
     4     4
     4     5
     5     1
     5     2
     5     3
     5     4
     5     5
     6     1
     6     2
     6     3
     6     4
     6     5
     6     6
     7     1
     7     2
     7     3
     7     4
     7     5
     7     6
     8     1
     8     2
     8     3
     8     4
     8     5
     9     1
     9     2
     9     3
     9     4
     9     5
    10     1
    10     2
    10     3
    10     4
    10     5
    10     6
    11     1
    11     2
    11     3
    11     4
    11     5
    11     6
    12     1
    12     2
    12     3
    12     4
    12     5
    13     1
    13     2
    13     3
    13     4
    13     5
    14     1
    14     2
    14     3
    14     4
    14     5
    14     6
    15     1
    15     2
    15     3
    15     4
    15     5
    15     6
    16     1
    16     2
    16     3
    16     4
    16     5];

VCMlist = [
        1     1
     1     2
     1     3
     1     4
     1     5
     2     1
     2     2
     2     3
     2     4
     2     5
     2     6
     3     1
     3     2
     3     3
     3     4
     3     5
     3     6
     4     1
     4     2
     4     3
     4     4
     4     5
     5     1
     5     2
     5     3
     5     4
     5     5
     6     1
     6     2
     6     3
     6     4
     6     5
     6     6
     7     1
     7     2
     7     3
     7     4
     7     5
     7     6
     8     1
     8     2
     8     3
     8     4
     8     5
     9     1
     9     2
     9     3
     9     4
     9     5
    10     1
    10     2
    10     3
    10     4
    10     5
    10     6
    11     1
    11     2
    11     3
    11     4
    11     5
    11     6
    12     1
    12     2
    12     3
    12     4
    12     5
    13     1
    13     2
    13     3
    13     4
    13     5
    14     1
    14     2
    14     3
    14     4
    14     5
    14     6
    15     1
    15     2
    15     3
    15     4
    15     5
    15     6
    16     1
    16     2
    16     3
    16     4
    16     5
    ];
BPMlist = [
       1     1
     1     2
     1     4
     1     6
     1     7
     2     1
     2     2
     2     4
     2     5
     2     7
     2     8
     3     1
     3     2
     3     4
     3     5
     3     7
     3     8
     4     1
     4     2
     4     4
     4     6
     4     7
     5     1
     5     2
     5     4
     5     6
     5     7
     6     1
     6     2
     6     4
     6     5
     6     7
     6     8
     7     1
     7     2
     7     4
     7     5
     7     7
     7     8
     8     1
     8     2
     8     4
     8     6
     8     7
     9     1
     9     2
     9     4
     9     6
     9     7
    10     1
    10     2
    10     4
    10     5
    10     7
    10     8
    11     1
    11     2
    11     4
    11     5
    11     7
    11     8
    12     1
    12     2
    12     4
    12     6
    12     7
    13     1
    13     2
    13     4
    13     6
    13     7
    14     1
    14     2
    14     4
    14     5
    14     7
    14     8
    15     1
    15     2
    15     4
    15     5
    15     7
    15     8
    16     1
    16     2
    16     4
    16     6
    16     7
    ];

