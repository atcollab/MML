/* mbbiDirectRecord.h generated from mbbiDirectRecord.dbd */

#ifndef INC_mbbiDirectRecord_H
#define INC_mbbiDirectRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef struct mbbiDirectRecord {
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
    epicsUInt16         val;        /* Current Value */
    epicsInt16          nobt;       /* Number of Bits */
    DBLINK              inp;        /* Input Specification */
    epicsUInt32         rval;       /* Raw Value */
    epicsUInt32         oraw;       /* Prev Raw Value */
    epicsUInt32         mask;       /* Hardware Mask */
    epicsUInt16         mlst;       /* Last Value Monitored */
    epicsUInt16         shft;       /* Shift */
    DBLINK              siol;       /* Sim Input Specifctn */
    epicsUInt32         sval;       /* Simulation Value */
    DBLINK              siml;       /* Sim Mode Location */
    epicsEnum16         simm;       /* Simulation Mode */
    epicsEnum16         sims;       /* Sim mode Alarm Svrty */
    epicsUInt8          b0;         /* Bit 0 */
    epicsUInt8          b1;         /* Bit 1 */
    epicsUInt8          b2;         /* Bit 2 */
    epicsUInt8          b3;         /* Bit 3 */
    epicsUInt8          b4;         /* Bit 4 */
    epicsUInt8          b5;         /* Bit 5 */
    epicsUInt8          b6;         /* Bit 6 */
    epicsUInt8          b7;         /* Bit 7 */
    epicsUInt8          b8;         /* Bit 8 */
    epicsUInt8          b9;         /* Bit 9 */
    epicsUInt8          ba;         /* Bit A */
    epicsUInt8          bb;         /* Bit B */
    epicsUInt8          bc;         /* Bit C */
    epicsUInt8          bd;         /* Bit D */
    epicsUInt8          be;         /* Bit E */
    epicsUInt8          bf;         /* Bit F */
} mbbiDirectRecord;

typedef enum {
	mbbiDirectRecordNAME = 0,
	mbbiDirectRecordDESC = 1,
	mbbiDirectRecordASG = 2,
	mbbiDirectRecordSCAN = 3,
	mbbiDirectRecordPINI = 4,
	mbbiDirectRecordPHAS = 5,
	mbbiDirectRecordEVNT = 6,
	mbbiDirectRecordTSE = 7,
	mbbiDirectRecordTSEL = 8,
	mbbiDirectRecordDTYP = 9,
	mbbiDirectRecordDISV = 10,
	mbbiDirectRecordDISA = 11,
	mbbiDirectRecordSDIS = 12,
	mbbiDirectRecordMLOK = 13,
	mbbiDirectRecordMLIS = 14,
	mbbiDirectRecordDISP = 15,
	mbbiDirectRecordPROC = 16,
	mbbiDirectRecordSTAT = 17,
	mbbiDirectRecordSEVR = 18,
	mbbiDirectRecordNSTA = 19,
	mbbiDirectRecordNSEV = 20,
	mbbiDirectRecordACKS = 21,
	mbbiDirectRecordACKT = 22,
	mbbiDirectRecordDISS = 23,
	mbbiDirectRecordLCNT = 24,
	mbbiDirectRecordPACT = 25,
	mbbiDirectRecordPUTF = 26,
	mbbiDirectRecordRPRO = 27,
	mbbiDirectRecordASP = 28,
	mbbiDirectRecordPPN = 29,
	mbbiDirectRecordPPNR = 30,
	mbbiDirectRecordSPVT = 31,
	mbbiDirectRecordRSET = 32,
	mbbiDirectRecordDSET = 33,
	mbbiDirectRecordDPVT = 34,
	mbbiDirectRecordRDES = 35,
	mbbiDirectRecordLSET = 36,
	mbbiDirectRecordPRIO = 37,
	mbbiDirectRecordTPRO = 38,
	mbbiDirectRecordBKPT = 39,
	mbbiDirectRecordUDF = 40,
	mbbiDirectRecordUDFS = 41,
	mbbiDirectRecordTIME = 42,
	mbbiDirectRecordFLNK = 43,
	mbbiDirectRecordVAL = 44,
	mbbiDirectRecordNOBT = 45,
	mbbiDirectRecordINP = 46,
	mbbiDirectRecordRVAL = 47,
	mbbiDirectRecordORAW = 48,
	mbbiDirectRecordMASK = 49,
	mbbiDirectRecordMLST = 50,
	mbbiDirectRecordSHFT = 51,
	mbbiDirectRecordSIOL = 52,
	mbbiDirectRecordSVAL = 53,
	mbbiDirectRecordSIML = 54,
	mbbiDirectRecordSIMM = 55,
	mbbiDirectRecordSIMS = 56,
	mbbiDirectRecordB0 = 57,
	mbbiDirectRecordB1 = 58,
	mbbiDirectRecordB2 = 59,
	mbbiDirectRecordB3 = 60,
	mbbiDirectRecordB4 = 61,
	mbbiDirectRecordB5 = 62,
	mbbiDirectRecordB6 = 63,
	mbbiDirectRecordB7 = 64,
	mbbiDirectRecordB8 = 65,
	mbbiDirectRecordB9 = 66,
	mbbiDirectRecordBA = 67,
	mbbiDirectRecordBB = 68,
	mbbiDirectRecordBC = 69,
	mbbiDirectRecordBD = 70,
	mbbiDirectRecordBE = 71,
	mbbiDirectRecordBF = 72
} mbbiDirectFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int mbbiDirectRecordSizeOffset(dbRecordType *prt)
{
    mbbiDirectRecord *prec = 0;

    assert(prt->no_fields == 73);
    prt->papFldDes[mbbiDirectRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[mbbiDirectRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[mbbiDirectRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[mbbiDirectRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[mbbiDirectRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[mbbiDirectRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[mbbiDirectRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[mbbiDirectRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[mbbiDirectRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[mbbiDirectRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[mbbiDirectRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[mbbiDirectRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[mbbiDirectRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[mbbiDirectRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[mbbiDirectRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[mbbiDirectRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[mbbiDirectRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[mbbiDirectRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[mbbiDirectRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[mbbiDirectRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[mbbiDirectRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[mbbiDirectRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[mbbiDirectRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[mbbiDirectRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[mbbiDirectRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[mbbiDirectRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[mbbiDirectRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[mbbiDirectRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[mbbiDirectRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[mbbiDirectRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[mbbiDirectRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[mbbiDirectRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[mbbiDirectRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[mbbiDirectRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[mbbiDirectRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[mbbiDirectRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[mbbiDirectRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[mbbiDirectRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[mbbiDirectRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[mbbiDirectRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[mbbiDirectRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[mbbiDirectRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[mbbiDirectRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[mbbiDirectRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[mbbiDirectRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[mbbiDirectRecordNOBT]->size = sizeof(prec->nobt);
    prt->papFldDes[mbbiDirectRecordINP]->size = sizeof(prec->inp);
    prt->papFldDes[mbbiDirectRecordRVAL]->size = sizeof(prec->rval);
    prt->papFldDes[mbbiDirectRecordORAW]->size = sizeof(prec->oraw);
    prt->papFldDes[mbbiDirectRecordMASK]->size = sizeof(prec->mask);
    prt->papFldDes[mbbiDirectRecordMLST]->size = sizeof(prec->mlst);
    prt->papFldDes[mbbiDirectRecordSHFT]->size = sizeof(prec->shft);
    prt->papFldDes[mbbiDirectRecordSIOL]->size = sizeof(prec->siol);
    prt->papFldDes[mbbiDirectRecordSVAL]->size = sizeof(prec->sval);
    prt->papFldDes[mbbiDirectRecordSIML]->size = sizeof(prec->siml);
    prt->papFldDes[mbbiDirectRecordSIMM]->size = sizeof(prec->simm);
    prt->papFldDes[mbbiDirectRecordSIMS]->size = sizeof(prec->sims);
    prt->papFldDes[mbbiDirectRecordB0]->size = sizeof(prec->b0);
    prt->papFldDes[mbbiDirectRecordB1]->size = sizeof(prec->b1);
    prt->papFldDes[mbbiDirectRecordB2]->size = sizeof(prec->b2);
    prt->papFldDes[mbbiDirectRecordB3]->size = sizeof(prec->b3);
    prt->papFldDes[mbbiDirectRecordB4]->size = sizeof(prec->b4);
    prt->papFldDes[mbbiDirectRecordB5]->size = sizeof(prec->b5);
    prt->papFldDes[mbbiDirectRecordB6]->size = sizeof(prec->b6);
    prt->papFldDes[mbbiDirectRecordB7]->size = sizeof(prec->b7);
    prt->papFldDes[mbbiDirectRecordB8]->size = sizeof(prec->b8);
    prt->papFldDes[mbbiDirectRecordB9]->size = sizeof(prec->b9);
    prt->papFldDes[mbbiDirectRecordBA]->size = sizeof(prec->ba);
    prt->papFldDes[mbbiDirectRecordBB]->size = sizeof(prec->bb);
    prt->papFldDes[mbbiDirectRecordBC]->size = sizeof(prec->bc);
    prt->papFldDes[mbbiDirectRecordBD]->size = sizeof(prec->bd);
    prt->papFldDes[mbbiDirectRecordBE]->size = sizeof(prec->be);
    prt->papFldDes[mbbiDirectRecordBF]->size = sizeof(prec->bf);
    prt->papFldDes[mbbiDirectRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[mbbiDirectRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[mbbiDirectRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[mbbiDirectRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[mbbiDirectRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[mbbiDirectRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[mbbiDirectRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[mbbiDirectRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[mbbiDirectRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[mbbiDirectRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[mbbiDirectRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[mbbiDirectRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[mbbiDirectRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[mbbiDirectRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[mbbiDirectRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[mbbiDirectRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[mbbiDirectRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[mbbiDirectRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[mbbiDirectRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[mbbiDirectRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[mbbiDirectRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[mbbiDirectRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[mbbiDirectRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[mbbiDirectRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[mbbiDirectRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[mbbiDirectRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[mbbiDirectRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[mbbiDirectRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[mbbiDirectRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[mbbiDirectRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[mbbiDirectRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[mbbiDirectRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[mbbiDirectRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[mbbiDirectRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[mbbiDirectRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[mbbiDirectRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[mbbiDirectRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[mbbiDirectRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[mbbiDirectRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[mbbiDirectRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[mbbiDirectRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[mbbiDirectRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[mbbiDirectRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[mbbiDirectRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[mbbiDirectRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[mbbiDirectRecordNOBT]->offset = (unsigned short)((char *)&prec->nobt - (char *)prec);
    prt->papFldDes[mbbiDirectRecordINP]->offset = (unsigned short)((char *)&prec->inp - (char *)prec);
    prt->papFldDes[mbbiDirectRecordRVAL]->offset = (unsigned short)((char *)&prec->rval - (char *)prec);
    prt->papFldDes[mbbiDirectRecordORAW]->offset = (unsigned short)((char *)&prec->oraw - (char *)prec);
    prt->papFldDes[mbbiDirectRecordMASK]->offset = (unsigned short)((char *)&prec->mask - (char *)prec);
    prt->papFldDes[mbbiDirectRecordMLST]->offset = (unsigned short)((char *)&prec->mlst - (char *)prec);
    prt->papFldDes[mbbiDirectRecordSHFT]->offset = (unsigned short)((char *)&prec->shft - (char *)prec);
    prt->papFldDes[mbbiDirectRecordSIOL]->offset = (unsigned short)((char *)&prec->siol - (char *)prec);
    prt->papFldDes[mbbiDirectRecordSVAL]->offset = (unsigned short)((char *)&prec->sval - (char *)prec);
    prt->papFldDes[mbbiDirectRecordSIML]->offset = (unsigned short)((char *)&prec->siml - (char *)prec);
    prt->papFldDes[mbbiDirectRecordSIMM]->offset = (unsigned short)((char *)&prec->simm - (char *)prec);
    prt->papFldDes[mbbiDirectRecordSIMS]->offset = (unsigned short)((char *)&prec->sims - (char *)prec);
    prt->papFldDes[mbbiDirectRecordB0]->offset = (unsigned short)((char *)&prec->b0 - (char *)prec);
    prt->papFldDes[mbbiDirectRecordB1]->offset = (unsigned short)((char *)&prec->b1 - (char *)prec);
    prt->papFldDes[mbbiDirectRecordB2]->offset = (unsigned short)((char *)&prec->b2 - (char *)prec);
    prt->papFldDes[mbbiDirectRecordB3]->offset = (unsigned short)((char *)&prec->b3 - (char *)prec);
    prt->papFldDes[mbbiDirectRecordB4]->offset = (unsigned short)((char *)&prec->b4 - (char *)prec);
    prt->papFldDes[mbbiDirectRecordB5]->offset = (unsigned short)((char *)&prec->b5 - (char *)prec);
    prt->papFldDes[mbbiDirectRecordB6]->offset = (unsigned short)((char *)&prec->b6 - (char *)prec);
    prt->papFldDes[mbbiDirectRecordB7]->offset = (unsigned short)((char *)&prec->b7 - (char *)prec);
    prt->papFldDes[mbbiDirectRecordB8]->offset = (unsigned short)((char *)&prec->b8 - (char *)prec);
    prt->papFldDes[mbbiDirectRecordB9]->offset = (unsigned short)((char *)&prec->b9 - (char *)prec);
    prt->papFldDes[mbbiDirectRecordBA]->offset = (unsigned short)((char *)&prec->ba - (char *)prec);
    prt->papFldDes[mbbiDirectRecordBB]->offset = (unsigned short)((char *)&prec->bb - (char *)prec);
    prt->papFldDes[mbbiDirectRecordBC]->offset = (unsigned short)((char *)&prec->bc - (char *)prec);
    prt->papFldDes[mbbiDirectRecordBD]->offset = (unsigned short)((char *)&prec->bd - (char *)prec);
    prt->papFldDes[mbbiDirectRecordBE]->offset = (unsigned short)((char *)&prec->be - (char *)prec);
    prt->papFldDes[mbbiDirectRecordBF]->offset = (unsigned short)((char *)&prec->bf - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(mbbiDirectRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_mbbiDirectRecord_H */
