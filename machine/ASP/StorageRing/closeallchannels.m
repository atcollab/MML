mcahandles = mcaopen;

for i=1:length(mcahandles)
    mcaclose(mcahandles(i));
end
mcaexit;

clear mcahandles;