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


% Kx = 16*1e6;
% Ky = 16*1e6;
% Kq = 1e6;
% 
% a = 10000;
% b = 11000;
% c = 13000;
% d = 14000;
% a = 5066383;
% b = 5393767;
% c = 5381955;
% d = 6481844;
% 
% s =  a+b+c+d
% x = Kx*(a-b-c+d)/s
% y = Ky*(a+b-c-d)/s
% q = Kq*(a-b+c-d)/s
% 
%    
% aa = (+x/Kx+y/Ky+q/Kq+1)*s/4
% bb = (-x/Kx+y/Ky-q/Kq+1)*s/4
% cc = (-x/Kx-y/Ky+q/Kq+1)*s/4
% dd = (+x/Kx-y/Ky-q/Kq+1)*s/4



%%


Kx = 16*1e6;
Ky = 16*1e6;
Kq = 1e6;

% A=c3  B=c1  C=c2  D=c0
sa = [
    [Prefix,'ADC3:rfMag']
    [Prefix,'ADC1:rfMag']
    [Prefix,'ADC2:rfMag']
    [Prefix,'ADC0:rfMag']
    [Prefix,'SA:xPos   ']
    [Prefix,'SA:yPos   ']
    [Prefix,'SA:skew   ']
    [Prefix,'SA:sum    ']
    ]

[sa, tmp, Ts] = getpvonline(sa);
t = linktime2datenum(Ts);
%[sa2, tmp, Ts2] = getpvonline(sa);
%t2 = linktime2datenum(Ts2);
a = sa(1);
b = sa(2);
c = sa(3);
d = sa(4);
x = sa(5)*1e6;   % Just .ELSO scaling [mm to nm for conversion to a,,b,c,d]
y = sa(6)*1e6;   % Just .ELSO scaling [mm to nm for conversion to a,,b,c,d]
q = sa(7);
s = sa(8);


ss =  a+b+c+d;
xx = Kx*(a-b-c+d)/s;
yy = Ky*(a+b-c-d)/s;
qq = Kq*(a-b+c-d)/s;

   
aa = (+x/Kx+y/Ky+q/Kq+1)*s/4;
bb = (-x/Kx+y/Ky-q/Kq+1)*s/4;
cc = (-x/Kx-y/Ky+q/Kq+1)*s/4;
dd = (+x/Kx-y/Ky-q/Kq+1)*s/4;

% A=c3  B=c1  C=c2  D=c0
fprintf('               EPICS     Converted from xyqs\n', a, aa);
fprintf('  a (ADC3) = %8d    %.f\n', a, aa);
fprintf('  b (ADC1) = %8d    %.f\n', b, bb);
fprintf('  c (ADC2) = %8d    %.f\n', c, cc);
fprintf('  d (ADC0) = %8d    %.f\n', d, dd);
fprintf('\n');

fprintf('               EPICS     Converted from abcd\n', a, aa);
fprintf('         x = %.7f    %.7f\n', x/1e6, xx/1e6);
fprintf('         y = %.7f    %.7f\n', y/1e6, yy/1e6);
fprintf('         q = %.f    %.f\n', q, qq);
fprintf('         s = %.f    %.f\n', s, ss);

 