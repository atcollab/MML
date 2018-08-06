%check of ADR data from 8/9/06 and 8/31/06

%8/9/06
format long
CD1a=1.057198+0.098126+2.219681+0.179035; 
CD2a=1.057198;
CD3a=1.0773;
CD4a=1.0773+0.099986+2.248227+0.099015;

%8/31/06
disp('')
CD1=3.554; disp(['CD1 ' num2str(CD1a,8) '   ' num2str(CD1a,8) '   ' num2str(CD1-CD1a,8)])
CD2=sqrt(0.00499^2 + 1.05716^2); disp(['CD2 ' num2str(CD2a,8) '   '  num2str(CD2,8) '   '  num2str(CD2-CD2a,8)])
CD3=sqrt(0.01958^2 + 1.07729^2); disp(['CD3 ' num2str(CD3a,8) '   '  num2str(CD3,8) '   '  num2str(CD3-CD3a,8)])
CD4=3.52448; disp(['CD4 ' num2str(CD4a,8) '   '  num2str(CD4,8) '   '  num2str(CD4-CD4a,8)])
format


sp3v82;
global THERING
indx=ATIndex(THERING);

% 9S straight section elements
% S9=[D9S1 THINCOR CD1 D9S2A BPM D9S2B BPM D9S2C THINCOR CD2 D9S3 THINCOR QF9_1...
%       D9S4 

%QD9_1 D9S5A BPM D9S5B QF9_2 THINCOR D9S6 CD3 THINCOR D9S7A BPM D9S7B BPM D9S7C CD4 THINCOR D9S8]

%center of triplet is indx.Q9S(2);
ictr=indx.Q9S(2);
ictr=indx.Q9S(3);    %modify to third entry after splitting quadrupoles
sctr=findspos(THERING,ictr)+THERING{ictr}.Length/2;  %findspos yields start of element


%DOWNSTREAM OF 9S CENTER
%BPM3 location
t=findspos(THERING,indx.D9S5A+1)-sctr;
disp(['  BPM3 center position : ' num2str(t)   ' desired : ' num2str(0.425)  ])

hcd=0.055;
%CD3 location
t=findspos(THERING,indx.D9S6+1)-sctr+hcd; % -1.0773;
disp(['  CD3 center position : ' num2str(t) ' desired : ' num2str(1.0773) ])

%BPM4 location
t=findspos(THERING,indx.D9S7A+1)-sctr; %-1.0773-0.099986;
disp(['  BPM4 center position : ' num2str(t) ' desired : ' num2str(1.0773+0.099986) ])

%BPM5 location
t=findspos(THERING,indx.D9S7B+1)-sctr; %-1.0773-0.099986-2.248227;
disp(['  BPM5 center position : ' num2str(t) ' desired : ' num2str(1.0773+0.099986+2.248227) ])

%CD4 location
t=findspos(THERING,indx.D9S7C+1)-sctr +hcd; %-1.0773-0.099986-2.248227-0.099015;
disp(['  CD4 center position : ' num2str(t) ' desired : ' num2str(1.0773+0.099986+2.248227+0.099015) ])

%UPSTREAM OF 9S CENTER
%CD2 location
t=sctr-(findspos(THERING,indx.D9S3)-hcd);
disp(['  CD2 center position : ' num2str(t)   ' desired : ' num2str(1.057198)  ])

%BPM2 location
t=sctr-(findspos(THERING,indx.D9S2C));
disp(['  BPM2 center position : ' num2str(t)   ' desired : ' num2str(1.057198+0.098126)  ])

%BPM1 location
t=sctr-(findspos(THERING,indx.D9S2B));
disp(['  BPM1 center position : ' num2str(t)   ' desired : ' num2str(1.057198+0.098126+2.219681)  ])

%CD1 location
t=sctr-(findspos(THERING,indx.D9S2A)-hcd);
disp(['  CD1 center position : ' num2str(t)   ' desired : ' num2str(1.057198+0.098126+2.219681+0.179035)  ])

%August 16, 2006  modify for split CD magnets
%Double check downstream of 9S center
t=-THERING{ictr}.Length/2;
for ii=ictr:ictr+18
t=t+(THERING{ii}.Length);
if strcmpi(THERING{ii}.FamName,'BPM') disp([THERING{ii}.FamName '  ' num2str(t)]);  end  
if strcmpi(THERING{ii}.FamName(1:2),'CD') 
    disp([THERING{ii}.FamName '  ' num2str(t-hcd)]); 
end  
end


%Double check upstream of 9S center
disp(' ')
t=-THERING{ictr}.Length/2;
for ii=ictr:-1:ictr-16
t=t+(THERING{ii}.Length);
if strcmpi(THERING{ii}.FamName,'BPM') disp([THERING{ii}.FamName '  ' num2str(t)]);  end  
if strcmpi(THERING{ii}.FamName(1:2),'CD') 
    disp([THERING{ii}.FamName '  ' num2str(t-hcd)]);  
end  
end


