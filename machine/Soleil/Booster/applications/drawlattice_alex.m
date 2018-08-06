function drawlattice(Offset, Scaling)
%DRAWLATTICE - Draws the AT lattice to a figure
%  drawlattice(Offset, Scaling)

%
%  Written by Gregory J. Portmann
%  Modified by Laurent S. Nadolski, SOLEIL, 03/09/04

if nargin < 1
    Offset = 0;
end
Offset = Offset(1);
if nargin < 2
    Scaling = 1;
end
Scaling = Scaling(1);

global THERING

SPositions = findspos(THERING, 1:length(THERING)+1);
L = SPositions(end);
plot([0 L], [0 0]+Offset, 'k');

% Remember the hold state then turn hold on
HoldState = ishold;
hold on;

% Make default icons for elements of different physical types
for i = 1:length(THERING)
    SPos = SPositions(i);
    if isfield(THERING{i},'BendingAngle') && THERING{i}.BendingAngle
        % make icons for bending magnets
        IconHeight = .3;
        IconColor = [1 0 0];
        IconWidth = THERING{i}.Length;
        if IconWidth < .15 % meters
            IconWidth = .15;
            SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
        end
        vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
        vy = [IconHeight IconHeight -IconHeight -IconHeight];
        h = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-');
        %if IconWidth < .1 % meters
        %    set(h, 'EdgeColor', IconColor);
        %end

    elseif isfield(THERING{i},'K') & THERING{i}.K
        % Quadrupole
        if THERING{i}.K > 0
            % Focusing quadrupole
            IconHeight = .6;
            IconColor = [0 0 1];
            IconWidth = THERING{i}.Length;
            if IconWidth < .15 % meters
                IconWidth = .15;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            vx = [SPos SPos+IconWidth/2  SPos+IconWidth SPos+IconWidth/2 SPos];
            vy = [0          IconHeight               0      -IconHeight    0];
        else
            % Defocusing quadrupole
            IconHeight = .6;
            IconColor = [0 0 1];
            IconWidth = THERING{i}.Length;
            if IconWidth < .15 % meters
                IconWidth = .15;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            vx = [SPos+.4*IconWidth    SPos    SPos+IconWidth  SPos+.6*IconWidth  SPos+IconWidth    SPos      SPos+.4*IconWidth];
            vy = [     0            IconHeight   IconHeight          0              -IconHeight  -IconHeight    0];
        end
        h = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-');
        %if IconWidth < .1 % meters
        %    set(h, 'EdgeColor', IconColor);
        %end

%     elseif isfield(THERING{i},'PolynomB') & length(THERING{i}.PolynomB)>2 & THERING{i}.PolynomB(3)
%         % Sextupole
%         if THERING{i}.PolynomB(3)>0
%             % Focusing sextupole
%             IconHeight = .5;
%             IconColor = [1 0 1];
%             IconWidth = THERING{i}.Length;
%             if IconWidth < .1 % meters
%                 IconWidth = .1;
%                 SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
%             end
%             vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
%             vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
%         else
%             % Defocusing sextupole
%             IconHeight = .5;
%             IconColor = [0 1 0];
%             IconWidth = THERING{i}.Length;
%             if IconWidth < .1 % meters
%                 IconWidth = .1;
%                 SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
%             end
%             vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
%             vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
%         end
%         h = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-');
%         %if IconWidth < .1 % meters
%         %    set(h, 'EdgeColor', IconColor);
%         %end
% 
%     elseif isfield(THERING{i},'Frequency') & isfield(THERING{i},'Voltage')
%         % RF cavity
%         IconColor = [1 0.5 0];
%         plot(SPos, 0+Offset, 'o', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 4)
% 
%     elseif strcmpi(THERING{i}.FamName,'BPM')
%         % BPM
%         IconColor = 'k';
%         plot(SPos, 0+Offset, '.-', 'Color', IconColor)
%         %plot(SPos, 0, 'o', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 1.5)
% 
%     elseif any(strcmpi(THERING{i}.FamName,{'COR','XCOR','YCOR','HCOR','VCOR'})) | isfield(THERING{i},'KickAngle')
%         % Corrector
%         IconHeight = .8;
%         IconColor = [0 0 0];
%         vx = [SPos   SPos];
%         vy = [-IconHeight IconHeight];
%         %plot(vx, Scaling*vy+Offset, 'Color', IconColor);
%         IconWidth = THERING{i}.Length;
%         vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
%         vy = [IconHeight IconHeight -IconHeight -IconHeight];
%         h = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle', '-');
%         if IconWidth < .1 % meters
%             set(h, 'EdgeColor', IconColor);
%         end
      end
end


% Leave the hold state as it was at the start
if ~HoldState
    hold off
end
xaxis([0 L]);XTick=[];
yaxis([-3 3]);
