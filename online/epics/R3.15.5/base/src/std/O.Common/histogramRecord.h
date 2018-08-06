/* histogramRecord.h generated from histogramRecord.dbd */

#ifndef INC_histogramRecord_H
#define INC_histogramRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef enum {
    histogramCMD_Read               /* Read */,
    histogramCMD_Clear              /* Clear */,
    histogramCMD_Start              /* Start */,
    histogramCMD_Stop               /* Stop */
} histogramCMD;
#define histogramCMD_NUM_CHOICES 4

typedef struct histogramRecord {
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
    void *	val;                     /* Value */
    epicsUInt16         nelm;       /* Num of Array Elements */
    epicsInt16          csta;       /* Collection Status */
    epicsEnum16         cmd;        /* Collection Control */
    epicsFloat64        ulim;       /* Upper Signal Limit */
    epicsFloat64        llim;       /* Lower Signal Limit  */
    epicsFloat64        wdth;       /* Element Width */
    epicsFloat64        sgnl;       /* Signal Value */
    epicsInt16          prec;       /* Display Precision */
    DBLINK              svl;        /* Signal Value Location */
    epicsUInt32 *bptr;              /* Buffer Pointer */
    void *  wdog;                   /* Watchdog callback */
    epicsInt16          mdel;       /* Monitor Count Deadband */
    epicsInt16          mcnt;       /* Counts Since Monitor */
    epicsFloat64        sdel;       /* Monitor Seconds Dband */
    DBLINK              siol;       /* Sim Input Specifctn */
    epicsFloat64        sval;       /* Simulation Value */
    DBLINK              siml;       /* Sim Mode Location */
    epicsEnum16         simm;       /* Simulation Mode */
    epicsEnum16         sims;       /* Sim mode Alarm Svrty */
    epicsUInt32         hopr;       /* High Operating Range */
    epicsUInt32         lopr;       /* Low Operating Range */
} histogramRecord;

typedef enum {
	histogramRecordNAME = 0,
	histogramRecordDESC = 1,
	histogramRecordASG = 2,
	histogramRecordSCAN = 3,
	histogramRecordPINI = 4,
	histogramRecordPHAS = 5,
	histogramRecordEVNT = 6,
	histogramRecordTSE = 7,
	histogramRecordTSEL = 8,
	histogramRecordDTYP = 9,
	histogramRecordDISV = 10,
	histogramRecordDISA = 11,
	histogramRecordSDIS = 12,
	histogramRecordMLOK = 13,
	histogramRecordMLIS = 14,
	histogramRecordDISP = 15,
	histogramRecordPROC = 16,
	histogramRecordSTAT = 17,
	histogramRecordSEVR = 18,
	histogramRecordNSTA = 19,
	histogramRecordNSEV = 20,
	histogramRecordACKS = 21,
	histogramRecordACKT = 22,
	histogramRecordDISS = 23,
	histogramRecordLCNT = 24,
	histogramRecordPACT = 25,
	histogramRecordPUTF = 26,
	histogramRecordRPRO = 27,
	histogramRecordASP = 28,
	histogramRecordPPN = 29,
	histogramRecordPPNR = 30,
	histogramRecordSPVT = 31,
	histogramRecordRSET = 32,
	histogramRecordDSET = 33,
	histogramRecordDPVT = 34,
	histogramRecordRDES = 35,
	histogramRecordLSET = 36,
	histogramRecordPRIO = 37,
	histogramRecordTPRO = 38,
	histogramRecordBKPT = 39,
	histogramRecordUDF = 40,
	histogramRecordUDFS = 41,
	histogramRecordTIME = 42,
	histogramRecordFLNK = 43,
	histogramRecordVAL = 44,
	histogramRecordNELM = 45,
	histogramRecordCSTA = 46,
	histogramRecordCMD = 47,
	histogramRecordULIM = 48,
	histogramRecordLLIM = 49,
	histogramRecordWDTH = 50,
	histogramRecordSGNL = 51,
	histogramRecordPREC = 52,
	histogramRecordSVL = 53,
	histogramRecordBPTR = 54,
	histogramRecordWDOG = 55,
	histogramRecordMDEL = 56,
	histogramRecordMCNT = 57,
	histogramRecordSDEL = 58,
	histogramRecordSIOL = 59,
	histogramRecordSVAL = 60,
	histogramRecordSIML = 61,
	histogramRecordSIMM = 62,
	histogramRecordSIMS = 63,
	histogramRecordHOPR = 64,
	histogramRecordLOPR = 65
} histogramFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int histogramRecordSizeOffset(dbRecordType *prt)
{
    histogramRecord *prec = 0;

    assert(prt->no_fields == 66);
    prt->papFldDes[histogramRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[histogramRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[histogramRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[histogramRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[histogramRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[histogramRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[histogramRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[histogramRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[histogramRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[histogramRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[histogramRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[histogramRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[histogramRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[histogramRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[histogramRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[histogramRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[histogramRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[histogramRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[histogramRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[histogramRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[histogramRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[histogramRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[histogramRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[histogramRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[histogramRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[histogramRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[histogramRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[histogramRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[histogramRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[histogramRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[histogramRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[histogramRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[histogramRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[histogramRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[histogramRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[histogramRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[histogramRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[histogramRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[histogramRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[histogramRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[histogramRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[histogramRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[histogramRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[histogramRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[histogramRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[histogramRecordNELM]->size = sizeof(prec->nelm);
    prt->papFldDes[histogramRecordCSTA]->size = sizeof(prec->csta);
    prt->papFldDes[histogramRecordCMD]->size = sizeof(prec->cmd);
    prt->papFldDes[histogramRecordULIM]->size = sizeof(prec->ulim);
    prt->papFldDes[histogramRecordLLIM]->size = sizeof(prec->llim);
    prt->papFldDes[histogramRecordWDTH]->size = sizeof(prec->wdth);
    prt->papFldDes[histogramRecordSGNL]->size = sizeof(prec->sgnl);
    prt->papFldDes[histogramRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[histogramRecordSVL]->size = sizeof(prec->svl);
    prt->papFldDes[histogramRecordBPTR]->size = sizeof(prec->bptr);
    prt->papFldDes[histogramRecordWDOG]->size = sizeof(prec->wdog);
    prt->papFldDes[histogramRecordMDEL]->size = sizeof(prec->mdel);
    prt->papFldDes[histogramRecordMCNT]->size = sizeof(prec->mcnt);
    prt->papFldDes[histogramRecordSDEL]->size = sizeof(prec->sdel);
    prt->papFldDes[histogramRecordSIOL]->size = sizeof(prec->siol);
    prt->papFldDes[histogramRecordSVAL]->size = sizeof(prec->sval);
    prt->papFldDes[histogramRecordSIML]->size = sizeof(prec->siml);
    prt->papFldDes[histogramRecordSIMM]->size = sizeof(prec->simm);
    prt->papFldDes[histogramRecordSIMS]->size = sizeof(prec->sims);
    prt->papFldDes[histogramRecordHOPR]->size = sizeof(prec->hopr);
    prt->papFldDes[histogramRecordLOPR]->size = sizeof(prec->lopr);
    prt->papFldDes[histogramRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[histogramRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[histogramRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[histogramRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[histogramRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[histogramRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[histogramRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[histogramRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[histogramRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[histogramRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[histogramRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[histogramRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[histogramRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[histogramRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[histogramRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[histogramRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[histogramRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[histogramRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[histogramRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[histogramRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[histogramRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[histogramRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[histogramRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[histogramRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[histogramRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[histogramRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[histogramRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[histogramRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[histogramRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[histogramRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[histogramRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[histogramRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[histogramRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[histogramRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[histogramRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[histogramRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[histogramRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[histogramRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[histogramRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[histogramRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[histogramRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[histogramRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[histogramRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[histogramRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[histogramRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[histogramRecordNELM]->offset = (unsigned short)((char *)&prec->nelm - (char *)prec);
    prt->papFldDes[histogramRecordCSTA]->offset = (unsigned short)((char *)&prec->csta - (char *)prec);
    prt->papFldDes[histogramRecordCMD]->offset = (unsigned short)((char *)&prec->cmd - (char *)prec);
    prt->papFldDes[histogramRecordULIM]->offset = (unsigned short)((char *)&prec->ulim - (char *)prec);
    prt->papFldDes[histogramRecordLLIM]->offset = (unsigned short)((char *)&prec->llim - (char *)prec);
    prt->papFldDes[histogramRecordWDTH]->offset = (unsigned short)((char *)&prec->wdth - (char *)prec);
    prt->papFldDes[histogramRecordSGNL]->offset = (unsigned short)((char *)&prec->sgnl - (char *)prec);
    prt->papFldDes[histogramRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[histogramRecordSVL]->offset = (unsigned short)((char *)&prec->svl - (char *)prec);
    prt->papFldDes[histogramRecordBPTR]->offset = (unsigned short)((char *)&prec->bptr - (char *)prec);
    prt->papFldDes[histogramRecordWDOG]->offset = (unsigned short)((char *)&prec->wdog - (char *)prec);
    prt->papFldDes[histogramRecordMDEL]->offset = (unsigned short)((char *)&prec->mdel - (char *)prec);
    prt->papFldDes[histogramRecordMCNT]->offset = (unsigned short)((char *)&prec->mcnt - (char *)prec);
    prt->papFldDes[histogramRecordSDEL]->offset = (unsigned short)((char *)&prec->sdel - (char *)prec);
    prt->papFldDes[histogramRecordSIOL]->offset = (unsigned short)((char *)&prec->siol - (char *)prec);
    prt->papFldDes[histogramRecordSVAL]->offset = (unsigned short)((char *)&prec->sval - (char *)prec);
    prt->papFldDes[histogramRecordSIML]->offset = (unsigned short)((char *)&prec->siml - (char *)prec);
    prt->papFldDes[histogramRecordSIMM]->offset = (unsigned short)((char *)&prec->simm - (char *)prec);
    prt->papFldDes[histogramRecordSIMS]->offset = (unsigned short)((char *)&prec->sims - (char *)prec);
    prt->papFldDes[histogramRecordHOPR]->offset = (unsigned short)((char *)&prec->hopr - (char *)prec);
    prt->papFldDes[histogramRecordLOPR]->offset = (unsigned short)((char *)&prec->lopr - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(histogramRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_histogramRecord_H */
