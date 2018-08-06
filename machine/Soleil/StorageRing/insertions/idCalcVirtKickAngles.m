function [outKicksX, outKicksZ] = idCalcVirtKickAngles(mOrbDistX, mOrbDistZ, vOrigX, vOrigZ)

vCurX = getx;
vCurZ = getz;
vDelX = vCurX - vOrigX;
vDelZ = vCurZ - vOrigZ;

outKicksX = idLeastSqLinFit(mOrbDistX, vDelX);
outKicksZ = idLeastSqLinFit(mOrbDistZ, vDelZ);
