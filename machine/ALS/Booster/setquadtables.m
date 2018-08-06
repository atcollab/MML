function setquadtables(QFtable, QDtable)


if nargin == 0
    fprintf('   Setting the nominal QF & QD linearity correction tables to the ILC.\n');
    load QFQD_Ramptable_Nominal
elseif nargin == 1
    error('QD table not input.')
end

setpv('QF', 'ILCTrim', QFtable, [1 1]);
setpv('QD', 'ILCTrim', QDtable, [1 1]);
