/* stateRecord.h generated from stateRecord.dbd */

#ifndef INC_stateRecord_H
#define INC_stateRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef struct stateRecord {
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
    char                val[20];    /* Value */
    char                oval[20];   /* Prev Value */
} stateRecord;

typedef enum {
	stateRecordNAME = 0,
	stateRecordDESC = 1,
	stateRecordASG = 2,
	stateRecordSCAN = 3,
	stateRecordPINI = 4,
	stateRecordPHAS = 5,
	stateRecordEVNT = 6,
	stateRecordTSE = 7,
	stateRecordTSEL = 8,
	stateRecordDTYP = 9,
	stateRecordDISV = 10,
	stateRecordDISA = 11,
	stateRecordSDIS = 12,
	stateRecordMLOK = 13,
	stateRecordMLIS = 14,
	stateRecordDISP = 15,
	stateRecordPROC = 16,
	stateRecordSTAT = 17,
	stateRecordSEVR = 18,
	stateRecordNSTA = 19,
	stateRecordNSEV = 20,
	stateRecordACKS = 21,
	stateRecordACKT = 22,
	stateRecordDISS = 23,
	stateRecordLCNT = 24,
	stateRecordPACT = 25,
	stateRecordPUTF = 26,
	stateRecordRPRO = 27,
	stateRecordASP = 28,
	stateRecordPPN = 29,
	stateRecordPPNR = 30,
	stateRecordSPVT = 31,
	stateRecordRSET = 32,
	stateRecordDSET = 33,
	stateRecordDPVT = 34,
	stateRecordRDES = 35,
	stateRecordLSET = 36,
	stateRecordPRIO = 37,
	stateRecordTPRO = 38,
	stateRecordBKPT = 39,
	stateRecordUDF = 40,
	stateRecordUDFS = 41,
	stateRecordTIME = 42,
	stateRecordFLNK = 43,
	stateRecordVAL = 44,
	stateRecordOVAL = 45
} stateFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int stateRecordSizeOffset(dbRecordType *prt)
{
    stateRecord *prec = 0;

    assert(prt->no_fields == 46);
    prt->papFldDes[stateRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[stateRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[stateRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[stateRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[stateRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[stateRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[stateRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[stateRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[stateRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[stateRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[stateRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[stateRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[stateRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[stateRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[stateRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[stateRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[stateRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[stateRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[stateRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[stateRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[stateRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[stateRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[stateRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[stateRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[stateRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[stateRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[stateRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[stateRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[stateRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[stateRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[stateRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[stateRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[stateRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[stateRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[stateRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[stateRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[stateRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[stateRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[stateRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[stateRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[stateRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[stateRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[stateRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[stateRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[stateRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[stateRecordOVAL]->size = sizeof(prec->oval);
    prt->papFldDes[stateRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[stateRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[stateRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[stateRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[stateRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[stateRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[stateRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[stateRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[stateRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[stateRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[stateRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[stateRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[stateRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[stateRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[stateRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[stateRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[stateRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[stateRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[stateRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[stateRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[stateRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[stateRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[stateRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[stateRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[stateRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[stateRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[stateRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[stateRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[stateRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[stateRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[stateRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[stateRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[stateRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[stateRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[stateRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[stateRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[stateRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[stateRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[stateRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[stateRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[stateRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[stateRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[stateRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[stateRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[stateRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[stateRecordOVAL]->offset = (unsigned short)((char *)&prec->oval - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(stateRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_stateRecord_H */
