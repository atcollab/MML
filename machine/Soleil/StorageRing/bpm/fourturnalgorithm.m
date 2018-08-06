function [nux nuz Xcod Zcod] = fourturnalgorithm(varargin)
%FOURTURNALGORITHM - Compute tunes and closed orbit knowing 4 subsequent turn  by turn data
%
%  INPUTS
%  Optional - 'Model', 'Online'
%           - 'Display', 'NoDisplay'
%
%  OUTPUTS
%  1. nux  - horizontal tune
%  2. nux  - vertical tune
%  3. Xcod - horizontal closed orbit
%  4. Zcod - horizontal closed orbit

%  ALGORITHM
%  EPAC94, Koscielniak, pp 929-931

%
%  Written by Laurent S. Nadolski

% Get turn by turn data

OnlineFlag  = 1;
ArchiveFlag = 0;
FileFlag    = 0;
DisplayFlag = 1;

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin2 = {varargin2{:} varargin{i}};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin2 = {varargin2{:} varargin{i}};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Model')
        OnlineFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        OnlineFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'File')
        FileFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Archive')
        ArchiveFlag = 1;
        varargin2 = [varargin2 varargin{i}];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = 0;
        varargin2 = [varargin2 varargin{i}];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Struct')
        StructureFlag = 1;
        varargin2 = [varargin2 varargin{i}];
        varargin(i) = [];
    end
end

BPMindex = family2atindex('BPMx');
spos = getspos('BPMx');

if ~OnlineFlag  % Model
    global THERING

    X00 = [1e-3 0 1e-3 0 0 0]';
    X01 = linepass(THERING, X00(:,end), 1:length(THERING)+1);
    X02 = linepass(THERING, X01(:,end), 1:length(THERING)+1);
    X03 = linepass(THERING, X02(:,end), 1:length(THERING)+1);
    X04 = linepass(THERING, X03(:,end), 1:length(THERING)+1);

    [X1 X2 X3 X4 ] = deal(X01(1,BPMindex)*1e3, X02(1,BPMindex)*1e3, X03(1,BPMindex)*1e3, X04(1,BPMindex)*1e3);
    [Z1 Z2 Z3 Z4 ] = deal(X01(3,BPMindex)*1e3, X02(3,BPMindex)*1e3, X03(3,BPMindex)*1e3, X04(3,BPMindex)*1e3);

else % Online
    [X Z] = anabpmnfirstturns([],4,10,'NoDisplay','NoMaxSum');
    [X1 X2 X3 X4] = deal(X(1,:),X(2,:),X(3,:),X(4,:));
    [Z1 Z2 Z3 Z4] = deal(Z(1,:),Z(2,:),Z(3,:),Z(4,:));
end

%% Algo 4 turns
nux = acos((X2-X1+X4-X3)/2./(X3-X2))/2/pi;
nuz = acos((Z2-Z1+Z4-Z3)/2./(Z3-Z2))/2/pi;

Xcod = (X3.*(X1+X3)-X2.*(X2+X4))./((X1-X4) + 3*(X3-X2));
Zcod = (Z3.*(Z1+Z3)-Z2.*(Z2+Z4))./((Z1-Z4) + 3*(Z3-Z2));

% %%
% figure(77)
% plot(spos,X1,'.r'); hold on;
% plot(spos,X2,'.b')
% plot(spos,X3,'.g')
% plot(spos,X4,'.k')
% xlabel('s-position [m]');
% ylabel('4 turns');
% grid on
% %%
if DisplayFlag
    figure(78)
    plot(spos,Xcod,'b',spos,Zcod,'r');
    xlabel('s-position [m]');
    ylabel('Close orbit [mm]');
    legend('Xcod','Zcod');
    grid on

    figure(79)
    subplot(2,2,[1 2])
    plot(spos,nux,'b.',spos,nuz,'r.')
    xlabel('s-position [m]')
    ylabel('tune fractionnal part')
    title('4-turn Algorithm')
    legend(sprintf('nux %f',mean(nux(~isnan(nux)))),sprintf('nuz %f',mean(nuz(~isnan(nuz)))));
    grid on
    yaxis([0 0.5])

    subplot(2,2,3)
    hist(nux(~isnan(nux)))
    xlabel('Fractional tune nux')
    grid on

    subplot(2,2,4)
    hist(nuz(~isnan(nuz)))
    xlabel('Fractional tune nuz')
    grid on

end
