/*
 * status code symbol table
 *
 * CREATED BY makeStatTbl.pl
 *       FROM C:/epics/base_3_15_5/src/libCom/O.windows-x64
 *         ON Mon Dec  4 17:24:32 2017
 */

#include "errMdef.h"
#include "errSymTbl.h"

#ifndef M_dbAccess
#define M_dbAccess (501 <<16) /*Database Access Routines */
#endif /* ifdef M_dbAccess */
#ifndef M_drvSup
#define M_drvSup (503 <<16) /*Driver Support*/
#endif /* ifdef M_drvSup */
#ifndef M_devSup
#define M_devSup (504 <<16) /*Device Support*/
#endif /* ifdef M_devSup */
#ifndef M_recSup
#define M_recSup (505 <<16) /*Record Support*/
#endif /* ifdef M_recSup */
#ifndef M_recType
#define M_recType (506 <<16) /*Record Type*/
#endif /* ifdef M_recType */
#ifndef M_record
#define M_record (507 <<16) /*Database Records*/
#endif /* ifdef M_record */
#ifndef M_ar
#define M_ar (508 <<16) /*Archiver; see arDefs.h*/
#endif /* ifdef M_ar */
#ifndef M_ts
#define M_ts (509 <<16) /*Time Stamp Routines; see tsDefs.h*/
#endif /* ifdef M_ts */
#ifndef M_arAcc
#define M_arAcc (510 <<16) /*Archive Access Library Routines*/
#endif /* ifdef M_arAcc */
#ifndef M_bf
#define M_bf (511 <<16) /*Block File Routines; see bfDefs.h*/
#endif /* ifdef M_bf */
#ifndef M_syd
#define M_syd (512 <<16) /*Sync Data Routines; see sydDefs.h*/
#endif /* ifdef M_syd */
#ifndef M_ppr
#define M_ppr (513 <<16) /*Portable Plot Routines; see pprPlotDefs.h*/
#endif /* ifdef M_ppr */
#ifndef M_env
#define M_env (514 <<16) /*Environment Routines; see envDefs.h*/
#endif /* ifdef M_env */
#ifndef M_gen
#define M_gen (515 <<16) /*General Purpose Routines; see genDefs.h*/
#endif /* ifdef M_gen */
#ifndef M_dbLib
#define M_dbLib (519 <<16) /*Static Database Access */
#endif /* ifdef M_dbLib */
#ifndef M_epvxi
#define M_epvxi (520 <<16) /*VXI Driver*/
#endif /* ifdef M_epvxi */
#ifndef M_devLib
#define M_devLib (521 <<16) /*Device Resource Registration*/
#endif /* ifdef M_devLib */
#ifndef M_asLib
#define M_asLib (522 <<16) /*Access Security		*/
#endif /* ifdef M_asLib */
#ifndef M_cas
#define M_cas (523 <<16) /*CA server*/
#endif /* ifdef M_cas */
#ifndef M_casApp
#define M_casApp (524 <<16) /*CA server application*/
#endif /* ifdef M_casApp */
#ifndef M_bucket
#define M_bucket (525 <<16) /*Bucket Hash*/
#endif /* ifdef M_bucket */
#ifndef M_gddFuncTbl
#define M_gddFuncTbl (526 <<16) /*gdd jump table*/
#endif /* ifdef M_gddFuncTbl */
#ifndef M_stdlib
#define M_stdlib (527 <<16) /*EPICS Standard library*/
#endif /* ifdef M_stdlib */
#ifndef M_pool
#define M_pool (528 <<16) /*Thread pool*/
#endif /* ifdef M_pool */
#define S_dev_success 0
#define S_dev_vectorInUse (M_devLib| 1) /*interrupt vector in use*/
#define S_dev_vecInstlFail (M_devLib| 2) /*interrupt vector install failed*/
#define S_dev_uknIntType (M_devLib| 3) /*Unrecognized interrupt type*/ 
#define S_dev_vectorNotInUse (M_devLib| 4) /*Interrupt vector not in use by caller*/
#define S_dev_badA16 (M_devLib| 5) /*Invalid VME A16 address*/
#define S_dev_badA24 (M_devLib| 6) /*Invalid VME A24 address*/
#define S_dev_badA32 (M_devLib| 7) /*Invalid VME A32 address*/
#define S_dev_uknAddrType (M_devLib| 8) /*Unrecognized address space type*/
#define S_dev_addressOverlap (M_devLib| 9) /*Specified device address overlaps another device*/ 
#define S_dev_identifyOverlap (M_devLib| 10) /*This device already owns the address range*/ 
#define S_dev_addrMapFail (M_devLib| 11) /*unable to map address*/ 
#define S_dev_intDisconnect (M_devLib| 12) /*Interrupt at vector disconnected from an EPICS device*/ 
#define S_dev_internal (M_devLib| 13) /*Internal failure*/ 
#define S_dev_intEnFail (M_devLib| 14) /*unable to enable interrupt level*/ 
#define S_dev_intDissFail (M_devLib| 15) /*unable to disable interrupt level*/ 
#define S_dev_noMemory (M_devLib| 16) /*Memory allocation failed*/ 
#define S_dev_addressNotFound (M_devLib| 17) /*Specified device address unregistered*/ 
#define S_dev_noDevice (M_devLib| 18) /*No device at specified address*/
#define S_dev_wrongDevice (M_devLib| 19) /*Wrong device type found at specified address*/
#define S_dev_badSignalNumber (M_devLib| 20) /*Signal number (offset) to large*/
#define S_dev_badSignalCount (M_devLib| 21) /*Signal count to large*/
#define S_dev_badRequest (M_devLib| 22) /*Device does not support requested operation*/
#define S_dev_highValue (M_devLib| 23) /*Parameter to high*/
#define S_dev_lowValue (M_devLib| 24) /*Parameter to low*/
#define S_dev_multDevice (M_devLib| 25) /*Specified address is ambiguous (more than one device responds)*/
#define S_dev_badSelfTest (M_devLib| 26) /*Device self test failed*/
#define S_dev_badInit (M_devLib| 27) /*Device failed during initialization*/
#define S_dev_hdwLimit (M_devLib| 28) /*Input exceeds Hardware Limit*/
#define S_dev_deviceDoesNotFit (M_devLib| 29) /*Unable to locate address space for device*/
#define S_dev_deviceTMO (M_devLib| 30) /*device timed out*/
#define S_dev_badFunction (M_devLib| 31) /*bad function pointer*/
#define S_dev_badVector (M_devLib| 32) /*bad interrupt vector*/
#define S_dev_badArgument (M_devLib| 33) /*bad function argument*/
#define S_dev_badISA (M_devLib| 34) /*Invalid ISA address*/
#define S_dev_badCRCSR (M_devLib| 35) /*Invalid VME CR/CSR address*/
#define S_dev_vxWorksIntEnFail S_dev_intEnFail
#define S_asLib_clientsExist 	(M_asLib| 1) /*Client Exists*/
#define S_asLib_noUag 		(M_asLib| 2) /*User Access Group does not exist*/
#define S_asLib_noHag 		(M_asLib| 3) /*Host Access Group does not exist*/
#define S_asLib_noAccess	(M_asLib| 4) /*access security: no access allowed*/
#define S_asLib_noModify	(M_asLib| 5) /*access security: no modification allowed*/
#define S_asLib_badConfig	(M_asLib| 6) /*access security: bad configuration file*/
#define S_asLib_badCalc		(M_asLib| 7) /*access security: bad calculation espression*/
#define S_asLib_dupAsg 		(M_asLib| 8) /*Duplicate Access Security Group */
#define S_asLib_InitFailed 	(M_asLib| 9) /*access security: Init failed*/
#define S_asLib_asNotActive 	(M_asLib|10) /*access security is not active*/
#define S_asLib_badMember 	(M_asLib|11) /*access security: bad ASMEMBERPVT*/
#define S_asLib_badClient 	(M_asLib|12) /*access security: bad ASCLIENTPVT*/
#define S_asLib_badAsg 		(M_asLib|13) /*access security: bad ASG*/
#define S_asLib_noMemory	(M_asLib|14) /*access security: no Memory */
#define S_stdlib_noConversion (M_stdlib | 1) /* No digits to convert */
#define S_stdlib_extraneous   (M_stdlib | 2) /* Extraneous characters */
#define S_stdlib_underflow    (M_stdlib | 3) /* Too small to represent */
#define S_stdlib_overflow     (M_stdlib | 4) /* Too large to represent */
#define S_stdlib_badBase      (M_stdlib | 5) /* Number base not supported */
#define S_pool_jobBusy   (M_pool| 1) /*Job already queued or running*/
#define S_pool_jobIdle   (M_pool| 2) /*Job was not queued or running*/
#define S_pool_noPool    (M_pool| 3) /*Job not associated with a pool*/
#define S_pool_paused    (M_pool| 4) /*Pool not currently accepting jobs*/
#define S_pool_noThreads (M_pool| 5) /*Can't create worker thread*/
#define S_pool_timeout   (M_pool| 6) /*Pool still busy after timeout*/
#define S_db_notFound 	(M_dbAccess| 1) /*Process Variable Not Found*/
#define S_db_badDbrtype	(M_dbAccess| 3) /*Illegal Database Request Type*/
#define S_db_noMod 	(M_dbAccess| 5) /*Attempt to modify noMod field*/
#define S_db_badLset 	(M_dbAccess| 7) /*Illegal Lock Set*/
#define S_db_precision 	(M_dbAccess| 9) /*get precision failed */
#define S_db_onlyOne 	(M_dbAccess|11) /*Only one element allowed*/
#define S_db_badChoice 	(M_dbAccess|13) /*Illegal choice*/
#define S_db_badField 	(M_dbAccess|15) /*Illegal field value*/
#define S_db_lsetLogic 	(M_dbAccess|17) /*Logic error generating lock sets*/
#define S_db_noRSET 	(M_dbAccess|31) /*missing record support entry table*/
#define S_db_noSupport 	(M_dbAccess|33) /*RSET or DSXT routine not defined*/
#define S_db_BadSub 	(M_dbAccess|35) /*Subroutine not found*/
#define S_db_Pending 	(M_dbAccess|37) /*Request is pending*/
#define S_db_Blocked 	(M_dbAccess|39) /*Request is Blocked*/
#define S_db_putDisabled (M_dbAccess|41) /*putFields are disabled*/
#define S_db_badHWaddr  (M_dbAccess|43) /*Hardware link type not on INP/OUT*/
#define S_db_bkptSet    (M_dbAccess|53) /*Breakpoint already set*/
#define S_db_bkptNotSet (M_dbAccess|55) /*No breakpoint set in record*/
#define S_db_notStopped (M_dbAccess|57) /*Record not stopped*/
#define S_db_errArg     (M_dbAccess|59) /*Error in argument*/
#define S_db_bkptLogic  (M_dbAccess|61) /*Logic error in breakpoint routine*/
#define S_db_cntSpwn    (M_dbAccess|63) /*Cannot spawn dbContTask*/
#define S_db_cntCont    (M_dbAccess|65) /*Cannot resume dbContTask*/
#define S_db_noMemory   (M_dbAccess|66) /*unable to allocate data structure from pool*/
#define S_db_notInit    (M_dbAccess|67) /*Not initialized*/
#define S_db_bufFull    (M_dbAccess|68) /*Buffer full*/
#define S_dev_noDevSup      (M_devSup| 1) /*SDR_DEVSUP: Device support missing*/
#define S_dev_noDSET        (M_devSup| 3) /*Missing device support entry table*/
#define S_dev_missingSup    (M_devSup| 5) /*Missing device support routine*/
#define S_dev_badInpType    (M_devSup| 7) /*Bad INP link type*/
#define S_dev_badOutType    (M_devSup| 9) /*Bad OUT link type*/
#define S_dev_badInitRet    (M_devSup|11) /*Bad init_rec return value */
#define S_dev_badBus        (M_devSup|13) /*Illegal bus type*/
#define S_dev_badCard       (M_devSup|15) /*Illegal or nonexistant module*/
#define S_dev_badSignal     (M_devSup|17) /*Illegal signal*/
#define S_dev_NoInit        (M_devSup|19) /*No init*/
#define S_dev_Conflict      (M_devSup|21) /*Multiple records accessing same signal*/
#define S_dev_noDeviceFound (M_devSup|23) /*No device found at specified address*/
#define S_drv_noDrvSup   (M_drvSup| 1) /*SDR_DRVSUP: Driver support missing*/
#define S_drv_noDrvet    (M_drvSup| 3) /*Missing driver support entry table*/
#define S_rec_noRSET     (M_recSup| 1) /*Missing record support entry table*/
#define S_rec_noSizeOffset (M_recSup| 2) /*Missing SizeOffset Routine*/
#define S_rec_outMem     (M_recSup| 3) /*Out of Memory*/
#define S_dbLib_recordTypeNotFound (M_dbLib|1) /* Record Type does not exist */
#define S_dbLib_recExists (M_dbLib|3)          /* Record Already exists */
#define S_dbLib_recNotFound (M_dbLib|5)        /* Record Not Found */
#define S_dbLib_flddesNotFound (M_dbLib|7)     /* Field Description Not Found */
#define S_dbLib_fieldNotFound (M_dbLib|9)      /* Field Not Found */
#define S_dbLib_badField (M_dbLib|11)          /* Bad Field value */
#define S_dbLib_menuNotFound (M_dbLib|13)      /* Menu not found */
#define S_dbLib_badLink (M_dbLib|15)           /* Bad Link Field */
#define S_dbLib_nameLength (M_dbLib|17)        /* Record Name is too long */
#define S_dbLib_noRecSup (M_dbLib|19)          /* Record support not found */
#define S_dbLib_strLen (M_dbLib|21)            /* String is too long */
#define S_dbLib_noSizeOffset (M_dbLib|23)      /* Missing SizeOffset Routine - No record support? */
#define S_dbLib_outMem (M_dbLib|27)            /* Out of memory */
#define S_dbLib_infoNotFound (M_dbLib|29)      /* Info item Not Found */
#define S_cas_success 0
#define S_cas_internal (M_cas| 1) /*Internal failure*/
#define S_cas_noMemory (M_cas| 2) /*Memory allocation failed*/
#define S_cas_bindFail (M_cas| 3) /*Attempt to set server's IP address/port failed*/
#define S_cas_hugeRequest (M_cas | 4) /*Requested op does not fit*/
#define S_cas_sendBlocked (M_cas | 5) /*Blocked for send q space*/
#define S_cas_badElementCount (M_cas | 6) /*Bad element count*/
#define S_cas_noConvert (M_cas | 7) /*No conversion between src & dest types*/
#define S_cas_badWriteType (M_cas | 8) /*Src type inappropriate for write*/
#define S_cas_noContext (M_cas | 11) /*Context parameter is required*/
#define S_cas_disconnect (M_cas | 12) /*Lost connection to server*/
#define S_cas_recvBlocked (M_cas | 13) /*Recv blocked*/
#define S_cas_badType (M_cas | 14) /*Bad data type*/
#define S_cas_timerDoesNotExist (M_cas | 15) /*Timer does not exist*/
#define S_cas_badEventType (M_cas | 16) /*Bad event type*/
#define S_cas_badResourceId (M_cas | 17) /*Bad resource identifier*/
#define S_cas_chanCreateFailed (M_cas | 18) /*Unable to create channel*/
#define S_cas_noRead (M_cas | 19) /*read access denied*/
#define S_cas_noWrite (M_cas | 20) /*write access denied*/
#define S_cas_noEventsSelected (M_cas | 21) /*no events selected*/
#define S_cas_noFD (M_cas | 22) /*no file descriptors available*/
#define S_cas_badProtocol (M_cas | 23) /*protocol from client was invalid*/
#define S_cas_redundantPost (M_cas | 24) /*redundundant io completion post*/
#define S_cas_badPVName (M_cas | 25) /*bad PV name from server tool*/
#define S_cas_badParameter (M_cas | 26) /*bad parameter from server tool*/
#define S_cas_validRequest (M_cas | 27) /*valid request*/
#define S_cas_tooManyEvents (M_cas | 28) /*maximum simult event types exceeded*/
#define S_cas_noInterface (M_cas | 29) /*server isnt attached to a network*/
#define S_cas_badBounds (M_cas | 30) /*server tool changed bounds on request*/
#define S_cas_pvAlreadyAttached (M_cas | 31) /*PV attached to another server*/
#define S_cas_badRequest (M_cas | 32) /*client's request was invalid*/
#define S_cas_invalidAsynchIO (M_cas | 33) /*inappropriate asynchronous IO type*/
#define S_cas_posponeWhenNonePending (M_cas | 34) /*request postponement, none pending*/
#define S_casApp_success 0 
#define S_casApp_noMemory (M_casApp | 1) /*Memory allocation failed*/
#define S_casApp_pvNotFound (M_casApp | 2) /*PV not found*/
#define S_casApp_badPVId (M_casApp | 3) /*Unknown PV identifier*/
#define S_casApp_noSupport (M_casApp | 4) /*No application support for op*/
#define S_casApp_asyncCompletion (M_casApp | 5) /*will complete asynchronously*/
#define S_casApp_badDimension (M_casApp | 6) /*bad matrix size in request*/
#define S_casApp_canceledAsyncIO (M_casApp | 7) /*asynchronous io canceled*/
#define S_casApp_outOfBounds (M_casApp | 8) /*operation was out of bounds*/
#define S_casApp_undefined (M_casApp | 9) /*undefined value*/
#define S_casApp_postponeAsyncIO (M_casApp | 10) /*postpone asynchronous IO*/
#define S_gddAppFuncTable_Success 0u
#define S_gddAppFuncTable_badType (M_gddFuncTbl|1u) /*application type unregistered*/ 
#define S_gddAppFuncTable_gddLimit (M_gddFuncTbl|2u) /*at gdd lib limit*/ 
#define S_gddAppFuncTable_noMemory (M_gddFuncTbl|3u) /*dynamic memory pool exhausted*/ 

static ERRSYMBOL symbols[] =
{
	{ "interrupt vector in use", (long) S_dev_vectorInUse },
	{ "interrupt vector install failed", (long) S_dev_vecInstlFail },
	{ "Unrecognized interrupt type", (long) S_dev_uknIntType },
	{ "Interrupt vector not in use by caller", (long) S_dev_vectorNotInUse },
	{ "Invalid VME A16 address", (long) S_dev_badA16 },
	{ "Invalid VME A24 address", (long) S_dev_badA24 },
	{ "Invalid VME A32 address", (long) S_dev_badA32 },
	{ "Unrecognized address space type", (long) S_dev_uknAddrType },
	{ "Specified device address overlaps another device", (long) S_dev_addressOverlap },
	{ "This device already owns the address range", (long) S_dev_identifyOverlap },
	{ "unable to map address", (long) S_dev_addrMapFail },
	{ "Interrupt at vector disconnected from an EPICS device", (long) S_dev_intDisconnect },
	{ "Internal failure", (long) S_dev_internal },
	{ "unable to enable interrupt level", (long) S_dev_intEnFail },
	{ "unable to disable interrupt level", (long) S_dev_intDissFail },
	{ "Memory allocation failed", (long) S_dev_noMemory },
	{ "Specified device address unregistered", (long) S_dev_addressNotFound },
	{ "No device at specified address", (long) S_dev_noDevice },
	{ "Wrong device type found at specified address", (long) S_dev_wrongDevice },
	{ "Signal number (offset) to large", (long) S_dev_badSignalNumber },
	{ "Signal count to large", (long) S_dev_badSignalCount },
	{ "Device does not support requested operation", (long) S_dev_badRequest },
	{ "Parameter to high", (long) S_dev_highValue },
	{ "Parameter to low", (long) S_dev_lowValue },
	{ "Specified address is ambiguous (more than one device responds)", (long) S_dev_multDevice },
	{ "Device self test failed", (long) S_dev_badSelfTest },
	{ "Device failed during initialization", (long) S_dev_badInit },
	{ "Input exceeds Hardware Limit", (long) S_dev_hdwLimit },
	{ "Unable to locate address space for device", (long) S_dev_deviceDoesNotFit },
	{ "device timed out", (long) S_dev_deviceTMO },
	{ "bad function pointer", (long) S_dev_badFunction },
	{ "bad interrupt vector", (long) S_dev_badVector },
	{ "bad function argument", (long) S_dev_badArgument },
	{ "Invalid ISA address", (long) S_dev_badISA },
	{ "Invalid VME CR/CSR address", (long) S_dev_badCRCSR },
	{ "Client Exists", (long) S_asLib_clientsExist },
	{ "User Access Group does not exist", (long) S_asLib_noUag },
	{ "Host Access Group does not exist", (long) S_asLib_noHag },
	{ "access security: no access allowed", (long) S_asLib_noAccess },
	{ "access security: no modification allowed", (long) S_asLib_noModify },
	{ "access security: bad configuration file", (long) S_asLib_badConfig },
	{ "access security: bad calculation espression", (long) S_asLib_badCalc },
	{ "Duplicate Access Security Group ", (long) S_asLib_dupAsg },
	{ "access security: Init failed", (long) S_asLib_InitFailed },
	{ "access security is not active", (long) S_asLib_asNotActive },
	{ "access security: bad ASMEMBERPVT", (long) S_asLib_badMember },
	{ "access security: bad ASCLIENTPVT", (long) S_asLib_badClient },
	{ "access security: bad ASG", (long) S_asLib_badAsg },
	{ "access security: no Memory ", (long) S_asLib_noMemory },
	{ " No digits to convert ", (long) S_stdlib_noConversion },
	{ " Extraneous characters ", (long) S_stdlib_extraneous },
	{ " Too small to represent ", (long) S_stdlib_underflow },
	{ " Too large to represent ", (long) S_stdlib_overflow },
	{ " Number base not supported ", (long) S_stdlib_badBase },
	{ "Job already queued or running", (long) S_pool_jobBusy },
	{ "Job was not queued or running", (long) S_pool_jobIdle },
	{ "Job not associated with a pool", (long) S_pool_noPool },
	{ "Pool not currently accepting jobs", (long) S_pool_paused },
	{ "Can't create worker thread", (long) S_pool_noThreads },
	{ "Pool still busy after timeout", (long) S_pool_timeout },
	{ "Process Variable Not Found", (long) S_db_notFound },
	{ "Illegal Database Request Type", (long) S_db_badDbrtype },
	{ "Attempt to modify noMod field", (long) S_db_noMod },
	{ "Illegal Lock Set", (long) S_db_badLset },
	{ "get precision failed ", (long) S_db_precision },
	{ "Only one element allowed", (long) S_db_onlyOne },
	{ "Illegal choice", (long) S_db_badChoice },
	{ "Illegal field value", (long) S_db_badField },
	{ "Logic error generating lock sets", (long) S_db_lsetLogic },
	{ "missing record support entry table", (long) S_db_noRSET },
	{ "RSET or DSXT routine not defined", (long) S_db_noSupport },
	{ "Subroutine not found", (long) S_db_BadSub },
	{ "Request is pending", (long) S_db_Pending },
	{ "Request is Blocked", (long) S_db_Blocked },
	{ "putFields are disabled", (long) S_db_putDisabled },
	{ "Hardware link type not on INP/OUT", (long) S_db_badHWaddr },
	{ "Breakpoint already set", (long) S_db_bkptSet },
	{ "No breakpoint set in record", (long) S_db_bkptNotSet },
	{ "Record not stopped", (long) S_db_notStopped },
	{ "Error in argument", (long) S_db_errArg },
	{ "Logic error in breakpoint routine", (long) S_db_bkptLogic },
	{ "Cannot spawn dbContTask", (long) S_db_cntSpwn },
	{ "Cannot resume dbContTask", (long) S_db_cntCont },
	{ "unable to allocate data structure from pool", (long) S_db_noMemory },
	{ "Not initialized", (long) S_db_notInit },
	{ "Buffer full", (long) S_db_bufFull },
	{ "SDR_DEVSUP: Device support missing", (long) S_dev_noDevSup },
	{ "Missing device support entry table", (long) S_dev_noDSET },
	{ "Missing device support routine", (long) S_dev_missingSup },
	{ "Bad INP link type", (long) S_dev_badInpType },
	{ "Bad OUT link type", (long) S_dev_badOutType },
	{ "Bad init_rec return value ", (long) S_dev_badInitRet },
	{ "Illegal bus type", (long) S_dev_badBus },
	{ "Illegal or nonexistant module", (long) S_dev_badCard },
	{ "Illegal signal", (long) S_dev_badSignal },
	{ "No init", (long) S_dev_NoInit },
	{ "Multiple records accessing same signal", (long) S_dev_Conflict },
	{ "No device found at specified address", (long) S_dev_noDeviceFound },
	{ "SDR_DRVSUP: Driver support missing", (long) S_drv_noDrvSup },
	{ "Missing driver support entry table", (long) S_drv_noDrvet },
	{ "Missing record support entry table", (long) S_rec_noRSET },
	{ "Missing SizeOffset Routine", (long) S_rec_noSizeOffset },
	{ "Out of Memory", (long) S_rec_outMem },
	{ " Record Type does not exist ", (long) S_dbLib_recordTypeNotFound },
	{ " Record Already exists ", (long) S_dbLib_recExists },
	{ " Record Not Found ", (long) S_dbLib_recNotFound },
	{ " Field Description Not Found ", (long) S_dbLib_flddesNotFound },
	{ " Field Not Found ", (long) S_dbLib_fieldNotFound },
	{ " Bad Field value ", (long) S_dbLib_badField },
	{ " Menu not found ", (long) S_dbLib_menuNotFound },
	{ " Bad Link Field ", (long) S_dbLib_badLink },
	{ " Record Name is too long ", (long) S_dbLib_nameLength },
	{ " Record support not found ", (long) S_dbLib_noRecSup },
	{ " String is too long ", (long) S_dbLib_strLen },
	{ " Missing SizeOffset Routine - No record support? ", (long) S_dbLib_noSizeOffset },
	{ " Out of memory ", (long) S_dbLib_outMem },
	{ " Info item Not Found ", (long) S_dbLib_infoNotFound },
	{ "Internal failure", (long) S_cas_internal },
	{ "Memory allocation failed", (long) S_cas_noMemory },
	{ "Attempt to set server's IP address/port failed", (long) S_cas_bindFail },
	{ "Requested op does not fit", (long) S_cas_hugeRequest },
	{ "Blocked for send q space", (long) S_cas_sendBlocked },
	{ "Bad element count", (long) S_cas_badElementCount },
	{ "No conversion between src & dest types", (long) S_cas_noConvert },
	{ "Src type inappropriate for write", (long) S_cas_badWriteType },
	{ "Context parameter is required", (long) S_cas_noContext },
	{ "Lost connection to server", (long) S_cas_disconnect },
	{ "Recv blocked", (long) S_cas_recvBlocked },
	{ "Bad data type", (long) S_cas_badType },
	{ "Timer does not exist", (long) S_cas_timerDoesNotExist },
	{ "Bad event type", (long) S_cas_badEventType },
	{ "Bad resource identifier", (long) S_cas_badResourceId },
	{ "Unable to create channel", (long) S_cas_chanCreateFailed },
	{ "read access denied", (long) S_cas_noRead },
	{ "write access denied", (long) S_cas_noWrite },
	{ "no events selected", (long) S_cas_noEventsSelected },
	{ "no file descriptors available", (long) S_cas_noFD },
	{ "protocol from client was invalid", (long) S_cas_badProtocol },
	{ "redundundant io completion post", (long) S_cas_redundantPost },
	{ "bad PV name from server tool", (long) S_cas_badPVName },
	{ "bad parameter from server tool", (long) S_cas_badParameter },
	{ "valid request", (long) S_cas_validRequest },
	{ "maximum simult event types exceeded", (long) S_cas_tooManyEvents },
	{ "server isnt attached to a network", (long) S_cas_noInterface },
	{ "server tool changed bounds on request", (long) S_cas_badBounds },
	{ "PV attached to another server", (long) S_cas_pvAlreadyAttached },
	{ "client's request was invalid", (long) S_cas_badRequest },
	{ "inappropriate asynchronous IO type", (long) S_cas_invalidAsynchIO },
	{ "request postponement, none pending", (long) S_cas_posponeWhenNonePending },
	{ "Memory allocation failed", (long) S_casApp_noMemory },
	{ "PV not found", (long) S_casApp_pvNotFound },
	{ "Unknown PV identifier", (long) S_casApp_badPVId },
	{ "No application support for op", (long) S_casApp_noSupport },
	{ "will complete asynchronously", (long) S_casApp_asyncCompletion },
	{ "bad matrix size in request", (long) S_casApp_badDimension },
	{ "asynchronous io canceled", (long) S_casApp_canceledAsyncIO },
	{ "operation was out of bounds", (long) S_casApp_outOfBounds },
	{ "undefined value", (long) S_casApp_undefined },
	{ "postpone asynchronous IO", (long) S_casApp_postponeAsyncIO },
	{ "application type unregistered", (long) S_gddAppFuncTable_badType },
	{ "at gdd lib limit", (long) S_gddAppFuncTable_gddLimit },
	{ "dynamic memory pool exhausted", (long) S_gddAppFuncTable_noMemory },
};

static ERRSYMTAB symTbl =
{
	NELEMENTS(symbols),  /* current number of symbols in table */
	symbols,             /* ptr to symbol array */
};

ERRSYMTAB_ID errSymTbl = &symTbl;

/*	EOF errSymTbl.c */
