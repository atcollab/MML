% check_bend_current
%
% Routine used for topoff testing to find the peak current of the booster bend magnet

bendI=get_dpsc_current_waveforms_cond;

figure
subplot(2,1,1)
plot(bendI.Timevec,bendI.Data);
xlabel('t [s]')
ylabel('I [A]')
legend('Bend','QF','QD');
subplot(2,1,2)
plot(bendI.Timevec,bendI.Data);
xlabel('t [s]')
ylabel('I [A]')
axis([0.45 0.5 980 1010]);

Asp = getpv('BRBend_Intrlk_SPA'); Bsp = getpv('BRBend_Intrlk_SPB');
UwinA = getpv('BRBend_UL_SPA'); UwinB = getpv('BRBend_UL_SPB');

fprintf('Top-off Energy Match Interlock, Booster Bend Interlock Setpoint (A) = %.1f A, (B) = %.1f A\n',Asp,Bsp);
fprintf('Upper Window (A) = %.3f %% = %.1f A, (B) = %.3f %% = %.1f A\n',UwinA,Asp*(1+UwinA/100),UwinB,Bsp*(1+UwinB/100));

fprintf('peak current of booster bend magnet is %.1f A\n',max(bendI.Data(:,1)));

if (max(bendI.Data(:,1))>Asp*(1+UwinA/100)) && (max(bendI.Data(:,1))>Bsp*(1+UwinB/100))
    fprintf('Peak booster current is larger than upper window of top-off interlock - should be OK to continue with interlock test.\n')
    fprintf('Caveat: If the peak booster current is very close to the top-off interlock upper window, it still could cause problems with interlock test.\n');
else
    fprintf('Peak booster current is smaller than at least one of the top-off interlock windows - might present problem for interlock test.\n');
    soundtada
end

legendstr=sprintf('max(I_{Bend}) = %.1f A',max(bendI.Data(:,1)));
legend(legendstr);
