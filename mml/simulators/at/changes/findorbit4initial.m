function orbit = FindOrbit4initial(RING,dP,orbitguess,varargin);
% FINDORBIT4 finds the closed orbit in the transverse 4-d phase 
%    space by numerically solving  for a fixed point of the one turn 
%    map M calculated with RingPass 
%
%         (X, PX, Y, PY, dP2, CT2 ) = M (X, PX, Y, PY, dP1, CT1)
% 
%    under the CONSTANT MOMENTUM constraint dP2 = dP1 = dP and 
%    no constraint on the 6-th coordinate CT 
%
% IMPORTANT!!! FINDORBIT4initial imposes a constraint on dP and relaxes
%    the constraint on the revolution frequency. A physical storage
%    ring does exactly the opposite: the momentum deviation finds an 
%    equilibrium for the particle on to be synchronous with the RF cavity 
%
%                 HarmNumber*Frev = Frf
%
%    To impose this artifiacial constraint in FINDORBIT4initial 
%    Pass function used for all elements SHOULD NOT 
%    1. change the longitudinal momentum dP (cavities , magnets with radiation)
%    2. have any time dependence (localized impedance, fast kickers).
% 
% FINDORBIT4initial(RING,dP,orbitguess) is 4x1 vector - fixed point at the 
%    entrance of the 1-st element of the RING (x,px,y,py)
%
% FINDORBIT4initial(RING,dP,orbitguess,REFPTS) is 4-by-Length(REFPTS)
%     array of coloumn vectors - fixed points (x,px,y,py)
%     at the entrance of each element indexed  REFPTS array. 
%     REFPTS is an array of increasing indexes that  select elements 
%     from the range 1 to length(RING)+1. 
%     See further explanation of REFPTS in the 'help' for FINDSPOS  
%
% See also: 	FindOrbit6, FindSyncOrbit

if ~iscell(RING)
   error('First argument must be a cell array');
end

if ~(isreal(dP) & length(dP)==1)
   error('Second argument must be a scalar');
end 

if ~(isreal(orbitguess) & length(orbitguess)==6)
   error('Third argument must be a 6x1 matrix');
end 

   
%d = sqrt(eps);	% step size for numerical differentiation
d = 1e-10;
max_iterations = 20;
J = zeros(4);
Ri = orbitguess;
Ri(5) = dP;

change = 1;
itercount = 0;
while (change>eps) & (itercount < max_iterations)
   RMATi=[Ri Ri Ri Ri Ri];               
   for k = 1:4
      RMATi(k,k)=RMATi(k,k)+d;
   end
   RMATf = ringpass(RING,RMATi);
   Rf = RMATf(:,5);
   % compute the transverse part of the Jacobian 
   
   J = (RMATf(1:4,1:4) - [Rf(1:4) Rf(1:4) Rf(1:4) Rf(1:4)])/d;
   B = inv(J-diag(ones(1,4)));
   B(5,5)=1;
   B(6,6)=0;
   Ri_next = Ri - B*(Rf-Ri);
   change = norm(Ri_next - Ri);
   Ri = Ri_next;
   itercount = itercount+1;
end;

if(nargin<4)   % return only the fixed point at the entrance of RING{1}
   orbit=Ri(1:4,1);
else            % 3-rd input argument - vector of reference points alog the Ring
                % is supplied - return orbit            
   orb6 = linepass(RING,Ri,varargin{1}); 
   orbit = orb6(1:4,:); 
end
