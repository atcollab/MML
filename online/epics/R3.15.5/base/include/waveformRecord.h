/* waveformRecord.h generated from waveformRecord.dbd */

#ifndef INC_waveformRecord_H
#define INC_waveformRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef enum {
    waveformPOST_Always             /* Always */,
    waveformPOST_OnChange           /* On Change */
} waveformPOST;
#define waveformPOST_NUM_CHOICES 2

typedef struct waveformRecord {
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
    epicsInt16          rarm;       /* Rearm the waveform */
    epicsInt16          prec;       /* Display Precision */
    DBLINK              inp;        /* Input Specification */
    char                egu[16];    /* Engineering Units */
    epicsFloat64        hopr;       /* High Operating Range */
    epicsFloat64        lopr;       /* Low Operating Range */
    epicsUInt32         nelm;       /* Number of Elements */
    epicsEnum16         ftvl;       /* Field Type of Value */
    epicsInt16          busy;       /* Busy Indicator */
    epicsUInt32         nord;       /* Number elements read */
    void *		bptr;                   /* Buffer Pointer */
    DBLINK              siol;       /* Sim Input Specifctn */
    DBLINK              siml;       /* Sim Mode Location */
    epicsEnum16         simm;       /* Simulation Mode */
    epicsEnum16         sims;       /* Sim mode Alarm Svrty */
    epicsEnum16         mpst;       /* Post Value Monitors */
    epicsEnum16         apst;       /* Post Archive Monitors */
    epicsUInt32         hash;       /* Hash of OnChange data. */
} waveformRecord;

typedef enum {
	waveformRecordNAME = 0,
	waveformRecordDESC = 1,
	waveformRecordASG = 2,
	waveformRecordSCAN = 3,
	waveformRecordPINI = 4,
	waveformRecordPHAS = 5,
	waveformRecordEVNT = 6,
	waveformRecordTSE = 7,
	waveformRecordTSEL = 8,
	waveformRecordDTYP = 9,
	waveformRecordDISV = 10,
	waveformRecordDISA = 11,
	waveformRecordSDIS = 12,
	waveformRecordMLOK = 13,
	waveformRecordMLIS = 14,
	waveformRecordDISP = 15,
	waveformRecordPROC = 16,
	waveformRecordSTAT = 17,
	waveformRecordSEVR = 18,
	waveformRecordNSTA = 19,
	waveformRecordNSEV = 20,
	waveformRecordACKS = 21,
	waveformRecordACKT = 22,
	waveformRecordDISS = 23,
	waveformRecordLCNT = 24,
	waveformRecordPACT = 25,
	waveformRecordPUTF = 26,
	waveformRecordRPRO = 27,
	waveformRecordASP = 28,
	waveformRecordPPN = 29,
	waveformRecordPPNR = 30,
	waveformRecordSPVT = 31,
	waveformRecordRSET = 32,
	waveformRecordDSET = 33,
	waveformRecordDPVT = 34,
	waveformRecordRDES = 35,
	waveformRecordLSET = 36,
	waveformRecordPRIO = 37,
	waveformRecordTPRO = 38,
	waveformRecordBKPT = 39,
	waveformRecordUDF = 40,
	waveformRecordUDFS = 41,
	waveformRecordTIME = 42,
	waveformRecordFLNK = 43,
	waveformRecordVAL = 44,
	waveformRecordRARM = 45,
	waveformRecordPREC = 46,
	waveformRecordINP = 47,
	waveformRecordEGU = 48,
	waveformRecordHOPR = 49,
	waveformRecordLOPR = 50,
	waveformRecordNELM = 51,
	waveformRecordFTVL = 52,
	waveformRecordBUSY = 53,
	waveformRecordNORD = 54,
	waveformRecordBPTR = 55,
	waveformRecordSIOL = 56,
	waveformRecordSIML = 57,
	waveformRecordSIMM = 58,
	waveformRecordSIMS = 59,
	waveformRecordMPST = 60,
	waveformRecordAPST = 61,
	waveformRecordHASH = 62
} waveformFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int waveformRecordSizeOffset(dbRecordType *prt)
{
    waveformRecord *prec = 0;

    assert(prt->no_fields == 63);
    prt->papFldDes[waveformRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[waveformRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[waveformRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[waveformRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[waveformRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[waveformRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[waveformRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[waveformRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[waveformRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[waveformRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[waveformRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[waveformRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[waveformRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[waveformRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[waveformRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[waveformRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[waveformRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[waveformRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[waveformRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[waveformRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[waveformRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[waveformRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[waveformRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[waveformRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[waveformRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[waveformRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[waveformRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[waveformRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[waveformRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[waveformRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[waveformRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[waveformRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[waveformRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[waveformRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[waveformRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[waveformRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[waveformRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[waveformRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[waveformRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[waveformRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[waveformRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[waveformRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[waveformRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[waveformRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[waveformRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[waveformRecordRARM]->size = sizeof(prec->rarm);
    prt->papFldDes[waveformRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[waveformRecordINP]->size = sizeof(prec->inp);
    prt->papFldDes[waveformRecordEGU]->size = sizeof(prec->egu);
    prt->papFldDes[waveformRecordHOPR]->size = sizeof(prec->hopr);
    prt->papFldDes[waveformRecordLOPR]->size = sizeof(prec->lopr);
    prt->papFldDes[waveformRecordNELM]->size = sizeof(prec->nelm);
    prt->papFldDes[waveformRecordFTVL]->size = sizeof(prec->ftvl);
    prt->papFldDes[waveformRecordBUSY]->size = sizeof(prec->busy);
    prt->papFldDes[waveformRecordNORD]->size = sizeof(prec->nord);
    prt->papFldDes[waveformRecordBPTR]->size = sizeof(prec->bptr);
    prt->papFldDes[waveformRecordSIOL]->size = sizeof(prec->siol);
    prt->papFldDes[waveformRecordSIML]->size = sizeof(prec->siml);
    prt->papFldDes[waveformRecordSIMM]->size = sizeof(prec->simm);
    prt->papFldDes[waveformRecordSIMS]->size = sizeof(prec->sims);
    prt->papFldDes[waveformRecordMPST]->size = sizeof(prec->mpst);
    prt->papFldDes[waveformRecordAPST]->size = sizeof(prec->apst);
    prt->papFldDes[waveformRecordHASH]->size = sizeof(prec->hash);
    prt->papFldDes[waveformRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[waveformRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[waveformRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[waveformRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[waveformRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[waveformRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[waveformRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[waveformRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[waveformRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[waveformRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[waveformRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[waveformRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[waveformRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[waveformRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[waveformRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[waveformRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[waveformRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[waveformRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[waveformRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[waveformRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[waveformRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[waveformRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[waveformRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[waveformRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[waveformRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[waveformRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[waveformRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[waveformRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[waveformRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[waveformRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[waveformRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[waveformRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[waveformRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[waveformRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[waveformRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[waveformRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[waveformRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[waveformRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[waveformRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[waveformRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[waveformRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[waveformRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[waveformRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[waveformRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[waveformRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[waveformRecordRARM]->offset = (unsigned short)((char *)&prec->rarm - (char *)prec);
    prt->papFldDes[waveformRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[waveformRecordINP]->offset = (unsigned short)((char *)&prec->inp - (char *)prec);
    prt->papFldDes[waveformRecordEGU]->offset = (unsigned short)((char *)&prec->egu - (char *)prec);
    prt->papFldDes[waveformRecordHOPR]->offset = (unsigned short)((char *)&prec->hopr - (char *)prec);
    prt->papFldDes[waveformRecordLOPR]->offset = (unsigned short)((char *)&prec->lopr - (char *)prec);
    prt->papFldDes[waveformRecordNELM]->offset = (unsigned short)((char *)&prec->nelm - (char *)prec);
    prt->papFldDes[waveformRecordFTVL]->offset = (unsigned short)((char *)&prec->ftvl - (char *)prec);
    prt->papFldDes[waveformRecordBUSY]->offset = (unsigned short)((char *)&prec->busy - (char *)prec);
    prt->papFldDes[waveformRecordNORD]->offset = (unsigned short)((char *)&prec->nord - (char *)prec);
    prt->papFldDes[waveformRecordBPTR]->offset = (unsigned short)((char *)&prec->bptr - (char *)prec);
    prt->papFldDes[waveformRecordSIOL]->offset = (unsigned short)((char *)&prec->siol - (char *)prec);
    prt->papFldDes[waveformRecordSIML]->offset = (unsigned short)((char *)&prec->siml - (char *)prec);
    prt->papFldDes[waveformRecordSIMM]->offset = (unsigned short)((char *)&prec->simm - (char *)prec);
    prt->papFldDes[waveformRecordSIMS]->offset = (unsigned short)((char *)&prec->sims - (char *)prec);
    prt->papFldDes[waveformRecordMPST]->offset = (unsigned short)((char *)&prec->mpst - (char *)prec);
    prt->papFldDes[waveformRecordAPST]->offset = (unsigned short)((char *)&prec->apst - (char *)prec);
    prt->papFldDes[waveformRecordHASH]->offset = (unsigned short)((char *)&prec->hash - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(waveformRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_waveformRecord_H */
