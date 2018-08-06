/* lsoRecord.h generated from lsoRecord.dbd */

#ifndef INC_lsoRecord_H
#define INC_lsoRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"
#include "devSup.h"

/* Declare Device Support Entry Table */
typedef struct lsodset {
    long number;
    DEVSUPFUN report;
    DEVSUPFUN init;
    DEVSUPFUN init_record;
    DEVSUPFUN get_ioint_info;
    DEVSUPFUN write_string;
} lsodset;


typedef struct lsoRecord {
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
    char *val;                      /* Current Value */
    char *oval;                     /* Previous Value */
    epicsUInt16         sizv;       /* Size of buffers */
    epicsUInt32         len;        /* Length of VAL */
    epicsUInt32         olen;       /* Length of OVAL */
    DBLINK              dol;        /* Desired Output Link */
    epicsEnum16         ivoa;       /* INVALID Output Action */
    char                ivov[40];   /* INVALID Output Value */
    epicsEnum16         omsl;       /* Output Mode Select */
    DBLINK              out;        /* Output Specification */
    epicsEnum16         mpst;       /* Post Value Monitors */
    epicsEnum16         apst;       /* Post Archive Monitors */
    DBLINK              siml;       /* Sim Mode link */
    epicsEnum16         simm;       /* Simulation Mode */
    epicsEnum16         sims;       /* Sim mode Alarm Svrty */
    DBLINK              siol;       /* Sim Output Specifctn */
} lsoRecord;

typedef enum {
	lsoRecordNAME = 0,
	lsoRecordDESC = 1,
	lsoRecordASG = 2,
	lsoRecordSCAN = 3,
	lsoRecordPINI = 4,
	lsoRecordPHAS = 5,
	lsoRecordEVNT = 6,
	lsoRecordTSE = 7,
	lsoRecordTSEL = 8,
	lsoRecordDTYP = 9,
	lsoRecordDISV = 10,
	lsoRecordDISA = 11,
	lsoRecordSDIS = 12,
	lsoRecordMLOK = 13,
	lsoRecordMLIS = 14,
	lsoRecordDISP = 15,
	lsoRecordPROC = 16,
	lsoRecordSTAT = 17,
	lsoRecordSEVR = 18,
	lsoRecordNSTA = 19,
	lsoRecordNSEV = 20,
	lsoRecordACKS = 21,
	lsoRecordACKT = 22,
	lsoRecordDISS = 23,
	lsoRecordLCNT = 24,
	lsoRecordPACT = 25,
	lsoRecordPUTF = 26,
	lsoRecordRPRO = 27,
	lsoRecordASP = 28,
	lsoRecordPPN = 29,
	lsoRecordPPNR = 30,
	lsoRecordSPVT = 31,
	lsoRecordRSET = 32,
	lsoRecordDSET = 33,
	lsoRecordDPVT = 34,
	lsoRecordRDES = 35,
	lsoRecordLSET = 36,
	lsoRecordPRIO = 37,
	lsoRecordTPRO = 38,
	lsoRecordBKPT = 39,
	lsoRecordUDF = 40,
	lsoRecordUDFS = 41,
	lsoRecordTIME = 42,
	lsoRecordFLNK = 43,
	lsoRecordVAL = 44,
	lsoRecordOVAL = 45,
	lsoRecordSIZV = 46,
	lsoRecordLEN = 47,
	lsoRecordOLEN = 48,
	lsoRecordDOL = 49,
	lsoRecordIVOA = 50,
	lsoRecordIVOV = 51,
	lsoRecordOMSL = 52,
	lsoRecordOUT = 53,
	lsoRecordMPST = 54,
	lsoRecordAPST = 55,
	lsoRecordSIML = 56,
	lsoRecordSIMM = 57,
	lsoRecordSIMS = 58,
	lsoRecordSIOL = 59
} lsoFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int lsoRecordSizeOffset(dbRecordType *prt)
{
    lsoRecord *prec = 0;

    assert(prt->no_fields == 60);
    prt->papFldDes[lsoRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[lsoRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[lsoRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[lsoRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[lsoRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[lsoRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[lsoRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[lsoRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[lsoRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[lsoRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[lsoRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[lsoRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[lsoRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[lsoRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[lsoRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[lsoRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[lsoRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[lsoRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[lsoRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[lsoRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[lsoRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[lsoRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[lsoRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[lsoRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[lsoRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[lsoRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[lsoRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[lsoRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[lsoRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[lsoRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[lsoRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[lsoRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[lsoRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[lsoRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[lsoRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[lsoRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[lsoRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[lsoRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[lsoRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[lsoRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[lsoRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[lsoRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[lsoRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[lsoRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[lsoRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[lsoRecordOVAL]->size = sizeof(prec->oval);
    prt->papFldDes[lsoRecordSIZV]->size = sizeof(prec->sizv);
    prt->papFldDes[lsoRecordLEN]->size = sizeof(prec->len);
    prt->papFldDes[lsoRecordOLEN]->size = sizeof(prec->olen);
    prt->papFldDes[lsoRecordDOL]->size = sizeof(prec->dol);
    prt->papFldDes[lsoRecordIVOA]->size = sizeof(prec->ivoa);
    prt->papFldDes[lsoRecordIVOV]->size = sizeof(prec->ivov);
    prt->papFldDes[lsoRecordOMSL]->size = sizeof(prec->omsl);
    prt->papFldDes[lsoRecordOUT]->size = sizeof(prec->out);
    prt->papFldDes[lsoRecordMPST]->size = sizeof(prec->mpst);
    prt->papFldDes[lsoRecordAPST]->size = sizeof(prec->apst);
    prt->papFldDes[lsoRecordSIML]->size = sizeof(prec->siml);
    prt->papFldDes[lsoRecordSIMM]->size = sizeof(prec->simm);
    prt->papFldDes[lsoRecordSIMS]->size = sizeof(prec->sims);
    prt->papFldDes[lsoRecordSIOL]->size = sizeof(prec->siol);
    prt->papFldDes[lsoRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[lsoRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[lsoRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[lsoRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[lsoRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[lsoRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[lsoRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[lsoRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[lsoRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[lsoRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[lsoRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[lsoRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[lsoRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[lsoRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[lsoRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[lsoRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[lsoRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[lsoRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[lsoRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[lsoRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[lsoRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[lsoRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[lsoRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[lsoRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[lsoRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[lsoRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[lsoRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[lsoRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[lsoRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[lsoRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[lsoRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[lsoRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[lsoRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[lsoRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[lsoRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[lsoRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[lsoRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[lsoRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[lsoRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[lsoRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[lsoRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[lsoRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[lsoRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[lsoRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[lsoRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[lsoRecordOVAL]->offset = (unsigned short)((char *)&prec->oval - (char *)prec);
    prt->papFldDes[lsoRecordSIZV]->offset = (unsigned short)((char *)&prec->sizv - (char *)prec);
    prt->papFldDes[lsoRecordLEN]->offset = (unsigned short)((char *)&prec->len - (char *)prec);
    prt->papFldDes[lsoRecordOLEN]->offset = (unsigned short)((char *)&prec->olen - (char *)prec);
    prt->papFldDes[lsoRecordDOL]->offset = (unsigned short)((char *)&prec->dol - (char *)prec);
    prt->papFldDes[lsoRecordIVOA]->offset = (unsigned short)((char *)&prec->ivoa - (char *)prec);
    prt->papFldDes[lsoRecordIVOV]->offset = (unsigned short)((char *)&prec->ivov - (char *)prec);
    prt->papFldDes[lsoRecordOMSL]->offset = (unsigned short)((char *)&prec->omsl - (char *)prec);
    prt->papFldDes[lsoRecordOUT]->offset = (unsigned short)((char *)&prec->out - (char *)prec);
    prt->papFldDes[lsoRecordMPST]->offset = (unsigned short)((char *)&prec->mpst - (char *)prec);
    prt->papFldDes[lsoRecordAPST]->offset = (unsigned short)((char *)&prec->apst - (char *)prec);
    prt->papFldDes[lsoRecordSIML]->offset = (unsigned short)((char *)&prec->siml - (char *)prec);
    prt->papFldDes[lsoRecordSIMM]->offset = (unsigned short)((char *)&prec->simm - (char *)prec);
    prt->papFldDes[lsoRecordSIMS]->offset = (unsigned short)((char *)&prec->sims - (char *)prec);
    prt->papFldDes[lsoRecordSIOL]->offset = (unsigned short)((char *)&prec->siol - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(lsoRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_lsoRecord_H */
