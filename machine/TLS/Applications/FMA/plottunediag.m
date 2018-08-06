function varargout = plottunediag(varargin)

% PLOTTUNEDIAG(order, superperiodicity, [x0 x1 y0 y1], [x y], '-nospawn').
% Where 'order' is the order of the resonance lines to be drawn, the
% superperiodicity of the lattice and a vector containing the points to
% plot on the diagram. Eg if you want to plot [x1 y1] and [x2 y2] then
% call, tuneplots(3,1,[x1 x2 y1 y2]). The last vector [x0 x1 y0 y1]
% indicates the range through which you want to view.
%
% Eugene Tan 25/08/03
% Eugene Tan 07/01/04 - Added some comments and made minor changes to the
%                     implementation.
%                     - Fixed bug: did not handle unequal integer ranges
%                     eg. [0 3 0 5]. Before could only handle [0 3 0 3] and
%                     [2 3 5 6]. Changed definition of 'linex' and 'liney'.
% Eugene Tan 03/05/04 - Minor change to implementation.
% Eugene Tan 10/06/04 - saves the lines plotted and returns is as
%                     varargout{2}

% Define some default values if no parameters are placed.

% Add points on the tune diagram.
if nargin < 4
    x = [13.3];
    y = [5.2];
else
    x = varargin{4}(1:end/2);
    y = varargin{4}(end/2 + 1:end);
end
% Define the N-fold periodicity of the ring
if nargin < 2
    N = 14;    % Superperiod
else
    N = varargin{2};
end
% Define the plotting window
if nargin < 3    
    x0 = 0;
    x1 = N;
    y0 = 0;
    y1 = N;
else
    x0 = varargin{3}(1);
    x1 = varargin{3}(2);
    y0 = varargin{3}(3);
    y1 = varargin{3}(4);
end  
% The resonance order to which this program will plot
if nargin < 1
    order = 3;
else
    order = varargin{1};
end
  

if nargin == 5 & strcmpi(varargin{5},'-nospawn')
    fig = gcf;
else
    fig = figure;
end
axis([x0 x1 y0 y1]);
hold on

dd = 2;
linex = floor(x0)-dd:((ceil(x1)+dd)-(floor(x0)-dd))/2:ceil(x1)+dd;
liney = floor(y0)-dd:((ceil(y1)+dd)-(floor(y0)-dd))/2:ceil(y1)+dd;
nux = linex;

a = 0;
b = 0;

for m=1:order
    % Define the different linestyles for the different resonance lines
    % plotted. Blue lines are for Difference resonance and Red lines are
    % for Sum resonances.
    switch m
        case 1
            blines='b-';
            rlines='r-';
        case 2
            blines='b--';
            rlines='r--';
        case 3
            blines='b-.';
            rlines='r-.';
        otherwise
            blines='b:';
            rlines='r:';
    end
    
    for i=0:m
        a = m - i;
        b = i;
        
        %         if mod(b,2) == 1
        %             continue
        %         end
        
        if b ~= 0
            
            % Sum resonance
            tmp = (a*linex + b*liney)/N;
            cmax = ceil(max(tmp))+10;
            cmin = floor(min(tmp))-10;
            for c=cmin:cmax
                nuy = (c*N - a*nux)/b;
                % If all points of nuy are within the range then plot it
                if ~isempty(find(nuy > y0)) & ~isempty(find(nuy < y1))
                    h = plot(nux, nuy,rlines);
                    set(h,'UserData',sprintf('%dnux + %dnuy = %d*14',a,b,c));
                end
            end
%             for c=-cmax:-cmin
%                 nuy = (-c*N - a*nux)/b;
%                 % If all points of nuy are within the range then plot it
%                 if ~isempty(find(nuy > y0)) & ~isempty(find(nuy < y1))
%                     plot(nux, nuy,rlines);
%                 end
%             end
            
            % Difference Lines
            tmp = (a*linex - b*liney)/N;
            cmax = ceil(max(tmp))+10;
            cmin = floor(min(tmp))-10;
            for c=cmin:cmax
                nuy = (a*nux - c*N)/b;
                % If all points of nuy are within the range then plot it
                if ~isempty(find(nuy > y0)) & ~isempty(find(nuy < y1))
                    h = plot(nux, nuy,blines);
                    set(h,'UserData',sprintf('%dnux - %dnuy = %d*14',a,b,c));
                end
            end
%             for c=-cmax:-cmin
%                 nuy = (a*nux + c*N)/b;
%                 % If all points of nuy are within the range then plot it
%                 if ~isempty(find(nuy > y0)) & ~isempty(find(nuy < y1))
%                     plot(nux, nuy,blines);
%                 end
%             end
            
        else
            %             tmp = (a*linex)/N;
%             cmax = ceil(max(tmp))+2;
%             cmin = floor(min(tmp))-2;
            cmin = floor(floor(x0)*a/N)-2*a*N;
            cmax = floor(ceil(x1)*a/N)+2*a*N;
            for c=cmin:cmax
                if c*N/a > x0 & c*N/a < x1
                    tmp = repmat(c*N/a,1,length(liney));
                    h = plot(tmp, liney,rlines);
                    set(h,'UserData',sprintf('%dnux + %dnuy = %d*14',a,b,c));
                end
            end
            
        end          
    end
end

% Plot points on the diagram.
plot(x, y, 'b.-', 'MarkerSize', 20);

% Half integer lines
halfx = floor(x0)-0.5:x1;
halfy = floor(y0)-0.5:y1;
% The two need to be separated in the event that the length of halfx and
% halfy are different. eg when the window is [0 3 0 6].
for i = 1:length(halfx)
    plot([halfx(i) halfx(i)], [liney(1) liney(end)], 'b-');
end
for i = 1:length(halfy)
    plot([linex(1) linex(end)], [halfy(i) halfy(i)], 'b-');
end
    
% Integer lines
halfx = floor(x0)-1:x1;
halfy = floor(y0)-1:y1;
% The two need to be separated in the event that the length of halfx and
% halfy are different. eg when the window is [0 3 0 6].
for i = 1:length(halfx)
    plot([halfx(i) halfx(i)], [liney(1) liney(end)], 'b-', 'LineWidth', 1.5);
end
for i = 1:length(halfy)
    plot([linex(1) linex(end)], [halfy(i) halfy(i)], 'b-', 'LineWidth', 1.5);
end

switch order
    case 1
        suffix = 'st';
    case 2
        suffix = 'nd';
    case 3
        suffix = 'rd';
    otherwise
        suffix = 'th';
end
title(sprintf('Resonance Diagram (up to %d%s order lines shown with %d-fold symmetry)'...
    ,order, suffix, N));
xlabel('\nu_x');
ylabel('\nu_y');

hold off

if nargout == 1
    varargout{1} = fig;
end
