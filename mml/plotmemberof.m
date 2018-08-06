function [h_axes, h] = plotmemberof(varargin)
%PLOTMEMBEROF - Plots the setpoint and monitor for all members in a "MemberOf" group
%  [h_axes, h_line] = plotmemberof(MemberOfField)
%
%  INPUTS
%  1. MemberOfField - MemberOf name (string)
%  2. Units flag overrides
%     'Physics'  - Use physics  units
%     'Hardware' - Use hardware unitS
%  3. Lattice flag overrides
%     'Production' - Get data from the production lattice 
%     'Injection'  - get data from the injection lattice 
%     'Online' - Get data online 
%     'Model'  - get data on the model
%
%  See also plotquad, findmemberof, getmemberof

%  Written by Greg Portmann


% Look for keywords on the input line
ModeFlag = {};
UnitsFlags = {};
LatticeFlag = '';

for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        % Remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Simulator') || strcmpi(varargin{i},'Model')
        ModeFlag = {'Model'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        ModeFlag = {'Online'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Production')
        LatticeFlag = 'Production';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Injection')
        LatticeFlag = 'Injection';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        UnitsFlags = {'Physics'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlags = {'Hardware'};
        varargin(i) = [];
    end
end


if isempty(varargin)
    MemberOfField = '';
else
    MemberOfField = varargin{1};
end
if isempty(MemberOfField)
    % Just some typical fields
    MemberOfFieldCell = {'BPM','COR','QUAD','SEXT','Tune Corrector','Chromaticity Corrector'};
    [ButtonName, OKFlag] = listdlg('Name','PLOTMEMBEROF','PromptString',{'These are typical MemberOf fields.',' ', 'Selection one:'}, 'SelectionMode','single', 'ListString', MemberOfFieldCell, 'ListSize', [350 100], 'InitialValue', 2);
    drawnow;
    MemberOfField = MemberOfFieldCell{ButtonName};
    %error('1 input required');
end


FamilyNames = findmemberof(MemberOfField);

N = length(FamilyNames);

WidthScaleFactor = .75;

clf reset
for i = 1:N
    
    h_axes(i,1) = subplot(N,1,i);
        
    if isempty(getfamilydata(FamilyNames{i}, 'Setpoint'))
        NoSetpointFlag = 1;
    else
        NoSetpointFlag = 0;
    end

    if strcmpi(LatticeFlag,'Production')
        [SP, AM] = getproductionlattice(FamilyNames{i}, UnitsFlags{:});
        SP = SP.Setpoint;
        AM = AM.Monitor;
        if ~isempty(UnitsFlags) && strcmpi(UnitsFlags{1},'Physics')
            SP = hw2physics(SP);
            AM = hw2physics(AM);
        elseif ~isempty(UnitsFlags) && strcmpi(UnitsFlags{1},'Hardware')
            SP = physics2hw(SP);
            AM = physics2hw(AM);
        end
    elseif strcmpi(LatticeFlag,'Injection')
        [SP, AM] = getinjectionlattice(FamilyNames{i}, UnitsFlags{:});
        SP = SP.Setpoint;
        AM = AM.Monitor;
        if ~isempty(UnitsFlags) && strcmpi(UnitsFlags{1},'Physics')
            SP = hw2physics(SP);
            AM = hw2physics(AM);
        elseif ~isempty(UnitsFlags) && strcmpi(UnitsFlags{1},'Hardware')
            SP = physics2hw(SP);
            AM = physics2hw(AM);
        end
    else
        AM = getam(FamilyNames{i}, 'Struct', ModeFlag{:}, UnitsFlags{:});
       
        %[SP, AM] = getlattice(FamilyNames{i}, UnitsFlags{:});
        %f = fieldnames(AM);
        %AM = AM.(f{1});
    end

    if ~NoSetpointFlag
        if ~(strcmpi(LatticeFlag,'Production') || strcmpi(LatticeFlag,'Injection'))
            SP = getsp(FamilyNames{i}, 'Struct', ModeFlag{:}, UnitsFlags{:});
        end

        h(i,2) = bar(h_axes(i), 1:length(SP.Data), SP.Data, WidthScaleFactor);
        set(h(i,2),'FaceColor',[0 0 .5]);
        set(h(i,2),'EdgeColor',[0 0 .5]);

        hold(h_axes(i), 'on');
        h(i,1) = bar(h_axes(i), 1:length(AM.Data), AM.Data, WidthScaleFactor/3);
        hold(h_axes(i), 'off');

        set(h(i,1),'FaceColor',[0 .5 0]);
        set(h(i,1),'EdgeColor',[0 .5 0]);
    else
        h(i,1) = bar(h_axes(i), 1:length(AM.Data), AM.Data, WidthScaleFactor);
        set(h(i,1),'FaceColor',[0 0 .5]);
        set(h(i,1),'EdgeColor',[0 0 .5]);
        SP = AM;
    end
    
    %bar(1:length(AM.Data), [AM.Data SP.Data], 1, 'grouped');
        
    ylabel(sprintf('%s [%s]', FamilyNames{i}, AM.UnitsString));

    if i == 1
        if strcmpi(LatticeFlag,'Production')
            title(h_axes(i), sprintf('%s - Production Lattice', MemberOfField));
        elseif strcmpi(LatticeFlag,'Injection')
            title(h_axes(i), sprintf('%s - Injection Lattice', MemberOfField));
        else
            title(h_axes(i), sprintf('%s', MemberOfField));
        end
    end
           
    
    % Change the scale
    axis tight;

    ScaleFactor = .95;

    MaxY = max([AM.Data(:); SP.Data(:)]);
    MinY = min([AM.Data(:); SP.Data(:)]);

    if isnan(MinY) || isnan(MaxY)
        axis(h_axis, 'auto');
        set(h_axis, 'XLim', a(1:2));
    else
        % Add a buffer
        Delta = MaxY - MinY;
        if Delta == 0
            Delta = 1e-12; %eps;
        end
        MaxY = MaxY + (1-ScaleFactor) * Delta;
        MinY = MinY - (1-ScaleFactor) * Delta;
        %end
        set(h_axes(i), 'YLim', [MinY MaxY]);
    end
end


if ~NoSetpointFlag
    %addlabel(0,0,'   Blue=Monitor   GRN=Setpoint');
    h = addlabel(0,0,'   Monitor');
    set(h, 'Color', [0 .5 0]);
    h = addlabel(0,.025,'   Setpoint');
    set(h, 'Color', [0 0 .5]);
end
addlabel(1,0);


% Don't echo to the screen if no output exits (I think it's cleaner)
if nargout == 0
    clear h_axes h
end

