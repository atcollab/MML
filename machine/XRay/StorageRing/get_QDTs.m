function [dI_qdts] = get_QDTs(file_name)

p = load(file_name)
k_qds = p.FitParameters(end).Values(4:11)
k_m = mean(k_qds)
dk_qds = k_m - k_qds
%I0_qd = getam('QD', [1 1])
I0_qd = 233.50
%I0_qdts = getam('QDT')
I0_qdts = [-9.64; 5.11; 4.36; 0.58; 9.44; 0.09; -4.65; 5.20];
%I0_qdts = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
I0_qds = I0_qd + I0_qdts;
alpha_m = k_m/mean(I0_qds);
s = sprintf('Avg. calibr. coeff.: %6.4f', alpha_m); disp(s);
for i = 1:8
    dI_qdts(i, 1) = dk_qds(i)/k_qds(i)*I0_qds(i) + I0_qdts(i);
end
dI_qdts
dI_min = min(dI_qdts); dI_max = max(dI_qdts);
offs = (dI_max+dI_min)/2.0
dI_qdts = dI_qdts - offs
%dI_qdts = dI_qdts*10.0/max(dI_qdts)