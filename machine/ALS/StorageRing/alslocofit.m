function [x, y, ygoal, xtotal] = alslocofit(funfcn, x0, ygoal)
%ALSLOCOFIT - Gradient search method for fitting the ALS optics 
%  [x, y, ygoal, xtotal] = alslocofit(funfcn, x0, ygoal)
%
%  Default ygoal: 
%  ygoal(1) = 14.25/4;  Horizontal Tune after 3 sectors
%  ygoal(2) = 14.25/3;  Horizontal Tune after 4 sectors
%  ygoal(3) =  9.20/3;  Vertical   Tune after 4 sectors
%  ygoal(4) = 0;        Horizontal Alpha at injection is zero
%  ygoal(5) = 0;        Vertical   Alpha at injection is zero
%  ygoal(6) = 0.060;    Horizontal Eta at injection .060 meters
%  ygoal(7) = 0;        Horizontal Eta-prime at injection is zero
%
%  Note: this function is used in the ALS setup!
%
%  See also setlocodata, alsfitnuy9

%  Written by Greg Portmann


% Parameter delta for the gradiant calculation
Delta = .0001;


if nargin < 1
    funfcn = @alsfitnuy9;
end

if nargin < 2 || isempty(x0)
    x0 = [
        getsp('QF',  [1 1], 'Physics', 'Model');
        getsp('QF',  [4 1], 'Physics', 'Model');
        getsp('QD',  [1 1], 'Physics', 'Model');
        getsp('QD',  [4 1], 'Physics', 'Model');
        getsp('QFA', [1 1], 'Physics', 'Model');
        getsp('QFA', [4 1], 'Physics', 'Model');
        getsp('QDA', [4 1], 'Physics', 'Model') ];
end


%%%%%%%%%%%%%%%%
% Get the goal %
%%%%%%%%%%%%%%%%
if nargin < 3 || isempty(ygoal)
    % Tune after 3 sectors should be 14.25/4
    ygoal(1,1) = 14.25/4;

    % Tune after 4 sectors should be 14.25/3 and 9.2/3
    ygoal(2,1) = 14.25/3;
    ygoal(3,1) =  9.20/3;

    % Alpha x/y at injection is zero
    ygoal(4,1) = 0;
    ygoal(5,1) = 0;

    % Horizontal Eta at injection .060 meters
    ygoal(6,1) = .060;

    % Horizontal Eta-prime at injection is zero
    ygoal(7,1) = 0; 
end


%%%%%%%%%%%%%%%%%% 
% Starting point %
%%%%%%%%%%%%%%%%%%
y0 = funfcn(x0);

[tunefrac, tuneint] = modeltune;
Tune0 = tunefrac + tuneint;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the gradiate matrix %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = x0;
y = y0;
xtotal = [];
for iter = 1:6
    if 1
        % Compute the gradient matrix
        if iter == 1
            tic;
            fprintf('   Computing the gradient matrix ... ');
            for i = 1:length(x)
                Xnew = x;
                Xnew(i) = Xnew(i) + Delta * Xnew(i);
                ytmp = funfcn(Xnew);

                M(:,i) = (ytmp - y) / (Delta * Xnew(i));
            end
            fprintf('%f seconds\n\n',toc);
            
            % Reset the lattice
            funfcn(x);
        end
    else
        % Use an old one
        M = [
             1.9995    0.2312    0.2988    0.0402    1.0745   -0.0542    0.0031
             2.2201    0.7406    0.3364    0.1138    1.0242    0.3187    0.0493
            -1.4082   -0.4693   -1.9681   -0.6525   -0.5585   -0.1923   -0.0479
            -1.3972    1.3885   -0.2380    0.2418    0.3189   -0.3254    0.0188
            -6.3947    5.9128   -8.5015    7.7463   -1.7888    1.4925   -0.2447
            -0.5293    0.0702   -0.0801    0.0108    0.8770   -0.1091   -0.0227
             0.0255   -0.0256    0.0039   -0.0039   -0.0423    0.0396    0.0083 ];
    end


    % Find the solution
    %delx = pinv(M) * (ygoal - y);
    delxsq = inv(M) * (ygoal - y);
    x = x + delxsq;

    %[U,S,V] = svd(M, 'econ');
    %Ivec = 1:size(S,1)-1;
    %delx = V(:,Ivec) * diag(diag(S(Ivec,Ivec)).^(-1)) * U(:,Ivec)' * (ygoal - y);
    %x = x + delx;

    % Set the lattice to the solution    
    y = funfcn(x);
    [tunefrac, tuneint] = modeltune;
    Tune = tunefrac + tuneint;
    
    xtotal = [xtotal x];

    if iter == 1
    fprintf('       ------- Tune ------   ------------- Sector Tunes -------------  ---------- Alpha ----------       Eta         Eta Prime \n');
    fprintf('   #   Horizontal Vertical     Sector 3x     Sector 4x     Sector 4y     Horizontal     Vertical      Horizontal     Horizontal\n');
    fprintf('   0.  %9.6f %9.6f  %13.5e %13.5e %13.5e  %13.5e %13.5e  %13.5e  %13.5e\n', Tune0(1), Tune0(2), y0(1), y0(2), y0(3), y0(4), y0(5), y0(6), y0(7));
    end
    fprintf('%4d.  %9.6f %9.6f  %13.5e %13.5e %13.5e  %13.5e %13.5e  %13.5e  %13.5e\n', iter, Tune(1), Tune(2), y(1), y(2), y(3), y(4), y(5), y(6), y(7));
end

fprintf('\n');
fprintf('                     Goal:  %13.5e %13.5e %13.5e  %13.5e %13.5e  %13.5e  %13.5e\n', ygoal(1), ygoal(2), ygoal(3), ygoal(4), ygoal(5), ygoal(6), ygoal(7));
fprintf('                    Error:  %13.5e %13.5e %13.5e  %13.5e %13.5e  %13.5e  %13.5e\n', ygoal(1)-y(1), ygoal(2)-y(2), ygoal(3)-y(3), ygoal(4)-y(4), ygoal(5)-y(5), ygoal(6)-y(6), ygoal(7)-y(7));
fprintf('\n');



