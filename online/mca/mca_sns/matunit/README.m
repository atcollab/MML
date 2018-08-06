% MATUnit : xUnit unit test framework for MATLAB
% Version 1.0
% June 28, 2005
% Timothy Wall, Oculus Technologies Corporation
%
% This framework provides unit tests for MATLAB m-files
%
% Use assertions (assertEquals, assertTrue, assertFalse) to check the results 
% of calling the MATLAB functions under test.  Tests should be grouped by 
% m-file, with a few lines of boilerplate code to enable the unit test 
% framework (see frameworkTest.m as an example).
%
% The following two lines are required to auto-scan and run test methods
%
%   tests = str2func(suite([mfilename '.m']));
%   [passres, failres, warnres] = runner(tests, printresult);
%
% Run the tests by invoking the containing m-file.  Detailed results will be 
% printed, followed by a summary of results.  
%
% Files:
% readme.m              this file
% suite.m               auto-generate suite of tests from a given m-file
% runner.m              handles running a suite of tests, printing results
% frameworkTest.m       this framework's unit tests
% assertTrue.m          assertion support
% assertFalse.m         
% assertEquals.m        
% fail.m                forces an explicit failure
% printstack.m          get a stack trace
%
% Compatible with MATLAB 6.0/7.0.
%
%------------------------------------------------------------------------
%Copyright (c) 2005 Timothy Wall
%
%Permission is hereby granted, free of charge, to any person obtaining a
%copy of this software and associated documentation files (the "Software"),
%to deal in the Software without restriction, including without limitation
%the rights to use, copy, modify, merge, publish, distribute, sublicense,
%and/or sell copies of the Software, and to permit persons to whom the
%Software is furnished to do so, subject to the following conditions:
%
%The above copyright notice and this permission notice shall be included in
%all copies or substantial portions of the Software.
%
%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
%THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
%DEALINGS IN THE SOFTWARE.
help readme
