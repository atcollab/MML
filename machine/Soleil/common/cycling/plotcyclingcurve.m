function plotcyclecurve(curve)
%
%  INPUTS
%  1. curve - n x 2 array amplitude versus time loaded in Cycling Dserver
%             or a cell array see getcyclecurve for details
%
%  EXAMPLES
%  1. plotcyclingcurve(getcyclecurve('LT1/AE/cycleQ.1'))
%  2. plotcyclingcurve(getcyclecurve('CycleQP'))
%
% See also setcyclecurve, getcyclecurve

%
% Written by Laurent S. Nadolski


if iscell(curve)
    for k=1:length(curve),
        n = size(curve{k}.Data,1);
        % time vector
        cums = cumsum(curve{k}.Data(:,2))';
        x = [cums; cums];
        x = reshape(x,1,2*n);
        x = [0 x(1:end-1)];

        % amplitude vector
        y = [curve{k}.Data(:,1),curve{k}.Data(:,1)]';
        y = reshape(y,1,2*n);

        figure;
        plot(x,y,'b.-');
        xlabel('Temps (s)');
        ylabel('Courant [A]');
        ylim([min(y) max(y)*1.05]);
        title(['Cycling curve for ' curve{k}.DeviceName]);
        grid on
    end
else
    n = size(curve,1);
    % time vector
    cums = cumsum(curve(:,2))';
    x = [cums; cums];
    x = reshape(x,1,2*n);
    x = [0 x(1:end-1)];

    % amplitude vector
    y = [curve(:,1),curve(:,1)]';
    y = reshape(y,1,2*n);

    figure;
    plot(x,y,'b.-');
    xlabel('Temps (s)');
    ylabel('Courant [A]');
    ylim([min(y) max(y)*1.05]);
    title('courbe de cyclage');

    grid on
end