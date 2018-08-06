function [emit sigmas] = getemit(TwissData)
global  THERING;
if (nargin==0) 
    [TwissData, tune]  = twissring(THERING,0,1:length(THERING)+1,'chrom');
end


ati = atindex(THERING);
ibend = sort([ati.BEND]);
for i = ibend
    THERING{i}.PassMethod = 'BndMPoleSymplectic4RadPass';
   % THERING{i}.Energy = 3e9;
end

RADELEMINDEX = sort([ibend]);

[ENV, DP, DL] = ohmienvelope(THERING,RADELEMINDEX, 1:length(THERING)+1);
sigmas = cat(2,ENV.Sigma);


[TwissData, tune]  = twissring(THERING,0,1:length(THERING)+1,'chrom');
beta = cat(1,TwissData.beta);
eta = cat(2,TwissData.Dispersion);

epsx = (sigmas(1,:).^2-eta(1,:).^2*DP^2)./beta(:,1)';
epsy = (sigmas(2,:).^2-eta(3,:).^2*DP^2)./beta(:,2)';
emit(1) = median(epsx);
emit(2) = median(epsy);
for i = ibend
    THERING{i}.PassMethod = 'BndMPoleSymplectic4Pass';
    THERING{i}.Energy = 3e9;
end
