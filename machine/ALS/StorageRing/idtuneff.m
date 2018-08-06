addQFsp = zeros(24,1);
addQDsp = zeros(24,1);


% EPUs excite nux = .25 resonance in vertical linear polarization mode!
% therefore with EPU tune feedforward
% running, we want to move our nominal working point away (just below) the .25 resonance.
%
% The following tune correction moves nominal
% nu_x from .25 to .245 - this should be enough for well set up lattices.
%
% 24 QF+ 24 QD
DeltaAmps = inv(SR_TUNE_MATRIX) * [-0.005;0];    %  DelAmps =  [QF; QD];
addQFsp = addQFsp + DeltaAmps(1,:);
addQDsp = addQDsp + DeltaAmps(2,:);

for gapnum = 1:length(actualgap)
    % Change in tune and [QF;QD] from maximum gap
    if (IDSector(gapnum,1) == 4) || (IDSector(gapnum,1) == 11)
        if IDSector(gapnum,2) == 1
            modenamestr = sprintf('SR%02dU___ODS1M__DC00',IDSector(gapnum,1));
        else % if IDSector(gapnum,2) == 2
            modenamestr = sprintf('SR%02dU___ODS2M__DC00',IDSector(gapnum,1));
        end
        epumode = getpv(modenamestr);
        if (IDSector(gapnum,1) == 4) && (IDSector(gapnum,2) == 1)
            if 1   % temporary fix as long as we do not have good tune FF table without shims (2008-02-15)
                if (epumode==0)
                    DeltaNuX = shift2tune(IDSector(gapnum,:),actualgap(gapnum),Shift(gapnum));
                    DeltaNuY = 0;
                else
                    DeltaNuX = 0;
                    DeltaNuY = 0;
                end
            elseif (epumode == 0)
                %                                                 DeltaNuX = interp2(gap_epu_41,shift_epu_41,dnux_epu_41_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
                %                                                 DeltaNuY = interp2(gap_epu_41,shift_epu_41,dnuy_epu_41_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuX = interp2(gap41p',shift41p',dnux41p',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap41p',shift41p',dnuy41p',actualgap(gapnum),Shift(gapnum),'linear',0);
            elseif (epumode == 1)
                %                                                 DeltaNux = 0;
                %                                                 DeltaNuY = gap2tune(IDSector(gapnum, :), actualgap(gapnum), SR_GeV);
                DeltaNuX = interp2(gap41a',shift41a',dnux41a',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap41a',shift41a',dnuy41a',actualgap(gapnum),Shift(gapnum),'linear',0);
            else
                DeltaNux = 0;
                DeltaNuY = gap2tune(IDSector(gapnum, :), actualgap(gapnum), SR_GeV);
            end
        elseif (IDSector(gapnum,1) == 11) && (IDSector(gapnum,2) == 1)
            if (epumode == 0)
                %                                                 DeltaNuX = interp2(gap_epu_111,shift_epu_111,dnux_epu_111_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
                %                                                 DeltaNuY = interp2(gap_epu_111,shift_epu_111,dnuy_epu_111_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuX = interp2(gap111p',shift111p',dnux111p',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap111p',shift111p',dnuy111p',actualgap(gapnum),Shift(gapnum),'linear',0);
            elseif (epumode == 1)
                %                                                 DeltaNuX = interp2(gap_epu_111,shift_epu_111,dnux_epu_111_m1',actualgap(gapnum),Shift(gapnum),'linear',0);
                %                                                 DeltaNuY = interp2(gap_epu_111,shift_epu_111,dnuy_epu_111_m1',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuX = interp2(gap111a',shift111a',dnux111a',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap111a',shift111a',dnuy111a',actualgap(gapnum),Shift(gapnum),'linear',0);
            else
                DeltaNuX = 0;
                DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);   % variation of vertical tune shift with phase is small for EPUs
            end
        elseif (IDSector(gapnum,1) == 11) && (IDSector(gapnum,2) == 2)
            if (epumode == 0)
                %                                                 DeltaNuX = interp2(gap_epu_111,shift_epu_111,dnux_epu_111_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
                %                                                 DeltaNuY = interp2(gap_epu_111,shift_epu_111,dnuy_epu_111_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuX = interp2(gap112p',shift112p',dnux112p',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap112p',shift112p',dnuy112p',actualgap(gapnum),Shift(gapnum),'linear',0);
            elseif (epumode == 1)
                %                                                 DeltaNuX = interp2(gap_epu_111,shift_epu_111,dnux_epu_111_m1',actualgap(gapnum),Shift(gapnum),'linear',0);
                %                                                 DeltaNuY = interp2(gap_epu_111,shift_epu_111,dnuy_epu_111_m1',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuX = interp2(gap112a',shift112a',dnux112a',actualgap(gapnum),Shift(gapnum),'linear',0);
                DeltaNuY = interp2(gap112a',shift112a',dnuy112a',actualgap(gapnum),Shift(gapnum),'linear',0);
            else
                DeltaNuX = 0;
                DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);   % variation of vertical tune shift with phase is small for EPUs
            end
        else
            DeltaNuX = 0;
            DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);
        end

    else
        DeltaNuX = 0;
        DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);
    end

    DelQF = zeros(length(QFsp),1);
    DelQD = zeros(length(QFsp),1);

    fraccorr = 0.8*DeltaNuY ./ TuneW16Min;

    % Find which quads to change (local beta beating correction
    % (horizontal for EPU, vertical otherwise)
    QuadList = [IDSector(gapnum,1)-1 2; IDSector(gapnum,1) 1];
    QuadElem = dev2elem('QF',QuadList); % in reality use QF and QD ...

    % global vertical tune correction
    % 24 QF+ 24 QD
    DeltaAmps = inv(SR_TUNE_MATRIX) * [(fraccorr*6.23e-4); fraccorr*(-0.05301)];    %  DelAmps =  [QF; QD];
    DelQF = DelQF + DeltaAmps(1,:);
    DelQD = DelQD + DeltaAmps(2,:);

    % local horizontal tune correction (is also nearly a beta beating correction) only nonzero for EPUs!
    % 2 QF + 2 QD
    DeltaAmpsLocal = 12*inv(SR_TUNE_MATRIX) * [-DeltaNuX;0];                       %  DelAmps =  [QF; QD];
    DelQF(QuadElem) = DelQF(QuadElem)+DeltaAmpsLocal(1,1);
    DelQD(QuadElem) = DelQD(QuadElem)+DeltaAmpsLocal(2,1);

    % local vertical beta beating correction (should be used together with above global tune correction)
    % set to zero for EPUs, since their vertical tune shift is small
    % 2 QF + 2QD
    if (IDSector(gapnum,1)==6) || (IDSector(gapnum,1)==7) || (IDSector(gapnum,1)==10) || (IDSector(gapnum,1)==11)
        QFfac = ([2.243127/2.237111; 2.243127/2.237111]-1) * fraccorr;
        QDfac = ([2.556392/2.511045; 2.556392/2.511045]-1) * fraccorr;
    elseif (IDSector(gapnum,1)==5) || (IDSector(gapnum,1)==9)
        QFfac = ([2.225965/2.219784; 2.243096/2.237111]-1) * fraccorr;
        QDfac = ([2.528950/2.483259; 2.556345/2.511045]-1) * fraccorr;
    elseif (IDSector(gapnum,1)==4) || (IDSector(gapnum,1)==8) || (IDSector(gapnum,1)==12)
        QFfac = ([2.243096/2.237111; 2.225965/2.219784]-1) * fraccorr;
        QDfac = ([2.556345/2.511045; 2.528950/2.483259]-1) * fraccorr;
    else
        QFfac = zeros(2,1);
        QDfac = zeros(2,1);
    end

    DelQF(QuadElem,:) = DelQF(QuadElem,:) + QFfac.*QFsp(QuadElem,:);
    DelQD(QuadElem,:) = DelQD(QuadElem,:) + QDfac.*QDsp(QuadElem,:);

    % add all tune and beta beating corrections for this one ID to the summed up correction vectors for all IDs
    addQFsp = addQFsp+DelQF;
    addQDsp = addQDsp+DelQD;

end