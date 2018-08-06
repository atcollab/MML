function [Sector, Nsectors, Ndevices] = sectorticks(List)
%SECTORTICK - Returns a vector of positions by sector
%  [Sector, Nsectors, Ndevices] = sectorticks(DeviceList)
%  This function needs work to be useful!!!

Nsectors = max(List(:,1));
Ndevices = max(List(:,2));
Sector = List(:,1) + List(:,2)/Ndevices - 1/Ndevices/2;
