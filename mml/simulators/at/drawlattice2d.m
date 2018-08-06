function h = drawlattice2d(Offset, Scaling, hAxes, Ldraw)
%DRAWLATTICE2D - Draws the AT lattice to a figure
%  h = drawlattice2d(Offset {0}, Scaling {1}, hAxes {gca}, Ldraw)
%
%  h - handle to each element drawn
%
%  Programmers Notes
%  1. The AT index is stored in the Userdata of each symbol.
%     get(h(i),'Userdata')
%  2. To set a callback on an element use:
%     set(h(i),'ButtonDownFcn', FunctionName);
%  3. To set a context menu (right mouse menu) on an element use:
%     hcmenu = uicontextmenu;
%     set(h(i),'UIContextMenu', hcmenu);
%     cb = 'locogui(''ContextMenuPlot_Callback'',gcbo,[],[])';
%     h1 = uimenu(hcmenu, 'Label', 'Run #1', 'Callback', 'disp(''Run #1'');');
%     h2 = uimenu(hcmenu, 'Label', 'Run #2', 'Callback', 'disp(''Run #2'');');
%     h3 = uimenu(hcmenu, 'Label', 'Run #3', 'Callback', 'disp(''Run #3'');');
%
%  See also drawlattice

%  Written by Greg Portmann


global THERING

if nargin < 1
    Offset = 0;
end
Offset = Offset(1);
if nargin < 2
    Scaling = 1;
end
Scaling = Scaling(1);

if nargin < 3
    hAxes = gca;
end

StartAngle = 0;
[x2d, y2d, a2d] = Survey2D(THERING, StartAngle);

SPositions = findspos(THERING, 1:length(THERING)+1);
L = SPositions(end);

if nargin < 4
    Ldraw = L;
end

plot(hAxes, x2d, y2d, 'k');

% Remember the hold state then turn hold on
HoldState = ishold(hAxes);
hold(hAxes, 'on');

try
    ATIndexHCM = family2atindex(gethcmfamily);
catch
    ATIndexHCM = [];
end

try
    ATIndexVCM = family2atindex(getvcmfamily);
catch
    ATIndexVCM = [];
end



% Make default icons for elements of different physical types
h = [];
for i = 1:length(THERING)
    % Minimum icon width in meters (also in drawquadrupolelocal)
    MinIconWidth = .01;
    
    NumberOfFinds = 0;

    SPos = SPositions(i);

    if SPos > Ldraw
        break
    end

    %             case 'rectangle'
    %                 % compute vertex coordinates
    %                 IconWidth = Families(FamIndex).IconWidth;
    %                 vx = [ x2d(i), x2d(i+1), x2d(i+1), x2d(i)] + IconWidth*xcorners*sin((a2d(i)+a2d(i+1))/2);
    %                 vy = [ y2d(i), y2d(i+1), y2d(i+1), y2d(i)] + IconWidth*ycorners*cos((a2d(i)+a2d(i+1))/2);
    %                 Elements(i).IconHandle = patch(vx,vy,Families(FamIndex).Color);
    %             case 'line'
    %                 Elements(i).IconHandle = line([x2d(i) x2d(i+1)],[y2d(i) y2d(i+1)]);
    %                 set(Elements(i).IconHandle,'Color',Families(FamIndex).Color);
    %             case 'o'
    %                 Elements(i).IconHandle = line([x2d(i) x2d(i+1)],[y2d(i) y2d(i+1)]);
    %                 set(Elements(i).IconHandle,'Color',Families(FamIndex).Color,...
    %                     'Marker','o','MarkerFaceColor',Families(FamIndex).Color);


    %if (isfield(THERING{i},'BendingAngle') && THERING{i}.BendingAngle) || strcmpi(THERING{i}.FamName,'BEND')
    if isfield(THERING{i},'BendingAngle') || any(strcmpi(THERING{i}.FamName,{'BEND','Kicker'})) 
        % make icons for bending magnets
        NumberOfFinds = NumberOfFinds + 1;
        if strcmpi(THERING{i}.FamName,'Kicker')
            IconHeight = .5;
            IconColor = [.5 0 .5];
        else
            IconHeight = .3;
            IconColor = [1 1 0];
        end
        IconWidth = THERING{i}.Length;
        if IconWidth < MinIconWidth    % meters
            IconWidth = MinIconWidth;
            SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
        end
        %xcorners = [-1 -1  1  1];
        %ycorners = [ 1  1 -1 -1];
        %vx = [ x2d(i), x2d(i+1), x2d(i+1), x2d(i)] + IconWidth*xcorners*sin((a2d(i)+a2d(i+1))/2);
        %vy = [ y2d(i), y2d(i+1), y2d(i+1), y2d(i)] + IconWidth*ycorners*cos((a2d(i)+a2d(i+1))/2);
        %vx = [ x2d(i)] + [SPos SPos+IconWidth SPos+IconWidth SPos]*sin((a2d(i)+a2d(i+1))/2);
        %vy = [ y2d(i)] + [IconHeight IconHeight -IconHeight -IconHeight]*cos((a2d(i)+a2d(i+1))/2);

        theta = (a2d(i)+a2d(i+1))/2;
        SPos = 0; %-IconWidth/2;
        x = [SPos SPos+IconWidth SPos+IconWidth SPos] ;
        y = [IconHeight IconHeight -IconHeight -IconHeight];
        vx = x2d(i) + x*cos(theta) - y*sin(theta);
        vy = y2d(i) + x*sin(theta) + y*cos(theta);

        %vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
        %vy = [IconHeight IconHeight -IconHeight -IconHeight];
        h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);
        set(h(end), 'UserData', i);

        %if IconWidth < .1 % meters
        %    set(h(end), 'EdgeColor', IconColor);
        %end
        set(h(end), 'EdgeColor', IconColor);

    elseif isfield(THERING{i},'K') %&& THERING{i}.K
        % Quadrupole
        NumberOfFinds = NumberOfFinds + 1;
        if THERING{i}.K == 0
            % Is it a skew quad?
            %if THERING{i}.PolynomA(2) ~= 0
                h(length(h)+1) = drawquadrupole_local(hAxes, 'SkeqQuad', x2d(i), y2d(i), a2d(i), SPos, THERING{i}.Length, Offset, Scaling);
            %else
                % Call it a QF
                %h(length(h)+1) = drawquadrupole_local(hAxes, 'QF', x2d(i), y2d(i), a2d(i), SPos, THERING{i}.Length, Offset, Scaling);
            %end
        elseif THERING{i}.K >= 0
            h(length(h)+1) = drawquadrupole_local(hAxes, 'QF', x2d(i), y2d(i), a2d(i), SPos, THERING{i}.Length, Offset, Scaling);
        else
            h(length(h)+1) = drawquadrupole_local(hAxes, 'QD', x2d(i), y2d(i), a2d(i), SPos, THERING{i}.Length, Offset, Scaling);
        end
        set(h(end), 'UserData', i);

    elseif isfield(THERING{i},'M66') && any(strcmpi(THERING{i}.FamName,{'QUAD','Q','QF','QD'}))
        % Quadrupole
        NumberOfFinds = NumberOfFinds + 1;
        if THERING{i}.M66(1,1) <= 0
            h(length(h)+1) = drawquadrupole_local(hAxes, 'QF', x2d(i), y2d(i), a2d(i), SPos, THERING{i}.Length, Offset, Scaling);
        else
            h(length(h)+1) = drawquadrupole_local(hAxes, 'QD', x2d(i), y2d(i), a2d(i), SPos, THERING{i}.Length, Offset, Scaling);
        end
        set(h(end), 'UserData', i);

    elseif isfield(THERING{i},'PolynomB') && length(THERING{i}.PolynomB)>2 && (THERING{i}.PolynomB(3) || any(strcmpi(THERING{i}.FamName,{'SF','SFF','SD','SDD','HSF','HSD'})))
        % Sextupole
        NumberOfFinds = NumberOfFinds + 1;
        if THERING{i}.PolynomB(3)>0 || any(strcmpi(THERING{i}.FamName,{'SF','SFF','HSF'}))
            % Focusing sextupole
            IconHeight = .7;
            IconColor = [1 0 1];
            IconWidth = THERING{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            SPos = 0;
            x = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            y = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        else
            % Defocusing sextupole
            IconHeight = .7;
            IconColor = [0 1 0];
            IconWidth = THERING{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            SPos = 0;
            x = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            y = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        end
        vx = x2d(i) + x*cos(a2d(i)) - y*sin(a2d(i));
        vy = y2d(i) + x*sin(a2d(i)) + y*cos(a2d(i));
        h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);
        set(h(end), 'UserData', i);
        %if IconWidth < .1 % meters
        %    set(h(end), 'EdgeColor', IconColor);
        %end
        set(h(end), 'EdgeColor', IconColor);

    elseif isfield(THERING{i},'PolynomB') && length(THERING{i}.PolynomB)>3 && (THERING{i}.PolynomB(4) || any(strcmpi(THERING{i}.FamName,{'Octupole','OCTU'})))
        % Octupole
        NumberOfFinds = NumberOfFinds + 1;
        if THERING{i}.PolynomB(3)>0 || any(strcmpi(THERING{i}.FamName,{'SF','SFF','HSF'}))
            % Focusing sextupole
            IconHeight = .6;
            IconColor = [0 .5 .5];
            IconWidth = THERING{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            SPos = 0;
            x = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            y = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        else
            % Defocusing sextupole
            IconHeight = .6;
            IconColor = [.5 .5 0];
            IconWidth = THERING{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            SPos = 0;
            x = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            y = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        end
        vx = x2d(i) + x*cos(a2d(i)) - y*sin(a2d(i));
        vy = y2d(i) + x*sin(a2d(i)) + y*cos(a2d(i));
        h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);
        set(h(end), 'UserData', i);
        %if IconWidth < .1 % meters
        %    set(h(end), 'EdgeColor', IconColor);
        %end
        set(h(end), 'EdgeColor', IconColor);

    elseif (isfield(THERING{i},'Frequency') && isfield(THERING{i},'Voltage')) || any(strcmpi(THERING{i}.FamName,{'Cavity','RFCavity'}))
        % RF cavity
        NumberOfFinds = NumberOfFinds + 1;
        IconColor = [1 0.5 0];
        if THERING{i}.Length == 0
            h(length(h)+1) = plot(hAxes, x2d(i), y2d(i)+Offset, 'o', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 4);
        else
            IconHeight = .15;
            IconWidth = THERING{i}.Length;
            x = [0 IconWidth IconWidth 0];
            y = [IconHeight IconHeight -IconHeight -IconHeight];
            vx = x2d(i) + x*cos(a2d(i)) - y*sin(a2d(i));
            vy = y2d(i) + x*sin(a2d(i)) + y*cos(a2d(i));
            h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);
            set(h(end), 'EdgeColor', IconColor);
        end
        set(h(end), 'UserData', i);

    elseif strcmpi(THERING{i}.FamName,'BPM')
        % BPM
        NumberOfFinds = NumberOfFinds + 1;
        IconColor = 'k';
        h(length(h)+1) = plot(hAxes, x2d(i), y2d(i)+Offset, '.', 'Color', IconColor);
        %h(length(h)+1) = plot(hAxes, x2d(i), y2d(i)+Offset, 'o', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 1.5)
        set(h(end), 'UserData', i);

    elseif strcmpi(THERING{i}.FamName,'TV')
        % TV screen
        NumberOfFinds = NumberOfFinds + 1;
        
        IconHeight = .1;
        IconColor = [.5 0 0];
        IconWidth = .15;
        x = [0 IconWidth IconWidth 0] ;
        y = [IconHeight IconHeight -IconHeight -IconHeight] + .7;
        vx = x2d(i) + x*cos(a2d(i)) - y*sin(a2d(i));
        vy = y2d(i) + x*sin(a2d(i)) + y*cos(a2d(i));
        h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);


        %         IconHeight = .7;
        %         IconColor = [.5 0 0];  %'k';
        %
        %         x = 0;
        %         y = Offset+IconHeight;
        %         vx = x2d(i) + x*cos(a2d(i)) - y*sin(a2d(i));
        %         vy = y2d(i) + x*sin(a2d(i)) + y*cos(a2d(i));
        %
        %         %h(length(h)+1) = plot(hAxes, vx, vy, 'x', 'Color', IconColor);
        %         %h(length(h)+1) = plot(hAxes, vx, vy, 'Marker','Square', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 3.5);
        %         h(length(h)+1) = plot(hAxes, vx, vy, 'Marker','o', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 3.5);

        set(h(end), 'UserData', i);
    end

    % Since correctors could be a combined function magnet, test separately
    if any(strcmpi(THERING{i}.FamName,{'COR','XCOR','YCOR','HCOR','VCOR'})) || isfield(THERING{i},'KickAngle')
        % Corrector
        NumberOfFinds = NumberOfFinds + 1;

        MinIconWidth = .01/3.5;

        if NumberOfFinds > 1
            IconWidth = 0;
        else
            IconWidth = THERING{i}.Length;
        end
        IconHeight = 1.1;  % was .8
        vx = [SPos   SPos];

        % Draw a line above for a HCM and below for a VCM
        % If it's not in the ML, then draw a line above and below
        CMFound = 1;
        if any(i == ATIndexVCM)
            IconColor = [0 0 0];
            vy = [-IconHeight 0];
            if IconWidth <= MinIconWidth
                IconWidth = MinIconWidth;
            else
                IconWidth = THERING{i}.Length;
            end
            x = [0 IconWidth IconWidth 0];
            y = [0 0 -IconHeight -IconHeight];
            %y = [IconHeight IconHeight -IconHeight -IconHeight];
            vx = x2d(i) + x*cos(a2d(i)) - y*sin(a2d(i));
            vy = y2d(i) + x*sin(a2d(i)) + y*cos(a2d(i));
            h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor, 'LineStyle', '-', 'Parent',hAxes);
            if IconWidth < MinIconWidth*2 % meters
                set(h(end), 'EdgeColor', IconColor);
            end
            set(h(end), 'UserData', i);
            CMFound = 0;
        end

        if any(i == ATIndexHCM)
            IconColor = [0 0 0];
            vy = [0 IconHeight];
            if IconWidth <= MinIconWidth
                IconWidth = MinIconWidth;
            else
                IconWidth = THERING{i}.Length;
            end
            x = [0 IconWidth IconWidth 0];
            y = [IconHeight IconHeight 0 0];
            %y = [IconHeight IconHeight -IconHeight -IconHeight];
            vx = x2d(i) + x*cos(a2d(i)) - y*sin(a2d(i));
            vy = y2d(i) + x*sin(a2d(i)) + y*cos(a2d(i));

            h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor, 'LineStyle', '-', 'Parent',hAxes);
            if IconWidth < MinIconWidth*2 % meters
                set(h(end), 'EdgeColor', IconColor);
            end
            set(h(end), 'UserData', i);
            CMFound = 0;
        end

        if CMFound
            IconColor = [0 0 0];
            vy = [-IconHeight IconHeight];
            if IconWidth <= MinIconWidth
                IconWidth = MinIconWidth;
            else
                IconWidth = THERING{i}.Length;
            end
            IconWidth = THERING{i}.Length;
            x = [0 IconWidth IconWidth 0];
            y = [IconHeight IconHeight -IconHeight -IconHeight];

            vx = x2d(i) + x*cos(a2d(i)) - y*sin(a2d(i));
            vy = y2d(i) + x*sin(a2d(i)) + y*cos(a2d(i));

            h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor, 'LineStyle', '-', 'Parent',hAxes);
            if IconWidth < MinIconWidth*2 % meters
                set(h(end), 'EdgeColor', IconColor);
            end
            set(h(end), 'UserData', i);
            CMFound = 0;
        end
    end
end


%plot(hAxes, x2d, y2d, 'k');


% Leave the hold state as it was at the start
if ~HoldState
    hold(hAxes, 'off');
end

% a = axis(hAxes);
% axis(hAxes, [0 L a(3:4)]);



function h = drawquadrupole_local(hAxes, QuadType, x2d, y2d, a2d, SPos, L, Offset, Scaling)

% Minimum icon width in meters
MinIconWidth = .01;

theta = a2d;
SPos = 0; %-IconWidth/2;

if strcmpi(QuadType, 'SkewQuad')
    % Focusing quadrupole
    IconHeight = .55;
    IconColor = [1 0 0];
    IconWidth = L;
    if IconWidth < MinIconWidth % meters
        IconWidth = MinIconWidth;
        SPos = SPos - IconWidth/2 + L/2;
    end
    vx = [SPos SPos+IconWidth/2  SPos+IconWidth SPos+IconWidth/2 SPos];
    vy = [0          IconHeight               0      -IconHeight    0];
elseif strcmpi(QuadType, 'QF')
    % Focusing quadrupole
    IconHeight = .8;
    IconColor = [1 0 0];
    IconWidth = L;
    if IconWidth < MinIconWidth % meters
        IconWidth = MinIconWidth;
        SPos = SPos - IconWidth/2 + L/2;
    end
    x = [SPos SPos+IconWidth/2  SPos+IconWidth SPos+IconWidth/2 SPos];
    y = [0          IconHeight               0      -IconHeight    0];
else
    % Defocusing quadrupole
    IconHeight = .7;
    IconColor = [0 0 1];
    IconWidth = L;
    if IconWidth < MinIconWidth % meters
        % Center about starting point
        IconWidth = MinIconWidth;
        SPos = SPos - IconWidth/2 + L/2;
    end
    x = [SPos+.4*IconWidth    SPos    SPos+IconWidth  SPos+.6*IconWidth  SPos+IconWidth    SPos      SPos+.4*IconWidth];
    y = [     0            IconHeight   IconHeight          0              -IconHeight  -IconHeight    0];
end

vx = x2d + x*cos(theta) - y*sin(theta);
vy = y2d + x*sin(theta) + y*cos(theta);
h = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);
set(h, 'EdgeColor', IconColor);





% --------------------------------------------------------------------
function [x2d, y2d, a2d] = Survey2D(LATTICE,STARTANGLE)
% Determine 2-d geometry of the LATTICE
NumElements = length(LATTICE);
x2d = zeros(1,NumElements+1);
y2d = zeros(1,NumElements+1);
a2d = zeros(1,NumElements+1); % angle of orbit in radians
a2d(1) = STARTANGLE;
for en = 1:NumElements-1
    if isfield(LATTICE{en},'BendingAngle')
        ba = LATTICE{en}.BendingAngle; % bending angle in radians
    else
        ba = 0;
    end

    if ba == 0
        Lt = LATTICE{en}.Length;
        Lp = 0;
    else
        Lt = LATTICE{en}.Length*sin(ba)/ba;
        Lp = -LATTICE{en}.Length*(1-cos(ba))/ba;
    end

    x2d(en+1) = x2d(en) + Lt*cos(a2d(en)) - Lp*sin(a2d(en));
    y2d(en+1) = y2d(en) + Lt*sin(a2d(en)) + Lp*cos(a2d(en));
    a2d(en+1)=a2d(en) - ba;

end

if 0
    % Close the circle
    x2d(NumElements+1) = x2d(1);
    y2d(NumElements+1) = y2d(1);
    a2d(NumElements+1) = a2d(1);
else
    x2d(NumElements+1) = [];
    y2d(NumElements+1) = [];
    a2d(NumElements+1) = [];
end

X0 = (max(x2d)+min(x2d))/2;
Y0 = (max(y2d)+min(y2d))/2;
x2d = x2d - X0;
y2d = y2d - Y0;
