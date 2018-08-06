function frameworkTest
% frameworkTest - MATUnit unit tests

printresult = 0;
% Standard boilerplate for any test .m file
% The following two lines are required to auto-scan and run test methods
tests = str2func(suite([mfilename '.m']));
[passres, failres, warnres] = runner(tests, printresult);
% End boilerplate

%========================================================================
%Actual tests

function testAssertTruePass
assertTrue('assertTrue with non-zero should pass', 1);
     
function testAssertFalsePass
assertFalse('assertFalse with zero should pass', 0);
     
function testAssertStringsEqual
assertEquals('strings should compare equal', 'this', 'this');

function testAssertLogicalEqual
assertEquals('logical should compare equal', logical(1), logical(1));

function testAssertLogicalVectorEqual
la = [ logical(1) logical(0)];
assertEquals('logical should compare equal', la, la);

function testVectorsEqual
v1 = [ 0 1 2 3 4 5 ];
v2 = [ 0 1 2 3 4 5 ];
assertEquals('vectors should compare equal', v1, v2);

function testMatrixEqual
v1 = [ 0 1 2; 3 4 5 ];
v2 = [ 0 1 2; 3 4 5 ];
assertEquals('matrices should compare equal', v1, v2);

function testCellArrayEqual
v1 = {'one', 'two', 'three', 'four'};
v2 = {'one', 'two', 'three', 'four'};
assertEquals('cell arrays should compare equal', v1, v2);

function testAssertTrueFail
try
    assertTrue('assertTrue with zero should fail', 0);
catch
    lastwarn('');
    return
end
fail('assertTrue with zero should fail');
    
function testAssertFalseFail
try
    assertFalse('assertFalse with non-zero should fail', 1);
catch
    lastwarn('');
    return
end
fail('assertFalse with non-zero should fail');
    
function testAssertStringsEqualFail
try
    assertEquals('expect this compare to fail', 'this', 'that');
catch
    lastwarn('');
    return
end
fail('comparison should fail');

function testAssertLogicalEqualFail
try
    assertEquals('expect this compare to fail', logical(1), logical(0));
catch
    lastwarn('');
    return
end
fail('comparison should fail');

function testAssertLogicalVectorEqualFail
try
    la = [logical(0) logical(1)];
    la2 = [logical(0) logical(0)];
    assertEquals('expect this compare to fail', la, la2);
catch
    lastwarn('');
    return
end
fail('comparison should fail');

function testVectorsEqualFail
v1 = [ 0 1 2 3 4 5 ];
v2 = [ 0 1 2 3 4 8 ];
try
    assertEquals('expect this compare to fail', v1, v2);
catch
    lastwarn('');
    return
end
fail('vector comparison should have failed');

function testMatrixEqualFail
v1 = [ 0 1 2; 3 4 5 ];
v2 = [ 0 1 2; 3 4 8 ];
try
    assertEquals('expect this compare to fail', v1, v2);
catch
    lastwarn('');
    return
end
fail('matrix comparison should have failed');

function testCellArrayEqualFail
v1 = { 'one', 'two' };
v2 = { 'one', 'four' };
try 
    assertEquals('expect this compare to fail', v1, v2);
catch
    lastwarn('');
    return
end
fail('cell array comparison should have failed');

% System-generated errors should be caught and reported as errors
function testFakeWarningErrorXError
lastwarn('emitted warnings should trigger an error result');

function testArithmeticErrorXError
assertTrue('warnings should result in an error', 1/0);

function testErrorXError
assertEquals('errors should result in an error', UNDEFINED, 0);
