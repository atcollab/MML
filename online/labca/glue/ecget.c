/* $Id: ecget.c,v 1.20 2007/10/14 03:28:04 strauman Exp $ */

/* ecdrget: channel access client routine for successively reading ECDR data.  */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 9/2001 */

/* LICENSE: EPICS open license, see ../LICENSE file */

/* system includes */
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#if defined(CMDLINE_APP)
/* probably need the cygwin environment for the
 * command line utility on windows...
 */
#include <unistd.h>
#endif
#include <string.h>

#include <cadef.h>

/* our local buffer is an array of buf_t */
typedef long buf_t;

#define DEBUG

#if defined(CMDLINE_APP) /****************************** CMDLINE INTERFACE DEFINITIONS **********************/

#define SYS_MALLOC(nbytes)	malloc(nbytes)
#define SYS_FREE(charptr)	free(charptr)
/* wrapper for printing error messages */
#define ecErr(arg)          do { fprintf(stderr,arg); fputc('\n',stderr);} while (0)
#define	NEITHER_SVAL_NOR_VAL_ACTION(pv_name,l,result,nord) fprintf(stderr, "invalid PV %s", pv_name)
#elif defined(SCILAB_APP) /***************************** SCILAB INTERFACE DEFINITIONS  **********************/

#if defined(DEBUG)
#undef DEBUG
#endif

extern void cerro(char*);

#define SYS_MALLOC(nbytes)	lcaMalloc(nbytes)
#define SYS_FREE(charptr)	lcaFree(charptr)
/* wrapper for printing error messages */
#define ecErr(arg)          do { cerro(arg); cerro("\n");} while (0)
#define	NEITHER_SVAL_NOR_VAL_ACTION(pv_name,l,result,nord) cerro("invalid PV")

#elif defined(MATLAB_APP) /***************************** MATLAB INTERFACE DEFINITIONS  **********************/
#include "matrix.h"
#include "mex.h"

#ifdef DEBUG
#undef DEBUG
#endif

#define SYS_MALLOC(nbytes) lcaMalloc(nbytes)
#define SYS_FREE(ptr)      lcaFree(ptr)
/* wrapper for printing error messages */
#define ecErr(arg)         mexWarnMsgTxt(arg)
#define	NEITHER_SVAL_NOR_VAL_ACTION(pv_name,l,result,nord) mexWarnMsgTxt("invalid PV")

#else

#error "unknown configuration"

#endif



/* struct caching all the necessary information about a board */
typedef struct EcdrBoardCRec_ {
	char			*name;
	chid			nbrd_id, bidx_id, val_id, sval_id, lock_id;	/* a couple of channel ids */
	struct EcdrBoardCRec_	*next; 						/* linked list */
	CA_SYNC_GID		sg;
} EcdrBoardCRec, *EcdrBoardC;

/* linked list of all known boards */
static EcdrBoardC	ecdrList=0;

/* release all resources related to a EcdrBoardCRec (including the
 * data structure itself).
 * Returns the 'next' field for convenience.
 */
static EcdrBoardC
ecdrBoardCdestroy(EcdrBoardC p)
{
EcdrBoardC rval;

	if (!p)
		return 0;

	if (p->val_id)	ca_clear_channel(p->val_id);
	if (p->sval_id)	ca_clear_channel(p->sval_id);
	if (p->lock_id)	ca_clear_channel(p->lock_id);
	if (p->bidx_id)	ca_clear_channel(p->bidx_id);
	if (p->nbrd_id)	ca_clear_channel(p->nbrd_id);
	if (p->sg) 		ca_sg_delete(p->sg);
	ca_pend_io(1.0);
	if (p->name)	SYS_FREE(p->name);

	rval = p->next;

	SYS_FREE(p);

	return rval;
}

/* search for a board 'name' in the cache. If the lookup fails,
 * try to create a new info struct and connection.
 *
 * RETURNS:
 *   SUCCESS: pointer to EcBardCRec from cache or newly created
 *            handle.
 *   FAILURE: 0 (all resources are released)
 */
static EcdrBoardC findConnectBoard(char *name)
{
	EcdrBoardC p;
	char	nbuf[100];

	assert(strlen(name) < sizeof(nbuf)-40);

	for (p=0; p && !strcmp(name, p->name); p++) /* do nothing */;

	if (p) return p; /* board exists already */

	/* create a new board entry */
	if (!(p=(EcdrBoardC)SYS_MALLOC(sizeof(*p)))) {
		ecErr("out of memory");
		goto cleanup;
	}
	memset(p,0,sizeof(*p));

	/* copy the name */
	if (!(p->name = (char*)SYS_MALLOC(strlen(name+1)))) {
		ecErr("out of memory");
		goto cleanup;
	}
	strcpy(p->name,name);

	/* now try to connect the needed channels */
	if (	(sprintf(nbuf,"%s.VAL", name), ECA_NORMAL!=ca_search(nbuf,&p->val_id)) ||
		(sprintf(nbuf,"%s.SVAL",name), ECA_NORMAL!=ca_search(nbuf,&p->sval_id)) ||
		(sprintf(nbuf,"%s.NBRD",name), ECA_NORMAL!=ca_search(nbuf,&p->nbrd_id)) ||
		(sprintf(nbuf,"%s.LOCK",name), ECA_NORMAL!=ca_search(nbuf,&p->lock_id)) ||
		(sprintf(nbuf,"%s.BIDX",name), ECA_NORMAL!=ca_search(nbuf,&p->bidx_id)) ||
		(ECA_NORMAL!=ca_pend_io(10.)) ) {
		sprintf(nbuf,"PVs for '%s' not found",name);
		ecErr(nbuf);
		goto cleanup;
	}

	/* create a synchronous group for the ca_puts */
	if ( ECA_NORMAL != ca_sg_create(&p->sg) ) {
		ecErr("unable to create synchronous group");
		goto cleanup;
	}

	/* SUCCESS */
	/* link into list */
	p->next = ecdrList;
	ecdrList = p;
	return p;

cleanup:
	/* FAILURE: release all resources and return 0 */
	ecdrBoardCdestroy(p);
	return 0;
}

/* ecdrget:
 *
 * reads data from the ECDR according to the following algorithm:
 *
 *   - strip field name from pv_name. Find cache entry or create
 *     a new connection.
 *   - Determine from the field name whether to interpret echotek
 *     data as SHORT or LONG.
 *   - obtain the ECDR record's lock
 *   - read NBRD (the number of bytes present in the server's buffer)
 *   - allocate a buffer (array of LONG).
 *   - repeatedly read chunks from the VAL or SVAL (short data)
 *     field until the entire buffer is transferred.
 *   - in case SHORT data was transferred to our buffer, convert it
 *     to LONG data.
 *   - release the lock.
 *   - pass the caller a pointer to the allocated buffer in *result
 *     and the number of elements in *nord (number of elements read)
 *
 * RETURNS:
 *   SUCCESS: - number of elements read in *nord
 *            - DATA as an array of *nord elements of LONG in *result.
 *              I.e. no matter whether the user reads VAL or SVAL
 *              the result is always a properly converted array of LONG
 *
 *              NOTE however, that the user still must read the correct
 *              PV according to whether the data are to interpreted as
 *              SHORT or LONG!
 *
 *   FAILURE:   all resources are released; *result and *nord are
 *              passed 0.
 *
 */

#ifndef CMDLINE_APP

#define epicsExportSharedSymbols
#include <shareLib.h>
#include <ecget.h>
#endif

void
#ifndef CMDLINE_APP
epicsShareAPI
#endif
ecdrget (char *pv_name, int *l, buf_t **result, int *nord)
{
long		i,j,blsz,zero=0,nelms,chunk,elsz;
char		lock=1;
buf_t		*buf=0;
EcdrBoardC	p=0;
char		msgbuf[100], *isSVAL;
chid		valID;

	/* reset return values */
	*result = 0;
	*nord   = 0;

	/* strip record field off board name */
	assert(strlen(pv_name) + 1 < sizeof(msgbuf));
	strcpy(msgbuf, pv_name);

	if ((isSVAL=strchr(msgbuf,'.'))) {
		*(isSVAL++)=0; /* strip off field name */
		/* is it the SVAL field ? */
		if (!strcmp(isSVAL,"SVAL")) {
			/* yes, no action needed */
		}
		else if (!strcmp(isSVAL,"VAL")) {
			/* it's VAL, reset isSVAL flag */
			isSVAL=0;
		}
		else {
			/* neither SVAL nor VAL; perform system dependent action and return */
			NEITHER_SVAL_NOR_VAL_ACTION(pv_name,l,result,nord);
			goto cleanup;
		}

	} /* else no field name --> VAL is default */

	/* look for this board in the cache or create an entry */
	if (! (p=findConnectBoard(msgbuf)) )
		goto cleanup;

	/* which PV to use ? */
	valID = isSVAL ? p->sval_id : p->val_id;

	/* get block and element sizes */
	blsz = ca_element_count(valID);
	elsz = isSVAL ? sizeof(short) : sizeof(long);

	/* try to acquire the LOCK field */
	if ((ECA_NORMAL!=ca_array_get(DBR_CHAR, 1, p->lock_id, &lock)) ||
		(ECA_NORMAL!=ca_pend_io(10.)) ||
		lock) {
		if ( lock == 3 )
			ecErr("Lock has value 3 -- IOC supports large CA transfers but not the locking protocol\n");
		else
			ecErr("Unable to acquire lock, try again\n");
		goto cleanup;
	}

	/* reset index using a synchronous group (making sure write completes
	 * before we start reading blocks)
	 */
	if ( (ECA_NORMAL!=ca_sg_array_get(p->sg, DBR_LONG, 1, p->nbrd_id, &nelms)) ||
	     (ECA_NORMAL!=ca_sg_array_put(p->sg, DBR_LONG, 1, p->bidx_id, &zero)) ||
	     (ECA_NORMAL!=ca_sg_block(p->sg,20.)) ) {
		ecErr("Unable to get/setup associated array PVs");
		goto cleanup;
	}

	/* calculate the total number of elements from the byte count */
	nelms /= elsz;

	/* verify element count is non-zero */
	if (nelms == 0) {
		ecErr("No elements to acquire");
		goto cleanup;
	}

	/* allocate buffer space */
	buf = (buf_t *)SYS_MALLOC(nelms * sizeof(buf_t));

	if (!buf) {
		ecErr("Out of memory - unable to allocate buffer");
		goto cleanup;
	}

#ifdef DEBUG
fprintf(stderr,"# elements %i, BLSZ %i, reading data...",nelms,blsz); fflush(stderr);
#endif

	/* post a the necessary number of read requests */
	for (i=0, chunk = blsz; i<nelms; i+=chunk) {
		if (nelms-i < chunk)
			chunk = nelms-i;
		/* if we are reading from SVAL we assume that the ECHOTEK
		 * holds an array:
		 *
		 *   short ecdr_buffer[nelems]
		 *
		 * We could let the server perform the conversion to LONG
		 * but that would slow down the transfer.
		 * Therefore, we ask for DBR_SHORTs and because our buffer
		 * is declared
		 *
		 *   long buf[nelems]
		 *
		 * we'll end up with the individual chunks holding
		 * shorts. Therefore we'll rearrange our buffer a couple
		 * of lines further down...
		 */
		if (ECA_NORMAL!=ca_array_get(isSVAL ? DBR_SHORT : DBR_LONG,
					     chunk,
					     valID,
					     (void*)(buf+i))) {
			sprintf(msgbuf,"Error getting block %li",i);
			ecErr(msgbuf);
			goto cleanup;
		}
	}

	/* now wait for the buffer to fill... */

	if ((ECA_NORMAL!=ca_pend_io(30.))) {
		ecErr("Unable to get value (PEND)");
		goto cleanup;
	}

	if (isSVAL) {
		/* rearrange the array so it's a proper array of 'longs' */
		for (i=0, chunk = blsz; i < nelms; i+=chunk) {
			if (nelms-i < chunk)
				chunk = nelms-i;
			/* work our way downwards converting shorts to longs */
			for (j=chunk-1; j>=0; j--) {
				/* do the actual conversion */
				(buf+i)[j] = (long)(((short*)(buf+i))[j]);
			}

		}
	}

#ifdef DEBUG
fprintf(stderr,"done.\n");
	if (i>=nelms)
		fprintf(stderr,"read of %i elements was successful\n",nelms);
#endif

	/* SUCCESS */
	*result = buf;
	buf=0;
	*nord   = nelms;

	/* fall through and cleanup */

cleanup:
	/* release the lock */
	if (!lock) {
		char unlock[2]={0,0};
		if ( (ECA_NORMAL!=ca_sg_array_put(p->sg, DBR_CHAR, 2, p->lock_id, unlock)) ||
/*			(ECA_NORMAL!=ca_array_get(DBR_LONG, 1, p->nbrd_id, &nbrd)) ||  */
			(ECA_NORMAL!=ca_sg_block(p->sg,10.))) {
			ecErr("OOps, unable to release lock...");
		}
		ca_pend_event(1.);
	}
	if (buf) SYS_FREE(buf);
}

#ifdef CMDLINE_APP

static void
usage(char *nm)
{
	fprintf(stderr,"usage: %s <ECDR PV name> [-hcd <fmt>]\n\n",nm);
	fprintf(stderr,"          -h        -- this message\n");
	fprintf(stderr,"          -c        -- verify counter data\n");
	fprintf(stderr,"          -d <fmt>  -- dump to stdout using (printf) format <fmt>\n");
	fprintf(stderr,"          -u		-- force unlocking the lock field\n");
	fputc('\n',stderr);
}


/* perform backslash substitution on str, i.e.
 * substitute all occurrences of '\''schar' by 'subst'
 */
static void
bssubst(char *str, char schar, char subst)
{
char sstr[3], *chpt;
	sstr[0]='\\'; sstr[1]=schar; sstr[2]=0;

	while (str=strstr(str,sstr)) {
		*(str++) = subst;
		chpt=str+1;
		do {
			*(chpt-1) = *chpt;
		} while (*(chpt++));
	}
}


int
main(int argc, char **argv)
{
buf_t	*buf=0;
int		nord=0,i;
int		ch,rval=0,test=0,forceunlock=0;
char	*fmt=0;

	while ((ch=getopt(argc,argv,"hcud:"))>=0) {
		switch (ch) {
			default:	fprintf(stderr,"unknown option '%c'\n",ch);
					rval=1;
			case 'h':	usage(argv[0]);
					return rval;

			case 'c':	test=1;	
					break;

			case 'u':   forceunlock=1;
					break;

			case 'd':
					fmt = optarg;
					break;
		}
	}

	if (optind>=argc) {
		fprintf(stderr,"%s: need an argument (ECDR PV name)\n\n",argv[0]);
		usage(argv[0]);
		exit(1);
	}

	ca_task_initialize();

	if (forceunlock) {
		char unlock[2]={0,0};
		EcdrBoardC	p = findConnectBoard(argv[optind]);
		if ( !p ||
			(ECA_NORMAL!=ca_sg_array_put(p->sg, DBR_CHAR, 2, p->lock_id, unlock)) ||
			(ECA_NORMAL!=ca_sg_block(p->sg,10.))) {
			ecErr("OOps, unable to release lock...");
		}
	} else {
		/* normal operation */

		ecdrget(argv[optind],0,&buf,&nord);
	
		fprintf(stderr,"MAIN: %i elements read\n",nord);
	
		if (!nord) return 2;
	
		if (fmt) {
			if (!strchr(fmt,'%')) {
				fprintf(stderr,"ERROR format has no %%\n");
				exit(1);
			}
			bssubst(fmt, 'n', '\n');
			bssubst(fmt, 'r', '\r');
			bssubst(fmt, 't', '\t');
			bssubst(fmt, '\\', '\\');
			bssubst(fmt, '0', '\0');
			for(i=0; i< nord; i++)
				printf(fmt,buf[i]);
		}
	
		if (test) {
			for(i=0; i<nord; i++)
				if (4*(i+1) % (1<<8*sizeof(short)) !=(int)(unsigned short)buf[i]) {
					fprintf(stderr,"mismatch at %i (buf[i]==%i (0x%08x) , should be %i)\n",i,buf[i],buf[i],4*(i+1));
					rval=2;
					break;
				}
			if (i>=nord)
					fprintf(stderr,"Comparison of %i counter values was SUCCESSFUL\n",nord);
		}
	
	}

	{
	/* delete all channels */
	EcdrBoardC p;
		for (p = ecdrList; p;) {
			p = ecdrBoardCdestroy(p);
		}
	}

	ca_task_exit();

	if (buf) SYS_FREE(buf);

	return rval;
}
#endif
