function ecm(nbits, m_max)
%%
hmx=1E-3;
nx=length(getpv('HCM'));
vmax=0;
error=[];
%%
for i=1:m_max,
    cx=(hmx/(2^nbits))*randn([1,nx]);
    cy=(hmx/(2^nbits))*randn([1,nx]);
    setpv('HCM',cx');
    setpv('VCM',cx');
    a{i}=10E6*getx;
    b{i}=10E6*gety;
   error=[error, cx, cy];
end

%%
figure(2)
x=0;
y=0;
% now the edge values:

for i=1:m_max,
    subplot(2,1,1)
    hold on
    plot(a{i},'r');
    x(i)=std(a{i});
    subplot(2,1,2)
    hold on
    plot(b{i},'b');
    y(i)=std(b{i});
end
%%
vmax=max([x,y]);
edge=0:vmax/10:vmax;
sx=histc(x, edge)*100/m_max;
sy=histc(y, edge)*100/m_max;
figure(3)
subplot(2,1,2)
plot(x,'r')
hold on
plot(y,'b')
subplot(2,1,1)
h1=bar (edge,[sx',sy']);
set(h1(1), 'FaceColor','r')
set(h1(2), 'FaceColor','b')
%fprintf(1,'horizontal orbit rms %f [um]\n',x*1E6)
%fprintf(1,'vertica; orbit rms %f [um]\n',y*1E6)
figure(8)