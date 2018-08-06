function varargout = FMA(varargin)
% FMA MATLAB code for FMA.fig
%      FMA, by itself, creates a new FMA or raises the existing
%      singleton*.
%
%      H = FMA returns the handle to a new FMA or the handle to
%      the existing singleton*.
%
%      FMA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FMA.M with the given input arguments.
%
%      FMA('Property','Value',...) creates a new FMA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FMA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FMA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FMA

% Last Modified by GUIDE v2.5 05-Mar-2012 17:23:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FMA_OpeningFcn, ...
                   'gui_OutputFcn',  @FMA_OutputFcn, ...
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


% --- Executes just before FMA is made visible.
function FMA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FMA (see VARARGIN)

% Choose default command line output for FMA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
load('sample.mat');
tunediagbounds = [13  13.5   5.0   5.5];
workingpoint = [13.3 5.2];
plotfma(workingpoint,tunediagbounds,fma,handles);

% UIWAIT makes FMA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FMA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Qx_Callback(hObject, eventdata, handles)
% hObject    handle to Qx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Qx as text
%        str2double(get(hObject,'String')) returns contents of Qx as a double


% --- Executes during object creation, after setting all properties.
function Qx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Qx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Qy_Callback(hObject, eventdata, handles)
% hObject    handle to Qy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Qy as text
%        str2double(get(hObject,'String')) returns contents of Qy as a double


% --- Executes during object creation, after setting all properties.
function Qy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Qy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function THx_Callback(hObject, eventdata, handles)
% hObject    handle to THx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load fma.mat;
Qx = str2num(get(handles.Qx,'String'));
Qy = str2num(get(handles.Qy,'String'));
workingpoint = [Qx Qy];
THx = str2num(get(handles.THx,'String'));
THy = str2num(get(handles.THy,'String'));
TLx = str2num(get(handles.TLx,'String'));
TLy = str2num(get(handles.TLy,'String'));
tunediagbounds = [TLx THx TLy THy];
plotfma(workingpoint,tunediagbounds,fma,handles);
% Hints: get(hObject,'String') returns contents of THx as text
%        str2double(get(hObject,'String')) returns contents of THx as a double


% --- Executes during object creation, after setting all properties.
function THx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to THx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function THy_Callback(hObject, eventdata, handles)
% hObject    handle to THy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load fma.mat;
Qx = str2num(get(handles.Qx,'String'));
Qy = str2num(get(handles.Qy,'String'));
workingpoint = [Qx Qy];
THx = str2num(get(handles.THx,'String'));
THy = str2num(get(handles.THy,'String'));
TLx = str2num(get(handles.TLx,'String'));
TLy = str2num(get(handles.TLy,'String'));
tunediagbounds = [TLx THx TLy THy];
plotfma(workingpoint,tunediagbounds,fma,handles);

% Hints: get(hObject,'String') returns contents of THy as text
%        str2double(get(hObject,'String')) returns contents of THy as a double


% --- Executes during object creation, after setting all properties.
function THy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to THy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TLx_Callback(hObject, eventdata, handles)
% hObject    handle to TLx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load fma.mat;
Qx = str2num(get(handles.Qx,'String'));
Qy = str2num(get(handles.Qy,'String'));
workingpoint = [Qx Qy];
THx = str2num(get(handles.THx,'String'));
THy = str2num(get(handles.THy,'String'));
TLx = str2num(get(handles.TLx,'String'));
TLy = str2num(get(handles.TLy,'String'));
tunediagbounds = [TLx THx TLy THy];
plotfma(workingpoint,tunediagbounds,fma,handles);
% Hints: get(hObject,'String') returns contents of TLx as text
%        str2double(get(hObject,'String')) returns contents of TLx as a double


% --- Executes during object creation, after setting all properties.
function TLx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TLx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TLy_Callback(hObject, eventdata, handles)
% hObject    handle to TLy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load fma.mat;
Qx = str2num(get(handles.Qx,'String'));
Qy = str2num(get(handles.Qy,'String'));
workingpoint = [Qx Qy];
THx = str2num(get(handles.THx,'String'));
THy = str2num(get(handles.THy,'String'));
TLx = str2num(get(handles.TLx,'String'));
TLy = str2num(get(handles.TLy,'String'));
tunediagbounds = [TLx THx TLy THy];
plotfma(workingpoint,tunediagbounds,fma,handles);
% Hints: get(hObject,'String') returns contents of TLy as text
%        str2double(get(hObject,'String')) returns contents of TLy as a double


% --- Executes during object creation, after setting all properties.
function TLy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TLy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FileName_Callback(hObject, eventdata, handles)
% hObject    handle to FileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileName as text
%        str2double(get(hObject,'String')) returns contents of FileName as a double


% --- Executes during object creation, after setting all properties.
function FileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.dat'},'Select an input file');
if filename == 0
    % Cancel selected... do nothing
    return
else
    latticefile = [pathname filename];
end

% Update the text field to reflect selection
set(handles.FileName,'String',latticefile);


% --- Executes on button press in Analyze.
function Analyze_Callback(hObject, eventdata, handles)
% hObject    handle to Analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
File = get(handles.FileName,'String');
fid = fopen(File,'r+');
fid2 = fopen('Lattice.m','w');
for i = 1:8
    tline = fgetl(fid);
end
filename = sscanf(tline(1:strfind(tline,'.')-1),'%s');
fprintf(fid2,'%s',filename);
fclose(fid);
fclose(fid2);
Lattice
[FractionalTune, IntegerTune] = modeltune;
workingpoint = [IntegerTune(1)+FractionalTune(1) IntegerTune(2)+FractionalTune(2)];
tunediagbounds = [IntegerTune(1) IntegerTune(1)+0.5 IntegerTune(2) IntegerTune(2)+0.5];
set(handles.Qx,'String',num2str(workingpoint(1)));
set(handles.Qy,'String',num2str(workingpoint(2)));
set(handles.THx,'String',num2str(tunediagbounds(2)));
set(handles.THy,'String',num2str(tunediagbounds(4)));
set(handles.TLx,'String',num2str(tunediagbounds(1)));
set(handles.TLy,'String',num2str(tunediagbounds(3)));
fma = fma_lib('analysis',File);
save fma.mat;
plotfma(workingpoint,tunediagbounds,fma,handles);


function varargout = plotfma(workingpoint,tunediagbounds,fma,handles)

% Defaults/Init
output = 0;
inputstruct = {}; ninput = 1;


% for i=1:nargin
%     if ischar(varargin{i})
%         if strcmpi(varargin{i},'file')
%             output = 1;
%         else
%             % Assumes that the string input is a filename.
%             ninput = ninput + 1;
%             inputstruct{ninput} = fma_lib('read',varargin{i});
%         end
%     elseif isstruct(varargin{i})
%         ninput = ninput + 1;
%         inputstruct{ninput} = varargin{i};
%     elseif isnumeric(varargin{i}) && length(varargin{i}) == 4
%         tunediagbounds = varargin{i};
%     elseif isnumeric(varargin{i}) && length(varargin{i}) == 2
%         workingpoint = varargin{i};
%     else
%         fprintf('\nInput parameter number %d not recognised',i);
%     end
% end

% h_coor = handles.figure1;
% h_freq = handles.figure1;

% nrows = floor(sqrt(ninput));
% ncols = ceil(ninput/nrows);

for i=1:ninput
%     fma = inputstruct{i};
    
    % Log of zero is undefined, so make it a really small number 1e-19.
    fma.data.dindex(find(fma.data.dindex == 0)) = 1e-19;

    % Plot dynamic aperture in coordinate space where the colour scale has
    % been indexed by the diffusion index.
%     figure(h_coor); subplot(nrows,ncols,i);
	axes(handles.DA);
    cla;
    m = length(fma.mesh.y);
    n = length(fma.mesh.x);
    colorbar('SouthOutside');
    % Check if the definition of the mesh intervals are sorted. Older
    % versions of the code that generated the FMA input files did not sort
    % this and it led to problems when plotting results using SURFACE.
    [val minindx] = min(fma.mesh.x);
    [val maxindx] = max(fma.mesh.x);
    [val minindy] = min(fma.mesh.y);
    [val maxindy] = max(fma.mesh.y);
    if minindx ~= 1 || maxindx ~= n || minindy ~= 1 || maxindy ~= m
        % Sort the mesh intervals
        temp = zeros(m,n);
        temp = log10(reshape(fma.data.dindex,m,n));
        [sortedx xind] = sort(fma.mesh.x);
        [sortedy yind] = sort(fma.mesh.y);
        surface(sortedx,sortedy,temp(yind,xind));
    else
        surface(fma.mesh.x, fma.mesh.y, log10(reshape(fma.data.dindex,m,n)));
    end
%     title('Diffusion');
    if isfield(fma,'aperture')
        switch fma.aperture
            case 'Transverse'
                xlabel('Horizontal Displacement (mm)')
                ylabel('Vertical Displacement (mm)')
                axis equal;
            case 'Momentum'
                xlabel('Momentum (%)')
                ylabel('Horizontal Displacement (mm)')
                axis normal;
        end
    else
        xlabel('Horizontal Displacement (mm)')
        ylabel('Vertical Displacement (mm)')
        axis equal;
    end
    set(handles.DA,'XLim',[0.0 1.1*max(fma.mesh.x)]);
    set(handles.DA,'YLim',[0.0 1.1*max(fma.mesh.y)]);
    shading flat; 
    caxis([-12 -0.17]);

    nux = fma.data.nux2+fix(workingpoint(1));
    nux(find(nux > (fix(workingpoint(1))+0.5))) = nux(find(nux > (fix(workingpoint(1))+0.5)))-1;
    nuy = fma.data.nuy2+fix(workingpoint(2));
    nuy(find(nuy > (fix(workingpoint(2))+0.5))) = nuy(find(nuy > (fix(workingpoint(2))+0.5)))-1;

%     figure(h_freq); subplot(nrows,ncols,i);
    axes(handles.TD);
    cla;
%     colorbar('SouthOutside');
    order = str2num(get(handles.order,'String'));
    tuneplot([tunediagbounds(1),tunediagbounds(2)],[tunediagbounds(3),tunediagbounds(4)],order,handles);
%     plottunediag(7,1, tunediagbounds,workingpoint,'-nospawn');%9,14
    hold on;
    title(''); 
    scatter(nux, nuy, 5, log10(fma.data.dindex),'filled');
    plot(workingpoint(1),workingpoint(2),'rs','MarkerEdgeColor','k','LineWidth',2,'MarkerFaceColor','r','MarkerSize',6);
%     axis square; 
    caxis([-12 -0.17]);
    axis(tunediagbounds);
%     set(handles.TD,'XLim',[13 13.5]);
%     set(handles.TD,'YLim',[5 5.5]);
end

% if output
%     print(h_coor,'-depsc2',sprintf('dynamic_aperture_%s.eps',fma.aperture));
% end
% if output
%     print(h_freq,'-depsc2',sprintf('frequency_map_%s.eps',fma.aperture));
% end
% handles.difhandle = h_coor;
% handles.tunehandle= h_freq;
% 
% varargout{1} = handles;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fma_gui;

function R = tuneplot(XTUNE,YTUNE,RESORDER,varargin)
%TUNESPACEPLOT draws a tune diagram
% resonance lines: m*nu_x + n*nu_y = p

%
% TUNESPACEPLOT(XTUNE, YTUNE, ORDER)
%
% XTUNE = [XTUNEMIN,XTUNEMAX] 
% YTUNE = [YTUNEMIN,YTUNEMAX] - plotting range in tune space
% RESORDER - resonance order: |m| + |n|

% TUNESPACEPLOT(XTUNE, YTUNE, ORDER, FIGHANDLE)
% TUNESPACEPLOT(XTUNE, YTUNE, ORDER, FIGHANDLE)


% 


 

% if nargin>3
%     if ishandle(varargin{1}) & strcmp(get(varargin{1},'Type'),'figure')
%         % Plot tune space plot
%         figure(varargin{1});
%     else % create new figure
%         figure
%         axes;   
%     end
% end
if nargin>4
    LINEARGS = varargin(2:end);
else
    LINEARGS = {};
end
handles = varargin{1};

axes(handles.TD);
axis([XTUNE,YTUNE]);
% axis square
        
for X = RESORDER:-1:1
R = zeros(8*length(X),6);
NLMAX = 0;
for r = X
    for m = 0:r
        n = r-m;
        
        % Lower
        p1 = ceil(m*XTUNE(1)+n*YTUNE(1));
        p2 = floor(m*XTUNE(2)+n*YTUNE(1));
        
            
        for p =p1:p2 
            if m % lines with m=0 do not cross upper and lower sides 
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,(p-n*YTUNE(1))/m,YTUNE(1)];
            end
        end
        
        % Left
        p1 = ceil(m*XTUNE(1)+n*YTUNE(1));
        p2 = floor(m*XTUNE(1)+n*YTUNE(2));
        
        
        for p =p1:p2
            if n % lines with n=0 do not cross left and right sides 
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,XTUNE(1),(p-m*XTUNE(1))/n];
            end
        end
        
        % Upper
        p1 = ceil(m*XTUNE(1)+n*YTUNE(2));
        p2 = floor(m*XTUNE(2)+n*YTUNE(2));
        
        for p=p1:p2
            if m
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,(p-n*YTUNE(2))/m,YTUNE(2)];
            end
        end
        
        % Right
        p1 = ceil(m*XTUNE(2)+n*YTUNE(1));
        p2 = floor(m*XTUNE(2)+n*YTUNE(2));
        
        for p=p1:p2
            if n
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,XTUNE(2),(p-m*XTUNE(2))/n];
            end
        end
        
        % ======================== 
        n = -r+m;
        
        % Lower
        p1 = ceil(m*XTUNE(1)+n*YTUNE(1));
        p2 = floor(m*XTUNE(2)+n*YTUNE(1));
        
        for p =p1:p2 
            if m % lines with m=0 do not cross upper and lower sides 
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,(p-n*YTUNE(1))/m,YTUNE(1)];
            end
        end
        
        % Left
        % Note: negative n
        p1 = floor(m*XTUNE(1)+n*YTUNE(1));
        p2 = ceil(m*XTUNE(1)+n*YTUNE(2));
        
        for p =p2:p1
            if n % lines with n=0 do not cross left and right sides 
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,XTUNE(1),(p-m*XTUNE(1))/n];
            end
        end
        
        % Upper
        p1 = ceil(m*XTUNE(1)+n*YTUNE(2));
        p2 = floor(m*XTUNE(2)+n*YTUNE(2));
        
        for p=p1:p2
            if m
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,(p-n*YTUNE(2))/m,YTUNE(2)];
            end
        end
        
        % Right
        % Note: negative n
        
        p1 = floor(m*XTUNE(2)+n*YTUNE(1));
        p2 = ceil(m*XTUNE(2)+n*YTUNE(2));
        for p=p2:p1
            if n
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,XTUNE(2),(p-m*XTUNE(2))/n];
            end
        end
    end
end

%R = sortrows(R(1:NLMAX,:));
R = unique(R(1:NLMAX,:),'rows');
[temp,I,J] = unique(R(:,1:4),'rows');
K = I(find(diff([0;I])==2))-1;

RESNUM = [R(K,1:4)]; % [o, m, n, p] O = |m| + |n|
X1 = R(K,5);
X2 = R(K+1,5);
Y1 = R(K,6);
Y2 = R(K+1,6);


% Remove accidental lines that are on the box edge
K1 = (X1==X2) & (X1==XTUNE(1));
K2 = (X1==X2) & (X1==XTUNE(2));
K3 = (Y1==Y2) & (Y1==YTUNE(1));
K4 = (Y1==Y2) & (Y1==YTUNE(2));

K = find(~(K1 | K2 | K3 | K4));


RESNUM = RESNUM(K,:);
X1 = X1(K);
X2 = X2(K);
Y1 = Y1(K);
Y2 = Y2(K);


R = [RESNUM,X1,Y1,X2,Y2];






NL = size(RESNUM,1);
for i = 1:NL
    switch X
        case 1
            hl = line([X1(i) X2(i)],[Y1(i) Y2(i)],'Color','y','LineWidth',2,'LineStyle','--');
        case 2
            hl = line([X1(i) X2(i)],[Y1(i) Y2(i)],'Color','b','LineWidth',2,'LineStyle','--');
        case 3
            hl = line([X1(i) X2(i)],[Y1(i) Y2(i)],'Color','g','LineWidth',2,'LineStyle','--');
        case 4
            hl = line([X1(i) X2(i)],[Y1(i) Y2(i)],'Color','r','LineWidth',2,'LineStyle','--');
        otherwise
            hl = line([X1(i) X2(i)],[Y1(i) Y2(i)],'Color','k','LineWidth',2,'LineStyle','--');
    end
    if ~isempty(LINEARGS)
        set(hl,LINEARGS{:});
    end
end
end
xlabel('Qx');
ylabel('Qy');
% global THERING
% [TD, Tune] = twissring(THERING, 0, 1:(length(THERING)+1));
% if strcmpi(getmode('RF'),'Online')
% [FractionalTune, IntegerTune] = modeltune;
% Tune = [FractionalTune(1)+IntegerTune(1),FractionalTune(2)+IntegerTune(2)];
% end
% set(handles.T1,'String',Tune(1));
% set(handles.T2,'String',Tune(2));
% set(handles.axes1,'NextPlot','add');
% axes(handles.TD);
% hold on;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function order_Callback(hObject, eventdata, handles)
% hObject    handle to order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load fma.mat;
THx = str2num(get(handles.THx,'String'));
THy = str2num(get(handles.THy,'String'));
TLx = str2num(get(handles.TLx,'String'));
TLy = str2num(get(handles.TLy,'String'));
tunediagbounds = [TLx THx TLy THy];
plotfma(workingpoint,tunediagbounds,fma,handles);
% Hints: get(hObject,'String') returns contents of order as text
%        str2double(get(hObject,'String')) returns contents of order as a double


% --- Executes during object creation, after setting all properties.
function order_CreateFcn(hObject, eventdata, handles)
% hObject    handle to order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [filename, pathname] = uigetfile({'*.mat'},'Select an input file');
% if filename == 0
%     % Cancel selected... do nothing
%     return
% else
%     latticefile = [pathname filename];
% end
% load fma.mat;
% set(handles.Qx,'String',num2str(workingpoint(1)));
% set(handles.Qy,'String',num2str(workingpoint(2)));
% set(handles.THx,'String',num2str(tunediagbounds(2)));
% set(handles.THy,'String',num2str(tunediagbounds(4)));
% set(handles.TLx,'String',num2str(tunediagbounds(1)));
% set(handles.TLy,'String',num2str(tunediagbounds(3)));
% plotfma(workingpoint,tunediagbounds,fma,handles);
