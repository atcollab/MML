if strcmp(optics_mode,'M1')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [0,0];
    
    %%% Quadrupoles
    qf2_strength =  3.197471856142;
    qd2_strength = -1.57498322484;
    qf3_strength =  2.16753642533;
    qd1_strength =  0.00000000000;
    qf1_strength =  0.00000000000;

elseif strcmp(optics_mode,'M2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [10, 10];
    IniCond.alpha= [0,0];
    
    %%% Quadrupoles
    qf2_strength =  9.831704524983;
    qd2_strength = -4.217071772967;
    qf3_strength = -8.283779571728;
    qd1_strength =  0.00000000000;
    qf1_strength =  0.00000000000;
    
elseif strcmp(optics_mode,'M3')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [-1.0,-1.0];
    
    %%% Quadrupoles
    qf2_strength =  11.497289971737;
    qd2_strength =  -4.009053542903;
    qf3_strength = -10.05208966219;
    qd1_strength =   0.00000000000;
    qf1_strength =   0.00000000000;
    
elseif strcmp(optics_mode,'M4')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [1.0,1.0];
    
    %%% Quadrupoles
    qf2_strength =  3.534340054347;
    qd2_strength = -6.58275439308;
    qf3_strength =  8.590198057857;
    qd1_strength =  0.000000000000;
    qf1_strength =  0.000000000000;
    
elseif strcmp(optics_mode,'M5')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [1.0,-1.0];
    
    %%% Quadrupoles
    qf2_strength =  14.330293389213;
    qd2_strength =  -3.670822362331;
    qf3_strength = -14.999984099609;
    qd1_strength =   0.000000000000;
    qf1_strength =   0.000000000000;
    
elseif strcmp(optics_mode,'M6')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [-1.0,1.0];
    
    %%% Quadrupoles
    qf2_strength =  10.334311920772;
    qd2_strength =  -2.542582493248;
    qf3_strength = -10.124615533866;
    qd1_strength =   0.000000000000;
    qf1_strength =   0.000000000000;
    
else
    error('caso nao implementado');
end