function stepchro_test(delta_xix,delta_xiz)
% stepchro_test - step chro using theoritical chromaticity matrix
% sextupole to chromaticity matrix response
% XI = A2*[S9;S10] 
% xi/Amps

A2 = [
-(2.72 - 3.63)/20 -(1.66 - 3.63)/10  
-(5.14 - 3.80)/20 -(4.31 - 3.80)/10  
];

% To change xix of 1 A and xiy of 0
dcm = inv(A2)*[delta_xix; delta_xiz];
stepsp('S9',dcm(1));
stepsp('S10',dcm(2));

return;
%% initial
   3.63494188538711
   3.80895506075137
%% -20 A sur S9
   2.72620641404035
   5.14305607187752

%% -20 A sur S10
-0.15467837810161
4.62101654578465

%% -10 A sur S10
1.66279256459202
4.31165978958150

A2 = [
(2.72 - 3.63)/20 (1.66 - 3.63)/10  
(5.14 - 3.80)/20 (4.31 - 3.80)/10  
]
 
% To change xix of 1 A and xiy of 0
dcm = inv(A2)*[delta_xix; delta_xiz];