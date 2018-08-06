function RINGData = locosetlatticeparam(RINGData, LocoParams, LocoValues)
%LOCOSETLATTICEPARAM - Set the AT lattice from the LOCO fit parameters
%  RINGData = locosetlatticeparam(RINGData, LocoParams, LocoValues)
%
%  This function is shortcut to the AT function setparamgroup 

RINGData.Lattice = setparamgroup(RINGData.Lattice, LocoParams, LocoValues);