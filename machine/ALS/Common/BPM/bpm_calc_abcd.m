

% With buttons, and positive X to the left, Y up:
% 
%      A   B
% 
%      D   C
% 
% Here?s the matrix that gives X, Y, Q, S, from A, B, C, D, where S=A+B+C+D:
% 
%                            [ gx    gx    gx   gx  ]
%                            [ --  - --  - --   --  ]
%                            [ S     S     S    S   ]
%                            [                      ]
%                            [ gy   gy     gy    gy ]
%                            [ --   --   - --  - -- ]
% (%o4)                      [ S    S      S     S  ]
%                            [                      ]
%                            [ gq    gq   gq     gq ]
%                            [ --  - --   --   - -- ]
%                            [ S     S    S      S  ]
%                            [                      ]
%                            [ 1    1     1     1   ]
% 
% Inverting this gives the matrix that provides A, B, C, D from X, Y, Q, S:
% (%i5) invert(%o4);
%                          [   S       S       S     1 ]
%                          [  ----    ----    ----   - ]
%                          [  4 gx    4 gy    4 gq   4 ]
%                          [                           ]
%                          [    S      S        S    1 ]
%                          [ - ----   ----   - ----  - ]
%                          [   4 gx   4 gy     4 gq  4 ]
% (%o5)                    [                           ]
%                          [    S       S      S     1 ]
%                          [ - ----  - ----   ----   - ]
%                          [   4 gx    4 gy   4 gq   4 ]
%                          [                           ]
%                          [   S        S       S    1 ]
%                          [  ----   - ----  - ----  - ]
%                          [  4 gx     4 gy    4 gq  4 ]






