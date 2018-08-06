/*
000801  Rev3-01-08
	date: 2000/08/01 22:15:18;  author: shalz;  state: Exp;  lines: +50 -24
        Changed DEFAULT_GROUP_REFRESH_PERIOD to .5 sec.  Wait for connections
        up to the do_get timeout but only if at least one channel is being
        read the first time and is not connected.  Gets other that the
        first do not cause a wait for connection.  Status comes back
        SCA_CANNOT_GET.  revision 1.44.
000331	Rev3-01-07  
	NT slow connect fixed.  Changed to using print_sca_status_str().
981120	Rev3-01-06  
	Changed do_put( double maxtime ) so that
	maxtime
	> 0.0	means callbacks are requested. Wait up to maxtime seconds
		for channel connections and callbacks.
	<= 0.0	means callbacks are not requested. Wait up to maxtime seconds
		for channel connections.
981007	Rev3-01-05  
	sca_sleep() with int number of milliseconds as argument.

970730	Rev3-01-04  
	Added sca_setup_aliases().  Makefile cleanup.  Test programs into CVS.

970605	Rev3-01-03  
	Use rdist for install.

970603	Rev3-01-02  
	Added sca_release() which returns release number which is
	intended to match the cvs tag and is kept in sca_release.h.
	Added arg to group_get_do_get_timeout() so it can return actual
	timeout of last do_get() of the group which is put into
	sca_group struct by group_refresh().

970603	R3_1
	This adds do_get_timeout to sca_group struct.  group_refresh()
	waits up to do_get_timeout sec. for completion of do_get() or
	.020+num_channels*.010 sec if do_get_timeout <= 0.0.
	group_set_do_get_timeout() and group_get_do_get_timeout() are
	available for manipulating do_get_timeout.

970602	R3_0
	This is scaIII, including grouping.

*/

static char release[] = { "Rev3-01-08" };	/* 10 + 1 bytes */
