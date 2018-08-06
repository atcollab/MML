function cc_llrf
% CC_LLRF - "Compiles" the LLRF application to run standalone

DirStart = pwd;          % Save the starting directory
gotocompile('Gun');      % Goto the compiled directory
cc_standalone('llrf');   % Compile 
cd(DirStart);            % Goto the starting directory
