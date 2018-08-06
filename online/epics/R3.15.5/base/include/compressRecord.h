/* compressRecord.h generated from compressRecord.dbd */

#ifndef INC_compressRecord_H
#define INC_compressRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef enum {
    compressALG_N_to_1_Low_Value    /* N to 1 Low Value */,
    compressALG_N_to_1_High_Value   /* N to 1 High Value */,
    compressALG_N_to_1_Average      /* N to 1 Average */,
    compressALG_Average             /* Average */,
    compressALG_Circular_Buffer     /* Circular Buffer */,
    compressALG_N_to_1_Median       /* N to 1 Median */
} compressALG;
#define compressALG_NUM_CHOICES 6

typedef struct compressRecord {
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
    DBLINK              inp;        /* Input Specification */
    epicsInt16          res;        /* Reset */
    epicsEnum16         alg;        /* Compression Algorithm */
    epicsUInt32         nsam;       /* Number of Values */
    epicsUInt32         n;          /* N to 1 Compression */
    epicsFloat64        ihil;       /* Init High Interest Lim */
    epicsFloat64        ilil;       /* Init Low Interest Lim */
    epicsFloat64        hopr;       /* High Operating Range */
    epicsFloat64        lopr;       /* Low Operating Range */
    epicsInt16          prec;       /* Display Precision */
    char                egu[16];    /* Engineering Units */
    epicsUInt32         off;        /* Offset */
    epicsUInt32         nuse;       /* Number Used */
    epicsUInt32         ouse;       /* Old Number Used */
    double		*bptr;                  /* Buffer Pointer */
    double		*sptr;                  /* Summing Buffer Ptr */
    double		*wptr;                  /* Working Buffer Ptr */
    epicsInt32          inpn;       /* Number of elements in Working Buffer */
    epicsFloat64        cvb;        /* Compress Value Buffer */
    epicsUInt32         inx;        /* Compressed Array Inx */
} compressRecord;

typedef enum {
	compressRecordNAME = 0,
	compressRecordDESC = 1,
	compressRecordASG = 2,
	compressRecordSCAN = 3,
	compressRecordPINI = 4,
	compressRecordPHAS = 5,
	compressRecordEVNT = 6,
	compressRecordTSE = 7,
	compressRecordTSEL = 8,
	compressRecordDTYP = 9,
	compressRecordDISV = 10,
	compressRecordDISA = 11,
	compressRecordSDIS = 12,
	compressRecordMLOK = 13,
	compressRecordMLIS = 14,
	compressRecordDISP = 15,
	compressRecordPROC = 16,
	compressRecordSTAT = 17,
	compressRecordSEVR = 18,
	compressRecordNSTA = 19,
	compressRecordNSEV = 20,
	compressRecordACKS = 21,
	compressRecordACKT = 22,
	compressRecordDISS = 23,
	compressRecordLCNT = 24,
	compressRecordPACT = 25,
	compressRecordPUTF = 26,
	compressRecordRPRO = 27,
	compressRecordASP = 28,
	compressRecordPPN = 29,
	compressRecordPPNR = 30,
	compressRecordSPVT = 31,
	compressRecordRSET = 32,
	compressRecordDSET = 33,
	compressRecordDPVT = 34,
	compressRecordRDES = 35,
	compressRecordLSET = 36,
	compressRecordPRIO = 37,
	compressRecordTPRO = 38,
	compressRecordBKPT = 39,
	compressRecordUDF = 40,
	compressRecordUDFS = 41,
	compressRecordTIME = 42,
	compressRecordFLNK = 43,
	compressRecordVAL = 44,
	compressRecordINP = 45,
	compressRecordRES = 46,
	compressRecordALG = 47,
	compressRecordNSAM = 48,
	compressRecordN = 49,
	compressRecordIHIL = 50,
	compressRecordILIL = 51,
	compressRecordHOPR = 52,
	compressRecordLOPR = 53,
	compressRecordPREC = 54,
	compressRecordEGU = 55,
	compressRecordOFF = 56,
	compressRecordNUSE = 57,
	compressRecordOUSE = 58,
	compressRecordBPTR = 59,
	compressRecordSPTR = 60,
	compressRecordWPTR = 61,
	compressRecordINPN = 62,
	compressRecordCVB = 63,
	compressRecordINX = 64
} compressFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int compressRecordSizeOffset(dbRecordType *prt)
{
    compressRecord *prec = 0;

    assert(prt->no_fields == 65);
    prt->papFldDes[compressRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[compressRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[compressRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[compressRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[compressRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[compressRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[compressRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[compressRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[compressRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[compressRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[compressRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[compressRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[compressRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[compressRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[compressRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[compressRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[compressRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[compressRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[compressRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[compressRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[compressRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[compressRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[compressRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[compressRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[compressRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[compressRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[compressRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[compressRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[compressRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[compressRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[compressRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[compressRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[compressRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[compressRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[compressRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[compressRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[compressRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[compressRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[compressRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[compressRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[compressRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[compressRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[compressRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[compressRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[compressRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[compressRecordINP]->size = sizeof(prec->inp);
    prt->papFldDes[compressRecordRES]->size = sizeof(prec->res);
    prt->papFldDes[compressRecordALG]->size = sizeof(prec->alg);
    prt->papFldDes[compressRecordNSAM]->size = sizeof(prec->nsam);
    prt->papFldDes[compressRecordN]->size = sizeof(prec->n);
    prt->papFldDes[compressRecordIHIL]->size = sizeof(prec->ihil);
    prt->papFldDes[compressRecordILIL]->size = sizeof(prec->ilil);
    prt->papFldDes[compressRecordHOPR]->size = sizeof(prec->hopr);
    prt->papFldDes[compressRecordLOPR]->size = sizeof(prec->lopr);
    prt->papFldDes[compressRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[compressRecordEGU]->size = sizeof(prec->egu);
    prt->papFldDes[compressRecordOFF]->size = sizeof(prec->off);
    prt->papFldDes[compressRecordNUSE]->size = sizeof(prec->nuse);
    prt->papFldDes[compressRecordOUSE]->size = sizeof(prec->ouse);
    prt->papFldDes[compressRecordBPTR]->size = sizeof(prec->bptr);
    prt->papFldDes[compressRecordSPTR]->size = sizeof(prec->sptr);
    prt->papFldDes[compressRecordWPTR]->size = sizeof(prec->wptr);
    prt->papFldDes[compressRecordINPN]->size = sizeof(prec->inpn);
    prt->papFldDes[compressRecordCVB]->size = sizeof(prec->cvb);
    prt->papFldDes[compressRecordINX]->size = sizeof(prec->inx);
    prt->papFldDes[compressRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[compressRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[compressRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[compressRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[compressRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[compressRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[compressRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[compressRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[compressRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[compressRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[compressRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[compressRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[compressRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[compressRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[compressRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[compressRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[compressRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[compressRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[compressRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[compressRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[compressRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[compressRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[compressRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[compressRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[compressRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[compressRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[compressRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[compressRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[compressRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[compressRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[compressRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[compressRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[compressRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[compressRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[compressRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[compressRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[compressRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[compressRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[compressRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[compressRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[compressRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[compressRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[compressRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[compressRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[compressRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[compressRecordINP]->offset = (unsigned short)((char *)&prec->inp - (char *)prec);
    prt->papFldDes[compressRecordRES]->offset = (unsigned short)((char *)&prec->res - (char *)prec);
    prt->papFldDes[compressRecordALG]->offset = (unsigned short)((char *)&prec->alg - (char *)prec);
    prt->papFldDes[compressRecordNSAM]->offset = (unsigned short)((char *)&prec->nsam - (char *)prec);
    prt->papFldDes[compressRecordN]->offset = (unsigned short)((char *)&prec->n - (char *)prec);
    prt->papFldDes[compressRecordIHIL]->offset = (unsigned short)((char *)&prec->ihil - (char *)prec);
    prt->papFldDes[compressRecordILIL]->offset = (unsigned short)((char *)&prec->ilil - (char *)prec);
    prt->papFldDes[compressRecordHOPR]->offset = (unsigned short)((char *)&prec->hopr - (char *)prec);
    prt->papFldDes[compressRecordLOPR]->offset = (unsigned short)((char *)&prec->lopr - (char *)prec);
    prt->papFldDes[compressRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[compressRecordEGU]->offset = (unsigned short)((char *)&prec->egu - (char *)prec);
    prt->papFldDes[compressRecordOFF]->offset = (unsigned short)((char *)&prec->off - (char *)prec);
    prt->papFldDes[compressRecordNUSE]->offset = (unsigned short)((char *)&prec->nuse - (char *)prec);
    prt->papFldDes[compressRecordOUSE]->offset = (unsigned short)((char *)&prec->ouse - (char *)prec);
    prt->papFldDes[compressRecordBPTR]->offset = (unsigned short)((char *)&prec->bptr - (char *)prec);
    prt->papFldDes[compressRecordSPTR]->offset = (unsigned short)((char *)&prec->sptr - (char *)prec);
    prt->papFldDes[compressRecordWPTR]->offset = (unsigned short)((char *)&prec->wptr - (char *)prec);
    prt->papFldDes[compressRecordINPN]->offset = (unsigned short)((char *)&prec->inpn - (char *)prec);
    prt->papFldDes[compressRecordCVB]->offset = (unsigned short)((char *)&prec->cvb - (char *)prec);
    prt->papFldDes[compressRecordINX]->offset = (unsigned short)((char *)&prec->inx - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(compressRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_compressRecord_H */
