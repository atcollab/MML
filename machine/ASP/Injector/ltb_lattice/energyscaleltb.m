
init = 0; % set to 1 for init, set to 0 to scale
if (init)
    bend0 = getsp('LTB_BEND','Hardware');
    q0 = getsp('LTB_Q','Hardware');
    h0 = getsp('LTB_HCOR','Hardware');
    v0 = getsp('LTB_VCOR','Hardware');
    sepi0 = getsp('LTB_SEPI','Hardware');
    ki0 = getsp('LTB_KI','Hardware');
end

scale = 1.22;

% setsp('LTB_BEND',scale*bend0,'Hardware');
setsp('LTB_Q',scale*q0,'Hardware');
% setsp('LTB_HCOR',scale*h0,'Hardware');
% setsp('LTB_VCOR',scale*v0,'Hardware');
% setsp('LTB_SEPI',scale*sepi0,'Hardware');
% setsp('LTB_KI',scale*ki0,'Hardware');
