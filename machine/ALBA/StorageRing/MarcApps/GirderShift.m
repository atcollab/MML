function GirderShift(StartIndx, EndIndx, DX, DY)
global THERING
for i=StartIndx:EndIndx
   V = zeros(1,6);
   V(1) = DX;
   V(3) = DY;
   THERING{i}.T1 =  V;
   THERING{i}.T2 = -V;
end