function eff_inj_ans_read(varargin)
% Mesure efficacité injection anneau
% Mesure dose moniteur de perte lent (MPL)


listefile = dir('injection_*.mat') ;
imax=length(listefile);


for i=3:imax
    
    file=listefile(i).name
    load(file,'commentaire','rend_boo', 'rend_ans', 'mpl_doserate', 'mpl_dose');
    
    figure(i)
    h=plot(mpl_doserate,'o-b');
    xlabel('MPL doserate')
    yy=ylim;
    text(1, (yy(2)*0.9), commentaire,'FontSize',12)
    text(1, (yy(2)*0.82), strcat('Rendement=',num2str(rend_ans),'%'),'FontSize',16)
    
    len=length(file);
    file1=[file(1:len-3),'png']
    saveas(h,file1,'png')
end


