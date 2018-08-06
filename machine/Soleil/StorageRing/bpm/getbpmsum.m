function [X Z Sum]=getbpmsum(varargin)
%GETBPMSUM - Get Sum vector for BPM and display it
%
%
%
%  See Also getbpmrawdata

%
%% Written by Laurent S. Nadolski

DisplayFlag = 1;

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end

spos=getspos('BPMx');
Vect = getbpmrawdata([],'Nodisplay','Struct');

Sum = Vect.Data.Sum;
X = Vect.Data.X;
Z = Vect.Data.Z;
[maxSum idx] = max(Sum');

%idx2 = sub2ind(size(AM.Data.Sum), xpos, idx+ishift)

% figure
% mesh(Vect.Data.Sum)

xdeb=0;
xfin=350;

xmax=10;
%xfin=getcircumference;

%&é"idx(1) = 7;
figure(205)
h1 = subplot(7,1,[1 2]);
plot(spos,maxSum,'.-');
ylabel('Sum Signal Amplitude (u.a.)');
xaxis([xdeb xfin]);yaxis([0 5e08]);

h2 = subplot(7,1,[3 4]);
plot(spos,X(1:120,idx(1)),'.-b');
% hold on
% plot(spos,X(1:120,idx(1)+1),'.-r');
% hold off
ylabel('X Amplitude (mm)');
yaxis([-xmax xmax]);xaxis([xdeb xfin]);

h3 = subplot(7,1,[5 6]);
plot(spos,Z(1:120,idx(1)),'.-b');
% hold on
% plot(spos,Z(1:120,idx(1))+1,'.-r');
% hold off
ylabel('Z Amplitude (mm)');
yaxis([-xmax xmax]);xaxis([xdeb xfin]);

h4 = subplot(7,1,7);
drawlattice 
set(h4,'YTick',[])
xaxis([xdeb xfin]);

grid on
xlabel('s [mm]');

linkaxes([h1 h2 h3 h4],'x')
set([h1 h2 h3 h4],'XGrid','On','YGrid','On');
%xaxis([0 100])


X  =X(1:120,idx(1));
Z  = Z(1:120,idx(1));
Sum = Sum(1:120,idx(1));