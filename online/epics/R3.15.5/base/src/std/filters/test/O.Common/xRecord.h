/* xRecord.h generated from xRecord.dbd */

#ifndef INC_xRecord_H
#define INC_xRecord_H



typedef struct xRecord {
    char                name[61];   /* Record Name */
    epicsInt32          val;        /* Value */
} xRecord;

typedef enum {
	xRecordNAME = 0,
	xRecordVAL = 1
} xFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int xRecordSizeOffset(dbRecordType *prt)
{
    xRecord *prec = 0;

    assert(prt->no_fields == 2);
    prt->papFldDes[xRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[xRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[xRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[xRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(xRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_xRecord_H */
