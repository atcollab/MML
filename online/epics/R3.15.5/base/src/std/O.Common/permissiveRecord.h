/* permissiveRecord.h generated from permissiveRecord.dbd */

#ifndef INC_permissiveRecord_H
#define INC_permissiveRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef struct permissiveRecord {
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
    char                labl[20];   /* Button Label */
    epicsUInt16         val;        /* Status */
    epicsUInt16         oval;       /* Old Status */
    epicsUInt16         wflg;       /* Wait Flag */
    epicsUInt16         oflg;       /* Old Flag */
} permissiveRecord;

typedef enum {
	permissiveRecordNAME = 0,
	permissiveRecordDESC = 1,
	permissiveRecordASG = 2,
	permissiveRecordSCAN = 3,
	permissiveRecordPINI = 4,
	permissiveRecordPHAS = 5,
	permissiveRecordEVNT = 6,
	permissiveRecordTSE = 7,
	permissiveRecordTSEL = 8,
	permissiveRecordDTYP = 9,
	permissiveRecordDISV = 10,
	permissiveRecordDISA = 11,
	permissiveRecordSDIS = 12,
	permissiveRecordMLOK = 13,
	permissiveRecordMLIS = 14,
	permissiveRecordDISP = 15,
	permissiveRecordPROC = 16,
	permissiveRecordSTAT = 17,
	permissiveRecordSEVR = 18,
	permissiveRecordNSTA = 19,
	permissiveRecordNSEV = 20,
	permissiveRecordACKS = 21,
	permissiveRecordACKT = 22,
	permissiveRecordDISS = 23,
	permissiveRecordLCNT = 24,
	permissiveRecordPACT = 25,
	permissiveRecordPUTF = 26,
	permissiveRecordRPRO = 27,
	permissiveRecordASP = 28,
	permissiveRecordPPN = 29,
	permissiveRecordPPNR = 30,
	permissiveRecordSPVT = 31,
	permissiveRecordRSET = 32,
	permissiveRecordDSET = 33,
	permissiveRecordDPVT = 34,
	permissiveRecordRDES = 35,
	permissiveRecordLSET = 36,
	permissiveRecordPRIO = 37,
	permissiveRecordTPRO = 38,
	permissiveRecordBKPT = 39,
	permissiveRecordUDF = 40,
	permissiveRecordUDFS = 41,
	permissiveRecordTIME = 42,
	permissiveRecordFLNK = 43,
	permissiveRecordLABL = 44,
	permissiveRecordVAL = 45,
	permissiveRecordOVAL = 46,
	permissiveRecordWFLG = 47,
	permissiveRecordOFLG = 48
} permissiveFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int permissiveRecordSizeOffset(dbRecordType *prt)
{
    permissiveRecord *prec = 0;

    assert(prt->no_fields == 49);
    prt->papFldDes[permissiveRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[permissiveRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[permissiveRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[permissiveRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[permissiveRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[permissiveRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[permissiveRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[permissiveRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[permissiveRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[permissiveRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[permissiveRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[permissiveRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[permissiveRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[permissiveRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[permissiveRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[permissiveRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[permissiveRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[permissiveRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[permissiveRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[permissiveRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[permissiveRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[permissiveRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[permissiveRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[permissiveRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[permissiveRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[permissiveRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[permissiveRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[permissiveRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[permissiveRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[permissiveRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[permissiveRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[permissiveRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[permissiveRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[permissiveRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[permissiveRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[permissiveRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[permissiveRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[permissiveRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[permissiveRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[permissiveRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[permissiveRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[permissiveRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[permissiveRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[permissiveRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[permissiveRecordLABL]->size = sizeof(prec->labl);
    prt->papFldDes[permissiveRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[permissiveRecordOVAL]->size = sizeof(prec->oval);
    prt->papFldDes[permissiveRecordWFLG]->size = sizeof(prec->wflg);
    prt->papFldDes[permissiveRecordOFLG]->size = sizeof(prec->oflg);
    prt->papFldDes[permissiveRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[permissiveRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[permissiveRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[permissiveRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[permissiveRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[permissiveRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[permissiveRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[permissiveRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[permissiveRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[permissiveRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[permissiveRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[permissiveRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[permissiveRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[permissiveRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[permissiveRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[permissiveRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[permissiveRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[permissiveRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[permissiveRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[permissiveRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[permissiveRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[permissiveRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[permissiveRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[permissiveRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[permissiveRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[permissiveRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[permissiveRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[permissiveRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[permissiveRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[permissiveRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[permissiveRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[permissiveRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[permissiveRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[permissiveRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[permissiveRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[permissiveRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[permissiveRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[permissiveRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[permissiveRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[permissiveRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[permissiveRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[permissiveRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[permissiveRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[permissiveRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[permissiveRecordLABL]->offset = (unsigned short)((char *)&prec->labl - (char *)prec);
    prt->papFldDes[permissiveRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[permissiveRecordOVAL]->offset = (unsigned short)((char *)&prec->oval - (char *)prec);
    prt->papFldDes[permissiveRecordWFLG]->offset = (unsigned short)((char *)&prec->wflg - (char *)prec);
    prt->papFldDes[permissiveRecordOFLG]->offset = (unsigned short)((char *)&prec->oflg - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(permissiveRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_permissiveRecord_H */
