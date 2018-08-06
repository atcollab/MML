function qfqd_restoreramptable
%


% Save the data on the path (Booster directory)
% QF_ILC = getpv('QF','ILCTrim');
% QD_ILC = getpv('QD','ILCTrim');
% save QFQD_Ramptable_Restore QF_ILC QD_ILC


FileName = 'QFQD_Ramptable_Restore';
load(FileName)


try
    setpv('QF', 'ILCTrim', QF_ILC, [1 1]);
    setpv('QD', 'ILCTrim', QD_ILC, [1 1]);
    fprintf('   QF & QD linearity correction table restored from file %s.\n', FileName);

catch
    fprintf('   There was a problem trying to restored the QF & QD ramp tables from file %s.\n', FileName);
    fprintf('\n%s\n', lasterr);
end