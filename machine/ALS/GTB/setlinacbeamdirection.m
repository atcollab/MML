function setlinacbeamdirection(BeamDirection)

%  setlinacbeamdirection
%
%  NOTES
%  1. LTB_____BS_FC__BM10 and LTB_____BS_LTB_BM11 do not appear to work
%  2. If this function doesn't work, power cycle (breaker) the BS magnet

if nargin < 1 || isempty(BeamDirection)
    %BeamDirection = 'Booster';
    BeamDirection = questdlg({'Choose the linac beam direction?'},'Linac Beam Direction','Booster','Faraday Cup','Booster');
    if isempty(BeamDirection)
            fprintf('   setlinacbeamdirection canceled\n');
        return
    end
end


% Booster or Faraday Cup
try
    if strcmpi(BeamDirection,'Booster')
        % Switch to BR (if necessary)
        if getpv('LTB_____BS_LTB_BC23')==1 && getpv('LTB_____BS_FC__BC22')==0 % && getpv('LTB_____BS_FC__BM10')==0 && getpv('LTB_____BS_LTB_BM11')==1 (BM does not appear to work0?)
            fprintf('   Beam is already switched towards the booster (not the Faraday Cup).\n');
        else
            %if getsp('BEND',[3 1]) > 20
            %    fprintf('   Beam is going to the Faraday Cup!\n');
            %else
            %    fprintf('   Beam might be going toward the Faraday Cup.  Check again when BS is at operating current.\n');
            %end
            
            fprintf('      Changing the Linac beam to go toward the booster ... ');
            % Should ramp BS down to 25.5, then switch setpv('LTB_____BS_LTB_BC23',0) setpv('LTB_____BS_FC__BC22', 1)
            T_BS = getramptime('BEND', 25.5, [3 1]);
            BS = getsp('BEND', [3 1]);
            setsp('BEND', 25.5, [3 1]);
            if T_BS > 0
                pause(T_BS+10);
            end
            setpv('LTB_____BS_LTB_BC23', 1);
            setpv('LTB_____BS_FC__BC22', 0);
            setsp('BEND',BS, [3 1]);
            fprintf('Done\n');
        end
        
    elseif strcmpi(BeamDirection,'Faraday Cup')
        % Switch to Faraday Cup (if necessary)
        if getpv('LTB_____BS_LTB_BC23')==0 && getpv('LTB_____BS_FC__BC22')==1
            fprintf('   Linac beam is already going to the Faraday Cup.\n');
        else
            fprintf('      Changing the Linac beam to go toward the Faraday Cup ... ');
            % Should ramp BS down to 25.5, then switch setpv('LTB_____BS_LTB_BC23', 1) setpv('LTB_____BS_FC__BC22', 0)
            % To go toward the Faraday Cup
            T_BS = getramptime('BEND', 25.5, [3 1]);
            BS = getsp('BEND', [3 1]);
            setsp('BEND', 25.5, [3 1]);
            if T_BS > 0
                pause(T_BS+10);
            end
            setpv('LTB_____BS_LTB_BC23', 0);
            setpv('LTB_____BS_FC__BC22', 1);
            setsp('BEND',BS, [3 1]);
            fprintf('Done\n');
        end
    end
catch
    fprintf(2, '   Error determining if using the Faraday Cup or if the beam will go to the booster.\n');
end
