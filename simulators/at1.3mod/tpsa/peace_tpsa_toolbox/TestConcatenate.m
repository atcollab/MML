clear all
OSIP = OSIP_Nerve(3,3,1)
X = VariablesOfTPS(TPS,1:OSIP.NumberOfVariables)
Y = VariablesOfTPS(TPS,1:OSIP.NumberOfVariables)
%for i=1:3, Y(i) = Y(i)*Y(i), end
for i=1:3, Y(i) = Y(i)^2, end
for i=1:3, Z(i) = ConcatenateTPSbyVPS(X(i),Y,0), end
for i=1:3, Y(i) = Y(i)+X(i), end
for i=1:3, Z(i) = ConcatenateTPSbyVPS(X(i),Y,0), end