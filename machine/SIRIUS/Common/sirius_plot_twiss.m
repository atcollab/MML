function sirius_plot_twiss(maquina,junto,save_fig)
%Funcao que faz o grafico dos parametros de twiss
% Antes de executar esse script e necessario rodar o camando
% sirius('versao') para carregar os caminhos no matlab
%variaveis de entrada:
%   maquina - string indicando a maquina que deseja fazer os grafico, pode
%    ser 'si' para o Anel de armazenamento, 'bo' para o booster e 'tb' ou
%    'ts' para as linhas de trasnporte linac-booster ou booster-anel.
%   junto - fazer o grafico de todas as funcoes de twiss juntas, true, ou
%   separadas, false. O Default e fazer tudo junto.
%   save_fig - flag que indica o desejo de salvar a figure sempre em
%   formato svg.
%Para utilizar o script e necessario rodas ANTES um comamndo carregando a
%rede da maquina em questao -> sirius('maquina+versao'). Depois disso o
%script se encarrega de fazer o resto.

FnSz = 16;
LnWd = 2;
ByCl = [1 0 0];
BxCl = [0 0 0.8];
DxCl = [0 0.8 0];

if ~exist('junto', 'var'), junto = 1; end
if ~exist('maquina', 'var'), maquina = 'si'; end
if ~exist('save_fig','var'), save_fig = false; end

%Carrega a rede e titulo da maquina desejada
switch lower(maquina)
    case 'si'
        [THERING titulo]=sirius_si_lattice;
        titulo=regexprep(titulo,'_','-');
        %quebra rede em segmentos de 10 cm
        THERING=lnls_refine_lattice(THERING,0.1);
        %Calcula parametros de twiss da rede
        twiss = calctwiss(THERING);
        %Define inicio e fim para o grafico (1 periodo)
        mib = findcells(THERING,'FamName','mib');
        ini=1;
        fim=mib(1);
        sym = 20;
    case 'bo'
        [THERING titulo]=sirius_bo_lattice;
        titulo=regexprep(titulo,'_','-');
        %quebra rede em segmentos de 10 cm
        THERING=lnls_refine_lattice(THERING,0.1);
        %Calcula parametros de twiss da rede
        twiss = calctwiss(THERING);
        %Define inicio e fim para o grafico (5 periodos)
        mqf = sort([findcells(THERING,'FamName','qf'), findcells(THERING,'FamName','QF')]);
        ini=1;
        fim=mqf(40);
        sym = 5;
    case 'tb'
        [THERING titulo Twiss0]=sirius_tb_lattice;
        titulo=regexprep(titulo,'_','-');
        %Calcula parametros de twiss da rede
        twiss_tb = twissline(THERING,0.0,Twiss0,1:length(THERING)+1,'chrom');
        %Define inicio e fim para o grafico (linha de transporte completa)
        ini=1;
        fim=length(twiss_tb);
        sym = 1;
        %Redefine a estrutura de twiss
        twiss.pos=cat(1,twiss_tb.SPos);
        beta=cat(1,twiss_tb.beta);
        twiss.betax=beta(:,1);
        twiss.betay=beta(:,2);
        disp=[twiss_tb.Dispersion];
        twiss.etax=disp(1,:)';
    case 'ts'
        [THERING titulo Twiss0]=sirius_ts_lattice;
        titulo=regexprep(titulo,'_','-');
        %Calcula parametros de twiss da rede
        twiss_ts = twissline(THERING,0.0,Twiss0,1:length(THERING)+1,'chrom');
        %Define inicio e fim para o grafico (linha de transporte completa)
        ini=1;
        fim=length(twiss_ts);
        sym = 1;
        %Redefine a estrutura de twiss
        twiss.pos=cat(1,twiss_ts.SPos);
        beta=cat(1,twiss_ts.beta);
        twiss.betax=beta(:,1);
        twiss.betay=beta(:,2);
        disp=[twiss_ts.Dispersion];
        twiss.etax=disp(1,:)';
    otherwise
        fprintf('Maquina nao reconhecida');
        %break;
end

if junto
    f1=figure('Color',[1 1 1],'Position', [1 1 1000 500]);
    ax1 = axes('FontSize',FnSz);
    xlabel({'s [m]'},'FontSize',FnSz);
    ylabel({'\beta [m], 10\eta_x [m]'},'FontSize',FnSz);
    hold all;
    plot(twiss.pos(ini:fim),twiss.betax(ini:fim),'LineWidth',LnWd,'Color',BxCl);
    plot(twiss.pos(ini:fim),twiss.betay(ini:fim),'LineWidth',LnWd,'Color',ByCl);
    plot(twiss.pos(ini:fim),10*twiss.etax(ini:fim),'LineWidth',LnWd,'Color',DxCl);

    legend({'\beta_x','\beta_y', '\eta_x'},'Location','northwest','Box','off',...
           'Color','none','XColor','w','YColor','w');
    
    %Creat grid
    grid(ax1,'on');
  
    
    %offset=min(min(abs(twiss.betay(ini:fim)),abs(twiss.betax(ini:fim))));
    offset=0;
    top=max(max(abs(twiss.betay(ini:fim)),abs(twiss.betax(ini:fim))));

    %Round to nice values (multiple of 5)
    top=(round(top/5)+(mod(top,5)~=0))*5;
    %Fixed top
    %top=30;
    nticks1=top/5;
    
    %Faz grafico da rede
    Delta=(top+offset)*0.1/3;
    offset=-offset-5*Delta;
    xlimit=[0 twiss.pos(fim)];
    switch lower(maquina)
        case 'si'
            lnls_drawlattice(THERING,20,offset,true,0.8*Delta,true,true);
            xlim(xlimit);
        case 'bo'
            lnls_drawlattice(THERING,10,offset,true,0.8*Delta,true,true);
            xlim(xlimit);
        otherwise
            lnls_drawlattice(THERING,1,offset,true,0.8*Delta,true,true);
            xlim(xlimit);
    end
    offset=offset-2*Delta;
    ylim([offset top]);
        box on;
    
    %Define eixo y secund?rio
%    ax2 = axes('Parent',figure1,'Position',get(ax1(1),'Position'),...
%               'XAxisLocation','top','YAxisLocation','right',...
%               'Color','none','XTickLabel',[],'FontSize', FnSz,...
%               'XColor','k','YColor',DxCl);
%    linkaxes([ax1(1) ax2],'x');
%    hold on
%    plot(ax2,twiss.pos(ini:fim),100*twiss.etax(ini:fim),'LineWidth',LnWd,'Color',DxCl);
%    ylabel(ax2,{'\eta_x [cm]'},'FontSize',FnSz,'Rot',-90);
%    set(get(ax2,'YLabel'),'Position',get(get(ax2,'YLabel'),'Position')+[1.2 0 0]);
    
    %Redefine extremos para casar escala com o eixo esquerdo
%    y2max=100*max(twiss.etax);
%    y2min=100*min(twiss.etax);
%    if (y2min<0)
%        y2max=max(y2max,-y2min);
%        y2min=-y2max;
%    else 
%        y2min=0;
%    end
%    Deltay2=y2max-y2min;
%    %Round to nice values
%    dDeltay2=Deltay2/nticks1;
%    dDeltay2=(round(dDeltay2/5)+(mod(dDeltay2,5)~=0))*5;
%    Deltay2=dDeltay2*nticks1;
%    if (y2min==0)
%        y2max=Deltay2;
%    else
%        y2max=Deltay2/2;
%        y2min=-y2max;
%    end
%    offset=y2min-4*Deltay2*0.1/3;
    %y1max=max(max(twiss.betax),max(twiss.betay));
    %y1min=min(min(twiss.betax),min(twiss.betay));
    %Deltay1= y1max-y1min;
    %y1lim=get(ax1,'ylim');
    %Dmin=abs((y1lim(1)-y1min)/Deltay1*Deltay2);
    %Dmax=abs((y1lim(2)-y1max)/Deltay1*Deltay2);
    
%    ylim(ax2,[offset y2max]);
%    Dticks=y2min:dDeltay2:y2max;
%    %y1ticks=get(ax1,'YTick');
%    %Dticks=(y2min-Dmin)+abs((y1ticks-y1lim(1))/Deltay1*Deltay2);
%    set(ax2,'Ytick',Dticks);
%    set(ax2,'YTickLabel',sprintf('%3.0f|',Dticks));
%    
    %Insere titulo e legenda
    title({['Twiss functions - ' titulo]},'FontSize',FnSz,'FontWeight','bold');
        
    hold off;
else
    xlimit=[0 twiss.pos(fim)];

    %Create Figure
    f1 = figure('Color',[1 1 1],'Position', [1 1 900 650]);
    
    %Grafico dispersao horizontal
    axes('Units','pixels','Position',[70 415 780 195],'XTickLabel',{},'FontSize',FnSz);
    title(['Twiss functions - ' titulo], 'FontWeight','bold');
    hold all;
    plot(twiss.pos(ini:fim),100*twiss.etax(ini:fim),'LineWidth',LnWd,'Color',DxCl);
    xlim(xlimit); ylim([-0.1+105*min(twiss.etax), 105*max(twiss.etax)]);
    ylabel('\eta_x [cm]', 'FontSize',FnSz);
    %         set(ylab, 'position', get(ylab,'position')+[0.6,0,0]);
    grid on;
    box on;
    
    %Grafico rede magnetica
    axes('Units','pixels','Position',[70 380 780 20]);
    lnls_drawlattice(THERING,sym,0,true,1,false,false);
    xlim(xlimit);
    axis off;
    
    %Grafico funcoes betatron
    axes('Units','pixels','Position',[70 70 780 295],'FontSize',FnSz);
    hold all;
    xlim(xlimit);
    plot(twiss.pos(ini:fim),twiss.betax(ini:fim),'LineWidth',LnWd,'Color',BxCl);
    plot(twiss.pos(ini:fim),twiss.betay(ini:fim),'LineWidth',LnWd,'Color',ByCl);
    xlabel('s [m]', 'FontSize',FnSz);
    ylabel({'\beta [m]'},'FontSize',FnSz);
    legend('\beta_x','\beta_y','Location','northeast');
    legend('boxoff');
    grid on;
    box on;
end

if save_fig
    %if strcmp(save_fig,'pdf')==1
    %    print('-dpdf',[maquina 'twiss.pdf']);
    %else
    %    print('-dpng',[maquina 'twiss.png']);
    plot2svg([maquina '_twiss.svg'],f1);
    saveas(f1, [maquina '_twiss']);
end

end

