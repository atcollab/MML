% check mcors for corrector magnets
%
% program ramps mcor for each magnet in 5 amp steps from
% starting level to about +25 amp, then down to -25 amp
% and then returns to original value
%
% J. Corbett and R. Berg   April, 2005
% load mcor device list

spmin=-20;   %use -20 amp to achieve -25 amp limit
spmax=+20;
step=5;

Families={'HCM' 'VCM'};
am=0;

for ii=1:length(Families)         %   loop over families
Devlist=getlist(Families{ii});    %   load devicelist

   for jj=1:size(Devlist,1)       %   loop over devicelist
    
       hitTop = 0;
        hitBtm = 0;
        sp=getsp(Families{ii},Devlist(jj,:));
        dir = 1; %start out going up
        Done = 0;
        newSp = sp;
        d=num2str(Devlist(jj,1));   %   device
        l=num2str(Devlist(jj,2));   %   list
        
        
        fprintf('original sp is %f\n',sp);    
        while (Done == 0) 

            newSp = newSp + step*dir;
            if((newSp > spmax) && (dir == 1))
                dir = -1; %go down
                hitTop = 1;
            end    
            if((newSp < spmin) && (dir == -1))
                dir = 1; %go up
                hitBtm = 1;

           end 
            if(hitTop == 1 && hitBtm == 1 && newSp == sp)
                break;
            end    
            setsp(Families{ii},newSp,Devlist(jj,:));
            pause(0.5);
            am=getam(Families{ii},Devlist(jj,:));   %   monitor
            disp(['Family ' Families{ii} ' Device [' d ' ' l '] Setpoint: ' num2str(newSp) '    Readback: ' num2str(am) '    Difference: ' num2str(newSp-am)]);
        end

        setsp(Families{ii},sp,Devlist(jj,:));
        pause(0.5);
        am=getam(Families{ii},Devlist(jj,:));   %   monitor
        disp(['Family ' Families{ii} ' Device [' d ' ' l '] Setpoint: ' num2str(sp) '    Readback: ' num2str(am) '    Difference: ' num2str(sp-am)]);

   end


end

