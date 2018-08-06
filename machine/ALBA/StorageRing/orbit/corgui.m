function corgui(action, varargin)
% CORGUI - controls corrector manipulation and plotting for orbit program
%varargout = corgui(action, varargin)
%=============================================================
%
% INPUT
%1. action among:
%   PlotCor_Init
%   Fract
%   ApplyCorrection
%   RemoveCorrection
%   ApplyFit
%   UpdateCors
%   GetAct
%   UpdateAct
%   PlotAct
%   PlotFit
%   ClearFit
%   ClearPlots
%   ShowPlots
%   HidePlots
%   RePlot
%   ylimits
%   CorSelect
%   CorDown
%   ProcessCor
%   CorBar
%   UpdateCorBox
%   CorBox
%   Up
%   CORmove
%   SelectAll
%   SelectNone
%   ToggleCor
%   ShowResp
%   ShowEig
%   SaveCors
%   RestoreCors
%   CorEdit
%   ShowCORState
%   

%
% Written by William J. Corbett
% Adapted by Laurent S. Nadolski

%globals
global COR RSP SYS

% HCORFamily = 'HCOR';
% VCORFamily = 'VCOR';
% BPMxFamily = 'BPMx';
% BPMzFamily = 'BPMz';

orbfig = findobj(0,'tag','orbfig');
plane  = SYS.plane;

switch action
    
    %==========================================================
    case 'PlotCor_Init'             % *** PlotCor_Init ***
        %============Replot==============================================
        %draw patches to create a "bar" plot for the correctors.
        set(SYS.ahcor,'Xlim',[0 SYS.xlimax]);

        %========================================
        %initialize for plane that IS NOT default
        %========================================
        plane     = 1 + mod(plane,2);
        SYS.plane = plane;

        xd = orbgui('GetAbscissa',SYS,'COR');  %horizontal coordinates for plotting

        COR(plane).id = 1;        %first corrector selected as default

        for ii = 1:size(COR(plane).name,1)
            c     = xd(ii);     %horizontal coordinate
            color = 'k';        %default black if not in status vector
            if ~isempty(find(COR(plane).status==ii,1)), color='y'; end  %yellow for available
            if ~isempty(find(COR(plane).ifit==ii,1)),   color='g'; end  %green for fit

            %actual corrector strength (green)
            COR(plane).hact(ii,1) = line('parent',SYS.ahcor,'XData', ...
                c,'YData',0,'Marker','diamond',...
                'MarkerFaceColor',color,'MarkerSize',6,...
                'tag', ['c' num2str(plane) '_' num2str(ii)],...   %c for corrector
                'ButtonDownFcn','corgui(''CorSelect'')');
            %vertical bar to icon
            COR(plane).hact(ii,2) = line('parent',SYS.ahcor,'XData', ...
                [c c],'YData',[0 0],'Color','b');

            %actual+fitted strength (red)
            COR(plane).hfit(ii,1) = line('parent',SYS.ahcor,'XData', ...
                c,'YData',0,'Marker','o',...
                'MarkerFaceColor','r','MarkerSize',4,...
                'tag', ['f' num2str(plane) '_' num2str(ii)],...   %f for fit
                'ButtonDownFcn','corgui(''CorSelect'')');
            %vertical bar to icon
            COR(plane).hfit(ii,2)=line('parent',SYS.ahcor,'XData', ...
                [c c],'YData',[0 0],'Color','b');

            if strcmp(color,'k')    %if status bad make single black dot
                set(COR(plane).hact(ii,1),'MarkerSize',4,'Marker','o');
                set(COR(plane).hfit(ii,1),'MarkerFaceColor','k');
            end

        end
        %========================================
        %initialize for plane that IS default
        %========================================
        plane = 1+mod(plane,2);    %return to default plane
        SYS.plane = plane;

        COR(plane).id = 1;

        xd = orbgui('GetAbscissa',SYS,'COR');  %horizontal coordinates for plotting

        for ii = 1:size(COR(plane).name,1)
            c = xd(ii);
            color = 'k';   %black if not in status vector
            if ~isempty(find(COR(plane).status==ii,1)), color='y'; end  %yellow for for available
            if ~isempty(find(COR(plane).ifit==ii,1)),   color='g'; end  %green for fit

            %actual corrector strength (green)
            COR(plane).hact(ii,1)=line('parent',SYS.ahcor,'XData', ...
                c,'YData',0,'Marker','diamond',...
                'MarkerFaceColor',color,'MarkerSize',6,...
                'tag', ['c' num2str(plane) '_' num2str(ii)],...
                'ButtonDownFcn','corgui(''CorSelect'')');
            %vertical bar to icon
            COR(plane).hact(ii,2)=line('parent',SYS.ahcor,'XData', ...
                [c c],'YData',[0 0]);

            %actual+fitted strength (red)
            COR(plane).hfit(ii,1)=line('parent',SYS.ahcor,'XData', ...
                c,'YData',0,'Marker','o',...
                'MarkerFaceColor','r','MarkerSize',4,...
                'tag', ['f' num2str(plane) '_' num2str(ii)],...
                'ButtonDownFcn','corgui(''CorSelect'')');
            %vertical bar to icon
            COR(plane).hfit(ii,2)=line('parent',SYS.ahcor,'XData', ...
                [c c],'YData',[0 0]);

            if strcmp(color,'k')    %if status bad make single black dot
                set(COR(plane).hact(ii,1),'MarkerSize',4,'Marker','o');
                set(COR(plane).hfit(ii,1),'MarkerFaceColor','k');
            end
        end


        %set limits on corrector plot
        ylim = get(SYS.ahcor,'YLim');
        
        %vertical bar on selected corrector
        SYS.lhcid = line('parent',SYS.ahcor,...
            'XData',[xd(COR(plane).id),xd(COR(plane).id)+0.001],...
            'YData',[ylim(1),ylim(2)],'Color','k');
        set(SYS.lhcid,'ButtonDownFcn','corgui(''CorSelect'')');

        corgui('ylimits');

        %===========================================================
    case 'Fract'                                 %*** Fract ***
        %===========================================================
        %callback of the text box used to set fraction
        h1    = SYS.fract;
        fract = str2double(get(h1,'String'));

        if isnan(fract) || ~isnumeric(fract) || ~length(fract) == 1
            % flush the bad string out of the edit; replace with current value:
            set(h1,'String',num2str(COR(plane).fract));
            disp('Warning: Invalid fraction entry.');
            orbgui('LBox','Warning: Invalid fraction entry');
            return;
        else
            COR(plane).fract = fract;
            %NOTE: fraction scalar only used at time of corrector application
            %   respgui('UpdateFit');
            %   orbgui('RefreshOrbGUI');
        end

        %===========================================================
    case 'ApplyCorrection'              %*** ApplyCorrection ***
        %===========================================================
        %Apply orbit correction
        if ~isempty(COR(plane).ifit) || RSP(plane).rfflag
            orbgui('LBox',' Apply Correction for current plane');
            corgui('ApplyFit');
        else
            orbgui('LBox',' Correction not valid for current plane');
        end

        %===========================================================
    case 'RemoveCorrection'            %*** RemoveCorrection ***
        %===========================================================
        %restore to corrector pattern prior to 'ApplyFit'

        if ~isempty(COR(plane).ifit) || RSP(plane).rfflag
            orbgui('LBox',' Removing Correction');
            
            if COR(plane).ifit % Corrector magnet part
                %NOTE: corrector pattern (.act) measured at time of fit in RefreshOrbGUI

                % Select good status correctors
                status = COR(plane).status;
                val    = COR(plane).rst(status);
                %restore values
                setsp(COR(plane).AOFamily,val,status,SYS.mode);
            end
            
            if RSP(plane).rfflag % RF part
                stepsp('RF', -SYS.drfrst, SYS.mode);
            end
            
            % Update gui
            bpmgui('GetAct');
            corgui('GetAct');
            orbgui('RefreshOrbGUI');
        else
            orbgui('LBox',' Correction not valid for current plane');
        end

        %===========================================================
    case 'ApplyFit'                            %*** ApplyFit ***
        %===========================================================
        %apply corrector fit pattern scaled by fract
        %NOTE: corrector pattern (.act) measured at time of fit in RefreshOrbGUI
        
        if ~isempty(COR(plane).ifit) % corrector magnet part
            % Actual value + fitted value
            val = COR(plane).act(COR(plane).ifit) + ...
                COR(plane).fract*COR(plane).fit;

            % Test if saturation
            istoobig = (abs(val) > COR(plane).lim(COR(plane).ifit));
            if sum(istoobig) ~= 0
                orbgui('LBox',' Warning: cannot apply correction strength too large');
                return;
            end

            %load restore field to enable corrector pattern removal
            COR(plane).rst = COR(plane).act;

            % Set new current values
            setsp(COR(plane).AOFamily,val,COR(plane).ifit,SYS.mode);
            pause(2); % pause for letting correctors reach their final value % (should be a special flag in setsp)
        end
        
        if RSP(plane).rfflag % Apply RF correction
            stepsp('RF',COR(plane).fract*SYS.drf, SYS.mode);
            %load restore field to enable corrector pattern removal
            SYS.drfrst = COR(plane).fract*SYS.drf;
        end
            
        setappdata(0,'SYS',SYS);
        bpmgui('GetAct');
        corgui('GetAct');
        orbgui('RefreshOrbGUI');

        
        %==========================================================
    case 'UpdateCorrs'                  % *** UpdateCorrs ***
        %==========================================================
        %callback of the 'refresh corrector' button
        %acquire corrector readbacks, plot, re-calculate fit
        corgui('UpdateAct');
        orbgui('RefreshOrbGUI');

        %==========================================================
    case 'GetAct'                              % *** GetAct ***
        %==========================================================
        %get readback corrector values from database
        %load values into full length array slots with valid status      
        
        % H-correctors
        status             = COR(1).status;
        COR(1).act(status) = getam(COR(1).AOFamily,[],SYS.mode);
        % V-correctors
        status             = COR(2).status;
        COR(2).act(status) = getam(COR(2).AOFamily,[],SYS.mode);

        setappdata(0,'COR',COR);

        %==========================================================
    case 'UpdateAct'                  % *** UpdateAct ***
        %==========================================================
        %callback of the 'refresh corrector' button
        %acquire corrector readbacks and plot

        corgui('GetAct');
        corgui('PlotAct');
        corgui('UpdateCorBox');
        orbgui('LBox',' Refresh Corrector Setpoints');

        %==========================================================
    case 'PlotAct'                            % *** PlotAct ***
        %==========================================================
        %draw stem plot for the actual corrector values.
        %act contains real values

        %scale start patch
        ah = get(SYS.ahcor);
        set(orbfig,'currentaxes',SYS.ahcor)

        xd = orbgui('GetAbscissa',SYS,'COR');
   
        nstat = length(COR(plane).act);
        kk = (1:nstat)';
        colorcell = repmat({'g'},nstat,1); %green for fit
        colorcell(setdiff(kk,COR(plane).ifit))  = {'y'};  %yellow for no fit
        colorcell(setdiff(kk,COR(plane).status)) = {'k'};  %black for not available
        
        if strcmpi(COR(plane).units,'Physics') == 1
            fact = COR(plane).hw2physics;
        else
            fact = 1;
        end
        
        yd      = zeros(nstat,1);
        idx     = intersect(kk,COR(plane).status);
        yd(idx) = COR(plane).act(idx);
        yd      = yd*fact;
        
        set(COR(plane).hact(:,1),{'XData'},num2cell(xd),{'YData'}, ...
            num2cell(yd),{'MarkerFaceColor'},colorcell);
        set(COR(plane).hact(:,2),{'XData'},num2cell([xd xd],2), ...
            {'YData'},num2cell([0*yd yd],2));

%         for kk = 1:size(COR(plane).name,1)
%             yd    = 0.0;      %default corrector value
%             color = 'k';   %default black if not in status vector
%             if ~isempty(find(COR(plane).status == kk))
%                 color = 'y';  %yellow for available
%                 yd    = COR(plane).act(kk);
%             end
% 
%             if ~isempty(COR(plane).ifit);
%                 if ~isempty(find(COR(plane).ifit == kk)) 
%                     color = 'g'; 
%                 end
%             end
%             
%             if strcmpi(COR(plane).units,'Physics') == 1
%                 fact = COR(plane).hw2physics;
%             else
%                 fact = 1;
%             end
%             
%             set(COR(plane).hact(kk,1),'XData',xd(kk),'YData', ...
%                 yd*fact,'MarkerFaceColor',color);
%             set(COR(plane).hact(kk,2),'XData',[xd(kk) xd(kk)], ...
%                 'YData',[0 yd*fact]);            
%         end  %end loop over all correctors

        corgui('ylimits');

        %==========================================================
    case 'PlotFit'                      % *** PlotFit ***
        %==========================================================
        %draw stem plot for the total predicted corrector values after fitting
        %note:COR(plane).fit is compressed

        if isempty(COR(plane).fit)
            return
        end

        xd = orbgui('GetAbscissa',SYS,'COR');

        len = length(COR(plane).ifit);        
        idx = COR(plane).ifit(1:len); %get indices
        xd  = xd(idx);
        yd  = COR(plane).act(idx) + COR(plane).fit(1:len); % new value

        if strcmpi(COR(plane).units,'Physics') == 1
            fact = COR(plane).hw2physics;
        else
            fact = 1;
        end
        yd  = yd *fact;

        set(COR(plane).hfit(idx,1),{'Xdata'}, num2cell(xd), ...
            {'YData'}, num2cell(yd));
        set(COR(plane).hfit(idx,2),{'Xdata'},num2cell([xd xd],2), ...
            {'YData'}, num2cell([0*yd yd],2));

%         for kk = 1:length(COR(plane).ifit)
%             k  = COR(plane).ifit(kk);
%             yd = COR(plane).act(k) + COR(plane).fit(kk);
% 
%             if strcmpi(COR(plane).units,'Physics') ==1
%                 fact = COR(plane).hw2physics;
%             else
%                 fact = 1;
%             end
%             
%             set(COR(plane).hfit(k,1),'Xdata', xd(k),'YData', yd*fact);
%             set(COR(plane).hfit(k,2),'Xdata',[xd(k) xd(k)],'YData',[0 yd*fact]);
%         end
%         corgui('ylimits');

        %==========================================================
    case 'ClearFit'                      % *** ClearFit ***
        %==========================================================
        
        %clear horizontal fit        
        set(COR(1).hfit(:,1),'YData',0);
        set(COR(1).hfit(:,2),'YData',[0 0]);
        
        %clear vertical   fit
        set(COR(2).hfit(:,1),'YData',0);
        set(COR(2).hfit(:,2),'YData',[0 0]);

        %==========================================================
    case 'ClearPlots'                    % *** Clearplots ***
        %==========================================================
        corgui('ClearFit');

        %clear horizontal actuals
        set(COR(1).hact(:,1),'YData',0);
        set(COR(1).hact(:,2),'YData',[0 0]);
        %clear vertical   actuals
        set(COR(2).hact(:,1),'YData',0);
        set(COR(2).hact(:,2),'YData',[0 0]);

        %==========================================================
    case 'ShowPlots'                    % *** Showplots ***
        %==========================================================
        %hide stem plots for current plane
        set(COR(plane).hact,'Visible','On');
        set(COR(plane).hfit,'Visible','On');

        %==========================================================
    case 'HidePlots'                    % *** Hideplots ***
        %==========================================================
        %hide stem plots for current plane
        set(COR(plane).hact,'Visible','Off');
        set(COR(plane).hfit,'Visible','Off');

        %=============================================================
    case 'RePlot'                                  % *** RePlot ***
        %=============================================================
        corgui('ClearPlots');
        set(orbfig,'currentaxes',SYS.ahcor)
        corgui('PlotAct');                        %plot actual correctors
        corgui('PlotFit');                        %plot fitted correctors
        corgui('ylimits');
        corgui('CorBar');
        
        %=============================================================
    case 'ylimits'                             % *** ylimits ***
        %=============================================================
        %compute vertical axes limits for corrector plot

        if COR(plane).scalemode == 0 
            return;  %manual mode
        end    
        
        orbgui('AutoScaleCorrAxis');
%         mxfit = 0;
%         if ~isempty(COR(plane).ifit)
%             mxfit = max(abs(COR(plane).fit(:) + COR(plane).act(COR(plane).ifit)));
%         end
% 
%         mxact = max(abs(COR(plane).act(COR(plane).status)));
% 
%         ylim  = max(mxfit, mxact)*1.1;
% 
%         if strcmpi(COR(plane).units,'Physics') == 1
%             fact = COR(plane).hw2physics;
%         else
%             fact = 1;
%         end
% 
%         ylim = ylim*fact;
%         
%         %% Saturation @ 10 um
%         if ylim < 0.01 
%             ylim = 0.01; 
%         end
%         
%         set(SYS.ahcor,'YLim',ylim*[-1, 1]);

        %=============================================================
    case 'CorSelect'                          % *** CorSelect ***
        %=============================================================
        %used if mouse clicks anywhere in COR window
        cpa = get(SYS.ahcor,'CurrentPoint');
        pos = cpa(1); % current position

        switch SYS.xscale
            case 'meter'
                id = find(min(abs(COR(plane).s-pos)) == abs(COR(plane).s-pos));
            case 'phase'
                id = find(min(abs(COR(plane).phi-pos)) == abs(COR(plane).phi-pos));
        end

        COR(plane).id = id;

        setappdata(0,'COR',COR);

        c = COR(plane).hact(id,1);  %...get handle

        corgui('ProcessCor',id,c);
        corgui('CorBar');

        %=============================================================
    case 'CorDown'                              % *** CorDown ***
        %=============================================================
        c    = gcbo;
        ctag = get(c,'tag');
        id   = str2double(ctag(4:length(ctag))); %strip off 'c/plane_' to get the cor index
        corgui('ProcessCor',id,c);

        %=============================================================
    case 'ProcessCor'                           % *** ProcessCor ***
        %=============================================================
        %This function is activated whenever the left mouse button is pressed inside a BPM patch.
        %It sets up corfig to interpret movement of the mouse and also puts data about the
        %particular cor into the text fields.

        %identify COR handle and number
        id = varargin{1}; %corrector index 'id' comes through varargin
        c  = varargin{2}; %bpm handle 'c' comes through varargin
        %c = gcbo;
        %cortag = get(c,'tag');
        %id = str2num(cortag(2:length(cortag)));         %strip off 'c' to get the cor index

        if COR(plane).mode == 1   %Correctors in toggle mode
            first = 0;
            if isempty(COR(plane).ifit)       %no CORs chosen
                COR(plane).ifit(1) = id;
                set(c,'MarkerFaceColor','g'); %add to fit list
                first = 1;
                setappdata(0,'COR',COR);
            end

            if ~isempty(find(COR(plane).ifit == id,1)) && first == 0  %presently selected for fit
                set(c,'MarkerFaceColor','y');
                COR(plane).ifit(find(COR(plane).ifit == id)) = 0;  %set fit vector to zero
                COR(plane).ifit = COR(plane).ifit(find(COR(plane).ifit)); % compress data
%                 nfit = length(COR(plane).ifit);         %compute vector length used ???
                setappdata(0,'COR',COR);

            elseif isempty(find(COR(plane).ifit == id,1)) && ...
                    ~isempty(find(COR(plane).avail == id, 1))
                %Corrector added to OK for fit
                %elseif ~isempty(find(COR(plane).avail==id))  %corrector is available
                set(c,'MarkerFaceColor','g');                 
                t = COR(plane).ifit; 
                t = t(find(t));       % number 1 to 56 out of 120 for instance
                t = sort([t; id]);    % add to fit list
                COR(plane).ifit = t;  % updated corrector list for fit
%                 nfit            = length(COR(plane).ifit); % used ???
                setappdata(0,'COR',COR); 
            end

            orbgui('RefreshOrbGUI');
        else
            corgui('UpdateCorBox');
        end    %end toggle mode condition

        set(orbfig,'WindowButtonUpFcn','corgui(''Up'')');

        %update response matrix column plot
        if strcmpi(RSP(plane).disp(1:3), 'off')     %Response display mode
            set(SYS.lhrsp,'XData',[],'YData',[]);
        else
            bpmgui('PlotResp');                            %plot matrix column vector
        end

        %=============================================================
    case 'CorBar'                              % *** CorBar ***
        %=============================================================
        %move black line in window to indicate selection
        id   = COR(plane).id;
        ylim = get(SYS.ahcor,'YLim');


        if isempty(find(COR(plane).status == id, 1))
            yd = ylim/4;
        else
            yd = COR(plane).act(id) + ylim/4;
        end


        xd = orbgui('GetAbscissa',SYS,'COR');  %horizontal coordinates for plotting
        xd = [xd(id) xd(id) + 0.001];

        set(SYS.lhcid,'XData',xd,'YData',yd);

        %=============================================================
    case 'UpdateCorBox'                     % *** UpdateCorBox ***
        %=============================================================
        %update UpdateCorBox
        %called from orbgui(RefreshOrbGUI), corgui(UpdateCorrs),
        id = COR(plane).id;
        %put fit value in offset box and in request box
        fitindx = [];
        if ~isempty(COR(plane).ifit) 
            fitindx = find(COR(plane).ifit == id); 
        end

        if ~isempty(fitindx)
            offset  = COR(plane).fit(fitindx);
            request = COR(plane).act(id)+offset;
        else
            offset  = 0.0;
            request = COR(plane).act(id);
        end

        % mean val
        meanV = mean(COR(plane).act(COR(plane).status));
        % rms val
        sigma = std(COR(plane).act(COR(plane).status));
        
        corgui('CorBox',COR(plane).name(id,:),COR(plane).act(id),...
            COR(plane).save(id),offset,request,...
            meanV,sigma,id);

        %=============================================================
    case 'CorBox'                            % *** CorBox ***
        %=============================================================
        %called from
        %corgui('CorBox',COR(plane).name(id,:),COR(plane).act(id),...
        %                COR(plane).ref(id),id);
        corname   = SYS.corname;
        actual    = SYS.coract;
        reference = SYS.corref;
        offset    = SYS.coroffset;
        request   = SYS.correq;
        rmsval    = SYS.cormean;
        meanval   = SYS.corrms;

        name = varargin{1};
        act  = varargin{2};
        ref  = varargin{3};
        off  = varargin{4};
        req  = varargin{5};
        rms  = varargin{6};
        meanV= varargin{7};
        id   = varargin{8};

        if strcmpi(COR(plane).units,'Physics') == 1
            fact = COR(plane).hw2physics;
        else
            fact = 1;
        end
            
        % conversion in device list
        dev = elem2dev(COR(plane).AOFamily,id);
        
        set(corname,  'String',[name '  [',num2str(dev(1)),' ', ...
            num2str(dev(2)),']']);
        set(actual,   'String',num2str(act*fact,   '%6.3f'));
        set(reference,'String',num2str(ref*fact,   '%6.3f'));
        set(offset,   'String',num2str(off*fact,   '%6.3f'));
        set(meanval,  'String',num2str(meanV*fact, '%6.3f'));
        set(rmsval,   'String',num2str(rms*fact,   '%6.3f'));
        set(request,  'String',num2str(req*fact,   '%6.3f'));

        %=============================================================
    case 'Up'                                  % *** Up ***
        %=============================================================
        %once the mouse button is let up, don't respond to motion any more.

        set(orbfig,'WindowButtonMotionFcn','','WindowButtonUpFcn','');

        %=============================================================
    case 'CORmove'                      % *** CORmove ***
        %=============================================================
        %empty for now: can't drag correctors
        return;
        
        %=============================================================
    case 'SelectAll'                           % *** SelectAll ***
        %============================================================
        %load all available correctors into ifit field
        COR(plane).ifit = [];
        
        set(COR(plane).hact(COR(plane).avail,1),'MarkerFaceColor','g');
        vavail = 1:length(COR(plane).avail);
        COR(plane).ifit(vavail) = COR(plane).avail;
        
%         for kk = 1:length(COR(plane).avail)
%             k  = COR(plane).avail(kk);
%             h1 = COR(plane).hact(k,1);  %k,1 is the icon
%             set(h1,'MarkerFaceColor','g');
%             COR(plane).ifit(kk)=k;
%         end

        COR(plane).ifit = COR(plane).ifit(:);
        setappdata(0,'COR',COR);

        corgui('ClearFit'); %be sure to remove residual red corrector bars
        orbgui('RefreshOrbGUI');

        %=============================================================
    case 'SelectNone'                           % *** SelectNone ***
        %=============================================================
        COR(plane).ifit = [];
        COR(plane).fit  = [];

        set(COR(plane).hact(COR(plane).avail,1),'MarkerFaceColor','y');
        
%         for kk = 1:length(COR(plane).avail)
%             k  = COR(plane).avail(kk);
%             h1 = COR(plane).hact(k,1);  %k,1 is the icon
%             set(h1,'MarkerFaceColor','y');
%         end

        setappdata(0,'COR',COR);

        RSP(plane).nsvd   = 1;
        RSP(plane).nsvdmax = 1;
        setappdata(0,'RSP',RSP);

        orbgui('RefreshOrbGUI');
        %respgui('FitOff',num2str(plane));

        %==========================================================
    case 'ToggleCor'                              %  ToggleCor
        %==========================================================
        h1  = SYS.togglecor;
        val = get(h1,'Value');
        if val == 0                        %radio was on, push turned off
            COR(plane).mode = 0;               %'0' for display
        elseif val == 1                    %radio was off, push turned on
            COR(plane).mode = 1;               %'1' for toggle
        end
        setappdata(0,'COR',COR);

        %==========================================================
    case 'ShowResp'                       %  ShowResp
        %==========================================================
        %toggle the 'showresp' flag to display columns of response matrix
        %plotting in bpmgui('PlotResp')

        %first make sure eigenvector display is off
        val = get(SYS.showeig,'Checked');
        if strcmpi(val,'On')                        %radio on, turn off
%             RSP(plane).eig = 'off';
            setappdata(0,'RSP',RSP);
            set(SYS.lheig,'XData',[],'YData',[]);
            set(SYS.showeig,'Checked','Off');
        end

        val = get(SYS.showresp,'Checked');
        %RSP=getappdata(0,'RSP');
        if strcmpi(val,'on')                       %radio was on, push turned off
%             RSP(plane).disp = 'off';
            set(SYS.lhrsp,'XData',[],'YData',[]);
            set(SYS.showresp,'Checked','Off');
        elseif strcmpi(val,'off')                    %radio was off, push turned on
%             RSP(plane).disp = 'on';
            setappdata(0,'RSP',RSP);
            bpmgui('PlotResp');
            set(SYS.showresp,'Checked','On');
        end

        %==========================================================
    case 'ShowEig'                       %  ShowEig
        %==========================================================
        %toggle state to show eigenvectors
        %first make sure response matrix display is off

        val = get(SYS.showresp,'Checked');
        if strcmpi(val, 'On')                   %radio on, turn off
            RSP(plane).disp = 'off';
            set(SYS.lhrsp,'XData',[],'YData',[]);
            set(SYS.showresp,'Checked','Off');
        end

        val = get(SYS.showeig,'Checked');
        if strcmpi(val, 'On')                       %radio was on, push turned off
%             RSP(plane).eig = 'off';
            set(SYS.lheig,'XData',[],'YData',[]);
            set(SYS.showeig,'Checked','Off');
        elseif strcmpi(val, 'Off')                    %radio was off, push turned on
%             RSP(plane).eig = 'on'; 
            bpmgui('PlotEig');
            set(SYS.showeig,'Checked','On');
        end

        %===========================================================
    case 'SaveCors'                          %*** SaveCors ***
        %===========================================================
        %Save Corrector Readbacks for RESET button
        plane = varargin{1};

        % Corrector magnet part
              
        % Read true values for want all correctors
        val    = getsp(COR(plane).AOFamily, SYS.mode);
        status = COR(plane).status;
        COR(plane).save(status) = val;
        
        % Set corrector save flag
        COR(plane).saveflag = 1;

        setappdata(0,'COR',COR);
        
        % RF part
        SYS.rfsave = getrf(SYS.mode);
        SYS.rfsaveflag = 1;
        
        setappdata(0,'SYS',SYS);
        
        %update corrector display
        corgui('UpdateCorBox');

        orbgui('LBox',[' Corrector and RF saved for plane: ' num2str(plane)]);

        %===========================================================
    case 'RestoreCors'                    %*** RestoreCors ***
        %===========================================================
        %restore correctors to saved values
        if ~COR(plane).saveflag || ~SYS.rfsaveflag
            orbgui('LBox',[' Corrector pattern not saved for plane: ' ...
                num2str(plane)]);
            return
        end

        if COR(plane).saveflag % Corrector magnet            
            %Get saved corrector values
            val    = COR(plane).save;
            status = COR(plane).status;

            % set back coorector values
            setsp(COR(plane).AOFamily, val(status), status, SYS.mode);

            orbgui('LBox',[' Corrector pattern restored for plane: ' num2str(plane)]);
        end
        
        if SYS.rfsaveflag % RF part
            setrf(SYS.rfsave, SYS.mode);
            orbgui('LBox','RF frequency restored ');
        end
            
        %% Update gui
        bpmgui('GetAct');
        corgui('GetAct');
        orbgui('RefreshOrbGUI');

%         %==============================================================
%     case 'MakeOrbitSlider'                       %  MakeOrbitSlider
%         %==============================================================
%         %figure to create bump sliders and/or write files
% 
%         [screen_wide, screen_high]=screensizecm;
%         fig_start = [0.4*screen_wide 0.5*screen_high];
%         fig_size  = [0.4*screen_wide 0.25*screen_high];
% 
%         h = findobj(0,'tag','makeorbitslider');
%         if ~isempty(h)
%             delete(h);
%         end
% 
%         if SYS.plane==1
%             planestr = 'Horizontal ';
%         else
%             planestr = 'Vertical';
%         end
% 
%         figh = figure('units','centimeters',...                %...Figure
%             'Position',[fig_start fig_size],'tag','makeorbitslider',...
%             'NumberTitle','off','Doublebuffer','on','Visible','On','Name',[planestr 'corrector bump panel'],...
%             'PaperPositionMode','Auto','MenuBar','None');
%         %------------------------------------------------------------------
%         path     = getfamilydata('Directory','BumpData');
%         filename = appendtimestamp('bump', clock);
% 
%         uicontrol('Style','Text',...	                       %...Header
%             'units', 'normalize', ...
%             'Position', [.02 .8 .12 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
%             'String','Header:','ToolTipString','Name of slider in gui display',...
%             'FontSize',8,'FontWeight','demi');
% 
%         SYS.bumpheader=uicontrol('Style','Edit',...	   %...Header
%             'units', 'normalize', ...
%             'Position', [.2 .8 .4 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
%             'String','Bump','ToolTipString','Name of slider in gui display',...
%             'FontSize',8,'FontWeight','demi');
% 
%         uicontrol('Style','Text',...	                       %...File Name
%             'units', 'normalize', ...
%             'Position', [.02 .7 .12 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
%             'String','File Name:','ToolTipString','Name of file written to disk',...
%             'FontSize',8,'FontWeight','demi');
% 
%         SYS.bumpfile=uicontrol('Style','Edit',...	  %...File Name
%             'units', 'normalize', ...
%             'Position', [.2 .7 .5 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
%             'String',filename,'ToolTipString','Name of file written to disk',...
%             'FontSize',8,'FontWeight','demi');
% 
%         uicontrol('Style','Text',...	                      %...Save Directory
%             'units', 'normalize', ...
%             'Position', [.02 .6 .12 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
%             'String','File Path','ToolTipString','Path of file written to disk',...
%             'FontSize',8,'FontWeight','demi');
% 
%         SYS.bumppath=uicontrol('Style','Edit',...	  %...Save Directory
%             'units', 'normalize', ...
%             'Position', [.2 .6 .8 .08],'ForeGroundColor','k','HorizontalAlignment','Left',...
%             'String',path,'ToolTipString','Path of file written to disk',...
%             'FontSize',8,'FontWeight','demi');
% 
%         uicontrol('Style','pushbutton',...	                  %...Save Command
%             'units', 'normalize', ...
%             'Position', [.2 .3 .3 .1],'ForeGroundColor','k',...
%             'String','Save file','ToolTipString','Write bump file to disk (do not launch slider)',...
%             'FontSize',8,'FontWeight','demi','Callback',['corgui(''WriteBumpFile'');', 'close(''gcf'')']);
% 
%         uicontrol('Style','pushbutton',...	                  %...Save & Launch Command
%             'units', 'normalize', ...
%             'Position', [.6 .3 .3 .1],'ForeGroundColor','k',...
%             'String','Save file/Launch Slider','ToolTipString','Write bump file to disk and launch slider',...
%             'FontSize',8,'FontWeight','demi','Callback','corgui(''LaunchBumpSlider'')');
% 
%         uicontrol('Style','pushbutton',...	                  %...cancel
%             'units', 'normalize','Position', [.8 .08 .1 .1],'ForeGroundColor','k','String','cancel',...
%             'Callback','delete(gcf)','FontSize',8,'FontWeight','demi');
% 
%         %==========================================================
%     case 'WriteBumpFile'             % *** WriteBumpFile ***
%         %==========================================================
%         %call of MakeOrbitSlider
%         %call function WriteBumpFile with corrector strengths
% 
%         if plane == 1
%             Family = HCORFamily;
%         elseif plane == 2
%             Family = VCORFamily;
%         end
% 
%         pv    = common2tango(COR(plane).name(COR(plane).ifit,:),'Setpoint',Family);
%         delta = zeros(length(COR(plane).ifit),1);
%         for ii = 1:length(COR(plane).ifit)
%             jj          = COR(plane).ifit(ii);
%             delta(ii,1) = COR(plane).fit(ii)-COR(plane).act(jj);
%         end
% 
%         header   = get(SYS.bumpheader,'String');
%         path     = get(SYS.bumppath,'String');
%         filename = get(SYS.bumpfile,'String');
% 
%         if isempty(header)   header = 'slider'; end
%         if isempty(path) path = getfamilydata('Directory','BumpFiles'); end
%         
%         set(SYS.bumppath,'String',path);       %update so launchbumpslider has correct path
%         
%         if isempty(filename) filename = appendtimestamp('bump', clock);
%             if isempty(findstr(filename,'.m')) filename = [filename '.m']; end
%             set(SYS.bumpfile,'String',filename);   %update so launchbumpslider has correct filename
%         end
% 
%         writebumpfile(pv,delta,header,path,filename);
%         orbgui('LBox',[' Bump File Created: ', filename]);
% 
%         %==========================================================
%     case 'LaunchBumpSlider'             % *** LaunchBumpSlider ***
%         %==========================================================
%         %call of MakeOrbitSlider 'Save and Launch
%         %call function SingleSlider with corrector strengths
% 
%         corgui('WriteBumpFile');    %first write file
% 
%         header=  get(SYS.bumpheader,'String');
%         path=    get(SYS.bumppath,'String');
%         filename=get(SYS.bumpfile,'String');
% 
%         if isempty(header)   header='slider'; end
%         if isempty(path)     path=getfamilydata('Directory','BumpFiles'); end
%         if isempty(filename) filename=appendtimestamp('bump', clock); end
% 
%         setappdata(0,'SliderIndex',1);
%         setappdata(0,'SliderFigHandle',gcf);
% 
%         singleslider(path,filename);


        %==========================================================
    case 'CorEdit'                                %...CorEdit
        %==========================================================
        %The callback of the single corrector edit box (not implemented)
        %
        h1 = SYS.corname;
        if ~isempty(get(h1,'String'))
            set(SYS.coredit,'String',num2str(0.0));
            return

        end

        %===========================================================
    case 'ShowCORState'              %*** ShowCORState ***
        %===========================================================

        % Show =corrector settings
        
        len = size(COR(plane).name,1);
        tavail  = zeros(len,1);
        tfit    = zeros(len,1);
        tifit   = zeros(len,1);
        tstatus = zeros(len,1);
      
        idx = intersect(COR(plane).avail,1:len);
        tavail(idx) = idx;
        idx = intersect(COR(plane).ifit,1:len);
        tifit(idx) = idx;
        tfit(idx) = COR(plane).fit;
        idx = intersect(COR(plane).status,1:len);
        tstatus(idx) = idx;
  
%         findx=1;
%         for ind=1:length(COR(plane).name)
%             if ~isempty(find(COR(plane).avail==ind)) tavail(ind)=ind;  end
%             if ~isempty(find(COR(plane).ifit==ind))
%                 tifit(ind)=ind;
%                 tfit(ind)=COR(plane).fit(findx);
%                 findx=findx+1;
%             end
%             if ~isempty(find(COR(plane).status==ind)) tstatus(ind)=ind;  end
%         end

  %%% BUILD UP CELL TO DISPLAY
        ivec = (1:len)';        
        Strcell = cell(8,len);
        Strcell(1,:) = num2cell(ivec);
        Strcell(2,:) = cellstr(COR(plane).name(ivec,:))';
        Strcell(3:end,:) = num2cell([tstatus(ivec),tavail(ivec),tifit(ivec), ...
            COR(plane).act(ivec),tfit(ivec),COR(plane).wt(ivec) ])';
        
        %% Speed issue 
        %  see bpmgui('ShowBPMState') for more details
                     
        filename = [SYS.localdata 'cordata.txt'];
        fid = fopen(filename,'w');
        fprintf(fid,'%s\n','index   name     stat  avail ifit      act        fit       weight');
        fprintf(fid,'%3d %10s %5d %5d %5d %10.3f %10.3f %10.3f\n', Strcell{:});
        fclose(fid)
%         edit 'cordata.txt'
        system(['nedit ', filename, ' &']); %much faster
        
%         fprintf('%s\n','index name       stat  avail ifit      act        fit       weight');
%         for ind=1:length(COR(plane).name)
%             fprintf('%3d %10s %5d %5d %5d %10.3f %10.3f %10.3f\n',...
%                 ind, COR(plane).name(ind,:),...
%                 tstatus(ind),tavail(ind),tifit(ind),COR(plane).act(ind),tfit(ind),COR(plane).wt(ind));
%         end

%         %==========================================================
%     case 'MeasureXResp'                  % *** MeasureXResp ***
%         %==========================================================
%         %callback of the 'Measure X-Response' menu selection
% 
%         orbitfiginvisible;
% 
%         disp('Orbit gui visibility turned off while response matrix measurement in progress');
%         disp(['To re-activate, issue command :  ', 'OrbitFigVisible']);
% 
%         % acquire initial orbit
%         disp('   Acquiring initial orbit')
%         Xorb                = getx('struct');
%         Xorb.DataDescriptor = 'ResponseMatrixReference';
%         Zorb                = getz('struct');
%         Zorb.DataDescriptor = 'ResponseMatrixReference';
% 
%         %acquire machine configuration
%         disp('   Acquiring machine configuration')
%         machineconfig = getmachineconfig;
% 
%         ad = getad;
% 
%         xbpms = BPM(1).status;
%         ybpms = BPM(2).status;
% 
%         xcors = COR(1).status;
%         xkick = COR(1).ebpm(xcors);
% 
%         WaitFlag   = ad.BPMDelay;
%         ExtraDelay = 0;
% 
%         disp('   *** Begin measuring horizontal response matrix ***');
%         mat = measrespmat({BPMxFamily,BPMzFamily},{xbpms,ybpms},HCORFamily, ...
%             xcors,xkick,'bipolar',WaitFlag,ExtraDelay,'struct');
% 
%         % Make a response matrix array
%         Rmat(1,1) = mat{1};  % xx
%         Rmat(2,1) = mat{2};  % zx
% 
%         %load xx data
%         Rmat(1,1).NaNData              = zeros(size(getlist(BPMxFamily,0),1), ...
%             size(getlist(HCORFamily,0),1));
%         Rmat(1,1).NaNData(:)           = deal(NaN);
%         Rmat(1,1).NaNData(xbpms,xcors) = mat{1}.Data;     %Kick x, look x
%         %
%         %load zx data
%         Rmat(2,1).NaNData              = zeros(size(getlist(BPMzFamily,0),1), ...
%             size(getlist(HCORFamily,0),1));
%         Rmat(2,1).NaNData(:)           = deal(NaN);
%         Rmat(2,1).NaNData(ybpms,xcors) = mat{2}.Data;     %Kick x, look z
% 
%         for ii = 1:2
%             Rmat(ii,1).X              = Xorb;
%             Rmat(ii,1).Y              = Zorb;
%             Rmat(ii,1).MachineConfig  = machineconfig;
%         end
%         Rmat(1,1).Monitor.DataDescriptor  = 'Horizontal Orbit';
%         Rmat(1,1).Actuator.DataDescriptor = 'Horizontal Correctors';
%         Rmat(2,1).Monitor.DataDescriptor  = 'Vertical Orbit';
%         Rmat(2,1).Actuator.DataDescriptor = 'Horizontal Correctors';
% 
%         RSP(1) = response2rsp(Rmat(1,1),RSP(1),1);
% 
%         orbitfigvisible;
% 
%         BPM = SortBPMs(BPM,RSP);
%         COR = SortCORs(COR,RSP);
%         orbgui('RefreshOrbGUI');
% 
%         orbgui('LBox',' Finished measuring horizontal eBPM response matrix');
% 
%         %==========================================================
%     case 'MeasureZResp'                  % *** MeasureZResp ***
%         %==========================================================
% 
%         %callback of the 'Measure Z-Response' menu selection
% 
%         orbitfiginvisible;
% 
%         disp('Orbit gui visibility turned off while response matrix measurement in progress');
%         disp(['To re-activate, issue command :  ', 'OrbitFigVisible']);
% 
%         % acquire initial orbit
%         disp('   Acquiring initial orbit')
%         Xorb                = getx('struct');
%         Xorb.DataDescriptor = 'ResponseMatrixReference';
%         Zorb                = getz('struct');
%         Zorb.DataDescriptor = 'ResponseMatrixReference';
% 
%         %acquire machine configuration
%         disp('   Acquiring machine configuration')
%         machineconfig=getmachineconfig;
% 
%         ad = getad;
% 
%         xbpms = BPM(1).status;
%         ybpms = BPM(2).status;
% 
%         ycors = COR(2).status;
%         ykick = COR(2).ebpm(ycors);
% 
%         WaitFlag   = 0;
%         ExtraDelay = ad.BPMDelay;
% 
%         disp('   *** Begin measuring vertical response matrix ***');
%         mat = measrespmat({BPMxFamily,BPMzFamily},{xbpms,ybpms}, ...
%             VCORFamily,ycors,ykick,'bipolar',WaitFlag,ExtraDelay,'struct');
% 
%         % Make a response matrix array
%         Rmat(1,2) = mat{1};  % zx
%         Rmat(2,2) = mat{2};  % zz
% 
%         %load x-y data
%         Rmat(1,2).NaNData              = zeros(size(getlist(BPMzFamily,0),1), ...
%             size(getlist(VCORFamily,0),1));
%         Rmat(1,2).NaNData(:)           = deal(NaN);
%         Rmat(1,2).NaNData(xbpms,ycors) = mat{1}.Data;     %Kick x, look z
% 
%         %load y-y data
%         Rmat(2,2).NaNData              = zeros(size(getlist(BPMxFamily,0),1), ...
%             size(getlist(VCORFamily,0),1));
%         Rmat(2,2).NaNData(:)           = deal(NaN);
%         Rmat(2,2).NaNData(xbpms,ycors) = mat{2}.Data;     %Kick z, look z
%         %
%         for ii = 1:2
%             Rmat(ii,2).X              = Xorb;
%             Rmat(ii,2).Y              = Zorb;
%             Rmat(ii,2).MachineConfig  = machineconfig;
%         end
% 
%         Rmat(1,2).Monitor.DataDescriptor  = 'Horizontal Orbit';
%         Rmat(1,2).Actuator.DataDescriptor = 'Vertical Correctors';
%         Rmat(2,2).Monitor.DataDescriptor  = 'Vertical Orbit';
%         Rmat(2,2).Actuator.DataDescriptor = 'Vertical Correctors';
% 
%         RSP(2) = response2rsp(Rmat(2,2),RSP(2),2);
% 
%         orbitfigvisible;
% 
%         BPM = SortBPMs(BPM,RSP);
%         COR = SortCORs(COR,RSP);
%         orbgui('RefreshOrbGUI');
% 
%         orbgui('LBox',' Finished measuring vertical eBPM response matrix');

        %==========================================================
    otherwise
        disp(['Warning: no CASE found in corgui: ' action]);

end  %end switchyard