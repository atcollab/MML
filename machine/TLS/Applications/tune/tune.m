function varargout = tune(varargin)
% TUNE M-file for tune.fig
%      TUNE, by itself, creates a new TUNE or raises the existing
%      singleton*.
%
%      H = TUNE returns the handle to a new TUNE or the handle to
%      the existing singleton*.
%
%      TUNE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TUNE.M with the given input arguments.
%
%      TUNE('Property','Value',...) creates a new TUNE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tune_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tune_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tune

% Last Modified by GUIDE v2.5 08-Dec-2010 15:25:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tune_OpeningFcn, ...
                   'gui_OutputFcn',  @tune_OutputFcn, ...
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


% --- Executes just before tune is made visible.
function tune_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tune (see VARARGIN)

% Choose default command line output for tune
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
axes(handles.axes1);
cla;
XTUNE = [str2num(get(handles.X1,'String')),str2num(get(handles.X2,'String'))];
YTUNE = [str2num(get(handles.Y1,'String')),str2num(get(handles.Y2,'String'))];
tuneplot(XTUNE,YTUNE,str2num(get(handles.order,'String')),handles);
QUAD = [getsp('QD1'),getsp('QF1'),getsp('QD2'),getsp('QF2')];
set(handles.figure1,'UserData',QUAD);


% UIWAIT makes tune wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tune_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

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

axes(handles.axes1);
axis([XTUNE,YTUNE]);
axis square
        
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
    Tune = gettune;
    Tune = [Tune(1)+7,Tune(2)+4];
% end
set(handles.T1,'String',Tune(1));
set(handles.T2,'String',Tune(2));
set(handles.axes1,'NextPlot','add');
plot(Tune(1),Tune(2),'*','MarkerEdgeColor','b','MarkerSize',10);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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



function order_Callback(hObject, eventdata, handles)
% hObject    handle to order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;
XTUNE = [str2num(get(handles.X1,'String')),str2num(get(handles.X2,'String'))];
YTUNE = [str2num(get(handles.Y1,'String')),str2num(get(handles.Y2,'String'))];
tuneplot(XTUNE,YTUNE,str2num(get(handles.order,'String')),handles);
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



function X1_Callback(hObject, eventdata, handles)
% hObject    handle to X1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;
XTUNE = [str2num(get(handles.X1,'String')),str2num(get(handles.X2,'String'))];
YTUNE = [str2num(get(handles.Y1,'String')),str2num(get(handles.Y2,'String'))];
tuneplot(XTUNE,YTUNE,str2num(get(handles.order,'String')),handles);

% Hints: get(hObject,'String') returns contents of X1 as text
%        str2double(get(hObject,'String')) returns contents of X1 as a double


% --- Executes during object creation, after setting all properties.
function X1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function X2_Callback(hObject, eventdata, handles)
% hObject    handle to X2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;
XTUNE = [str2num(get(handles.X1,'String')),str2num(get(handles.X2,'String'))];
YTUNE = [str2num(get(handles.Y1,'String')),str2num(get(handles.Y2,'String'))];
tuneplot(XTUNE,YTUNE,str2num(get(handles.order,'String')),handles);

% Hints: get(hObject,'String') returns contents of X2 as text
%        str2double(get(hObject,'String')) returns contents of X2 as a double


% --- Executes during object creation, after setting all properties.
function X2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Y1_Callback(hObject, eventdata, handles)
% hObject    handle to Y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;
XTUNE = [str2num(get(handles.X1,'String')),str2num(get(handles.X2,'String'))];
YTUNE = [str2num(get(handles.Y1,'String')),str2num(get(handles.Y2,'String'))];
tuneplot(XTUNE,YTUNE,str2num(get(handles.order,'String')),handles);

% Hints: get(hObject,'String') returns contents of Y1 as text
%        str2double(get(hObject,'String')) returns contents of Y1 as a double


% --- Executes during object creation, after setting all properties.
function Y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Y2_Callback(hObject, eventdata, handles)
% hObject    handle to Y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;
XTUNE = [str2num(get(handles.X1,'String')),str2num(get(handles.X2,'String'))];
YTUNE = [str2num(get(handles.Y1,'String')),str2num(get(handles.Y2,'String'))];
tuneplot(XTUNE,YTUNE,str2num(get(handles.order,'String')),handles);

% Hints: get(hObject,'String') returns contents of Y2 as text
%        str2double(get(hObject,'String')) returns contents of Y2 as a double


% --- Executes during object creation, after setting all properties.
function Y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [DelQuad, ActuatorFamily] = set_tune(varargin,handles)
%SETTUNE - Set the tune
%  [DelQuad, QuadFamily] = settune(NuDesired, InteractiveFlag, TuneResponseMatrix);
%
%  INPUTS
%  1. NuDesired - Desired tune   [NuX; NuY] (2x1) {Default: golden tunes}
%  2. InteractiveFlag - 0    -> No display information
%                       else -> display tune information before setting magnets {Default}
%  3. TuneResponseMatrix - Tune response matrix {Default: gettuneresp}
%  4. ActuatorFamily -  Quadrupole to vary, ex {'Q7', 'Q9'} {Default: gettuneresp}
%  5. Optional override of the units:
%     'Physics'  - Use physics  units
%     'Hardware' - Use hardware units
%  6. Optional override of the mode:
%     'Online'    - Set/Get data online  
%     'Model'     - Set/Get data on the simulated accelerator using AT
%     'Simulator' - Set/Get data on the simulated accelerator using AT
%     'Manual'    - Set/Get data manually
%
%  OUTPUTS
%  1. DelQuad
%  2. QuadFamily - Families used (cell array)
%
%  Algorithm:  
%     SVD method
%     DelQuad = inv(TuneResponseMatrix) * DeltaTune
%     instead of 
%     DelQuad = inv(TuneResponseMatrix) * (Nu-gettune)
%              DelQuad = [Q7; Q9]
%
%  NOTES
%  1. If gettune only uses the fractional tune then NuDesired should only have fractional tunes.
%  2. The tune measurement system must be running correctly for this routine to work properly.
%
%  EXAMPLES
%  1. use 2 defaults family if specified in 'Tune Corrector'
%     settune([18.23 10.3]
%  2. use 10 families
%     Qfam = findmemberof('QUAD');
%     RTune = meastuneresp(Qfam, 'Model')
%     [DK Fam] = settune([18.12 10.3],1,RTune,Qfam,'Model')
%
%  See also steptune, gettune

%  Written by Gregory J. Portmann
%  Modified by Laurent S. Nadolski
%    Adaptation for SOLEIL
%    Modification ALGO : use SVD as in steptune

% Case of 2 families or more
% ActuatorFamily = findmemberof('Tune Corrector')';
ActuatorFamily = {};
if get(handles.Q1,'Value') == 1
    ActuatorFamily = cat(2,ActuatorFamily,'QD1');
end
if get(handles.Q2,'Value') == 1
    ActuatorFamily = cat(2,ActuatorFamily,'QF1');
end
if get(handles.Q3,'Value') == 1
    ActuatorFamily = cat(2,ActuatorFamily,'QD2');
end
if get(handles.Q4,'Value') == 1
    ActuatorFamily = cat(2,ActuatorFamily,'QF2');
end
if isempty(ActuatorFamily) % Default 2 families
    ActuatorFamily = {'QF','QD'};
end

% Input parser
UnitsFlag = {}; 
ModeFlag = {};
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'physics')
        UnitsFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        ModeFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'online')
        ModeFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'manual')
        ModeFlag = varargin(i);
        varargin(i) = [];
    end        
end


if length(varargin) >= 1
    Nu = varargin{1};
else
    Nu =[];
end

% Golden values
% if isempty(Nu)
%     Nu = getgolden('TUNE',[1 1;1 2]);
% end

% if isempty(Nu)
%     error('Tune must be an input or the golden tunes must be available.');
% end
% Nu = Nu(:);
% if ~all(size(Nu) == [2 1])
%     error('Nu must be a 2x1 vector.');
% end

if length(varargin) >= 2
    InteractiveFlag = varargin{2};
else
    InteractiveFlag = 1;
end

% Get tune response matrix
if length(varargin) >= 3
    TuneResponseMatrix = varargin{3};
else
    TuneResponseMatrix = [];
end

% Get ActuatorFamilies
if length(varargin) >= 4
    ActuatorFamily1 = varargin{4};
else
    ActuatorFamily1 = ActuatorFamily;
end

% Interactive part
if InteractiveFlag
    Flag = 1;
    if isempty(TuneResponseMatrix)
        TuneResponseMatrix = gettuneresp(ActuatorFamily,UnitsFlag{:});
    end
    if isempty(TuneResponseMatrix)
        error('The tune response matrix must be an input or available in one of the default response matrix files.');
    end
    while Flag
%         global THERING
%         [TD, TuneOld] = twissring(THERING, 0, 1:(length(THERING)+1));
%         if strcmpi(getmode('RF'),'Online')
            TuneOld = gettune;
            TuneOld = [TuneOld(1)+7,TuneOld(2)+4];
%         end
%         TuneOld = gettune;
        TuneOld = TuneOld';
        Nu(1) = str2num(get(handles.S1,'String'));
        Nu(2) = str2num(get(handles.S2,'String'));
        Nu = Nu';
        fprintf('\n');
        fprintf('  Present Tune:  Horizontal = %.4f   Vertical = %.4f\n', TuneOld(1), TuneOld(2));
        fprintf('     Goal Tune:  Horizontal = %.4f   Vertical = %.4f\n', Nu(1), Nu(2));

        DelNu = Nu - TuneOld;

        % 1. SVD Tune Correction
        % Decompose the tune response matrix:
        [U, S, V] = svd(TuneResponseMatrix, 'econ');
        % TuneResponseMatrix = U*S*V'
        %
        % The V matrix columns are the singular vectors in the quadrupole magnet space
        % The U matrix columns are the singular vectors in the TUNE space
        % U'*U=I and V*V'=I
        %
        % TUNECoef is the projection onto the columns of TuneResponseMatrix*V(:,Ivec) (same space as spanned by U)
        % Sometimes it's interesting to look at the size of these coefficients with singular value number.
        TUNECoef = diag(diag(S).^(-1)) * U' * DelNu;
        %
        % Convert the vector TUNECoef back to coefficents of TuneResponseMatrix
        DelQuad = V * TUNECoef;

        % 2. Square matrix solution
        % DelQuad = inv(TuneResponseMatrix) * DelNu; %  DelQuad = [Q7; Q9];


        % 3. Least squares solution
        % DelQuad = inv(TuneResponseMatrix'*TuneResponseMatrix)*TuneResponseMatrix' * DeltaTune;
        %
        % see Matlab help for "Matrices and Linear Algebra" to see what this does
        % If overdetermined, then "\" is least squares
        %
        % If underdetermined (like more than 2 quadrupole families), then only the
        % columns with the 2 biggest norms will be keep.  The rest of the quadupole
        % families with have zero effect.  Hence, constraints would have to be added for
        % this method to work.
        % DelQuad = TuneResponseMatrix \ DelNu;

        for k = 1:length(ActuatorFamily1)
            [Units, UnitsString] = getunits(ActuatorFamily1{k});
            if k == 1
                fprintf('   Quad Change:  Delta %3s = %+f %s\n', ActuatorFamily1{k}, DelQuad(k), UnitsString);
            else
                fprintf('                 Delta %3s = %+f %s\n', ActuatorFamily1{k}, DelQuad(k), UnitsString);
            end
            switch ActuatorFamily1{k}
                case 'QD1'
                    set(handles.QC1,'String',DelQuad(k));
                    stepsp('QD1',DelQuad(k));
                case 'QF1'
                    set(handles.QC2,'String',DelQuad(k));
                    stepsp('QF1',DelQuad(k));
                case 'QD2'
                    set(handles.QC3,'String',DelQuad(k));
                    stepsp('QD2',DelQuad(k));
                case 'QF2'
                    set(handles.QC4,'String',DelQuad(k));
                    stepsp('QF2',DelQuad(k));
            end
        end
        fprintf('\n')

%         tmp = menu('Choose an option?','Step quadrupoles','Remeasure Tunes','Change goal tune','Exit');
%         if tmp == 1
%             Flag = 0;
%         elseif tmp == 2
%             Flag = 1;
%         elseif tmp == 3
%             Nu(1) = input('  Input new horizontal tune = ');
%             Nu(2) = input('  Input new   vertical tune = ');
%             % Nu(1) = rem(Nu(1),1);
%             % Nu(2) = rem(Nu(2),1);
%         else
%             disp('  Tunes not changed.');
%             return
%         end
         Flag = 0;
    end

    disp('  Changing quadrupoles...');

else
    % Non interactive part
    TuneOld = gettune;
end


% Set the tune
DeltaTune = Nu - TuneOld;
if size(DeltaTune,1) ~= 2
	error('Input must be a 2x1 column vector.');
end

% Step the tune
% [DelQuad, ActuatorFamily] = steptune(DeltaTune, TuneResponseMatrix, UnitsFlag{:}, ModeFlag{:});


if InteractiveFlag
   disp('  Set tune complete.');
end


% --- Executes on button press in T1.
function Q1_Callback(hObject, eventdata, handles)
% hObject    handle to T1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of T1


% --- Executes on button press in T2.
function Q2_Callback(hObject, eventdata, handles)
% hObject    handle to T2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of T2


% --- Executes on button press in Q3.
function Q3_Callback(hObject, eventdata, handles)
% hObject    handle to Q3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Q3


% --- Executes on button press in Q4.
function Q4_Callback(hObject, eventdata, handles)
% hObject    handle to Q4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Q4



function S1_Callback(hObject, eventdata, handles)
% hObject    handle to S1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of S1 as text
%        str2double(get(hObject,'String')) returns contents of S1 as a double


% --- Executes during object creation, after setting all properties.
function S1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function S2_Callback(hObject, eventdata, handles)
% hObject    handle to S2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of S2 as text
%        str2double(get(hObject,'String')) returns contents of S2 as a double


% --- Executes during object creation, after setting all properties.
function S2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.QC1,'String',[]);
set(handles.QC2,'String',[]);
set(handles.QC3,'String',[]);
set(handles.QC4,'String',[]);
set_tune('',handles);
axes(handles.axes1);
cla;
XTUNE = [str2num(get(handles.X1,'String')),str2num(get(handles.X2,'String'))];
YTUNE = [str2num(get(handles.Y1,'String')),str2num(get(handles.Y2,'String'))];
tuneplot(XTUNE,YTUNE,str2num(get(handles.order,'String')),handles);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
QUAD = get(handles.figure1,'UserData');
setsp('QD1',QUAD(:,1));
setsp('QF1',QUAD(:,2));
setsp('QD2',QUAD(:,3));
setsp('QF2',QUAD(:,4));
set(handles.QC1,'String',[]);
set(handles.QC2,'String',[]);
set(handles.QC3,'String',[]);
set(handles.QC4,'String',[]);
set(handles.Q1,'Value',0);
set(handles.Q2,'Value',0);
set(handles.Q3,'Value',0);
set(handles.Q4,'Value',0);
set(handles.X1,'String',7.2);
set(handles.X2,'String',7.4);
set(handles.Y1,'String',4.1);
set(handles.Y2,'String',4.3);
set(handles.order,'String',4);
set(handles.S1,'String',[]);
set(handles.S2,'String',[]);
axes(handles.axes1);
cla;
XTUNE = [str2num(get(handles.X1,'String')),str2num(get(handles.X2,'String'))];
YTUNE = [str2num(get(handles.Y1,'String')),str2num(get(handles.Y2,'String'))];
tuneplot(XTUNE,YTUNE,str2num(get(handles.order,'String')),handles);



function QC1_Callback(hObject, eventdata, handles)
% hObject    handle to QC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QC1 as text
%        str2double(get(hObject,'String')) returns contents of QC1 as a double


% --- Executes during object creation, after setting all properties.
function QC1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QC2_Callback(hObject, eventdata, handles)
% hObject    handle to QC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QC2 as text
%        str2double(get(hObject,'String')) returns contents of QC2 as a double


% --- Executes during object creation, after setting all properties.
function QC2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QC3_Callback(hObject, eventdata, handles)
% hObject    handle to QC3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QC3 as text
%        str2double(get(hObject,'String')) returns contents of QC3 as a double


% --- Executes during object creation, after setting all properties.
function QC3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QC3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QC4_Callback(hObject, eventdata, handles)
% hObject    handle to QC4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QC4 as text
%        str2double(get(hObject,'String')) returns contents of QC4 as a double


% --- Executes during object creation, after setting all properties.
function QC4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QC4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lock.
function lock_Callback(hObject, eventdata, handles)
% hObject    handle to lock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
X = get(handles.lock,'Value');
tune1 = gettune;
tune2 = [str2num(get(handles.S1,'String'))-7;str2num(get(handles.S2,'String'))-4];
while X
    if strcmpi(getmode('RF'),'Online')
        tune = gettune;
        current = getpv('DCCT');
        if current < 5
            msg = msgbox('Beam Loss!','','error');
            th = findall(msg,'Type','Text');
            set(th,'color','b');
            set(th,'FontSize',12);
            set(th,'FontName','Arial');
            X = 0;
            set(handles.lock,'Value',0);
            break
        end
        if abs(tune2(1)-tune(1)) > 0.005 || abs(tune2(2)-tune(2)) > 0.005
            sleep(4);
            tune = gettune;
            if abs(tune2(1)-tune(1)) > 0.005 || abs(tune2(2)-tune(2)) > 0.005
                msg = msgbox('Error Tunes!','','error');
                th = findall(msg,'Type','Text');
                set(th,'color','b');
                set(th,'FontSize',12);
                set(th,'FontName','Arial');
                X = 0;
                set(handles.lock,'Value',0);
                break
            end
        end
        time = ctl_readin('tuinjetime');
        if time > 58
            sleep(4);
        else
            if get(handles.lock,'Value') == 1
                pushbutton6_Callback(hObject, eventdata, handles);
                X = 1;
            elseif get(handles.lock,'Value') == 0
                msg = msgbox('Lock process is stop!','','warn');
                th = findall(msg,'Type','Text');
                set(th,'color','b');
                set(th,'FontSize',12);
                set(th,'FontName','Arial');
                X = 0;
            end
            sleep(3);
        end 
    else
        if get(handles.lock,'Value') == 1
            pushbutton6_Callback(hObject, eventdata, handles);
            X = 1;
        elseif get(handles.lock,'Value') == 0
            msg = msgbox('Lock process is stop!','','warn');
            th = findall(msg,'Type','Text');
            set(th,'color','b');
            set(th,'FontSize',12);
            set(th,'FontName','Arial');
            X = 0;
        end
        sleep(3);
    end      
end
    

% Hint: get(hObject,'Value') returns toggle state of lock
