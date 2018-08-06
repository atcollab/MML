  THE DATE AND TIME OF THIS RUN : Thu Feb 14 18:12:55 2002

                TITLE                                                                          
               CLS 500, OCT 1999 , MULTIPOLES CORRECTED AUG 2000                               
               CX:GKICK,L=0,DXP=0                                                              
               CY:GKICK,L=0,DYP=0                                                              
               OF:GKICK,L=0,DX=.000                                                            
               YYY:MARKER                                                                      
               OCK:GKICK,L=0,DXP=.0001                                                         
               MV:MONITOR                                                                      
               MH:MONITOR                                                                      
               MARK:MARKER                                                                     
               D1:DRIFT,L=.25                                                                  
               D1KK:DRIFT,L=.175                                                               
               D1B:DRIFT,L=.35                                                                 
               D1BB:DRIFT,L=.225                                                               
               D1D:DRIFT,L=.212                                                                
               D1CC:DRIFT,L=.075                                                               
               D1C:DRIFT,L=.175                                                                
               D2:DRIFT,L=0.26                                                                 
               D2KK:DRIFT,L=0.185                                                              
               D3:DRIFT,L=0.305                                                                
               D4:DRIFT,L=.407                                                                 
               D5:DRIFT,L=.309                                                                 
               D6:DRIFT,L=.156                                                                 
               D7:DRIFT,L=.394                                                                 
               D8:DRIFT,L=.322                                                                 
               DQ:DRIFT,L=.006                                                                 
               DQL:DRIFT,L=.0085                                                               
               DQS:DRIFT,L=.007                                                                
               FQ1=1.77027                                                                     
               FQ2=1.73328                                                                     
               FQ3=2.03477 
               !Quadrupoles
               !Write Grouped Cell Quadrupoles - DO NOT REMOVE THIS LINE: command used to fill skeleton deck
               FS1 = -25.3797                                                                  
               FS2 =  39.1415             
               !Write Grouped Cell Sextupoles - DO NOT REMOVE THIS LINE: command used to fill skeleton deck
               Q1C:MULTIPOLE,L=.18,K1=FQ1,APERTURE=.01, &                                      
               K5=FQ1*5.722E4,K9=FQ1*1.65E14,K13=FQ1*2.701E24                                  
               Q2C:MULTIPOLE,L=.18,K1=FQ2,APERTURE=.01, &                                      
               K5=FQ2*5.722E4,K9=FQ2*1.65E14,K13=FQ2*2.701E24                                  
               Q3C:MULTIPOLE,L=.26,K1=FQ3,APERTURE=.01, &                                      
               K5=FQ3*5.722E4,K9=FQ3*1.65E14,K13=FQ3*2.701E24                                  
               S1:MULTIPOLE,L=.192,K2=FS1,APERTURE=.01, &                                      
               K8=FS1*8.261E10,K14=FS1*5.95E+25                                                
               S2:MULTIPOLE,L=.192,K2=FS2,APERTURE=.01, &                                      
               K8=FS2*8.261E10,K14=FS2*5.95E+25   
               !Dipoles
               FB1=-0.39280000
               !Write Grouped Cell Dipoles - DO NOT REMOVE THIS LINE: command used to fill skeleton deck
               HC:SBEND,L=1.87,ANGLE=0.2617994,E1=0.105,E2=.105,K1=FB1, &                 
               HGAP=.025,FINT=0.68,FINTX=0.68,K2=-.074                                         
               HM:MULTIPOLE, &                                                                 
                K3=12.01E1/2, &                                                                
                K4=1.939E3/2, K5=3.232E5/2, &                                                  
                K6=6.464E7/2, K7=1.508E10/2, &                                                 
                K8=4.022E12/2, K9=1.207E15/2, &                                                
                K10=4.022E17/2, K11=1.475E20/2, &                                              
                K12=5.899E22, K13=2.556E25                                                     
               KK1:GKICK,L=.15,DXP=-.0005                                                      
               KK2:GKICK,L=0,DXP=.00124248                                                     
               KK3:GKICK,L=0,DXP=.000                                                          
               KK4:GKICK,L=0,DXP=-.0085                                                        
               KK5:GKICK,L=0,DXP=.00733                                                        
               KK6:GKICK,L=.15,DXP=.000416                                                     
               KK1:GKICK,L=.15,DXP=-.000                                                       
               KK2:GKICK,L=.2,DXP=.00                                                          
               KK3:GKICK,L=0,DXP=.000                                                          
               KK4:GKICK,L=0,DXP=-.0                                                           
               KK5:GKICK,L=.2,DXP=.00                                                          
               KK6:GKICK,L=.15,DXP=.000                                                        
               KSYN:GKICK,L=0.,DP=-.000042,V=1,T=1                                             
               KSYN:GKICK,L=0.,DP=-.000194,V=1,T=1                                             
               KSYN:GKICK,L=0.,DP=-.000302,V=1,T=1                                             
                CAV:RFCAVITY,L=0.,VOLT=2.65,LAG=3.115,FREQ=285.,ENERGY=1.5;                    
                CAV:RFCAVITY,L=0.,VOLT=2.65,LAG=2.955,FREQ=285.,ENERGY=2.5;                    
                CAV:RFCAVITY,L=0.,VOLT=2.65,LAG=2.8,FREQ=285.,ENERGY=2.9;                      
               Q1:LINE=(DQS,Q1C,DQS)                                                           
               Q2:LINE=(DQS,Q2C,DQS)                                                           
               Q3:LINE=(DQL,Q3C,DQL)                                                           
               CELL:LINE=(MARK,9*D1,D1B,MH,MV,Q1, &                                            
               D2,CX,D2,Q2,D3,HM,HC,HM,MH,D4,S1,CX,CY, &                                       
               D5,Q3,D6, &                                                                     
               S2,D6,Q3,D7,CX,CY,S1,D8,MH,MV,HM,HC,HM,D3,Q2,D2,CY,CX,D2,Q1, &                  
               MH,MV,D1B,9*D1)                                                                 
               CELL2:LINE=(MARK,9*D1,D1B,MH,MV,Q1, &                                           
               D2,CX,D2,Q2,D3,HM,HC,HM,MH,D4,S1,CX,CY, &                                       
               D5,Q3,D6, &                                                                     
               S2,D6,Q3,D7,CX,CY,S1,D8,MH,MV,HM,HC,HM,D3,Q2,D2KK,CY,CX,KK1,D2KK,Q1, &          
               MH,MV,D1BB,KK2,D1KK,D1CC,KK3,D1C,7*D1, &                                        
               MARK,7*D1,D1C,KK4,D1CC,D1KK,KK5,D1BB,MH,MV,Q1, &                                
               D2KK,KK6,D2KK,Q2,D3,HM,HC,HM,MH,D4,S1,CX,CY, &                                  
               D5,Q3,D6, &                                                                     
               S2,D6,Q3,D7,CX,CY,S1,D8,MH,MV,HM,HC,HM,D3,Q2,D2,CY,CX,D2,Q1, &                  
               MH,MV,D1B,9*D1)                                                                 
               RING:LINE=( &                                                                   
              10*CELL,CELL2,KSYN,CAV &                                                        
               )                                                                               
               USE,RING                                                                        
               DIMAT                                                                           
