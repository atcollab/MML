/* xRecord.h generated from xRecord.dbd */

#ifndef INC_xRecord_H
#define INC_xRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef struct xRecord {
    char                name[61];   /* Record Name */
    char                desc[41];   /* Descriptor */
    char                asg[29];    /* Access Security Group */
    epicsEnum16         scan;       /* Scan Mechanism */
    epicsEnum16         pini;       /* Process at iocInit */
    epicsInt16          phas;       /* Scan Phase */
    char                evnt[40];   /* Event Name */
    epicsInt16          tse;        /* Time Stamp Event */
    DBLINK              tsel;       /* Time Stamp Link */
    epicsEnum16         dtyp;       /* Device Type */
    epicsInt16          disv;       /* Disable Value */
    epicsInt16          disa;       /* Disable */
    DBLINK              sdis;       /* Scanning Disable */
    epicsMutexId        mlok;       /* Monitor lock */
    ELLLIST             mlis;       /* Monitor List */
    epicsUInt8          disp;       /* Disable putField */
    epicsUInt8          proc;       /* Force Processing */
    epicsEnum16         stat;       /* Alarm Status */
    epicsEnum16         sevr;       /* Alarm Severity */
    epicsEnum16         nsta;       /* New Alarm Status */
    epicsEnum16         nsev;       /* New Alarm Severity */
    epicsEnum16         acks;       /* Alarm Ack Severity */
    epicsEnum16         ackt;       /* Alarm Ack Transient */
    epicsEnum16         diss;       /* Disable Alarm Sevrty */
    epicsUInt8          lcnt;       /* Lock Count */
    epicsUInt8          pact;       /* Record active */
    epicsUInt8          putf;       /* dbPutField process */
    epicsUInt8          rpro;       /* Reprocess  */
    struct asgMember    *asp;       /* Access Security Pvt */
    struct processNotify *ppn;      /* pprocessNotify */
    struct processNotifyRecord *ppnr; /* pprocessNotifyRecord */
    struct scan_element *spvt;      /* Scan Private */
    struct rset         *rset;      /* Address of RSET */
    struct dset         *dset;      /* DSET address */
    void                *dpvt;      /* Device Private */
    struct dbRecordType *rdes;      /* Address of dbRecordType */
    struct lockRecord   *lset;      /* Lock Set */
    epicsEnum16         prio;       /* Scheduling Priority */
    epicsUInt8          tpro;       /* Trace Processing */
    char                bkpt;       /* Break Point */
    epicsUInt8          udf;        /* Undefined */
    epicsEnum16         udfs;       /* Undefined Alarm Sevrty */
    epicsTimeStamp      time;       /* Time */
    DBLINK              flnk;       /* Forward Process Link */
    epicsInt32          val;        /* Value */
    DBLINK              lnk;        /* Link */
    DBLINK              inp;        /* Input Link */
} xRecord;

typedef enum {
	xRecordNAME = 0,
	xRecordDESC = 1,
	xRecordASG = 2,
	xRecordSCAN = 3,
	xRecordPINI = 4,
	xRecordPHAS = 5,
	xRecordEVNT = 6,
	xRecordTSE = 7,
	xRecordTSEL = 8,
	xRecordDTYP = 9,
	xRecordDISV = 10,
	xRecordDISA = 11,
	xRecordSDIS = 12,
	xRecordMLOK = 13,
	xRecordMLIS = 14,
	xRecordDISP = 15,
	xRecordPROC = 16,
	xRecordSTAT = 17,
	xRecordSEVR = 18,
	xRecordNSTA = 19,
	xRecordNSEV = 20,
	xRecordACKS = 21,
	xRecordACKT = 22,
	xRecordDISS = 23,
	xRecordLCNT = 24,
	xRecordPACT = 25,
	xRecordPUTF = 26,
	xRecordRPRO = 27,
	xRecordASP = 28,
	xRecordPPN = 29,
	xRecordPPNR = 30,
	xRecordSPVT = 31,
	xRecordRSET = 32,
	xRecordDSET = 33,
	xRecordDPVT = 34,
	xRecordRDES = 35,
	xRecordLSET = 36,
	xRecordPRIO = 37,
	xRecordTPRO = 38,
	xRecordBKPT = 39,
	xRecordUDF = 40,
	xRecordUDFS = 41,
	xRecordTIME = 42,
	xRecordFLNK = 43,
	xRecordVAL = 44,
	xRecordLNK = 45,
	xRecordINP = 46
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

    assert(prt->no_fields == 47);
    prt->papFldDes[xRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[xRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[xRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[xRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[xRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[xRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[xRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[xRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[xRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[xRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[xRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[xRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[xRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[xRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[xRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[xRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[xRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[xRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[xRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[xRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[xRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[xRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[xRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[xRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[xRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[xRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[xRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[xRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[xRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[xRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[xRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[xRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[xRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[xRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[xRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[xRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[xRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[xRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[xRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[xRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[xRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[xRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[xRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[xRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[xRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[xRecordLNK]->size = sizeof(prec->lnk);
    prt->papFldDes[xRecordINP]->size = sizeof(prec->inp);
    prt->papFldDes[xRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[xRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[xRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[xRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[xRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[xRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[xRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[xRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[xRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[xRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[xRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[xRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[xRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[xRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[xRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[xRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[xRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[xRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[xRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[xRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[xRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[xRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[xRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[xRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[xRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[xRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[xRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[xRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[xRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[xRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[xRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[xRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[xRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[xRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[xRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[xRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[xRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[xRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[xRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[xRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[xRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[xRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[xRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[xRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[xRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[xRecordLNK]->offset = (unsigned short)((char *)&prec->lnk - (char *)prec);
    prt->papFldDes[xRecordINP]->offset = (unsigned short)((char *)&prec->inp - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(xRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_xRecord_H */
