/* eventRecord.h generated from eventRecord.dbd */

#ifndef INC_eventRecord_H
#define INC_eventRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"
#include "dbScan.h"

typedef struct eventRecord {
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
    char                val[40];    /* Event Name To Post */
    EVENTPVT epvt;                  /* Event private */
    DBLINK              inp;        /* Input Specification */
    DBLINK              siol;       /* Sim Input Specifctn */
    char                sval[40];   /* Simulation Value */
    DBLINK              siml;       /* Sim Mode Location */
    epicsEnum16         simm;       /* Simulation Mode */
    epicsEnum16         sims;       /* Sim mode Alarm Svrty */
} eventRecord;

typedef enum {
	eventRecordNAME = 0,
	eventRecordDESC = 1,
	eventRecordASG = 2,
	eventRecordSCAN = 3,
	eventRecordPINI = 4,
	eventRecordPHAS = 5,
	eventRecordEVNT = 6,
	eventRecordTSE = 7,
	eventRecordTSEL = 8,
	eventRecordDTYP = 9,
	eventRecordDISV = 10,
	eventRecordDISA = 11,
	eventRecordSDIS = 12,
	eventRecordMLOK = 13,
	eventRecordMLIS = 14,
	eventRecordDISP = 15,
	eventRecordPROC = 16,
	eventRecordSTAT = 17,
	eventRecordSEVR = 18,
	eventRecordNSTA = 19,
	eventRecordNSEV = 20,
	eventRecordACKS = 21,
	eventRecordACKT = 22,
	eventRecordDISS = 23,
	eventRecordLCNT = 24,
	eventRecordPACT = 25,
	eventRecordPUTF = 26,
	eventRecordRPRO = 27,
	eventRecordASP = 28,
	eventRecordPPN = 29,
	eventRecordPPNR = 30,
	eventRecordSPVT = 31,
	eventRecordRSET = 32,
	eventRecordDSET = 33,
	eventRecordDPVT = 34,
	eventRecordRDES = 35,
	eventRecordLSET = 36,
	eventRecordPRIO = 37,
	eventRecordTPRO = 38,
	eventRecordBKPT = 39,
	eventRecordUDF = 40,
	eventRecordUDFS = 41,
	eventRecordTIME = 42,
	eventRecordFLNK = 43,
	eventRecordVAL = 44,
	eventRecordEPVT = 45,
	eventRecordINP = 46,
	eventRecordSIOL = 47,
	eventRecordSVAL = 48,
	eventRecordSIML = 49,
	eventRecordSIMM = 50,
	eventRecordSIMS = 51
} eventFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int eventRecordSizeOffset(dbRecordType *prt)
{
    eventRecord *prec = 0;

    assert(prt->no_fields == 52);
    prt->papFldDes[eventRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[eventRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[eventRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[eventRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[eventRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[eventRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[eventRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[eventRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[eventRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[eventRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[eventRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[eventRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[eventRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[eventRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[eventRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[eventRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[eventRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[eventRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[eventRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[eventRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[eventRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[eventRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[eventRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[eventRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[eventRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[eventRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[eventRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[eventRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[eventRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[eventRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[eventRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[eventRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[eventRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[eventRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[eventRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[eventRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[eventRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[eventRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[eventRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[eventRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[eventRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[eventRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[eventRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[eventRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[eventRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[eventRecordEPVT]->size = sizeof(prec->epvt);
    prt->papFldDes[eventRecordINP]->size = sizeof(prec->inp);
    prt->papFldDes[eventRecordSIOL]->size = sizeof(prec->siol);
    prt->papFldDes[eventRecordSVAL]->size = sizeof(prec->sval);
    prt->papFldDes[eventRecordSIML]->size = sizeof(prec->siml);
    prt->papFldDes[eventRecordSIMM]->size = sizeof(prec->simm);
    prt->papFldDes[eventRecordSIMS]->size = sizeof(prec->sims);
    prt->papFldDes[eventRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[eventRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[eventRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[eventRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[eventRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[eventRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[eventRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[eventRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[eventRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[eventRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[eventRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[eventRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[eventRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[eventRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[eventRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[eventRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[eventRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[eventRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[eventRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[eventRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[eventRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[eventRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[eventRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[eventRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[eventRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[eventRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[eventRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[eventRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[eventRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[eventRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[eventRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[eventRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[eventRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[eventRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[eventRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[eventRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[eventRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[eventRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[eventRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[eventRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[eventRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[eventRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[eventRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[eventRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[eventRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[eventRecordEPVT]->offset = (unsigned short)((char *)&prec->epvt - (char *)prec);
    prt->papFldDes[eventRecordINP]->offset = (unsigned short)((char *)&prec->inp - (char *)prec);
    prt->papFldDes[eventRecordSIOL]->offset = (unsigned short)((char *)&prec->siol - (char *)prec);
    prt->papFldDes[eventRecordSVAL]->offset = (unsigned short)((char *)&prec->sval - (char *)prec);
    prt->papFldDes[eventRecordSIML]->offset = (unsigned short)((char *)&prec->siml - (char *)prec);
    prt->papFldDes[eventRecordSIMM]->offset = (unsigned short)((char *)&prec->simm - (char *)prec);
    prt->papFldDes[eventRecordSIMS]->offset = (unsigned short)((char *)&prec->sims - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(eventRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_eventRecord_H */
