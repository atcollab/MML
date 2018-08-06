function plsinit(OperationalMode)
%PLSINIT - MML initialization program


if nargin < 1
    OperationalMode = 1;
end


% Clear AO
setao([]); 

Mode = 'Online';


%=============================================
%BPM data: status field designates if BPM in use
%=============================================
ntbpm=108;
AO.BPMx.FamilyName               = 'BPMx';
AO.BPMx.MemberOf                 = {'PlotFamily'; 'BPM'; 'HBPM';};
AO.BPMx.Monitor.Mode             = Mode;
AO.BPMx.Monitor.DataType         = 'Scalar';
AO.BPMx.Monitor.Units            = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'meter';

AO.BPMy.FamilyName               = 'BPMy';
AO.BPMy.MemberOf                 = {'PlotFamily'; 'BPM'; 'VBPM';};
AO.BPMy.Monitor.Mode             = Mode;
AO.BPMy.Monitor.DataType         = 'Scalar';
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'meter';

% x-name              x-chname       xstat y-name       y-chname             ystat DevList  Elem   Type 
%                                                                                              (Bergoz/Ecotek)
bpm={
 '1BPM1   '    'SR12:BPM01:AVG:2x   '  0  '1BPM1   '    'SR12:BPM01:AVG:2y   '  0  [1 ,1]    1    'B'    ; ...
 '1BPM2   '    'SR12:BPM01:AVG:3x   '  1  '1BPM2   '    'SR12:BPM01:AVG:3y   '  1  [1 ,2]    2    'B'    ; ...
 '1BPM3   '    'SR01:BPM01:AVG:4x   '  1  '1BPM3   '    'SR01:BPM01:AVG:4y   '  1  [1 ,3]    3    'B'    ; ...
 '1BPM4   '    'SR01:BPM01:AVG:5x   '  1  '1BPM4   '    'SR01:BPM01:AVG:5y   '  1  [1 ,4]    4    'B'    ; ...
 '1BPM5   '    'SR01:BPM01:AVG:6x   '  1  '1BPM5   '    'SR01:BPM01:AVG:6y   '  1  [1 ,5]    5    'B'    ; ...
 '1BPM6   '    'SR01:BPM01:AVG:7x   '  1  '1BPM6   '    'SR01:BPM01:AVG:7y   '  1  [1 ,6]    6    'B'    ; ...
 '1BPM7   '    'SR01:BPM01:AVG:8x   '  1  '1BPM7   '    'SR01:BPM01:AVG:8y   '  1  [1 ,7]    7    'B'    ; ...
 '1BPM8   '    'SR01:BPM01:AVG:9x   '  1  '1BPM8   '    'SR01:BPM01:AVG:9y   '  1  [1 ,8]    8    'B'    ; ...
 '1BPM9   '    'SR01:BPM02:AVG:1x   '  1  '1BPM9   '    'SR01:BPM02:AVG:1y   '  1  [1 ,9]    9    'B'    ; ...
 '2BPM1   '    'SR01:BPM02:AVG:2x   '  1  '2BPM1   '    'SR01:BPM02:AVG:2y   '  1  [2 ,1]   10    'B'    ; ...
 '2BPM2   '    'SR01:BPM02:AVG:3x   '  1  '2BPM2   '    'SR01:BPM02:AVG:3y   '  1  [2 ,2]   11    'B'    ; ...
 '2BPM3   '    'SR02:BPM02:AVG:4x   '  1  '2BPM3   '    'SR02:BPM02:AVG:4y   '  1  [2 ,3]   12    'B'    ; ...
 '2BPM4   '    'SR02:BPM02:AVG:5x   '  1  '2BPM4   '    'SR02:BPM02:AVG:5y   '  1  [2 ,4]   13    'B'    ; ...
 '2BPM5   '    'SR02:BPM02:AVG:6x   '  1  '2BPM5   '    'SR02:BPM02:AVG:6y   '  1  [2 ,5]   14    'B'    ; ...
 '2BPM6   '    'SR02:BPM02:AVG:7x   '  1  '2BPM6   '    'SR02:BPM02:AVG:7y   '  1  [2 ,6]   15    'B'    ; ...
 '2BPM7   '    'SR02:BPM02:AVG:8x   '  1  '2BPM7   '    'SR02:BPM02:AVG:8y   '  1  [2 ,7]   16    'B'    ; ...
 '2BPM8   '    'SR02:BPM02:AVG:9x   '  1  '2BPM8   '    'SR02:BPM02:AVG:9y   '  1  [2 ,8]   17    'B'    ; ...
 '2BPM9   '    'SR02:BPM03:AVG:1x   '  0  '2BPM9   '    'SR02:BPM03:AVG:1y   '  0  [2 ,9]   18    'B'    ; ...
 '3BPM1   '    'SR02:BPM03:AVG:2x   '  1  '3BPM1   '    'SR02:BPM03:AVG:2y   '  1  [3 ,1]   19    'B'    ; ...
 '3BPM2   '    'SR02:BPM03:AVG:3x   '  1  '3BPM2   '    'SR02:BPM03:AVG:3y   '  1  [3 ,2]   20    'B'    ; ...
 '3BPM3   '    'SR03:BPM03:AVG:4x   '  1  '3BPM3   '    'SR03:BPM03:AVG:4y   '  1  [3 ,3]   21    'B'    ; ...
 '3BPM4   '    'SR03:BPM03:AVG:5x   '  1  '3BPM4   '    'SR03:BPM03:AVG:5y   '  1  [3 ,4]   22    'B'    ; ...
 '3BPM5   '    'SR03:BPM03:AVG:6x   '  1  '3BPM5   '    'SR03:BPM03:AVG:6y   '  1  [3 ,5]   23    'B'    ; ...
 '3BPM6   '    'SR03:BPM03:AVG:7x   '  1  '3BPM6   '    'SR03:BPM03:AVG:7y   '  1  [3 ,6]   24    'B'    ; ...
 '2BPM7   '    'SR03:BPM03:AVG:8x   '  1  '2BPM7   '    'SR03:BPM03:AVG:8y   '  1  [3 ,7]   25    'B'    ; ...
 '2BPM8   '    'SR03:BPM03:AVG:9x   '  1  '2BPM8   '    'SR03:BPM03:AVG:9y   '  1  [3 ,8]   26    'B'    ; ...
 '2BPM9   '    'SR03:BPM04:AVG:1x   '  1  '2BPM9   '    'SR03:BPM04:AVG:1y   '  1  [3 ,9]   27    'B'    ; ...
 '4BPM1   '    'SR03:BPM04:AVG:2x   '  1  '4BPM1   '    'SR03:BPM04:AVG:2y   '  1  [4 ,1]   28    'B'    ; ...
 '4BPM2   '    'SR03:BPM04:AVG:3x   '  0  '4BPM2   '    'SR03:BPM04:AVG:3y   '  0  [4 ,2]   29    'B'    ; ...
 '4BPM3   '    'SR04:BPM04:AVG:4x   '  1  '4BPM3   '    'SR04:BPM04:AVG:4y   '  1  [4 ,3]   30    'B'    ; ...
 '4BPM4   '    'SR04:BPM04:AVG:5x   '  1  '4BPM4   '    'SR04:BPM04:AVG:5y   '  1  [4 ,4]   31    'B'    ; ...
 '4BPM5   '    'SR04:BPM04:AVG:6x   '  1  '4BPM5   '    'SR04:BPM04:AVG:6y   '  1  [4 ,5]   32    'B'    ; ...
 '4BPM6   '    'SR04:BPM04:AVG:7x   '  1  '4BPM6   '    'SR04:BPM04:AVG:7y   '  1  [4 ,6]   33    'B'    ; ...
 '4BPM7   '    'SR04:BPM04:AVG:8x   '  1  '4BPM7   '    'SR04:BPM04:AVG:8y   '  1  [4 ,7]   34    'B'    ; ...
 '4BPM8   '    'SR04:BPM04:AVG:9x   '  1  '4BPM8   '    'SR04:BPM04:AVG:9y   '  1  [4 ,8]   35    'B'    ; ...
 '4BPM9   '    'SR04:BPM05:AVG:1x   '  1  '4BPM9   '    'SR04:BPM05:AVG:1y   '  1  [4 ,9]   36    'B'    ; ...
 '5BPM1   '    'SR04:BPM05:AVG:2x   '  1  '5BPM1   '    'SR04:BPM05:AVG:2y   '  1  [5 ,1]   37    'B'    ; ...
 '5BPM2   '    'SR04:BPM05:AVG:3x   '  1  '5BPM2   '    'SR04:BPM05:AVG:3y   '  1  [5 ,2]   38    'B'    ; ...
 '5BPM3   '    'SR05:BPM05:AVG:4x   '  1  '5BPM3   '    'SR05:BPM05:AVG:4y   '  1  [5 ,3]   39    'B'    ; ...
 '5BPM4   '    'SR05:BPM05:AVG:5x   '  1  '5BPM4   '    'SR05:BPM05:AVG:5y   '  1  [5 ,4]   40    'B'    ; ...
 '5BPM5   '    'SR05:BPM05:AVG:6x   '  1  '5BPM5   '    'SR05:BPM05:AVG:6y   '  1  [5 ,5]   41    'B'    ; ...
 '5BPM6   '    'SR05:BPM05:AVG:7x   '  1  '5BPM6   '    'SR05:BPM05:AVG:7y   '  1  [5 ,6]   42    'B'    ; ...
 '5BPM7   '    'SR05:BPM05:AVG:8x   '  1  '5BPM7   '    'SR05:BPM05:AVG:8y   '  1  [5 ,7]   43    'B'    ; ...
 '5BPM8   '    'SR05:BPM05:AVG:9x   '  0  '5BPM8   '    'SR05:BPM05:AVG:9y   '  0  [5 ,8]   44    'B'    ; ...
 '5BPM9   '    'SR05:BPM06:AVG:1x   '  1  '5BPM9   '    'SR05:BPM06:AVG:1y   '  1  [5 ,9]   45    'B'    ; ...
 '6BPM1   '    'SR05:BPM06:AVG:2x   '  1  '6BPM1   '    'SR05:BPM06:AVG:2y   '  1  [6 ,1]   46    'B'    ; ...
 '6BPM2   '    'SR05:BPM06:AVG:3x   '  1  '6BPM2   '    'SR05:BPM06:AVG:3y   '  1  [6 ,2]   47    'B'    ; ...
 '6BPM3   '    'SR06:BPM06:AVG:4x   '  1  '6BPM3   '    'SR06:BPM06:AVG:4y   '  1  [6 ,3]   48    'B'    ; ...
 '6BPM4   '    'SR06:BPM06:AVG:5x   '  1  '6BPM4   '    'SR06:BPM06:AVG:5y   '  1  [6 ,4]   49    'B'    ; ...
 '6BPM5   '    'SR06:BPM06:AVG:6x   '  1  '6BPM5   '    'SR06:BPM06:AVG:6y   '  1  [6 ,5]   50    'B'    ; ...
 '6BPM6   '    'SR06:BPM06:AVG:7x   '  1  '6BPM6   '    'SR06:BPM06:AVG:7y   '  1  [6 ,6]   51    'B'    ; ...
 '6BPM7   '    'SR06:BPM06:AVG:8x   '  1  '6BPM7   '    'SR06:BPM06:AVG:8y   '  1  [6 ,7]   52    'B'    ; ...
 '6BPM8   '    'SR06:BPM06:AVG:9x   '  1  '6BPM8   '    'SR06:BPM06:AVG:9y   '  1  [6 ,8]   53    'B'    ; ...
 '6BPM9   '    'SR06:BPM07:AVG:1x   '  1  '6BPM9   '    'SR06:BPM07:AVG:1y   '  1  [6 ,9]   54    'B'    ; ...
 '7BPM1   '    'SR06:BPM07:AVG:2x   '  1  '7BPM1   '    'SR06:BPM07:AVG:2y   '  1  [7 ,1]   55    'B'    ; ...
 '7BPM2   '    'SR06:BPM07:AVG:3x   '  1  '7BPM2   '    'SR06:BPM07:AVG:3y   '  1  [7 ,2]   56    'B'    ; ...
 '7BPM3   '    'SR07:BPM07:AVG:4x   '  1  '7BPM3   '    'SR07:BPM07:AVG:4y   '  1  [7 ,3]   57    'B'    ; ...
 '7BPM4   '    'SR07:BPM07:AVG:5x   '  1  '7BPM4   '    'SR07:BPM07:AVG:5y   '  1  [7 ,4]   58    'B'    ; ...
 '7BPM5   '    'SR07:BPM07:AVG:6x   '  1  '7BPM5   '    'SR07:BPM07:AVG:6y   '  1  [7 ,5]   59    'B'    ; ...
 '7BPM6   '    'SR07:BPM07:AVG:7x   '  1  '7BPM6   '    'SR07:BPM07:AVG:7y   '  1  [7 ,6]   60    'B'    ; ...
 '7BPM7   '    'SR07:BPM07:AVG:8x   '  1  '7BPM7   '    'SR07:BPM07:AVG:8y   '  1  [7 ,7]   61    'B'    ; ...
 '7BPM8   '    'SR07:BPM07:AVG:9x   '  1  '7BPM8   '    'SR07:BPM07:AVG:9y   '  1  [7 ,8]   62    'B'    ; ...
 '7BPM9   '    'SR07:BPM08:AVG:1x   '  1  '7BPM9   '    'SR07:BPM08:AVG:1y   '  1  [7 ,9]   63    'B'    ; ...
 '8BPM1   '    'SR07:BPM08:AVG:2x   '  1  '8BPM1   '    'SR07:BPM08:AVG:2y   '  1  [8 ,1]   64    'B'    ; ...
 '8BPM2   '    'SR07:BPM08:AVG:3x   '  1  '8BPM2   '    'SR07:BPM08:AVG:3y   '  1  [8 ,2]   65    'B'    ; ...
 '8BPM3   '    'SR08:BPM08:AVG:4x   '  1  '8BPM3   '    'SR08:BPM08:AVG:4y   '  1  [8 ,3]   66    'B'    ; ...
 '8BPM4   '    'SR08:BPM08:AVG:5x   '  1  '8BPM4   '    'SR08:BPM08:AVG:5y   '  1  [8 ,4]   67    'B'    ; ...
 '8BPM5   '    'SR08:BPM08:AVG:6x   '  1  '8BPM5   '    'SR08:BPM08:AVG:6y   '  1  [8 ,5]   68    'B'    ; ...
 '8BPM6   '    'SR08:BPM08:AVG:7x   '  1  '8BPM6   '    'SR08:BPM08:AVG:7y   '  1  [8 ,6]   69    'B'    ; ...
 '8BPM7   '    'SR08:BPM08:AVG:8x   '  1  '8BPM7   '    'SR08:BPM08:AVG:8y   '  1  [8 ,7]   70    'B'    ; ...
 '8BPM8   '    'SR08:BPM08:AVG:9x   '  1  '8BPM8   '    'SR08:BPM08:AVG:9y   '  1  [8 ,8]   71    'B'    ; ...
 '8BPM9   '    'SR08:BPM09:AVG:1x   '  1  '8BPM9   '    'SR08:BPM09:AVG:1y   '  1  [8 ,9]   72    'B'    ; ...
 '9BPM1   '    'SR08:BPM09:AVG:2x   '  1  '9BPM1   '    'SR08:BPM09:AVG:2y   '  1  [9 ,1]   73    'B'    ; ...
 '9BPM2   '    'SR08:BPM09:AVG:3x   '  1  '9BPM2   '    'SR08:BPM09:AVG:3y   '  1  [9 ,2]   74    'B'    ; ...
 '9BPM3   '    'SR09:BPM09:AVG:4x   '  1  '9BPM3   '    'SR09:BPM09:AVG:4y   '  1  [9 ,3]   75    'B'    ; ...
 '9BPM4   '    'SR09:BPM09:AVG:5x   '  1  '9BPM4   '    'SR09:BPM09:AVG:5y   '  1  [9 ,4]   76    'B'    ; ...
 '9BPM5   '    'SR09:BPM09:AVG:6x   '  1  '9BPM5   '    'SR09:BPM09:AVG:6y   '  1  [9 ,5]   77    'B'    ; ...
 '9BPM6   '    'SR09:BPM09:AVG:7x   '  1  '9BPM6   '    'SR09:BPM09:AVG:7y   '  1  [9 ,6]   78    'B'    ; ...
 '9BPM7   '    'SR09:BPM09:AVG:8x   '  1  '9BPM7   '    'SR09:BPM09:AVG:8y   '  1  [9 ,7]   79    'B'    ; ...
 '9BPM8   '    'SR09:BPM09:AVG:9x   '  1  '9BPM8   '    'SR09:BPM09:AVG:9y   '  1  [9 ,8]   80    'B'    ; ...
 '9BPM9   '    'SR09:BPM10:AVG:1x   '  1  '9BPM9   '    'SR09:BPM10:AVG:1y   '  1  [9 ,9]   81    'B'    ; ...
 '10BPM1  '    'SR09:BPM10:AVG:2x   '  1  '10BPM1  '    'SR09:BPM10:AVG:2y   '  1  [10,1]   82    'B'    ; ...
 '10BPM2  '    'SR09:BPM10:AVG:3x   '  1  '10BPM2  '    'SR09:BPM10:AVG:3y   '  1  [10,2]   83    'B'    ; ...
 '10BPM3  '    'SR10:BPM10:AVG:4x   '  1  '10BPM3  '    'SR10:BPM10:AVG:4y   '  1  [10,3]   84    'B'    ; ...
 '10BPM4  '    'SR10:BPM10:AVG:5x   '  1  '10BPM4  '    'SR10:BPM10:AVG:5y   '  1  [10,4]   85    'B'    ; ...
 '10BPM5  '    'SR10:BPM10:AVG:6x   '  1  '10BPM5  '    'SR10:BPM10:AVG:6y   '  1  [10,5]   86    'B'    ; ...
 '10BPM6  '    'SR10:BPM10:AVG:7x   '  1  '10BPM6  '    'SR10:BPM10:AVG:7y   '  1  [10,6]   87    'B'    ; ...
 '10BPM7  '    'SR10:BPM10:AVG:8x   '  1  '10BPM7  '    'SR10:BPM10:AVG:8y   '  1  [10,7]   88    'B'    ; ...
 '10BPM8  '    'SR10:BPM10:AVG:9x   '  1  '10BPM8  '    'SR10:BPM10:AVG:9y   '  1  [10,8]   89    'B'    ; ...
 '10BPM9  '    'SR10:BPM11:AVG:1x   '  1  '10BPM9  '    'SR10:BPM11:AVG:1y   '  1  [10,9]   90    'B'    ; ...
 '11BPM1  '    'SR10:BPM11:AVG:2x   '  1  '11BPM1  '    'SR10:BPM11:AVG:2y   '  1  [11,1]   91    'B'    ; ...
 '11BPM2  '    'SR10:BPM11:AVG:3x   '  1  '11BPM2  '    'SR10:BPM11:AVG:3y   '  1  [11,2]   92    'B'    ; ...
 '11BPM3  '    'SR11:BPM11:AVG:4x   '  1  '11BPM3  '    'SR11:BPM11:AVG:4y   '  1  [11,3]   93    'B'    ; ...
 '11BPM4  '    'SR11:BPM11:AVG:5x   '  1  '11BPM4  '    'SR11:BPM11:AVG:5y   '  1  [11,4]   94    'B'    ; ...
 '11BPM5  '    'SR11:BPM11:AVG:6x   '  0  '11BPM5  '    'SR11:BPM11:AVG:6y   '  0  [11,5]   95    'B'    ; ...
 '11BPM6  '    'SR11:BPM11:AVG:7x   '  1  '11BPM6  '    'SR11:BPM11:AVG:7y   '  1  [11,6]   96    'B'    ; ...
 '11BPM7  '    'SR11:BPM11:AVG:8x   '  1  '11BPM7  '    'SR11:BPM11:AVG:8y   '  1  [11,7]   97    'B'    ; ...
 '11BPM8  '    'SR11:BPM11:AVG:9x   '  0  '11BPM8  '    'SR11:BPM11:AVG:9y   '  0  [11,8]   98    'B'    ; ...
 '11BPM9  '    'SR11:BPM12:AVG:1x   '  1  '11BPM9  '    'SR11:BPM12:AVG:1y   '  1  [11,9]   99    'B'    ; ...
 '12BPM1  '    'SR11:BPM12:AVG:2x   '  1  '12BPM1  '    'SR11:BPM12:AVG:2y   '  1  [12,1]  100    'B'    ; ...
 '12BPM2  '    'SR11:BPM12:AVG:3x   '  1  '12BPM2  '    'SR11:BPM12:AVG:3y   '  1  [12,2]  101    'B'    ; ...
 '12BPM3  '    'SR12:BPM12:AVG:4x   '  1  '12BPM3  '    'SR12:BPM12:AVG:4y   '  1  [12,3]  102    'B'    ; ...
 '12BPM4  '    'SR12:BPM12:AVG:5x   '  1  '12BPM4  '    'SR12:BPM12:AVG:5y   '  1  [12,4]  103    'B'    ; ...
 '12BPM5  '    'SR12:BPM12:AVG:6x   '  1  '12BPM5  '    'SR12:BPM12:AVG:6y   '  1  [12,5]  104    'B'    ; ...
 '12BPM6  '    'SR12:BPM12:AVG:7x   '  1  '12BPM6  '    'SR12:BPM12:AVG:7y   '  1  [12,6]  105    'B'    ; ...
 '12BPM7  '    'SR12:BPM12:AVG:8x   '  1  '12BPM7  '    'SR12:BPM12:AVG:8y   '  1  [12,7]  106    'B'    ; ...
 '12BPM8  '    'SR12:BPM12:AVG:9x   '  1  '12BPM8  '    'SR12:BPM12:AVG:9y   '  1  [12,8]  107    'B'    ; ...
 '12BPM9  '    'SR12:BPM01:AVG:1x   '  1  '12BPM9  '    'SR12:BPM01:AVG:1y   '  1  [12,9]  108    'B'    ; ...
};

%Load fields from data block
for ii=1:size(bpm,1)
name=bpm{ii,1};      AO.BPMx.CommonNames(ii,:)         = name;
name=bpm{ii,2};      AO.BPMx.Monitor.ChannelNames(ii,:)= name;
val =bpm{ii,3};      AO.BPMx.Status(ii,:)              = val;  
name=bpm{ii,4};      AO.BPMy.CommonNames(ii,:)         = name;
name=bpm{ii,5};      AO.BPMy.Monitor.ChannelNames(ii,:)= name;
val =bpm{ii,6};      AO.BPMy.Status(ii,:)              = val;  
val =bpm{ii,7};      AO.BPMx.DeviceList(ii,:)          = val;   
                     AO.BPMy.DeviceList(ii,:)          = val;
val =bpm{ii,8};      AO.BPMx.ElementList(ii,:)         = val;   
                     AO.BPMy.ElementList(ii,:)         = val;
                     AO.BPMx.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
                     AO.BPMx.Monitor.Physics2HWParams(ii,:) = 1000;
                     AO.BPMy.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
                     AO.BPMy.Monitor.Physics2HWParams(ii,:) = 1000;
end

AO.BPMx.Status = AO.BPMx.Status(:);
AO.BPMy.Status = AO.BPMy.Status(:);



%===========================================================
%Corrector data: status field designates if corrector in use
%===========================================================
AO.HCM.FamilyName               = 'HCM';
AO.HCM.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'HCM'; 'Magnet'};

AO.HCM.Monitor.Mode             = Mode;
AO.HCM.Monitor.DataType         = 'Scalar';
AO.HCM.Monitor.Units            = 'Hardware';
AO.HCM.Monitor.HWUnits          = 'ampere';           
AO.HCM.Monitor.PhysicsUnits     = 'radian';
AO.HCM.Monitor.HW2PhysicsFcn = @amp2k;
AO.HCM.Monitor.Physics2HWFcn = @k2amp;

AO.HCM.Setpoint.Mode            = Mode;
AO.HCM.Setpoint.DataType        = 'Scalar';
AO.HCM.Setpoint.Units           = 'Hardware';
AO.HCM.Setpoint.HWUnits         = 'ampere';           
AO.HCM.Setpoint.PhysicsUnits    = 'radian';
AO.HCM.Setpoint.HW2PhysicsFcn = @amp2k;
AO.HCM.Setpoint.Physics2HWFcn = @k2amp;


AO.VCM.FamilyName               = 'VCM';
AO.VCM.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'COR'; 'VCM'; 'Magnet'};

AO.VCM.Monitor.Mode             = Mode;
AO.VCM.Monitor.DataType         = 'Scalar';
AO.VCM.Monitor.Units            = 'Hardware';
AO.VCM.Monitor.HWUnits          = 'ampere';           
AO.VCM.Monitor.PhysicsUnits     = 'radian';
AO.VCM.Monitor.HW2PhysicsFcn = @amp2k;
AO.VCM.Monitor.Physics2HWFcn = @k2amp;

AO.VCM.Setpoint.Mode            = Mode;
AO.VCM.Setpoint.DataType        = 'Scalar';
AO.VCM.Setpoint.Units           = 'Hardware';
AO.VCM.Setpoint.HWUnits         = 'ampere';           
AO.VCM.Setpoint.PhysicsUnits    = 'radian';
AO.VCM.Setpoint.HW2PhysicsFcn = @amp2k;
AO.VCM.Setpoint.Physics2HWFcn = @k2amp;

% HW in ampere, Physics in radian                                                                                                      ** radian units converted to ampere below ***
%x-common             x-monitor           x-setpoint            xstat y-common           y-monitor              y-setpoint           ystat devlist elem   range        tol   x-kick   y-kick    y-phot   H2P_X          P2H_X        H2P_Y        P2H_Y 
%not used                                                           not used                                                                            Not Used   Not Used  ---------------> Not Used                   
HCMGain = NaN; 
VCMGain = NaN;  % Not used
cor={
 '1CX3    ' 'SR12:P01CH3:aiReadBack ' 'SR12:P01CH3:setCurrent '  1  '1CY3    ' 'DP-S12:P01CV3:I   '        'DP-S12:P01CV3:SETI    '  1   [1 ,3]  1  [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '1CX4    ' 'SR01:P01CH4:aiReadBack ' 'SR01:P01CH4:setCurrent '  1  '1CY4    ' 'DP-S01:P01CV4:I   '        'DP-S01:P01CV4:SETI    '  1   [1 ,4]  2  [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '1CX5    ' 'SR01:P01CH5:aiReadBack ' 'SR01:P01CH5:setCurrent '  1  '1CY5    ' 'DP-S01:P01CV5:I   '        'DP-S01:P01CV5:SETI    '  1   [1 ,5]  3  [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '1CX6    ' 'SR01:P01CH6:aiReadBack ' 'SR01:P01CH6:setCurrent '  1  '1CY6    ' 'DP-S01:P01CV6:I   '        'DP-S01:P01CV6:SETI    '  1   [1 ,6]  4  [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX1    ' 'SR01:P02CH1:rdbkCurrent' 'SR01:P02CH1:set24Bit   '  1  '2CY1    ' 'DP-S01:P02CV1:I   '        'DP-S01:P02CV1:SETI    '  1   [2 ,1]  5  [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX2    ' 'SR01:P02CH2:rdbkCurrent' 'SR01:P02CH2:set24Bit   '  1  '2CY2    ' 'DP-S01:P02CV2:I   '        'DP-S01:P02CV2:SETI    '  1   [2 ,2]  6  [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX3    ' 'SR01:P02CH3:aiReadBack ' 'SR01:P02CH3:setCurrent '  1  '2CY3    ' 'DP-S01:P02CV3:I   '        'DP-S01:P02CV3:SETI    '  1   [2 ,3]  7  [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX4    ' 'SR02:P02CH4:aiReadBack ' 'SR02:P02CH4:setCurrent '  1  '2CY4    ' 'DP-S02:P02CV4:I   '        'DP-S02:P02CV4:SETI    '  1   [2 ,4]  8  [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX5    ' 'SR02:P02CH5:aiReadBack ' 'SR02:P02CH5:setCurrent '  1  '2CY5    ' 'DP-S02:P02CV5:I   '        'DP-S02:P02CV5:SETI    '  1   [2 ,5]  9  [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '2CX6    ' 'SR02:P02CH6:aiReadBack ' 'SR02:P02CH6:setCurrent '  1  '2CY6    ' 'DP-S02:P02CV6:I   '        'DP-S02:P02CV6:SETI    '  1   [2 ,6]  10 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX1    ' 'SR02:P03CH1:rdbkCurrent' 'SR02:P03CH1:set24Bit   '  1  '3CY1    ' 'DP-S02:P03CV1:I   '        'DP-S02:P03CV1:SETI    '  1   [3 ,1]  11 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX2    ' 'SR02:P03CH2:rdbkCurrent' 'SR02:P03CH2:set24Bit   '  1  '3CY2    ' 'DP-S02:P03CV2:I   '        'DP-S02:P03CV2:SETI    '  1   [3 ,2]  12 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX3    ' 'SR02:P03CH3:aiReadBack ' 'SR02:P03CH3:setCurrent '  1  '3CY3    ' 'DP-S02:P03CV3:I   '        'DP-S02:P03CV3:SETI    '  1   [3 ,3]  13 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX4    ' 'SR03:P03CH4:aiReadBack ' 'SR03:P03CH4:setCurrent '  1  '3CY4    ' 'DP-S03:P03CV4:I   '        'DP-S03:P03CV4:SETI    '  1   [3 ,4]  14 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX5    ' 'SR03:P03CH5:aiReadBack ' 'SR03:P03CH5:setCurrent '  1  '3CY5    ' 'DP-S03:P03CV5:I   '        'DP-S03:P03CV5:SETI    '  1   [3 ,5]  15 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '3CX6    ' 'SR03:P03CH6:aiReadBack ' 'SR03:P03CH6:setCurrent '  1  '3CY6    ' 'DP-S03:P03CV6:I   '        'DP-S03:P03CV6:SETI    '  1   [3 ,6]  16 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX1    ' 'SR03:P04CH1:rdbkCurrent' 'SR03:P04CH1:set24Bit   '  1  '4CY1    ' 'DP-S03:P04CV1:I   '        'DP-S03:P04CV1:SETI    '  1   [4 ,1]  17 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX2    ' 'SR03:P04CH2:rdbkCurrent' 'SR03:P04CH2:set24Bit   '  1  '4CY2    ' 'DP-S03:P04CV2:I   '        'DP-S03:P04CV2:SETI    '  1   [4 ,2]  18 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX3    ' 'SR03:P04CH3:aiReadBack ' 'SR03:P04CH3:setCurrent '  1  '4CY3    ' 'DP-S03:P04CV3:I   '        'DP-S03:P04CV3:SETI    '  1   [4 ,3]  19 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX4    ' 'SR04:P04CH4:aiReadBack ' 'SR04:P04CH4:setCurrent '  1  '4CY4    ' 'DP-S04:P04CV4:I   '        'DP-S04:P04CV4:SETI    '  1   [4 ,4]  20 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX5    ' 'SR04:P04CH5:aiReadBack ' 'SR04:P04CH5:setCurrent '  1  '4CY5    ' 'DP-S04:P04CV5:I   '        'DP-S04:P04CV5:SETI    '  1   [4 ,5]  21 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '4CX6    ' 'SR04:P04CH6:aiReadBack ' 'SR04:P04CH6:setCurrent '  1  '4CY6    ' 'DP-S04:P04CV6:I   '        'DP-S04:P04CV6:SETI    '  1   [4 ,6]  22 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX1    ' 'SR04:P05CH1:rdbkCurrent' 'SR04:P05CH1:set24Bit   '  1  '5CY1    ' 'DP-S04:P05CV1:I   '        'DP-S04:P05CV1:SETI    '  1   [5 ,1]  23 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX2    ' 'SR04:P05CH2:rdbkCurrent' 'SR04:P05CH2:set24Bit   '  1  '5CY2    ' 'DP-S04:P05CV2:I   '        'DP-S04:P05CV2:SETI    '  1   [5 ,2]  24 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX3    ' 'SR04:P05CH3:aiReadBack ' 'SR04:P05CH3:setCurrent '  1  '5CY3    ' 'DP-S04:P05CV3:I   '        'DP-S04:P05CV3:SETI    '  1   [5 ,3]  25 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX4    ' 'SR05:P05CH4:aiReadBack ' 'SR05:P05CH4:setCurrent '  1  '5CY4    ' 'DP-S05:P05CV4:I   '        'DP-S05:P05CV4:SETI    '  1   [5 ,4]  26 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX5    ' 'SR05:P05CH5:aiReadBack ' 'SR05:P05CH5:setCurrent '  1  '5CY5    ' 'DP-S05:P05CV5:I   '        'DP-S05:P05CV5:SETI    '  1   [5 ,5]  27 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '5CX6    ' 'SR05:P05CH6:aiReadBack ' 'SR05:P05CH6:setCurrent '  1  '5CY6    ' 'DP-S05:P05CV6:I   '        'DP-S05:P05CV6:SETI    '  1   [5 ,6]  28 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX1    ' 'SR05:P06CH1:rdbkCurrent' 'SR05:P06CH1:set24Bit   '  0  '6CY1    ' 'DP-S05:P06CV1:I   '        'DP-S05:P06CV1:SETI    '  1   [6 ,1]  29 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX2    ' 'SR05:P06CH2:rdbkCurrent' 'SR05:P06CH2:set24Bit   '  1  '6CY2    ' 'DP-S05:P06CV2:I   '        'DP-S05:P06CV2:SETI    '  1   [6 ,2]  30 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX3    ' 'SR05:P06CH3:aiReadBack ' 'SR05:P06CH3:setCurrent '  1  '6CY3    ' 'DP-S05:P06CV3:I   '        'DP-S05:P06CV3:SETI    '  1   [6 ,3]  31 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX4    ' 'SR06:P06CH4:aiReadBack ' 'SR06:P06CH4:setCurrent '  1  '6CY4    ' 'DP-S06:P06CV4:I   '        'DP-S06:P06CV4:SETI    '  1   [6 ,4]  32 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX5    ' 'SR06:P06CH5:aiReadBack ' 'SR06:P06CH5:setCurrent '  1  '6CY5    ' 'DP-S06:P06CV5:I   '        'DP-S06:P06CV5:SETI    '  1   [6 ,5]  33 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '6CX6    ' 'SR06:P06CH6:aiReadBack ' 'SR06:P06CH6:setCurrent '  1  '6CY6    ' 'DP-S06:P06CV6:I   '        'DP-S06:P06CV6:SETI    '  1   [6 ,6]  34 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX1    ' 'SR06:P07CH1:rdbkCurrent' 'SR06:P07CH1:set24Bit   '  1  '7CY1    ' 'DP-S06:P07CV1:I   '        'DP-S06:P07CV1:SETI    '  1   [7 ,1]  35 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX2    ' 'SR06:P07CH2:rdbkCurrent' 'SR06:P07CH2:set24Bit   '  1  '7CY2    ' 'DP-S06:P07CV2:I   '        'DP-S06:P07CV2:SETI    '  1   [7 ,2]  36 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX3    ' 'SR06:P07CH3:aiReadBack ' 'SR06:P07CH3:setCurrent '  1  '7CY3    ' 'DP-S06:P07CV3:I   '        'DP-S06:P07CV3:SETI    '  1   [7 ,3]  37 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX4    ' 'SR07:P07CH4:aiReadBack ' 'SR07:P07CH4:setCurrent '  1  '7CY4    ' 'DP-S07:P07CV4:I   '        'DP-S07:P07CV4:SETI    '  1   [7 ,4]  38 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX5    ' 'SR07:P07CH5:aiReadBack ' 'SR07:P07CH5:setCurrent '  1  '7CY5    ' 'DP-S07:P07CV5:I   '        'DP-S07:P07CV5:SETI    '  1   [7 ,5]  39 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '7CX6    ' 'SR07:P07CH6:aiReadBack ' 'SR07:P07CH6:setCurrent '  1  '7CY6    ' 'DP-S07:P07CV6:I   '        'DP-S07:P07CV6:SETI    '  1   [7 ,6]  40 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX1    ' 'SR07:P08CH1:rdbkCurrent' 'SR07:P08CH1:set24Bit   '  1  '8CY1    ' 'DP-S07:P08CV1:I   '        'DP-S07:P08CV1:SETI    '  1   [8 ,1]  41 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX2    ' 'SR07:P08CH2:rdbkCurrent' 'SR07:P08CH2:set24Bit   '  0  '8CY2    ' 'DP-S07:P08CV2:I   '        'DP-S07:P08CV2:SETI    '  1   [8 ,2]  42 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX3    ' 'SR07:P08CH3:aiReadBack ' 'SR07:P08CH3:setCurrent '  1  '8CY3    ' 'DP-S07:P08CV3:I   '        'DP-S07:P08CV3:SETI    '  1   [8 ,3]  43 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX4    ' 'SR08:P08CH4:aiReadBack ' 'SR08:P08CH4:setCurrent '  1  '8CY4    ' 'DP-S08:P08CV4:I   '        'DP-S08:P08CV4:SETI    '  1   [8 ,4]  44 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX5    ' 'SR08:P08CH5:aiReadBack ' 'SR08:P08CH5:setCurrent '  1  '8CY5    ' 'DP-S08:P08CV5:I   '        'DP-S08:P08CV5:SETI    '  1   [8 ,5]  45 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '8CX6    ' 'SR08:P08CH6:aiReadBack ' 'SR08:P08CH6:setCurrent '  1  '8CY6    ' 'DP-S08:P08CV6:I   '        'DP-S08:P08CV6:SETI    '  1   [8 ,6]  46 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX1    ' 'SR08:P09CH1:rdbkCurrent' 'SR08:P09CH1:set24Bit   '  1  '9CY1    ' 'DP-S08:P09CV1:I   '        'DP-S08:P09CV1:SETI    '  1   [9 ,1]  47 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX2    ' 'SR08:P09CH2:rdbkCurrent' 'SR08:P09CH2:set24Bit   '  1  '9CY2    ' 'DP-S08:P09CV2:I   '        'DP-S08:P09CV2:SETI    '  1   [9 ,2]  48 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX3    ' 'SR08:P09CH3:aiReadBack ' 'SR08:P09CH3:setCurrent '  1  '9CY3    ' 'DP-S08:P09CV3:I   '        'DP-S08:P09CV3:SETI    '  1   [9 ,3]  49 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX4    ' 'SR09:P09CH4:aiReadBack ' 'SR09:P09CH4:setCurrent '  1  '9CY4    ' 'DP-S09:P09CV4:I   '        'DP-S09:P09CV4:SETI    '  1   [9 ,4]  50 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX5    ' 'SR09:P09CH5:aiReadBack ' 'SR09:P09CH5:setCurrent '  1  '9CY5    ' 'DP-S09:P09CV5:I   '        'DP-S09:P09CV5:SETI    '  1   [9 ,5]  51 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '9CX6    ' 'SR09:P09CH6:aiReadBack ' 'SR09:P09CH6:setCurrent '  1  '9CY6    ' 'DP-S09:P09CV6:I   '        'DP-S09:P09CV6:SETI    '  1   [9 ,6]  52 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX1   ' 'SR09:P10CH1:rdbkCurrent' 'SR09:P10CH1:set24Bit   '  1  '10CY1   ' 'DP-S09:P10CV1:I   '        'DP-S09:P10CV1:SETI    '  1   [10,1]  53 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX2   ' 'SR09:P10CH2:rdbkCurrent' 'SR09:P10CH2:set24Bit   '  1  '10CY2   ' 'DP-S09:P10CV2:I   '        'DP-S09:P10CV2:SETI    '  1   [10,2]  54 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX3   ' 'SR09:P10CH3:aiReadBack ' 'SR09:P10CH3:setCurrent '  1  '10CY3   ' 'DP-S09:P10CV3:I   '        'DP-S09:P10CV3:SETI    '  1   [10,3]  55 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX4   ' 'SR10:P10CH4:aiReadBack ' 'SR10:P10CH4:setCurrent '  1  '10CY4   ' 'DP-S10:P10CV4:I   '        'DP-S10:P10CV4:SETI    '  1   [10,4]  56 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX5   ' 'SR10:P10CH5:aiReadBack ' 'SR10:P10CH5:setCurrent '  1  '10CY5   ' 'DP-S10:P10CV5:I   '        'DP-S10:P10CV5:SETI    '  1   [10,5]  57 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '10CX6   ' 'SR10:P10CH6:aiReadBack ' 'SR10:P10CH6:setCurrent '  1  '10CY6   ' 'DP-S10:P10CV6:I   '        'DP-S10:P10CV6:SETI    '  1   [10,6]  58 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX1   ' 'SR10:P11CH1:rdbkCurrent' 'SR10:P11CH1:set24Bit   '  1  '11CY1   ' 'DP-S10:P11CV1:I   '        'DP-S10:P11CV1:SETI    '  1   [11,1]  59 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX2   ' 'SR10:P11CH2:rdbkCurrent' 'SR10:P11CH2:set24Bit   '  1  '11CY2   ' 'DP-S10:P11CV2:I   '        'DP-S10:P11CV2:SETI    '  1   [11,2]  60 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX3   ' 'SR10:P11CH3:aiReadBack ' 'SR10:P11CH3:setCurrent '  1  '11CY3   ' 'DP-S10:P11CV3:I   '        'DP-S10:P11CV3:SETI    '  1   [11,3]  61 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX4   ' 'SR11:P11CH4:aiReadBack ' 'SR11:P11CH4:setCurrent '  1  '11CY4   ' 'DP-S11:P11CV4:I   '        'DP-S11:P11CV4:SETI    '  1   [11,4]  62 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX5   ' 'SR11:P11CH5:aiReadBack ' 'SR11:P11CH5:setCurrent '  1  '11CY5   ' 'DP-S11:P11CV5:I   '        'DP-S11:P11CV5:SETI    '  1   [11,5]  63 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '11CX6   ' 'SR11:P11CH6:aiReadBack ' 'SR11:P11CH6:setCurrent '  1  '11CY6   ' 'DP-S11:P11CV6:I   '        'DP-S11:P11CV6:SETI    '  1   [11,6]  64 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX1   ' 'SR11:P12CH1:rdbkCurrent' 'SR11:P12CH1:set24Bit   '  1  '12CY1   ' 'DP-S11:P12CV1:I   '        'DP-S11:P12CV1:SETI    '  1   [12,1]  65 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX2   ' 'SR11:P12CH2:rdbkCurrent' 'SR11:P12CH2:set24Bit   '  1  '12CY2   ' 'DP-S11:P12CV2:I   '        'DP-S11:P12CV2:SETI    '  1   [12,2]  66 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX3   ' 'SR11:P12CH3:aiReadBack ' 'SR11:P12CH3:setCurrent '  1  '12CY3   ' 'DP-S11:P12CV3:I   '        'DP-S11:P12CV3:SETI    '  1   [12,3]  67 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX4   ' 'SR12:P12CH4:aiReadBack ' 'SR12:P12CH4:setCurrent '  1  '12CY4   ' 'DP-S12:P12CV4:I   '        'DP-S12:P12CV4:SETI    '  1   [12,4]  68 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX5   ' 'SR12:P12CH5:aiReadBack ' 'SR12:P12CH5:setCurrent '  1  '12CY5   ' 'DP-S12:P12CV5:I   '        'DP-S12:P12CV5:SETI    '  1   [12,5]  69 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
 '12CX6   ' 'SR12:P12CH6:aiReadBack ' 'SR12:P12CH6:setCurrent '  1  '12CY6   ' 'DP-S12:P12CV6:I   '        'DP-S12:P12CV6:SETI    '  1   [12,6]  70 [-90.0 +90.0]  0.750  1.5e-4    1.5e-4    1e-5  [HCMGain 0]  [1/HCMGain 0]  [VCMGain 0]  [1/VCMGain 0]; ...
};

%Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset
[C, Leff, MagnetType, HCMcoefficients] = magnetcoefficients('HCM');
HCMcoefficients = [HCMcoefficients 0];
[C, Leff, MagnetType, VCMcoefficients] = magnetcoefficients('VCM');
VCMcoefficients = [VCMcoefficients 0];

for ii=1:size(cor,1)
name=cor{ii,1};     AO.HCM.CommonNames(ii,:)           = name;            
name=cor{ii,3};     AO.HCM.Setpoint.ChannelNames(ii,:) = name;     
name=cor{ii,2};     AO.HCM.Monitor.ChannelNames(ii,:)  = name;
val =cor{ii,4};     AO.HCM.Status(ii,1)                = val;

name=cor{ii,5};     AO.VCM.CommonNames(ii,:)           = name;            
name=cor{ii,7};     AO.VCM.Setpoint.ChannelNames(ii,:) = name;     
name=cor{ii,6};     AO.VCM.Monitor.ChannelNames(ii,:)  = name;
val =cor{ii,8};     AO.VCM.Status(ii,1)                = val;

val =cor{ii,9};     AO.HCM.DeviceList(ii,:)            = val;
                    AO.VCM.DeviceList(ii,:)            = val;
val =cor{ii,10};    AO.HCM.ElementList(ii,1)           = val;
                    AO.VCM.ElementList(ii,1)           = val;
val =cor{ii,11};    AO.HCM.Setpoint.Range(ii,:)        = [-90 90];
                    AO.VCM.Setpoint.Range(ii,:)        = [-110 110];
val =cor{ii,12};    AO.HCM.Setpoint.Tolerance(ii,1)    = Inf;           % Needs work!!!!!!!!!!!!!!!!!!!!!
                    AO.VCM.Setpoint.Tolerance(ii,1)    = 0.2;
val =cor{ii,13};    AO.HCM.Setpoint.DeltaRespMat(ii,1) = val;
val =cor{ii,14};    AO.VCM.Setpoint.DeltaRespMat(ii,1) = val;

AO.HCM.Monitor.HW2PhysicsParams{1}(ii,:)  = HCMcoefficients;          
AO.HCM.Monitor.Physics2HWParams{1}(ii,:)  = HCMcoefficients;
AO.HCM.Setpoint.HW2PhysicsParams{1}(ii,:) = HCMcoefficients;          
AO.HCM.Setpoint.Physics2HWParams{1}(ii,:) = HCMcoefficients;

AO.VCM.Monitor.HW2PhysicsParams{1}(ii,:)  = VCMcoefficients;          
AO.VCM.Monitor.Physics2HWParams{1}(ii,:)  = VCMcoefficients;
AO.VCM.Setpoint.HW2PhysicsParams{1}(ii,:) = VCMcoefficients;          
AO.VCM.Setpoint.Physics2HWParams{1}(ii,:) = VCMcoefficients;
end

AO.HCM.Status=AO.HCM.Status(:);
AO.VCM.Status=AO.VCM.Status(:);

% This is an attempt to remove the offset (you should look to see if it's a gain or offset or both)
load CorrectorOffset
AO.HCM.Monitor.Offset = HCMam-HCMsp;


%====================
%Skew Quadrupole data
%====================
AO.SkewQuad.FamilyName               = 'SkewQuad';
AO.SkewQuad.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'SkewQuad'; 'Magnet';};

HW2Physics=1.0;
AO.SkewQuad.Monitor.Mode             = Mode;
AO.SkewQuad.Monitor.DataType         = 'Scalar';
AO.SkewQuad.Monitor.Units            = 'Hardware';
AO.SkewQuad.Monitor.HWUnits          = 'ampere';           
AO.SkewQuad.Monitor.PhysicsUnits     = 'meter^-2';
AO.SkewQuad.Monitor.HW2PhysicsFcn      = @amp2k;
AO.SkewQuad.Monitor.Physics2HWFcn      = @k2amp;

AO.SkewQuad.Setpoint.Mode            = Mode;
AO.SkewQuad.Setpoint.DataType        = 'Scalar';
AO.SkewQuad.Setpoint.Units           = 'Hardware';
AO.SkewQuad.Setpoint.HWUnits         = 'ampere';           
AO.SkewQuad.Setpoint.PhysicsUnits    = 'meter^-2';
AO.SkewQuad.Setpoint.Tolerance       = 1.0;
AO.SkewQuad.Setpoint.HW2PhysicsFcn      = @amp2k;
AO.SkewQuad.Setpoint.Physics2HWFcn      = @k2amp;


%common         monitor                   setpoint                 stat devlist elem  scalefactor    range     tol  respkick
sq={
 '2SQ1    ' 'SR02:SKEW_1:aiReadBack  '    'SR02:SKEW_1:setCurrent  '    1   [ 2 1]   1        1.0     [-10 , 10]   0.25    0.01; ...
 '5SQ1    ' 'SR05:SKEW_2:aiReadBack  '    'SR05:SKEW_2:setCurrent  '    1   [ 5 1]   2        1.0     [-10 , 10]   0.25    0.01; ...
 '8SQ1    ' 'SR08:SKEW_3:aiReadBack  '    'SR08:SKEW_3:setCurrent  '    1   [ 8 1]   3        1.0     [-10 , 10]   0.25    0.01; ...
 '11SQ1   ' 'SR11:SKEW_4:aiReadBack  '    'SR11:SKEW_4:setCurrent  '    1   [11 1]   4        1.0     [-10 , 10]   0.25    0.01; ...
}; 


for ii=1:size(sq,1)
name=sq{ii,1};      AO.SkewQuad.CommonNames(ii,:)           = name;            
name=sq{ii,2};      AO.SkewQuad.Monitor.ChannelNames(ii,:)  = name;     
name=sq{ii,3};      AO.SkewQuad.Setpoint.ChannelNames(ii,:) = name;
val =sq{ii,4};      AO.SkewQuad.Status(ii,1)                = val;

val =sq{ii,5};      AO.SkewQuad.DeviceList(ii,:)            = val;
val =sq{ii,6};      AO.SkewQuad.ElementList(ii,1)           = val;
val =sq{ii,8};      AO.SkewQuad.Setpoint.Range(ii,:)        = val;
val =sq{ii,9};      AO.SkewQuad.Setpoint.Tolerance(ii,1)    = val;
val =sq{ii,10};     AO.SkewQuad.Setpoint.DeltaRespMat(ii,1) = val;

ScaleFactor =sq{ii,7};

AO.SkewQuad.Monitor.HW2PhysicsParams(ii,:)                  = HW2Physics*ScaleFactor;          
AO.SkewQuad.Monitor.Physics2HWParams(ii,:)                  = ScaleFactor/HW2Physics;

AO.SkewQuad.Setpoint.HW2PhysicsParams(ii,:)                 = HW2Physics*ScaleFactor;         
AO.SkewQuad.Setpoint.Physics2HWParams(ii,:)                 = ScaleFactor/HW2Physics;
end



%=============================
%        MAIN MAGNETS
%=============================

% BEND Family
AO.BEND.FamilyName                 = 'BEND';
AO.BEND.MemberOf                   = {'PlotFamily'; 'MachineConfig'; 'BEND'; 'Magnet';};
AO.BEND.Monitor.Mode               = Mode;
AO.BEND.Monitor.DataType           = 'Scalar';
AO.BEND.DeviceList = [];
for ii = 1:12
    AO.BEND.DeviceList = [AO.BEND.DeviceList; ii 1; ii 2; ii 3];
end
for ii = 1:36
    AO.BEND.Monitor.ChannelNames(ii,:) = 'SR_BEND:MBUS-AI:C0:S1';
end
AO.BEND.Status                     = 1;
AO.BEND.ElementList                = [1:36]';
AO.BEND.Monitor.Units              = 'Hardware';
AO.BEND.Monitor.HW2PhysicsFcn      = @amp2k;
AO.BEND.Monitor.Physics2HWFcn      = @k2amp;
AO.BEND.Monitor.HWUnits            = 'ampere';           
AO.BEND.Monitor.PhysicsUnits       = 'radian';

AO.BEND.Setpoint.Mode              = Mode;
AO.BEND.Setpoint.DataType          = 'Scalar';
for ii = 1:36
    AO.BEND.Setpoint.ChannelNames(ii,:)= 'SR_BEND:MBUS-AO:C0:S1';     
end
AO.BEND.Setpoint.Units             = 'Hardware';
AO.BEND.Setpoint.HW2PhysicsFcn     = @amp2k;
AO.BEND.Setpoint.Physics2HWFcn     = @k2amp;
AO.BEND.Setpoint.HWUnits           = 'ampere';           
AO.BEND.Setpoint.PhysicsUnits      = 'radian';

HW2PhysicsParams                    = magnetcoefficients('BEND');
Physics2HWParams                    = magnetcoefficients('BEND');
for ii = 1:36
AO.BEND.Monitor.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
AO.BEND.Monitor.HW2PhysicsParams{2}(ii,:) = 1;
AO.BEND.Monitor.Physics2HWParams{1}(ii,:) = Physics2HWParams;
AO.BEND.Monitor.Physics2HWParams{2}(ii,:) = 1;

AO.BEND.Setpoint.HW2PhysicsParams{1}(ii,:) = HW2PhysicsParams;
AO.BEND.Setpoint.HW2PhysicsParams{2}(ii,:) = 1;
AO.BEND.Setpoint.Physics2HWParams{1}(ii,:) = Physics2HWParams;
AO.BEND.Setpoint.Physics2HWParams{2}(ii,:) = 1;
end
AO.BEND.Setpoint.Range     = [0 1000];
AO.BEND.Setpoint.Tolerance = .5;  % ???



% *** Q1 ***
AO.Q1.FamilyName                 = 'Q1';
AO.Q1.MemberOf                   = {'PlotFamily'; 'MachineConfig'; 'Tune Corrector'; 'QUAD'; 'Magnet';};
HW2PhysicsParams                    = magnetcoefficients('Q1');
Physics2HWParams                    = magnetcoefficients('Q1');

AO.Q1.Monitor.Mode               = Mode;
AO.Q1.Monitor.DataType           = 'Scalar';
AO.Q1.Monitor.Units              = 'Hardware';
AO.Q1.Monitor.HWUnits            = 'ampere';           
AO.Q1.Monitor.PhysicsUnits       = 'meter^-2';
AO.Q1.Monitor.HW2PhysicsFcn      = @amp2k;
AO.Q1.Monitor.Physics2HWFcn      = @k2amp;

AO.Q1.Setpoint.Mode              = Mode;
AO.Q1.Setpoint.DataType          = 'Scalar';
AO.Q1.Setpoint.Units             = 'Hardware';
AO.Q1.Setpoint.HWUnits           = 'ampere';           
AO.Q1.Setpoint.PhysicsUnits      = 'meter^-2';
AO.Q1.Setpoint.HW2PhysicsFcn     = @amp2k;
AO.Q1.Setpoint.Physics2HWFcn     = @k2amp;

q11factor= 1/0.9928;
q12factor= 1/0.9945;
q11to6factor=0.5* (1/q11factor   +   1/q12factor);
q11to6factor=1/q11to6factor;
%                                                                                                        delta-k
%common             desired                         monitor                       setpoint            stat devlist  elem  scalefactor    range    tol  respkick
%Not Used           Not Used
q1={
 '1Q1U     '    'MS1-QF:CurrSetptDes  '    'SR_P01Q1:MBUS-AI:C0:S1    '    'SR_P01Q1:MBUS-AO:C0:S1   '  1   [1 ,1]    1   q11to6factor   [0, 137] 0.50  0.05; ...
 '1Q1D     '    'MS1-QF:CurrSetptDes  '    'P02Q1:IO2                 '    'P02Q1:ISET2              '  1   [1 ,2]    2   q11to6factor   [0, 137] 0.50  0.05; ...
 '2Q1U     '    'MS1-QF:CurrSetptDes  '    'P02Q1:IO2                 '    'P02Q1:ISET2              '  1   [2 ,1]    2   q11to6factor   [0, 137] 0.50  0.05; ...
 '2Q1D     '    'MS1-QF:CurrSetptDes  '    'SR_P03Q1:MBUS-AI:C6:S1    '    'SR_P03Q1:MBUS-AO:C6:S1   '  1   [2 ,2]    3   q11to6factor   [0, 137] 0.50  0.05; ...
 '3Q1U     '    'MS1-QF:CurrSetptDes  '    'SR_P03Q1:MBUS-AI:C6:S1    '    'SR_P03Q1:MBUS-AO:C6:S1   '  1   [3 ,1]    3   q11to6factor   [0, 137] 0.50  0.05; ...
 '3Q1D     '    'MS1-QF:CurrSetptDes  '    'SR_P04Q1:MBUS-AI:C9:S1    '    'SR_P04Q1:MBUS-AO:C9:S1   '  1   [3 ,2]    4   q11to6factor   [0, 137] 0.50  0.05; ...
 '4Q1U     '    'MS1-QF:CurrSetptDes  '    'SR_P04Q1:MBUS-AI:C9:S1    '    'SR_P04Q1:MBUS-AO:C9:S1   '  1   [4 ,1]    4   q11to6factor   [0, 137] 0.50  0.05; ...
 '4Q1D     '    'MS1-QF:CurrSetptDes  '    'SR_P05Q1:MBUS-AI:C12:S1   '    'SR_P05Q1:MBUS-AO:C12:S1  '  1   [4 ,2]    5   q11to6factor   [0, 137] 0.50  0.05; ...
 '5Q1U     '    'MS1-QF:CurrSetptDes  '    'SR_P05Q1:MBUS-AI:C12:S1   '    'SR_P05Q1:MBUS-AO:C12:S1  '  1   [5 ,1]    5   q11to6factor   [0, 137] 0.50  0.05; ...
 '5Q1D     '    'MS1-QF:CurrSetptDes  '    'SR_P06Q1:MBUS-AI:C15:S1   '    'SR_P06Q1:MBUS-AO:C15:S1  '  1   [5 ,2]    6   q11to6factor   [0, 137] 0.50  0.05; ...
 '6Q1U     '    'MS1-QF:CurrSetptDes  '    'SR_P06Q1:MBUS-AI:C15:S1   '    'SR_P06Q1:MBUS-AO:C15:S1  '  1   [6 ,1]    6   q11to6factor   [0, 137] 0.50  0.05; ...
 '6Q1D     '    '05G-QF1:CurrSetptDes '    'SR_P07Q1:MBUS-AI:C18:S1   '    'SR_P07Q1:MBUS-AO:C18:S1  '  1   [6 ,2]    7   q11factor      [0, 137] 0.50  0.05; ...
 '7Q1U     '    '05G-QF1:CurrSetptDes '    'SR_P07Q1:MBUS-AI:C18:S1   '    'SR_P07Q1:MBUS-AO:C18:S1  '  1   [7 ,1]    7   q11factor      [0, 137] 0.50  0.05; ...
 '7Q1D     '    '05G-QF2:CurrSetptDes '    'SR_P08Q1:MBUS-AI:C21:S1   '    'SR_P08Q1:MBUS-AO:C21:S1  '  1   [7 ,2]    8   q12factor      [0, 137] 0.50  0.05; ...
 '8Q1U     '    '05G-QF2:CurrSetptDes '    'SR_P08Q1:MBUS-AI:C21:S1   '    'SR_P08Q1:MBUS-AO:C21:S1  '  1   [8 ,1]    8   q12factor      [0, 137] 0.50  0.05; ...
 '8Q1D     '    '06G-QF1:CurrSetptDes '    'SR_P09Q1:MBUS-AI:C24:S1   '    'SR_P09Q1:MBUS-AO:C24:S1  '  1   [8 ,2]    9   q11factor      [0, 137] 0.50  0.05; ...
 '9Q1U     '    '06G-QF1:CurrSetptDes '    'SR_P09Q1:MBUS-AI:C24:S1   '    'SR_P09Q1:MBUS-AO:C24:S1  '  1   [9 ,1]    9   q11factor      [0, 137] 0.50  0.05; ...
 '9Q1D     '    '06G-QF2:CurrSetptDes '    'SR_P10Q1:MBUS-AI:C27:S1   '    'SR_P10Q1:MBUS-AO:C27:S1  '  1   [9 ,2]    10  q12factor      [0, 137] 0.50  0.05; ...
 '10Q1U    '    '06G-QF2:CurrSetptDes '    'SR_P10Q1:MBUS-AI:C27:S1   '    'SR_P10Q1:MBUS-AO:C27:S1  '  1   [10 ,1]    10  q12factor     [0, 137] 0.50  0.05; ...
 '10Q1D    '    '07G-QF1:CurrSetptDes '    'SR_P11Q1:MBUS-AI:C30:S1   '    'SR_P11Q1:MBUS-AO:C30:S1  '  1   [10 ,2]    11  q11factor     [0, 137] 0.50  0.05; ...
 '11Q1U    '    '07G-QF1:CurrSetptDes '    'SR_P11Q1:MBUS-AI:C30:S1   '    'SR_P11Q1:MBUS-AO:C30:S1  '  1   [11 ,1]    11  q11factor     [0, 137] 0.50  0.05; ...
 '11Q1D    '    '07G-QF2:CurrSetptDes '    'SR_P12Q1:MBUS-AI:C33:S1   '    'SR_P12Q1:MBUS-AO:C33:S1  '  1   [11 ,2]    12  q12factor     [0, 137] 0.50  0.05; ...
 '12Q1U    '    '07G-QF2:CurrSetptDes '    'SR_P12Q1:MBUS-AI:C33:S1   '    'SR_P12Q1:MBUS-AO:C33:S1  '  1   [12 ,1]    12  q12factor     [0, 137] 0.50  0.05; ...
 '12Q1D    '    'MS1-QF:CurrSetptDes  '    'SR_P01Q1:MBUS-AI:C0:S1    '    'SR_P01Q1:MBUS-AO:C0:S1   '  1   [12 ,2]    1   q11to6factor  [0, 137] 0.50  0.05; ...
 };

for ii=1:size(q1,1)
    if ii == 1
        iname = 23;
    elseif ii == 2
        iname = 24;
    else
        iname = ii - 2;
    end
    
    name=q1{ii,1};      AO.Q1.CommonNames(ii,:)           = name;
    AO.Q1.Monitor.ChannelNames(ii,:)  = q1{iname,3};
    AO.Q1.Setpoint.ChannelNames(ii,:) = q1{iname,4};
    val =q1{ii,5};      AO.Q1.Status(ii,1)                = val;
    val =q1{ii,6};      AO.Q1.DeviceList(ii,:)            = val;
    val =q1{ii,7};      AO.Q1.ElementList(ii,1)           = val;
    val =q1{ii,8};
    AO.Q1.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
    AO.Q1.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
    AO.Q1.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
    AO.Q1.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
    AO.Q1.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
    AO.Q1.Monitor.Physics2HWParams{2}(ii,:)               = val;
    AO.Q1.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
    AO.Q1.Setpoint.Physics2HWParams{2}(ii,:)              = val;
    val =q1{ii,9};      AO.Q1.Setpoint.Range(ii,:)        = val;
    val =q1{ii,10};     AO.Q1.Setpoint.Tolerance(ii,1)    = val;
    val =q1{ii,11};     AO.Q1.Setpoint.DeltaRespMat(ii,1) = val;
end




% *** Q2 ***
AO.Q2.FamilyName               = 'Q2';
AO.Q2.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'Tune Corrector'; 'QUAD'; 'Magnet';};
HW2PhysicsParams                  = magnetcoefficients('Q2');
Physics2HWParams                  = magnetcoefficients('Q2');

AO.Q2.Monitor.Mode             = Mode;
AO.Q2.Monitor.DataType         = 'Scalar';
AO.Q2.Monitor.Units            = 'Hardware';
AO.Q2.Monitor.HWUnits          = 'ampere';           
AO.Q2.Monitor.PhysicsUnits     = 'meter^-2';
AO.Q2.Monitor.HW2PhysicsFcn    = @amp2k;
AO.Q2.Monitor.Physics2HWFcn    = @k2amp;

AO.Q2.Setpoint.Mode            = Mode;
AO.Q2.Setpoint.DataType        = 'Scalar';
AO.Q2.Setpoint.Units           = 'Hardware';
AO.Q2.Setpoint.HWUnits         = 'ampere';           
AO.Q2.Setpoint.PhysicsUnits    = 'meter^-2';
AO.Q2.Setpoint.HW2PhysicsFcn   = @amp2k;
AO.Q2.Setpoint.Physics2HWFcn   = @k2amp;

q21factor= 1/0.9835;
q22factor= 1/0.9795;
q21to6factor=(q21factor+q22factor)/2;
%                                                                                                                                                         delta-k
%common         desired                    monitor                               setpoint             stat  devlist  elem  scalefactor    range       tol  respkick
q2={
 '1Q2U    '    'MS1-QD:CurrSetptDes  '    'SR_P01Q2:MBUS-AI:C1:S1     '    'SR_P01Q2:MBUS-AO:C1:S1   '  1   [1 ,1]    1    q21to6factor     [0, 137] 0.50  0.05; ...
 '1Q2D    '    'MS1-QD:CurrSetptDes  '    'P02Q2:IO2                  '    'P02Q2:ISET2              '  1   [1 ,2]    2    q21to6factor     [0, 137] 0.50  0.05; ...
 '2Q2U    '    'MS1-QD:CurrSetptDes  '    'P02Q2:IO2                  '    'P02Q2:ISET2              '  1   [2 ,1]    2    q21to6factor     [0, 137] 0.50  0.05; ...
 '2Q2D    '    'MS1-QD:CurrSetptDes  '    'SR_P03Q2:MBUS-AI:C7:S1     '    'SR_P03Q2:MBUS-AO:C7:S1   '  1   [2 ,2]    3    q21to6factor     [0, 137] 0.50  0.05; ...
 '3Q2U    '    'MS1-QD:CurrSetptDes  '    'SR_P03Q2:MBUS-AI:C7:S1     '    'SR_P03Q2:MBUS-AO:C7:S1   '  1   [3 ,1]    3    q21to6factor     [0, 137] 0.50  0.05; ...
 '3Q2D    '    'MS1-QD:CurrSetptDes  '    'SR_P04Q2:MBUS-AI:C10:S1    '    'SR_P04Q2:MBUS-AO:C10:S1  '  1   [3 ,2]    4    q21to6factor     [0, 137] 0.50  0.05; ...
 '4Q2U    '    'MS1-QD:CurrSetptDes  '    'SR_P04Q2:MBUS-AI:C10:S1    '    'SR_P04Q2:MBUS-AO:C10:S1  '  1   [4 ,1]    4    q21to6factor     [0, 137] 0.50  0.05; ...
 '4Q2D    '    'MS1-QD:CurrSetptDes  '    'SR_P05Q2:MBUS-AI:C13:S1    '    'SR_P05Q2:MBUS-AO:C13:S1  '  1   [4 ,2]    5    q21to6factor     [0, 137] 0.50  0.05; ...
 '5Q2U    '    'MS1-QD:CurrSetptDes  '    'SR_P05Q2:MBUS-AI:C13:S1    '    'SR_P05Q2:MBUS-AO:C13:S1  '  1   [5 ,1]    5    q21to6factor     [0, 137] 0.50  0.05; ...
 '5Q2D    '    'MS1-QD:CurrSetptDes  '    'SR_P06Q2:MBUS-AI:C16:S1    '    'SR_P06Q2:MBUS-AO:C16:S1  '  1   [5 ,2]    6    q21to6factor     [0, 137] 0.50  0.05; ...
 '6Q2U    '    'MS1-QD:CurrSetptDes  '    'SR_P06Q2:MBUS-AI:C16:S1    '    'SR_P06Q2:MBUS-AO:C16:S1  '  1   [6 ,1]    6    q21to6factor     [0, 137] 0.50  0.05; ...
 '6Q2D    '    '05G-QD1:CurrSetptDes '    'SR_P07Q2:MBUS-AI:C19:S1    '    'SR_P07Q2:MBUS-AO:C19:S1  '  1   [6 ,2]    7    q21factor        [0, 137] 0.50  0.05; ...
 '7Q2U    '    '05G-QD1:CurrSetptDes '    'SR_P07Q2:MBUS-AI:C19:S1    '    'SR_P07Q2:MBUS-AO:C19:S1  '  1   [7 ,1]    7    q21factor        [0, 137] 0.50  0.05; ...
 '7Q2D    '    '05G-QD2:CurrSetptDes '    'SR_P08Q2:MBUS-AI:C22:S1    '    'SR_P08Q2:MBUS-AO:C22:S1  '  1   [7 ,2]    8    q22factor        [0, 137] 0.50  0.05; ...
 '8Q2U    '    '05G-QD2:CurrSetptDes '    'SR_P08Q2:MBUS-AI:C22:S1    '    'SR_P08Q2:MBUS-AO:C22:S1  '  1   [8 ,1]    8    q22factor        [0, 137] 0.50  0.05; ...
 '8Q2D    '    '06G-QD1:CurrSetptDes '    'SR_P09Q2:MBUS-AI:C25:S1    '    'SR_P09Q2:MBUS-AO:C25:S1  '  1   [8 ,2]    9    q21factor        [0, 137] 0.50  0.05; ...
 '9Q2U    '    '06G-QD1:CurrSetptDes '    'SR_P09Q2:MBUS-AI:C25:S1    '    'SR_P09Q2:MBUS-AO:C25:S1  '  1   [9 ,1]    9    q21factor        [0, 137] 0.50  0.05; ...
 '9Q2D    '    '06G-QD2:CurrSetptDes '    'SR_P10Q2:MBUS-AI:C28:S1    '    'SR_P10Q2:MBUS-AO:C28:S1  '  1   [9 ,2]    10   q22factor        [0, 137] 0.50  0.05; ...
 '10Q2U   '    '06G-QD2:CurrSetptDes '    'SR_P10Q2:MBUS-AI:C28:S1    '    'SR_P10Q2:MBUS-AO:C28:S1  '  1   [10 ,1]    10   q22factor       [0, 137] 0.50  0.05; ...
 '10Q2D   '    '07G-QD1:CurrSetptDes '    'SR_P11Q2:MBUS-AI:C31:S1    '    'SR_P11Q2:MBUS-AO:C31:S1  '  1   [10 ,2]    11   q21factor       [0, 137] 0.50  0.05; ...
 '11Q2U   '    '07G-QD1:CurrSetptDes '    'SR_P11Q2:MBUS-AI:C31:S1    '    'SR_P11Q2:MBUS-AO:C31:S1  '  1   [11 ,1]    11   q21factor       [0, 137] 0.50  0.05; ...
 '11Q2D   '    '07G-QD2:CurrSetptDes '    'SR_P12Q2:MBUS-AI:C34:S1    '    'SR_P12Q2:MBUS-AO:C34:S1  '  1   [11 ,2]    12   q22factor       [0, 137] 0.50  0.05; ...
 '12Q2U   '    '07G-QD2:CurrSetptDes '    'SR_P12Q2:MBUS-AI:C34:S1    '    'SR_P12Q2:MBUS-AO:C34:S1  '  1   [12 ,1]    12   q22factor       [0, 137] 0.50  0.05; ...
 '12Q2D   '    'MS1-QD:CurrSetptDes  '    'SR_P01Q2:MBUS-AI:C1:S1     '    'SR_P01Q2:MBUS-AO:C1:S1   '  1   [12 ,2]    1    q21to6factor    [0, 137] 0.50  0.05; ...
};   
 
for ii=1:size(q2,1)
    if ii == 1
        iname = 23;
    elseif ii == 2
        iname = 24;
    else
        iname = ii - 2;
    end
    
    name=q2{ii,1};      AO.Q2.CommonNames(ii,:)           = name;
    AO.Q2.Monitor.ChannelNames(ii,:)  = q2{iname,3};
    AO.Q2.Setpoint.ChannelNames(ii,:) = q2{iname,4};    
    val =q2{ii,5};      AO.Q2.Status(ii,1)                = val;
    val =q2{ii,6};      AO.Q2.DeviceList(ii,:)            = val;
    val =q2{ii,7};      AO.Q2.ElementList(ii,1)           = val;
    val =q2{ii,8};
    AO.Q2.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
    AO.Q2.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
    AO.Q2.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
    AO.Q2.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
    AO.Q2.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
    AO.Q2.Monitor.Physics2HWParams{2}(ii,:)               = val;
    AO.Q2.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
    AO.Q2.Setpoint.Physics2HWParams{2}(ii,:)              = val;
    val =q2{ii,9};      AO.Q2.Setpoint.Range(ii,:)        = val;
    val =q2{ii,10};      AO.Q2.Setpoint.Tolerance(ii,1)   = val;
    val =q2{ii,11};     AO.Q2.Setpoint.DeltaRespMat(ii,1) = val;
end


% *** Q3 ***
AO.Q3.FamilyName               = 'Q3';
AO.Q3.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'Tune Corrector'; 'QUAD'; 'Magnet';};
HW2PhysicsParams                  = magnetcoefficients('Q3');
Physics2HWParams                  = magnetcoefficients('Q3');

AO.Q3.Monitor.Mode             = Mode;
AO.Q3.Monitor.DataType         = 'Scalar';
AO.Q3.Monitor.Units            = 'Hardware';
AO.Q3.Monitor.HW2PhysicsFcn    = @amp2k;
AO.Q3.Monitor.Physics2HWFcn    = @k2amp;
AO.Q3.Monitor.HWUnits          = 'ampere';           
AO.Q3.Monitor.PhysicsUnits     = 'meter^-2';

AO.Q3.Setpoint.Mode            = Mode;
AO.Q3.Setpoint.DataType        = 'Scalar';
AO.Q3.Setpoint.Units           = 'Hardware';
AO.Q3.Setpoint.HW2PhysicsFcn   = @amp2k;
AO.Q3.Setpoint.Physics2HWFcn   = @k2amp;
AO.Q3.Setpoint.HWUnits         = 'ampere';           
AO.Q3.Setpoint.PhysicsUnits    = 'meter^-2';
 
%                                                                                                                                    delta-k
%common          desired                     monitor                          setpoint                stat devlist  elem  scalefactor    range   tol  respkick
q3={
'1Q3U    '    'MS1-QFC:CurrSetptDes '    'SR_P01Q3:MBUS-AI:C2:S1     '    'SR_P01Q3:MBUS-AO:C2:S1   '  1  [1 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'1Q3D    '    'MS1-QFC:CurrSetptDes '    'SR_P02Q3:MBUS-AI:C5:S1     '    'SR_P02Q3:MBUS-AO:C5:S1   '  1  [1 ,2]  2         1.0         [0 500] 0.050   0.05; ... 
'2Q3U    '    'MS1-QFC:CurrSetptDes '    'SR_P02Q3:MBUS-AI:C5:S1     '    'SR_P02Q3:MBUS-AO:C5:S1   '  1  [2 ,1]  2         1.0         [0 500] 0.050   0.05; ... 
'2Q3D    '    'MS1-QFC:CurrSetptDes '    'SR_P03Q3:MBUS-AI:C8:S1     '    'SR_P03Q3:MBUS-AO:C8:S1   '  1  [2 ,2]  3         1.0         [0 500] 0.050   0.05; ... 
'3Q3U    '    'MS1-QFC:CurrSetptDes '    'SR_P03Q3:MBUS-AI:C8:S1     '    'SR_P03Q3:MBUS-AO:C8:S1   '  1  [3 ,1]  3         1.0         [0 500] 0.050   0.05; ...
'3Q3D    '    'MS1-QFC:CurrSetptDes '    'SR_P04Q3:MBUS-AI:C11:S1    '    'SR_P04Q3:MBUS-AO:C11:S1  '  1  [3 ,2]  4         1.0         [0 500] 0.050   0.05; ... 
'4Q3U    '    'MS1-QFC:CurrSetptDes '    'SR_P04Q3:MBUS-AI:C11:S1    '    'SR_P04Q3:MBUS-AO:C11:S1  '  1  [4 ,1]  4         1.0         [0 500] 0.050   0.05; ...
'4Q3D    '    'MS1-QFC:CurrSetptDes '    'SR_P05Q3:MBUS-AI:C14:S1    '    'SR_P05Q3:MBUS-AO:C14:S1  '  1  [4 ,2]  5         1.0         [0 500] 0.050   0.05; ... 
'5Q3U    '    'MS1-QFC:CurrSetptDes '    'SR_P05Q3:MBUS-AI:C14:S1    '    'SR_P05Q3:MBUS-AO:C14:S1  '  1  [5 ,1]  5         1.0         [0 500] 0.050   0.05; ...
'5Q3D    '    'MS1-QFC:CurrSetptDes '    'SR_P06Q3:MBUS-AI:C17:S1    '    'SR_P06Q3:MBUS-AO:C17:S1  '  1  [5 ,2]  6         1.0         [0 500] 0.050   0.05; ...
'6Q3U    '    'MS1-QFC:CurrSetptDes '    'SR_P06Q3:MBUS-AI:C17:S1    '    'SR_P06Q3:MBUS-AO:C17:S1  '  1  [6 ,1]  6         1.0         [0 500] 0.050   0.05; ...
'6Q3D    '    'MS1-QFC:CurrSetptDes '    'SR_P07Q3:MBUS-AI:C20:S1    '    'SR_P07Q3:MBUS-AO:C20:S1  '  1  [6 ,2]  7         1.0         [0 500] 0.050   0.05; ...
'7Q3U    '    'MS1-QFC:CurrSetptDes '    'SR_P07Q3:MBUS-AI:C20:S1    '    'SR_P07Q3:MBUS-AO:C20:S1  '  1  [7 ,1]  7         1.0         [0 500] 0.050   0.05; ...
'7Q3D    '    'MS2-QFC:CurrSetptDes '    'SR_P08Q3:MBUS-AI:C23:S1    '    'SR_P08Q3:MBUS-AO:C23:S1  '  1  [7 ,2]  8         1.0         [0 500] 0.050   0.05; ... 
'8Q3U    '    'MS2-QFC:CurrSetptDes '    'SR_P08Q3:MBUS-AI:C23:S1    '    'SR_P08Q3:MBUS-AO:C23:S1  '  1  [8 ,1]  8         1.0         [0 500] 0.050   0.05; ...
'8Q3D    '    'MS2-QFC:CurrSetptDes '    'SR_P09Q3:MBUS-AI:C26:S1    '    'SR_P09Q3:MBUS-AO:C26:S1  '  1  [8 ,2]  9         1.0         [0 500] 0.050   0.05; ...
'9Q3U    '    'MS2-QFC:CurrSetptDes '    'SR_P09Q3:MBUS-AI:C26:S1    '    'SR_P09Q3:MBUS-AO:C26:S1  '  1  [9 ,1]  9         1.0         [0 500] 0.050   0.05; ...
'9Q3D    '    'MS1-QFC:CurrSetptDes '    'SR_P10Q3:MBUS-AI:C29:S1    '    'SR_P10Q3:MBUS-AO:C29:S1  '  1  [9 ,2]  10         1.0         [0 500] 0.050   0.05; ...
'10Q3U   '    'MS1-QFC:CurrSetptDes '    'SR_P10Q3:MBUS-AI:C29:S1    '    'SR_P10Q3:MBUS-AO:C29:S1  '  1  [10 ,1]  10         1.0         [0 500] 0.050   0.05; ...
'10Q3D   '    'MS2-QFC:CurrSetptDes '    'SR_P11Q3:MBUS-AI:C32:S1    '    'SR_P11Q3:MBUS-AO:C32:S1  '  1  [10 ,2]  11         1.0         [0 500] 0.050   0.05; ... 
'11Q3U   '    'MS2-QFC:CurrSetptDes '    'SR_P11Q3:MBUS-AI:C32:S1    '    'SR_P11Q3:MBUS-AO:C32:S1  '  1  [11 ,1]  11         1.0         [0 500] 0.050   0.05; ... 
'11Q3D   '    'MS2-QFC:CurrSetptDes '    'SR_P12Q3:MBUS-AI:C35:S1    '    'SR_P12Q3:MBUS-AO:C35:S1  '  1  [11 ,2]  12         1.0         [0 500] 0.050   0.05; ...
'12Q3U   '    'MS2-QFC:CurrSetptDes '    'SR_P12Q3:MBUS-AI:C35:S1    '    'SR_P12Q3:MBUS-AO:C35:S1  '  1  [12 ,1]  12         1.0         [0 500] 0.050   0.05; ...
'12Q3D   '    'MS1-QFC:CurrSetptDes '    'SR_P01Q3:MBUS-AI:C2:S1     '    'SR_P01Q3:MBUS-AO:C2:S1   '  1  [12 ,2]  1         1.0         [0 500] 0.050   0.05; ...
};

for ii=1:size(q3,1)
    if ii == 1
        iname = 23;
    elseif ii == 2
        iname = 24;
    else
        iname = ii - 2;
    end
    
    name=q3{ii,1};      AO.Q3.CommonNames(ii,:)           = name;
    AO.Q3.Monitor.ChannelNames(ii,:)  = q3{iname,3};
    AO.Q3.Setpoint.ChannelNames(ii,:) = q3{iname,4};
    name=q3{ii,3};      AO.Q3.Monitor.ChannelNames(ii,:)  = name;
    name=q3{ii,4};      AO.Q3.Setpoint.ChannelNames(ii,:) = name;
    val =q3{ii,5};      AO.Q3.Status(ii,1)                = val;
    val =q3{ii,6};      AO.Q3.DeviceList(ii,:)            = val;
    val =q3{ii,7};      AO.Q3.ElementList(ii,1)           = val;
    val =q3{ii,8};
    AO.Q3.Monitor.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
    AO.Q3.Monitor.HW2PhysicsParams{2}(ii,:)                = val;
    AO.Q3.Setpoint.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
    AO.Q3.Setpoint.HW2PhysicsParams{2}(ii,:)               = val;
    AO.Q3.Monitor.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
    AO.Q3.Monitor.Physics2HWParams{2}(ii,:)                = val;
    AO.Q3.Setpoint.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
    AO.Q3.Setpoint.Physics2HWParams{2}(ii,:)               = val;
    val =q3{ii,9};      AO.Q3.Setpoint.Range(ii,:)        = val;
    val =q3{ii,10};     AO.Q3.Setpoint.Tolerance(ii,1)    = val;
    val =q3{ii,11};     AO.Q3.Setpoint.DeltaRespMat(ii,1) = val;
end


% *** Q4 ***
AO.Q4.FamilyName               = 'Q4';
AO.Q4.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet';};
HW2PhysicsParams                  = magnetcoefficients('Q4');
Physics2HWParams                  = magnetcoefficients('Q4');

AO.Q4.Monitor.Mode             = Mode;
AO.Q4.Monitor.DataType         = 'Scalar';
AO.Q4.Monitor.Units            = 'Hardware';
AO.Q4.Monitor.HW2PhysicsFcn    = @amp2k;
AO.Q4.Monitor.Physics2HWFcn    = @k2amp;
AO.Q4.Monitor.HWUnits          = 'ampere';           
AO.Q4.Monitor.PhysicsUnits     = 'meter^-2';

AO.Q4.Setpoint.Mode            = Mode;
AO.Q4.Setpoint.DataType        = 'Scalar';
AO.Q4.Setpoint.Units           = 'Hardware';
AO.Q4.Setpoint.HW2PhysicsFcn   = @amp2k;
AO.Q4.Setpoint.Physics2HWFcn   = @k2amp;
AO.Q4.Setpoint.HWUnits         = 'ampere';           
AO.Q4.Setpoint.PhysicsUnits    = 'meter^-2';
 
%                                                                                                                                    delta-k
%common            desired                monitor                          setpoint            stat  devlist  elem  scalefactor    range   tol  respkick
q4={
'1Q4U    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [1 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'1Q4D    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [1 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'2Q4U    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [2 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'2Q4D    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [2 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'3Q4U    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [3 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'3Q4D    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [3 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'4Q4U    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [4 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'4Q4D    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [4 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'5Q4U    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [5 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'5Q4D    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [5 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'6Q4U    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [6 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'6Q4D    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [6 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'7Q4U    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [7 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'7Q4D    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [7 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'8Q4U    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [8 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'8Q4D    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [8 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'9Q4U    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [9 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'9Q4D    '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [9 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'10Q4U   '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [10 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'10Q4D   '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [10 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'11Q4U   '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [11 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'11Q4D   '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [11 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'12Q4U   '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [12 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'12Q4D   '    'MS1-QFC:CurrSetptDes '    'SR_Q4:MBUS-AI:C1:S1     '    'SR_Q4:MBUS-AO:C1:S1   '  1  [12 ,2]  1         1.0         [0 500] 0.050   0.05; ...
};

for ii=1:size(q4,1)
name=q4{ii,1};      AO.Q4.CommonNames(ii,:)           = name;            
name=q4{ii,3};      AO.Q4.Monitor.ChannelNames(ii,:)  = name;
name=q4{ii,4};      AO.Q4.Setpoint.ChannelNames(ii,:) = name;     
val =q4{ii,5};      AO.Q4.Status(ii,1)                = val;
val =q4{ii,6};      AO.Q4.DeviceList(ii,:)            = val;
val =q4{ii,7};      AO.Q4.ElementList(ii,1)           = val;
val =q4{ii,8};
AO.Q4.Monitor.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
AO.Q4.Monitor.HW2PhysicsParams{2}(ii,:)                = val;
AO.Q4.Setpoint.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.Q4.Setpoint.HW2PhysicsParams{2}(ii,:)               = val;
AO.Q4.Monitor.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
AO.Q4.Monitor.Physics2HWParams{2}(ii,:)                = val;
AO.Q4.Setpoint.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.Q4.Setpoint.Physics2HWParams{2}(ii,:)               = val;
val =q4{ii,9};      AO.Q4.Setpoint.Range(ii,:)        = val;
val =q4{ii,10};     AO.Q4.Setpoint.Tolerance(ii,1)    = val;
val =q4{ii,11};     AO.Q4.Setpoint.DeltaRespMat(ii,1) = val;
end


% *** Q5 ***
AO.Q5.FamilyName               = 'Q5';
AO.Q5.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet';};
HW2PhysicsParams                  = magnetcoefficients('Q5');
Physics2HWParams                  = magnetcoefficients('Q5');

AO.Q5.Monitor.Mode             = Mode;
AO.Q5.Monitor.DataType         = 'Scalar';
AO.Q5.Monitor.Units            = 'Hardware';
AO.Q5.Monitor.HW2PhysicsFcn    = @amp2k;
AO.Q5.Monitor.Physics2HWFcn    = @k2amp;
AO.Q5.Monitor.HWUnits          = 'ampere';           
AO.Q5.Monitor.PhysicsUnits     = 'meter^-2';

AO.Q5.Setpoint.Mode            = Mode;
AO.Q5.Setpoint.DataType        = 'Scalar';
AO.Q5.Setpoint.Units           = 'Hardware';
AO.Q5.Setpoint.HW2PhysicsFcn   = @amp2k;
AO.Q5.Setpoint.Physics2HWFcn   = @k2amp;
AO.Q5.Setpoint.HWUnits         = 'ampere';           
AO.Q5.Setpoint.PhysicsUnits    = 'meter^-2';
 
%                                                                                                                                    delta-k
%common          desired                monitor                  setpoint           stat  devlist  elem  scalefactor    range   tol  respkick
q5={
'1Q5U    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [1 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'1Q5D    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [1 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'2Q5U    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [2 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'2Q5D    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [2 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'3Q5U    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [3 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'3Q5D    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [3 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'4Q5U    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [4 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'4Q5D    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [4 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'5Q5U    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [5 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'5Q5D    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [5 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'6Q5U    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [6 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'6Q5D    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [6 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'7Q5U    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [7 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'7Q5D    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [7 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'8Q5U    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [8 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'8Q5D    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [8 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'9Q5U    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [9 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'9Q5D    '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [9 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'10Q5U   '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [10 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'10Q5D   '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [10 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'11Q5U   '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [11 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'11Q5D   '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [11 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'12Q5U   '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [12 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'12Q5D   '    'MS1-QFC:CurrSetptDes '    'SR_Q5:MBUS-AI:C2:S1     '    'SR_Q5:MBUS-AO:C2:S1   '  1  [12 ,2]  1         1.0         [0 500] 0.050   0.05; ...
};
 
for ii=1:size(q5,1)
name=q5{ii,1};      AO.Q5.CommonNames(ii,:)           = name;            
name=q5{ii,3};      AO.Q5.Monitor.ChannelNames(ii,:)  = name;
name=q5{ii,4};      AO.Q5.Setpoint.ChannelNames(ii,:) = name;     
val =q5{ii,5};      AO.Q5.Status(ii,1)                = val;
val =q5{ii,6};      AO.Q5.DeviceList(ii,:)            = val;
val =q5{ii,7};      AO.Q5.ElementList(ii,1)           = val;
val =q5{ii,8};
AO.Q5.Monitor.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
AO.Q5.Monitor.HW2PhysicsParams{2}(ii,:)                = val;
AO.Q5.Setpoint.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.Q5.Setpoint.HW2PhysicsParams{2}(ii,:)               = val;
AO.Q5.Monitor.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
AO.Q5.Monitor.Physics2HWParams{2}(ii,:)                = val;
AO.Q5.Setpoint.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.Q5.Setpoint.Physics2HWParams{2}(ii,:)               = val;
val =q5{ii,9};      AO.Q5.Setpoint.Range(ii,:)        = val;
val =q5{ii,10};     AO.Q5.Setpoint.Tolerance(ii,1)    = val;
val =q5{ii,11};     AO.Q5.Setpoint.DeltaRespMat(ii,1) = val;
end


% *** Q6 ***
AO.Q6.FamilyName               = 'Q6';
AO.Q6.MemberOf                 = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet';};
HW2PhysicsParams                  = magnetcoefficients('Q6');
Physics2HWParams                  = magnetcoefficients('Q6');

AO.Q6.Monitor.Mode             = Mode;
AO.Q6.Monitor.DataType         = 'Scalar';
AO.Q6.Monitor.Units            = 'Hardware';
AO.Q6.Monitor.HW2PhysicsFcn    = @amp2k;
AO.Q6.Monitor.Physics2HWFcn    = @k2amp;
AO.Q6.Monitor.HWUnits          = 'ampere';           
AO.Q6.Monitor.PhysicsUnits     = 'meter^-2';

AO.Q6.Setpoint.Mode            = Mode;
AO.Q6.Setpoint.DataType        = 'Scalar';
AO.Q6.Setpoint.Units           = 'Hardware';
AO.Q6.Setpoint.HW2PhysicsFcn   = @amp2k;
AO.Q6.Setpoint.Physics2HWFcn   = @k2amp;
AO.Q6.Setpoint.HWUnits         = 'ampere';           
AO.Q6.Setpoint.PhysicsUnits    = 'meter^-2';
 
%                                                                                                                                    delta-k
%common          desired                monitor                  setpoint           stat  devlist  elem  scalefactor    range   tol  respkick
q6={
'1Q6U    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [1 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'1Q6D    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [1 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'2Q6U    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [2 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'2Q6D    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [2 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'3Q6U    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [3 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'3Q6D    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [3 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'4Q6U    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [4 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'4Q6D    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [4 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'5Q6U    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [5 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'5Q6D    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [5 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'6Q6U    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [6 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'6Q6D    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [6 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'7Q6U    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [7 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'7Q6D    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [7 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'8Q6U    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [8 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'8Q6D    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [8 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'9Q6U    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [9 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'9Q6D    '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [9 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'10Q6U   '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [10 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'10Q6D   '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [10 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'11Q6U   '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [11 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'11Q6D   '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [11 ,2]  1         1.0         [0 500] 0.050   0.05; ...
'12Q6U   '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [12 ,1]  1         1.0         [0 500] 0.050   0.05; ...
'12Q6D   '    'MS1-QFC:CurrSetptDes '    'SR_Q6:MBUS-AI:C3:S1     '    'SR_Q6:MBUS-AO:C3:S1   '  1  [12 ,2]  1         1.0         [0 500] 0.050   0.05; ...
};
 
for ii=1:size(q6,1)
name=q6{ii,1};      AO.Q6.CommonNames(ii,:)           = name;            
name=q6{ii,3};      AO.Q6.Monitor.ChannelNames(ii,:)  = name;
name=q6{ii,4};      AO.Q6.Setpoint.ChannelNames(ii,:) = name;     
val =q6{ii,5};      AO.Q6.Status(ii,1)                = val;
val =q6{ii,6};      AO.Q6.DeviceList(ii,:)            = val;
val =q6{ii,7};      AO.Q6.ElementList(ii,1)           = val;
val =q6{ii,8};
AO.Q6.Monitor.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
AO.Q6.Monitor.HW2PhysicsParams{2}(ii,:)                = val;
AO.Q6.Setpoint.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.Q6.Setpoint.HW2PhysicsParams{2}(ii,:)               = val;
AO.Q6.Monitor.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
AO.Q6.Monitor.Physics2HWParams{2}(ii,:)                = val;
AO.Q6.Setpoint.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.Q6.Setpoint.Physics2HWParams{2}(ii,:)               = val;
val =q6{ii,9};      AO.Q6.Setpoint.Range(ii,:)        = val;
val =q6{ii,10};     AO.Q6.Setpoint.Tolerance(ii,1)    = val;
val =q6{ii,11};     AO.Q6.Setpoint.DeltaRespMat(ii,1) = val;
end


%===============
%Sextupole data
%===============
% *** SF ***
AO.SF.FamilyName                = 'SF';
AO.SF.MemberOf                  = {'PlotFamily'; 'MachineConfig'; 'Chromaticity Corrector'; 'SD'; 'SEXT'; 'Magnet'};
HW2PhysicsParams                   = magnetcoefficients('SF');
Physics2HWParams                   = magnetcoefficients('SF');

AO.SF.Monitor.Mode              = Mode;
AO.SF.Monitor.DataType          = 'Scalar';
AO.SF.Monitor.Units             = 'Hardware';
AO.SF.Monitor.HW2PhysicsFcn     = @amp2k;
AO.SF.Monitor.Physics2HWFcn     = @k2amp;
AO.SF.Monitor.HWUnits           = 'ampere';           
AO.SF.Monitor.PhysicsUnits      = 'meter^-3';

AO.SF.Setpoint.Mode             = Mode;
AO.SF.Setpoint.DataType         = 'Scalar';
AO.SF.Setpoint.Units            = 'Hardware';
AO.SF.Setpoint.HW2PhysicsFcn    = @amp2k;
AO.SF.Setpoint.Physics2HWFcn    = @k2amp;
AO.SF.Setpoint.HWUnits          = 'ampere';           
AO.SF.Setpoint.PhysicsUnits     = 'meter^-3';

%                                                                                                      delta-k
%common            desired            monitor               setpoint        stat  devlist  elem  scalefactor    range   tol  respkick
sf={
 '1SF1    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [1 ,1]  1          1.0       [0, 500] 0.050   0.05; ...
 '1SF2    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [1 ,2]  2          1.0       [0, 500] 0.050   0.05; ...
 '2SF1    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [2 ,1]  3          1.0       [0, 500] 0.050   0.05; ...
 '2SF2    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [2 ,2]  4          1.0       [0, 500] 0.050   0.05; ...
 '3SF1    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [3 ,1]  5          1.0       [0, 500] 0.050   0.05; ...
 '3SF2    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [3 ,2]  6          1.0       [0, 500] 0.050   0.05; ...
 '4SF1    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [4 ,1]  7          1.0       [0, 500] 0.050   0.05; ...
 '4SF2    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [4 ,2]  8          1.0       [0, 500] 0.050   0.05; ...
 '5SF1    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [5 ,1]  9          1.0       [0, 500] 0.050   0.05; ...
 '5SF2    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [5 ,2]  10          1.0       [0, 500] 0.050   0.05; ...
 '6SF1    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [6 ,1]  11          1.0       [0, 500] 0.050   0.05; ...
 '6SF2    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [6 ,2]  12          1.0       [0, 500] 0.050   0.05; ...
 '7SF1    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [7 ,1]  13          1.0       [0, 500] 0.050   0.05; ...
 '7SF2    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [7 ,2]  14         1.0       [0, 500] 0.050   0.05; ...
 '8SF1    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [8 ,1]  15          1.0       [0, 500] 0.050   0.05; ...
 '8SF2    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [8 ,2]  16          1.0       [0, 500] 0.050   0.05; ...
 '9SF1    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [9 ,1]  17          1.0       [0, 500] 0.050   0.05; ...
 '9SF2    '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [9 ,2]  18          1.0       [0, 500] 0.050   0.05; ...
 '10SF1   '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [10 ,1]  19          1.0       [0, 500] 0.050   0.05; ...
 '10SF2   '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [10 ,2]  20          1.0       [0, 500] 0.050   0.05; ...
 '11SF1   '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [11 ,1]  21         1.0       [0, 500] 0.050   0.05; ...
 '11SF2   '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [11 ,2]  22         1.0       [0, 500] 0.050   0.05; ...
 '12SF1   '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [12 ,1]  23         1.0       [0, 500] 0.050   0.05; ...
 '12SF2   '    'MS1-SF:CurrSetptDes '    'SR_SF:MBUS-AI:C4:S1    '    'SR_SF:MBUS-AO:C4:S1  '  1   [12 ,2]  24         1.0       [0, 500] 0.050   0.05; ...
};

for ii=1:size(sf,1)
name=sf{ii,1};      AO.SF.CommonNames(ii,:)           = name;            
name=sf{ii,3};      AO.SF.Monitor.ChannelNames(ii,:)  = name;
name=sf{ii,4};      AO.SF.Setpoint.ChannelNames(ii,:) = name;     
val =sf{ii,5};      AO.SF.Status(ii,1)                = val;
val =sf{ii,6};      AO.SF.DeviceList(ii,:)            = val;
val =sf{ii,7};      AO.SF.ElementList(ii,1)           = val;
val =sf{ii,8};
AO.SF.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.SF.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
AO.SF.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO.SF.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
AO.SF.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.SF.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO.SF.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO.SF.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =sf{ii,9};      AO.SF.Setpoint.Range(ii,:)        = val;
val =sf{ii,10};     AO.SF.Setpoint.Tolerance(ii,1)    = val;
val =sf{ii,11};     AO.SF.Setpoint.DeltaRespMat(ii,1)         = val;
end


% *** SD ***
AO.SD.FamilyName                = 'SD';
AO.SD.MemberOf                  = {'PlotFamily'; 'MachineConfig'; 'Chromaticity Corrector'; 'SF'; 'SEXT'; 'Magnet'};
HW2PhysicsParams                = magnetcoefficients('SD');
Physics2HWParams                = magnetcoefficients('SD');

AO.SD.Monitor.Mode              = Mode;
AO.SD.Monitor.DataType          = 'Scalar';
AO.SD.Monitor.Units             = 'Hardware';
AO.SD.Monitor.HW2PhysicsFcn     = @amp2k;
AO.SD.Monitor.Physics2HWFcn     = @k2amp;
AO.SD.Monitor.HWUnits           = 'ampere';           
AO.SD.Monitor.PhysicsUnits      = 'meter^-3';

AO.SD.Setpoint.Mode             = Mode;
AO.SD.Setpoint.DataType         = 'Scalar';
AO.SD.Setpoint.Units            = 'Hardware';
AO.SD.Setpoint.HW2PhysicsFcn    = @amp2k;
AO.SD.Setpoint.Physics2HWFcn    = @k2amp;
AO.SD.Setpoint.HWUnits          = 'ampere';           
AO.SD.Setpoint.PhysicsUnits     = 'meter^-3';
              
%                                                                                                      delta-k
%common           desired             monitor               setpoint        stat  devlist  elem  scalefactor    range   tol  respkick
sd={
 '1SD1    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [1 ,1]  1          1.0       [0, 500] 0.050   0.05; ...
 '1SD2    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [1 ,2]  2          1.0       [0, 500] 0.050   0.05; ...
 '2SD1    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [2 ,1]  3          1.0       [0, 500] 0.050   0.05; ...
 '2SD2    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [2 ,2]  4          1.0       [0, 500] 0.050   0.05; ...
 '3SD1    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [3 ,1]  5          1.0       [0, 500] 0.050   0.05; ...
 '3SD2    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [3 ,2]  6          1.0       [0, 500] 0.050   0.05; ...
 '4SD1    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [4 ,1]  7          1.0       [0, 500] 0.050   0.05; ...
 '4SD2    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [4 ,2]  8          1.0       [0, 500] 0.050   0.05; ...
 '5SD1    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [5 ,1]  9          1.0       [0, 500] 0.050   0.05; ...
 '5SD2    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [5 ,2]  10          1.0       [0, 500] 0.050   0.05; ...
 '6SD1    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [6 ,1]  11          1.0       [0, 500] 0.050   0.05; ...
 '6SD2    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [6 ,2]  12          1.0       [0, 500] 0.050   0.05; ...
 '7SD1    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [7 ,1]  13          1.0       [0, 500] 0.050   0.05; ...
 '7SD2    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [7 ,2]  14          1.0       [0, 500] 0.050   0.05; ...
 '8SD1    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [8 ,1]  15          1.0       [0, 500] 0.050   0.05; ...
 '8SD2    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [8 ,2]  16          1.0       [0, 500] 0.050   0.05; ...
 '9SD1    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [9 ,1]  17          1.0       [0, 500] 0.050   0.05; ...
 '9SD2    '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [9 ,2]  18          1.0       [0, 500] 0.050   0.05; ...
 '10SD1   '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [10 ,1]  19          1.0       [0, 500] 0.050   0.05; ...
 '10SD2   '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [10 ,2]  20          1.0       [0, 500] 0.050   0.05; ...
 '11SD1   '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [11 ,1]  21          1.0       [0, 500] 0.050   0.05; ...
 '11SD2   '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [11 ,2]  22          1.0       [0, 500] 0.050   0.05; ...
 '12SD1   '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [12 ,1]  23          1.0       [0, 500] 0.050   0.05; ...
 '12SD2   '    'MS1-SF:CurrSetptDes '    'SR_SD:MBUS-AI:C5:S1    '    'SR_SD:MBUS-AO:C5:S1  '  1   [12 ,2]  24          1.0       [0, 500] 0.050   0.05; ...
};

for ii=1:size(sd,1)
name=sd{ii,3};      AO.SD.Monitor.ChannelNames(ii,:)  = name;
name=sd{ii,4};      AO.SD.Setpoint.ChannelNames(ii,:) = name;     
val =sd{ii,5};      AO.SD.Status(ii,1)                = val;
val =sd{ii,6};      AO.SD.DeviceList(ii,:)            = val;
val =sd{ii,7};      AO.SD.ElementList(ii,1)           = val;
val =sd{ii,8};
AO.SD.Monitor.HW2PhysicsParams{1}(ii,:)               = HW2PhysicsParams;
AO.SD.Monitor.HW2PhysicsParams{2}(ii,:)               = val;
AO.SD.Setpoint.HW2PhysicsParams{1}(ii,:)              = HW2PhysicsParams;
AO.SD.Setpoint.HW2PhysicsParams{2}(ii,:)              = val;
AO.SD.Monitor.Physics2HWParams{1}(ii,:)               = Physics2HWParams;
AO.SD.Monitor.Physics2HWParams{2}(ii,:)               = val;
AO.SD.Setpoint.Physics2HWParams{1}(ii,:)              = Physics2HWParams;
AO.SD.Setpoint.Physics2HWParams{2}(ii,:)              = val;
val =sd{ii,9};      AO.SD.Setpoint.Range(ii,:)        = val;
val =sd{ii,10};     AO.SD.Setpoint.Tolerance(ii,1)    = val;
val =sd{ii,11};     AO.SD.Setpoint.DeltaRespMat(ii,1) = val;
end



% *** Kicker Amplitude ***
AO.KICKER.FamilyName                     = 'KICKER';
AO.KICKER.MemberOf                       = {'Injection'};

AO.KICKER.Monitor.Mode                   = Mode;
AO.KICKER.Monitor.DataType               = 'Scalar';
AO.KICKER.Monitor.Units                  = 'Hardware';
AO.KICKER.Monitor.HWUnits                = 'DAC';           
AO.KICKER.Monitor.PhysicsUnits           = 'mradian';

AO.KICKER.Setpoint.Mode                  = Mode;
AO.KICKER.Setpoint.DataType              = 'Scalar';
AO.KICKER.Setpoint.Units                 = 'Hardware';
AO.KICKER.Setpoint.HWUnits               = 'DAC';           
AO.KICKER.Setpoint.PhysicsUnits          = 'mradian';

%common        monitor          setpoint stat devlist elem range tol
kickeramp={ 
 'K1     '    '02S-K1:PulseAmpl  '     '02S-K1:PulseAmplSetpt  '  1   [2  ,1]  1  [0 9]  0.10 ; ...
 'K2     '    '03S-K2:PulseAmpl  '     '03S-K2:PulseAmplSetpt  '  1   [3  ,1]  2  [0 9]  0.10 ; ...
 'K3     '    '04S-K3:PulseAmpl  '     '04S-K3:PulseAmplSetpt  '  1   [4  ,1]  3  [0 9]  0.10 ; ...
  };

for ii=1:size(kickeramp,1)
name=kickeramp{ii,1};     AO.KICKER.CommonNames(ii,:)          = name;            
name=kickeramp{ii,2};     AO.KICKER.Monitor.ChannelNames(ii,:) = name; 
name=kickeramp{ii,3};     AO.KICKER.Setpoint.ChannelNames(ii,:)= name;     
val =kickeramp{ii,4};     AO.KICKER.Status(ii,1)               = val;
val =kickeramp{ii,5};     AO.KICKER.DeviceList(ii,:)           = val;
val =kickeramp{ii,6};     AO.KICKER.ElementList(ii,1)          = val;
val =kickeramp{ii,7};     AO.KICKER.Setpoint.Range(ii,:)       = val;
val =kickeramp{ii,8};     AO.KICKER.Setpoint.Tolerance(ii,1)   = val;
end

% AO.KICKER.Monitor.HW2PhysicsParams(1,:)    = [1/2.157 0];         %2.157 Volts/radian     
% AO.KICKER.Monitor.Physics2HWParams(1,:)    = [2.157 0];
% AO.KICKER.Setpoint.HW2PhysicsParams(1,:)   = [1/2.157 0];         
% AO.KICKER.Setpoint.Physics2HWParams(1,:)   = [2.157 0];
% AO.KICKER.Monitor.HW2PhysicsParams(2,:)    = [1/4.314 0];          
% AO.KICKER.Monitor.Physics2HWParams(2,:)    = [4.314 0];
% AO.KICKER.Setpoint.HW2PhysicsParams(2,:)   = [1/4.314 0];         
% AO.KICKER.Setpoint.Physics2HWParams(2,:)   = [4.314 0];
% AO.KICKER.Monitor.HW2PhysicsParams(3,:)    = [1/2.157 0];          
% AO.KICKER.Monitor.Physics2HWParams(3,:)    = [2.157 0];
% AO.KICKER.Setpoint.HW2PhysicsParams(3,:)   = [1/2.157 0];         
% AO.KICKER.Setpoint.Physics2HWParams(3,:)   = [2.157 0];

k1hw2physics=1/8691;
k2hw2physics=1/17171;
k3hw2physics=1/8691;
AO.KICKER.Monitor.HW2PhysicsParams(1,:)    = [k1hw2physics 0];     
AO.KICKER.Monitor.Physics2HWParams(1,:)    = [1/k1hw2physics 0];
AO.KICKER.Setpoint.HW2PhysicsParams(1,:)   = [k1hw2physics 0];         
AO.KICKER.Setpoint.Physics2HWParams(1,:)   = [1/k1hw2physics 0];
AO.KICKER.Monitor.HW2PhysicsParams(2,:)    = [k2hw2physics 0];          
AO.KICKER.Monitor.Physics2HWParams(2,:)    = [1/k2hw2physics 0];
AO.KICKER.Setpoint.HW2PhysicsParams(2,:)   = [k2hw2physics 0];         
AO.KICKER.Setpoint.Physics2HWParams(2,:)   = [1/k2hw2physics 0];
AO.KICKER.Monitor.HW2PhysicsParams(3,:)    = [k3hw2physics 0];          
AO.KICKER.Monitor.Physics2HWParams(3,:)    = [1/k3hw2physics 0];
AO.KICKER.Setpoint.HW2PhysicsParams(3,:)   = [k3hw2physics 0];         
AO.KICKER.Setpoint.Physics2HWParams(3,:)   = [1/k3hw2physics 0];

%hw2physics=0.155;
% AO.KICKER.Monitor.HW2PhysicsParams(1,:)    = [hw2physics 0];         %0.155mrad/kV_pulser     
% AO.KICKER.Monitor.Physics2HWParams(1,:)    = [1/hw2physics 0];
% AO.KICKER.Setpoint.HW2PhysicsParams(1,:)   = [hw2physics 0];         
% AO.KICKER.Setpoint.Physics2HWParams(1,:)   = [1/hw2physics 0];
% AO.KICKER.Monitor.HW2PhysicsParams(2,:)    = [hw2physics 0];          
% AO.KICKER.Monitor.Physics2HWParams(2,:)    = [1/hw2physics 0];
% AO.KICKER.Setpoint.HW2PhysicsParams(2,:)   = [hw2physics 0];         
% AO.KICKER.Setpoint.Physics2HWParams(2,:)   = [1/hw2physics 0];
% AO.KICKER.Monitor.HW2PhysicsParams(3,:)    = [hw2physics 0];          
% AO.KICKER.Monitor.Physics2HWParams(3,:)    = [1/hw2physics 0];
% AO.KICKER.Setpoint.HW2PhysicsParams(3,:)   = [hw2physics 0];         
% AO.KICKER.Setpoint.Physics2HWParams(3,:)   = [1/hw2physics 0];


% *** Kicker Delay ***
AO.KICKERDELAY.FamilyName                     = 'KICKERDELAY';
AO.KICKERDELAY.MemberOf                       = {'Injection'};

AO.KICKERDELAY.Monitor.Mode                   = Mode;
AO.KICKERDELAY.Monitor.DataType               = 'Scalar';
AO.KICKERDELAY.Monitor.Units                  = 'Hardware';
AO.KICKERDELAY.Monitor.HWUnits                = 'volts';           
AO.KICKERDELAY.Monitor.PhysicsUnits           = 'radian';

AO.KICKERDELAY.Setpoint.Mode                  = Mode;
AO.KICKERDELAY.Setpoint.DataType              = 'Scalar';
AO.KICKERDELAY.Setpoint.Units                 = 'Hardware';
AO.KICKERDELAY.Setpoint.HWUnits               = 'ampere';           
AO.KICKERDELAY.Setpoint.PhysicsUnits          = 'radian';

%common        monitor                  setpoint                  stat  devlist elem range tol
kickeramp={ 
 'K1     '    '02S-K1:PulseDelay  '     '02S-K1:PulseDelaySetpt  '  1   [2  ,1]  1  [0 9]  0.10 ; ...
 'K2     '    '03S-K2:PulseDelay  '     '03S-K2:PulseDelaySetpt  '  1   [3  ,1]  2  [0 9]  0.10 ; ...
 'K3     '    '04S-K3:PulseDelay  '     '04S-K3:PulseDelaySetpt  '  1   [4  ,1]  3  [0 9]  0.10 ; ...
  };

for ii=1:size(kickeramp,1)
name=kickeramp{ii,1};     AO.KICKERDELAY.CommonNames(ii,:)          = name;            
name=kickeramp{ii,2};     AO.KICKERDELAY.Monitor.ChannelNames(ii,:) = name; 
name=kickeramp{ii,3};     AO.KICKERDELAY.Setpoint.ChannelNames(ii,:)= name;     
val =kickeramp{ii,4};     AO.KICKERDELAY.Status(ii,1)               = val;
val =kickeramp{ii,5};     AO.KICKERDELAY.DeviceList(ii,:)           = val;
val =kickeramp{ii,6};     AO.KICKERDELAY.ElementList(ii,1)          = val;
val =kickeramp{ii,7};     AO.KICKERDELAY.Setpoint.Range(ii,:)       = val;
val =kickeramp{ii,8};     AO.KICKERDELAY.Setpoint.Tolerance(ii,1)   = val;

AO.KICKERDELAY.Monitor.HW2PhysicsParams(ii,:)    = [1 0];          
AO.KICKERDELAY.Monitor.Physics2HWParams(ii,:)    = [1 0];
AO.KICKERDELAY.Setpoint.HW2PhysicsParams(ii,:)   = [1 0];         
AO.KICKERDELAY.Setpoint.Physics2HWParams(ii,:)   = [1 0];
end


%============
%RF System
%============
AO.RF.FamilyName                  = 'RF';
AO.RF.MemberOf                    = {'MachineConfig'; 'RF'};
AO.RF.Status                      = 1;
AO.RF.CommonNames                 = 'RF';
AO.RF.DeviceList                  = [1 1];
AO.RF.ElementList                 = [1];

%Frequency Readback
AO.RF.Monitor.Mode                = Mode;
AO.RF.Monitor.DataType            = 'Scalar';
AO.RF.Monitor.Units               = 'Hardware';
AO.RF.Monitor.HW2PhysicsParams    = 1e+3;       %no hw2physics function necessary   
AO.RF.Monitor.Physics2HWParams    = 1e-3;
AO.RF.Monitor.HWUnits             = 'kHz';           
AO.RF.Monitor.PhysicsUnits        = 'Hz';
AO.RF.Monitor.ChannelNames        = 'SR:RF00:SI02';     

%Frequency Setpoint
AO.RF.Setpoint.Mode               = Mode;
AO.RF.Setpoint.DataType           = 'Scalar';
AO.RF.Setpoint.Units              = 'Hardware';
AO.RF.Setpoint.HW2PhysicsParams   = 1e+3;         
AO.RF.Setpoint.Physics2HWParams   = 1e-3;
AO.RF.Setpoint.HWUnits            = 'kHz';           
AO.RF.Setpoint.PhysicsUnits       = 'Hz';
AO.RF.Setpoint.ChannelNames       = 'SR:RF00:SO02';     
AO.RF.Setpoint.Range              = [0 600000];
AO.RF.Setpoint.Tolerance          = 1e-3;

%Voltage monitor
AO.RF.Voltage.Mode               = Mode;
AO.RF.Voltage.DataType           = 'Scalar';
AO.RF.Voltage.Units              = 'Hardware';
AO.RF.Voltage.HW2PhysicsParams   = 1;         
AO.RF.Voltage.Physics2HWParams   = 1;
AO.RF.Voltage.HWUnits            = 'Volts';           
AO.RF.Voltage.PhysicsUnits       = 'Volts';
AO.RF.Voltage.ChannelNames       = 'SR:RF01:AI16';     
AO.RF.Voltage.Range              = [-inf inf];
AO.RF.Voltage.Tolerance          = inf;


%====
%TUNE
%====
AO.TUNE.FamilyName  = 'TUNE';
AO.TUNE.MemberOf    = {'TUNE'; 'Diagnostics'};
AO.TUNE.DeviceList  = [ 1 1; 1 2; 1 3];
AO.TUNE.ElementList = [1 2 3]';
AO.TUNE.Status      = [1 1 0]';
AO.TUNE.Position                       = 0;

AO.TUNE.Monitor.Mode                   = Mode;
AO.TUNE.Monitor.DataType               = 'Special';
AO.TUNE.Monitor.SpecialFunctionGet     = 'gettune_pls';
AO.TUNE.Monitor.Units                  = 'Hardware';
AO.TUNE.Monitor.HW2PhysicsParams       = 1;
AO.TUNE.Monitor.Physics2HWParams       = 1;
AO.TUNE.Monitor.HWUnits                = 'fractional tune';           
AO.TUNE.Monitor.PhysicsUnits           = 'fractional tune';


%====
%DCCT
%====
AO.DCCT.FamilyName                     = 'DCCT';
AO.DCCT.MemberOf                       = {'Diagnostics'};
AO.DCCT.CommonNames                    = 'DCCT';
AO.DCCT.DeviceList                     = [1 1];
AO.DCCT.ElementList                    = 1;
AO.DCCT.Status                         = 1;
AO.DCCT.Position                       = 0;  % ???

AO.DCCT.Monitor.Mode                   = Mode;
AO.DCCT.Monitor.DataType               = 'Scalar';
AO.DCCT.Monitor.ChannelNames           = 'BEAMCURRENT';    
AO.DCCT.Monitor.Units                  = 'Hardware';
AO.DCCT.Monitor.HWUnits                = 'milli-ampere';           
AO.DCCT.Monitor.PhysicsUnits           = 'ampere';
AO.DCCT.Monitor.HW2PhysicsParams       = 1;          
AO.DCCT.Monitor.Physics2HWParams       = 1;


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


% Convert DeltaRespMat to hardware units
AO = getao;
AO.HCM.Setpoint.DeltaRespMat = ones(size(AO.HCM.DeviceList,1),1); %abs(physics2hw(AO.HCM.FamilyName,'Setpoint', AO.HCM.Setpoint.DeltaRespMat, AO.HCM.DeviceList));
AO.VCM.Setpoint.DeltaRespMat = ones(size(AO.VCM.DeviceList,1),1); %abs(physics2hw(AO.VCM.FamilyName,'Setpoint', AO.VCM.Setpoint.DeltaRespMat, AO.VCM.DeviceList));

AO.Q1.Setpoint.DeltaRespMat = ones(size(AO.Q1.DeviceList,1),1); %abs(physics2hw(AO.Q1.FamilyName,'Setpoint',AO.Q1.Setpoint.DeltaRespMat,AO.Q1.DeviceList));
AO.Q2.Setpoint.DeltaRespMat = ones(size(AO.Q2.DeviceList,1),1); %abs(physics2hw(AO.Q2.FamilyName,'Setpoint',AO.Q2.Setpoint.DeltaRespMat,AO.Q2.DeviceList));
AO.Q3.Setpoint.DeltaRespMat = ones(size(AO.Q3.DeviceList,1),1); %=abs(physics2hw(AO.Q3.FamilyName,'Setpoint',AO.Q3.Setpoint.DeltaRespMat,AO.Q3.DeviceList));
AO.Q4.Setpoint.DeltaRespMat = ones(size(AO.Q4.DeviceList,1),1); %=abs(physics2hw(AO.Q4.FamilyName,'Setpoint',AO.Q4.Setpoint.DeltaRespMat,AO.Q4.DeviceList));
AO.Q5.Setpoint.DeltaRespMat = ones(size(AO.Q5.DeviceList,1),1); %=abs(physics2hw(AO.Q5.FamilyName,'Setpoint',AO.Q5.Setpoint.DeltaRespMat,AO.Q5.DeviceList));
AO.Q6.Setpoint.DeltaRespMat = ones(size(AO.Q6.DeviceList,1),1); %=abs(physics2hw(AO.Q6.FamilyName,'Setpoint',AO.Q6.Setpoint.DeltaRespMat,AO.Q6.DeviceList));

AO.SF.Setpoint.DeltaRespMat = 3*ones(size(AO.SF.DeviceList,1),1); %=abs(physics2hw(AO.SF.FamilyName,'Setpoint',AO.SF.Setpoint.DeltaRespMat,AO.SF.DeviceList));
AO.SD.Setpoint.DeltaRespMat = 4*ones(size(AO.SD.DeviceList,1),1); %=abs(physics2hw(AO.SD.FamilyName,'Setpoint',AO.SD.Setpoint.DeltaRespMat,AO.SD.DeviceList));
setao(AO);



