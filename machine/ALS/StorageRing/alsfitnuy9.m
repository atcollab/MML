function y = alsfitnuy9(x)
%  y = alsfitnuy9(x)
%
%  x definition:
%  x(1) - QF
%  x(2) - QFsb
%  x(3) - QD
%  x(4) - QDsb
%  x(5) - QFA
%  x(6) - QFAsb
%  x(7) - QDA
% 
%  y(1) - Horizontal Tune after 3 sectors is 14.25/4
%  y(2) - Horizontal Tune after 4 sectors is 14.25/3
%  y(3) - Vertical   Tune after 4 sectors is   9.2/3
%  y(4) - Horizontal Alpha at injection is zero
%  y(5) - Vertical   Alpha at injection is zero
%  y(6) - Horizontal Eta at injection .060 meters
%  y(7) - Horizontal Eta-prime at injection is zero
%
%  See also alslocofit, setlocodata

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the new model (if input) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if nargin < 1
%  x = [
%      getsp('QF', [1 1], 'Physics', 'Model');
%      getsp('QF', [4 1], 'Physics', 'Model');
%      getsp('QD', [1 1], 'Physics', 'Model');
%      getsp('QD', [4 1], 'Physics', 'Model');
%      getsp('QFA', [1 1], 'Physics', 'Model');
%      getsp('QFA', [4 1], 'Physics', 'Model');
%      getsp('QDA', [4 1], 'Physics', 'Model') ];
% end
if nargin >= 1
    setsp('QF', x(1), 'Physics', 'Model');
    setsp('QF', x(2), [4 1;4 2; 8 1;8 2; 12 1;12 2;], 'Physics', 'Model');

    setsp('QD', x(3), 'Physics', 'Model');
    setsp('QD', x(4), [4 1;4 2; 8 1;8 2; 12 1;12 2;], 'Physics', 'Model');

    setsp('QFA', x(5), 'Physics', 'Model');
    setsp('QFA', x(6), [4 1;4 2; 8 1;8 2; 12 1;12 2;], 'Physics', 'Model');

    setsp('QDA', x(7), 'Physics', 'Model');
end


%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Get the error function %
%%%%%%%%%%%%%%%%%%%%%%%%%%
global THERING

% Index at the center of straight 4 (3 sectors from injection)
IndexSect4 = family2atindex('SECT4'); 
[TD3, Tune3b] = twissring(THERING, 0, 1:IndexSect4, 'Chrom');
Tune3 = TD3(end).mu(:)/2/pi;

%     % Replace tune with Johan's method
%     m66 = findm66(THERING, 1:IndexSect4);
%     FracTune = getnusympmat(m66);
%     Tune3c = fix(Tune3) + FracTune;
 
    
% Index at the center of straight 5 (4 sectors from injection)
IndexSect5 = family2atindex('SECT5'); 
[TD4, Tune4b] = twissring(THERING, 0, 1:IndexSect5, 'Chrom');
Tune4 = TD4(end).mu(:)/2/pi;

%     % Replace tune with Johan's method
%     m66 = findm66(THERING, 1:IndexSect5);
%     FracTune = getnusympmat(m66);
%     Tune4c = fix(Tune4) + FracTune;

    
% Tune after 3 sectors (ALS: 14.25/4)
y(1,1) = Tune3(1);

% Tune after 4 sectors  (ALS: 14.25/3 and 9.2/3)
y(2,1) = Tune4(1);
y(3,1) = Tune4(2);

% Alpha x/y at injection (ALS: zero)
y(4,1) = TD4(1).alpha(1);
y(5,1) = TD4(1).alpha(2);

% Horizontal Eta at injection (ALS: .060 meters)
y(6,1) = TD4(1).Dispersion(1); 

% Horizontal Eta-prime at injection  (ALS: zero)
y(7,1) = TD4(1).Dispersion(2);



% % Tune after 3 sectors (ALS: 14.25/4)
% y(1,1) = Tune3(1) - fgoal(1);
% 
% % Tune after 4 sectors  (ALS: 14.25/3 and 9.2/3)
% y(2,1) = Tune4(1) - fgoal(2);
% y(3,1) = Tune4(2) - fgoal(3);
% 
% % Alpha x/y at injection (ALS: zero)
% y(4,1) = TD4(1).alpha(1) - fgoal(4);
% y(5,1) = TD4(1).alpha(2) - fgoal(5);
% 
% % Horizontal Eta at injection (ALS: .060 meters)
% y(6,1) = TD4(1).Dispersion(1) - fgoal(6); 
% 
% % Horizontal Eta-prime at injection  (ALS: zero)
% y(7,1) = TD4(1).Dispersion(2) - fgoal(7);

