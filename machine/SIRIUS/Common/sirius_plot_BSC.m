function [POS, HBSC, VBSC] = sirius_plot_BSC(maquina,tipo,save_fig,e_spread)
%Funcao que faz o grafico do tamanho do feixe apenas no booster e anel de
%armazenmento.  +
%Antes de executar esse script e necessario rodar o comando
%sirius('versao') para carregar os caminhos no matlab
%variaveis de entrada:
%   maquina - string indicando a maquina que deseja fazer os grafico, pode
%    ser 'si' para o Anel de armazenamento, 'bo' para o booster e 'tb' ou
%    'ts' para as linhas de trasnporte linac-booster ou booster-anel.
%   tipo - fazer o grafico de todas as funcoes de twiss juntas (0) ou
%   separadas (1). O Default e fazer tudo junto.
%   coup - acoplamente betatron x-y.
%   save_fig - flag que indica o desejo de salvar a figure sempre em
%   formato svg.
%   e_spread - no caso das linhas de transporte o input do energy spread e
%   necessario.
%Para utilizar o script e necessario rodas ANTES um comamndo carregando a
%rede da maquina em questao -> sirius('maquina+versao'). Depois disso o
%script se encarrega de fazer o resto.

FnSz = 16;
LnWd = 2;

if ~exist('maquina', 'var'), maquina = 'si'; end
if ~exist('e_spread', 'var'), e_spread=0; end
if ~exist('tipo', 'var'), tipo = 1; end
if ~exist('save_fig','var'), save_fig = false; end


if strcmp(maquina,'BO')
    plot_bo(maquina);
    return;
end
    
%Carrega a rede e titulo da maquina desejada
if strcmp(maquina,'si')
    [THERING titulo]=sirius_si_lattice;
    titulo=regexprep(titulo,'_','-');
    %quebra rede em segmentos de 10 cm
    THERING=lnls_refine_lattice(THERING,0.1);
    %Calcula parametros de twiss da rede
    twiss = calctwiss(THERING);
    %Define inicio e fim para o grafico (1 periodo)
    mip = findcells(THERING,'FamName','mip');
    ini=1;
    fim=mip(1);
    %Calcula dispersao de energia
    param=atsummary;
    e_spread=param.naturalEnergySpread;
    delta = 0.06;
elseif strcmp(maquina,'bo')
    error('This is to be reviewed. BO has a specific way for the BSC to be calculated!');
    [THERING titulo]=sirius_bo_lattice;
    titulo=regexprep(titulo,'_','-');
    %Calcula parametros de twiss da rede
    twiss = calctwiss(THERING);
    %Define inicio e fim para o grafico (5 periodos)
    mqf = sort([findcells(THERING,'FamName','QF'), findcells(THERING,'FamName','qf')]);
    ini=1;
    fim=mqf(6);
    %Calcula dispersao de energia
    param=atsummary;
    e_spread=param.naturalEnergySpread;
    delta = 0.03;
elseif strcmp(maquina,'tb')
    [THERING titulo Twiss0]=sirius_tb_lattice;
    titulo=regexprep(titulo,'_','-');
    %Calcula parametros de twiss da rede
    twiss_tb = twissline(THERING,0.0,Twiss0,1:length(THERING)+1,'chrom');
    %Define inicio e fim para o grafico (linha de transporte completa)
    ini=1;
    fim=length(twiss_tb)-1;
    %Redefine a estrutura de twiss
    pos=cat(1,twiss_tb.SPos);
    twiss.pos=pos(2:length(pos));
    beta=cat(1,twiss_tb.beta);
    twiss.betax=beta(2:length(beta),1);
    twiss.betay=beta(2:length(beta),2);
    disp=[twiss_tb.Dispersion];
    twiss.etax=disp(1,2:length(disp))';
    % Define desvio de energia
    delta = 0.0;
elseif strcmp(maquina,'ts')
    [THERING titulo Twiss0]=sirius_ts_lattice;
    titulo=regexprep(titulo,'_','-');
    %Calcula parametros de twiss da rede
    twiss_ts = twissline(THERING,0.0,Twiss0,1:length(THERING)+1,'chrom');
    %Define inicio e fim para o grafico (linha de transporte completa)
    ini=1;
    fim=length(twiss_ts)-1;
    %Redefine a estrutura de twiss
    pos=cat(1,twiss_ts.SPos);
    twiss.pos=pos(2:length(pos));
    beta=cat(1,twiss_ts.beta);
    twiss.betax=beta(2:length(beta),1);
    twiss.betay=beta(2:length(beta),2);
    disp=[twiss_ts.Dispersion];
    twiss.etax=disp(1,2:length(disp))';
    % Define desvio de energia
    delta = 0.0;
else
    fprintf('Maquina nao reconhecida');
    return;
end

%Guarda tamanho da camara de vacuo
Hap=getcellstruct(THERING,'VChamber',1:length(THERING),1);
Vap=getcellstruct(THERING,'VChamber',1:length(THERING),2);

%Calcula aceitancia
Haccep=min(Hap.^2./twiss.betax);
Vaccep=min(Vap.^2./twiss.betay);

%Calcula beam stay clear:
% Primeiro Calculamos a contribuição das oscilações on-energy geradas
% principalmente durante a injeção no anel:
HBSC=sqrt(Haccep*twiss.betax+e_spread^2*twiss.etax.^2)*1e3;
VBSC=sqrt(Vaccep*twiss.betay+e_spread^2*twiss.etax.^2)*1e3;

% Agora calculamos a amplitude touschek para um desvio de energia
% desejado. Para o anel scolhemos 6% por ser a aceitância de RF
H0    = ((twiss.betax.*twiss.etaxl + twiss.alphax.*twiss.etax).^2 + ...
    twiss.etax.^2)./twiss.betax;
H_max = max(H0);
Amp   = (sqrt(H_max*twiss.betax) + twiss.etax)*delta*1e3;

% o beam stay clear horizontal é o máximo ponto a ponto dessas duas
% contribuições.
HBSC = max(HBSC,Amp);

if ~tipo
    figure1=figure('Color',[1 1 1],'Position', [1 1 1000 621]);
    axes('FontSize',FnSz);
    xlabel({'s [m]'},'FontSize',FnSz);
    ylabel({'Beam stay clear [mm]'},'FontSize',FnSz);
    hold on;
    bx=plot(twiss.pos(ini:fim),HBSC(ini:fim),'LineWidth',LnWd,'Color',[0 0 0.8]);
    by=plot(twiss.pos(ini:fim),VBSC(ini:fim),'LineWidth',LnWd,'Color',[1 0 0]);
    
    %Creat grid
    grid 'on';
    box 'on';
    
    offset=min(min(abs(VBSC(ini:fim)),abs(HBSC(ini:fim))));
    top=max(max(abs(VBSC(ini:fim)),abs(HBSC(ini:fim))));
    
    %Faz grafico da rede
    Delta=(top+offset)*0.1/3;
    offset=offset-2*Delta;
    xlimit=[0 twiss.pos(fim)];
    switch lower(maquina)
        case 'si'
        lnls_drawlattice(THERING,10,offset,1,Delta);
        xlim(xlimit);
        case 'bo'
            lnls_drawlattice(THERING,10,offset,1,Delta);
            xlim(xlimit);
        otherwise
            lnls_drawlattice(THERING,1,offset,1,Delta);
            xlim(xlimit);
    end
    offset=offset-2*Delta;
    ylim([offset top+2]);
    
    %Insere titulo e legenda
    title({['Beam Stay Clear - ' titulo]},'FontSize',FnSz,'FontWeight','bold');
    legend([bx,by],'horizontal','vertical','Location','northwest','boxoff');
    
    hold off;
else
    xlimit=[0 twiss.pos(fim)];
    
    %Create Figure
    figure1 = figure('Color',[1 1 1],'Position', [1 1 900 650]);
        
    %Grafico dispersao horizontal
    axes('Units','pixels','Position',[70 380 780 230],'FontSize',FnSz);
    title(['Beam Stay Clear - ' titulo], 'FontWeight','bold');
    hold all;
    plot(twiss.pos(ini:fim),HBSC(ini:fim),'LineWidth',LnWd,'Color',[0 0 0.8]);
    xlim(xlimit); ylim([0,1.1*max(HBSC)]);
    ylabel('Horizontal BSC [mm]', 'FontSize',FnSz);
    %set(ylab, 'position', get(ylab,'position')+[0.6,0,0]);
    grid on;
    box on;
    
    %Grafico rede magnetica
    axes('Units','pixels','Position',[70 300 780 50]);
    if strcmp(maquina,'si')
        lnls_drawlattice(THERING,10,0,true,1,true);
        xlim(xlimit);
        axis off;
    elseif strcmp(maquina,'bo')
        lnls_drawlattice(THERING,10,0,true,1,true);
        xlim(xlimit);
        axis off;
    else
        lnls_drawlattice(THERING,1,0,true,1,true);
        xlim(xlimit);
        axis off;
    end
    
    %Grafico funcoes betatron
    axes('Units','pixels','Position',[70 70 780 230],'FontSize',FnSz);
    hold all;
    xlim(xlimit); ylim([0,1.1*max(VBSC)]);
    plot(twiss.pos(ini:fim),VBSC(ini:fim),'LineWidth',LnWd,'Color',[1 0 0]);
    xlabel('s [m]', 'FontSize',FnSz);
    ylabel({'Vertical BSC [mm]'},'FontSize',FnSz);
    grid on;
    box on;
end

if strcmp(maquina,'si')
    mia = findcells(THERING,'FamName','mia');
    mib = findcells(THERING,'FamName','mib');

    inda = twiss.pos >= twiss.pos(mia(1)) & twiss.pos <= twiss.pos(mia(1))+3;
    posa = twiss.pos(inda);   posa = posa-posa(1);    bscha = HBSC(inda);   bscva = VBSC(inda);

    indb = twiss.pos >= twiss.pos(mib(1)) & twiss.pos <= twiss.pos(mib(1))+3;
    posb = twiss.pos(indb);   posb = posb-posb(1);    bschb = HBSC(indb);   bscvb = VBSC(indb);

    f2 = createfigure(posa,bscha,bscva,  posb,bschb,bscvb);

    if save_fig
        f = fopen('bsc_ssa.txt','w');
        fprintf(f,'%15s %15s %15s\n','pos [m]', 'BSCH [mm]', 'BSCV [mm]');
        fprintf(f,'%15.5f %15.5f %15.5f\n',[posa,bscha,bscva]');
        fclose(f);
        f = fopen('bsc_ssbp.txt','w');
        fprintf(f,'%15s %15s %15s\n','pos [m]', 'BSCH [mm]', 'BSCV [mm]');
        fprintf(f,'%15.5f %15.5f %15.5f\n',[posb,bschb,bscvb]');
        fclose(f);
        plot2svg([maquina '_BSC_SS.svg'],f2);
        saveas(f2, [maquina '_BSC_SS']);
    end
end

if save_fig
    %if strcmp(save_fig,'pdf')==1
    %    print('-dpdf',[maquina '_BSC.pdf']);
    %else
    %    print('-dpng',[maquina '_BSC.png']);
    plot2svg([maquina '_BSC.svg'],figure1);
    saveas(figure1, [maquina '_BSC']);
end

POS  = twiss.pos(ini:fim);
HBSC = HBSC(ini:fim);
VBSC = VBSC(ini:fim);


function fig = createfigure(X1,Y1,Y2, X2,Y3,Y4)
%CREATEFIGURE(X1,Y1,Y2,X2,Y3,Y4)
%  X1:  vector of x data
%  Y1:  vector of y data
%  Y2:  vector of y data
%  X2:  vector of x data
%  Y3:  vector of y data
%  Y4:  vector of y data

%  Auto-generated by MATLAB on 30-Mar-2017 11:33:24

% Create figure
fig = figure('Position', [38,80,1105,832]);

% Create axes
ax1 = axes('Parent',fig,...
    'YMinorTick','on','YMinorGrid','on',...
    'XMinorTick','on','XMinorGrid','on',...
    'OuterPosition',[0.0 0.50 0.507 0.489],...
    'Position',[0.084 0.541 0.418 0.405],...
    'GridLineStyle','--','FontSize',16);
box(ax1,'on');
grid(ax1,'on');
hold(ax1,'all');
plot(X1,Y1,'Parent',ax1,'LineWidth',2);
title('High Beta SS (SA)','FontSize',16);
ylabel('Horizontal BSC [mm]','FontSize',16);

% Create axes
ax2 = axes('Parent',fig,...
    'YMinorTick','on','YMinorGrid','on',...
    'XMinorTick','on','XMinorGrid','on',...
    'OuterPosition',[0.02 0.50 0.49 0.489],...
    'Position',[0.084 0.067 0.418 0.399],...
    'GridLineStyle','--','FontSize',16);
box(ax2,'on');
grid(ax2,'on');
hold(ax2,'all');
plot(X1,Y2,'Parent',ax2,'LineWidth',2,'Color',[1 0 0]);
xlabel('distance from center [m]','FontSize',16);
ylabel('Vertical BSC [mm]','FontSize',16);

% Create axes
ax3 = axes('Parent',fig,...
    'YMinorTick','on','YMinorGrid','on',...
    'XMinorTick','on','XMinorGrid','on',...
    'OuterPosition',[0.52 0.5 0.49 0.49],...
    'Position',[0.563 0.542 0.400 0.405],...
    'GridLineStyle','--','FontSize',16);
box(ax3,'on');
grid(ax3,'on');
hold(ax3,'all');
plot(X2,Y3,'Parent',ax3,'LineWidth',2);
title('Low Beta SSs (SB,SP)','FontSize',16);

% Create axes
ax4 = axes('Parent',fig,...
    'YMinorTick','on','YMinorGrid','on',...
    'XMinorTick','on', 'XMinorGrid','on',...
    'OuterPosition',[0.52 0 0.49 0.49],...
    'Position',[0.563 0.067 0.400 0.399],...
    'GridLineStyle','--', 'FontSize',16);
box(ax4,'on');
grid(ax4,'on');
hold(ax4,'all');
plot(X2,Y4,'Parent',ax4,'LineWidth',2,'Color',[1 0 0]);
xlabel('distance from center [m]','FontSize',16);
