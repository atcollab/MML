function varargout = locogui(varargin)
%LOCOGUI - Graphical interface for running the LOCO algorithm
%
%  There are a number of inputs when running LOCO.
%
%  I. File menu
%  A.  Open -> open a loco data file. The input file can be a .mat file or a .m script.  
%  B.  Save as -> save file to a different name.
%  C.  Save as (one iteration) -> saves only one iteration.
%  D.  Print,
%  E.  Pop Plot #1 -> copies plot #1 in locogui to a Matlab figure so that it can 
%                 be modified in any way the user wants.  Locogui has the axes 
%                 handles hiddlen.  If a user wants to change this issue, 
%                 set(0,'ShowHiddenHandles','on') (at your own risk).   
%  E.  Pop Plot #2 -> copies plot #2 in locogui to a Matlab figure.
%  F.  Diary -> Starts/Ends a diary file.
%  
%  All the information for each iteration is saved in the data file.  Anytime a selection 
%  is made from the "Start From" popup menu, all the items in the input menu are restored.  
%  This includes the BPM and CM lists.  One potential awkwardness in this application is 
%  respect to viewing the BPM and CM lists.  If one edits a BPM or CM list, then the displayed 
%  list is relative to the "Start From" popup menu and not the "Plot Iteration" popup menu.
%  
%  II. Input menu
%  A.  Auto-Correct deltas
%  LocoFlags.AutoCorrectDelta = 'Yes' or 'No'
%  
%  Automatically adjust the delta used to compute the response matrix gradient.  
%  If AutoCorrectDeltaFlag = 'Yes', then the parameter deltas are adjusted to 
%  keep the RMS change in the response matrix change equal to 1 micron.  
%  If the RMS is within a factor of ten, then the delta is corrected but 
%  the response matrix is not recomputed.  Note: if FitParameters.Deltas = NaN 
%  and Autocorrect is off, then Fdelta will still be autocorrected once.
% 
%  B. Options for selecting the number of singular values
%  LocoFlags.SVmethod = 'Rank,' [], threshold, or an index vector
% 
%  If SVmethod is a scalar, then all singular values will be greater than Smax * SVmethod.
%  If SVmethod is empty, then singular values will be choosen manually (graphically).
%  If SVmethod is a vector, then that vector corresponds to the index of singular values.
%  If SVmethod is 'Rank', then singular values are removed if a Matlab warning for rank tolerance is exceeded.
% 
%  C. Include dispersion as a column of the response matrix
%  LocoFlags.Dispersion = 'Yes' or 'No'
% 
%  D. Use the fully coupled response matrix
%  LocoFlags.Coupling = 'Yes' or 'No'
% 
%  E. Normalize the parameter fit response matrix to the same RMS as the model response matrix
%  LocoFlags.Normalization.Flag = 'Yes' or 'No'
%  Note: if the RF frequency is fit, it is always normalized.
% 
%  F. Use linear response matrix calculator 
%  LocoFlags.ResponseMatrixCalculator = 'Linear'
% 
%  G. Outlier rejection 
%  LocoFlags.OutlierFactor = number of sigma
%
%  H.  Output U,S,V, and A matrices to a file
%  LocoFlags.SVDDataFileName = Directory\FileName or [] (ignored if empty)
% 
%  NOTE 
%  1. When saving A, S, V, U the outliers have been removed, however, 
%     the saved response matrix (measured and model) do not.
%
%  See LocoManual.doc, James SaFranek (the LOCO creator), Andrei Terebilo, or Greg Portmann for more information.
% 
%  Writen by Greg Portmann


% LOCOGUI Application M-file for locogui.fig
%    FIG = LOCOGUI launch locogui GUI.
%    LOCOGUI('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 21-Nov-2001 16:26:19

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'new');  % 'reuse'

	% Use system color scheme for figure (this seems to create platform dependent problems)
	%set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
    handles = guihandles(fig);
    guidata(fig, handles);
    
    if nargout > 0
        varargout{1} = fig;
    end

        
    % Change menu locations
    % set(findobj(fig,'tag','FileName'),'Position',1);
    % set(findobj(fig,'tag','FileName'),'Separator','Off');
    % set(findobj(fig,'tag','FileName'),'Interruptible','Off');
    % set(findobj(fig,'tag','Flags'),'Position',2);
    % set(findobj(fig,'tag','Flags'),'Separator','On');
    % set(findobj(fig,'tag','Flags'),'Interruptible','Off');
    % set(findobj(fig,'tag','Help'),'Interruptible','Off');
    
    % set(findobj(gcf,'tag','linear'),'enable','off')

    
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.


% --------------------------------------------------------------------
function varargout = Start_Callback(h, eventdata, handles, varargin)

% Get filename and try to load
FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
try
    load(FileName);
    FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');     % Just in case FileName happens to be saved in the .mat file
catch
    fprintf('   File does not exist or is not a *.mat file type.\n');
    axes(findobj(gcbf,'Tag','Axes1'));
    set(gca,'XTick',[]); set(gca,'YTick',[]); cla; title(' '); xlabel(' '); ylabel(' ');
    axes(findobj(gcbf,'Tag','Axes2'));
    set(gca,'XTick',[]); set(gca,'YTick',[]); cla; title(' '); xlabel(' '); ylabel(' ');
    return
end


% Check inputs and add defaults (should already be done)
%[BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});


StartFrom  = get(findobj(gcbf,'Tag','StartFrom'),'Value')-1;
Iterations = get(findobj(gcbf,'Tag','Iterations'),'Value');

    
% Clear old iterations if they exist
if StartFrom+2 <= length(FitParameters)
    fprintf('   Note:  You are writing over previous iterations.\n');
    LocoFlags(StartFrom+2:end) = [];
    BPMData(StartFrom+2:end) = [];
    CMData(StartFrom+2:end) = [];
    FitParameters(StartFrom+2:end) = [];
    LocoModel(:,StartFrom+2:end) = [];
end


for i = StartFrom+2:(StartFrom+2+Iterations-1)
    fprintf('   Iteration #%d\n', i-1);
    
    % Start with the old values
    BPMData(i) = BPMData(i-1);
    CMData(i) = CMData(i-1);
    FitParameters(i) = FitParameters(i-1);
    LocoFlags(i) = LocoFlags(i-1);
    
    % Check for a new (user input) BPM and CM good data lists  
    if ~isempty(get(findobj(gcbf,'Tag','HBPMIndex'), 'Userdata'))
        %fprintf('   Horizontal BPM list changed based on user input.\n');
        BPMData(i).HBPMGoodDataIndex = get(findobj(gcbf,'Tag','HBPMIndex'), 'Userdata');
    end
    if ~isempty(get(findobj(gcbf,'Tag','VBPMIndex'), 'Userdata'))
        %fprintf('   Vertical BPM list changed based on user input.\n');
        BPMData(i).VBPMGoodDataIndex = get(findobj(gcbf,'Tag','VBPMIndex'), 'Userdata');
    end
    if ~isempty(get(findobj(gcbf,'Tag','HCMIndex'), 'Userdata'))
        %fprintf('   Horizontal corrector magnet list changed based on user input.\n');
        CMData(i).HCMGoodDataIndex = get(findobj(gcbf,'Tag','HCMIndex'), 'Userdata');
    end
    if ~isempty(get(findobj(gcbf,'Tag','VCMIndex'), 'Userdata'))
        %fprintf('   Vertical corrector magnet list changed based on user input.\n');
        CMData(i).VCMGoodDataIndex = get(findobj(gcbf,'Tag','VCMIndex'), 'Userdata');
    end


    % Get flags
    if strcmpi((get(findobj(gcbf,'Tag','Rank'),'Checked')),'on') 
        % Rank method
        LocoFlags(i).SVmethod = 'Rank';
    elseif strcmpi((get(findobj(gcbf,'Tag','Threshold'),'Checked')),'on')
        % Threshold method
        LocoFlags(i).SVmethod = get(findobj(gcbf,'Tag','Threshold'),'Userdata');
    elseif strcmpi((get(findobj(gcbf,'Tag','Interactive'),'Checked')),'on')
        % Interactive method
        LocoFlags(i).SVmethod = [];
    elseif strcmpi((get(findobj(gcbf,'Tag','UserInput'),'Checked')),'on')
        % User Input method
        LocoFlags(i).SVmethod = get(findobj(gcbf,'Tag','UserInput'),'Userdata');
    else
        % Threshold method
        LocoFlags(i).SVmethod = get(findobj(gcbf,'Tag','Threshold'),'Userdata');        
    end
    
    LocoFlags(i).Threshold = get(findobj(gcbf,'Tag','Threshold'),'Userdata');
    LocoFlags(i).OutlierFactor = get(findobj(gcbf,'Tag','Outlier'),'Userdata');
    LocoFlags(i).HorizontalDispersionWeight = getappdata(gcbf,'HorizontalDispersionWeight');
    LocoFlags(i).VerticalDispersionWeight = getappdata(gcbf,'VerticalDispersionWeight');

    if strcmpi((get(findobj(gcf,'Tag','AutoCorrect'),'Checked')),'on')
        LocoFlags(i).AutoCorrectDelta = 'Yes';
    else
        LocoFlags(i).AutoCorrectDelta = 'No';
    end
        
    if strcmpi((get(findobj(gcf,'Tag','Coupling'),'Checked')),'on')
        LocoFlags(i).Coupling = 'Yes';
    else
        LocoFlags(i).Coupling = 'No';
    end
    
    if strcmpi((get(findobj(gcf,'Tag','Normalize'),'Checked')),'on')
        LocoFlags(i).Normalization.Flag = 'Yes';
    else
        LocoFlags(i).Normalization.Flag = 'No';
    end
    
    if strcmpi((get(findobj(gcf,'Tag','Dispersion'),'Checked')),'on')
        LocoFlags(i).Dispersion = 'Yes';
    else
        LocoFlags(i).Dispersion = 'No';
    end
    
    if strcmpi((get(findobj(gcf,'Tag','FitHCMEnergyShift'),'Checked')),'on')
        CMData(i).FitHCMEnergyShift = 'Yes';
    else
        CMData(i).FitHCMEnergyShift = 'No';
    end

    if strcmpi((get(findobj(gcf,'Tag','FitVCMEnergyShift'),'Checked')),'on')
        CMData(i).FitVCMEnergyShift = 'Yes';
    else
        CMData(i).FitVCMEnergyShift = 'No';
    end

    if strcmpi((get(findobj(gcf,'Tag','Linear'),'Checked')),'on')
        LocoFlags(i).ResponseMatrixCalculator = 'Linear';
    else %strcmpi((get(findobj(gcf,'Tag','Full'),'Checked')),'on')
        LocoFlags(i).ResponseMatrixCalculator = 'Full';
    end

    if strcmpi((get(findobj(gcf,'Tag','CM'),'Checked')),'on')
        LocoFlags(i).ClosedOrbitType = 'FixedMomentum';
    else %strcmpi((get(findobj(gcf,'Tag','CPL'),'Checked')),'on')
        LocoFlags(i).ClosedOrbitType = 'FixedPathLength';
    end

    if strcmpi((get(findobj(gcf,'Tag','RespMatBiDirectional'),'Checked')),'on')
        LocoFlags(i).ResponseMatrixMeasurement = 'BiDirectional';
    else %strcmpi((get(findobj(gcf,'Tag','RespMatOneWay'),'Checked')),'on')
        LocoFlags(i).ResponseMatrixMeasurement = 'OneWay';
    end

    if strcmpi((get(findobj(gcf,'Tag','DispBiDirectional'),'Checked')),'on')
        LocoFlags(i).DispersionMeasurement = 'BiDirectional';
    else %strcmpi((get(findobj(gcf,'Tag','DispOneWay'),'Checked')),'on')
        LocoFlags(i).DispersionMeasurement = 'OneWay';
    end
    
    if strcmpi((get(findobj(gcf,'Tag','ErrorBars'),'Checked')),'on')
        LocoFlags(i).CalculateSigma = 'Yes';
    else
        LocoFlags(i).CalculateSigma = 'No';
    end

    if strcmpi((get(findobj(gcf,'Tag','SinglePrecision'),'Checked')),'on')
        LocoFlags(i).SinglePrecision = 'Yes';
    else
        LocoFlags(i).SinglePrecision = 'No';
    end

    if strcmpi((get(findobj(gcf,'Tag','SVD_FileName'),'Checked')),'on')
        LocoFlags(i).SVDDataFileName = get(findobj(gcbf,'Tag','SVD_FileName'),'Userdata');
    else
        LocoFlags(i).SVDDataFileName = '';
    end
            
    if strcmpi((get(findobj(gcf,'Tag','FitRF'),'Checked')),'on')
        FitParameters(i).FitRFFrequency = 'Yes';
    else
        FitParameters(i).FitRFFrequency = 'No';
    end

    if strcmpi((get(findobj(gcf,'Tag','BPMGains'),'Checked')),'on')
        BPMData(i).FitGains = 'Yes';
    else
        BPMData(i).FitGains = 'No';
    end

    if strcmpi((get(findobj(gcf,'Tag','BPMCoupling'),'Checked')),'on')
        BPMData(i).FitCoupling = 'Yes';
    else
        BPMData(i).FitCoupling = 'No';
    end
    
    if strcmpi((get(findobj(gcf,'Tag','CMKicks'),'Checked')),'on')
        CMData(i).FitKicks = 'Yes';
    else
        CMData(i).FitKicks = 'No';
    end

    if strcmpi((get(findobj(gcf,'Tag','CMRolls'),'Checked')),'on')
        CMData(i).FitCoupling = 'Yes';
    else
        CMData(i).FitCoupling = 'No';
    end    
    
    if strcmpi(get(handles.GaussNewton,'Checked'),'on')
        LocoFlags(i).Method.Name    = 'Gauss-Newton';
    elseif strcmpi(get(handles.GaussNewtonWithCost,'Checked'),'on')
        LocoFlags(i).Method.Name    = 'Gauss-Newton With Cost Function';
        LocoFlags(i).Method.CostScaleFactor  = get(handles.CostScaleFactor,'Userdata');
    elseif strcmpi(get(handles.LevenbergMarquardt,'Checked'),'on')
        LocoFlags(i).Method.Name    = 'Levenberg-Marquardt';
        LocoFlags(i).Method.MaxIter = get(handles.MaxIterLM,'Userdata');
        LocoFlags(i).Method.Lambda  = get(handles.LambdaLM,'Userdata');
    elseif strcmpi(get(handles.ScaledLevenbergMarquardt,'Checked'),'on')
        LocoFlags(i).Method.Name    = 'Scaled Levenberg-Marquardt';
        LocoFlags(i).Method.MaxIter = get(handles.MaxIterLM,'Userdata');
        LocoFlags(i).Method.Lambda  = get(handles.LambdaLM,'Userdata');
    else
        error('Method unknown');
    end
    
    
    % Run loco
    [LocoModel(i), BPMData(i), CMData(i), FitParameters(i), LocoFlags(i), RINGData] = loco(LocoMeasData, BPMData(i), CMData(i), FitParameters(i), LocoFlags(i), RINGData);

    % Was a better solution found?
    if any(strcmpi(LocoFlags(i).Method.Name, {'Levenberg-Marquardt', 'Scaled Levenberg-Marquardt'}))
        if strcmpi(LocoFlags(i).Method.BetterSolution, 'No')
            % not needed: LocoModel(i) = []; BPMData(i) = []; CMData(i) = []; FitParameters(i) = []; LocoFlags(i) = [];
            fprintf('\n   Stopping at iteration %d since no better solution was found.\n\n', i-1);
            iLast = i-1;
            break;
        end
    end
    iLast = i;
    
    save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');
    setappdata(gcbf, 'LocoDataCell', {BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});
    
    % Plot
    set(findobj(gcbf,'Tag','PlotIteration'),'String',num2str((0:iLast-1)'));
    set(findobj(gcbf,'Tag','PlotIteration'),'Value', iLast); 
    MenuAxes_Callback(findobj(gcbf,'Tag','PlotMenu1'));
    MenuAxes_Callback(findobj(gcbf,'Tag','PlotMenu2'));
    load(FileName);
    drawnow;
end

set(findobj(gcbf,'Tag','StartFrom'),'String',num2str((0:iLast-1)'));
set(findobj(gcbf,'Tag','StartFrom'),'Value',iLast);

% Update menu items in case something was changed in loco
setmenuinputs(BPMData(end), CMData(end), LocoFlags(end), FitParameters(end), handles);


% --------------------------------------------------------------------
function varargout = LevenbergMarquardt_Callback(h, eventdata, handles, varargin)
set(handles.GaussNewton,             'Checked','off'); 
set(handles.GaussNewtonWithCost,     'Checked','off'); 
set(handles.LevenbergMarquardt,      'Checked','on'); 
set(handles.ScaledLevenbergMarquardt,'Checked','off'); 
set(handles.CostScaleFactor, 'Enable','off'); 
set(handles.LambdaLM,        'Enable','on'); 
set(handles.MaxIterLM,       'Enable','on');

%set(handles.LambdaLM, 'Label',['    Lambda = ',            num2str(get(handles.LambdaLM, 'Userdata'))]);
%set(handles.MaxIterLM,'Label',['    Maximum Iterations = ',num2str(get(handles.MaxIterLM,'Userdata'))]);

% --------------------------------------------------------------------
function varargout = ScaledLevenbergMarquardt_Callback(h, eventdata, handles, varargin)
set(handles.GaussNewton,             'Checked','off'); 
set(handles.GaussNewtonWithCost,     'Checked','off'); 
set(handles.LevenbergMarquardt,      'Checked','off'); 
set(handles.ScaledLevenbergMarquardt,'Checked','on'); 
set(handles.CostScaleFactor, 'Enable','off'); 
set(handles.LambdaLM,        'Enable','on'); 
set(handles.MaxIterLM,       'Enable','on');

%set(handles.LambdaLM, 'Label',['    Lambda = ',            num2str(get(handles.LambdaLM, 'Userdata'))]);
%set(handles.MaxIterLM,'Label',['    Maximum Iterations = ',num2str(get(handles.MaxIterLM,'Userdata'))]);


% --------------------------------------------------------------------
function varargout = CostScaleFactor_Callback(h, eventdata, handles, varargin)

CostScaleFactor = get(handles.CostScaleFactor,'Userdata');
if isempty(CostScaleFactor)
    CostScaleFactor = 1;
end

AnswerString = inputdlg({'CostScaleFactor (Levenberg-Marquardt):'},'LOCO',1,{num2str(CostScaleFactor)});
if ~isempty(AnswerString); 
    CostScaleFactor = str2num(AnswerString{1}); 
    set(handles.CostScaleFactor, 'Label', ['    Cost Scale Factor = ',num2str(CostScaleFactor)]); 
    set(handles.CostScaleFactor, 'Userdata', CostScaleFactor); 
end

% --------------------------------------------------------------------
function varargout = LambdaLM_Callback(h, eventdata, handles, varargin)

LambdaLM = get(handles.LambdaLM,'Userdata');
if isempty(LambdaLM)
    LambdaLM = .001;
end

AnswerString = inputdlg({'Lambda (Levenberg-Marquardt):'},'LOCO',1,{num2str(LambdaLM)});
if ~isempty(AnswerString); 
    LambdaLM = str2num(AnswerString{1}); 
    set(handles.LambdaLM, 'Label', ['    Lambda = ',num2str(LambdaLM)]); 
    set(handles.LambdaLM, 'Userdata', LambdaLM); 
end


% --------------------------------------------------------------------
function varargout = MaxIterLM_Callback(h, eventdata, handles, varargin)
MaxIterLM = get(handles.MaxIterLM, 'Userdata');
if isempty(MaxIterLM)
    MaxIterLM = 10;
end

AnswerString = inputdlg({'Maximum Iterations (Levenberg-Marquardt):'},'LOCO',1,{num2str(MaxIterLM)});
if ~isempty(AnswerString); 
    MaxIterLM = ceil(str2num(AnswerString{1})); 
    set(handles.MaxIterLM, 'Label', ['   Maximum Iterations = ',num2str(MaxIterLM)]); 
    set(handles.MaxIterLM, 'Userdata', MaxIterLM); 
end


% --------------------------------------------------------------------
function varargout = PlotIteration_Callback(h, eventdata, handles, varargin)
MenuAxes_Callback(handles.PlotMenu1);
MenuAxes_Callback(handles.PlotMenu2);


% --------------------------------------------------------------------
function varargout = OpenFile_Callback(h, eventdata, handles, varargin)

% Get filename and try to load
%FileName = deblank(get(h,'String'));
[FileName, PathName] = uigetfile({'*.*'}, 'Choose the desired loco data file');
if isequal(FileName,0) || isequal(PathName,0)
    return
end

set(gcbf,'Pointer','watch');

axes(findobj(gcbf,'Tag','Axes1'));
cla
set(gca, 'UIContextMenu', []);   % Clear content menu
set(gca,'XTick',[]); set(gca,'YTick',[]); cla; title(' '); xlabel(' '); ylabel(' ');
axes(findobj(gcbf,'Tag','Axes2'));
cla
set(gca, 'UIContextMenu', []);  % Clear content menu
set(gca,'XTick',[]); set(gca,'YTick',[]); cla; title(' '); xlabel(' '); ylabel(' ');

try
    idot = find(FileName=='.');
    
    % If the variable exist as a matlab script file, just read it
    if strcmp(FileName(idot:end),'.m') 
        % Convert .m file to a .mat file
        PresentDirectory = pwd;
        cd(PathName);
        eval(FileName(1:end-2));
        cd(PresentDirectory);
        FileName = [PathName,FileName,'at'];   % Make a mat file
        save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');
    elseif strcmp(FileName(idot:end),'.mat') 
        % .mat file
        FileName = [PathName, FileName];
        %load(FileName);
    else
        fprintf('   File must be of type .mat or .m.\n');
        error('  ');
    end
catch
    fprintf('   File open problem\n');
    axes(findobj(gcbf,'Tag','Axes1')); 
    cla; 
    axes(findobj(gcbf,'Tag','Axes2')); 
    cla;
    set(gcbf,'Pointer','arrow');
    return
end

% Check the file then reload
try
    [BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck(FileName);
    %[BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});
    %save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');
    setappdata(gcbf, 'LocoDataCell', {BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});
catch
    fprintf('   File open problem.\n');
    axes(findobj(gcbf,'Tag','Axes1')); 
    cla; 
    axes(findobj(gcbf,'Tag','Axes2')); 
    cla;
    fprintf('%s\n', lasterr);    
    set(gcbf,'Pointer','arrow');
    return
end

set(findobj(gcbf,'Tag','FileName'),'Userdata',FileName);
set(gcbf,'Name',['LOCO:  ',FileName]);

set(findobj(gcbf,'Tag','PlotIteration'),'String',num2str([0:length(CMData)-1]'));
set(findobj(gcbf,'Tag','PlotIteration'),'Value', length(CMData)); 
set(findobj(gcbf,'Tag','StartFrom'),'String',num2str([0:length(CMData)-1]'));
set(findobj(gcbf,'Tag','StartFrom'),'Value',length(CMData));

set(findobj(gcbf,'Tag','HBPMIndex'), 'Userdata', []); 
set(findobj(gcbf,'Tag','VBPMIndex'), 'Userdata', []); 
set(findobj(gcbf,'Tag','HCMIndex'), 'Userdata', []); 
set(findobj(gcbf,'Tag','VCMIndex'), 'Userdata', []); 


% Force plot #2 and #3 to avoid an error with response matrix plots which cache the filename
StringCell = get(handles.PlotMenu1,'String');
StringNumber = get(handles.PlotMenu1,'Value');
if ~isempty(strfind('response matrix',lower(StringCell{StringNumber})))
    set(handles.PlotMenu1,'Value', 2);
end
StringCell = get(handles.PlotMenu2,'String');
StringNumber = get(handles.PlotMenu2,'Value');
if ~isempty(strfind('response matrix',lower(StringCell{StringNumber})))
    set(handles.PlotMenu2,'Value', 3);
end
MenuAxes_Callback(findobj(gcbf,'Tag','PlotMenu1'), 1);
MenuAxes_Callback(findobj(gcbf,'Tag','PlotMenu2'), 1);

% Update menu items
setmenuinputs(BPMData(end), CMData(end), LocoFlags(end), FitParameters(end), handles);

set(gcbf,'Pointer','arrow');


% --------------------------------------------------------------------
function varargout = SVDDataSave_Callback(h, eventdata, handles, varargin)

if strcmpi((get(findobj(gcbf,'Tag','SVD_FileName'),'Checked')), 'on')
    set(findobj(gcbf,'Tag','SVD_FileName'),'Checked','Off');
    set(findobj(gcbf,'Tag','SVD_FileName'),'Label',['Save A,S,V,U,CovFit to File']);
    set(findobj(gcbf,'Tag','SVD_FileName'),'Userdata',[]);    
else
    [FileName, PathName] = uiputfile('*.mat', 'SVD data file name');
    if isequal(FileName,0) || isequal(PathName,0)
        set(findobj(gcbf,'Tag','SVD_FileName'),'Checked','Off');
        set(findobj(gcbf,'Tag','SVD_FileName'),'Label',['Save A,S,V,U,CovFit to File']);
        return
    end
    FileName = [PathName,FileName];
    set(findobj(gcbf,'Tag','SVD_FileName'),'Checked','On');
    set(findobj(gcbf,'Tag','SVD_FileName'),'Label',['Save A,S,V,U,CovFit to File: ', FileName]);
    set(findobj(gcbf,'Tag','SVD_FileName'),'Userdata',FileName);
end


% --------------------------------------------------------------------
function varargout = Diary_Callback(h, eventdata, handles, varargin)

if strcmpi((get(findobj(gcbf,'Tag','Diary'),'Checked')), 'on')
    set(findobj(gcbf,'Tag','Diary'),'Checked','Off');
    set(findobj(gcbf,'Tag','Diary'),'Label','Diary');
    set(findobj(gcbf,'Tag','Diary'),'Userdata',[]);
    diary off
else
    [FileName, PathName] = uiputfile('*.*', 'Diary file name');
    if isequal(FileName,0) || isequal(PathName,0)
        set(findobj(gcbf,'Tag','Diary'),'Checked','Off');
        set(findobj(gcbf,'Tag','Diary'),'Label','Diary');
        return
    end
    FileName = [PathName,FileName];
    set(findobj(gcbf,'Tag','Diary'),'Checked','On');
    set(findobj(gcbf,'Tag','Diary'),'Label',['Diary: ', FileName]);
    set(findobj(gcbf,'Tag','Diary'),'Userdata',FileName);
    diary(FileName);
end


% --------------------------------------------------------------------
function varargout = NewMeasRespMat_Callback(h, eventdata, handles, varargin)
FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
if isempty(FileName)
    fprintf('   LOCO data file does not exist (use File->Open).\n');
    return
end

% Get response matrix filename and try to load
fprintf('\n');
[FileNameMeas, PathNameMeas] = uigetfile('*.mat', 'New LOCO response mastrix data file name');
if isequal(FileNameMeas,0) || isequal(PathNameMeas,0)
    fprintf('   Measured response data file does not exist.\n\n');
    return
end
try
    load(FileNameMeas);    
    %if ~exist('LocoMeasData','var')
    %    fprintf('   LocoMeasData variable does not exist.\n');
    %    return
    %end
    if exist('LocoMeasData','var')
        fprintf('   LocoMeasData will be replaced\n');
    end
    if exist('BPMData','var')
        fprintf('   BPMData will be replaced\n');
    end
    if exist('CMData','var')
        fprintf('   CMData will be replaced\n');
    end
    if exist('FitParameters','var')
        fprintf('   FitParameters will be replaced\n');
    end
    if exist('LocoFlags','var')
        fprintf('   LocoFlags will be replaced\n');
    end
    if exist('RINGData','var')
        fprintf('   RINGData will be replaced\n');
    end
    %if exist('LocoModel','var')
    %    fprintf('   LocoModel will be replaced\n');
    %end
catch
    fprintf('   Measured response data file does not exist or is not a *.mat file type\n\n');
    return
end

AllExistFlag = (exist('LocoMeasData','var') & exist('BPMData','var') & exist('CMData','var') & exist('LocoModel','var') & exist('FitParameters','var') & exist('LocoFlags','var') & exist('RINGData','var'));
NoneExistFlag = (~exist('LocoMeasData','var') & ~exist('BPMData','var') & ~exist('CMData','var') & ~exist('LocoModel','var') & ~exist('FitParameters','var') & ~exist('LocoFlags','var') & ~exist('RINGData','var'));

if NoneExistFlag
    fprintf('   No LOCO variable found in this file\n\n');
    return;
end

fprintf('   LocoModel will be recomputed\n');
if AllExistFlag
    % Replace all variables (just like a OPEN)
else
    % Get filename and try to load
    try
        load(FileName);
    catch
        fprintf('   LOCO file does not exist or is not a *.mat file type\n\n');
        cla;
        return
    end
    
    % Which iteration do you want to associate the measured response matrix with
    if length(CMData) > 1
        for i = 1:length(CMData)
            NumList{i} = num2str(i-1);
        end
        IterNum = menu({'Which iteration # do you want the ','new data associated with?'}, NumList);
        if IterNum == 0
            fprintf('   No change made to the measured response matrix\n\n');
            return
        end
    else
        IterNum = 1;
    end
    
    FitParameters = FitParameters(IterNum);
    BPMData = BPMData(IterNum);
    CMData = CMData(IterNum);
    %LocoModel = LocoModel(IterNum);
    LocoFlags = LocoFlags(IterNum);
end

% Write over with the new data 
load(FileNameMeas);    


% Double check length of new variables (should be one if adding new variables)
if ~AllExistFlag
    if length(CMData) > 1
        for i = 1:length(CMData)
            NumList{i} = num2str(i-1);
        end
        IterNum = menu({'New data has more than one iteration #','Which iteration do you want to use?'}, NumList);
        if IterNum == 0
            fprintf('   No change made to the LOCO input file.\n');
            return
        end
        
        NewFileFlag = questdlg({sprintf('Only iteration #%d will be saved.',IterNum-1),'Do you want to change the LOCO file name?'},'New Response Matrix','Yes','No','No');
        if strcmp(NewFileFlag,'Yes')
            [FileName, PathName] = uiputfile('*.mat', 'New LOCO data file name');
            if isequal(FileName,0) || isequal(PathName,0)
                axes(findobj(gcbf,'Tag','Axes1'));
                cla;
                axes(findobj(gcbf,'Tag','Axes2'));
                cla;
                return
            end
            FileName = [PathName,FileName];
        end
    else
        IterNum = 1;
    end
    
    FitParameters = FitParameters(IterNum);
    BPMData = BPMData(IterNum);
    CMData = CMData(IterNum);
    %LocoModel = LocoModel(IterNum);
    LocoFlags = LocoFlags(IterNum);
end

try
    LocoModel = [];   % Clear the model because the RINGData, BPMData, or CMData may be different 
    [BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});
catch
    fprintf('   There were problems with the input file, so no changes were made.\n');
    return
end

fprintf('\n');

save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');
setappdata(gcbf, 'LocoDataCell', {BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});

set(findobj(gcbf,'Tag','FileName'),'Userdata',FileName);
set(gcbf,'Name',['LOCO:  ',FileName]);

set(findobj(gcbf,'Tag','HBPMIndex'), 'Userdata', []); 
set(findobj(gcbf,'Tag','VBPMIndex'), 'Userdata', []); 
set(findobj(gcbf,'Tag','HCMIndex'), 'Userdata', []); 
set(findobj(gcbf,'Tag','VCMIndex'), 'Userdata', []); 

set(findobj(gcbf,'Tag','PlotIteration'),'String',num2str([0:length(CMData)-1]'));
set(findobj(gcbf,'Tag','PlotIteration'),'Value', length(CMData)); 
set(findobj(gcbf,'Tag','StartFrom'),'String',num2str([0:length(CMData)-1]'));
set(findobj(gcbf,'Tag','StartFrom'),'Value',length(CMData));

MenuAxes_Callback(findobj(gcbf,'Tag','PlotMenu1'));
MenuAxes_Callback(findobj(gcbf,'Tag','PlotMenu2'));


% --------------------------------------------------------------------
function varargout = SaveAs_Callback(h, eventdata, handles, varargin)

% Get filename and try to load
FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
if isempty(FileName)
    fprintf('   Old data file does not exist.\n');
    return
end
try
    load(FileName);
catch
    fprintf('   Old data file does not exist or is not a *.mat file type.\n');
    cla;
    return
end

if strcmp(get(h,'Tag'),'SaveAsLastIteration')
    if length(CMData) > 1
        for i = 1:length(CMData)
            NumList{i} = num2str(i-1);
        end
        
        IterNum = menu('Which iteration #', NumList);
        if IterNum == 0
            fprintf('   Save aborted.\n');
            return
        end

        % Always keep the first iteration
        if IterNum ~= 1
            IterNum = [1 IterNum];
        end
        
        FitParameters = FitParameters(IterNum);
        BPMData = BPMData(IterNum);
        CMData = CMData(IterNum);
        LocoModel = LocoModel(IterNum);
        LocoFlags = LocoFlags(IterNum);
    end
end

[FileName, PathName] = uiputfile('*.mat', 'Loco data file name');
if isequal(FileName,0) || isequal(PathName,0)
    axes(findobj(gcbf,'Tag','Axes1'));
    cla;
    axes(findobj(gcbf,'Tag','Axes2'));
    cla;
    return
end
FileName = [PathName,FileName];

save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');
setappdata(gcbf, 'LocoDataCell', {BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});

set(findobj(gcbf,'Tag','FileName'),'Userdata',FileName);
set(gcbf,'Name',['LOCO:  ',FileName]);

set(findobj(gcbf,'Tag','PlotIteration'),'String',num2str([0:length(CMData)-1]'));
set(findobj(gcbf,'Tag','PlotIteration'),'Value', length(CMData)); 
set(findobj(gcbf,'Tag','StartFrom'),'String',num2str([0:length(CMData)-1]'));
set(findobj(gcbf,'Tag','StartFrom'),'Value',length(CMData));

MenuAxes_Callback(findobj(gcbf,'Tag','PlotMenu1'));
MenuAxes_Callback(findobj(gcbf,'Tag','PlotMenu2'));


% --------------------------------------------------------------------
function varargout = MenuUserInput_Callback(h, eventdata, handles, varargin)
AnswerString=inputdlg({'Which singular values:'},'LOCO',1,{sprintf('[%d:1]',1)});
if ~isempty(AnswerString); 
    Ivec = str2num(AnswerString{1}); 
    set(findobj(gcbf,'Tag','UserInput'),'Userdata',Ivec); 
    set(findobj(gcbf,'Tag','UserInput'),'Checked','on'); 
    set(findobj(gcbf,'Tag','Rank'),'Checked','off');
    set(findobj(gcbf,'Tag','Threshold'),'Checked','off'); 
    set(findobj(gcbf,'Tag','Interactive'),'Checked','off');
end

% --------------------------------------------------------------------
function varargout = MenuThreshold_Callback(h, eventdata, handles, varargin)
Threshold = get(findobj(gcbf,'Tag','Threshold'),'Userdata'); 

AnswerString=inputdlg({'Threshold:'},'LOCO',1,{num2str(Threshold)});
if ~isempty(AnswerString); 
    Threshold = str2num(AnswerString{1}); 
    set(findobj(gcbf,'Tag','Threshold'),'Label',['Threshold (',num2str(Threshold),')']); 
    set(findobj(gcbf,'Tag','Threshold'),'Userdata',Threshold); 
    set(findobj(gcbf,'Tag','UserInput'),'Checked','off'); 
    set(findobj(gcbf,'Tag','Rank'),'Checked','off');
    set(findobj(gcbf,'Tag','Threshold'),'Checked','on'); 
    set(findobj(gcbf,'Tag','Interactive'),'Checked','off');
end

% --------------------------------------------------------------------
function varargout = Outlier_Callback(h, eventdata, handles, varargin)
OutlierFactor = get(findobj(gcbf,'Tag','Outlier'),'Userdata');

AnswerString=inputdlg({'Outlier Factor: enter the # of sigma'},'LOCO',1,{num2str(OutlierFactor)});
if ~isempty(AnswerString)
    OutlierFactor = str2num(AnswerString{1}); 
    set(findobj(gcbf,'Tag','Outlier'),'Label',['Outlier Rejection (',num2str(OutlierFactor),' sigma)']); 
    set(findobj(gcbf,'Tag','Outlier'),'Userdata', OutlierFactor); 
    set(findobj(gcbf,'Tag','Outlier'),'Checked', 'on'); 
end


% --------------------------------------------------------------------
function varargout = HorizontalDispersion_Callback(h, eventdata, handles, varargin)
HorizontalDispersionWeight = getappdata(gcbf, 'HorizontalDispersionWeight');

AnswerString = inputdlg({'Horizontal Dispersion Weight'},'LOCO',1,{num2str(HorizontalDispersionWeight)});
if ~isempty(AnswerString)
    HorizontalDispersionWeight = abs(str2num(AnswerString{1})); 
    set(findobj(gcbf,'Tag','HorizontalDispersionWeight'),'Label', sprintf('    Weigh for Horizontal Dispersion = %f', HorizontalDispersionWeight)); 
    setappdata(gcbf,'HorizontalDispersionWeight', HorizontalDispersionWeight); 
end

% --------------------------------------------------------------------
function varargout = VerticalDispersion_Callback(h, eventdata, handles, varargin)
VerticalDispersionWeight = getappdata(gcbf, 'VerticalDispersionWeight');

AnswerString = inputdlg({'Vertical Dispersion Weight'},'LOCO',1,{num2str(VerticalDispersionWeight)});
if ~isempty(AnswerString)
    VerticalDispersionWeight = abs(str2num(AnswerString{1})); 
    set(findobj(gcbf,'Tag','VerticalDispersionWeight'),'Label', sprintf('    Weigh for Vertical     Dispersion = %f', VerticalDispersionWeight)); 
    setappdata(gcbf,'VerticalDispersionWeight', VerticalDispersionWeight); 
end


% --------------------------------------------------------------------
function varargout = HBPMIndex_Callback(h, eventdata, handles, varargin)

LocoDataCell = getappdata(gcbf, 'LocoDataCell');
if isempty(LocoDataCell)
    FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
    if isempty(FileName)
        fprintf('   File does not exist.\n');
        return
    end
    try
        load(FileName);
    catch
        fprintf('   File does not exist or is not a *.mat file type.\n');
        cla;
        return
    end
else
    BPMData = LocoDataCell{1};
end

StartFrom = get(findobj(gcbf,'Tag','StartFrom'),'Value');

if isempty(get(findobj(gcbf,'Tag','HBPMIndex'), 'Userdata'))
    Index = BPMData(StartFrom).HBPMGoodDataIndex;
else
    Index = get(findobj(gcbf,'Tag','HBPMIndex'), 'Userdata');
end

Checked = zeros(size(BPMData(StartFrom).HBPMIndex));
Checked(Index) = 1; 

tmp = BPMData(StartFrom).BPMIndex(BPMData(StartFrom).HBPMIndex);
Index = locoeditlist([(1:length(BPMData(StartFrom).HBPMIndex))' tmp(:)], 'BPM', Checked);
Index = Index(:,1);

set(findobj(gcbf,'Tag','HBPMIndex'), 'Userdata', Index); 

% --------------------------------------------------------------------
function varargout = VBPMIndex_Callback(h, eventdata, handles, varargin)

LocoDataCell = getappdata(gcbf, 'LocoDataCell');
if isempty(LocoDataCell)
    FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
    if isempty(FileName)
        fprintf('   File does not exist.\n');
        return
    end
    try
        load(FileName);
    catch
        fprintf('   File does not exist or is not a *.mat file type.\n');
        cla;
        return
    end
else
    BPMData = LocoDataCell{1};
end

StartFrom = get(findobj(gcbf,'Tag','StartFrom'),'Value');

if isempty(get(findobj(gcbf,'Tag','VBPMIndex'), 'Userdata'))
    Index = BPMData(StartFrom).VBPMGoodDataIndex;
else
    Index = get(findobj(gcbf,'Tag','VBPMIndex'), 'Userdata');
end

Checked = zeros(size(BPMData(StartFrom).VBPMIndex));
Checked(Index) = 1; 

tmp = BPMData(StartFrom).BPMIndex(BPMData(StartFrom).VBPMIndex);
Index = locoeditlist([(1:length(BPMData(StartFrom).VBPMIndex))' tmp(:)], 'BPM', Checked);
Index = Index(:,1);

set(findobj(gcbf,'Tag','VBPMIndex'), 'Userdata', Index); 


% --------------------------------------------------------------------
function varargout = HCMIndex_Callback(h, eventdata, handles, varargin)

LocoDataCell = getappdata(gcbf, 'LocoDataCell');
if isempty(LocoDataCell)
    FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
    if isempty(FileName)
        fprintf('   File does not exist.\n');
        return
    end
    try
        load(FileName);
    catch
        fprintf('   File does not exist or is not a *.mat file type.\n');
        cla;
        return
    end
else
    CMData = LocoDataCell{2};
end

StartFrom = get(findobj(gcbf,'Tag','StartFrom'),'Value');

if isempty(get(findobj(gcbf,'Tag','HCMIndex'), 'Userdata'))
    Index = CMData(StartFrom).HCMGoodDataIndex;
else
    Index = get(findobj(gcbf,'Tag','HCMIndex'), 'Userdata');
end

Checked = zeros(size(CMData(StartFrom).HCMIndex));
Checked(Index) = 1; 

Index = locoeditlist([(1:length(CMData(StartFrom).HCMIndex))'  CMData(StartFrom).HCMIndex(:)], 'HCM', Checked);
Index = Index(:,1);

set(findobj(gcbf,'Tag','HCMIndex'), 'Userdata', Index); 


% --------------------------------------------------------------------
function varargout = VCMIndex_Callback(h, eventdata, handles, varargin)

LocoDataCell = getappdata(gcbf, 'LocoDataCell');
if isempty(LocoDataCell)
    FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
    if isempty(FileName)
        fprintf('   File does not exist.\n');
        return
    end
    try
        load(FileName);
    catch
        fprintf('   File does not exist or is not a *.mat file type.\n');
        cla;
        return
    end
else
    CMData = LocoDataCell{2};
end

StartFrom = get(findobj(gcbf,'Tag','StartFrom'),'Value');

if isempty(get(findobj(gcbf,'Tag','VCMIndex'), 'Userdata'))
    Index = CMData(StartFrom).VCMGoodDataIndex;
else
    Index = get(findobj(gcbf,'Tag','VCMIndex'), 'Userdata');
end

Checked = zeros(size(CMData(StartFrom).VCMIndex));
Checked(Index) = 1; 

Index = locoeditlist([(1:length(CMData(StartFrom).VCMIndex))'  CMData(StartFrom).VCMIndex(:)], 'VCM', Checked);
Index = Index(:,1);

set(findobj(gcbf,'Tag','VCMIndex'), 'Userdata', Index); 


% --------------------------------------------------------------------
function varargout = StartFrom_Callback(h, eventdata, handles, varargin)
LocoDataCell = getappdata(gcbf, 'LocoDataCell');
if isempty(LocoDataCell)
    FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
    if isempty(FileName)
        fprintf('   File does not exist.\n');
        return
    end
    try
        load(FileName);
    catch
        fprintf('   File does not exist or is not a *.mat file type.\n');
        cla;
        return
    end
else
    BPMData       = LocoDataCell{1};
    CMData        = LocoDataCell{2};
    FitParameters = LocoDataCell{5};
    LocoFlags     = LocoDataCell{6};
end

StartFrom = get(findobj(gcbf,'Tag','StartFrom'),'Value') + 1;
StartFromSize = size(get(findobj(gcbf,'Tag','StartFrom'),'String'),1);
if StartFrom > StartFromSize
    StartFrom = StartFromSize;
end
setmenuinputs(BPMData(StartFrom), CMData(StartFrom), LocoFlags(StartFrom), FitParameters(StartFrom), handles);


% --------------------------------------------------------------------
function setmenuinputs(BPMData, CMData, LocoFlags, FitParameters, handles)

% Set BPM Indexes
set(findobj(gcbf,'Tag','HBPMIndex'), 'Userdata', BPMData.HBPMGoodDataIndex);
set(findobj(gcbf,'Tag','VBPMIndex'), 'Userdata', BPMData.VBPMGoodDataIndex);
set(findobj(gcbf,'Tag','HCMIndex'),  'Userdata', CMData.HCMGoodDataIndex);
set(findobj(gcbf,'Tag','VCMIndex'),  'Userdata', CMData.VCMGoodDataIndex);


% Set flags
set(findobj(gcbf,'Tag','Rank'),       'Checked','Off');
set(findobj(gcbf,'Tag','Threshold'),  'Checked','Off');
set(findobj(gcbf,'Tag','Interactive'),'Checked','Off');
set(findobj(gcbf,'Tag','UserInput'),  'Checked','Off');
set(findobj(gcbf,'Tag','Threshold'),  'Checked','Off');
if strcmpi((LocoFlags.SVmethod),'rank')
    set(findobj(gcbf,'Tag','Rank'),'Checked','On');
elseif length(LocoFlags.SVmethod) > 1
    set(findobj(gcbf,'Tag','UserInput'),'Userdata',LocoFlags.SVmethod); 
    set(findobj(gcbf,'Tag','UserInput'),'Checked','On');
elseif  length(LocoFlags.SVmethod) == 1
    set(findobj(gcbf,'Tag','Threshold'),'Checked','On');
elseif  isempty(LocoFlags.SVmethod)
    set(findobj(gcbf,'Tag','Interactive'),'Checked','On');
else
    set(findobj(gcbf,'Tag','Threshold'),'Checked','On');    
end

set(findobj(gcbf,'Tag','Threshold'),'Userdata', LocoFlags.Threshold);
set(findobj(gcbf,'Tag','Threshold'),'Label',['Threshold (',num2str(LocoFlags.Threshold),')']); 

set(findobj(gcbf,'Tag','Outlier'),'Userdata',LocoFlags.OutlierFactor); 
set(findobj(gcbf,'Tag','Outlier'),'Label',['Outlier Rejection (',num2str(LocoFlags.OutlierFactor),' sigma)']); 

setappdata(gcbf,'HorizontalDispersionWeight', LocoFlags.HorizontalDispersionWeight);
set(findobj(gcbf,'Tag','HorizontalDispersionWeight'),'Label', sprintf('    Weight for Horizontal Dispersion = %f', LocoFlags.HorizontalDispersionWeight)); 

setappdata(gcbf,'VerticalDispersionWeight', LocoFlags.VerticalDispersionWeight);
set(findobj(gcbf,'Tag','VerticalDispersionWeight'),'Label', sprintf('    Weight for Vertical     Dispersion = %f', LocoFlags.VerticalDispersionWeight)); 

if ischar(LocoFlags.Coupling)
    if strcmpi((LocoFlags.Coupling),'yes')
        set(findobj(gcbf,'Tag','Coupling'),'Checked','On');
    else
        set(findobj(gcbf,'Tag','Coupling'),'Checked','Off');
    end
end

if ischar(LocoFlags.AutoCorrectDelta)
    if strcmpi((LocoFlags.AutoCorrectDelta),'yes')
        set(findobj(gcbf,'Tag','AutoCorrect'),'Checked','On');
    else
        set(findobj(gcbf,'Tag','AutoCorrect'),'Checked','Off');
    end
end

if ischar(LocoFlags.Normalization.Flag)
    if strcmpi((LocoFlags.Normalization.Flag),'yes')
        set(findobj(gcbf,'Tag','Normalize'),'Checked','On');
    else
        set(findobj(gcbf,'Tag','Normalize'),'Checked','Off');
    end
end

if ischar(LocoFlags.Dispersion)
    if strcmpi((LocoFlags.Dispersion),'yes')
        set(findobj(gcbf,'Tag','Dispersion'),'Checked','On');
    else
        set(findobj(gcbf,'Tag','Dispersion'),'Checked','Off');
    end
end

if ischar(CMData.FitHCMEnergyShift)
    if strcmpi((CMData.FitHCMEnergyShift),'yes')
        set(findobj(gcbf,'Tag','FitHCMEnergyShift'),'Checked','On');
    else
        set(findobj(gcbf,'Tag','FitHCMEnergyShift'),'Checked','Off');
    end
end

if ischar(CMData.FitVCMEnergyShift)
    if strcmpi((CMData.FitVCMEnergyShift),'yes')
        set(findobj(gcbf,'Tag','FitVCMEnergyShift'),'Checked','On');
    else
        set(findobj(gcbf,'Tag','FitVCMEnergyShift'),'Checked','Off');
    end
end

if ischar(LocoFlags.ResponseMatrixCalculator)
    if strcmpi((LocoFlags.ResponseMatrixCalculator),'linear')
        set(findobj(gcbf,'Tag','Linear'),'Checked','On');
        set(findobj(gcbf,'Tag','Full'),'Checked','Off');
    else %strcmpi((LocoFlags.ResponseMatrixCalculator),'full')
        set(findobj(gcbf,'Tag','Linear'),'Checked','Off');
        set(findobj(gcbf,'Tag','Full'),'Checked','On');
    end
end

if ischar(LocoFlags.ClosedOrbitType)
    if strcmpi((LocoFlags.ClosedOrbitType),'fixedmomentum')
        set(findobj(gcbf,'Tag','CM'),'Checked','On');
        set(findobj(gcbf,'Tag','CPL'),'Checked','Off');
    else %strcmpi((LocoFlags.ClosedOrbitType),'fixedpathlength')
        set(findobj(gcbf,'Tag','CM'),'Checked','Off');
        set(findobj(gcbf,'Tag','CPL'),'Checked','On');
    end
end
    
if ischar(LocoFlags.ResponseMatrixMeasurement)
    if strcmpi((LocoFlags.ResponseMatrixMeasurement),'bidirectional')
        set(findobj(gcbf,'Tag','RespMatBiDirectional'),'Checked','On');
        set(findobj(gcbf,'Tag','RespMatOneWay'),'Checked','Off');
    else %strcmpi((LocoFlags.ResponseMatrixMeasurement),'oneway')
        set(findobj(gcbf,'Tag','RespMatBiDirectional'),'Checked','Off');
        set(findobj(gcbf,'Tag','RespMatOneWay'),'Checked','On');
    end
end

if ischar(LocoFlags.DispersionMeasurement)
    if strcmpi((LocoFlags.DispersionMeasurement),'bidirectional')
        set(findobj(gcbf,'Tag','DispBiDirectional'),'Checked','On');
        set(findobj(gcbf,'Tag','DispOneWay'),'Checked','Off');
    else %strcmpi((LocoFlags.DispersionMeasurement),'oneway')
        set(findobj(gcbf,'Tag','DispBiDirectional'),'Checked','Off');
        set(findobj(gcbf,'Tag','DispOneWay'),'Checked','On');
    end
end

if isfield(LocoFlags, 'CalculateSigma')
    if ischar(LocoFlags.CalculateSigma)
        if strcmpi(LocoFlags.CalculateSigma, 'Yes')
            set(findobj(gcf,'Tag','ErrorBars'),'Checked','on');
        else
            set(findobj(gcf,'Tag','ErrorBars'),'Checked','off');
        end
    end
end

if isfield(LocoFlags, 'SinglePrecision')
    if ischar(LocoFlags.SinglePrecision)
        if strcmpi(LocoFlags.SinglePrecision, 'Yes')
            set(findobj(gcf,'Tag','SinglePrecision'),'Checked','on');
        else
            set(findobj(gcf,'Tag','SinglePrecision'),'Checked','off');
        end
    end
end

if ~isempty(LocoFlags.SVDDataFileName) && ischar(LocoFlags.SVDDataFileName)
    set(findobj(gcbf,'Tag','SVD_FileName'),'Checked','On');
    set(findobj(gcbf,'Tag','SVD_FileName'),'Userdata',LocoFlags.SVDDataFileName);   
    set(findobj(gcbf,'Tag','SVD_FileName'),'Label',['Save A,S,V,U,CovFit to File: ', LocoFlags.SVDDataFileName]);
else
    set(findobj(gcbf,'Tag','SVD_FileName'),'Checked','Off');
    set(findobj(gcbf,'Tag','SVD_FileName'),'Userdata',[]);    
    set(findobj(gcbf,'Tag','SVD_FileName'),'Label',['Save A,S,V,U,CovFit to File: ', LocoFlags.SVDDataFileName]);
    set(findobj(gcbf,'Tag','SVD_FileName'),'Label',['Save A,S,V,U,CovFit to File']);
end

if ischar(FitParameters.FitRFFrequency)
    if strcmpi((FitParameters.FitRFFrequency),'yes')
        set(findobj(gcbf,'Tag','FitRF'),'Checked','On');
    else
        set(findobj(gcbf,'Tag','FitRF'),'Checked','Off');
    end
end

if ischar(BPMData.FitGains)
    if strcmpi((BPMData.FitGains),'yes')
        set(findobj(gcbf,'Tag','BPMGains'),'Checked','On');
    else
        set(findobj(gcbf,'Tag','BPMGains'),'Checked','Off');
    end
end

if ischar(BPMData.FitCoupling)
    if strcmpi((BPMData.FitCoupling),'yes')
        set(findobj(gcbf,'Tag','BPMCoupling'),'Checked','On');
    else
        set(findobj(gcbf,'Tag','BPMCoupling'),'Checked','Off');
    end
end

if ischar(CMData.FitKicks)
    if strcmpi((CMData.FitKicks),'yes')
        set(findobj(gcbf,'Tag','CMKicks'),'Checked','On');
    else
        set(findobj(gcbf,'Tag','CMKicks'),'Checked','Off');
    end
end

if ischar(CMData.FitCoupling)
    if strcmpi((CMData.FitCoupling),'yes')
        set(findobj(gcbf,'Tag','CMRolls'),'Checked','On');
    else
        set(findobj(gcbf,'Tag','CMRolls'),'Checked','Off');
    end
end

if isfield(LocoFlags,'Method')
    if strcmpi(LocoFlags.Method.Name, 'Gauss-Newton')
        set(handles.GaussNewton,             'Checked','on');
        set(handles.GaussNewtonWithCost,     'Checked','off');
        set(handles.LevenbergMarquardt,      'Checked','off');
        set(handles.ScaledLevenbergMarquardt,'Checked','off');
        set(handles.CostScaleFactor, 'Enable','off');
        set(handles.LambdaLM,        'Enable','off');
        set(handles.MaxIterLM,       'Enable','off');
    elseif strcmpi(LocoFlags.Method.Name, 'Gauss-Newton With Cost Function')
        set(handles.GaussNewton,             'Checked','off');
        set(handles.GaussNewtonWithCost,     'Checked','on');
        set(handles.LevenbergMarquardt,      'Checked','off');
        set(handles.ScaledLevenbergMarquardt,'Checked','off');
        set(handles.CostScaleFactor, 'Enable','on');
        set(handles.LambdaLM,        'Enable','off');
        set(handles.MaxIterLM,       'Enable','off');
    elseif strcmpi(LocoFlags.Method.Name, 'Levenberg-Marquardt')
        set(handles.GaussNewton,             'Checked','off');
        set(handles.GaussNewtonWithCost,     'Checked','off');
        set(handles.LevenbergMarquardt,      'Checked','on');
        set(handles.ScaledLevenbergMarquardt,'Checked','off');
        set(handles.CostScaleFactor, 'Enable','off');
        set(handles.LambdaLM,        'Enable','on');
        set(handles.MaxIterLM,       'Enable','on');
    elseif strcmpi(LocoFlags.Method.Name, 'Scaled Levenberg-Marquardt')
        set(handles.GaussNewton,             'Checked','off');
        set(handles.GaussNewtonWithCost,     'Checked','off');
        set(handles.LevenbergMarquardt,      'Checked','off');
        set(handles.ScaledLevenbergMarquardt,'Checked','on');
        set(handles.CostScaleFactor, 'Enable','off');
        set(handles.LambdaLM,        'Enable','on');
        set(handles.MaxIterLM,       'Enable','on');
    end

    if isfield(LocoFlags(end),'Method') && isfield(LocoFlags.Method,'Lambda') &&  ~isempty(LocoFlags.Method.Lambda)
        set(handles.LambdaLM, 'Userdata', LocoFlags.Method.Lambda);
        set(handles.MaxIterLM,'Userdata', LocoFlags.Method.MaxIter);
    end
    set(handles.LambdaLM, 'Label',['    Lambda = ',num2str(get(handles.LambdaLM, 'Userdata'))]);
    set(handles.MaxIterLM,'Label',['    Maximum Iterations = ',num2str(get(handles.MaxIterLM,'Userdata'))]);

    if isfield(LocoFlags,'Method') && isfield(LocoFlags.Method,'CostScaleFactor') &&  ~isempty(LocoFlags.Method.CostScaleFactor)
        set(handles.CostScaleFactor, 'Userdata', LocoFlags.Method.CostScaleFactor);
    end
    set(handles.CostScaleFactor, 'Label',['    Cost Scale Factor = ',num2str(get(handles.CostScaleFactor, 'Userdata'))]);
end


% --------------------------------------------------------------------
function varargout = MenuAxes_Callback(h, eventdata, handles, varargin)

if nargin > 1 
    setappdata(gcbf,'OtherParameterPlot1',[]);
    setappdata(gcbf,'OtherParameterPlot2',[]);
end

TagString = get(h,'Userdata');            % Axis tag is storage in the menu pulldown
PlotNumber = get(h,'Value');
h_axis = findobj(gcbf,'Tag',TagString);
axes(h_axis);
locoplots(PlotNumber);
set(h_axis,'Tag',TagString);                 % axes tag is lost if plot function is used
set(h_axis,'HandleVisibility','Callback');   % So no one else can plot to it.
%axes(h_axis);
%legend
%set(gca,'Tag',TagString);                 % axes tag is lost if plot function is used
%set(gca,'HandleVisibility','Callback');   % So no one else can plot to it.


% -------------------------------------------------------------------
function locoplots(PlotNumber, FieldName)

% Save the current axes
H_Axes = gca;

if nargin < 2
    FieldName = [];
end

LocoDataCell = getappdata(gcbf, 'LocoDataCell');
if isempty(LocoDataCell)
    FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
    if isempty(FileName)
        fprintf('   File does not exist.\n');
        return
    end
    try
        load(FileName);
    catch
        fprintf('   File does not exist or is not a *.mat file type.\n');
        cla;
        return
    end
else
    BPMData       = LocoDataCell{1};
    CMData        = LocoDataCell{2};
    LocoMeasData  = LocoDataCell{3};
    LocoModel     = LocoDataCell{4};
    FitParameters = LocoDataCell{5};
    LocoFlags     = LocoDataCell{6};
    RINGData      = LocoDataCell{7};
end

% Get the iteration number to plot
i = get(findobj(gcbf,'Tag','PlotIteration'),'Value');  % The first point in the array is starting point


% If the LocoModel does not exist, then compute it
if isempty(LocoModel(i).M) || isempty(LocoModel(i).ChiSquare)
    AxesTag = get(H_Axes,'Tag');
    [LocoModel(i).M, LocoModel(i).Eta, LocoModel(i).ChiSquare] = getmodelresponsematrix(BPMData(i), CMData(i), FitParameters(i), LocoFlags(i), LocoMeasData, RINGData);
    FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
    save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');
    setappdata(gcbf, 'LocoDataCell', {BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});
    set(H_Axes, 'Tag', AxesTag);
end


% Compute Chi2 verses parameter and save data
if PlotNumber == 16
    if ~isfield(LocoFlags(i),'Method') || ~isfield(LocoFlags(i).Method,'DeltaChi2') || ~isfield(LocoFlags(i).Method.DeltaChi2,'FitParameter') ...
            || isempty(LocoFlags(i).Method.DeltaChi2.FitParameter) || length(LocoFlags(i).Method.DeltaChi2.FitParameter)~=length(FitParameters(i).Values)
        LocoFlags(i).Method.DeltaChi2 = lococalcdeltachi2(LocoModel, LocoMeasData, BPMData, CMData, FitParameters, LocoFlags, RINGData,i-1, 'Display');
        FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
        save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');
        setappdata(gcbf, 'LocoDataCell', {BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});
    end
end


% Patch for a iteration zero bug fixed on 1-29-2004
NHBPM = length(BPMData(i).HBPMGoodDataIndex);
NVBPM = length(BPMData(i).VBPMGoodDataIndex);
NBPM  = NHBPM + NVBPM;
NHCM = length(CMData(i).HCMGoodDataIndex);
NVCM = length(CMData(i).VCMGoodDataIndex);
if any(size(LocoModel(i).M) ~= [NBPM NHCM+NVCM])
    AxesTag = get(H_Axes,'Tag');
    [LocoModel(i).M, LocoModel(i).Eta, LocoModel(i).ChiSquare] = getmodelresponsematrix(BPMData(i), CMData(i), FitParameters(i), LocoFlags(i), LocoMeasData, RINGData);
    FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
    save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');
    setappdata(gcbf, 'LocoDataCell', {BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});
    set(H_Axes, 'Tag', AxesTag);
end

Mmodel = LocoModel(i).M;

% Clear content menu
set(H_Axes, 'UIContextMenu', []);

legend off

try
    switch PlotNumber
        case 1
            plot(H_Axes,[0 1],[0 1],'w');
            title(H_Axes,'LOCO Input Parameter');
            set(H_Axes,'box','on');
            set(H_Axes,'XTick',[]);
            set(H_Axes,'YTick',[]);
            
            N = 1;
            if exist('LocoFlags','var')
                if ~isempty(LocoFlags)
                    
                    if isfield(LocoFlags(i), 'SinglePrecision')
                        if ischar(LocoFlags(i).SinglePrecision)
                            text(2,N,sprintf('Single Precision = %s', LocoFlags(i).SinglePrecision),'units','characters');
                            N = N + 1;
                        end
                    end

                    if isfield(LocoFlags(i), 'CalculateSigma')
                        if ischar(LocoFlags(i).CalculateSigma)
                            text(2,N,sprintf('Calculate Error Bars = %s', LocoFlags(i).CalculateSigma),'units','characters');
                            N = N + 1;
                        end
                    end
                    
                    if isfield(LocoFlags(i),'Dispersion')
                        text(2,N,sprintf('Include Dispersion = %s', LocoFlags(i).Dispersion),'units','characters');
                        N = N + 1;
                    end
                    if isfield(LocoFlags(i),'AutoCorrectDelta')
                        text(2,N,sprintf('Auto Correct Deltas = %s', LocoFlags(i).AutoCorrectDelta),'units','characters');
                        N = N + 1;
                    end
                    if isfield(LocoFlags(i),'Coupling')
                        text(2,N,sprintf('Include Off-Diagonal Terms = %s', LocoFlags(i).Coupling),'units','characters');
                        N = N + 1;
                    end
                    if isfield(LocoFlags(i),'ResponseMatrixCalculator')
                        text(2,N,sprintf('Response Matrix Calculator = %s', LocoFlags(i).ResponseMatrixCalculator),'units','characters');
                        N = N + 1;
                    end
                    if isfield(LocoFlags(i),'ClosedOrbitType')
                        text(2,N,sprintf('Response Matrix Closed Orbit = %s', LocoFlags(i).ClosedOrbitType),'units','characters');
                        N = N + 1;
                    end
                    if isfield(LocoFlags(i),'SVmethod')
                        if isempty(LocoFlags(i))
                            text(2,N,sprintf('Singular Value Selection = '),'units','characters');
                        elseif isempty(LocoFlags(i).SVmethod)
                            text(2,N,sprintf('Singular Value Selection = Interactive'),'units','characters');
                        elseif strcmpi((LocoFlags(i).SVmethod),'rank')
                            text(2,N,sprintf('Singular Value Selection = Rank'),'units','characters');
                        elseif length(LocoFlags(i).SVmethod) > 1
                            text(2,N,sprintf('Singular Value Selection = User Input'),'units','characters');
                        else   
                            text(2,N,sprintf('Singular Value Selection = Threshold (%f)',LocoFlags(i).Threshold),'units','characters');
                        end
                        N = N + 1;
                    end
                    if isfield(LocoFlags(i),'Normalize')
                        text(2,N,sprintf('Normalize = %s', LocoFlags(i).Normalization.Flag),'units','characters');
                        N = N + 1;
                    end
                end
            end    
            if isfield(FitParameters(i),'FitRFFrequency')
                text(2,N,sprintf('Fit RF Frequency = %s', FitParameters(i).FitRFFrequency),'units','characters');
                N = N + 1;
            end
            if isfield(CMData(i),'FitVCMEnergyShift')
                text(2,N,sprintf('Fit Energy Shifts at VCM = %s', CMData(i).FitVCMEnergyShift),'units','characters');
                N = N + 1;
            end
            if isfield(CMData(i),'FitHCMEnergyShift')
                text(2,N,sprintf('Fit Energy Shifts at HCM = %s', CMData(i).FitHCMEnergyShift),'units','characters');
                N = N + 1;
            end
            if isfield(CMData(i),'FitKicks')
                text(2,N,sprintf('Fit Corrector Magnet Gains = %s', CMData(i).FitKicks),'units','characters');
                N = N + 1;
            end
            if isfield(CMData(i),'FitCoupling')
                text(2,N,sprintf('Fit Corrector Magnet Rolls = %s', CMData(i).FitCoupling),'units','characters');
                N = N + 1;
            end
            if isfield(BPMData(i),'FitGains')
                text(2,N,sprintf('Fit BPM Gains = %s', BPMData(i).FitGains),'units','characters');
                N = N + 1;
            end
            if isfield(BPMData(i),'FitCoupling')
                text(2,N,sprintf('Fit BPM Coupling = %s', BPMData(i).FitCoupling),'units','characters');
                N = N + 1;
            end    
            if isfield(CMData(i),'VCMGoodDataIndex')
                text(2,N,sprintf('%d horizontal %d vertical CMs', length(CMData(i).HCMGoodDataIndex), length(CMData(i).VCMGoodDataIndex)),'units','characters');
                N = N + 1;
            end
            if isfield(BPMData(i),'HBPMGoodDataIndex')
                text(2,N,sprintf('%d horizontal %d vertical BPMs', length(BPMData(i).HBPMGoodDataIndex), length(BPMData(i).VBPMGoodDataIndex)),'units','characters');
                N = N + 1;
            end
            
        case 2        
            x = 1:length(CMData(i).HCMKicks);
            if isempty(CMData(i).HCMKicksSTD) || all(isnan(CMData(i).HCMKicksSTD))
                plot(x(CMData(i).HCMGoodDataIndex), CMData(i).HCMKicks(CMData(i).HCMGoodDataIndex), '.-');
            else
                errorbar(x(CMData(i).HCMGoodDataIndex), CMData(i).HCMKicks(CMData(i).HCMGoodDataIndex), CMData(i).HCMKicksSTD(CMData(i).HCMGoodDataIndex));
            end
            title(sprintf('Corrector Magnet Parameter Fits (%d)',length(CMData(i).HCMKicks(CMData(i).HCMGoodDataIndex))));
            ylabel(H_Axes,'Horizontal Kick [mrad]');
            xlabel(H_Axes,'Horizontal Corrector Number');
            axis tight
            
        case 3
            x = 1:length(CMData(i).VCMKicks);
            if isempty(CMData(i).VCMKicksSTD) || all(isnan(CMData(i).VCMKicksSTD))
                plot(x(CMData(i).VCMGoodDataIndex), CMData(i).VCMKicks(CMData(i).VCMGoodDataIndex), '.-');
            else
                errorbar(x(CMData(i).VCMGoodDataIndex), CMData(i).VCMKicks(CMData(i).VCMGoodDataIndex), CMData(i).VCMKicksSTD(CMData(i).VCMGoodDataIndex));
            end
            title(sprintf('Corrector Magnet Parameter Fits (%d)',length(CMData(i).VCMKicks(CMData(i).VCMGoodDataIndex))));
            ylabel(H_Axes,'Vertical Kick [mrad]');
            xlabel(H_Axes,'Vertical Corrector Number');
            axis tight;
            
        case 4
            if ~isempty(CMData(i).HCMCoupling)
                x = 1:length(CMData(i).HCMCoupling);
                if isempty(CMData(i).HCMCouplingSTD) || all(isnan(CMData(i).HCMCouplingSTD))
                    plot(x(CMData(i).HCMGoodDataIndex), CMData(i).HCMCoupling(CMData(i).HCMGoodDataIndex), '.-');
                else
                    errorbar(x(CMData(i).HCMGoodDataIndex), CMData(i).HCMCoupling(CMData(i).HCMGoodDataIndex), CMData(i).HCMCouplingSTD(CMData(i).HCMGoodDataIndex));
                end
                title(sprintf('Corrector Magnet Parameter Fits (%d)',length(CMData(i).HCMCoupling(CMData(i).HCMGoodDataIndex))));
                ylabel(H_Axes,'Horizontal Coupling');
                xlabel(H_Axes,'Horizontal Corrector Number');
                axis tight
            else
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            end
            
        case 5
            if ~isempty(CMData(i).VCMCoupling)
                x = 1:length(CMData(i).VCMCoupling);
                if isempty(CMData(i).VCMCouplingSTD) || all(isnan(CMData(i).VCMCouplingSTD))
                    plot(x(CMData(i).VCMGoodDataIndex), CMData(i).VCMCoupling(CMData(i).VCMGoodDataIndex), '.-');
                else    
                    errorbar(x(CMData(i).VCMGoodDataIndex), CMData(i).VCMCoupling(CMData(i).VCMGoodDataIndex), CMData(i).VCMCouplingSTD(CMData(i).VCMGoodDataIndex));
                end
                title(sprintf('Corrector Magnet Parameter Fits (%d)',length(CMData(i).VCMCoupling(CMData(i).VCMGoodDataIndex))));
                ylabel(H_Axes,'Vertical Coupling');
                xlabel(H_Axes,'Vertical Corrector Number');
                axis tight;
            else
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            end
            
        case 6   
            if ~isempty(CMData(i).HCMEnergyShift)
                x = 1:length(CMData(i).HCMEnergyShift);
                if isempty(CMData(i).HCMEnergyShiftSTD) || all(isnan(CMData(i).HCMEnergyShiftSTD))
                    plot(x(CMData(i).HCMGoodDataIndex), CMData(i).HCMEnergyShift(CMData(i).HCMGoodDataIndex), '.-');
                else
                    errorbar(x(CMData(i).HCMGoodDataIndex), CMData(i).HCMEnergyShift(CMData(i).HCMGoodDataIndex), CMData(i).HCMEnergyShiftSTD(CMData(i).HCMGoodDataIndex));
                end
                title(sprintf('Corrector Magnet Parameter Fits (%d)',length(CMData(i).HCMEnergyShift(CMData(i).HCMGoodDataIndex))));
                ylabel(H_Axes,'Horizontal Energy Shift');
                xlabel(H_Axes,'Horizontal Corrector Number');
                axis tight
            else
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            end
            
        case 7
            if ~isempty(CMData(i).VCMEnergyShift)
                x = 1:length(CMData(i).VCMEnergyShift);
                if isempty(CMData(i).VCMEnergyShiftSTD) || all(isnan(CMData(i).VCMEnergyShiftSTD))
                    plot(x(CMData(i).VCMGoodDataIndex), CMData(i).VCMEnergyShift(CMData(i).VCMGoodDataIndex), '.-');
                else
                    errorbar(x(CMData(i).VCMGoodDataIndex), CMData(i).VCMEnergyShift(CMData(i).VCMGoodDataIndex), CMData(i).VCMEnergyShiftSTD(CMData(i).VCMGoodDataIndex));
                end
                title(sprintf('Corrector Magnet Parameter Fits (%d)',length(CMData(i).VCMEnergyShift(CMData(i).VCMGoodDataIndex))));
                ylabel(H_Axes,'Vertical Energy Shift');
                xlabel(H_Axes,'Vertical Corrector Number');
                axis tight
            else
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            end
            
        case 8
            x = 1:length(BPMData(i).HBPMGain);
            if isempty(BPMData(i).HBPMGainSTD) || all(isnan(BPMData(i).HBPMGainSTD))
                plot(x(BPMData(i).HBPMGoodDataIndex), BPMData(i).HBPMGain(BPMData(i).HBPMGoodDataIndex), '.-');
            else
                errorbar(x(BPMData(i).HBPMGoodDataIndex), BPMData(i).HBPMGain(BPMData(i).HBPMGoodDataIndex), BPMData(i).HBPMGainSTD(BPMData(i).HBPMGoodDataIndex));
            end
            title(sprintf('BPM Parameter Fits (%d)',length(BPMData(i).HBPMGain(BPMData(i).HBPMGoodDataIndex))));
            ylabel(H_Axes,'BPMx Gain');
            xlabel(H_Axes,'Horizontal BPM Number');
            axis tight
            
        case 9
            x = 1:length(BPMData(i).VBPMGain);
            if isempty(BPMData(i).VBPMGainSTD) || all(isnan(BPMData(i).VBPMGainSTD))
                plot(x(BPMData(i).VBPMGoodDataIndex), BPMData(i).VBPMGain(BPMData(i).VBPMGoodDataIndex), '.-');
            else
                errorbar(x(BPMData(i).VBPMGoodDataIndex), BPMData(i).VBPMGain(BPMData(i).VBPMGoodDataIndex), BPMData(i).VBPMGainSTD(BPMData(i).VBPMGoodDataIndex));
            end
            title(sprintf('BPM Parameter Fits (%d)',length(BPMData(i).VBPMGain(BPMData(i).VBPMGoodDataIndex))));
            ylabel(H_Axes,'BPMy Gain');
            xlabel(H_Axes,'Vertical BPM Number');
            axis tight;
            
        case 10
            x = 1:length(BPMData(i).HBPMCoupling);
            if ~isempty(BPMData(i).HBPMCoupling)
                if isempty(BPMData(i).HBPMCouplingSTD) || all(isnan(BPMData(i).HBPMCouplingSTD))
                    plot(x(BPMData(i).HBPMGoodDataIndex), BPMData(i).HBPMCoupling(BPMData(i).HBPMGoodDataIndex), '.-');
                else
                    errorbar(x(BPMData(i).HBPMGoodDataIndex), BPMData(i).HBPMCoupling(BPMData(i).HBPMGoodDataIndex), BPMData(i).HBPMCouplingSTD(BPMData(i).HBPMGoodDataIndex));
                end
                title(sprintf('BPM Parameter Fits (%d)',length(BPMData(i).HBPMCoupling(BPMData(i).HBPMGoodDataIndex))));
                ylabel(H_Axes,'BPMx Coupling');
                xlabel(H_Axes,'Horizontal BPM Number');
                axis tight
            else
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            end
            
        case 11
            x = 1:length(BPMData(i).VBPMCoupling);
            if ~isempty(BPMData(i).VBPMCoupling)
                if isempty(BPMData(i).VBPMCouplingSTD)|| all(isnan(BPMData(i).VBPMCouplingSTD))
                    plot(x(BPMData(i).VBPMGoodDataIndex), BPMData(i).VBPMCoupling(BPMData(i).VBPMGoodDataIndex), '.-');
                else
                    errorbar(x(BPMData(i).VBPMGoodDataIndex), BPMData(i).VBPMCoupling(BPMData(i).VBPMGoodDataIndex), BPMData(i).VBPMCouplingSTD(BPMData(i).VBPMGoodDataIndex));
                end
                title(sprintf('BPM Parameter Fits (%d)',length(BPMData(i).VBPMCoupling(BPMData(i).VBPMGoodDataIndex))));
                ylabel(H_Axes,'BPMy Coupling');
                xlabel(H_Axes,'Vertical BPM Number');
                axis tight;
            else
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            end

        case 12
            % HBPM Standard Deviations            
            BPMstd = LocoMeasData.BPMSTD(BPMData(i).HBPMGoodDataIndex);
            
            %BPMstd = LocoMeasData.BPMSTD([BPMData(i).HBPMGoodDataIndex length(BPMData(i).HBPMIndex)+BPMData(i).VBPMGoodDataIndex]);
            %if ~isempty(BPMstd)
            %    plot(BPMstd)
            %    ylabel(H_Axes,'Standard Deviation [mm]');
            %    axis tight
            %    
            %    % Change label to BPM numbers
            %    Nx = length(BPMstd);
            %    Ticks = 1:ceil(Nx/10):Nx;
            %    set(H_Axes, 'XTick', Ticks);      
            %    TickNumber = [BPMData(i).HBPMGoodDataIndex BPMData(i).VBPMGoodDataIndex];
            %    TickNumber = TickNumber(Ticks);
            %    set(H_Axes, 'XTickLabel', num2cell(TickNumber));         
            %    xlabel(H_Axes,'HBPM# and VBPM#');
            %end
            
            if ~isempty(BPMstd)                
                plot(BPMstd, '.-');
                title(H_Axes,'Horizontal BPM Standard Deviations');
                ylabel(H_Axes,'Standard Deviation [mm]');
                xlabel(H_Axes,'BPM Number');
                axis tight
            end

        case 13
            % VBPM Standard Deviations            
            BPMstd = LocoMeasData.BPMSTD(length(BPMData(i).HBPMIndex)+BPMData(i).VBPMGoodDataIndex);
            
            if ~isempty(BPMstd)                
                plot(BPMstd, '.-');
                title(H_Axes,'Vertical BPM Standard Deviations');
                ylabel(H_Axes,'Standard Deviation [mm]');
                xlabel(H_Axes,'BPM Number');
                axis tight
            end

        case 14
            if isempty(FitParameters(i).DeltaRF)
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            else
                plot(H_Axes,[0 1],[0 1],'w');
                title(H_Axes,'RF Frequency');
                set(H_Axes,'box','on');
                set(H_Axes,'XTick',[]);
                set(H_Axes,'YTick',[]);
                text(4,10,sprintf('Dispersion Measurement'),'units','characters');
                text(4,9,sprintf('RF Frequency Change:'),'units','characters');
                text(4,8,sprintf('%8.3f Hz Measured',  LocoMeasData.DeltaRF),'units','characters');
                text(4,7,sprintf('%8.3f Hz Model', FitParameters(i).DeltaRF),'units','characters');
                
                text(4,6,sprintf('%10.5f Hz \\sigma-Model', FitParameters(i).DeltaRFSTD),'units','characters');
                if isfield(FitParameters(i),'FitRFFrequency')
                    text(4,5,sprintf('Fit Delta RF Frequency = %s', FitParameters(i).FitRFFrequency),'units','characters');
                end    
                if isfield(LocoMeasData,'RF')
                    text(4,3,sprintf('RF Frequency = %.1f Hz (Measured)', LocoMeasData.RF),'units','characters');
                end    
                if isfield(RINGData,'CavityFrequency')
                    text(4,2,sprintf('RF Frequency = %.1f Hz (Model)', RINGData.CavityFrequency'),'units','characters');
                end    
            end            
            
        case 15
            % Other parameters
            if isempty(FitParameters(i).Values)
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
                return;
            elseif length(FitParameters(i).Values) > 1
                ATFlag = 0;
                if iscell(RINGData.Lattice)
                    if isfield(RINGData.Lattice{1},'FamName') 
                        ATFlag = 1;
                    end
                end
                
                AxesTag = get(H_Axes,'Tag');
                if strcmp(AxesTag,'Axes1')
                    FieldName = getappdata(gcbf,'OtherParameterPlot1');
                elseif strcmp(AxesTag,'Axes2')
                    FieldName = getappdata(gcbf,'OtherParameterPlot2');
                end
                
                if isempty(FieldName) || strcmp(FieldName, 'All')
                    if isempty(FitParameters(i).ValuesSTD) || all(isnan(FitParameters(i).ValuesSTD))
                        plot(1:length(FitParameters(i).Values), FitParameters(i).Values, '.-b');
                    else
                        errorbar(1:length(FitParameters(i).Values), FitParameters(i).Values, FitParameters(i).ValuesSTD);
                    end
                    title(H_Axes,'LOCO Parameter Fits');
                    ylabel(H_Axes,'');
                    xlabel(H_Axes,'Parameter Number');
                    axis tight
                    %fprintf('   Right click in the axis to select different parameter plots.\n');
                    
                else
                    ParameterNumber = [];Values=[]; ValuesSTD=[];
                    for j = 1:length(FitParameters(i).Params)
                        if ATFlag
                            Name = RINGData.Lattice{FitParameters(i).Params{j}(1).ElemIndex}.FamName;
                            SubField = FitParameters(i).Params{j}(1).FieldName;
                            Name = [Name,'.',SubField];
                        else
                            Name = FitParameters(i).Params{j}(1).FieldName;
                        end
                        
                        if strcmp(Name, FieldName)
                            Values = [Values FitParameters(i).Values(j)];
                            ParameterNumber = [ParameterNumber j];
                            if isempty(FitParameters(i).ValuesSTD)
                                ValuesSTD = [];
                            else
                                ValuesSTD = [ValuesSTD FitParameters(i).ValuesSTD(j)];
                            end
                        end
                    end
                    if isempty(ValuesSTD) || all(isnan(ValuesSTD))
                        if length(Values) == 1
                            plot(ParameterNumber, Values, 'squareb','MarkerFaceColor','b');
                        else
                            %plot(1:length(Values), Values);
                            plot(ParameterNumber, Values, '.-b');
                        end
                    else
                        %errorbar(1:length(Values), Values, ValuesSTD);
                        errorbar(ParameterNumber, Values, ValuesSTD);
                    end
                    title(H_Axes,['LOCO Parameter Fits for Field: ', FieldName]);
                    ylabel(H_Axes,'');
                    xlabel(H_Axes,'Parameter Number');
                    axis tight
                end
                
                % Add a context menu
                hcmenu = uicontextmenu;
                
                % Define the line and associate it with the context menu
                set(H_Axes, 'UIContextMenu', hcmenu);
                
                % Define the context menu items        
                cb = 'locogui(''ContextMenuPlot_Callback'',gcbo,[],[])';
                h = uimenu(hcmenu, 'Label', 'All', 'Callback', cb);
                set(h,'Userdata','All');
                if ATFlag
                    % When using the AT model this will work
                    j = 1;
                    cb = 'locogui(''ContextMenuPlot_Callback'',gcbo,[],[])';
                    NameNew = RINGData.Lattice{FitParameters(i).Params{j}(1).ElemIndex}.FamName;
                    SubField = FitParameters(i).Params{j}(1).FieldName;
                    %h = uimenu(hcmenu, 'Label', NameNew, 'Callback', cb);
                    h = uimenu(hcmenu, 'Label',[NameNew,'.',SubField], 'Callback', cb);
                    %set(h,'Userdata',NameNew);
                    set(h,'Userdata',[NameNew,'.',SubField]);
                    %Names{1} = NameNew;
                    Names{1} = [NameNew,'.',SubField];
                    for j = 2:length(FitParameters(i).Params)
                        NameNew = RINGData.Lattice{FitParameters(i).Params{j}(1).ElemIndex}.FamName;
                        SubField = FitParameters(i).Params{j}(1).FieldName;
                        %if ~any(strcmp(NameNew, Names))
                        if ~any(strcmp([NameNew,'.',SubField], Names))
                            %Names{end+1} = NameNew;
                            Names{end+1} = [NameNew,'.',SubField];
                            cb = 'locogui(''ContextMenuPlot_Callback'',gcbo,[],[])';
                            %h = uimenu(hcmenu, 'Label', NameNew, 'Callback', cb);
                            h = uimenu(hcmenu, 'Label',[NameNew,'.',SubField], 'Callback', cb);
                            %set(h,'Userdata',NameNew);
                            set(h,'Userdata',[NameNew,'.',SubField]);
                        end
                    end
                else
                    % Base names on paramgroup
                    j = 1;
                    cb = 'locogui(''ContextMenuPlot_Callback'',gcbo,[],[])';
                    h = uimenu(hcmenu, 'Label', FitParameters(i).Params{1}(1).FieldName, 'Callback', cb);
                    set(h,'Userdata',FitParameters(i).Params{j}(1).FieldName);
                    for j = 2:length(FitParameters(i).Params)
                        if ~strcmp(FitParameters(i).Params{j}(1).FieldName, FitParameters(i).Params{j-1}(1).FieldName)
                            cb = 'locogui(''ContextMenuPlot_Callback'',gcbo,[],[])';
                            h = uimenu(hcmenu, 'Label', FitParameters(i).Params{j}(1).FieldName, 'Callback', cb);
                            set(h,'Userdata',FitParameters(i).Params{j}(1).FieldName);
                        end
                    end
                end
                
            else
                plot(H_Axes,[0 1],[0 1],'w');
                title(H_Axes,'LOCO Parameter Fits');
                set(H_Axes,'box','on');
                set(H_Axes,'XTick',[]);
                set(H_Axes,'YTick',[]);
                text(4,6,sprintf('Parameter Fit #1'),'units','characters');
                text(4,5,sprintf('Value = %f', FitParameters(i).Values),'units','characters');
                text(4,4,sprintf('\\sigma = %f', FitParameters(i).ValuesSTD),'units','characters');
                %text(.05,.6,sprintf('Parameter Fit #1:  Value = %f, \\sigma = %f', FitParameters(i).Values, FitParameters(i).Values));
            end

        case 16
            % Plot delta chi^2 w.r.t. fit parameter
            if isfield(LocoFlags(i),'Method') && isfield(LocoFlags(i).Method,'DeltaChi2') && isfield(LocoFlags(i).Method.DeltaChi2,'FitParameter') && ~isempty(LocoFlags(i).Method.DeltaChi2.FitParameter)
                axes(H_Axes);
                if 0
                    plot(1:length(LocoFlags(i).Method.DeltaChi2.FitParameter), LocoFlags(i).Method.DeltaChi2.FitParameter,'.-');
                    ylabel(H_Axes,'\Delta \chi^2', 'FontSize', 14);
                else
                    semilogy(1:length(LocoFlags(i).Method.DeltaChi2.FitParameter), abs(LocoFlags(i).Method.DeltaChi2.FitParameter),'.-');
                    ylabel(H_Axes,'\mid\Delta \chi^2\mid', 'FontSize', 14);
                end
                title(H_Axes,'');
                xlabel(H_Axes,'Fit Parameter Index', 'FontSize', 10);
                title(H_Axes,'\Delta \chi^2 vs Fit Parameter', 'FontSize', 10);
                %grid  on;
                axis tight;
                d = .08;
                text(.03,.9-0*d, sprintf('\\Delta \\chi^2(All BPMs) = %.1f',          LocoFlags(i).Method.DeltaChi2.BPMGroup),          'FontSize', 10, 'Units','Normalized');
                text(.03,.9-1*d, sprintf('\\Delta \\chi^2(All CMs)  = %.1f',          LocoFlags(i).Method.DeltaChi2.CMGroup),           'FontSize', 10, 'Units','Normalized');
                text(.03,.9-2*d, sprintf('\\Delta \\chi^2(All FitParameters) = %.1f', LocoFlags(i).Method.DeltaChi2.FitParameterGroup), 'FontSize', 10, 'Units','Normalized');
            else
                % No data probably because delta chi^2 calculation was canceled
                cla;
                plot(H_Axes,[0 1],[0 1],'w');
                set(H_Axes,'XTick',[]);
                set(H_Axes,'YTick',[]);
                title(H_Axes,' ');
                xlabel(H_Axes,' '); ylabel(H_Axes,' ');
                text(.45,.5,sprintf('No Data'),'Units','Normalized');
                return
            end

        case 17
            % Plot partial chi^2 w.r.t. fit parameter
            if isfield(LocoFlags(i),'Method') && isfield(LocoFlags(i).Method,'PartialChi2') && ~isempty(fieldnames(LocoFlags(i).Method.PartialChi2))
                AxesTag = get(H_Axes,'Tag');
                if strcmp(AxesTag,'Axes1')
                    Userdata = getappdata(gcbf, 'PartialChi2Plot1');
                elseif strcmp(AxesTag,'Axes2')
                    Userdata = getappdata(gcbf, 'PartialChi2Plot2');
                end
                if isempty(Userdata)
                    Userdata = {'All', H_Axes};
                    if strcmp(AxesTag,'Axes1')
                        setappdata(gcbf, 'PartialChi2Plot1', Userdata);
                    elseif strcmp(AxesTag,'Axes2')
                        setappdata(gcbf, 'PartialChi2Plot2', Userdata);
                    end
                end

                PlotPartialChi2;
                
                % Define the context menu for the plot
                hcmenu = uicontextmenu('Tag','PartialChi2Plot');
                set(H_Axes, 'UIContextMenu', hcmenu);
                h = uimenu(hcmenu, 'Label', 'All', 'Callback', 'locogui(''ContextPartialChi2Plot_Callback'',gcbo,[],[])');
                set(h,'Userdata',{'All', H_Axes});
                FieldCell = fieldnames(LocoFlags(i).Method.PartialChi2);
                for ifield = 1:length(FieldCell)
                    h = uimenu(hcmenu, 'Label', FieldCell{ifield}, 'Callback', 'locogui(''ContextPartialChi2Plot_Callback'',gcbo,[],[])');
                    set(h,'Userdata',{FieldCell{ifield}, H_Axes});
                end
                %fprintf('   Right click in the axis to select different plots.\n');

            else
                % No data
                cla;
                plot(H_Axes,[0 1],[0 1],'w');
                set(H_Axes,'XTick',[]);
                set(H_Axes,'YTick',[]);
                title(H_Axes,' ');
                xlabel(H_Axes,' '); ylabel(H_Axes,' ');
                text(.35,.5,sprintf('No  \\partial\\chi^2 / \\partialFitParamter Data'),'Units','Normalized');
                return
            end
            
                        
        case 18
            % Plot cost function
            if isfield(LocoFlags(i),'Method') && isfield(LocoFlags(i).Method,'Cost')&& isstruct(LocoFlags(i).Method.Cost) && ~isempty(fieldnames(LocoFlags(i).Method.Cost))
                AxesTag = get(H_Axes,'Tag');
                if strcmp(AxesTag,'Axes1')
                    Userdata = getappdata(gcbf, 'CostFunctionPlot1');
                elseif strcmp(AxesTag,'Axes2')
                    Userdata = getappdata(gcbf, 'CostFunctionPlot2');
                end
                if isempty(Userdata)
                    Userdata = {'All', H_Axes};
                    if strcmp(AxesTag,'Axes1')
                        setappdata(gcbf, 'CostFunctionPlot1', Userdata);
                    elseif strcmp(AxesTag,'Axes2')
                        setappdata(gcbf, 'CostFunctionPlot2', Userdata);
                    end
                end

                PlotCostFunction;
                
                % Define the context menu for the plot
                hcmenu = uicontextmenu('Tag','PlotCostFunction');
                set(H_Axes, 'UIContextMenu', hcmenu);
                h = uimenu(hcmenu, 'Label', 'All', 'Callback', 'locogui(''ContextCostFunctionPlot_Callback'',gcbo,[],[])');
                set(h,'Userdata',{'All', H_Axes});
                FieldCell = fieldnames(LocoFlags(i).Method.Cost);
                for ifield = 1:length(FieldCell)
                    h = uimenu(hcmenu, 'Label', FieldCell{ifield}, 'Callback', 'locogui(''ContextCostFunctionPlot_Callback'',gcbo,[],[])');
                    set(h,'Userdata',{FieldCell{ifield}, H_Axes});
                end
                %fprintf('   Right click in the axis to select different parameter costs.\n');

            else
                % No data
                cla;
                plot(H_Axes,[0 1],[0 1],'w');
                set(H_Axes,'XTick',[]);
                set(H_Axes,'YTick',[]);
                title(H_Axes,' ');
                xlabel(H_Axes,' '); ylabel(H_Axes,' ');
                text(.35,.5,sprintf('No Cost Function Data'),'Units','Normalized');
                return
            end
       
        case 19
            if ~exist('LocoFlags','var') || ~isfield(LocoFlags(i), 'Method') || ~isfield(LocoFlags(i).Method, 'SV') || isempty(LocoFlags(i).Method.SV)
                cla;
                plot(H_Axes,[0 1],[0 1],'w');
                set(H_Axes,'XTick',[]);
                set(H_Axes,'YTick',[]);
                title(H_Axes,' ');
                xlabel(H_Axes,' '); ylabel(H_Axes,' ');
                text(.45,.5,sprintf('No Data'),'Units','Normalized');
                return
            else
                SValues = LocoFlags(i).Method.SV;
                Ivec = LocoFlags(i).Method.SVIndex;
                
                semilogy(SValues,'b');
                hold on; 
                semilogy(Ivec, SValues(Ivec),'og','MarkerSize',2); 
                axis([1 length(SValues) min(SValues) max(SValues)]);
                
                x=1:length(SValues);
                x(Ivec)=[];
                SValues(Ivec)=[];
                semilogy(x, SValues,'xr','MarkerSize',4); 
                hold off
                
                title(H_Axes,'Singular Values');
                xlabel(H_Axes,'Singular Value Number');
                ylabel(H_Axes,'Magnitude');
            end
            
        case 20
            % Response matrix plot
            
            AxesTag = get(H_Axes,'Tag');
            if strcmp(AxesTag,'Axes1')
                h = findobj(gcbf,'Tag','SurfPlot1');
                FieldName = get(h,'Userdata');
            elseif strcmp(AxesTag,'Axes2')
                h = findobj(gcbf,'Tag','SurfPlot2');
                FieldName = get(h,'Userdata');
            end
            
            if ~iscell(FieldName)
                FieldName = {'Model', 'All'};
                %FieldName = {'Measured', 'All'};
                %fprintf('   Right click in the axis to select different plots.\n');
            else
                % Force the field to Model when a new file or one of the pulldown menus is selected
                %FieldName = {'Model', 'All'};
            end
            
            
            PlotString  = FieldName{1};
            PlaneString = FieldName{2}; 
            if length(FieldName) > 2 
                ElementsInput = FieldName{3};
            else
                ElementsInput = [];
            end
            
            set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            FieldName{3} = locoplot({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, i-1, PlotString, PlaneString, ElementsInput);
            % if isempty(Mmodel)
            %     set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            %     return
            % end
            set(h,'Userdata', FieldName);
            
            
            % Define the context menu items for surf plot 
            hcmenu = uicontextmenu('Tag','3dsurfplot');
            set(H_Axes, 'UIContextMenu', hcmenu);
            
            h = uimenu(hcmenu, 'Label', 'Model: 3-D, All', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model','All'});
            h = uimenu(hcmenu, 'Label', 'Model: 3-D, HBPM vs HCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model','XX'});
            h = uimenu(hcmenu, 'Label', 'Model: 3-D, HBPM vs VCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model','XY'});
            h = uimenu(hcmenu, 'Label', 'Model: 3-D, VBPM vs VCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model','YY'});
            h = uimenu(hcmenu, 'Label', 'Model: 3-D, VBPM vs HCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model','YX'});
            
            h = uimenu(hcmenu, 'Label', 'Model: 2-D, HBPM (Rows)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model','HBPM'});
            h = uimenu(hcmenu, 'Label', 'Model: 2-D, VBPM (Rows)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model','VBPM'});
            h = uimenu(hcmenu, 'Label', 'Model: 2-D, HCM (Columns)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model','HCM'});
            h = uimenu(hcmenu, 'Label', 'Model: 2-D, VCM (Columns)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model','VCM'});
            
            h = uimenu(hcmenu, 'Label', ' ', 'Callback', '');
            
            h = uimenu(hcmenu, 'Label', 'Measured: 3-D, All', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Measured','All'});
            h = uimenu(hcmenu, 'Label', 'Measured: 3-D, HBPM vs HCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Measured','XX'});
            h = uimenu(hcmenu, 'Label', 'Measured: 3-D, HBPM vs VCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Measured','XY'});
            h = uimenu(hcmenu, 'Label', 'Measured: 3-D, VBPM vs VCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Measured','YY'});
            h = uimenu(hcmenu, 'Label', 'Measured: 3-D, VBPM vs HCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Measured','YX'});
            
            h = uimenu(hcmenu, 'Label', 'Measured: 2-D, HBPM (Rows)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Measured','HBPM'});
            h = uimenu(hcmenu, 'Label', 'Measured: 2-D, VBPM (Rows)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Measured','VBPM'});
            h = uimenu(hcmenu, 'Label', 'Measured: 2-D, HCM (Columns)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Measured','HCM'});
            h = uimenu(hcmenu, 'Label', 'Measured: 2-D, VCM (Columns)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Measured','VCM'});
            
            h = uimenu(hcmenu, 'Label', ' ', 'Callback', '');
            
            h = uimenu(hcmenu, 'Label', 'Model-Measured: 3-D, All', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured','All'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured: 3-D, HBPM vs HCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured','XX'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured: 3-D, HBPM vs VCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured','XY'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured: 3-D, VBPM vs VCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured','YY'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured: 3-D, VBPM vs HCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured','YX'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured: 2-D, HBPM (Rows)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured','HBPM'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured: 2-D, VBPM (Rows)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured','VBPM'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured: 2-D, HCM (Columns)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured','HCM'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured: 2-D, VCM (Columns)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured','VCM'});
            
            h = uimenu(hcmenu, 'Label', ' ', 'Callback', '');
            
            h = uimenu(hcmenu, 'Label', 'Model-Measured+EnergyShifts: 3-D, All', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured+EnergyShifts','All'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured+EnergyShifts: 3-D, HBPM vs HCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured+EnergyShifts','XX'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured+EnergyShifts: 3-D, HBPM vs VCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured+EnergyShifts','XY'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured+EnergyShifts: 3-D, VBPM vs VCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured+EnergyShifts','YY'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured+EnergyShifts: 3-D, VBPM vs HCM', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured+EnergyShifts','YX'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured+EnergyShifts: 2-D, HBPM (Rows)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured+EnergyShifts','HBPM'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured+EnergyShifts: 2-D, VBPM (Rows)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured+EnergyShifts','VBPM'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured+EnergyShifts: 2-D, HCM (Columns)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured+EnergyShifts','HCM'});
            h = uimenu(hcmenu, 'Label', 'Model-Measured+EnergyShifts: 2-D, VCM (Columns)', 'Callback', 'locogui(''ContextMenuSurfPlot_Callback'',gcbo,[],[])');
            set(h,'Userdata',{'Model-Measured+EnergyShifts','VCM'});
            
        case 21
            % Error function histogram
            plot(0,0); set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            
            ErrorFunction = locodata({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, i-1, 'ErrorDistribution');
            if ~isempty(ErrorFunction)
                hist(ErrorFunction,2000);
                xlabel(H_Axes,'Error in Units of Standard Deviations');
                ylabel(H_Axes,['Number of Points (',num2str(length(ErrorFunction)),' total points)']);
                %title(texlabel(['Histogram: (M_meas - M_model)']));
                title(texlabel(['Histogram: (M_meas - M_model) / sigma_bpm']));
                %title(texlabel(['Histogram: (M_meas - M_model)^2 / sigma^2_bpm']));
                
                a = axis;
                axis([a(1)-(a(2)-a(1))/60 a(2) a(3) a(4)]);
                %OutlierFactor = LocoFlags(i).OutlierFactor;
            end

        case 22
            % Horizontal dispersion function    
            plot(0,0); set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            
            if 1
                % Only plotting horizontal dispersion   
                NHBPM = length(BPMData(i).HBPMGoodDataIndex);
                x = 1:length(BPMData(i).HBPMIndex);
                x = x(BPMData(i).HBPMGoodDataIndex);
                
                if isempty(LocoModel(i).Eta)
                    EtaModel = NaN*ones(size(x))';
                    fprintf('   Model dispersion is empty.\n');
                else
                    EtaModel = LocoModel(i).Eta(1:NHBPM);                   
                end
                if isempty(LocoMeasData.Eta)
                    EtaMeas = NaN*ones(size(x))';
                    fprintf('   Measured dispersion is empty.\n');
                else
                    EtaMeas = LocoMeasData.Eta(BPMData(i).HBPMGoodDataIndex);
                end
                
                plot(x, EtaMeas,'-b');
                hold on;
                plot(x, EtaModel,'--r');        
                
                % Add circles for the outliers                   
                EtaOutliers = LocoModel(i).EtaOutlierIndex;
                j = find(EtaOutliers <= NHBPM);      % Only horizontal data
                if ~isempty(j)
                    plot(x(EtaOutliers(j)),EtaMeas(EtaOutliers(j)),'og','MarkerSize',2);
                    legend('Measured','Model','Outliers', 'Location', 'Best');
                else
                    legend('Measured','Model', 'Location', 'Best');
                end
                
                hold off
                title(sprintf('"Dispersion" Function (%d BPMs)',length(EtaModel)));
                ylabel(H_Axes,'"Dispersion" [mm]');
                xlabel(H_Axes,'Horizontal BPM Number');
                axis tight
            else
                % Horizontal and vertical dispersion
                NHBPM = length(BPMData(i).HBPMGoodDataIndex);
                NVBPM = length(BPMData(i).VBPMGoodDataIndex);
                NBPM  = NHBPM + NVBPM;
                NHCM = length(CMData(i).HCMGoodDataIndex);
                NVCM = length(CMData(i).VCMGoodDataIndex);
                
                if isempty(LocoModel(i).Eta)
                    EtaModel = NaN;
                    fprintf('   Model dispersion is empty.\n');
                else
                    EtaModel = LocoModel(i).Eta;                   
                end
                if isempty(LocoMeasData.Eta)
                    EtaMeas = NaN;
                    fprintf('   Measured dispersion is empty.\n');
                else
                    EtaMeas = LocoMeasData.Eta([BPMData(i).HBPMGoodDataIndex length(BPMData(i).HBPMIndex)+BPMData(i).VBPMGoodDataIndex]);
                end
                
                plot(EtaMeas,'-b');
                hold on;
                plot(EtaModel,'--r');        
                
                % Add circles for the outliers                   
                EtaOutliers = LocoModel(i).EtaOutlierIndex;
                x = 1:length(EtaMeas);
                if ~isempty(EtaOutliers)
                    plot(x(EtaOutliers),EtaMeas(EtaOutliers),'ob','MarkerSize',2);
                    if all(isnan(EtaModel))
                        fprintf('   Model dispersion is NaN.\n');
                        legend('Measured','Outliers', 'Location', 'Best');
                    else
                        legend('Measured','Model','Outliers', 'Location', 'Best');
                    end
                else
                    if all(isnan(EtaModel))
                        fprintf('   Model dispersion is NaN.\n');
                        %legend off
                        legend('Measured', 'Location', 'Best');
                    else
                        legend('Measured','Model', 'Location', 'Best');
                    end
                end
                
                hold off
                title(sprintf('"Dispersion" Function (%d BPMs)',length(EtaModel)));
                ylabel(H_Axes,'"Dispersion" [mm]');
                xlabel(H_Axes,'BPM Number');
                
                % Change label to BPM numbers
                Nx = length(EtaMeas);
                Ticks = 1:ceil(Nx/10):Nx;
                set(H_Axes, 'XTick', Ticks);      
                TickNumber = [BPMData(i).HBPMGoodDataIndex BPMData(i).VBPMGoodDataIndex];
                TickNumber = TickNumber(Ticks);
                set(H_Axes, 'XTickLabel', num2cell(TickNumber));         
                xlabel(H_Axes,'HBPM# and VBPM#');
                
                axis tight
            end
            
        case 23
            % Vertical dispersion function    
            plot(0,0); set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            
            % Only plotting vertical dispersion   
            NHBPM = length(BPMData(i).HBPMGoodDataIndex);
            NVBPM = length(BPMData(i).VBPMGoodDataIndex);
            NBPM  = NHBPM + NVBPM;
            NHCM = length(CMData(i).HCMGoodDataIndex);
            NVCM = length(CMData(i).VCMGoodDataIndex);
            
            x = 1:length(BPMData(i).VBPMIndex);
            x = x(BPMData(i).VBPMGoodDataIndex);
            
            if isempty(LocoModel(i).Eta)
                EtaModel = NaN*ones(size(x))';
                fprintf('   Model dispersion is empty.\n');
            else
                EtaModel = LocoModel(i).Eta(NHBPM+(1:NVBPM));
            end
            if isempty(LocoMeasData.Eta)
                EtaMeas = NaN*ones(size(x))';
                fprintf('   Measured dispersion is empty.\n');
            else
                EtaMeas = LocoMeasData.Eta(length(BPMData(i).HBPMIndex)+BPMData(i).VBPMGoodDataIndex);
            end
            
            plot(x, EtaMeas,'-b');
            hold on;
            plot(x, EtaModel,'--r');        
            
            % Add circles for the outliers                   
            EtaOutliers = LocoModel(i).EtaOutlierIndex;
            j = find(EtaOutliers > NHBPM);      % Only vertical data
            EtaOutliers = EtaOutliers(j) - NHBPM;
            if ~isempty(j)
                hold on
                plot(x(EtaOutliers), EtaMeas(EtaOutliers), 'og', 'MarkerSize',2);
                hold off
                legend('Measured', 'Model', 'Outliers', 'Location', 'Best');
            else
                legend('Measured','Model', 'Location', 'Best');
            end
            
            hold off
            title(sprintf('"Dispersion" Function (%d BPMs)',length(EtaModel)));
            ylabel(H_Axes,'"Dispersion" [mm]');
            xlabel(H_Axes,'Vertical BPM Number');
            axis tight
            
        case 24  
            % Dispersion function error
            plot(0,0); set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            
            % Horizontal dispersion
            if 1
                % Only plot horizontal dispersion  
                NHBPM = length(BPMData(i).HBPMGoodDataIndex);
                x = 1:length(BPMData(i).HBPMIndex);
                x = x(BPMData(i).HBPMGoodDataIndex);
                
                if isempty(LocoModel(i).Eta)
                    EtaModel = NaN*ones(size(x))';
                    fprintf('   Model dispersion is empty.\n');
                else
                    EtaModel = LocoModel(i).Eta(1:NHBPM);                   
                end
                if isempty(LocoMeasData.Eta)
                    EtaMeas = NaN*ones(size(x))';
                    fprintf('   Measured dispersion is empty.\n');
                else
                    EtaMeas = LocoMeasData.Eta(BPMData(i).HBPMGoodDataIndex);
                end
                
                plot(x, EtaMeas-EtaModel,'-b');
                
                % Add circles for the outliers                   
                EtaOutliers = LocoModel(i).EtaOutlierIndex;
                j = find(EtaOutliers <= NHBPM);      % Only horizontal data
                if ~isempty(j)
                    hold on;
                    plot(x(EtaOutliers(j)),EtaMeas(EtaOutliers(j))-EtaModel(EtaOutliers(j)),'og','MarkerSize',2);
                    hold off;
                    legend('Measured-Model','Outliers', 'Location', 'Best');
                end
                
                if all(isnan(EtaModel))
                    fprintf('   Model dispersion is NaN.\n');
                    legend off
                end
                
                hold off
                title(sprintf('"Dispersion" Function Error (%d BPMs)',length(EtaModel)));
                ylabel(H_Axes,'"Dispersion" Error [mm]');
                xlabel(H_Axes,'Horizontal BPM Number');
                axis tight
            else
                % Horizontal and vertical dispersion
                NHBPM = length(BPMData(i).HBPMGoodDataIndex);
                NVBPM = length(BPMData(i).VBPMGoodDataIndex);
                NBPM  = NHBPM + NVBPM;
                NHCM = length(CMData(i).HCMGoodDataIndex);
                NVCM = length(CMData(i).VCMGoodDataIndex);
                
                if isempty(LocoModel(i).Eta)
                    EtaModel = NaN;
                    fprintf('   Model dispersion is empty.\n');
                else
                    EtaModel = LocoModel(i).Eta;                   
                end
                if isempty(LocoMeasData.Eta)
                    EtaMeas = NaN;
                    fprintf('   Measured dispersion is empty.\n');
                else
                    EtaMeas = LocoMeasData.Eta([BPMData(i).HBPMGoodDataIndex length(BPMData(i).HBPMIndex)+BPMData(i).VBPMGoodDataIndex]);
                end
                
                plot(EtaMeas-EtaModel,'-b');
                
                % Add circles for the outliers                   
                EtaOutliers = LocoModel(i).EtaOutlierIndex;
                x = 1:length(EtaMeas);
                if ~isempty(EtaOutliers)
                    hold on;
                    plot(x(EtaOutliers),EtaMeas(EtaOutliers)-EtaModel(EtaOutliers),'og','MarkerSize',2);
                    hold off;
                    legend('Measured-Model','Outliers', 'Location', 'Best');
                end
                
                hold off
                title(sprintf('"Dispersion" Function Error (%d BPMs)',length(EtaModel)));
                ylabel(H_Axes,'"Dispersion" Error [mm]');
                xlabel(H_Axes,'BPM Number');
                
                % Change label to BPM numbers
                Nx = length(EtaMeas);
                Ticks = 1:ceil(Nx/10):Nx;
                set(H_Axes, 'XTick', Ticks);      
                TickNumber = [BPMData(i).HBPMGoodDataIndex BPMData(i).VBPMGoodDataIndex];
                TickNumber = TickNumber(Ticks);
                set(H_Axes, 'XTickLabel', num2cell(TickNumber));         
                xlabel(H_Axes,'HBPM# and VBPM#');
                
                axis tight
            end
            
        case 25
            % Vertical dispersion error function    
            plot(0,0); set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            
            % Only plotting vertical dispersion   
            NHBPM = length(BPMData(i).HBPMGoodDataIndex);
            NVBPM = length(BPMData(i).VBPMGoodDataIndex);
            NBPM  = NHBPM + NVBPM;
            NHCM = length(CMData(i).HCMGoodDataIndex);
            NVCM = length(CMData(i).VCMGoodDataIndex);
            
            x = 1:length(BPMData(i).VBPMIndex);
            x = x(BPMData(i).VBPMGoodDataIndex);
            
            if isempty(LocoModel(i).Eta)
                EtaModel = NaN*ones(size(x))';
                fprintf('   Model dispersion is empty.\n');
            else
                EtaModel = LocoModel(i).Eta(NHBPM+(1:NVBPM));
            end
            if isempty(LocoMeasData.Eta)
                EtaMeas = NaN*ones(size(x))';
                fprintf('   Measured dispersion is empty.\n');
            else
                EtaMeas = LocoMeasData.Eta(length(BPMData(i).HBPMIndex)+BPMData(i).VBPMGoodDataIndex);
            end
            
            plot(x, EtaMeas-EtaModel,'-b');
            
            % Add circles for the outliers                   
            EtaOutliers = LocoModel(i).EtaOutlierIndex;
            j = find(EtaOutliers > NHBPM);      % Only vertical data
            EtaOutliers = EtaOutliers(j) - NHBPM;
            if ~isempty(j)
                hold on
                plot(x(EtaOutliers), EtaMeas(EtaOutliers)-EtaModel(EtaOutliers), 'og', 'MarkerSize',2);
                hold off
                legend('Measured-Model','Outliers', 'Location', 'Best');
            end
            
            title(sprintf('"Dispersion" Function Error (%d BPMs)',length(EtaModel)));
            ylabel(H_Axes,'"Dispersion" Error [mm]');
            xlabel(H_Axes,'Vertical BPM Number');
            axis tight
            
        case 26
            % Horizontal Beta
            plot(H_Axes,[0 1],[0 1],'w'); set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            set(H_Axes,'box','on');
            text(4,11,sprintf('Please wait ...'),'units','characters');
            text(4, 9,sprintf('Computing Beta Functions'),'units','characters');
            drawnow;
            
            [Beta1, Tune1] = locodata({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, i-1, 'Beta',[],'Tune',[]);
            if ~isempty(Beta1) && isreal(Beta1)
                plot(Beta1(:,3), Beta1(:,1), 'b');
                xlabel(H_Axes,'Position [meters]');
                ylabel(H_Axes,'Horizontal Beta Function [meters]');
                title(texlabel(sprintf('Model Beta Function (nu_x=%.4f)',Tune1(1))));
                try
                    L = findspos(RINGData.Lattice,length(RINGData.Lattice)+1);
                    if ~isempty(Beta1)
                        set(H_Axes, 'XLim', [0 L]);
                    end
                catch
                end
            else
                plot(H_Axes,[0 1],[0 1],'w');
                title(H_Axes,'');
                set(H_Axes,'box','on');
                set(H_Axes,'XTick',[]);
                set(H_Axes,'YTick',[]);
                text(4, 9,sprintf('There was a problem computing the beta function.'),'units','characters');
                drawnow;
            end
            
        case 27
            % Vertical Beta
            plot(H_Axes,[0 1],[0 1],'w'); set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            set(H_Axes,'box','on');
            text(4,11,sprintf('Please wait ...'),'units','characters');
            text(4, 9,sprintf('Computing Beta Functions'),'units','characters');
            drawnow;
            
            [Beta1, Tune1] = locodata({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, i-1, 'Beta',[],'Tune',[]);
            if ~isempty(Beta1) && isreal(Beta1)
                plot(Beta1(:,3), Beta1(:,2), 'b'); 
                xlabel(H_Axes,'Position [meters]');
                ylabel(H_Axes,'Vertical Beta Function [meters]');
                title(texlabel(sprintf('Model Beta Function (nu_y=%.4f)', Tune1(2))));
                try
                    L = findspos(RINGData.Lattice,length(RINGData.Lattice)+1);
                    if ~isempty(Beta1)
                        set(H_Axes, 'XLim', [0 L]);
                    end
                catch
                end
            else
                plot(H_Axes,[0 1],[0 1],'w');
                title(H_Axes,'');
                set(H_Axes,'box','on');
                set(H_Axes,'XTick',[]);
                set(H_Axes,'YTick',[]);
                text(4, 9,sprintf('There was a problem computing the beta function.'),'units','characters');
                drawnow;
            end

        case 28
            % Horizontal Beta Beat
            plot(H_Axes,[0 1],[0 1],'w'); set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            set(H_Axes,'box','on');
            text(4,11,sprintf('Please wait ...'),'units','characters');
            text(4, 9,sprintf('Computing Beta Functions'),'units','characters');
            drawnow;
            
            [Beta1, Tune1] = locodata({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, i-1, 'Beta',[],'Tune',[]);
            [Beta0, Tune0] = locodata({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData},   0, 'Beta',[],'Tune',[]);
            if ~isempty(Beta1) && ~isempty(Beta0) && isreal(Beta1) && isreal(Beta0)
                %plot(Beta1(:,3), Beta1(:,1)-Beta0(:,1), 'b');
                %ylabel(sprintf('Horizontal Beta(%d)-Beta(0) [meters]',i-1));
                plot(Beta1(:,3), Beta1(:,1)./Beta0(:,1), 'b');
                ylabel(sprintf('Horizontal Beta(%d)/Beta(0)',i-1));
                xlabel(H_Axes,'BPM Position [meters]');
                title(texlabel(sprintf('Beta Beat (nu_x(%d)=%.4f, nu_x(0)=%.4f)',i-1, Tune1(1),Tune0(1))));
                try
                    L = findspos(RINGData.Lattice,length(RINGData.Lattice)+1);
                    if ~isempty(Beta1)
                        set(H_Axes, 'XLim', [0 L]);
                    end
                catch
                end
            else
                plot(H_Axes,[0 1],[0 1],'w');
                title(H_Axes,'');
                set(H_Axes,'box','on');
                set(H_Axes,'XTick',[]);
                set(H_Axes,'YTick',[]);
                text(4, 9,sprintf('There was a problem computing the beta function.'),'units','characters');
                drawnow;
            end

            %h = uimenu(hcmenu, 'Label', 'Beta Beat', 'Callback', 'locogui(''ContextMenuBetaBeat_Callback'',gcbo,[],[])');
            %set(h,'Userdata',{'Model-Measured','VCM'});
            
        case 29
            % Vertical Beta Beat
            plot(H_Axes,[0 1],[0 1],'w'); set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            set(H_Axes,'box','on');
            text(4,11,sprintf('Please wait ...'),'units','characters');
            text(4, 9,sprintf('Computing Beta Functions'),'units','characters');
            drawnow;
            
            [Beta1, Tune1] = locodata({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, i-1, 'Beta',[],'Tune',[]);
            [Beta0, Tune0] = locodata({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData},   0, 'Beta',[],'Tune',[]);
            if ~isempty(Beta1) && ~isempty(Beta0) && isreal(Beta1) && isreal(Beta0)
                %plot(Beta1(:,3), Beta1(:,2)-Beta0(:,2), 'b'); 
                %ylabel(sprintf('Vertical Beta(%d)-Beta(0) [meters]',i-1));
                plot(Beta1(:,3), Beta1(:,2)./Beta0(:,2), 'b'); 
                ylabel(sprintf('Vertical Beta(%d)/Beta(0)',i-1));
                xlabel(H_Axes,'BPM Position [meters]');
                title(texlabel(sprintf('Beta Beat (nu_y(%d)=%.4f, nu_y(0)=%.4f)',i-1, Tune1(2),Tune0(2))));
                try
                    L = findspos(RINGData.Lattice,length(RINGData.Lattice)+1);
                    if ~isempty(Beta1)
                        set(H_Axes, 'XLim', [0 L]);
                    end
                catch
                end
            else
                plot(H_Axes,[0 1],[0 1],'w');
                title(H_Axes,'');
                set(H_Axes,'box','on');
                set(H_Axes,'XTick',[]);
                set(H_Axes,'YTick',[]);
                text(4, 9,sprintf('There was a problem computing the beta function.'),'units','characters');
                drawnow;
            end
            
        case 30
            if isempty(Mmodel)
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            else
                locoplotrms({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, i-1, 1);
            end
        case 31
            if isempty(Mmodel)
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            else
                locoplotrms({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, i-1, 3);
            end

        case 32
            if isempty(Mmodel)
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            else
                locoplotrms({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, i-1, 2);
            end
        case 33
            if isempty(Mmodel)
                set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
            else
                locoplotrms({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData}, i-1, 4);
            end
    end
    
catch
    set(H_Axes,'XTick',[]); set(H_Axes,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');
    fprintf('Plot failed: %s\n', lasterr);
end

axes(findobj(gcbf,'Tag','ChiSquare'));
cla;
if ~isempty(LocoModel(i).ChiSquare)
    if LocoModel(i).ChiSquare~=0
        text(0,.5,sprintf('\\fontsize{12}\\chi^{2}_{\\fontsize{8}total} \\fontsize{9}/ D.O.F \\fontsize{10}= %f', LocoModel(i).ChiSquare));
    end
end

drawnow;


% % --------------------------------------------------------------------
% function varargout = ContextMenuBetaBeat_Callback(h, eventdata, handles, varargin)
% %FieldName = get(h,'Userdata');
% 
% FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
% if isempty(FileName)
%     return
% end
% try
%     load(FileName);
% catch
%     fprintf('   File does not exist or is not a *.mat file type.\n');
%     cla;
%     return
% end
% 
% i = get(findobj(gcbf,'Tag','PlotIteration'),'Value');  % The first point in the array is starting point



% --------------------------------------------------------------------
function varargout = ContextCostFunctionPlot_Callback(h, eventdata, handles, varargin)
Userdata = get(h,'Userdata');
FieldName = Userdata{1};
H_Axes = Userdata{2};

AxesTag = get(gca,'Tag');
if strcmp(AxesTag,'Axes1')
    setappdata(gcbf, 'CostFunctionPlot1', Userdata);
elseif strcmp(AxesTag,'Axes2')
    setappdata(gcbf, 'CostFunctionPlot2', Userdata);
end

PlotCostFunction;


function PlotCostFunction

LogPlotFlag = 1;

AxesTag = get(gca,'Tag');
if strcmp(AxesTag,'Axes1')
    Userdata = getappdata(gcbf, 'CostFunctionPlot1');
    TagString = get(findobj(gcbf,'Tag','PlotMenu1'),'Userdata');   % Axis tag is storage in the menu pulldown
elseif strcmp(AxesTag,'Axes2')
    Userdata = getappdata(gcbf, 'CostFunctionPlot2');
    TagString = get(findobj(gcbf,'Tag','PlotMenu2'),'Userdata');   % Axis tag is storage in the menu pulldown
end

FieldName = Userdata{1};
H_Axes = Userdata{2};

FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
if isempty(FileName)
    return
end
try
    load(FileName);
catch
    fprintf('   File does not exist or is not a *.mat file type.\n');
    cla;
    return
end
i = get(findobj(gcbf,'Tag','PlotIteration'),'Value');  % The first point in the array is starting point

axes(H_Axes);


CostScaleFactor = 1;
if strcmpi(LocoFlags(i).Method.Name, 'Gauss-Newton With Cost Function') && isfield(LocoFlags(i).Method, 'CostScaleFactor') && ~isempty(LocoFlags(i).Method.CostScaleFactor)
    CostScaleFactor = LocoFlags(i).Method.CostScaleFactor;
end


if strcmpi(FieldName, 'All')
    FieldCell = fieldnames(LocoFlags(i).Method.Cost);
    Total = [];
    for ifield = 1:length(FieldCell)
        NewData = LocoFlags(i).Method.Cost.(FieldCell{ifield});
        Total = [Total; NewData(:)];
    end
    axes(H_Axes);
    if LogPlotFlag && all(Total>0)
        semilogy(1:length(Total), CostScaleFactor * Total);
    else
        plot(1:length(Total), CostScaleFactor * Total);
    end
    title(H_Axes,'');
    xlabel(H_Axes,'All Fit Parameters', 'FontSize', 10);
    ylabel(H_Axes,'Cost');
    title(H_Axes,'Parameter Cost', 'FontSize', 10);
else
    if LogPlotFlag && all(LocoFlags(i).Method.Cost.(FieldName)>0)
        semilogy(1:length(LocoFlags(i).Method.Cost.(FieldName)), CostScaleFactor * LocoFlags(i).Method.Cost.(FieldName));
    else
        plot(1:length(LocoFlags(i).Method.Cost.(FieldName)), CostScaleFactor * LocoFlags(i).Method.Cost.(FieldName));
    end
    title(H_Axes,'');
    xlabel(H_Axes,sprintf('%s Number', FieldName), 'FontSize', 10);
    ylabel(H_Axes,'Cost');
    title(H_Axes,sprintf('Parameter Cost for %s', FieldName), 'FontSize', 10);
end
%grid  on;
a1 = axis;
axis tight;
a2 = axis;
axis([a2(1:2) a1(3:4)]);

set(gca,'Tag',TagString);                 % axes tag is lost if plot function is used
set(gca,'HandleVisibility','Callback');   % So no one else can plot to it.




% --------------------------------------------------------------------
function varargout = ContextPartialChi2Plot_Callback(h, eventdata, handles, varargin)
Userdata = get(h,'Userdata');
FieldName = Userdata{1};
H_Axes = Userdata{2};

AxesTag = get(gca,'Tag');
if strcmp(AxesTag,'Axes1')
    setappdata(gcbf, 'PartialChi2Plot1', Userdata);
elseif strcmp(AxesTag,'Axes2')
    setappdata(gcbf, 'PartialChi2Plot2', Userdata);
end

PlotPartialChi2;


function PlotPartialChi2

LogPlotFlag = 1;

AxesTag = get(gca,'Tag');
if strcmp(AxesTag,'Axes1')
    Userdata = getappdata(gcbf, 'PartialChi2Plot1');
    TagString = get(findobj(gcbf,'Tag','PlotMenu1'),'Userdata');   % Axis tag is storage in the menu pulldown
elseif strcmp(AxesTag,'Axes2')
    Userdata = getappdata(gcbf, 'PartialChi2Plot2');
    TagString = get(findobj(gcbf,'Tag','PlotMenu2'),'Userdata');   % Axis tag is storage in the menu pulldown
end

FieldName = Userdata{1};
H_Axes = Userdata{2};

FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
if isempty(FileName)
    return
end
try
    load(FileName);
catch
    fprintf('   File does not exist or is not a *.mat file type.\n');
    cla;
    return
end
i = get(findobj(gcbf,'Tag','PlotIteration'),'Value');  % The first point in the array is starting point

axes(H_Axes);

if strcmpi(FieldName, 'All')
    FieldCell = fieldnames(LocoFlags(i).Method.PartialChi2);
    Total = [];
    for ifield = 1:length(FieldCell)
        NewData = LocoFlags(i).Method.PartialChi2.(FieldCell{ifield});
        Total = [Total; NewData(:)];
    end
    axes(H_Axes);
    if LogPlotFlag
        semilogy(1:length(Total), Total);
    else
        plot(1:length(Total), Total);
    end
    title(H_Axes,'');
    xlabel(H_Axes,'All Fit Parameters', 'FontSize', 10);
    ylabel(H_Axes,'\fontsize{14}\partial \chi^2 / \partial \fontsize{9}Fit Parameter');
    title(H_Axes,'Change in \chi^2 w.r.t. Each Fit Parameter', 'FontSize', 10);
else
    if LogPlotFlag
        semilogy(1:length(LocoFlags(i).Method.PartialChi2.(FieldName)), LocoFlags(i).Method.PartialChi2.(FieldName));
    else
        plot(1:length(LocoFlags(i).Method.PartialChi2.(FieldName)), LocoFlags(i).Method.PartialChi2.(FieldName));
    end
    title(H_Axes,'');
    xlabel(H_Axes,sprintf('%s Number', FieldName), 'FontSize', 10);
    ylabel(H_Axes,sprintf('\\fontsize{14}\\partial \\chi^2 / \\partial \\fontsize{10}%s', FieldName));
    title(H_Axes,sprintf('Change in \\chi^2 w.r.t. Each %s Fit Parameter', FieldName), 'FontSize', 10);
end
%grid  on;
a1 = axis;
axis tight;
a2 = axis;
axis([a2(1:2) a1(3:4)]);

set(gca,'Tag',TagString);                 % axes tag is lost if plot function is used
set(gca,'HandleVisibility','Callback');   % So no one else can plot to it.


% --------------------------------------------------------------------
function varargout = ContextMenuPlot_Callback(h, eventdata, handles, varargin)
FieldName = get(h,'Userdata');

AxesTag = get(gca,'Tag');
if strcmp(AxesTag,'Axes1')
    TagString = get(findobj(gcbf,'Tag','PlotMenu1'),'Userdata');   % Axis tag is storage in the menu pulldown
    setappdata(gcbf,'OtherParameterPlot1',FieldName);
elseif strcmp(AxesTag,'Axes2')
    TagString = get(findobj(gcbf,'Tag','PlotMenu2'),'Userdata');   % Axis tag is storage in the menu pulldown
    setappdata(gcbf,'OtherParameterPlot2',FieldName);
else
    %error('problem with AxesTag name')
end
h_axis = findobj(gcbf,'Tag',TagString);
axes(h_axis);
locoplots(15, FieldName);

axes(h_axis);
legend
set(gca,'Tag',TagString);                 % axes tag is lost if plot function is used
set(gca,'HandleVisibility','Callback');   % So no one else can plot to it.


% --------------------------------------------------------------------
function varargout = ContextMenuSurfPlot_Callback(h, eventdata, handles, varargin)
FieldName = get(h,'Userdata');

AxesTag = get(gca,'Tag');
if strcmp(AxesTag,'Axes1')
    TagString = get(findobj(gcbf,'Tag','PlotMenu1'),'Userdata');   % Axis tag is storage in the menu pulldown
    h1 = findobj(gcbf,'Tag','SurfPlot1');
    set(h1,'Userdata', FieldName);
elseif strcmp(AxesTag,'Axes2')
    TagString = get(findobj(gcbf,'Tag','PlotMenu2'),'Userdata');   % Axis tag is storage in the menu pulldown
    h1 = findobj(gcbf,'Tag','SurfPlot2');
    set(h1,'Userdata', FieldName);
else
    %error('problem with AxesTag name')
end

h_axis = findobj(gcbf,'Tag',TagString);
axes(h_axis);

%FileName = get(findobj(gcbf,'Tag','FileName'),'Userdata');
LocoDataCell = getappdata(gcbf, 'LocoDataCell');
Iteration = get(findobj(gcbf,'Tag','PlotIteration'),'Value')-1;
ElementsInput = locoplot(LocoDataCell, Iteration, FieldName{1}, FieldName{2});

FieldName{3} = ElementsInput; 
set(h1,'Userdata', FieldName);

set(gca,'Tag',TagString);                 % axes tag is lost if plot function is used
set(gca,'HandleVisibility','Callback');   % So no one else can plot to it.



function [Mmodel, Dispersion, ChiSquare] = getmodelresponsematrix(BPMData, CMData, FitParameters, LocoFlags, LocoMeasData, RINGData)

% Save the current axes
H_Axes = gca;

% UNITS CONVERSIONS (to be combatible with tracking code)
% Convert corrector kicks used in the response matrix to radians
CMData.HCMKicks = CMData.HCMKicks(:) / 1000;   % milliradian to radians (column vector)
CMData.VCMKicks = CMData.VCMKicks(:) / 1000;   % milliradian to radians (column vector)

% Convert the measured response matrix to meters
LocoMeasData.M = LocoMeasData.M / 1000;

% Convert the BPMSTD to meters and make the same size as a response matrix
LocoMeasData.BPMSTD = LocoMeasData.BPMSTD / 1000;    % mm to meters

% Convert orbit for "dispersion" in meters in column vector format
LocoMeasData.Eta = LocoMeasData.Eta(:) / 1000;       % mm to meters
% END UNITS CONVERTSION


% % Check for a new (user input) BPM and CM good data lists  
% if ~isempty(get(findobj(gcbf,'Tag','HBPMIndex'), 'Userdata'))
%     BPMData.HBPMGoodDataIndex = get(findobj(gcf,'Tag','HBPMIndex'), 'Userdata');
% end
% if ~isempty(get(findobj(gcbf,'Tag','VBPMIndex'), 'Userdata'))
%     BPMData.VBPMGoodDataIndex = get(findobj(gcf,'Tag','VBPMIndex'), 'Userdata');
% end
% if ~isempty(get(findobj(gcbf,'Tag','HCMIndex'), 'Userdata'))
%     CMData.HCMGoodDataIndex = get(findobj(gcf,'Tag','HCMIndex'), 'Userdata');
% end
% if ~isempty(get(findobj(gcbf,'Tag','VCMIndex'), 'Userdata'))
%     CMData.VCMGoodDataIndex = get(findobj(gcf,'Tag','VCMIndex'), 'Userdata');
% end


% Limit the correctors to the good ones
if isfield(CMData, 'FamName')
    CMDataRM.FamName = CMData.FamName;
end
CMDataRM.HCMIndex = CMData.HCMIndex(CMData.HCMGoodDataIndex);
CMDataRM.VCMIndex = CMData.VCMIndex(CMData.VCMGoodDataIndex);
CMDataRM.HCMKicks = CMData.HCMKicks(CMData.HCMGoodDataIndex);
CMDataRM.VCMKicks = CMData.VCMKicks(CMData.VCMGoodDataIndex);
CMDataRM.HCMCoupling = CMData.HCMCoupling(CMData.HCMGoodDataIndex);
CMDataRM.VCMCoupling = CMData.VCMCoupling(CMData.VCMGoodDataIndex);
CMDataRM.HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
CMDataRM.VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);

% Set the lattice model to the starting LocoValues
for i = 1:length(FitParameters.Params)
    RINGData = locosetlatticeparam(RINGData, FitParameters.Params{i}, FitParameters.Values(i));
end

plot(H_Axes,[0 1],[0 1],'w');
title(H_Axes,'RF Frequency');
set(gca,'box','on');
set(gca,'XTick',[]);
set(gca,'YTick',[]);
text(4,11,sprintf('Please wait ...'),'units','characters');
text(4, 9,sprintf('Computing nominal response matrix'),'units','characters');
text(4, 8,sprintf('                   and dispersion.'),'units','characters');
drawnow;

% Find nominal response matrix and dispersion
if isempty(FitParameters.DeltaRF)
    fprintf('   Computing nominal response matrix (%s, %s) ... ', LocoFlags.ResponseMatrixCalculator, LocoFlags.ClosedOrbitType); tic
    LocoFlags.Dispersion = 'no';
    LocoFlags.ClosedOrbitType = 'FixedPathLength';
    Mmodel = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags);
else
    fprintf('   Computing nominal response matrix and dispersion (%s, %s) ... ', LocoFlags.ResponseMatrixCalculator, LocoFlags.ClosedOrbitType); tic
    Mmodel = locoresponsematrix(RINGData, BPMData, CMDataRM, LocoFlags, 'RF', FitParameters.DeltaRF);
end
fprintf('%f seconds. \n',toc);

if isempty(LocoMeasData.Eta) || any(isnan(LocoMeasData.Eta))
    % Don't computer Chi^2 for with dispersion if the measured dispersion is emmpty or NaN
    LocoFlags.Dispersion = 'no';
end

plot(0,0); set(gca,'XTick',[]); set(gca,'YTick',[]); cla; title(H_Axes,' '); xlabel(H_Axes,' '); ylabel(H_Axes,' ');

% Rotate Mmodel and remove BPMs not in the measured response matrix
C11 = ones(length(BPMData.BPMIndex),1);
C11(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex)) = BPMData.HBPMGain(BPMData.HBPMGoodDataIndex);

C12 = zeros(length(BPMData.BPMIndex),1);
C12(BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex)) = BPMData.HBPMCoupling(BPMData.HBPMGoodDataIndex);

C21 = zeros(length(BPMData.BPMIndex),1);
C21(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex)) = BPMData.VBPMCoupling(BPMData.VBPMGoodDataIndex);

C22 = ones(length(BPMData.BPMIndex),1);
C22(BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex)) = BPMData.VBPMGain(BPMData.VBPMGoodDataIndex);

C = [diag(C11) diag(C12)
     diag(C21) diag(C22)];

Mmodel = C * Mmodel;

clear C C11 C12 C21 C22  

% Remove unwanted BPMs  (Change by James S.  3-17-2006)
%Mmodel = Mmodel([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], :); 
BPMIndexShortX = BPMData.HBPMIndex(BPMData.HBPMGoodDataIndex);
BPMIndexShortY = BPMData.VBPMIndex(BPMData.VBPMGoodDataIndex) + length(BPMData.BPMIndex);
BPMIndexShort = [BPMIndexShortX(:)' BPMIndexShortY(:)'];
Mmodel = Mmodel(BPMIndexShort,:); 

if isempty(FitParameters.DeltaRF)
    Dispersion = [];
else
    Dispersion = Mmodel(:,end);
end


% When using the fixed momentum response matrix calculator, the merit function becomes:
%              Merit = Mmeas_ij - Mmod_ij - Dp/p_j * eta_i 
%              where eta_i is the measured eta (not the model eta)
% This is done by changing Mmodel to (Mmodel_ij + Dp/p_j * eta_i)
%if strcmpi((CMData.FitHCMEnergyShift),'yes') | strcmpi((CMData.FitVCMEnergyShift),'yes')    
if strcmpi((LocoFlags.ClosedOrbitType), 'fixedmomentum')
    HCMEnergyShift = CMData.HCMEnergyShift(CMData.HCMGoodDataIndex);
    VCMEnergyShift = CMData.VCMEnergyShift(CMData.VCMGoodDataIndex);
    
    AlphaMCF = locomcf(RINGData);
    EtaXmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(BPMData.HBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    EtaYmcf = -AlphaMCF * LocoMeasData.RF * LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex) / LocoMeasData.DeltaRF;
    
    for i = 1:length(HCMEnergyShift)
        Mmodel(:,i) = Mmodel(:,i) + HCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end
    
    NHCM = length(HCMEnergyShift);
    for i = 1:length(VCMEnergyShift)
        Mmodel(:,NHCM+i) = Mmodel(:,NHCM+i) + VCMEnergyShift(i) * [EtaXmcf; EtaYmcf];
    end
end


% Compute chi-squared based on new model
Mmeas = LocoMeasData.M;
Mmeas = Mmeas([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]); 

Mstd = LocoMeasData.BPMSTD * ones(1,size(LocoMeasData.M,2));
Mstd = Mstd ([BPMData.HBPMGoodDataIndex length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex], [CMData.HCMGoodDataIndex length(CMData.HCMIndex)+CMData.VCMGoodDataIndex]); 

Xstd = LocoMeasData.BPMSTD(BPMData.HBPMGoodDataIndex);
Ystd = LocoMeasData.BPMSTD(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);

if isempty(LocoMeasData.Eta) 
    EtaX = NaN * ones(length(BPMData.HBPMGoodDataIndex),1);
    EtaY = NaN * ones(length(BPMData.VBPMGoodDataIndex),1);
else
    EtaX = LocoMeasData.Eta(BPMData.HBPMGoodDataIndex);
    EtaY = LocoMeasData.Eta(length(BPMData.HBPMIndex)+BPMData.VBPMGoodDataIndex);
end
    
Mstd  = Mstd(:);
Mmeas = Mmeas(:);

if strcmpi((LocoFlags.Dispersion),'yes')
    Mstd  = [Mstd;  [Xstd; Ystd]];
    Mmeas = [Mmeas; [EtaX; EtaY]];
else
    % Remove dispersion from the model for ChiSquare
    if ~isempty(FitParameters.DeltaRF)
        Mmodel = Mmodel(:,1:end-1);
    end
end

% Without NumberOfParameters (since no fits were done yet, but this is a little confusing to some)
ChiSquare = sum(((Mmeas - Mmodel(:)) ./ Mstd) .^ 2) / length(Mstd);


% Remove the disperion for the output is it has not been already removed
if strcmpi((LocoFlags.Dispersion),'yes')  
    Mmodel = Mmodel(:,1:end-1);
end


% Unit conversions (back to LOCO units)
%CMData.HCMKicks = 1000*CMData.HCMKicks;        % radian to milliradians
%CMData.VCMKicks = 1000*CMData.VCMKicks;        % radian to milliradians
Mmodel     = 1000 * Mmodel;         % meters to millimeters
Dispersion = 1000 * Dispersion;     % meters to millimeters

