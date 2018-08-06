
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALS Universe: Dominate Sort %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pick the fields to sort on
%UFields = {'SigmaXStraight','SigmaXB2'};
%UFields = {'SigmaXStraight','SigmaXB2','BetaYStraight'};

%UFields = {'SigmaXStraight','SigmaXB2','BetaYStraight','QF'};
%UBound  = {      300,           400,        10,         4};

%UFields = {'SigmaXStraight','SigmaXB2','BetaYStraight','QF','QD'};
%%UBound = {       300,          400,          10,        2.5, 2.8};
%UBound = {       300,          400,          10,        2.4, 2.7};

UFields = {'SigmaXStraight','SigmaXB2','BetaYStraight','BetaYB2','QF','QD'};
UBound = {       300,          400,          10,          10,    2.4, 2.7};


%%%%%%%%%%%%%%%%%%%%%%
% Load Weishi's Data %
%%%%%%%%%%%%%%%%%%%%%%

% Total set
U = getuniverse;
U.Index = (1:length(U.QF))';

% Chop it down some before starting dominate sort
%[U, iSort] = sortuniverse({'SigmaXStraight','SigmaXB1','SigmaXB2','BetaYStraight'}, {300,400,300,10}, U);
[U, iSort] = sortuniverse(UFields, UBound, U);


% Dominate sort 
[UPareto, iPareto, ParetoPopulation] = sortuniversedominant(UFields, U);

if size(ParetoPopulation, 1) < 40
    format long
    ParetoPopulation
    format short
end


if length(UFields) == 2
    figure(1);
    clf reset
    k = find(U.SigmaXStraight< 300 & U.SigmaXB2< 300); 
    plot(U.(UFields{1})(k), U.(UFields{2})(k), '.r');
    hold on;
    plot(UPareto.(UFields{1}), UPareto.(UFields{2}), 'squareb', 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',6);
    hold off;
    xlabel(UFields{1});
    ylabel(UFields{2});
    title('Pareto Optimum');
    %axis([0 200 0 200]);
    
    figure(2);
    clf reset
    plot(UPareto.(UFields{1}), UPareto.(UFields{2}), 'squareb', 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',4);
    xlabel(UFields{1});
    ylabel(UFields{2});
    title('Pareto Optimum');

elseif length(UFields) >= 3
    figure(1);
    clf reset
    %k = find(U.SigmaXStraight< 60 & U.SigmaXB1< 60 & U.SigmaXB2< 60); 
    %plot3(U.SigmaXStraight(k), U.SigmaXB1(k), U.SigmaXB2(k),'.r');
    %hold on;
    %plot3(U.SigmaXStraight(iParetoVector), U.SigmaXB1(iParetoVector), U.SigmaXB2(iParetoVector),'squareb','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);
    %k = find(U.SigmaXStraight< 200 & U.SigmaXB2< 300); 
    %plot3(U.(UFields{1})(k), U.(UFields{2})(k), U.(UFields{3})(k),'.r');
    plot3(U.(UFields{1}), U.(UFields{2}), U.(UFields{3}),'.r');
    hold on;
    plot3(UPareto.(UFields{1}), UPareto.(UFields{2}), UPareto.(UFields{3}),'squareb','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',4);
    hold off
    xlabel(UFields{1});
    ylabel(UFields{2});
    zlabel(UFields{3});
    title('Pareto Optimum');
    view(-57,84);
else
    fprintf('   No plot for %d fields\n', length(UFields));
end





%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load into the AT Model %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% switch to simulate mode (or use 'Model' everywhere)
switch2sim;

% Load an AT lattice without superbends
alslat_loco_disp_nuy9_122bpms_splitdipole2;  %als_short;
updateatindex;       % This will throw some warnings because of the missing magnets - SB, QDA, etc.
setradiation off;
setcavity off;


% U = sortuniverse('SigmaXStraight', 140, U);
% U = sortuniverse('SigmaXB2', 80, U);
% U = sortuniverse('BetaYStraight', 6, U);

U = sortuniverse('SigmaXStraight', 180, U);
U = sortuniverse('SigmaXB2', 80, U);
U = sortuniverse('BetaYStraight', 8, U);
U = sortuniverse('BetaYB1', 30, U);




% Inspect the remaining solutions manually
h = figure(4);
for i = 1:length(U.QF)

    % Set quadrupoles
    setsp('QF',  U.QF(i),  'Physics');
    setsp('QD',  U.QD(i),  'Physics');
    setsp('QFA', U.QFA(i), 'Physics');


    % Zero the sextupoles and skew quadrupoles
    setsp('SF',   0, 'Physics');
    setsp('SD',   0, 'Physics');
    setsp('SQSF', 0, 'Physics');
    setsp('SQSD', 0, 'Physics');

    
    figure(h);
    plottwiss;
    %modeltwiss('Beta', 'DrawLattice');

    %figure(2);
    %modeltwiss('Eta', 'DrawLattice');

    fprintf('   %d.  This is lattice #%d\n', i, U.Index(i));
    fprintf('        SigmaX straight=%f   SigmaX BEND #2=%f   BetaYStraight=%f   QF=%f\n', U.SigmaXStraight(i), U.SigmaXB2(i), U.BetaYStraight(i), U.QF(i));
    fprintf('              Emittance=%f           Alpha0=%f                QFA=%f   QD=%f\n', U.Emittance(i), U.Alpha0(i), U.QFA(i), U.QD(i));
    
    if i ~= iPareto(end)
        fprintf('   %d. Hit <return> to continue.\n\n', i);
        pause;
    end
end




% % Search on beam size
% %[Population, iParetoVector] = sortrows([U.SigmaXStraight U.SigmaXB2],[1 2]);
% %[Population, iParetoVector] = sortrows([U.SigmaXStraight U.SigmaXB1 U.SigmaXB2],[1 2]);
% %[Population, iParetoVector] = sortrows([U.SigmaXStraight U.SigmaXB2 U.Emittance],[1 2]);
% [Population, iParetoVector] = sortrows([U.SigmaXStraight U.SigmaXB2 U.BetaYStraight],[1 2 3]);
% 
% 
% % % Remove equal (this does not work for order > 2)
% % isame = find(diff(Population(:,1))==0);
% % Population(isame+1,:) = [];
% % iParetoVector(isame+1) = [];
% 
% % % Dim = 2
% % j = 1;
% % while j < size(Population,1)
% %     iLessDominate = find(Population(j+1:end,2) >= Population(j,2));
% %     Population(iLessDominate+j,:) = [];   
% %     iParetoVector(iLessDominate+j) = [];
% %     j = j + 1;
% % end
% 
% % All dimensions
% j = 1;
% while j < size(Population,1)
%     iLessDominate = Population(j+1:end,2) >= Population(j,2);
%     for iCol = 3:size(Population,2)
%         iLessDominate = iLessDominate & (Population(j+1:end,iCol) >= Population(j,iCol));
%     end
%     iLessDominate = find(iLessDominate);
%     Population(iLessDominate+j,:) = [];   
%     iParetoVector(iLessDominate+j) = [];
%     j = j + 1;
% end
% 
% 
% % Remove equals
% isame = find(all(diff(Population,1,1)==0,2)==1)+1;
% Population(isame,:) = [];
% iParetoVector(isame) = [];
% 
% 
% % Print some stuff
% [iParetoVector Population]
% iParetoVector = iParetoVector(:);
% fprintf('\n   %d lattices found\n', length(iParetoVector));
