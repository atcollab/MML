function randvcm(mrkick)
%randvcm(mrkick): seed VCM correctors with random kicks, sigma=mrkick (mrad)
%SIMULATION ONLY

if nargin==0
    error('No input arguement supplied (mrad)')
end

AO=getappdata(0,'AcceleratorObjects');
n=isfamily('VCM');
mode=AO{n}.Mode;
AO{n}.Mode='Simulator';
setappdata(0,'AcceleratorObjects',AO);


mrkick=mrkick/1000;
setsp(AO{n}, randn(size(AO{n}.DeviceList,1),1)*mrkick);


AO{n}.Mode=mode;
setappdata(0,'AcceleratorObjects',AO);
