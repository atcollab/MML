/* printfRecord.h generated from printfRecord.dbd */

#ifndef INC_printfRecord_H
#define INC_printfRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"
#include "devSup.h"

/* Declare Device Support Entry Table */
typedef struct printfdset {
    long number;
    DEVSUPFUN report;
    DEVSUPFUN init;
    DEVSUPFUN init_record;
    DEVSUPFUN get_ioint_info;
    DEVSUPFUN write_string;
} printfdset;

/* Number of INPx fields defined */
#define PRINTF_NLINKS 10

typedef struct printfRecord {
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
    char *val;                      /* Result */
    epicsUInt16         sizv;       /* Size of VAL buffer */
    epicsUInt32         len;        /* Length of VAL */
    DBLINK              out;        /* Output Specification */
    char                fmt[81];    /* Format String */
    char                ivls[16];   /* Invalid Link String */
    DBLINK              inp0;       /* Input 0 */
    DBLINK              inp1;       /* Input 1 */
    DBLINK              inp2;       /* Input 2 */
    DBLINK              inp3;       /* Input 3 */
    DBLINK              inp4;       /* Input 4 */
    DBLINK              inp5;       /* Input 5 */
    DBLINK              inp6;       /* Input 6 */
    DBLINK              inp7;       /* Input 7 */
    DBLINK              inp8;       /* Input 8 */
    DBLINK              inp9;       /* Input 9 */
} printfRecord;

typedef enum {
	printfRecordNAME = 0,
	printfRecordDESC = 1,
	printfRecordASG = 2,
	printfRecordSCAN = 3,
	printfRecordPINI = 4,
	printfRecordPHAS = 5,
	printfRecordEVNT = 6,
	printfRecordTSE = 7,
	printfRecordTSEL = 8,
	printfRecordDTYP = 9,
	printfRecordDISV = 10,
	printfRecordDISA = 11,
	printfRecordSDIS = 12,
	printfRecordMLOK = 13,
	printfRecordMLIS = 14,
	printfRecordDISP = 15,
	printfRecordPROC = 16,
	printfRecordSTAT = 17,
	printfRecordSEVR = 18,
	printfRecordNSTA = 19,
	printfRecordNSEV = 20,
	printfRecordACKS = 21,
	printfRecordACKT = 22,
	printfRecordDISS = 23,
	printfRecordLCNT = 24,
	printfRecordPACT = 25,
	printfRecordPUTF = 26,
	printfRecordRPRO = 27,
	printfRecordASP = 28,
	printfRecordPPN = 29,
	printfRecordPPNR = 30,
	printfRecordSPVT = 31,
	printfRecordRSET = 32,
	printfRecordDSET = 33,
	printfRecordDPVT = 34,
	printfRecordRDES = 35,
	printfRecordLSET = 36,
	printfRecordPRIO = 37,
	printfRecordTPRO = 38,
	printfRecordBKPT = 39,
	printfRecordUDF = 40,
	printfRecordUDFS = 41,
	printfRecordTIME = 42,
	printfRecordFLNK = 43,
	printfRecordVAL = 44,
	printfRecordSIZV = 45,
	printfRecordLEN = 46,
	printfRecordOUT = 47,
	printfRecordFMT = 48,
	printfRecordIVLS = 49,
	printfRecordINP0 = 50,
	printfRecordINP1 = 51,
	printfRecordINP2 = 52,
	printfRecordINP3 = 53,
	printfRecordINP4 = 54,
	printfRecordINP5 = 55,
	printfRecordINP6 = 56,
	printfRecordINP7 = 57,
	printfRecordINP8 = 58,
	printfRecordINP9 = 59
} printfFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int printfRecordSizeOffset(dbRecordType *prt)
{
    printfRecord *prec = 0;

    assert(prt->no_fields == 60);
    prt->papFldDes[printfRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[printfRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[printfRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[printfRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[printfRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[printfRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[printfRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[printfRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[printfRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[printfRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[printfRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[printfRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[printfRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[printfRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[printfRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[printfRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[printfRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[printfRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[printfRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[printfRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[printfRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[printfRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[printfRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[printfRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[printfRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[printfRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[printfRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[printfRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[printfRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[printfRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[printfRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[printfRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[printfRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[printfRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[printfRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[printfRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[printfRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[printfRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[printfRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[printfRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[printfRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[printfRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[printfRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[printfRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[printfRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[printfRecordSIZV]->size = sizeof(prec->sizv);
    prt->papFldDes[printfRecordLEN]->size = sizeof(prec->len);
    prt->papFldDes[printfRecordOUT]->size = sizeof(prec->out);
    prt->papFldDes[printfRecordFMT]->size = sizeof(prec->fmt);
    prt->papFldDes[printfRecordIVLS]->size = sizeof(prec->ivls);
    prt->papFldDes[printfRecordINP0]->size = sizeof(prec->inp0);
    prt->papFldDes[printfRecordINP1]->size = sizeof(prec->inp1);
    prt->papFldDes[printfRecordINP2]->size = sizeof(prec->inp2);
    prt->papFldDes[printfRecordINP3]->size = sizeof(prec->inp3);
    prt->papFldDes[printfRecordINP4]->size = sizeof(prec->inp4);
    prt->papFldDes[printfRecordINP5]->size = sizeof(prec->inp5);
    prt->papFldDes[printfRecordINP6]->size = sizeof(prec->inp6);
    prt->papFldDes[printfRecordINP7]->size = sizeof(prec->inp7);
    prt->papFldDes[printfRecordINP8]->size = sizeof(prec->inp8);
    prt->papFldDes[printfRecordINP9]->size = sizeof(prec->inp9);
    prt->papFldDes[printfRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[printfRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[printfRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[printfRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[printfRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[printfRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[printfRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[printfRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[printfRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[printfRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[printfRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[printfRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[printfRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[printfRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[printfRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[printfRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[printfRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[printfRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[printfRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[printfRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[printfRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[printfRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[printfRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[printfRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[printfRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[printfRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[printfRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[printfRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[printfRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[printfRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[printfRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[printfRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[printfRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[printfRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[printfRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[printfRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[printfRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[printfRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[printfRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[printfRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[printfRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[printfRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[printfRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[printfRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[printfRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[printfRecordSIZV]->offset = (unsigned short)((char *)&prec->sizv - (char *)prec);
    prt->papFldDes[printfRecordLEN]->offset = (unsigned short)((char *)&prec->len - (char *)prec);
    prt->papFldDes[printfRecordOUT]->offset = (unsigned short)((char *)&prec->out - (char *)prec);
    prt->papFldDes[printfRecordFMT]->offset = (unsigned short)((char *)&prec->fmt - (char *)prec);
    prt->papFldDes[printfRecordIVLS]->offset = (unsigned short)((char *)&prec->ivls - (char *)prec);
    prt->papFldDes[printfRecordINP0]->offset = (unsigned short)((char *)&prec->inp0 - (char *)prec);
    prt->papFldDes[printfRecordINP1]->offset = (unsigned short)((char *)&prec->inp1 - (char *)prec);
    prt->papFldDes[printfRecordINP2]->offset = (unsigned short)((char *)&prec->inp2 - (char *)prec);
    prt->papFldDes[printfRecordINP3]->offset = (unsigned short)((char *)&prec->inp3 - (char *)prec);
    prt->papFldDes[printfRecordINP4]->offset = (unsigned short)((char *)&prec->inp4 - (char *)prec);
    prt->papFldDes[printfRecordINP5]->offset = (unsigned short)((char *)&prec->inp5 - (char *)prec);
    prt->papFldDes[printfRecordINP6]->offset = (unsigned short)((char *)&prec->inp6 - (char *)prec);
    prt->papFldDes[printfRecordINP7]->offset = (unsigned short)((char *)&prec->inp7 - (char *)prec);
    prt->papFldDes[printfRecordINP8]->offset = (unsigned short)((char *)&prec->inp8 - (char *)prec);
    prt->papFldDes[printfRecordINP9]->offset = (unsigned short)((char *)&prec->inp9 - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(printfRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_printfRecord_H */
