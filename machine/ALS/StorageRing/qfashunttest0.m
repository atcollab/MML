function qfashunttest0
%QFASHUNTTEST0 - Test if the QFA shunts turn on and off
%
%  The output of this program on 2007-12-06 was the following.
%   1. QFA( 1, 1):   Shunt #1 = 1   Shunt #2 = 1  (14.12 Seconds)
%   2. QFA( 1, 2):   Shunt #1 = 1   Shunt #2 = 1  (21.95 Seconds)
%   3. QFA( 2, 1):   Shunt #1 = 1   Shunt #2 = 1  (12.93 Seconds)
%   4. QFA( 2, 2):   Shunt #1 = 1   Shunt #2 = 1  (20.97 Seconds)
%   5. QFA( 3, 1):   Shunt #1 = 1   Shunt #2 = 1  (11.92 Seconds)
%   6. QFA( 3, 2):   Shunt #1 = 1   Shunt #2 = 1  (20.97 Seconds)
%   7. QFA( 4, 1):   Shunt #1 = 1   Shunt #2 = 1  (16.83 Seconds)
%   8. QFA( 4, 2):   Shunt #1 = 1   Shunt #2 = 1  (20.84 Seconds)
%   9. QFA( 5, 1):   Shunt #1 = 1   Shunt #2 = 1  (20.84 Seconds)
%  10. QFA( 5, 2):   Shunt #1 = 1   Shunt #2 = 1  (20.92 Seconds)
%  11. QFA( 6, 1):   Shunt #1 = 1   Shunt #2 = 1  ( 0.93 Seconds)
%  12. QFA( 6, 2):   Shunt #1 = 1   Shunt #2 = 1  ( 0.95 Seconds)
%  13. QFA( 7, 1):   Shunt #1 = 1   Shunt #2 = 1  (13.95 Seconds)
%  14. QFA( 7, 2):   Shunt #1 = 1   Shunt #2 = 1  (20.91 Seconds)
%  15. QFA( 8, 1):   Shunt #1 = 1   Shunt #2 = 1  (18.92 Seconds)
%  16. QFA( 8, 2):   Shunt #1 = 1   Shunt #2 = 1  (20.91 Seconds)
%  17. QFA( 9, 1):   Shunt #1 = 1   Shunt #2 = 1  ( 0.95 Seconds)
%  18. QFA( 9, 2):   Shunt #1 = 1   Shunt #2 = 1  ( 0.95 Seconds)
%  19. QFA(10, 1):   Shunt #1 = 1   Shunt #2 = 1  ( 0.95 Seconds)
%  20. QFA(10, 2):   Shunt #1 = 1   Shunt #2 = 1  ( 0.94 Seconds)
%  21. QFA(11, 1):   Shunt #1 = 1   Shunt #2 = 1  (19.95 Seconds)
%  22. QFA(11, 2):   Shunt #1 = 1   Shunt #2 = 1  (20.94 Seconds)
%  23. QFA(12, 1):   Shunt #1 = 1   Shunt #2 = 1  (18.95 Seconds)
%  24. QFA(12, 2):   Shunt #1 = 1   Shunt #2 = 1  (20.95 Seconds)
%
%  The output of this program on 2008-06-03 was the following.
%   1. QFA( 1, 1):   Shunt #1 = 1   Shunt #2 = 1  (20.79 Seconds)
%   2. QFA( 1, 2):   Shunt #1 = 1   Shunt #2 = 1  (21.79 Seconds)
%   3. QFA( 2, 1):   Shunt #1 = 1   Shunt #2 = 1  (18.18 Seconds)
%   4. QFA( 2, 2):   Shunt #1 = 1   Shunt #2 = 1  (21.51 Seconds)
%   5. QFA( 3, 1):   Shunt #1 = 1   Shunt #2 = 1  (119.92 Seconds)  !!!
%   6. QFA( 3, 2):   Shunt #1 = 1   Shunt #2 = 1  (176.91 Seconds)  !!!
%   7. QFA( 4, 1):   Shunt #1 = 1   Shunt #2 = 1  (20.83 Seconds)
%   8. QFA( 4, 2):   Shunt #1 = 1   Shunt #2 = 1  (20.90 Seconds)
%   9. QFA( 5, 1):   Shunt #1 = 1   Shunt #2 = 1  (28.93 Seconds)
%  10. QFA( 5, 2):   Shunt #1 = 1   Shunt #2 = 1  (28.90 Seconds)
%  11. QFA( 6, 1):   Shunt #1 = 1   Shunt #2 = 1  ( 0.84 Seconds)
%  12. QFA( 6, 2):   Shunt #1 = 1   Shunt #2 = 1  ( 0.88 Seconds)
%  13. QFA( 7, 1):   Shunt #1 = 1   Shunt #2 = 1  (19.92 Seconds)
%  14. QFA( 7, 2):   Shunt #1 = 1   Shunt #2 = 1  (20.94 Seconds)
%  15. QFA( 8, 1):   Shunt #1 = 1   Shunt #2 = 1  (23.91 Seconds)
%  16. QFA( 8, 2):   Shunt #1 = 1   Shunt #2 = 1  (29.91 Seconds)
%  17. QFA( 9, 1):   Shunt #1 = 1   Shunt #2 = 1  ( 0.90 Seconds)
%  18. QFA( 9, 2):   Shunt #1 = 1   Shunt #2 = 1  ( 0.92 Seconds)
%  19. QFA(10, 1):   Shunt #1 = 1   Shunt #2 = 1  ( 0.89 Seconds)
%  20. QFA(10, 2):   Shunt #1 = 1   Shunt #2 = 1  ( 0.92 Seconds)
%  21. QFA(11, 1):   Shunt #1 = 1   Shunt #2 = 1  (21.15 Seconds)
%  22. QFA(11, 2):   Shunt #1 = 1   Shunt #2 = 1  (21.54 Seconds)
%  23. QFA(12, 1):   Shunt #1 = 1   Shunt #2 = 1  (12.85 Seconds)
%  24. QFA(12, 2):   Shunt #1 = 1   Shunt #2 = 1  (20.91 Seconds)

%  Since all the shunts show a monitor value of 1 when the control
%  was turned on, hopefully all shunts are working properly. 
%  The long delays in most of the sectors is due to the shunt ILC
%  control have to share time with reading the ion pumps (GPIB).

%  Written by Greg Portmann


% Just to test if the shunts are working

QuadFamily = 'QFA';
QuadDevList = family2dev('QFA');


% Start with all shunts off
setqfashunt(1, 0, [], 0);
setqfashunt(2, 0, [], 0);

for k = 1:size(QuadDevList,1)

    % See if the shunts turn on
    tic;
    setqfashunt(1, 1, QuadDevList(k,:), 0);
    setqfashunt(2, 1, QuadDevList(k,:), -1);
    setqfashunt(1, 1, QuadDevList(k,:), -1);
    T = toc;

    fprintf('   %2d. QFA(%2d,%2d):   Shunt #1 = %.0f   Shunt #2 = %.0f  (%5.2f Seconds)\n', k, QuadDevList(k,:), getqfashunt(1,QuadDevList(k,:)), getqfashunt(1,QuadDevList(k,:)), T);
    
    % Turn off
    setqfashunt(1, 0, QuadDevList(k,:), 0);
    setqfashunt(2, 0, QuadDevList(k,:), 0);
end