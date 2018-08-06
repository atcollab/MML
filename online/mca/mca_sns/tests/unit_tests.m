function unit_tests
%unit_tests
%
% Unit tests for most of the MCA routines.
%
% Requires the demo.db to run in a soft IOC.
% With that in place, simply invoking this
% file should run all the tests.
%
% kasemirk@ornl.gov

% Standard boilerplate for any test .m file
addpath ../matunit
tests = str2func(suite([mfilename '.m']));
[passres, failres, warnres] = runner(tests, 1);

%========================================================================

function testVersion
% Reset, then check
mcaexit;
assertEquals('Version test', '4.1', mcaversion); 

%
function testNonsense
try
   mca(9875);
   % Should not get here...
   fail 'Allowed nonsense switch code?'
catch
end

%
function testCheckDefaultTimeouts
t = mcatimeout;
assertEquals('default search timeout', 10.0, t(1), 0.01); 
assertEquals('default get timeout', 10.0, t(2), 0.01); 
assertEquals('default put timeout', 10.0, t(3), 0.01);

%
function testSetCustomTimeouts
mcatimeout('open', 5);
mcatimeout('get', 6);
mcatimeout('put', 7);
t = mcatimeout;
assertEquals('custom search timeout', 5.0, t(1), 0.01); 
assertEquals('custom get timeout', 6.0, t(2), 0.01); 
assertEquals('custom put timeout', 7.01, t(3), 0.01);
mcaexit;

%
function testOneOpenClose
pv = mcaopen('fred');
[h, names] = mcaopen;
assertEquals('One channel', 1, length(h));
assertEquals('Correct name', 'fred', names{1});
info = mcainfo(pv);
assertEquals('info handle', pv, info.Handle);
assertEquals('info name', 'fred', info.PVName);
assertEquals('info type', 'DOUBLE', info.NativeType);
assertEquals('info count', 1, info.ElementCount);
mcaclose(pv);
[h, names] = mcaopen;
assertEquals('No more channels', 0, length(h));

%
function testMutipleOpenClose
[pv, pv2] = mcaopen('fred', 'janet');
[h, names] = mcaopen;
assertEquals('Two channels', 2, length(h));
assertEquals('Correct name', 'fred', names{1});
assertEquals('Correct name', 'janet', names{2});
[h, infos] = mcainfo;
assertEquals('Two channels', 2, length(h));
assertEquals('Correct name', 'fred', infos(1).PVName);
assertEquals('Correct name', 'janet', infos(2).PVName);
assertEquals('checkopen', pv2, mcacheckopen('janet'));
assertEquals('checkopen', pv, mcacheckopen('fred'));
assertEquals('isopen', pv2, mcaisopen('janet'));
assertEquals('isopen', pv, mcaisopen('fred'));
mcaclose(pv2, pv);
assertEquals('isopen', 0, mcaisopen('janet'));
assertEquals('isopen', 0, mcaisopen('fred'));
[h, names] = mcaopen;
assertEquals('No more channels', 0, length(h));

%
function testCellOpenClose
names={'fred', 'janet'};
pvs = mcaopen(names);
[h, names] = mcaopen;
assertEquals('Two channels', 2, length(h));
assertEquals('Correct name', 'fred', names{1});
assertEquals('Correct name', 'janet', names{2});
mcaclose(pvs);
[h, names] = mcaopen;
assertEquals('No more channels', 0, length(h));

%
function testState
names={'fred', 'janet'};
pvs = mcaopen(names);
assertEquals('connected', 1, mcastate(pvs(1)));
assertEquals('connected', 1, mcastate(pvs(2)));
% hard to test 'disconnected' without stopping the CA server...
mcaclose(pvs);

%
function testBasicGet
pv = mcaopen('fred');
val = mcaget(pv);
pv = mcaopen('alan');
val = mcaget(pv);
assertTrue('got array', length(val) > 1);

%
function testGetTypes
% Double
pv = mcacheckopen('fred');
val = mcaget(pv);
info = mcainfo(pv);
assertEquals('double', 'DOUBLE', info.NativeType);
assertTrue('got scalar', length(val) == 1);
mcaclose(pv);
% Array
pv = mcacheckopen('alan');
val = mcaget(pv);
info = mcainfo(pv);
assertEquals('double', 'DOUBLE', info.NativeType);
assertTrue('got array', length(val) > 1);
mcaclose(pv);
% String
pv = mcacheckopen('ramp.DESC');
val = mcaget(pv);
info = mcainfo(pv);
assertEquals('double', 'STRING', info.NativeType);
mcaclose(pv);
% Enum
pv = mcacheckopen('ramp.SCAN');
val = mcaget(pv);
info = mcainfo(pv);
assertEquals('double', 'ENUM', info.NativeType);
mcaclose(pv);

%
function testGetMultiple
names={'fred', 'janet'};
pvs = mcaopen(names);
assertEquals('connected', 1, mcastate(pvs(1)));
assertEquals('connected', 1, mcastate(pvs(2)));
vals = mcaget(pvs);
assertEquals('got array', 2, length(vals));
mcaclose(pvs);

%
function testGetTimes
names={'fred', 'janet'};
pvs = mcaopen(names);
assertEquals('connected', 1, mcastate(pvs(1)));
assertEquals('connected', 1, mcastate(pvs(2)));
vals = mcaget(pvs);
[t1, t2]=mcatime(pvs(1), pvs(2));
assertTrue('recent time', abs(t1 - now) < 1);
assertTrue('recent time', abs(t2 - now) < 1);
datestr(t1);
datestr(t2);
mcaclose(pvs);

%
function testAlarm
% 'ramp' should go in and out of MAJOR/HIGH alarm...
pv = mcacheckopen('ramp');
disp('Wait for normal');
i=1;
while i<10
    mcaget(pv);
    ss = mcaalarm(pv);
    if ss.severity == 0
        break
    end
    pause(1.0);
    i=i+1;
end
assertTrue('found normal severity', i<10);
disp('Wait for major');
i=1;
while i<10
    mcaget(pv);
    ss = mcaalarm(pv);
    if ss.severity == 2
        break
    end
    pause(1.0);
    i=i+1;
end
assertTrue('found major severity', i<10);
mcaclose(pv);

% These end up in mca(80, ...)
function testArrayput
p1 = mcacheckopen('set1');
p2 = mcacheckopen('set2');
mcaput([p1 p2], [1 2]);
assertEquals('put OK', 1, mcaget(p1));
assertEquals('put OK', 2, mcaget(p2));
mcaput([p1 p2], [3 4]);
assertEquals('put OK', 3, mcaget(p1));
assertEquals('put OK', 4, mcaget(p2));
mcaclose(p1, p2);
try
    mcaput([p1 p2], [3 4]);
    assertTrue('Should never get here', false);
catch
    assertTrue('Should get here', strfind(lasterr, 'Invalid handle') > 0);
end


% These end up in mca(70, ...)
function testPut
p1 = mcacheckopen('set1');
mcaput(p1, 10);
assertEquals('put OK', 10, mcaget(p1));
mcaput(p1, 20);
assertEquals('put OK', 20, mcaget(p1));
mcaclose(p1);
try
    mcaput(p1, 3);
    assertTrue('Should never get here', false);
catch
    assertTrue('Should get here', strfind(lasterr, 'Invalid handle') > 0);
end

% Use tiny time which should result in timeout,
% then try long time which should suffice.
% However, you never know with these timing tests...
function testPutTimeout
mcatimeout('put', 1e-10);
p1 = mcacheckopen('set1');
assertEquals('Got timeout', -1, mcaput(p1, 10));
% Problem:
% We didn't allow enough time for the last callback to arrive.
% Wait a little for it to arrive and get discarded,
% because otherwise we might confuse it with the result
% of the next mcaput.
pause(3);
mcatimeout('put', 10.0);
assertEquals('Got OK', 1, mcaput(p1, 10));
mcaclose(p1);

%
function testPutStrings
p1 = mcacheckopen('set1.DESC');
assertEquals('Got OK', 1, mcaput(p1, 'Some Text'));
try
    mcaput(p1, 42);
    assertTrue('Should never get here', false);
catch
    assertTrue('Should get here', strfind(lasterr, 'Need string') > 0);
end
mcaclose(p1);
p1 = mcacheckopen('set1');
assertEquals('Got OK', 1, mcaput(p1, 42));
try
    mcaput(p1, '42');
    assertTrue('Should never get here', false);
catch
    assertTrue('Should get here', strfind(lasterr, 'Need numeric') > 0);
end
mcaclose(p1);

%
function testPutCell
p1 = mcacheckopen('set1');
p2 = mcacheckopen('set1.DESC');
mcaput({p1, p2}, { 42, 'Description' });
assertEquals('Readback matches', 42, mcaget(p1));
assertEquals('Readback matches', 'Description', mcaget(p2));
mcaclose(p2, p1);

% Does this crash IOCs??
%p1 = mcaopen('set1');
%p2 = mcaopen('set1.DESC');
%mcaput(p1, 42);
%mcaput(p2, 'Description');
%mcaclose(p2);
%mcaclose(p1);


%
function testSimpleMonitor
p1 = mcacheckopen('ramp');
% 'Default' callback
assertEquals('Start monitor', 1, mcamon(p1));
[h, cb] = mcamon;
assertEquals('Monitor info count', 1, length(h));
assertEquals('Monitor handle', p1, h);
assertEquals('Monitor callback', 0, length(cb{1}));
disp('Wait for events');
pause(2);
assertTrue('Got values', mcamonevents(p1) > 0);
mcacache(p1);
% Should be 0, maybe 1 if we just received another one now
assertTrue('Cleared event counts', mcamonevents(p1) < 2);
pause(2);
assertTrue('Got values', mcamonevents(p1) > 0);
mcaclearmon(p1);
mcacache(p1);
% Should be 0, with no more arriving
assertEquals('No more events', 0, mcamonevents(p1));
pause(2);
assertEquals('No more events', 0, mcamonevents(p1));
mcaclose(p1);

%
function testMonitorCallback
global v
v = [];
p1 = mcacheckopen('ramp');
cmd = sprintf('global v; v=[v mcacache(%d)]', p1);
assertEquals('Start monitor', 1, mcamon(p1, cmd));
[h, cb] = mcamon;
mcamontimer('start');
assertEquals('Monitor info count', 1, length(h));
assertEquals('Monitor handle', p1, h);
assertEquals('Monitor callback', cmd, cb{1});
disp('Wait for values');
pause(5);
mcaclearmon(p1);
mcamontimer('stop');
assertTrue('Got value', length(v) > 2);
mcaexit;

