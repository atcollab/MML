function Difusion(order, file)
% Plot frequency map
% plot_fmap('fmap.out')
%
% Laurent S. Nadolski, SOLEIL, 03/04
%
% Change it to use scatter(qx,qy,1,diff)

%% grille par defaut
set(0,'DefaultAxesXgrid','on');
set(0,'DefaultAxesZgrid','on');

if nargin ==0
  help (mfilename)
  file ='fmap.out';
  order=4;
end
if nargin ==1
  help (mfilename)
  file ='fmap.out';
end
try
    [header data] = hdrload(file);
catch
    error('Error while opening filename %s ',file)
end
%% dimensions en mm
x = data(:,1)*1e3;
z = data(:,2)*1e3;
%% ajoute partie entiere
fx = 18 + abs(data(:,3));
fz = 8 + abs(data(:,4));

%% cas si diffusion
if size(data,2) == 6
    diffusion = 1;
    dfx = data(:,5);
    dfz = data(:,6);
else
    clear data
    diffusion = 0
end

% select stable particles
indx=(fx~=18.0);

%%% carte en frequence N&B


%% cas diffusion
if diffusion    
    figure(5);  clf
    xgrid = [];  dfxgrid = []; fxgrid = []; 
    zgrid = [];  dfzgrid = []; fzgrid = [];
    
    %% calcul automayique la taille des donnees
    nz = sum(x==x(1));
    nx = size(x,1)/nz;
    
    xgrid = reshape(x,nz,nx);
    zgrid = reshape(z,nz,nx);
    fxgrid = reshape(fx,nz,nx);
    fzgrid = reshape(fz,nz,nx);
    dfxgrid = reshape(dfx,nz,nx);
    dfzgrid = reshape(dfz,nz,nx);
    
    %% Calcul de la diffusion
    diffu = log10(sqrt(dfxgrid.*dfxgrid+dfzgrid.*dfzgrid)+1E-19);
    dif=log10(sqrt(dfx.*dfx+dfz.*dfz)+1E-19);
    ind2=isinf(dif);
    dif(ind2)=NaN;
    ind = isinf(diffu); 
    diffu(ind) = NaN;
    diffumax = -2; diffumin = -10;
    diffu(diffu< diffumin) = diffumin; % very stable
    diffu(diffu> diffumax) = diffumax; %chaotic
    dif(diffu< diffumin) = diffumin; 
    dif(diffu> diffumax) = diffumax; %chaotic
    h1=subplot(2,1,1);
    %% frequency map   
   % h=mesh(fxgrid,fzgrid,diffu,'LineStyle','.','MarkerSize',5.0,'FaceColor','none');
    h=mesh(fxgrid,fzgrid,diffu,'LineStyle','none','Marker','.','MarkerSize',7.0,'FaceColor','none');
    %h=scatter(fx(fx>18.001), fz(fx>18.001),1,dif(fx>18.001));
    caxis([-10 -2]); % Echelle absolue
    view(2); hold on;
    %axis([18.195 18.27 10.26 10.32])
    %shading flat
    xlabel('\nu_x');  ylabel('\nu_z');
    s=header(2,:);
    title(s);
    hold on
    max_order= order;
    global THERING
    [TD, tune] = twissring(THERING, 0,1:length(THERING));
    qx=tune(1);
    qy=tune(2);
    per = 1;
    window = [tune(1)-1.2 tune(1)+1.2 tune(2)-1.2 tune(2)+1.2];
    for i=max_order:-1:1,
        [k, tab] = reson(i,per,window);
    end
    xaxis([tune(1)-0.3 tune(1)+0.3])
    yaxis([tune(2)-0.3 tune(2)+0.3])
    hold off
    %% colorbar position
    hp=colorbar('horizon');
    
    h2=subplot(2,1,2);
    %% colorbar position
    p1 = get(h1,'position'); p2 = get(h2,'position'); p0 = get(hp,'position');
    set(hp,'position',[p0(1) p1(2) - 1.2*(p1(2)-p2(2)-p2(4))/2 p0(3:4)]);   
    %% dynamic aperture
    pcolor(xgrid,zgrid,diffu); hold on;
    %%xaxis([0 25])
    caxis([-10 -2]); % Echelle absolue
    shading flat;
    xlabel('x(mm)'); ylabel('z(mm)');
    addlabel(0,0,datestr(now));
end