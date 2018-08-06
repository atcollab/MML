function mode(X)

if X == 1
    clear all;
    close all hidden;
    setpathtls('TLS_CTL');
    plotfamily;
elseif X == 2
    clear all;
    close all hidden;
    setpathtls('TLS_CTL_EPICS');
    plotfamily;
end