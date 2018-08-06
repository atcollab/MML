if 0
    % Save nominal
    
end

totalscale = 1;
scale = 0.5;

% 
% % use first dipole to generate scaling factor for rest of the magnets
% pvhandle = mcaopen('PS-B-A-1-1:CURRENT_SP');
% mcaput(pvha% mcaput(pvhandle,dipole_val);
% mcaclose(pvhandle);

pvhandles = {};
pvnames = {...
    'PS-B-A-1-1:CURRENT_SP',...
    'PS-B-A-1-2:CURRENT_SP',...
    'PS-B-B-1:CURRENT_SP'};
pvvalues = {};
for i=1:3
    pvhandles{i} = mcaopen(pvnames{i});
    pvvalues{i} = mcaget(pvhandles{i})*scale;
end
mcaput(pvhandles,pvvalues);
mcaclose(pvhandles);

pvhandles = {};
pvvalues = {};
for i=1:11
    pvhandles{i} = mcaopen(sprintf('PS-Q-1-%1d:CURRENT_SP',i));
    pvvalues{i} = mcaget(pvhandles{i}).*scale;
end
mcaput(pvhandles,pvvalues);
mcaclose(pvhandles);

pvhandles = {};
pvvalues = {};
for i=1:2
    pvhandles{i} = mcaopen(sprintf('PS-OCH-A-1-%1d:CURRENT_SP',i));
    pvvalues{i} = mcaget(pvhandles{i}).*scale;
end
mcaput(pvhandles,pvvalues);
mcaclose(pvhandles);

pvhandles = {};
pvvalues = {};
for i=1:4
    pvhandles{i} = mcaopen(sprintf('PS-OCV-A-1-%1d:CURRENT_SP',i));
    pvvalues{i} = mcaget(pvhandles{i}).*scale;
end
mcaput(pvhandles,pvvalues);
mcaclose(pvhandles);

pvhandles = {};
pvvalues = {};
for i=1:1
    pvhandles{i} = mcaopen(sprintf('PS-SEI-2:CURRENT_SP',i));
    pvvalues{i} = mcaget(pvhandles{i}).*scale;
end
mcaput(pvhandles,pvvalues);
mcaclose(pvhandles);
