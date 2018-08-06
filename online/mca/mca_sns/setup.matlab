# Run this once to create a startup.m file
# which will point your copy of matlab to MCA:

if [ ! -d ~/matlab ]
then
    echo "Creating ~/matlab"
    mkdir ~/matlab
fi

if [ -r ~/matlab/startup.m ]
then
    echo "There is already a ~/matlab/startup.m file"
    echo "You better move that out of the way,"
    echo "then run me again to create a new one,"
    echo "then figure out if you need to merge stuff"
    echo "from the original file back into the new one."
else
	
cat > ~/matlab/startup.m <<END
global is_matlab
eval('is_matlab=length(matlabroot)>0;', 'is_matlab=0;')
% Location of the MCA matlab scripts
addpath $EPICS_EXTENSIONS/src/mca/matlab
% Location of the MCA MEX binary
addpath $EPICS_EXTENSIONS/lib/$EPICS_HOST_ARCH
END

echo "Created ~/matlab/startup.m for using Matlab with EPICS Channel Access"
echo "Some setups might use ~/.matlab/SomeVersionNumber/..., in which case you"
echo "have to get the path settings into there."
fi
