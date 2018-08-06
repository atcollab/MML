/* aaoRecord.h generated from aaoRecord.dbd */

#ifndef INC_aaoRecord_H
#define INC_aaoRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef enum {
    aaoPOST_Always                  /* Always */,
    aaoPOST_OnChange                /* On Change */
} aaoPOST;
#define aaoPOST_NUM_CHOICES 2

typedef struct aaoRecord {
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
    DBLINK              out;        /* Output Specification */
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
    DBLINK              siol;       /* Sim Output Specifctn */
    epicsEnum16         mpst;       /* Post Value Monitors */
    epicsEnum16         apst;       /* Post Archive Monitors */
    epicsUInt32         hash;       /* Hash of OnChange data. */
} aaoRecord;

typedef enum {
	aaoRecordNAME = 0,
	aaoRecordDESC = 1,
	aaoRecordASG = 2,
	aaoRecordSCAN = 3,
	aaoRecordPINI = 4,
	aaoRecordPHAS = 5,
	aaoRecordEVNT = 6,
	aaoRecordTSE = 7,
	aaoRecordTSEL = 8,
	aaoRecordDTYP = 9,
	aaoRecordDISV = 10,
	aaoRecordDISA = 11,
	aaoRecordSDIS = 12,
	aaoRecordMLOK = 13,
	aaoRecordMLIS = 14,
	aaoRecordDISP = 15,
	aaoRecordPROC = 16,
	aaoRecordSTAT = 17,
	aaoRecordSEVR = 18,
	aaoRecordNSTA = 19,
	aaoRecordNSEV = 20,
	aaoRecordACKS = 21,
	aaoRecordACKT = 22,
	aaoRecordDISS = 23,
	aaoRecordLCNT = 24,
	aaoRecordPACT = 25,
	aaoRecordPUTF = 26,
	aaoRecordRPRO = 27,
	aaoRecordASP = 28,
	aaoRecordPPN = 29,
	aaoRecordPPNR = 30,
	aaoRecordSPVT = 31,
	aaoRecordRSET = 32,
	aaoRecordDSET = 33,
	aaoRecordDPVT = 34,
	aaoRecordRDES = 35,
	aaoRecordLSET = 36,
	aaoRecordPRIO = 37,
	aaoRecordTPRO = 38,
	aaoRecordBKPT = 39,
	aaoRecordUDF = 40,
	aaoRecordUDFS = 41,
	aaoRecordTIME = 42,
	aaoRecordFLNK = 43,
	aaoRecordVAL = 44,
	aaoRecordPREC = 45,
	aaoRecordOUT = 46,
	aaoRecordEGU = 47,
	aaoRecordHOPR = 48,
	aaoRecordLOPR = 49,
	aaoRecordNELM = 50,
	aaoRecordFTVL = 51,
	aaoRecordNORD = 52,
	aaoRecordBPTR = 53,
	aaoRecordSIML = 54,
	aaoRecordSIMM = 55,
	aaoRecordSIMS = 56,
	aaoRecordSIOL = 57,
	aaoRecordMPST = 58,
	aaoRecordAPST = 59,
	aaoRecordHASH = 60
} aaoFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int aaoRecordSizeOffset(dbRecordType *prt)
{
    aaoRecord *prec = 0;

    assert(prt->no_fields == 61);
    prt->papFldDes[aaoRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[aaoRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[aaoRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[aaoRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[aaoRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[aaoRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[aaoRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[aaoRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[aaoRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[aaoRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[aaoRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[aaoRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[aaoRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[aaoRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[aaoRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[aaoRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[aaoRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[aaoRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[aaoRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[aaoRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[aaoRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[aaoRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[aaoRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[aaoRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[aaoRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[aaoRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[aaoRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[aaoRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[aaoRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[aaoRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[aaoRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[aaoRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[aaoRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[aaoRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[aaoRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[aaoRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[aaoRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[aaoRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[aaoRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[aaoRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[aaoRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[aaoRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[aaoRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[aaoRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[aaoRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[aaoRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[aaoRecordOUT]->size = sizeof(prec->out);
    prt->papFldDes[aaoRecordEGU]->size = sizeof(prec->egu);
    prt->papFldDes[aaoRecordHOPR]->size = sizeof(prec->hopr);
    prt->papFldDes[aaoRecordLOPR]->size = sizeof(prec->lopr);
    prt->papFldDes[aaoRecordNELM]->size = sizeof(prec->nelm);
    prt->papFldDes[aaoRecordFTVL]->size = sizeof(prec->ftvl);
    prt->papFldDes[aaoRecordNORD]->size = sizeof(prec->nord);
    prt->papFldDes[aaoRecordBPTR]->size = sizeof(prec->bptr);
    prt->papFldDes[aaoRecordSIML]->size = sizeof(prec->siml);
    prt->papFldDes[aaoRecordSIMM]->size = sizeof(prec->simm);
    prt->papFldDes[aaoRecordSIMS]->size = sizeof(prec->sims);
    prt->papFldDes[aaoRecordSIOL]->size = sizeof(prec->siol);
    prt->papFldDes[aaoRecordMPST]->size = sizeof(prec->mpst);
    prt->papFldDes[aaoRecordAPST]->size = sizeof(prec->apst);
    prt->papFldDes[aaoRecordHASH]->size = sizeof(prec->hash);
    prt->papFldDes[aaoRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[aaoRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[aaoRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[aaoRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[aaoRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[aaoRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[aaoRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[aaoRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[aaoRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[aaoRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[aaoRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[aaoRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[aaoRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[aaoRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[aaoRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[aaoRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[aaoRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[aaoRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[aaoRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[aaoRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[aaoRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[aaoRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[aaoRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[aaoRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[aaoRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[aaoRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[aaoRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[aaoRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[aaoRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[aaoRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[aaoRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[aaoRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[aaoRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[aaoRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[aaoRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[aaoRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[aaoRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[aaoRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[aaoRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[aaoRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[aaoRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[aaoRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[aaoRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[aaoRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[aaoRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[aaoRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[aaoRecordOUT]->offset = (unsigned short)((char *)&prec->out - (char *)prec);
    prt->papFldDes[aaoRecordEGU]->offset = (unsigned short)((char *)&prec->egu - (char *)prec);
    prt->papFldDes[aaoRecordHOPR]->offset = (unsigned short)((char *)&prec->hopr - (char *)prec);
    prt->papFldDes[aaoRecordLOPR]->offset = (unsigned short)((char *)&prec->lopr - (char *)prec);
    prt->papFldDes[aaoRecordNELM]->offset = (unsigned short)((char *)&prec->nelm - (char *)prec);
    prt->papFldDes[aaoRecordFTVL]->offset = (unsigned short)((char *)&prec->ftvl - (char *)prec);
    prt->papFldDes[aaoRecordNORD]->offset = (unsigned short)((char *)&prec->nord - (char *)prec);
    prt->papFldDes[aaoRecordBPTR]->offset = (unsigned short)((char *)&prec->bptr - (char *)prec);
    prt->papFldDes[aaoRecordSIML]->offset = (unsigned short)((char *)&prec->siml - (char *)prec);
    prt->papFldDes[aaoRecordSIMM]->offset = (unsigned short)((char *)&prec->simm - (char *)prec);
    prt->papFldDes[aaoRecordSIMS]->offset = (unsigned short)((char *)&prec->sims - (char *)prec);
    prt->papFldDes[aaoRecordSIOL]->offset = (unsigned short)((char *)&prec->siol - (char *)prec);
    prt->papFldDes[aaoRecordMPST]->offset = (unsigned short)((char *)&prec->mpst - (char *)prec);
    prt->papFldDes[aaoRecordAPST]->offset = (unsigned short)((char *)&prec->apst - (char *)prec);
    prt->papFldDes[aaoRecordHASH]->offset = (unsigned short)((char *)&prec->hash - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(aaoRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_aaoRecord_H */
