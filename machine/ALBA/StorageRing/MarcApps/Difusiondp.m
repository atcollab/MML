function Difusiondp(order, file)
% Plot frequency map
% eg:
% plot_fmapdp('fmapdp.out')
%
% Laurent S. Nadolski, SOLEIL, 03/04

%% grille par defaut
set(0,'DefaultAxesXgrid','on');
set(0,'DefaultAxesYgrid','on');

if nargin ==0
  help (mfilename)
  file ='fmapdp.out';
  order=4;
end
if nargin ==1
  help (mfilename)
  file ='fmapdp.out';
end

try
    [dp x fx fz dfx dfz] = textread(file,'%f %f %f %f %f %f','headerlines',3);
catch
    error('Error while opening filename %s',file)
end

%% ajoute parties entieres
fx=18+abs(fx);
fz=8+abs(fz);
%% energie en %
dp = dp*1e2;
%% position en mm
x = x*1e3;
            
% select stable particles
indx=(fx~=18.0);



%% Carte avec diffusion
figure(7); clf 
dpgrid = [];
xgrid = [];
dfxgrid = [];
dfzgrid = [];
fxgrid = [];
fzgrid = [];

%% Calcul automatique de la taille des donnees
nx = sum(dp==dp(1));
ndp = size(dp,1)/nx;

xgrid = reshape(x,nx,ndp);
dpgrid = reshape(dp,nx,ndp);
fxgrid = reshape(fx,nx,ndp);
fzgrid = reshape(fz,nx,ndp);
dfxgrid = reshape(dfx,nx,ndp);
dfzgrid = reshape(dfz,nx,ndp);


%% Diffusion

   diffu = log10(sqrt(dfxgrid.*dfxgrid+dfzgrid.*dfzgrid));

%% saturation
ind = isinf(diffu); 
diffu(ind) = NaN;
diffumax = -2; diffumin = -10;
diffu(diffu< diffumin) = diffumin; % very stable
diffu(diffu> diffumax) = diffumax; %chaotic
diffu(end)    = diffumin;
diffu(end-1) = diffumax;

%% fmap
h1=subplot(2,1,1);

%mesh(fxgrid,fzgrid,diffu,'LineStyle','.','MarkerSize',5.0,'FaceColor','none');
mesh(fxgrid,fzgrid,diffu,'LineStyle','none','Marker','.','MarkerSize',8.0,'FaceColor','none');
caxis([-10 -2]); % Echelle absolue
set(gca,'View',[0 90]);
hold on
shading flat
hp=colorbar( 'EastOutside'  );
xlabel('\nu_x')
ylabel('\nu_z')
hold on
    max_order= order;
    global THERING
    [TD, tune] = twissring(THERING, 0,1:length(THERING));
    qx=tune(1);
    qy=tune(2);
    per = 4;
    window = [tune(1)-1.2 tune(1)+1.2 tune(2)-1.2 tune(2)+1.2];
    for i=max_order:-1:1,
        [k, tab] = reson(i,per,window);
    end
    xaxis([tune(1)-0.3 tune(1)+0.3])
    yaxis([tune(2)-0.3 tune(2)+0.3])
%% DA
h2=subplot(2,1,2);
%% colorbar position

pcolor(dpgrid,xgrid,diffu); hold on
caxis([-10 -2]); % Echelle absolue
shading flat
xlabel('dp (%)')
ylabel('x(mm)')
%ind_amplitude

% addlabel(0,0,datestr(now))
