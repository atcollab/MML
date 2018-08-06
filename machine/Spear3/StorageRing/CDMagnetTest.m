%CD magnet test


% %CD1
% close all
% cur1=[0.837
% 1.827
% 5.898
% 8.938
% 12.014
% 15.017
% 18.093
% 21.133
% 24.207
% 27.169
% 30.244
% ];
% 
% %raw data
% BL1Data=[0.001197
% 0.002948
% 0.0058
% 0.008628
% 0.01148
% 0.01427
% 0.017225
% 0.02011
% 0.023009
% 0.025834
% 0.028729];
% 
% %polynomial fit
% BL1=[0.00135956
% 0.00267525
% 0.006065913
% 0.008476419
% 0.011367938
% 0.014364614
% 0.017308551
% 0.020063496
% 0.02292571
% 0.025911903
% 0.028710649
% ];
% 
% angle=10.00692271077745*amp2k('CD','Setpoint',cur1,[9 1]);
% plot(cur1,BL1Data)
% hold on; plot(cur1,BL1,'r+');   %polynomial fit from Jack
% plot(cur1,BL1Data,'b*');        %Data
% plot(cur1,angle,'k*');          %polynomial fit from MATLAB
% 
% 
% 
% amp=k2amp('CD','Setpoint',angle/10.00692271077745,[9 1]);
% 
% 
% 
% [amp cur1]



% %CD2
% close all
% cur2=[0.72
% 6.969
% 14.027
% 21.134
% 28.169
% 35.25
% 42.438
% 49.524
% 56.579
% 63.656
% 70.82
% 
% ];
% 
% %raw data
% BL2Data=[0.000873
% 0.005585
% 0.010715
% 0.016235
% 0.021472
% 0.026696
% 0.032164
% 0.037657
% 0.043051
% 0.048456
% 0.05359
% ];
% 
% %polynomial fit
% BL2=[0.000886758
% 0.00552321
% 0.010825134
% 0.016165887
% 0.021436816
% 0.026747628
% 0.032183518
% 0.037612537
% 0.043063586
% 0.048461305
% 0.053587622
% 
% ];
% 
% angle=10.00692271077745*amp2k('CD','Setpoint',cur2,[9 2]);
% plot(cur2,BL2Data)
% hold on; plot(cur2,BL2,'r+');   %polynomial fit from Jack
% plot(cur2,BL2Data,'b*');        %Data
% plot(cur2,angle,'k*');          %polynomial fit from MATLAB
% 
% 
% 
% amp=k2amp('CD','Setpoint',angle/10.00692271077745,[9 2]);
% 
% 
% 
% [amp cur2]


% %CD3
% close all
% cur3=[0.726
% 20.139
% 40.361
% 60.59
% 81.01
% 101.267
% 121.347
% 141.666
% 161.965
% 182.155
% 202.528
% 220.633
% 240.976
% 261.281
% 281.549
% 301.76
% ];
% 
% %raw data
% BL3Data=[0.001005
% 0.015117
% 0.02994
% 0.044912
% 0.060018
% 0.074959
% 0.089638
% 0.104266
% 0.118283
% 0.12963
% 0.137845
% 0.143671
% 0.149392
% 0.154296
% 0.158682
% 0.162547
% ];
% 
% %polynomial fit
% BL3=[0.000793902
% 0.015621849
% 0.029950506
% 0.044446034
% 0.059658692
% 0.0751225
% 0.090278109
% 0.104769474
% 0.117776114
% 0.128813578
% 0.137844693
% 0.144175888
% 0.14972997
% 0.154200551
% 0.158303573
% 0.162715571
% ];
% 
% angle=10.00692271077745*amp2k('CD','Setpoint',cur3,[9 3]);
% plot(cur3,BL3Data)
% hold on; plot(cur3,BL3,'r+');   %polynomial fit from Jack
% plot(cur3,BL3Data,'b*');        %Data
% plot(cur3,angle,'k*');          %polynomial fit from MATLAB
% 
% 
% 
% amp=k2amp('CD','Setpoint',angle/10.00692271077745,[9 3]);
% 
% 
% 
% [amp cur3]

%CD4
close all
cur4=[0.869
14.026
28.169
42.437
56.579
70.823
85.028
99.193
113.302
127.441
141.675
];

%raw data
BL4Data=[0.001179
0.013215
0.026229
0.039574
0.052599
0.065432
0.075025
0.080484
0.084522
0.087829
0.090492
];

%polynomial fit
BL4=[0.001116577
0.013472964
0.025904683
0.039467829
0.053108692
0.065307922
0.074600111
0.080753865
0.084644431
0.08767146
0.090531463
];

angle=10.00692271077745*amp2k('CD','Setpoint',cur4,[9 4]);  %use factor of 10 to agree with Jack (B-rho)
plot(cur4,BL4Data)
hold on; plot(cur4,BL4,'r+');   %polynomial fit from Jack
plot(cur4,BL4Data,'b*');        %Data
plot(cur4,angle,'k*');          %polynomial fit from MATLAB



amp=k2amp('CD','Setpoint',angle/10.00692271077745,[9 4]);



[amp cur4]

ACD1 =  +0.002000;  % bend angles from Ringwall
ACD2 =  +0.0048325;
ACD3 =  -0.0148325;
ACD4 =  +0.008000;

disp([' Current for CD1:' num2str([ACD1 k2amp('CD','Setpoint',ACD1,[9 1])])]);
disp([' Current for CD2:' num2str([ACD2 k2amp('CD','Setpoint',ACD2,[9 2])])])
disp([' Current for CD3:' num2str([ACD3 k2amp('CD','Setpoint',ACD3,[9 3])])])
disp([' Current for CD4:' num2str([ACD4 k2amp('CD','Setpoint',ACD4,[9 4])])])
% DevList=getlist('CD');
% 
% for ii=1:4
%     
% CDName=CDNames{ii};   
% sp=getsp('CD',DevList(ii,:));
% angle=getsp('CD','physics',DevList(ii,:));
% disp(['CD [' num2str(DevList(ii,:)) '] setpoint ' num2str(sp) ' angle ' num2str(angle)])
% end