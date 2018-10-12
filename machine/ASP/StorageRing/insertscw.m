function varargout = id_insertscw(B)

global THERING

ii = findcells(THERING,'FamName','scw');
if any(ii)
    fprintf('SCW alreay in the lattice. Setting the field B = %f T.\n',B);
    THERING{ii}.Bmax = B;
    return
end

lambda = 52e-3;

elemdata.FamName = 'scw';
elemdata.Length = lambda*63/2;
elemdata.Lw = lambda;
elemdata.Bmax = B;
elemdata.Nstep = 5;
elemdata.Nmeth = 4; % 2 or 4 for 2nd or 4th order.
elemdata.NHharm = 0; % Number of harmonics
elemdata.NVharm = 0;
elemdata.By = []; % Harmonic data [n C_n kx_n ky_n kz_n phiz_n]
elemdata.Bx = [];
elemdata.R1 = eye(6,6);
elemdata.R2 = eye(6,6);
elemdata.T1 = zeros(6,1);
elemdata.T2 = zeros(6,1);
elemdata.PassMethod = 'GWigSymplecticPass';
elemdata.Energy = THERING{1}.Energy;

n = 1;
kw = 2*pi/lambda;
kx = 10;
kz = n*kw;
ky = sqrt(kx^2 + kz^2);
tz = 0;
C = 1;

elemdata.NHharm = 1;
elemdata.By = [1 C kx/kw ky/kw kz/kw tz];

idind = findcells(THERING,'FamName','id');

THERING{idind(8)} = elemdata;
THERING{idind(8)-1}.Length = THERING{idind(8)-1}.Length - elemdata.Length/2;
THERING{idind(8)+1}.Length = THERING{idind(8)+1}.Length - elemdata.Length/2;