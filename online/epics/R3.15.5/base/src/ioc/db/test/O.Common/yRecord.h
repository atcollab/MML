/* yRecord.h generated from yRecord.dbd */

#ifndef INC_yRecord_H
#define INC_yRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef struct yRecord {
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
} yRecord;

typedef enum {
	yRecordNAME = 0,
	yRecordDESC = 1,
	yRecordASG = 2,
	yRecordSCAN = 3,
	yRecordPINI = 4,
	yRecordPHAS = 5,
	yRecordEVNT = 6,
	yRecordTSE = 7,
	yRecordTSEL = 8,
	yRecordDTYP = 9,
	yRecordDISV = 10,
	yRecordDISA = 11,
	yRecordSDIS = 12,
	yRecordMLOK = 13,
	yRecordMLIS = 14,
	yRecordDISP = 15,
	yRecordPROC = 16,
	yRecordSTAT = 17,
	yRecordSEVR = 18,
	yRecordNSTA = 19,
	yRecordNSEV = 20,
	yRecordACKS = 21,
	yRecordACKT = 22,
	yRecordDISS = 23,
	yRecordLCNT = 24,
	yRecordPACT = 25,
	yRecordPUTF = 26,
	yRecordRPRO = 27,
	yRecordASP = 28,
	yRecordPPN = 29,
	yRecordPPNR = 30,
	yRecordSPVT = 31,
	yRecordRSET = 32,
	yRecordDSET = 33,
	yRecordDPVT = 34,
	yRecordRDES = 35,
	yRecordLSET = 36,
	yRecordPRIO = 37,
	yRecordTPRO = 38,
	yRecordBKPT = 39,
	yRecordUDF = 40,
	yRecordUDFS = 41,
	yRecordTIME = 42,
	yRecordFLNK = 43,
	yRecordVAL = 44
} yFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int yRecordSizeOffset(dbRecordType *prt)
{
    yRecord *prec = 0;

    assert(prt->no_fields == 45);
    prt->papFldDes[yRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[yRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[yRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[yRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[yRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[yRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[yRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[yRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[yRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[yRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[yRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[yRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[yRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[yRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[yRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[yRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[yRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[yRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[yRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[yRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[yRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[yRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[yRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[yRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[yRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[yRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[yRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[yRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[yRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[yRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[yRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[yRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[yRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[yRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[yRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[yRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[yRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[yRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[yRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[yRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[yRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[yRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[yRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[yRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[yRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[yRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[yRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[yRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[yRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[yRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[yRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[yRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[yRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[yRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[yRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[yRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[yRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[yRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[yRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[yRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[yRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[yRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[yRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[yRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[yRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[yRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[yRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[yRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[yRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[yRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[yRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[yRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[yRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[yRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[yRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[yRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[yRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[yRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[yRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[yRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[yRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[yRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[yRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[yRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[yRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[yRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[yRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[yRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[yRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[yRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(yRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_yRecord_H */
