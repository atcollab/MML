function cc_llrf_reflect_trip
% cc_llrf_reflect_trip - "Compiles" the LLRF re application to run standalone

DirStart = pwd;          % Save the starting directory
gotocompile('Gun');      % Goto the compiled directory
cc_standalone('llrf_reflect_trip');   % Compile 
cd(DirStart);            % Goto the starting directory
