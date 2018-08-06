function  ALBAsteptune(dqx, dqy, ModeString)
% ALBAsteptune(dqx, dqy)
% Step the tune, using the fitted values of the quads

quadlist=findmemberof('QUAD');
nmagnet= size(quadlist,1);

if nargin < 3
    ModeString = getmode(quadlist{1});
end

%
%This has to be moved to the AO
M.QD1.a=-0.76164;M.QD1.b=-0.0918838;M.QD1.f=12.7976;
M.QD2.a=-0.13152;M.QD2.b=-0.202929;M.QD2.f=2.20554;
M.QD3.a=0.469173;M.QD3.b=-0.584404;M.QD3.f=-5.45137;
M.QF1.a=0.566096;M.QF1.b=0.037456;M.QF1.f=-9.0738;
M.QF2.a=-0.0240997;M.QF2.b=0.0245747;M.QF2.f=2.13817;
M.QF3.a=-0.621443;M.QF3.b=-0.152661;M.QF3.f=14.1161;
M.QF4.a=0.378425;M.QF4.b=0.0702568;M.QF4.f=-5.97448;
M.QF5.a=0.143881;M.QF5.b=0.00797372;M.QF5.f=-0.884384;
M.QF6.a=0.0519018;M.QF6.b=0.0524274;M.QF6.f=0.70281;
M.QF7.a=-0.0370648;M.QF7.b=0.154413;M.QF7.f=1.40356;
M.QF8.a=0.00836203;M.QF8.b=-0.0487246;M.QF8.f=2.2572;

for i=1:nmagnet,
    magnet=cell2mat(quadlist(i));
    dm(i)=quadlist(i);
    dsp(i)=dqx*M.(magnet).a+dqy*M.(magnet).b;
end
%for i=1:nmagnet,
%    setsp(cell2mat(dm(i)), dsp(i)+getsp(cell2mat(dm(i)),1,ModeString), ModeString);
%end
for i=1:nmagnet,
    stepsp(cell2mat(dm(i)), dsp(i),'Physics', ModeString);
end
