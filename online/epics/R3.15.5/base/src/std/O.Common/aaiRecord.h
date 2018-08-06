/* aaiRecord.h generated from aaiRecord.dbd */

#ifndef INC_aaiRecord_H
#define INC_aaiRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef enum {
    aaiPOST_Always                  /* Always */,
    aaiPOST_OnChange                /* On Change */
} aaiPOST;
#define aaiPOST_NUM_CHOICES 2

typedef struct aaiRecord {
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
    void *		val;                    /* Value */
    epicsInt16          prec;       /* Display Precision */
    DBLINK              inp;        /* Input Specification */
    char                egu[16];    /* Engineering Units */
    epicsFloat64        hopr;       /* High Operating Range */
    epicsFloat64        lopr;       /* Low Operating Range */
    epicsUInt32         nelm;       /* Number of Elements */
    epicsEnum16         ftvl;       /* Field Type of Value */
    epicsUInt32         nord;       /* Number elements read */
    void *		bptr;                   /* Buffer Pointer */
    DBLINK              siml;       /* Sim Mode Location */
    epicsEnum16         simm;       /* Simulation Mode */
    epicsEnum16         sims;       /* Sim mode Alarm Svrty */
    DBLINK              siol;       /* Sim Input Specifctn */
    epicsEnum16         mpst;       /* Post Value Monitors */
    epicsEnum16         apst;       /* Post Archive Monitors */
    epicsUInt32         hash;       /* Hash of OnChange data. */
} aaiRecord;

typedef enum {
	aaiRecordNAME = 0,
	aaiRecordDESC = 1,
	aaiRecordASG = 2,
	aaiRecordSCAN = 3,
	aaiRecordPINI = 4,
	aaiRecordPHAS = 5,
	aaiRecordEVNT = 6,
	aaiRecordTSE = 7,
	aaiRecordTSEL = 8,
	aaiRecordDTYP = 9,
	aaiRecordDISV = 10,
	aaiRecordDISA = 11,
	aaiRecordSDIS = 12,
	aaiRecordMLOK = 13,
	aaiRecordMLIS = 14,
	aaiRecordDISP = 15,
	aaiRecordPROC = 16,
	aaiRecordSTAT = 17,
	aaiRecordSEVR = 18,
	aaiRecordNSTA = 19,
	aaiRecordNSEV = 20,
	aaiRecordACKS = 21,
	aaiRecordACKT = 22,
	aaiRecordDISS = 23,
	aaiRecordLCNT = 24,
	aaiRecordPACT = 25,
	aaiRecordPUTF = 26,
	aaiRecordRPRO = 27,
	aaiRecordASP = 28,
	aaiRecordPPN = 29,
	aaiRecordPPNR = 30,
	aaiRecordSPVT = 31,
	aaiRecordRSET = 32,
	aaiRecordDSET = 33,
	aaiRecordDPVT = 34,
	aaiRecordRDES = 35,
	aaiRecordLSET = 36,
	aaiRecordPRIO = 37,
	aaiRecordTPRO = 38,
	aaiRecordBKPT = 39,
	aaiRecordUDF = 40,
	aaiRecordUDFS = 41,
	aaiRecordTIME = 42,
	aaiRecordFLNK = 43,
	aaiRecordVAL = 44,
	aaiRecordPREC = 45,
	aaiRecordINP = 46,
	aaiRecordEGU = 47,
	aaiRecordHOPR = 48,
	aaiRecordLOPR = 49,
	aaiRecordNELM = 50,
	aaiRecordFTVL = 51,
	aaiRecordNORD = 52,
	aaiRecordBPTR = 53,
	aaiRecordSIML = 54,
	aaiRecordSIMM = 55,
	aaiRecordSIMS = 56,
	aaiRecordSIOL = 57,
	aaiRecordMPST = 58,
	aaiRecordAPST = 59,
	aaiRecordHASH = 60
} aaiFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int aaiRecordSizeOffset(dbRecordType *prt)
{
    aaiRecord *prec = 0;

    assert(prt->no_fields == 61);
    prt->papFldDes[aaiRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[aaiRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[aaiRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[aaiRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[aaiRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[aaiRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[aaiRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[aaiRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[aaiRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[aaiRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[aaiRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[aaiRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[aaiRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[aaiRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[aaiRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[aaiRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[aaiRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[aaiRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[aaiRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[aaiRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[aaiRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[aaiRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[aaiRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[aaiRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[aaiRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[aaiRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[aaiRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[aaiRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[aaiRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[aaiRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[aaiRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[aaiRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[aaiRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[aaiRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[aaiRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[aaiRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[aaiRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[aaiRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[aaiRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[aaiRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[aaiRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[aaiRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[aaiRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[aaiRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[aaiRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[aaiRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[aaiRecordINP]->size = sizeof(prec->inp);
    prt->papFldDes[aaiRecordEGU]->size = sizeof(prec->egu);
    prt->papFldDes[aaiRecordHOPR]->size = sizeof(prec->hopr);
    prt->papFldDes[aaiRecordLOPR]->size = sizeof(prec->lopr);
    prt->papFldDes[aaiRecordNELM]->size = sizeof(prec->nelm);
    prt->papFldDes[aaiRecordFTVL]->size = sizeof(prec->ftvl);
    prt->papFldDes[aaiRecordNORD]->size = sizeof(prec->nord);
    prt->papFldDes[aaiRecordBPTR]->size = sizeof(prec->bptr);
    prt->papFldDes[aaiRecordSIML]->size = sizeof(prec->siml);
    prt->papFldDes[aaiRecordSIMM]->size = sizeof(prec->simm);
    prt->papFldDes[aaiRecordSIMS]->size = sizeof(prec->sims);
    prt->papFldDes[aaiRecordSIOL]->size = sizeof(prec->siol);
    prt->papFldDes[aaiRecordMPST]->size = sizeof(prec->mpst);
    prt->papFldDes[aaiRecordAPST]->size = sizeof(prec->apst);
    prt->papFldDes[aaiRecordHASH]->size = sizeof(prec->hash);
    prt->papFldDes[aaiRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[aaiRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[aaiRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[aaiRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[aaiRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[aaiRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[aaiRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[aaiRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[aaiRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[aaiRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[aaiRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[aaiRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[aaiRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[aaiRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[aaiRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[aaiRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[aaiRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[aaiRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[aaiRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[aaiRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[aaiRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[aaiRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[aaiRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[aaiRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[aaiRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[aaiRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[aaiRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[aaiRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[aaiRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[aaiRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[aaiRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[aaiRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[aaiRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[aaiRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[aaiRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[aaiRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[aaiRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[aaiRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[aaiRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[aaiRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[aaiRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[aaiRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[aaiRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[aaiRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[aaiRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[aaiRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[aaiRecordINP]->offset = (unsigned short)((char *)&prec->inp - (char *)prec);
    prt->papFldDes[aaiRecordEGU]->offset = (unsigned short)((char *)&prec->egu - (char *)prec);
    prt->papFldDes[aaiRecordHOPR]->offset = (unsigned short)((char *)&prec->hopr - (char *)prec);
    prt->papFldDes[aaiRecordLOPR]->offset = (unsigned short)((char *)&prec->lopr - (char *)prec);
    prt->papFldDes[aaiRecordNELM]->offset = (unsigned short)((char *)&prec->nelm - (char *)prec);
    prt->papFldDes[aaiRecordFTVL]->offset = (unsigned short)((char *)&prec->ftvl - (char *)prec);
    prt->papFldDes[aaiRecordNORD]->offset = (unsigned short)((char *)&prec->nord - (char *)prec);
    prt->papFldDes[aaiRecordBPTR]->offset = (unsigned short)((char *)&prec->bptr - (char *)prec);
    prt->papFldDes[aaiRecordSIML]->offset = (unsigned short)((char *)&prec->siml - (char *)prec);
    prt->papFldDes[aaiRecordSIMM]->offset = (unsigned short)((char *)&prec->simm - (char *)prec);
    prt->papFldDes[aaiRecordSIMS]->offset = (unsigned short)((char *)&prec->sims - (char *)prec);
    prt->papFldDes[aaiRecordSIOL]->offset = (unsigned short)((char *)&prec->siol - (char *)prec);
    prt->papFldDes[aaiRecordMPST]->offset = (unsigned short)((char *)&prec->mpst - (char *)prec);
    prt->papFldDes[aaiRecordAPST]->offset = (unsigned short)((char *)&prec->apst - (char *)prec);
    prt->papFldDes[aaiRecordHASH]->offset = (unsigned short)((char *)&prec->hash - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(aaiRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_aaiRecord_H */
