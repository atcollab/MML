// Test script for labCA; load 'test.db' into a soft-IOC example app
// and run this script from scilab/matlab...
//
// Reset severity warn level
lcaSetSeverityWarnLevel(3)
lcaSetSeverityWarnLevel(13)

// Make sure any previous monitors and channels are removed
disp('CLEARING ALL')
lcaClear()
disp('<<<OK')


// Test basic error handling
disp('TESTING basic error throwing')
try
	lcaSetTimeout()
	error('basic error throwing test FAILED')
catch
// just continue
end
disp('<<<OK')

// Test for features
disp('CHECKING FEATURES/VERSION')
try
	lcaLastError();
	labcaversion=3
catch
	labcaversion=2
end
disp('<<<OK')

// Test timeout and retry count

try

// argument check
if ( labcaversion > 2 )
	try
		lcaSetTimeout(0)
	catch
		if ( lcaLastError() ~= 1 )
			errxxx=lasterror()
			error(errxxx)
		end
	end
	try
		lcaSetRetryCount(0)
	catch
		if ( lcaLastError() ~= 1 )
			errxxx=lasterror()
			error(errxxx)
		end
	end
end

if ( labcaversion > 2 )
lcaTmeout   = 0.5
lcaRetryCnt = 4
else
lcaTmeout   = 0.05
lcaRetryCnt = 40
end

lcaSetTimeout(lcaTmeout)

if ( abs(lcaGetTimeout() - lcaTmeout) > 1E-4 )
	error('Readback of timeout FAILED')
end

lcaSetRetryCount(lcaRetryCnt)

if ( lcaGetRetryCount() ~= lcaRetryCnt )
	error('Readback of retry count FAILED')
end

// estimate timeout
tic()
	try
	disp('Waiting for timeout to expire...')
    disp('An error >could not find process variable : xxxx5789z< is normal here')
	lcaGet('xxxx5789z')
	catch
		if ( labcaversion > 2 )
		if ( lcaLastError() ~= 6 ) 
			disp('lcaGet from unkown PV timeout expected but got other error')
			errxxx=lasterror()
			error(errxxx)
		end
		end
	end
tme = toc();
if ( tme < 1 | tme > 3 )
	error('timeout out of bounds')
end

catch
	disp('Timeout/Retry count test FAILED')
	errxxx=lasterror()
	error(errxxx)
end

disp('<<< Timeout/Retry count test COMPLETED')
disp('')
disp('')
disp('Testing lcaGet/lcaPut/lcaPutNoWait')

// Test Put and Get
// Fill a matrix with numbers 1..10000

nums = ones(10,1)*[0:99] + [1:100:1000]'*ones(1,100);
wavs = {...
	'lca:wav0'; 'lca:wav1'; 'lca:wav2'; 'lca:wav3'; 'lca:wav4';...
	'lca:wav5'; 'lca:wav6'; 'lca:wav7'; 'lca:wav8'; 'lca:wav9';...
};

try

disp('CHECKING TIMESTAMPS')
lcaPut( 'lca:scl0', 432 )
[got, ts]  = lcaGet( 'lca:scl0' );
sleep(1000*3)
lcaPut( 'lca:scl0', 234 )
[got, ts1] = lcaGet( 'lca:scl0' );
got = real(ts1-ts)
if got < 2.5 | got > 3.5
	error('TIMESTAMP TEST FAILED')
end
disp('<<<OK')

lcaPut( wavs, nums );

[got, ts] = lcaGet(wavs);
if ( find(got ~= nums) )
	error('lcaGet(wavs) ~= nums')
end

disp('VERIFY THAT lcaPutNoWait FLUSHES IMMEDIATELY')
lcaPutNoWait(wavs, zeros(10,100))

disp('Sleeping for 3s to verify lcaPutNoWait() flushing queue')
// don't change format of sleep; sed script for
// conversion to matlab looks for string
// 's','l','e','e','p','(','1','0','0','0','*'
sleep(1000*3)

[got, ts1] = lcaGet(wavs(1),1);

if ( prod(size(got)) ~= 1 )
	error('Asking for 1 waveform element FAILED')
end
if ( real(ts1-ts(1)) > 1 ) 
	error('lcaPutNoWait() flush check FAILED')
end
disp('<<<OK')

disp('CHECKING TYPE CONVERSIONS FOR lcaPut')

// restore values
lcaPutNoWait(wavs,nums)

// Verify that we can read a subarray
got = lcaGet(wavs,4);

if ( find(got ~= nums(:,1:4)) )
	error('Reading subarray FAILED')
end

// Verify that we can write typed values
lcaPut('lca:scl0',2^32+1234,'d')
if ( lcaGet('lca:scl0') ~= 2^32+1234 )
	error('type DOUBLE readback check FAILED')
end

lcaPut('lca:scl0',2^32+1234,'l')
longscl = lcaGet('lca:scl0');
// FIXME: unclear how double is converted -> long
// some compilers produce 2^31-1 others -2^31 and yet others 1234...
if ( longscl ~= 2^31-1 & longscl ~= -2^31 & longscl ~= 1234 )
	error('type LONG readback overflow check FAILED')
end
lcaPut('lca:scl0',2^16+1234,'l')
if ( lcaGet('lca:scl0') ~= 2^16+1234 )
	error('type LONG readback check FAILED')
end
lcaPut('lca:scl0',2^16+1234,'s')
if ( lcaGet('lca:scl0') ~= 1234 )
	error('type SHORT readback overflow check FAILED')
end
lcaPut('lca:scl0',1234,'s')
if ( lcaGet('lca:scl0') ~= 1234 )
	error('type SHORT readback check FAILED')
end
lcaPut('lca:scl0',1234,'b')
// IOC puts CHAR as UCHAR !!!
// (see) dbPutNotifyMapType() hence 
// well get 210 back instead of -46
if ( lcaGet('lca:scl0') ~= 1234-1024 )
	error('type BYTE readback overflow check FAILED')
end
lcaPut('lca:scl0',123,'b')
if ( lcaGet('lca:scl0') ~= 123 )
	error('type BYTE readback check FAILED')
end

disp('<<<OK')

disp('CHECKING TYPE CONVERSIONS FOR lcaGet')

// Verify that we can read typed values
lcaPut('lca:scl0', 2^32+1234)
// ??? conversion happens on IOC and is compiler-dependent :-(;
// seems we get -2^31
if ( lcaGet('lca:scl0',0,'l') ~= -2^31 )
	error('type LONG read overflow check FAILED')
end

lcaPut('lca:scl0',2^16+1234)
if ( lcaGet('lca:scl0',0,'l') ~= 2^16+1234 )
	error('type LONG read check FAILED')
end
// ??? conversion happens on IOC and is compiler-dependent :-(;
// some (same EPICS versions) seem to saturate, others
// truncate the bits...
longscl = lcaGet('lca:scl0',0,'s'); 
if (  longscl ~= -2^15 & longscl ~= 1234 )
	error('type SHORT read overflow check FAILED')
end
lcaPut('lca:scl0',1234)
if ( lcaGet('lca:scl0',0,'s') ~= 1234 )
	error('type SHORT read check FAILED')
end
// ??? conversion happens on IOC and is compiler-dependent :-(;
// some (same EPICS versions) seem to saturate, others
// truncate the bits...
longscl = lcaGet('lca:scl0',0,'b'); 
if ( longscl ~= -46 )
	error('type BYTE read overflow check FAILED')
end
lcaPut('lca:scl0',123)
if ( lcaGet('lca:scl0',0,'b') ~= 123 )
	error('type BYTE read check FAILED')
end

// Check string/menu conversion
if ( ~mtlb_strcmp(lcaGet('lca:scl0',0,'c'),'123') )
	error('type STRING -> number read check FAILED')
end
if ( ~mtlb_strcmp(lcaGet('lca:count.SCAN'),'1 second') )
	error('type STRING read check FAILED')
end
if ( lcaGet('lca:count.SCAN',0,'l') ~= 6 )
	error('type STRING -> number (menu) read check FAILED')
end
lcaPut('lca:count.SCAN','Passive')
if ( lcaGet('lca:count.SCAN',0,'l') ~= 0 )
	error('type STRING -> number (menu) write check FAILED')
end
lcaPut('lca:count.SCAN',6)
if ( ~ mtlb_strcmp(lcaGet('lca:count.SCAN'), '1 second') )
	error('type STRING -> number (menu) write check FAILED')
end

catch
	disp('Testing lcaGet/lcaPut/lcaPutNoWait FAILED')
	errxxx=lasterror()
	error(errxxx)
end

disp('<<<OK')

disp('CHECKING lcaGetNelem')
if ( find( lcaGetNelem(wavs) ~= 100*ones(10,1) ) )
	error('lcaGetNelem FAILED')
end
disp('<<<OK')

disp('CHECKING lcaGetControlLimits / lcaGetGraphicLimits / lcaGetPrecision')

hopr =   500;
lopr = -1500;
drvh = 13000;
drvl = -4321;

lcaPut({'lca:out.HOPR';'lca:out.LOPR'},[hopr ; lopr])
lcaPut({'lca:out.DRVH';'lca:out.DRVL'},[drvh ; drvl])
lcaPut('lca:out.PREC',5)
lcaPut('lca:out',0.12345)

[ lo, hi ] = lcaGetControlLimits('lca:out');

if ( lo ~= drvl | hi ~= drvh )
	error('lcaGetControlLimits test FAILED')
end

[ lo, hi ] = lcaGetGraphicLimits('lca:out');

if ( lo ~= lopr | hi ~= hopr )
	error('lcaGetGraphicLimits test FAILED')
end

if ( labcaversion > 2 )
if ( lcaGetPrecision('lca:out') ~= 5 )
	error('lcaGetPrecision test FAILED')
end

if ( ~mtlb_strcmp(lcaGet('lca:out',0,'c'),'0.12345') )
	error('lcaGetPrecision test (string 1) FAILED')
end

lcaPut('lca:out.PREC',2)

if ( ~mtlb_strcmp(lcaGet('lca:out',0,'c'),'0.12') )
	error('lcaGetPrecision test (string 2) FAILED')
end
end

disp('<<<OK')

disp('CHECKING lcaGetStatus and severity rejection')

// argument check
try
  lcaGetStatus('lca:scl0');
  sevr = lcaGetStatus('lca:scl0');
  [ sevr, stat ]  = lcaGetStatus('lca:scl0');
  [ sevr, stat, ts ]  = lcaGetStatus('lca:scl0');
catch
	error('lcaGetStatus FAILED: cannot handle all possible output args');
end

// try invalid args
try
	lcaGetStatus();
	error('lcaGetStatus FAILED to reject no arg');
catch
// just continue
end
try
	[sevr, stat, ts, got] = lcaGetStatus('lca:scl0');
	error('lcaGetStatus FAILED to reject to many output args');
catch
// just continue
end


// scl5 is always UDF
if ( 3 ~= lcaGetStatus('lca:scl5') )
	error('lcaGetStatus(): expected INVALID severity')
end

[ sevr, stat ] = lcaGetStatus('lca:scl5');
if ( sevr ~= 3 | stat ~= 17 )
	error('lcaGetStatus(): expected INVALID severity, UDF status')
end

// suppress warnings
lcaSetSeverityWarnLevel(4);
// reject MINOR
lcaSetSeverityWarnLevel(11);
if ( ~isnan(lcaGet('lca:scl5')) )
	error('lcaGet should return NAN for PV with INVALID severity')
end

// now check the different levels
lcaPut('lca:scl1.LSV', 'MINOR');   lcaPut('lca:scl1.LOW',-1000);
lcaPut('lca:scl1.HSV', 'MAJOR');   lcaPut('lca:scl1.HIGH',1000);
lcaPut('lca:scl1.HHSV','INVALID'); lcaPut('lca:scl1.HIHI',2000);
lcaPut('lca:scl2.LSV', 'MINOR');   lcaPut('lca:scl2.LOW',+1000);
lcaPut('lca:scl2.HSV', 'MAJOR');   lcaPut('lca:scl2.HIGH',2000);
lcaPut('lca:scl2.HHSV','INVALID'); lcaPut('lca:scl2.HIHI',3000);
scls = {'lca:scl1';'lca:scl2'};
lcaPut(scls, [0;0]);
[sevr, stat, ts ] = lcaGetStatus(scls);
// MINOR
if ( find( sevr ~= [ 0; 1] ) | find ( stat ~= [ 0; 6 ] ) )
	error('lcaGetStatus: (testing MINOR) unexpected STAT / SEVR')
end
[got, ts1] = lcaGet(scls);
if ( find( ts ~= ts1 ) )
	error('lcaGetStatus: timestamp inconsistency')
end
if ( find( isnan(got) ~= isnan([ 0; %nan]) ) )
	error('lcaGet rejection for MINOR FAILED')
end
lcaSetSeverityWarnLevel(12);
if ( find( isnan(lcaGet(scls)) ~= isnan([0;0])) )
	error('lcaGet rejection for MINOR FAILED to accept')
end

// MAJOR
lcaPut(scls,[1500;1500]);

[sevr, stat] = lcaGetStatus(scls);
if ( find( sevr ~= [ 2; 0] ) | find ( stat ~= [ 4; 0 ] ) )
	error('lcaGetStatus: (testing MAJOR) unexpected STAT / SEVR')
end
if ( find( isnan(lcaGet(scls)) ~= isnan( [ %nan; 0] )) )
	error('lcaGet rejection for MAJOR FAILED')
end
lcaSetSeverityWarnLevel(13);
if ( find( isnan(lcaGet(scls)) ~= isnan([0;0])) )
	error('lcaGet rejection for MAJOR FAILED to accept')
end

// INVALID
lcaPut(scls,[2500;2500]);
[sevr, stat] = lcaGetStatus(scls);
if ( find( sevr ~= [ 3; 2] ) | find ( stat ~= [ 3; 4 ] ) )
	error('lcaGetStatus: (testing INVALID) unexpected STAT / SEVR')
end
if ( find( isnan(lcaGet(scls)) ~= isnan( [ %nan; 0] )) )
	error('lcaGet rejection for INVALID FAILED')
end
lcaSetSeverityWarnLevel(14);
if ( find( isnan(lcaGet(scls)) ~= isnan([0;0])) )
	error('lcaGet rejection for INVALID FAILED to accept')
end
// check call with 0 and 1 output arg
sevr = lcaGetStatus(scls);
lcaGetStatus(scls);
if ( find( ans ~= sevr ) )
	error('lcaGetStatus call with 0 and 1 output arg FAILED')
end

disp('<<<OK')

if ( labcaversion > 2 )
disp('CHECKING lcaGetUnits')
lcaPut({'lca:scl0.EGU';'lca:scl1.EGU'},{'ABER';'XX'});
if ( find(~mtlb_strcmp(lcaGetUnits({'lca:scl0';'lca:scl1'}),{'ABER';'XX'})) )
	error('lcaGetUnits test FAILED');
end
disp('<<<OK')
end

disp('CHECKING lcaSetMonitor/lcaNewMonitorWait/lcaNewMonitorValue')
lcaSetMonitor('lca:count')
lcaNewMonitorWait('lca:count')
[got,ts]=lcaGet('lca:count');
if ( lcaNewMonitorValue('lca:count') )
	error('lcaNewMonitorValue should be 0; FAILED')
end
lcaNewMonitorWait('lca:count')
if ( ~lcaNewMonitorValue('lca:count') )
	error('lcaNewMonitorValue should be 1; FAILED')
end
[got1,ts1]=lcaGet('lca:count');
if ( lcaNewMonitorValue('lca:count') )
	error('lcaNewMonitorValue should be 0; FAILED')
end
if ( got1~=got+1 )
	error('MONITOR DIFFERENCE FAILURE')
end
if ( abs(real(ts1-ts)-1)>0.2 )
	error('MONITOR TIMESTAMP DIFFERENCE FAILURE')
end
// Now monitor a second PV; verify that we can set monitor twice...
lcaSetMonitor({'lca:scl1';'lca:count'})
// Verify that blocking on just one monitor works
lcaNewMonitorWait({'lca:scl1';'lca:count'})
lcaGet('lca:count');
// scl1 is still pending
try
	lcaNewMonitorWait({'lca:scl1';'lca:count'})
catch
	error('blocking on 1 monitor (1 more already pending): FAILED')
end
lcaGet({'lca:scl1';'lca:count'});
// now remove 'scl1' monitor again
lcaClear('lca:scl1')
// Verify that we get an error if we try to monitor a
// variable w/o monitor
if ( labcaversion > 2 )
try
	lcaNewMonitorValue({'lca:scl1';'lca:count'});
	error('lcaNewMonitorValue on un-monitored PV should throw error: FAILED')
catch
	if ( lcaLastError() ~= 20 )
		error('lcaNewMonitorValue un-monitored PV error catch check: FAILED')
	end
end
else
	if ( find( lcaNewMonitorValue({'lca:scl1';'lca:count'}) ~= [-1;0] ) )
		error('lcaNewMonitorValue on un-monitored PV check FAILED')
	end
end

disp('<<<OK')

if ( labcaversion > 2 )
// NOTE NOTE This MUST be the last test until I know how to catch
// a Ctrl-C event under matlab
disp('CHECKING CTRL-C HANDLING: press Ctrl-C and verify that the command')
disp('                          aborts prior to expiration of a 10s timeout')
//MATLABWARN('WARNING: Cannot catch CTRL-C under MATLAB from .m file -- ignore error message')
try
lcaDelay(10)
error('No Ctrl-C detected')
catch
// MATLAB NOTE: CTRL-C aborts entire .m file -- we never get here...
	if ( lcaLastError() ~= 9 )
		error('CTRL-C test FAILED (unknown cause)')
	end
end
disp('<<<OK')
else
disp('test CTRL-C handling manually under labCA version 2')
end
disp('<< ALL DONE')
