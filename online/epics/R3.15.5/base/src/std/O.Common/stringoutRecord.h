/* stringoutRecord.h generated from stringoutRecord.dbd */

#ifndef INC_stringoutRecord_H
#define INC_stringoutRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef enum {
    stringoutPOST_OnChange          /* On Change */,
    stringoutPOST_Always            /* Always */
} stringoutPOST;
#define stringoutPOST_NUM_CHOICES 2

typedef struct stringoutRecord {
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
    char                val[40];    /* Current Value */
    char                oval[40];   /* Previous Value */
    DBLINK              dol;        /* Desired Output Loc */
    epicsEnum16         omsl;       /* Output Mode Select */
    DBLINK              out;        /* Output Specification */
    epicsEnum16         mpst;       /* Post Value Monitors */
    epicsEnum16         apst;       /* Post Archive Monitors */
    DBLINK              siol;       /* Sim Output Specifctn */
    DBLINK              siml;       /* Sim Mode Location */
    epicsEnum16         simm;       /* Simulation Mode */
    epicsEnum16         sims;       /* Sim mode Alarm Svrty */
    epicsEnum16         ivoa;       /* INVALID output action */
    char                ivov[40];   /* INVALID output value */
} stringoutRecord;

typedef enum {
	stringoutRecordNAME = 0,
	stringoutRecordDESC = 1,
	stringoutRecordASG = 2,
	stringoutRecordSCAN = 3,
	stringoutRecordPINI = 4,
	stringoutRecordPHAS = 5,
	stringoutRecordEVNT = 6,
	stringoutRecordTSE = 7,
	stringoutRecordTSEL = 8,
	stringoutRecordDTYP = 9,
	stringoutRecordDISV = 10,
	stringoutRecordDISA = 11,
	stringoutRecordSDIS = 12,
	stringoutRecordMLOK = 13,
	stringoutRecordMLIS = 14,
	stringoutRecordDISP = 15,
	stringoutRecordPROC = 16,
	stringoutRecordSTAT = 17,
	stringoutRecordSEVR = 18,
	stringoutRecordNSTA = 19,
	stringoutRecordNSEV = 20,
	stringoutRecordACKS = 21,
	stringoutRecordACKT = 22,
	stringoutRecordDISS = 23,
	stringoutRecordLCNT = 24,
	stringoutRecordPACT = 25,
	stringoutRecordPUTF = 26,
	stringoutRecordRPRO = 27,
	stringoutRecordASP = 28,
	stringoutRecordPPN = 29,
	stringoutRecordPPNR = 30,
	stringoutRecordSPVT = 31,
	stringoutRecordRSET = 32,
	stringoutRecordDSET = 33,
	stringoutRecordDPVT = 34,
	stringoutRecordRDES = 35,
	stringoutRecordLSET = 36,
	stringoutRecordPRIO = 37,
	stringoutRecordTPRO = 38,
	stringoutRecordBKPT = 39,
	stringoutRecordUDF = 40,
	stringoutRecordUDFS = 41,
	stringoutRecordTIME = 42,
	stringoutRecordFLNK = 43,
	stringoutRecordVAL = 44,
	stringoutRecordOVAL = 45,
	stringoutRecordDOL = 46,
	stringoutRecordOMSL = 47,
	stringoutRecordOUT = 48,
	stringoutRecordMPST = 49,
	stringoutRecordAPST = 50,
	stringoutRecordSIOL = 51,
	stringoutRecordSIML = 52,
	stringoutRecordSIMM = 53,
	stringoutRecordSIMS = 54,
	stringoutRecordIVOA = 55,
	stringoutRecordIVOV = 56
} stringoutFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int stringoutRecordSizeOffset(dbRecordType *prt)
{
    stringoutRecord *prec = 0;

    assert(prt->no_fields == 57);
    prt->papFldDes[stringoutRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[stringoutRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[stringoutRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[stringoutRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[stringoutRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[stringoutRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[stringoutRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[stringoutRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[stringoutRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[stringoutRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[stringoutRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[stringoutRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[stringoutRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[stringoutRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[stringoutRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[stringoutRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[stringoutRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[stringoutRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[stringoutRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[stringoutRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[stringoutRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[stringoutRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[stringoutRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[stringoutRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[stringoutRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[stringoutRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[stringoutRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[stringoutRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[stringoutRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[stringoutRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[stringoutRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[stringoutRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[stringoutRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[stringoutRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[stringoutRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[stringoutRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[stringoutRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[stringoutRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[stringoutRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[stringoutRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[stringoutRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[stringoutRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[stringoutRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[stringoutRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[stringoutRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[stringoutRecordOVAL]->size = sizeof(prec->oval);
    prt->papFldDes[stringoutRecordDOL]->size = sizeof(prec->dol);
    prt->papFldDes[stringoutRecordOMSL]->size = sizeof(prec->omsl);
    prt->papFldDes[stringoutRecordOUT]->size = sizeof(prec->out);
    prt->papFldDes[stringoutRecordMPST]->size = sizeof(prec->mpst);
    prt->papFldDes[stringoutRecordAPST]->size = sizeof(prec->apst);
    prt->papFldDes[stringoutRecordSIOL]->size = sizeof(prec->siol);
    prt->papFldDes[stringoutRecordSIML]->size = sizeof(prec->siml);
    prt->papFldDes[stringoutRecordSIMM]->size = sizeof(prec->simm);
    prt->papFldDes[stringoutRecordSIMS]->size = sizeof(prec->sims);
    prt->papFldDes[stringoutRecordIVOA]->size = sizeof(prec->ivoa);
    prt->papFldDes[stringoutRecordIVOV]->size = sizeof(prec->ivov);
    prt->papFldDes[stringoutRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[stringoutRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[stringoutRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[stringoutRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[stringoutRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[stringoutRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[stringoutRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[stringoutRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[stringoutRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[stringoutRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[stringoutRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[stringoutRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[stringoutRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[stringoutRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[stringoutRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[stringoutRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[stringoutRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[stringoutRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[stringoutRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[stringoutRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[stringoutRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[stringoutRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[stringoutRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[stringoutRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[stringoutRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[stringoutRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[stringoutRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[stringoutRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[stringoutRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[stringoutRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[stringoutRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[stringoutRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[stringoutRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[stringoutRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[stringoutRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[stringoutRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[stringoutRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[stringoutRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[stringoutRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[stringoutRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[stringoutRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[stringoutRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[stringoutRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[stringoutRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[stringoutRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[stringoutRecordOVAL]->offset = (unsigned short)((char *)&prec->oval - (char *)prec);
    prt->papFldDes[stringoutRecordDOL]->offset = (unsigned short)((char *)&prec->dol - (char *)prec);
    prt->papFldDes[stringoutRecordOMSL]->offset = (unsigned short)((char *)&prec->omsl - (char *)prec);
    prt->papFldDes[stringoutRecordOUT]->offset = (unsigned short)((char *)&prec->out - (char *)prec);
    prt->papFldDes[stringoutRecordMPST]->offset = (unsigned short)((char *)&prec->mpst - (char *)prec);
    prt->papFldDes[stringoutRecordAPST]->offset = (unsigned short)((char *)&prec->apst - (char *)prec);
    prt->papFldDes[stringoutRecordSIOL]->offset = (unsigned short)((char *)&prec->siol - (char *)prec);
    prt->papFldDes[stringoutRecordSIML]->offset = (unsigned short)((char *)&prec->siml - (char *)prec);
    prt->papFldDes[stringoutRecordSIMM]->offset = (unsigned short)((char *)&prec->simm - (char *)prec);
    prt->papFldDes[stringoutRecordSIMS]->offset = (unsigned short)((char *)&prec->sims - (char *)prec);
    prt->papFldDes[stringoutRecordIVOA]->offset = (unsigned short)((char *)&prec->ivoa - (char *)prec);
    prt->papFldDes[stringoutRecordIVOV]->offset = (unsigned short)((char *)&prec->ivov - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(stringoutRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_stringoutRecord_H */
