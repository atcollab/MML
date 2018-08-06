function varargout = synchro_mode_tests(varargin)
% SYNCHRO_MODE_TESTS M-file for synchro_mode_tests.fig
%      SYNCHRO_MODE_TESTS, by itself, creates a new SYNCHRO_MODE_TESTS or raises the existing
%      singleton*.
%
%      H = SYNCHRO_MODE_TESTS returns the handle to a new SYNCHRO_MODE_TESTS or the handle to
%      the existing singleton*.
%
%      SYNCHRO_MODE_TESTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYNCHRO_MODE_TESTS.M with the given input arguments.
%
%      SYNCHRO_MODE_TESTS('Property','Value',...) creates a new SYNCHRO_MODE_TESTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before synchro_mode_tests_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to synchro_mode_tests_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help synchro_mode_tests

% Last Modified by GUIDE v2.5 22-Feb-2007 16:58:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @synchro_mode_tests_OpeningFcn, ...
                   'gui_OutputFcn',  @synchro_mode_tests_OutputFcn, ...
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


% --- Executes just before synchro_mode_tests is made visible.
function synchro_mode_tests_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to synchro_mode_tests (see VARARGIN)


set(handles.edit_etat, 'String','??');
% Choose default command line output for synchro_mode_tests
handles.output = hObject;

% Choix des events
handles.event0 =int32(0);
handles.event00=int32(100);  %Spéciale EP

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes synchro_mode_tests wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = synchro_mode_tests_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_linac_3Hz.
function pushbutton_linac_3Hz_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_linac_3Hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('synchro_offset_lin', 'inj_offset' , 'ext_offset', 'lin_fin');
tout=0.;
event0=handles.event0;

    % switch to 3Hz
        event=int32(2) ;% adresse de l'injection
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',     event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent',   event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',     event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',     event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',      event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent', event); pause(tout);
   % pas d'injection
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent', event0); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent',    event0);     
        
    % special modulateur
        delay=inj_offset+0;
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareTimeDelay',delay);
        %display('ok change soft to 3Hz')
        
set(handles.edit_etat, 'String','LINAC = 3Hz');


% --- Executes on button press in pushbutton_linac_soft.
function pushbutton_linac_soft_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_linac_soft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('synchro_offset_lin', 'inj_offset' , 'ext_offset', 'lin_fin');
tout=0.;
event0=handles.event0;
event00=handles.event00;

    % switch to soft
        event=int32(5) ;% adresse de l'injection
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',      event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent', event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent',    int32(1)); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent', event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',      event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',      event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',       event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',  event); pause(tout);
   % pas d'injection
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent', event0); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent',    event0);
   % Pas d'extraction
        tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent',      event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent',  event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent',event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent',event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent',    event0);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigEvent',    event0);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctEvent',     event0);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvEvent',        event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceEvent',   event0);pause(tout);
        arg.svalue={'k1.trig','k2.trig','k3.trig','k4.trig'}; arg.lvalue=int32([1 1 1 1])*event00; 
        tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','SetEventsNumbers',arg);% chagement groupé address sans update
        tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Update');
        
        arg.svalue={'sep-p.trig','sep-a.trig'}; arg.lvalue=int32([1 1])*event00; 
        tango_command_inout('ANS-C01/SY/LOCAL.Ainj.2','SetEventsNumbers',arg);% chagement groupé address sans update
        tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.2', 'Update');
    
    % special modulateur
        temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay');pc=temp.value(1);
        temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');soft=temp.value(1);
        delay=inj_offset+soft-pc;
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareTimeDelay',delay);
        %display('ok change 3Hz to soft')

set(handles.edit_etat, 'String','LINAC = Soft');

% --- Executes on button press in pushbutton_linac_Off.
function pushbutton_linac_Off_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_linac_Off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('synchro_offset_lin', 'inj_offset' , 'ext_offset', 'lin_fin');
tout=0.;
event0=handles.event0;

    % switch to Off
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',     event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent',   event0); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',event0); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',     event0); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',     event0); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',      event0); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent', event0); pause(tout);

set(handles.edit_etat, 'String','LINAC = Off');


% --- Executes on button press in pushbutton_boo_3Hz.
function pushbutton_boo_3Hz_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_3Hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('synchro_offset_lin', 'inj_offset' , 'ext_offset', 'lin_fin');
tout=0.;
event0=handles.event0;
event00=handles.event00;

    % switch to 3Hz
        event=int32(2) ;% adresse de l'injection
        tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscEvent',        event); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',        event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',   event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent',      event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigEvent',event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigEvent',event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigEvent',event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigEvent',event); pause(tout); 
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',   event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',        event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',        event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',         event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',    event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigEvent',event);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent', event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent',    event);
        % pas d'extraction
        tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent',      event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent',  event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent',event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent',event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent',    event0);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigEvent',    event0);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctEvent',     event0);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvEvent',        event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceEvent',   event0);pause(tout);
        arg.svalue={'k1.trig','k2.trig','k3.trig','k4.trig'}; arg.lvalue=int32([1 1 1 1])*event00; 
        tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','SetEventsNumbers',arg);% chagement groupé address sans update
        tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Update');
        
        arg.svalue={'sep-p.trig','sep-a.trig'}; arg.lvalue=int32([1 1])*event00; 
        tango_command_inout('ANS-C01/SY/LOCAL.Ainj.2','SetEventsNumbers',arg);% chagement groupé address sans update
        tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.2', 'Update');
        
     % special modulateur
        delay=inj_offset+0;
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareTimeDelay',delay);
        display('ok change soft to 3Hz')

set(handles.edit_etat, 'String','LINAC + BOO = 3Hz');


% --- Executes on button press in pushbutton_boo_soft.
function pushbutton_boo_soft_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_soft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('synchro_offset_lin', 'inj_offset' , 'ext_offset', 'lin_fin');
tout=0.;
event0=handles.event0;
event00=handles.event00;

    % switch to soft
        event=int32(5) ;% adresse de l'injection
        tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscEvent',        event); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',        event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',   event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent',      int32(1)); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigEvent',event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigEvent',event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigEvent',event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigEvent',event); pause(tout); 
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',   event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',        event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',        event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',         event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',    event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigEvent',event);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent', event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent',    event);
        % Pas d'extraction
        tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent',      event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent',  event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent',event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent',event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent',    event0);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigEvent',    event0);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctEvent',     event0);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvEvent',        event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceEvent',   event0);pause(tout);
        arg.svalue={'k1.trig','k2.trig','k3.trig','k4.trig'}; arg.lvalue=int32([1 1 1 1])*event00; 
        tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','SetEventsNumbers',arg);% chagement groupé address sans update
        tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Update');
        
        arg.svalue={'sep-p.trig','sep-a.trig'}; arg.lvalue=int32([1 1])*event00; 
        tango_command_inout('ANS-C01/SY/LOCAL.Ainj.2','SetEventsNumbers',arg);% chagement groupé address sans update
        tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.2', 'Update');

        
    % special modulateur
        temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay');pc=temp.value(1);
        temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');soft=temp.value(1);
        delay=inj_offset+soft-pc;
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareTimeDelay',delay);
        

set(handles.edit_etat, 'String','LINAC + BOO = Soft');


% --- Executes on button press in pushbutton_boo_off.
function pushbutton_boo_off_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('synchro_offset_lin', 'inj_offset' , 'ext_offset', 'lin_fin');
tout=0.;
event0=handles.event0;
event00=handles.event00;

    % switch to Off
        tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscEvent',        event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',        event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',   event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent',      event0); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigEvent',event0); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigEvent',event0); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigEvent',event0); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigEvent',event0); pause(tout);     
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',   event0); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',        event0); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',        event0); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',         event0); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',    event0); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigEvent',event0); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent',event0); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent',    event0); pause(tout);
        tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent',      event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent',  event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent',event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent',event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent',    event0);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceEvent',    event0);pause(tout);
        

set(handles.edit_etat, 'String','LINAC + BOO = Off');


% --- Executes on button press in pushbutton_ans_3hz.
function pushbutton_ans_3hz_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ans_3hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('synchro_offset_lin', 'inj_offset' , 'ext_offset', 'lin_fin');
tout=0.;
event0=handles.event0;
event00=handles.event00;

%     % switch to 3Hz
%         event=int32(2) ;% adresse de l'injection
%         tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscEvent',        event); pause(tout);
%         tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',        event0); pause(tout);
%         tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',   event0); pause(tout);
%         tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent',      eint32(1)); pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigEvent',event); pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigEvent',event); pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigEvent',event); pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigEvent',event); pause(tout); 
%         tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',   event); pause(tout);
%         tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',        event); pause(tout);
%         tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',        event); pause(tout);
%         tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',         event); pause(tout);
%         tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',    event); pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigEvent',event);pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent', event); pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent',     event);
%         event=int32(3) ;% adresse de extraction
%         tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent',      event);pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent',  event);pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent',event);pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent',event);pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent',    event);pause(tout);
%         tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigEvent',    event);pause(tout);
%         tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctEvent',     event);pause(tout);
%         tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvEvent',        event);pause(tout);
%         tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceEvent',   event);pause(tout);
%         
%         arg.svalue={'k1.trig','k2.trig','k3.trig','k4.trig'}; arg.lvalue=int32([3 3 3 3]); 
%         tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','SetEventsNumbers',arg);% chagement groupé address sans update
%        
%         arg.svalue={'sep-p.trig','sep-a.trig'}; arg.lvalue=int32([3 3]); 
%         tango_command_inout('ANS-C01/SY/LOCAL.Ainj.2','SetEventsNumbers',arg);% chagement groupé address sans update
%         
%         tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctEvent',    event);pause(tout);
%         tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigEvent',event);pause(tout);
%         tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
%         tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
%         tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
%         tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
%         tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
%         tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
%         tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
%         tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
%         tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
%         tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
%         tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
%         tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
%         tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
%         tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
%         tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
%     
%     % special modulateur
%         delay=inj_offset+0;
%         tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareTimeDelay',delay);
%         display('ok change soft to 3Hz')
        
       % special septum actif boo et ans
%         r=(1+0.0004); 
%         try
%             temp=tango_read_attribute2('BOO-C12/EP/AL_SEP_A.Ext','voltage');boo=temp.value(2)*r
%             tango_write_attribute2('BOO-C12/EP/AL_SEP_A.Ext','voltage',boo);        
%             temp=tango_read_attribute2('ANS-C01/EP/AL_SEP_A','voltage');ans=temp.value(2)*r
%             tango_write_attribute2('ANS-C01/EP/AL_SEP_A','voltage',ans);  
%         catch
%             display('Erreur ajustement tension septa passif')
%         end  


%display('ok change address')

set(handles.edit_etat, 'String','Aucune Action');


% --- Executes on button press in pushbutton_ans_soft.
function pushbutton_ans_soft_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ans_soft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('synchro_offset_lin', 'inj_offset' , 'ext_offset', 'lin_fin');
tout=0.;
event0=handles.event0;
event00=handles.event00;

    % switch to soft
        event=int32(5) ;% adresse de l'injection
        tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscEvent',        event); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',        event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',   event0); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent',      int32(1)); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigEvent',event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigEvent',event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigEvent',event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigEvent',event); pause(tout); 
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',   event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',        event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',        event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',         event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',    event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigEvent',event);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent', event); pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent',     event);
 
        tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent',      event);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent',  event);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent',event);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent',event);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent',    event);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigEvent',    event);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctEvent',     event);pause(tout);
        tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvEvent',        event);pause(tout);
        tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceEvent',   event);pause(tout);
        arg.svalue={'k1.trig','k2.trig','k3.trig','k4.trig'}; arg.lvalue=int32([5 5 5 5]); 
        tango_command_inout('ANS-C01/SY/LOCAL.Ainj.1','SetEventsNumbers',arg);% chagement groupé addresses sans update
        tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Update');
        
        arg.svalue={'sep-p.trig','sep-a.trig'}; arg.lvalue=int32([5 5]); 
        tango_command_inout('ANS-C01/SY/LOCAL.Ainj.2','SetEventsNumbers',arg);% chagement groupé address sans update
        tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.2', 'Update');
        
        tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctEvent',    int32(3));pause(tout);
        tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigEvent',event);pause(tout);
        tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
        tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
        tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
        tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
        tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
        tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
        tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
        tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
        tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
        tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
        tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
        tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
        tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
        tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
        tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);    
        
    % special modulateur
        temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay');pc=temp.value(1);
        temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');soft=temp.value(1);
        delay=inj_offset+soft-pc;
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareTimeDelay',delay);

        
%      % special septum actif boo et ans
%         r=(1-0.0004); 
%         try
%             temp=tango_read_attribute2('BOO-C12/EP/AL_SEP_A.Ext','voltage');boo=temp.value(2)*r
%             tango_write_attribute2('BOO-C12/EP/AL_SEP_A.Ext','voltage',boo);        
%             temp=tango_read_attribute2('ANS-C01/EP/AL_SEP_A','voltage');ans=temp.value(2)*r
%             tango_write_attribute2('ANS-C01/EP/AL_SEP_A','voltage',ans);  
%         catch
%             display('Erreur ajustement tension septa passif')
%         end  
        

set(handles.edit_etat, 'String','LINAC + BOO + ANS = Soft');




% --- Executes on button press in pushbutton_ans_off.
function pushbutton_ans_off_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ans_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.edit_etat, 'String','Aucune Action');

function edit_etat_Callback(hObject, eventdata, handles)
% hObject    handle to edit_etat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_etat as text
%        str2double(get(hObject,'String')) returns contents of edit_etat as a double


% --- Executes during object creation, after setting all properties.
function edit_etat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_etat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


