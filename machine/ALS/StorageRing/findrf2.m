function [DeltaRF, RF] = findrf2
%  [DeltaRF, RF] = findrf2
%
%  This function uses analcm to find and set the RF frequency
%  to minimize the mean of arc-section horiztonal correctors
%
%  Also see findrf, rmdisp, plotcm


RFold = getsp('RF');
%fprintf('  The current RF frequency is %.4f MHz.', RFold);


[DeltaRF, EnergyChange, meanHCM3456] = analcm;


if 1

    Const19 = 0.0012;
    Const15 = 0.0015;

    GeV = bend2gev;
    if GeV == getenergy('Production')
        RFnew = RFold + (Const19*meanHCM3456);
    elseif GeV == getenergy('Injection')
        RFnew = RFold + (Const15*meanHCM3456);
    else
        fprintf('  There is no conversion factor for this energy. Please set the frequency manually.');
    end

    DeltaRF = Const19*meanHCM3456;

else

    % Half the energy change seems to be a good RF change
    DeltaRF = DeltaRF/2;
    RFnew = RFold + DeltaRF;

end

%fprintf('  The new RF frequency will be %.4f MHz. ', RFnew);

changeRFbutton = questdlg(sprintf('The current RF freq. is %.6f MHz\nThe new RF freq. will be %.6f MHz\nDo you wish to change it?', RFold, RFnew), 'Change RF Frequency?', 'Yes', 'No', 'No');

switch changeRFbutton
    case 'Yes'
        setsp('RF',RFnew);
        pause(1);
        RF = getsp('RF');
        fprintf('   The RF frequency has been changed. The new RF frequency is %.6f MHz.\n', RF);
    case 'No'
        RF = getsp('RF');
        fprintf('   The RF frequency has not been changed. The RF frequency is %.6f MHz.\n', RF);
end
