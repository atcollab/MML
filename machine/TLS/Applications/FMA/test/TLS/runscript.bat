@echo off
echo.
echo Starting MATLAB and running Frequency Map Analysis...
echo Input file : 
echo        %%CD%%tlslattice_fma_input.dat
echo Matlab error logs saved to : 
echo        %%CD%%tlslattice_fma_input_matlaberrors.log
echo.
matlab -nosplash -nodesktop -nojvm -logfile %%CD%%tlslattice_fma_input_matlaberrors.log -r "fma = fma_lib('analysis','%%CD%%tlslattice_fma_input.dat'); plot_emailresults(fma); exit;"
