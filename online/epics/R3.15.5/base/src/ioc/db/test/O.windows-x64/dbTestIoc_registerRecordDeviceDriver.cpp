/* THIS IS A GENERATED FILE. DO NOT EDIT! */
/* Generated from ../O.Common/dbTestIoc.dbd */

#include <string.h>

#include "compilerDependencies.h"
#include "epicsStdlib.h"
#include "iocsh.h"
#include "iocshRegisterCommon.h"
#include "registryCommon.h"

extern "C" {

epicsShareExtern rset *pvar_rset_xRSET;

typedef int (*rso_func)(dbRecordType *pdbRecordType);
epicsShareExtern rso_func pvar_func_xRecordSizeOffset;

static const char * const recordTypeNames[] = {
    "x"
};

static const recordTypeLocation rtl[] = {
    {pvar_rset_xRSET, pvar_func_xRecordSizeOffset}
};

epicsShareExtern dset *pvar_dset_devxLTestSoft,
    *pvar_dset_devxLTestVME_IO, *pvar_dset_devxLTestCAMAC_IO,
    *pvar_dset_devxLTestAB_IO, *pvar_dset_devxLTestGPIB_IO,
    *pvar_dset_devxLTestBITBUS_IO, *pvar_dset_devxLTestINST_IO,
    *pvar_dset_devxLTestBBGPIB_IO, *pvar_dset_devxLTestRF_IO,
    *pvar_dset_devxLTestVXI_IO;

static const char * const deviceSupportNames[] = {
    "devxLTestSoft", "devxLTestVME_IO", "devxLTestCAMAC_IO",
    "devxLTestAB_IO", "devxLTestGPIB_IO", "devxLTestBITBUS_IO",
    "devxLTestINST_IO", "devxLTestBBGPIB_IO", "devxLTestRF_IO",
    "devxLTestVXI_IO"
};

static const dset * const devsl[] = {
    pvar_dset_devxLTestSoft, pvar_dset_devxLTestVME_IO,
    pvar_dset_devxLTestCAMAC_IO, pvar_dset_devxLTestAB_IO,
    pvar_dset_devxLTestGPIB_IO, pvar_dset_devxLTestBITBUS_IO,
    pvar_dset_devxLTestINST_IO, pvar_dset_devxLTestBBGPIB_IO,
    pvar_dset_devxLTestRF_IO, pvar_dset_devxLTestVXI_IO
};

int dbTestIoc_registerRecordDeviceDriver(DBBASE *pbase)
{
    static int executed = 0;
    const char *bldTop = "C:/epics/base_3_15_5";
    const char *envTop = getenv("TOP");

    if (envTop && strcmp(envTop, bldTop)) {
        printf("Warning: IOC is booting with TOP = \"%s\"\n"
               "          but was built with TOP = \"%s\"\n",
               envTop, bldTop);
    }

    if (!pbase) {
        printf("pdbbase is NULL; you must load a DBD file first.\n");
        return -1;
    }

    if (executed) {
        printf("Warning: Registration already done.\n");
    }
    executed = 1;

    registerRecordTypes(pbase, NELEMENTS(rtl), recordTypeNames, rtl);
    registerDevices(pbase, NELEMENTS(devsl), deviceSupportNames, devsl);
    return 0;
}

/* dbTestIoc_registerRecordDeviceDriver */
static const iocshArg rrddArg0 = {"pdbbase", iocshArgPdbbase};
static const iocshArg *rrddArgs[] = {&rrddArg0};
static const iocshFuncDef rrddFuncDef =
    {"dbTestIoc_registerRecordDeviceDriver", 1, rrddArgs};
static void rrddCallFunc(const iocshArgBuf *)
{
    dbTestIoc_registerRecordDeviceDriver(*iocshPpdbbase);
}

} // extern "C"

/*
 * Register commands on application startup
 */
static int Registration() {
    iocshRegisterCommon();
    iocshRegister(&rrddFuncDef, rrddCallFunc);
    return 0;
}

static int done EPICS_UNUSED = Registration();
