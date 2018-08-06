tic;fprintf('%s: Flushing out hidden FFB setpoints (due to VCMs)\n',datestr(now));
                    setpv('SR01____FFBON__BC00',0,0);
                    pause(0.001);
                    setpv('SR01____FFBON__BC00',2,0);
                    pause(0.001);
                    setpv('SR01____FFBON__BC00',1,0);toc
                    