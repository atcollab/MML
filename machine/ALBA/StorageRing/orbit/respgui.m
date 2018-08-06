function respgui(action, varargin)
% RESPGUI - Part treating of the response matrice and the correction
%
% INPUT
% 1. action among
% 
% PlotSVD_Init
% SVDotActive
% MoveDot
% DotUp
% PlotSVD
% SolveSystem
% BackSubSystem
% SVDEdit
% MoveSVDDot
% DisplayRFFit
% DisplayNsvd
% UpdateFit
% RFToggle
% ExternalFitOff
% FitOff
% DispersionPanel
% EtaXFlag
% EtaZFlag
% 


%
% Written by J. Corbett
% Adapted by Laurent S. Nadolski


% TODO etaflag and rfflag misused
% rfflag shoudl be for RF correction
% etaflag should be for Amman factor substraction (to be implemented)

%globals
global BPM COR RSP SYS

orbfig = findobj(0,'tag','orbfig');
plane  = SYS.plane;

switch action

    %==========================================================
    case 'PlotSVD_Init'                  % *** PlotSVD_Init ***
        %==========================================================
        %blue, solid dynamic semilog-line for singular value plot.
        set(SYS.ahsvd,'Color',[1 1 1],'NextPlot','add');
        %           'ButtonDownFcn','respgui(''SVDotActive'')');

        set(orbfig,'currentaxes',SYS.ahsvd)

        SYS.svdplot = plot(ones(1,RSP(plane).nsvd),'LineStyle','-', ...
            'Color','b'); %does this tag axes or line?
        grid on;
        SYS.lhsvd = SYS.svdplot;

        SYS.lhdot = line('parent',SYS.ahsvd,...
            'XData',0,'YData',0,...
            'ButtonDownFcn','respgui(''SVDotActive'');',...
            'Marker','o','MarkerSize',8,'MarkerFaceColor','r');


        %=============================================================
    case 'SVDotActive'                       % *** SVDotActive ***
        %=============================================================
        %used if mouse clicks on SVD plot dot or anywhere in SVD window
        %activate window-button-motion
        set(orbfig,'WindowButtonMotionFcn','respgui(''MoveDot'');',...
            'WindowButtonUpFcn','respgui(''DotUp'')');

        %==========================================================
    case 'MoveDot'                            % *** MoveDot ***
        %==========================================================
        %The callback of the singular value plot dot drag
        cpa             = get(SYS.ahsvd,'CurrentPoint');
        RSP(plane).nsvd = round(cpa(1));

        %check for out-of-range drag above
        if RSP(plane).nsvd > RSP(plane).nsvdmax
            RSP(plane).nsvd = RSP(plane).nsvdmax;
        end

        %check for out-of-range drag below
        if RSP(plane).nsvd <= 0
            RSP(plane).nsvd = 1;            
        end

        setappdata(0,'RSP',RSP);

        %re-draw dot
        % vector of singular values
        ydat = diag(RSP(plane).S);
        % index of the dot
        indx = RSP(plane).nsvd;
        
        if indx <= 0, indx = 1; end

        set(SYS.lhdot,'Xdata',RSP(plane).nsvd,'YData',ydat(indx));

        %==========================================================
    case 'DotUp'                            % *** DotUp ***
        %==========================================================
        respgui('MoveDot');

        set(orbfig,'WindowButtonMotionFcn','','WindowButtonUpFcn','');
        %update edit boxes
        set(SYS.svdedit,'String',num2str(RSP(plane).nsvd));

        orbgui('RefreshOrbGUI');

        %==========================================================
    case 'PlotSVD'                             % ***PlotSVD ***
        %==========================================================
        %blue, solid dynamic line for singular value plot
        set(orbfig,'currentaxes',SYS.ahsvd);
        %...must have fit valid before plotting
        if RSP(plane).nsvdmax > 1 && RSP(plane).fit == 1 
            k      = RSP(plane).nsvdmax;
            ydat   = diag(RSP(plane).S);
            set(SYS.lhsvd,'Xdata',(1:k),'YData',ydat(1:k));
            % scale y absciss using log scale
            axis('tight');
            %red dot
            indx = RSP(plane).nsvd;
            if indx <= 0, indx = 1; end
            set(SYS.lhdot,'Xdata',RSP(plane).nsvd,'YData',ydat(indx));
        else %fit not valid
%             set(SYS.lhsvd,'Xdata',0:10,'YData',ones(1,11));
%             axis('tight');
            %no red dot
            set(SYS.lhdot,'Xdata',[],'YData',[]);
        end

        %==========================================================
    case 'SolveSystem'                    % *** SolveSystem ***
        %==========================================================
        %solve the system with requested technique (SYS.algo)
        % 1. check that bpms and correctors selected for fitting
        % 2. build total response matrix (orbit dispersion)
        % 3. build total constraint vector (orbit, dispersion)
        % 4. check dimensions of matrix, constraints
        % 5. perform inversion
        % 6. backsubstitute
        
        %check for no variables or constraints
        if isempty(BPM(plane).ifit) || isempty(COR(plane).ifit) 
            RSP(plane).fit = 0;
            BPM(plane).fit = zeros(length(BPM(plane).act),1);
            COR(plane).fit = COR(plane).act;
            setappdata(0,'RSP',RSP);
            setappdata(0,'BPM',BPM);
            setappdata(0,'COR',COR);

            if ~RSP(plane).rfflag %% RF fit only
                SYS.drf = 0;
                setappdata(0,'SYS',SYS);
                orbgui('LBox','Warning: select BPMs and CORs first');
                disp('Warning: select beam position monitors and correctors first');
                return
            end
        end

        %check for no singular values requested
        if RSP(plane).nsvd <= 0 && RSP(plane).svdtol <=0
            disp('   Warning: no singular values or tolerance requested in svdfit');
            return
        end

        %========================
        switch SYS.algo
            %========================
            case 'SVD'   %use singular value technique to solve system

                % Index the response matrix
                %...corrector set
                ActuatorDeviceList      = elem2dev(COR(plane).AOFamily,COR(plane).ifit);
                ActuatorDeviceListTotal = elem2dev(COR(plane).AOFamily);
                [corlist, iNotFound]    = findrowindex(ActuatorDeviceList, ActuatorDeviceListTotal);
                if ~isempty(iNotFound)
                    for i = iNotFound(:)',
                        fprintf('   %s(%d,%d) not found\n', S.Actuator.FamilyName, ...
                            ActuatorDeviceList(i,1), ActuatorDeviceList(i,2));
                    end
                    error('Actuator not found');
                end
%                 corwt   = COR(plane).wt(corlist);
  
%                 %remove dispersion component if rfflag true
%                 if RSP(plane).rfflag == 1                             %...subtract rf component
%                     [BPM] = etaoff(plane,BPM,RSP);                    %...calc dispersion component
%                 else
                    BPM(plane).rffit = zeros(length(BPM(plane).s),1); %...initialize to zero
%                 end
                setappdata(0,'BPM',BPM);

                %...electron BPM orbit and matrix (compressed)
%                 eBPMlist = BPM(plane).ifit;                                   %...electron BPM list
                MonitorDeviceList      = elem2dev(BPM(plane).AOFamily,BPM(plane).ifit);
                MonitorDeviceListTotal = elem2dev(BPM(plane).AOFamily);
                [eBPMlist, iNotFound]  = findrowindex(MonitorDeviceList,  MonitorDeviceListTotal);
                if ~isempty(iNotFound)
                    for i = iNotFound(:)'
                        fprintf('   %s(%d,%d) not found\n', S.Monitor.FamilyName, MonitorDeviceList(i,1), MonitorDeviceList(i,2));
                    end
                    error('Monitor not found');
                end

                eBPMval = BPM(plane).act - BPM(plane).des - BPM(plane).rffit;%...actual minus reference orbit
                eBPMval = BPM(plane).wt.*eBPMval;                            %...apply weights
                BPMval  = eBPMval(eBPMlist);                                 %...compress residual orbit vector

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Build up R-matrix
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                Rmat    = RSP(plane).Data(eBPMlist,corlist);%...use only selected fit indices
                wt      = diag(BPM(plane).wt(eBPMlist));    %...bpm weights on diagonal
                Rmat    = wt*Rmat;                          %...weight matrix lines w/ BPM weights before inversion

                %...add dispersion portion of orbit and matrix (compressed)
                %   NOTE - only electron BPMs selected for orbit fitting used for dispersion fitting
%                 if RSP(plane).etaflag                                %...check dispersion fitting flag
%                     etaBPMval = BPM(plane).dsp-BPM(plane).dspref;    %...actual minus reference dispersion
%                     etaBPMval = diag(BPM(plane).etawt)*etaBPMval(:); %...apply weights
%                     etaBPMval = etaBPMval(eBPMlist);                 %...compress residual dispersion vector
%                     BPMval    = [BPMval; etaBPMval];                 %...concatenate electron and dispersion BPM error signals
% 
%                     ceta = RSP(plane).eta(eBPMlist,corlist);        %...use only selected fit indices
%                     wt   = diag(BPM(plane).etawt(eBPMlist));         %...bpm weights on diagonal
%                     ceta = wt*ceta;                                  %...weight matrix before inversion
%                     Rmat = [Rmat; ceta];                             %...concatenate dispersion response matrix
%                 end

                if RSP(plane).etaflag && RSP(plane).rfflag          %...check dispersion fitting flag
                    eta  = RSP(plane).eta(eBPMlist);            %...use only selected fit indices
                    RFWeight = 10*mean(std(Rmat))/std(eta); %...bpm weights on diagonal
                    Rmat = [Rmat RFWeight*eta];             %...concatenate dispersion response matrix
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %...perform SVD decomposition
                %...A=USV'   A-1=VU'/S
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                [RSP(plane).U , RSP(plane).S, RSP(plane).V] = svd(Rmat,0);    
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Determine the singular vector and error check
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                
                %... get singular values  
                S    = diag(RSP(plane).S);
           
                %...reject zeros to get nb of nonzero singular values
                RSP(plane).nsvdmax = length(S(find(S)));      
                
                % Check whether singular value number larger than total number 
                if RSP(plane).nsvd > RSP(plane).nsvdmax
                    RSP(plane).nsvd = RSP(plane).nsvdmax;
                    fprintf('Warning: %d zero singular value(s) rejected\n', ...
                        RSP(plane).nsvd - RSP(plane).nsvdmax)
                end
                
                %...use tolerance method if specified
                if RSP(plane).svdtol == 0  % user given number
                    Ivect = 1:RSP(plane).nsvd;
                else % Tolerance
                    Ivect = find(S > RSP(plane).svdtol*S(1));
                    if isempty(Ivect)
                        disp('   Warning: no singular values requested in svdfit');
                        RSP(plane).fit = 0; % valid fit flag
                        return
                    end
                end

                %...backsubstitute
                %Computes first Rmat2=U(1,Ivect)*S(Ivect,Ivect) = Rmat*V(1,:Ivect)
                Rmat2          =  Rmat*RSP(plane).V(:,Ivect);   
                SUtBPM         = -Rmat2\BPMval;         
                Delcm =  RSP(plane).V(:,Ivect)*SUtBPM; %compute actuator values
                
                %% Fitted values for correctors
                if RSP(plane).etaflag && RSP(plane).rfflag % if RF correction
                    COR(plane).fit = Delcm(1:end-1);
                    SYS.drf        = RFWeight*Delcm(end);
                    %% update rf value and rf step for correction
                    set(SYS.hrf,'String', num2str(getrf(SYS.mode), '%10.7f'));
                    set(SYS.hdrf,'String',num2str(SYS.drf));
                else
                    COR(plane).fit = Delcm;
                end

                %NOTE: fraction scalar only used at time of corrector application

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %...compute predicted results
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
                
                % Note: use of RSP(plane).Data and not Rmat for orbit
                % predicted at all BPM required
                BPM(plane).fit = RSP(plane).Data(eBPMlist,corlist)*COR(plane).fit;

                %% Case of RF correction
                if RSP(plane).etaflag && RSP(plane).rfflag
                    BPM(plane).rffit = eta*SYS.drf; 
                end

                RSP(plane).fit = 1; %...set valid fit flag

                setappdata(0,'BPM',BPM);
                setappdata(0,'COR',COR);
                setappdata(0,'RSP',RSP);

            otherwise
                disp(['Warning: no CASE found in SolveSystem: ' SYS.algo]);
        end  %end SYS.algo switchyard

        %==========================================================
%     case 'BackSubSystem'                      % ***BackSubSystem ***
%         %==========================================================
%         %backsubstitute to find solution
%         switch SYS.algo
% 
%             case 'SVD'                                % ***BackSubSystem ***
%                 %callback of svdedit via SVDEdit
%                 %etaoff has already been called
% 
%                 [BPM,BL,COR]      = BackSubSystem(plane,SYS,BPM,BL,COR,RSP);  %also removes eta, bumps
%                 RSP(plane).nsvdes = RSP(plane).nsvd;
%                 RSP(plane).nsvd   = SVDMax(SYS,BPM,BL,COR,RSP);
%                 if RSP(plane).nsvd <= RSP(plane).nsvdes
%                     [BPM,COR] = BackSubSystem(plane,SYS,BPM,BL,COR,RSP);  %also removes eta, bumps
%                 end
% 
%                 setappdata(0,'BPM',BPM);
%                 setappdata(0,'COR',COR);
%                 setappdata(0,'RSP',RSP);
% 
%             otherwise
%                 disp(['Warning: no CASE found in BackSubSystem: ' algorithm]);
%         end  %end backsubsystem switchyard
% 
%         %==========================================================
    case 'SVDEdit'                            % *** SVDEdit ***
        %==========================================================
        %callback of the singular value edit box.

        val = str2double(get(SYS.svdedit,'String'));

        if isnan(val) || ~isnumeric(val) || ~length(val) == 1
            % flush the bad string out of the edit; replace with current value:
            set(SYS.svdedit,'String',num2str(RSP(plane).nsvd));
            orbgui('LBox','Warning: Invalid entry # singular values');
            disp('Warning: Invalid SVD entry.');
            return;
        else

            RSP(plane).nsvd = round(val);

            if RSP(plane).nsvd == 0        %don't allow zero singular values
                RSP(plane).nsvd = 1;
                set(SYS.svdedit,'String',num2str(RSP(plane).nsvd));
            end

            if RSP(plane).nsvd > RSP(plane).nsvdmax
                orbgui('LBox','Warning: # singular values exceeds maximum');
                disp(['Warning: number of singular values exceeds maximum: ',num2str(RSP(plane).nsvdmax)])
                RSP(plane).nsvd=RSP(plane).nsvdmax;
                set(SYS.svdedit,'String',num2str(RSP(plane).nsvd));
            end

            setappdata(0,'RSP',RSP);

            respgui('MoveSVDDot');
            orbgui('RefreshOrbGUI');

        end

%         %============================================================
%     case 'SVDSlider'                            % *** SVDSlide ***
%         %============================================================
%         %The callback of the singular value slider.
%         %
%         val = (get(SYS.svdslide,'Value'));
% 
%         RSP(plane).nsvd = round(val);
% 
% %         if RSP(plane).nsvd == 0
% %             RSP(plane).nsvd = 1;
% %         end
% 
%         if RSP(plane).nsvd > RSP(plane).nsvdmax
%             disp(['Warning: number of singular values exceeds maximum: ',num2str(RSP(plane).nsvdmax)])
%             RSP(plane).nsvd = RSP(plane).nsvdmax;
%             set(SYS.svdslide,'Value',RSP(plane).nsvd);
%         end
% 
%         setappdata(0,'RSP',RSP);
% 
%         set(SYS.svdedit,'String', num2str(RSP(plane).nsvd));
%         respgui('MoveSVDDot');
%         orbgui('RefreshOrbGUI');
% 
        %==========================================================
    case 'MoveSVDDot'                       % ***MoveSVDDot ***
        %==========================================================
        if isempty(COR(plane).ifit) || RSP(plane).rfflag, return; end
        
        % Vector of singular values
        yd = diag(RSP(plane).S);
        
        % default dot is user defined
        indx = RSP(plane).nsvd;

        if indx <= 0, indx = 1; end
        
        % check number of singular values
        %nb of correctors included RF
        ncor = length(COR(plane).ifit) + RSP(plane).rfflag; 
        if RSP(plane).nsvd > ncor 
            RSP(plane).nsvd = ncor;
            indx            = ncor;
        end

        % check fit 
        if RSP(plane).fit == 1
            %move the red dot
            set(SYS.lhdot,'Xdata',RSP(plane).nsvd,'YData',yd(indx));
        end

        setappdata(0,'RSP',RSP);
      
        %==========================================================
    case 'DisplayRFFit'                         % ***DisplayRFFit ***
        %==========================================================
        %update prediction for rf component
        if RSP(plane).rfflag == 1     %display rf component
            set(SYS.hdrf,'String', num2str(SYS.drf));
        end

        %==========================================================
    case 'DisplayNsvd'                     % ***DisplayNsvd ***
        %==========================================================
        %update SVD Slider
        %                                      'Value',round(RSP(plane).nsvd));
        %update SVD Edit Field
        set(SYS.svdedit,'String',num2str(RSP(plane).nsvd));

        %==========================================================
    case 'UpdateFit'                         % ***UpdateFit ***
        %==========================================================
      
        bpmgui('PlotFit');        %plots orbit fit, updates limits
        corgui('PlotFit');        %plots corrector fit (don't need to clear), updates ylimits
        respgui('DisplayRFFit');  %display rf frequency shift

        if strcmp(SYS.algo,'SVD')
            respgui('PlotSVD');       %...show singular value plot
            respgui('DisplayNsvd');   %...display number of singular values
            respgui('MoveSVDDot');    %...move dot to display number of singular values
            %update eigenvector plot
            if strcmpi(RSP(plane).eig(1:2), 'of') || RSP(plane).nsvd==0    %Eigenvector display mode
                set(SYS.lheig,'XData',[],'YData',[]);
            else
                bpmgui('PlotEig');                   %plot matrix column vector
            end
        end

        %update response matrix plot
        if strcmpi(RSP(plane).disp(1:2),'of')
            set(SYS.lhrsp,'XData',[],'YData',[]);
        else
            bpmgui('PlotResp');                   %plot matrix column vector
        end

        %==========================================================
    case 'RFToggle'                            % ***RFToggle***
        %==========================================================
        %callback of the rf component toggle radio button
        %radio button toggles state and then executes callback
        %hence, this routine finds the new state
        h1  = SYS.rftoggle;
        val = get(h1,'Value');
        if val == 1                    %state was just toggled 'on'
            RSP(plane).rfflag = 1;
            %add RF singular value
            RSP(plane).nsvdmax = RSP(plane).nsvdmax + 1;
            RSP(plane).nsvd = RSP(plane).nsvd + 1;
        else
            RSP(plane).rfflag = 0;     %state was just toggled 'off'
            %retrieve RF singular value
            RSP(plane).nsvdmax = RSP(plane).nsvdmax - 1;
            RSP(plane).nsvd = RSP(plane).nsvd - 1;
        end

        setappdata(0,'RSP',RSP);

        respgui('SolveSystem',SYS.algo);
        respgui('UpdateFit');

        %==========================================================
    case 'ExternalFitOff'                     %...ExternalFitOff
        %==========================================================
        plane = str2double(varargin{1});     %define requested plane
        RSP(plane).fit = 0;                  %fit not valid

        switch SYS.algo
            case 'SVD'
                RSP(plane).nsvd = 0;
                setappdata(0,'RSP',RSP);
        end


        %==========================================================
    case 'FitOff'                             %...FitOff
        %==========================================================
        %clear graphics because fit invalid
        plane = str2double(varargin{1});    %define requested plane

        RSP(plane).fit = 0;                 %fit not valid
        RSP(plane).U   = [];
        RSP(plane).S   = [];
        RSP(plane).V   = [];
        setappdata(0,'RSP',RSP);

        set(SYS.hdrf,'String', '0.0');
        %zero out fitting variables
        BPM(plane).fit = zeros(size(BPM(plane).name,1),1);
        setappdata(0,'BPM',BPM);

        ncor=length(COR(plane).ifit);
        COR(plane).fit = zeros(ncor,1);   %COR.fit is compressed
        COR(plane).sav = COR(plane).fit;  %zero out save vector
        setappdata(0,'COR',COR);

        bpmgui('ClearPlots');          %remove all bpm fitting plots
        corgui('ClearFit');            %remove all cor fitting plots
        corgui('ylimits');

        switch SYS.algo
            case 'SVD'
                %RSP=getappdata(0,'RSP');
                RSP(plane).nsvdmax = 1;
                RSP(plane).nsvd    = 1;      %keep one singular value - all correctors off then one on
                setappdata(0,'RSP',RSP);
                set(SYS.svdedit,'String',num2str(1));  %SVD display box
                respgui('PlotSVD');
        end

        %==========================================================
    case 'DispersionPanel'                   %  DispersionPanel
        %==========================================================
        %----------------------------------------------------------------
        %  create figure
        %----------------------------------------------------------------
        h = findobj(0,'tag','dispersionpanel');
        
        if ~isempty(h)
            delete(h);
        end

        [screen_wide, screen_high] = screensizecm;
        fig_start = [0.4*screen_wide 0.5*screen_high];
        fig_size  = [0.5*screen_wide 0.25*screen_high];
        %----------------------------------------------------------------
        figh = figure('units','centimeters',...  %...Dispersion Control Figure
            'Position',[fig_start fig_size],...
            'tag','dispersionpanel',...
            'NumberTitle','off',...
            'Doublebuffer','on',...
            'Visible','On',...
            'Name','Dispersion Fitting Control Panel',...
            'PaperPositionMode','Auto');
        set(figh,'MenuBar','None');
        %------------------------------------------------------------------

        %Radio Dispersion On/Off
        uicontrol('Style','radiobutton',...	 %Radio Horizontal Dispersion On/Off
            'units', 'normalize', ...
            'Position', [.05 .8 .3 .1], ...
            'String','Fit Eta-X',...
            'Tag','etaxflag',...
            'Value',RSP(1).etaflag,...
            'ToolTipString','Fit Horizontal Dispersion',...
            'FontSize',8,'FontWeight','demi',...
            'Callback','respgui(''EtaXFlag'')');

        uicontrol('Style','radiobutton',...	 %Radio Vertical Dispersion On/Off
            'units', 'normalize', ...
            'Position', [.5 .8 .3 .1], ...
            'String','Fit Eta-Z',...
            'Tag','etazflag',...
            'Value',RSP(2).etaflag,...
            'ToolTipString','Fit Vertical Dispersion',...
            'FontSize',8,'FontWeight','demi',...
            'Callback','respgui(''EtaZFlag'')');

        %Select Horizontal Dispersion Weights
        cback = 'rload(''GenFig'',BPM(1).name,BPM(1).status,BPM(1).ifit,';
        cback = [cback 'BPM(1).etawt,''Horizontal BPMs for Eta Fitting'',''etaxwt'');'];
        %instructions are used during 'load' procedure of rload window
        instructions = [...
            '   global BPM;',...
            '   tlist = get(gcf,''UserData'');',...
            '   BPM(1).etawt=tlist{4};',...
            '   setappdata(0,''BPM'',BPM);',...
            '   orbgui(''RefreshOrbGUI'');'];

        uicontrol('Style','pushbutton',...	                       %Select Horizontal Dispersion Weights
            'units', 'normalize', ...
            'Position', [.05 .65 .3 .1], ...
            'String','Select x-BPM Weights',...
            'tag','etaxwt',...
            'Callback',cback,...
            'Userdata',instructions);

        %Select Vertical Dispersion Weights
        cback='rload(''GenFig'',BPM(2).name,BPM(2).status,BPM(2).ifit,';
        cback=[cback 'BPM(2).etawt,''Horizontal BPMs for Eta Fitting'',''etaywt'');'];
        %instructions are used during 'load' procedure of rload window
        instructions=[...
            '   global BPM;',...
            '   tlist = get(gcf,''UserData'');',...
            '   BPM(2).etawt=tlist{4};',...
            '   setappdata(0,''BPM'',BPM);',...
            '   orbgui(''RefreshOrbGUI'');'];

        uicontrol('Style','pushbutton',... %Select Vertical Dispersion Weights
            'units', 'normalize', ...
            'Position', [.5 .65 .3 .1], ...
            'String','Select z-BPM Weights',...
            'tag','etaywt',...
            'Callback',cback,...
            'Userdata',instructions);

        %==========================================================
    case 'EtaXFlag'                   %  EtaXFlag
        %==========================================================
        RSP(1).etaflag = 0;
        h = findobj(gcf,'tag','etaxflag');
        val = get(h,'value');
        if val == 1
            RSP(1).etaflag = 1;
            setappdata(0,'RSP',RSP);
        end

        %% TODO merge ETAXZflag function 
        
        %==========================================================
    case 'EtaZFlag'                   %  EtaZFlag
        %==========================================================
        RSP(2).etaflag = 0;
        h = findobj(gcf,'tag','etazflag');
        val = get(h,'value');
        if val == 1
            RSP(2).etaflag=1;
            setappdata(0,'RSP',RSP);
        end


        %==========================================================
    otherwise
        disp(['Warning: no CASE found in respgui: ' action]);
end  %end switchyard
