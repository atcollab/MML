function configcyclecurve(family, curve)

%%
% 
error('Expert: Do not use this function')

AO = getao;

fam = 'QP';
fam = 'CV';

k= 1;

if strcmpi(fam, 'CV') || strcmpi(fam, 'CH') 
    rtag = 'C[H,V]';
elseif strcmpi(fam, 'QP') 
    rtag = 'Q';
elseif strcmpi(fam, 'BEND') 
    rtag = 'D';    
end

for k = 1:length(AO.(fam).DeviceName)
    dev_name = AO.(fam).DeviceName{k};
    idx = regexpi(dev_name,rtag);
%     idx = regexpi(dev_name,'Q');

    dev_cycle = [dev_name(1:idx-1) 'cycle' dev_name(idx:end)];

    prop_name = {'AttributeProxyRead','AttributeProxyWrite', 'Iterations'};
    prop = tango_get_properties2(dev_cycle,prop_name);
    prop(1).value = {AO.(fam).Monitor.TangoNames{k}};
    prop(2).value = prop(1).value;
    prop(3).value = {'1'};
    tango_put_properties2(dev_cycle,prop);
end
