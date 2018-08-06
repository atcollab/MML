function varargout = brwaveforms(varargin)
% BRWAVEFORMS M-file for brwaveforms.fig
%      BRWAVEFORMS, by itself, creates a new BRWAVEFORMS or raises the existing
%      singleton*.
%
%      H = BRWAVEFORMS returns the handle to a new BRWAVEFORMS or the handle to
%      the existing singleton*.
%
%      BRWAVEFORMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRWAVEFORMS.M with the given input arguments.
%
%      BRWAVEFORMS('Property','Value',...) creates a new BRWAVEFORMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before brwaveform_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to brwaveforms_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help brwaveforms

% Last Modified by GUIDE v2.5 13-Jan-2009 15:06:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @brwaveforms_OpeningFcn, ...
    'gui_OutputFcn',  @brwaveforms_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before brwaveforms is made visible.
function brwaveforms_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to brwaveforms (see VARARGIN)

% Choose default command line output for brwaveforms
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible so window can get raised using brwaveforms.
axes(handles.axes1);
plot([0 1],[NaN NaN])

axes(handles.axes2);
plot([0 1],[NaN NaN])

axes(handles.axes3);
plot([0 1],[NaN NaN])

axes(handles.axes4);
plot([0 1],[NaN NaN])

axes(handles.axes5);
plot([0 1],[NaN NaN])

axes(handles.axes6);
plot([0 1],[NaN NaN])

axes(handles.axes7);
plot([0 1],[NaN NaN])

set(handles.BRWaveformDate, 'String', datestr(now));

% Remove timer field if a saved version is there
h = getappdata(handles.figure1, 'HandleStructure');
if isfield(h,'TimerHandle')
    %stop(h.TimerHandle);
    %delete(h.TimerHandle);
    h = rmfield(h, 'TimerHandle');
    setappdata(handles.figure1, 'HandleStructure', h);
end

% UIWAIT makes brwaveforms wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = brwaveforms_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BRWaveformStart.
function BRWaveformStart_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%
% Files and paths %
%%%%%%%%%%%%%%%%%%%

%InputFile = 'BQFQD_golden_2008106.txt';
InputFile = 'BR_BQFQD_last_shot.txt';
if ispc
    %PathName = 'm:\matlab\srdata\powersupplies\';
    %PathName = 'm:\matlab\srdata\powersupplies\BQFQD_ramping_20071031\';
    PathName = '\\Als-filer\physdata\matlab\srdata\powersupplies\BQFQD_ramping_20071031\';
else
    %PathName = '/home/physdata/matlab/srdata/powersupplies/';
    PathName = '/home/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20071031/';
end
setappdata(handles.figure1, 'FileName', [PathName,InputFile]);

GoldenFileName = 'BR_BQFQD_20091120.txt';     % this file updated on 9-3-10, when we had very consistent BR beam - T.Scarvie
% GoldenFileName = 'BR_BQFQD_after_retuning_QD_20090824.txt';     % updated on August 24, after reyuning QD (larger offset curren) - hopefully reducing frequency of QD 'jumps' - C. Steier
% GoldenFileName = 'BR_BQFQD_golden_after_bend_jump_20090818.txt';     % updated on August 18, after recovering from one more step change in booster bend magnet supply - C. Steier
% GoldenFileName = 'BR_BQFQD_ramping_20090714.txt';  %updated July 14, 2009, after recovering from booster tuning problems that started after July 4th shutdown - C. Steier
% GoldenFileName = 'BQFQD_ramping_20090331.txt';  %updated 3-31-09 with data taken during 9am fill - T.Scarvie
% GoldenFileName = 'BR_BQFQD_golden_20081106.txt';  %updated 10-13-08 with data taken during 9am fill - T.Scarvie
if ispc
    %GoldenPathName = 'm:\matlab\srdata\powersupplies\BQFQD_ramping_20071031\';
    GoldenPathName = '\\Als-filer\physdata\matlab\srdata\powersupplies\BQFQD_ramping_20071031\';
else
    GoldenPathName = '/home/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20071031/';
end


try
    GoldData = readdvmfile_local([GoldenPathName, GoldenFileName]);
catch
    fprintf('%s\n', lasterr);
    fprintf('   Golden trace data file open error\n');
    set(handles.BRWaveformStart,'String','Start');
    return;
end

% Save data
setappdata(handles.figure1, 'GoldenData', GoldData);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if already open so multiple timers don't get started %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmpi(get(handles.BRWaveformStart,'String'),'Start')
    set(handles.BRWaveformStart, 'String', 'Stop')
    
    % Create the timer
    %h = getappdata(handles.figure1, 'HandleStructure');
    %if isfield(h,'TimerHandle') && isobject(h.TimerHandle)
    %    % Just restart it
    %    start(h.TimerHandle);
    %    %fprintf('   BR waveforms already open\n');
    %    %return
    %else
        %%%%%%%%%%%%%%%
        % Setup Timer %
        %%%%%%%%%%%%%%%
        UpdatePeriod = 1;
        
        t = timer;
        set(t, 'StartDelay', 0);
        set(t, 'Period', UpdatePeriod);
        set(t, 'TimerFcn', ['brwaveforms(''BRWaveformUpdate_Callback'',', sprintf('%.30f',handles.figure1), ',',sprintf('%.30f',handles.figure1), ', [])']);
        %set(t, 'StartFcn', ['brwaveforms(''Timer_Start'',',    sprintf('%.30f',handles.figure1), ',',sprintf('%.30f',handles.figure1), ', [])']);
        set(t, 'UserData', handles);
        set(t, 'BusyMode', 'drop');  %'queue'
        set(t, 'TasksToExecute', Inf);
        set(t, 'ExecutionMode', 'FixedRate');
        set(t, 'Tag', 'BRWaveformsTimer');
        
        handles.TimerHandle = t;
        
        % Save handles
        setappdata(handles.figure1, 'HandleStructure', handles);
    %end


    % Start the timer
    start(handles.TimerHandle);
    
else
    % Stop request
    set(handles.BRWaveformStart,'String','Start');
    
    try
        h = getappdata(handles.figure1, 'HandleStructure');
        if isfield(h,'TimerHandle')
            stop(h.TimerHandle);
            delete(h.TimerHandle);
            h = rmfield(h, 'TimerHandle');
        end
    catch
        fprintf('   Trouble stopping the BR waveform timer on exit.\n');
    end
end
drawnow;




function BRWaveformUpdate_Callback(hObject, eventdata, handles)

handles = getappdata(hObject, 'HandleStructure');

GoldData = getappdata(handles.figure1, 'GoldenData');
FileName = getappdata(handles.figure1, 'FileName');

try
    SkipFlag = 0;
%    NewData = readdvmfile_local(FileName);
    Data = get_dpsc_current_waveforms_cond; NewData=[];
    NewData.Data(:,1)=Data.Data(:,1)/125; NewData.Data(:,2)=Data.Data(:,3)/60; NewData.Data(:,3)=Data.Data(:,2)/60;
    NewData.TimeStep = Data.TimeStep;
    DirData = dir(FileName);
    [dummy, endind]    = max(NewData.Data(:,1));
    [dummy, endindold] = max(GoldData.Data(:,1));
catch
    SkipFlag = 1;
    disp('File is currently busy ... skipping one file read cycle');
    pause(.2);
end

if ~SkipFlag
    if ((now-datenum(DirData.date))*24*60*60)>30
        %soundtada;
        warningstr = sprintf('Data file %s has not been update in %g seconds. Need to start Labview app',FileName,(now-datenum(DirData.date))*24*60*60);
        warning(warningstr);
    end
    
    % "Figure 11"
    plot(handles.axes1, ...
        125*10/10*GoldData.Data(1:endindold,1),60*10/10*GoldData.Data(1:endindold,2)./(125*10/10*GoldData.Data(1:endindold,1)),'c', ...
        125*10/10*GoldData.Data(1:endindold,1),60*GoldData.Data(1:endindold,3)./(125*10/10*GoldData.Data(1:endindold,1)),'m');
    hold(handles.axes1, 'on');
    plot(handles.axes1, ...
        125*10/10*NewData.Data(1:endind,1),60*10/10*NewData.Data(1:endind,2)./(125*10/10*NewData.Data(1:endind,1)),'b', ...
        125*10/10*NewData.Data(1:endind,1),60*NewData.Data(1:endind,3)./(125*10/10*NewData.Data(1:endind,1)),'r','LineWidth',1.5);
    plot(handles.axes1, [25 25],[0 1],'k','LineWidth',2);
    hold(handles.axes1, 'off');
    %xlabel(handles.axes1, 'I_{Bend} [A]');
    ylabel(handles.axes1, 'I_{Quad}/I_{Bend}');
    axis(handles.axes1, [0 1000 0.45 0.6]);
    %axis(handles.axes1, [0 800 0.35 0.57]);
    
    plot(handles.axes2, ...
        125*10/10*GoldData.Data(1:endindold,1),60*10/10*GoldData.Data(1:endindold,2)./(125*10/10*GoldData.Data(1:endindold,1)),'c', ...
        125*10/10*GoldData.Data(1:endindold,1),60*GoldData.Data(1:endindold,3)./(125*10/10*GoldData.Data(1:endindold,1)),'m');
    hold(handles.axes2, 'on');
    %%axis(handles.axes2, [0 100 0.46 0.56]);
    axis(handles.axes2, [20 80 0.475 0.585]);
    plot(handles.axes2, ...
        125*10/10*NewData.Data(1:endind,1),60*10/10*NewData.Data(1:endind,2)./(125*10/10*NewData.Data(1:endind,1)),'b', ...
        125*10/10*NewData.Data(1:endind,1),60*NewData.Data(1:endind,3)./(125*10/10*NewData.Data(1:endind,1)),'r','LineWidth',1.5);
    plot(handles.axes2, [25 25],[0 1],'k','LineWidth',2);
    hold(handles.axes2, 'off');
    xlabel(handles.axes2, 'I_{Bend} [A]');
    ylabel(handles.axes2, 'I_{Quad}/I_{Bend}');
    %legend(handles.axes2, 'QD_{golden}','QF_{golden}','QD','QF','Location','EastOutside');
    
    set(handles.BRWaveformDate, 'String', DirData.date);
    
    % "Figure 12"
    plot(handles.axes3, (0:(endind-1))*NewData.TimeStep,125*10/10*NewData.Data(1:endind,1),'g',(0:(endindold-1))*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),'b')
    hold(handles.axes3, 'on');
    plot(handles.axes3, [0.014 0.014],[0 1000],'k','LineWidth',2);
    hold(handles.axes3, 'off');
    legend(handles.axes3, 'BEND (present data)','BEND (golden)','Location','Best');
    ylabel(handles.axes3, 'I [A]');
    
    if (NewData.TimeStep == GoldData.TimeStep)
        plot(handles.axes4, (0:(endind-1))*NewData.TimeStep,(125*10/10*NewData.Data(1:endind,1)-125*10/10*GoldData.Data(1:endind,1))./(125*10/10*GoldData.Data(1:endind,1)),'b');
    else
        plot(handles.axes4, (0:(endind-1))*NewData.TimeStep,(125*10/10*NewData.Data(1:endind,1)'-interp1((0:(endindold-1))*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),(0:(endind-1))*NewData.TimeStep,'linear','extrap'))./interp1((0:(endindold-1))*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),(0:(endind-1))*NewData.TimeStep,'linear','extrap'),'b');
    end
    hold(handles.axes4, 'on');
    plot(handles.axes4, [0.014 0.014],[-1 1],'k','LineWidth',2);
    hold(handles.axes4, 'off');
    legend(handles.axes4, '(present-golden)/golden','Location','Best');
    xlabel(handles.axes4, 'Time [Seconds]');
    ylabel(handles.axes4, '\Delta I / I');
    axis(handles.axes4, [0 0.5 -0.02 0.02]);
    
    
    % "Figure 13"
    plot(handles.axes5, (0:(endind-1))*NewData.TimeStep, (125*10/10*NewData.Data(1:endind,1)), 'g', (0:(endind-1))*NewData.TimeStep, 60*10/10*NewData.Data(1:endind,2), 'b', (0:(endind-1))*NewData.TimeStep, 60*NewData.Data(1:endind,3), 'r');
    hold(handles.axes5, 'on');
    plot(handles.axes5, [0.014 0.014],[0 100],'k','LineWidth',2);
    hold(handles.axes5, 'off');
    %xlabel(handles.axes5, 'Time [Seconds]');
    ylabel(handles.axes5, '[Amps]');
    legend(handles.axes5, 'BEND', 'QD','QF');
    axis(handles.axes5, [0 .06 0 60]);
    
    if (NewData.TimeStep == GoldData.TimeStep)
        plot(handles.axes6, (0:(endind-1))*NewData.TimeStep, ((125*10/10*NewData.Data(1:endind,1))-125*10/10*GoldData.Data(1:endind,1))./(125*10/10*GoldData.Data(1:endind,1)), 'g', (0:(endind-1))*NewData.TimeStep, (60*10/10*NewData.Data(1:endind,2)-60*10/10*GoldData.Data(1:endind,2))./(60*10/10*GoldData.Data(1:endind,2)), 'b', (0:(endind-1))*NewData.TimeStep, (60*NewData.Data(1:endind,3)-60*10/10*GoldData.Data(1:endind,3))./(60*10/10*GoldData.Data(1:endind,3)),'r');
        hold(handles.axes6, 'on');
        plot(handles.axes6, [0.014 0.014],[-1 1],'k','LineWidth',2);
        hold(handles.axes6, 'off');
        axis(handles.axes6, [0 0.06 -0.04 0.04])
    else
        plot(handles.axes6, (0:(endind-1))*NewData.TimeStep, (125*10/10*NewData.Data(1:endind,1)- ...
            interp1((0:(endindold-1))*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),(0:(endind-1))*NewData.TimeStep,'linear','extrap')')./ ...
            interp1((0:(endindold-1))*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),(0:(endind-1))*NewData.TimeStep,'linear','extrap')', 'g', ...
            (0:(endind-1))*NewData.TimeStep, (60*10/10*NewData.Data(1:endind,2)- ...
            interp1((0:(endindold-1))*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),(0:(endind-1))*NewData.TimeStep,'linear','extrap')')./ ...
            interp1((0:(endindold-1))*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),(0:(endind-1))*NewData.TimeStep,'linear','extrap')', 'b', ...
            (0:(endind-1))*NewData.TimeStep, (60*NewData.Data(1:endind,3)- ...
            interp1((0:(endindold-1))*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),(0:(endind-1))*NewData.TimeStep,'linear','extrap')')./ ...
            interp1((0:(endindold-1))*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),(0:(endind-1))*NewData.TimeStep,'linear','extrap')','r');
        hold(handles.axes6, 'on');
        plot(handles.axes6, [0.014 0.014],[-1 1],'k','LineWidth',2);
        hold(handles.axes6, 'off');
        axis(handles.axes6, [0 0.06 -0.04 0.04]);
    end
    %xlabel(handles.axes6, 'Time [Seconds]');
    ylabel(handles.axes6, '(I_{present}-I_{golden})/I_{golden}');
    %legend(handles.axes6, '\Delta I / I_{BEND}', '\Delta I / I_{QD}','\Delta I / I_{QF}','Location','Best');  % 'EastOutside'
    
    
    if (NewData.TimeStep == GoldData.TimeStep)
        plot(handles.axes7, (0:(endind-1))*NewData.TimeStep, ((125*10/10*NewData.Data(1:endind,1))-125*10/10*GoldData.Data(1:endind,1))./(125*10/10*GoldData.Data(1:endind,1)), 'g', (0:(endind-1))*NewData.TimeStep, (60*10/10*NewData.Data(1:endind,2)-60*10/10*GoldData.Data(1:endind,2))./(60*10/10*GoldData.Data(1:endind,2)), 'b', (0:(endind-1))*NewData.TimeStep, (60*NewData.Data(1:endind,3)-60*10/10*GoldData.Data(1:endind,3))./(60*10/10*GoldData.Data(1:endind,3)),'r');
        hold(handles.axes7, 'on');
        plot(handles.axes7, [0.014 0.014],[-1 1],'k','LineWidth',2);
        hold(handles.axes7, 'off');
        axis(handles.axes7, [0 0.5 -0.04 0.04]);
    else
        plot(handles.axes7, (0:(endind-1))*NewData.TimeStep, (125*10/10*NewData.Data(1:endind,1)- ...
            interp1((0:(endindold-1))*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),(0:(endind-1))*NewData.TimeStep,'linear','extrap')')./ ...
            interp1((0:(endindold-1))*GoldData.TimeStep,125*10/10*GoldData.Data(1:endindold,1),(0:(endind-1))*NewData.TimeStep,'linear','extrap')', 'g', ...
            (0:(endind-1))*NewData.TimeStep, (60*10/10*NewData.Data(1:endind,2)- ...
            interp1((0:(endindold-1))*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),(0:(endind-1))*NewData.TimeStep,'linear','extrap')')./ ...
            interp1((0:(endindold-1))*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,2),(0:(endind-1))*NewData.TimeStep,'linear','extrap')', 'b', ...
            (0:(endind-1))*NewData.TimeStep, (60*NewData.Data(1:endind,3)- ...
            interp1((0:(endindold-1))*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),(0:(endind-1))*NewData.TimeStep,'linear','extrap')')./ ...
            interp1((0:(endindold-1))*GoldData.TimeStep,60*10/10*GoldData.Data(1:endindold,3),(0:(endind-1))*NewData.TimeStep,'linear','extrap')','r');
        hold(handles.axes7, 'on');
        plot(handles.axes7, [0.014 0.014],[-1 1],'k','LineWidth',2);
        hold(handles.axes7, 'off');
        axis(handles.axes7, [0 0.5 -0.04 0.04]);
    end
    %legend(handles.axes7, '\Delta_{BEND}', '\Delta{QD}','\Delta{QF}');
    xlabel(handles.axes7, 'Time [Seconds]');
    ylabel(handles.axes7, '(I_{present}-I_{golden})/I_{golden}');
    
    title(handles.axes7, 'GRN=\Delta I / I_{BEND}   Blue=\Delta I / I_{QD}   Red=\Delta I / I_{QF}');
    
    drawnow
    
    pause(1.2);
    
%     % Just to stop before waiting 3 seconds
%     t0 = clock;
%     StopFlag = 0;
%     while etime(clock,t0)<3
%         % Check is the figure got closed
%         if ~exist('handles','var') || ~ishandle(handles.axes1) || strcmpi(get(handles.BRWaveformStart,'String'),'Start')
%             StopFlag = 1;
%             break
%         end
%         pause(.2);
%     end
%     if StopFlag
%         break
%     end
end




% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end


% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
printdlg(handles.figure1)


% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


function data = readdvmfile_local(FileName)
fid = fopen(FileName, 'r');
data.TimeStep = fscanf(fid, '%f', 1);
data.Line2    = fscanf(fid, '%f', 1);
data.Data     = fscanf(fid, '%f %f %f', [3 inf])';
fclose(fid);

