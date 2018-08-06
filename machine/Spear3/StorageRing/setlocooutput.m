function setlocooutput(FileName)

if nargin == 0
    [FileName, DirectoryName] = uigetfile('*.mat', 'LOCO Output File Name?');
    if FileName == 0
        fprintf('   setlocooutput canceled\n');
        return
    end
    FileName = [DirectoryName FileName];
end

load(FileName);  
le = length(FitParameters);

QFscale(1:6) = FitParameters(1).Values(1)/FitParameters(le).Values(1);
QFscale(7:28) = FitParameters(1).Values(2:23)./FitParameters(le).Values(2:23);
QDscale(1:6) = FitParameters(1).Values(24)/FitParameters(le).Values(24);
QDscale(7:28) = FitParameters(1).Values(25:46)./FitParameters(le).Values(25:46);
QFCscale = FitParameters(1).Values(47)/FitParameters(le).Values(47);
QDXscale = FitParameters(1).Values(48)/FitParameters(le).Values(48);
QFXscale = FitParameters(1).Values(49)/FitParameters(le).Values(49);
QDYscale = FitParameters(1).Values(50)/FitParameters(le).Values(50);
QFYscale = FitParameters(1).Values(51)/FitParameters(le).Values(51);
QDZscale = FitParameters(1).Values(52)/FitParameters(le).Values(52);
QFZscale = FitParameters(1).Values(53)/FitParameters(le).Values(53);


% According the Jacky's fit (Q:\Groups\Accel\Controls\matlab\machine\spear3data\Loco\2004-01-07\Jacky) 
% K/I = 0.00245246 1/(m^2*A)
SkewQuad = FitParameters(le).Values(54:end);
SkewQuadnew = SkewQuad / 0.00245246;
% dialog box to apply?
%stepsp('SkewQuad', SkewQuadnew);   % Should this be -SkewQuadnew???



QFnew  = QFscale'.*getsp('QF');
QDnew  = QDscale'.*getsp('QD');
QFCnew = QFCscale*getsp('QFC');
QDXnew = QDXscale*getsp('QDX');
QFXnew = QFXscale*getsp('QFX');
QDYnew = QDYscale*getsp('QDY');
QFYnew = QFYscale*getsp('QFY');
QDZnew = QDZscale*getsp('QDZ');
QFZnew = QFZscale*getsp('QFZ');


setsp('QF', QFnew);
setsp('QD', QDnew);
setsp('QFC', QFCnew);

setsp('QFX', QFXnew);
setsp('QFY', QFYnew);
setsp('QFZ', QFZnew);

setsp('QDX', QDXnew);
setsp('QDY', QDYnew);
setsp('QDZ', QDZnew);

