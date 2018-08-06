function outModelData = idReadElecBeamModel(dir)

if(strcmp(dir, '') == 0) %read the data from disk
    dirStart = pwd;
	cd(dir);

    load('BtX');
    load('BtZ');
    load('AlpX');
    load('AlpZ');
    load('EtaX');
    load('EtaZ');
    load('PhX');
    load('PhZ');
    load('NuXZ');

    cd(dirStart);
else
%recalculate (?) or extract data from Laurent's functions
%assuming you're in Control Room and soleilinit was executed
    [Btx, Btz] = modelbeta('BPMx');
    [Alpx, Alpz] = modeltwiss('alpha', 'BPMx');
    [Etax, Etaz] = modeldisp('BPMx');
    [Phx, Phz] = modelphase('BPMx');
    Nuxz = modeltune;
end

outModelData.Btx = Btx;
outModelData.Btz = Btz;
outModelData.Alpx = Alpx;
outModelData.Alpz = Alpz;
outModelData.Etax = Etax;
outModelData.Etaz = Etaz;
outModelData.Phx = Phx;
outModelData.Phz = Phz;
outModelData.Nuxz = Nuxz;

outModelData.circ = 354;  %how to read this from the model?
outModelData.alp1 = 0.0004;
outModelData.E = 2.75; 