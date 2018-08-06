function ConfigSeq = mkconfigramp(CNF1,CNF2,NSTEPS,FIELDS)
% !!! Work in progress, A.T. 2-22-04
%MKCONFIGRAMP creates a sequence of machine configurations
% between CNF1 and CNF2 for a linear ramp in NSTEPS
% FIELDS (default - all) specifies which AO fields change

ConfigSeq = cell(1,NSTEPS+1);

for i = 1:length(FIELDS)
    ConfigSeq{1}.(FIELDS{i}) = CNF1.(FIELDS{i});
    ConfigSeq{end}.(FIELDS{i}) = CNF2.(FIELDS{i});
    
    START = CNF1.(FIELDS{i}).Data;
    STOP  = CNF2.(FIELDS{i}).Data;
    STEP  = (STOP-START)/NSTEPS;
    for j = 1:NSTEPS-1
        ConfigSeq{j+1}.(FIELDS{i}).Data = START + j*STEP;
    end
end
        