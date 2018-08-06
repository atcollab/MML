/* calcRecord.h generated from calcRecord.dbd */

#ifndef INC_calcRecord_H
#define INC_calcRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"
#include "postfix.h"

typedef struct calcRecord {
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
    epicsFloat64        val;        /* Result */
    char                calc[80];   /* Calculation */
    DBLINK              inpa;       /* Input A */
    DBLINK              inpb;       /* Input B */
    DBLINK              inpc;       /* Input C */
    DBLINK              inpd;       /* Input D */
    DBLINK              inpe;       /* Input E */
    DBLINK              inpf;       /* Input F */
    DBLINK              inpg;       /* Input G */
    DBLINK              inph;       /* Input H */
    DBLINK              inpi;       /* Input I */
    DBLINK              inpj;       /* Input J */
    DBLINK              inpk;       /* Input K */
    DBLINK              inpl;       /* Input L */
    char                egu[16];    /* Engineering Units */
    epicsInt16          prec;       /* Display Precision */
    epicsFloat64        hopr;       /* High Operating Rng */
    epicsFloat64        lopr;       /* Low Operating Range */
    epicsFloat64        hihi;       /* Hihi Alarm Limit */
    epicsFloat64        lolo;       /* Lolo Alarm Limit */
    epicsFloat64        high;       /* High Alarm Limit */
    epicsFloat64        low;        /* Low Alarm Limit */
    epicsEnum16         hhsv;       /* Hihi Severity */
    epicsEnum16         llsv;       /* Lolo Severity */
    epicsEnum16         hsv;        /* High Severity */
    epicsEnum16         lsv;        /* Low Severity */
    epicsFloat64        aftc;       /* Alarm Filter Time Constant */
    epicsFloat64        afvl;       /* Alarm Filter Value */
    epicsFloat64        hyst;       /* Alarm Deadband */
    epicsFloat64        adel;       /* Archive Deadband */
    epicsFloat64        mdel;       /* Monitor Deadband */
    epicsFloat64        a;          /* Value of Input A */
    epicsFloat64        b;          /* Value of Input B */
    epicsFloat64        c;          /* Value of Input C */
    epicsFloat64        d;          /* Value of Input D */
    epicsFloat64        e;          /* Value of Input E */
    epicsFloat64        f;          /* Value of Input F */
    epicsFloat64        g;          /* Value of Input G */
    epicsFloat64        h;          /* Value of Input H */
    epicsFloat64        i;          /* Value of Input I */
    epicsFloat64        j;          /* Value of Input J */
    epicsFloat64        k;          /* Value of Input K */
    epicsFloat64        l;          /* Value of Input L */
    epicsFloat64        la;         /* Prev Value of A */
    epicsFloat64        lb;         /* Prev Value of B */
    epicsFloat64        lc;         /* Prev Value of C */
    epicsFloat64        ld;         /* Prev Value of D */
    epicsFloat64        le;         /* Prev Value of E */
    epicsFloat64        lf;         /* Prev Value of F */
    epicsFloat64        lg;         /* Prev Value of G */
    epicsFloat64        lh;         /* Prev Value of H */
    epicsFloat64        li;         /* Prev Value of I */
    epicsFloat64        lj;         /* Prev Value of J */
    epicsFloat64        lk;         /* Prev Value of K */
    epicsFloat64        ll;         /* Prev Value of L */
    epicsFloat64        lalm;       /* Last Value Alarmed */
    epicsFloat64        alst;       /* Last Value Archived */
    epicsFloat64        mlst;       /* Last Val Monitored */
    char	rpcl[INFIX_TO_POSTFIX_SIZE(80)]; /* Reverse Polish Calc */
} calcRecord;

typedef enum {
	calcRecordNAME = 0,
	calcRecordDESC = 1,
	calcRecordASG = 2,
	calcRecordSCAN = 3,
	calcRecordPINI = 4,
	calcRecordPHAS = 5,
	calcRecordEVNT = 6,
	calcRecordTSE = 7,
	calcRecordTSEL = 8,
	calcRecordDTYP = 9,
	calcRecordDISV = 10,
	calcRecordDISA = 11,
	calcRecordSDIS = 12,
	calcRecordMLOK = 13,
	calcRecordMLIS = 14,
	calcRecordDISP = 15,
	calcRecordPROC = 16,
	calcRecordSTAT = 17,
	calcRecordSEVR = 18,
	calcRecordNSTA = 19,
	calcRecordNSEV = 20,
	calcRecordACKS = 21,
	calcRecordACKT = 22,
	calcRecordDISS = 23,
	calcRecordLCNT = 24,
	calcRecordPACT = 25,
	calcRecordPUTF = 26,
	calcRecordRPRO = 27,
	calcRecordASP = 28,
	calcRecordPPN = 29,
	calcRecordPPNR = 30,
	calcRecordSPVT = 31,
	calcRecordRSET = 32,
	calcRecordDSET = 33,
	calcRecordDPVT = 34,
	calcRecordRDES = 35,
	calcRecordLSET = 36,
	calcRecordPRIO = 37,
	calcRecordTPRO = 38,
	calcRecordBKPT = 39,
	calcRecordUDF = 40,
	calcRecordUDFS = 41,
	calcRecordTIME = 42,
	calcRecordFLNK = 43,
	calcRecordVAL = 44,
	calcRecordCALC = 45,
	calcRecordINPA = 46,
	calcRecordINPB = 47,
	calcRecordINPC = 48,
	calcRecordINPD = 49,
	calcRecordINPE = 50,
	calcRecordINPF = 51,
	calcRecordINPG = 52,
	calcRecordINPH = 53,
	calcRecordINPI = 54,
	calcRecordINPJ = 55,
	calcRecordINPK = 56,
	calcRecordINPL = 57,
	calcRecordEGU = 58,
	calcRecordPREC = 59,
	calcRecordHOPR = 60,
	calcRecordLOPR = 61,
	calcRecordHIHI = 62,
	calcRecordLOLO = 63,
	calcRecordHIGH = 64,
	calcRecordLOW = 65,
	calcRecordHHSV = 66,
	calcRecordLLSV = 67,
	calcRecordHSV = 68,
	calcRecordLSV = 69,
	calcRecordAFTC = 70,
	calcRecordAFVL = 71,
	calcRecordHYST = 72,
	calcRecordADEL = 73,
	calcRecordMDEL = 74,
	calcRecordA = 75,
	calcRecordB = 76,
	calcRecordC = 77,
	calcRecordD = 78,
	calcRecordE = 79,
	calcRecordF = 80,
	calcRecordG = 81,
	calcRecordH = 82,
	calcRecordI = 83,
	calcRecordJ = 84,
	calcRecordK = 85,
	calcRecordL = 86,
	calcRecordLA = 87,
	calcRecordLB = 88,
	calcRecordLC = 89,
	calcRecordLD = 90,
	calcRecordLE = 91,
	calcRecordLF = 92,
	calcRecordLG = 93,
	calcRecordLH = 94,
	calcRecordLI = 95,
	calcRecordLJ = 96,
	calcRecordLK = 97,
	calcRecordLL = 98,
	calcRecordLALM = 99,
	calcRecordALST = 100,
	calcRecordMLST = 101,
	calcRecordRPCL = 102
} calcFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int calcRecordSizeOffset(dbRecordType *prt)
{
    calcRecord *prec = 0;

    assert(prt->no_fields == 103);
    prt->papFldDes[calcRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[calcRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[calcRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[calcRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[calcRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[calcRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[calcRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[calcRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[calcRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[calcRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[calcRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[calcRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[calcRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[calcRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[calcRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[calcRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[calcRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[calcRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[calcRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[calcRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[calcRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[calcRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[calcRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[calcRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[calcRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[calcRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[calcRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[calcRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[calcRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[calcRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[calcRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[calcRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[calcRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[calcRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[calcRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[calcRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[calcRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[calcRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[calcRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[calcRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[calcRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[calcRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[calcRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[calcRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[calcRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[calcRecordCALC]->size = sizeof(prec->calc);
    prt->papFldDes[calcRecordINPA]->size = sizeof(prec->inpa);
    prt->papFldDes[calcRecordINPB]->size = sizeof(prec->inpb);
    prt->papFldDes[calcRecordINPC]->size = sizeof(prec->inpc);
    prt->papFldDes[calcRecordINPD]->size = sizeof(prec->inpd);
    prt->papFldDes[calcRecordINPE]->size = sizeof(prec->inpe);
    prt->papFldDes[calcRecordINPF]->size = sizeof(prec->inpf);
    prt->papFldDes[calcRecordINPG]->size = sizeof(prec->inpg);
    prt->papFldDes[calcRecordINPH]->size = sizeof(prec->inph);
    prt->papFldDes[calcRecordINPI]->size = sizeof(prec->inpi);
    prt->papFldDes[calcRecordINPJ]->size = sizeof(prec->inpj);
    prt->papFldDes[calcRecordINPK]->size = sizeof(prec->inpk);
    prt->papFldDes[calcRecordINPL]->size = sizeof(prec->inpl);
    prt->papFldDes[calcRecordEGU]->size = sizeof(prec->egu);
    prt->papFldDes[calcRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[calcRecordHOPR]->size = sizeof(prec->hopr);
    prt->papFldDes[calcRecordLOPR]->size = sizeof(prec->lopr);
    prt->papFldDes[calcRecordHIHI]->size = sizeof(prec->hihi);
    prt->papFldDes[calcRecordLOLO]->size = sizeof(prec->lolo);
    prt->papFldDes[calcRecordHIGH]->size = sizeof(prec->high);
    prt->papFldDes[calcRecordLOW]->size = sizeof(prec->low);
    prt->papFldDes[calcRecordHHSV]->size = sizeof(prec->hhsv);
    prt->papFldDes[calcRecordLLSV]->size = sizeof(prec->llsv);
    prt->papFldDes[calcRecordHSV]->size = sizeof(prec->hsv);
    prt->papFldDes[calcRecordLSV]->size = sizeof(prec->lsv);
    prt->papFldDes[calcRecordAFTC]->size = sizeof(prec->aftc);
    prt->papFldDes[calcRecordAFVL]->size = sizeof(prec->afvl);
    prt->papFldDes[calcRecordHYST]->size = sizeof(prec->hyst);
    prt->papFldDes[calcRecordADEL]->size = sizeof(prec->adel);
    prt->papFldDes[calcRecordMDEL]->size = sizeof(prec->mdel);
    prt->papFldDes[calcRecordA]->size = sizeof(prec->a);
    prt->papFldDes[calcRecordB]->size = sizeof(prec->b);
    prt->papFldDes[calcRecordC]->size = sizeof(prec->c);
    prt->papFldDes[calcRecordD]->size = sizeof(prec->d);
    prt->papFldDes[calcRecordE]->size = sizeof(prec->e);
    prt->papFldDes[calcRecordF]->size = sizeof(prec->f);
    prt->papFldDes[calcRecordG]->size = sizeof(prec->g);
    prt->papFldDes[calcRecordH]->size = sizeof(prec->h);
    prt->papFldDes[calcRecordI]->size = sizeof(prec->i);
    prt->papFldDes[calcRecordJ]->size = sizeof(prec->j);
    prt->papFldDes[calcRecordK]->size = sizeof(prec->k);
    prt->papFldDes[calcRecordL]->size = sizeof(prec->l);
    prt->papFldDes[calcRecordLA]->size = sizeof(prec->la);
    prt->papFldDes[calcRecordLB]->size = sizeof(prec->lb);
    prt->papFldDes[calcRecordLC]->size = sizeof(prec->lc);
    prt->papFldDes[calcRecordLD]->size = sizeof(prec->ld);
    prt->papFldDes[calcRecordLE]->size = sizeof(prec->le);
    prt->papFldDes[calcRecordLF]->size = sizeof(prec->lf);
    prt->papFldDes[calcRecordLG]->size = sizeof(prec->lg);
    prt->papFldDes[calcRecordLH]->size = sizeof(prec->lh);
    prt->papFldDes[calcRecordLI]->size = sizeof(prec->li);
    prt->papFldDes[calcRecordLJ]->size = sizeof(prec->lj);
    prt->papFldDes[calcRecordLK]->size = sizeof(prec->lk);
    prt->papFldDes[calcRecordLL]->size = sizeof(prec->ll);
    prt->papFldDes[calcRecordLALM]->size = sizeof(prec->lalm);
    prt->papFldDes[calcRecordALST]->size = sizeof(prec->alst);
    prt->papFldDes[calcRecordMLST]->size = sizeof(prec->mlst);
    prt->papFldDes[calcRecordRPCL]->size = sizeof(prec->rpcl);
    prt->papFldDes[calcRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[calcRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[calcRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[calcRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[calcRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[calcRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[calcRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[calcRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[calcRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[calcRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[calcRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[calcRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[calcRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[calcRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[calcRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[calcRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[calcRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[calcRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[calcRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[calcRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[calcRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[calcRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[calcRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[calcRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[calcRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[calcRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[calcRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[calcRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[calcRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[calcRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[calcRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[calcRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[calcRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[calcRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[calcRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[calcRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[calcRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[calcRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[calcRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[calcRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[calcRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[calcRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[calcRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[calcRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[calcRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[calcRecordCALC]->offset = (unsigned short)((char *)&prec->calc - (char *)prec);
    prt->papFldDes[calcRecordINPA]->offset = (unsigned short)((char *)&prec->inpa - (char *)prec);
    prt->papFldDes[calcRecordINPB]->offset = (unsigned short)((char *)&prec->inpb - (char *)prec);
    prt->papFldDes[calcRecordINPC]->offset = (unsigned short)((char *)&prec->inpc - (char *)prec);
    prt->papFldDes[calcRecordINPD]->offset = (unsigned short)((char *)&prec->inpd - (char *)prec);
    prt->papFldDes[calcRecordINPE]->offset = (unsigned short)((char *)&prec->inpe - (char *)prec);
    prt->papFldDes[calcRecordINPF]->offset = (unsigned short)((char *)&prec->inpf - (char *)prec);
    prt->papFldDes[calcRecordINPG]->offset = (unsigned short)((char *)&prec->inpg - (char *)prec);
    prt->papFldDes[calcRecordINPH]->offset = (unsigned short)((char *)&prec->inph - (char *)prec);
    prt->papFldDes[calcRecordINPI]->offset = (unsigned short)((char *)&prec->inpi - (char *)prec);
    prt->papFldDes[calcRecordINPJ]->offset = (unsigned short)((char *)&prec->inpj - (char *)prec);
    prt->papFldDes[calcRecordINPK]->offset = (unsigned short)((char *)&prec->inpk - (char *)prec);
    prt->papFldDes[calcRecordINPL]->offset = (unsigned short)((char *)&prec->inpl - (char *)prec);
    prt->papFldDes[calcRecordEGU]->offset = (unsigned short)((char *)&prec->egu - (char *)prec);
    prt->papFldDes[calcRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[calcRecordHOPR]->offset = (unsigned short)((char *)&prec->hopr - (char *)prec);
    prt->papFldDes[calcRecordLOPR]->offset = (unsigned short)((char *)&prec->lopr - (char *)prec);
    prt->papFldDes[calcRecordHIHI]->offset = (unsigned short)((char *)&prec->hihi - (char *)prec);
    prt->papFldDes[calcRecordLOLO]->offset = (unsigned short)((char *)&prec->lolo - (char *)prec);
    prt->papFldDes[calcRecordHIGH]->offset = (unsigned short)((char *)&prec->high - (char *)prec);
    prt->papFldDes[calcRecordLOW]->offset = (unsigned short)((char *)&prec->low - (char *)prec);
    prt->papFldDes[calcRecordHHSV]->offset = (unsigned short)((char *)&prec->hhsv - (char *)prec);
    prt->papFldDes[calcRecordLLSV]->offset = (unsigned short)((char *)&prec->llsv - (char *)prec);
    prt->papFldDes[calcRecordHSV]->offset = (unsigned short)((char *)&prec->hsv - (char *)prec);
    prt->papFldDes[calcRecordLSV]->offset = (unsigned short)((char *)&prec->lsv - (char *)prec);
    prt->papFldDes[calcRecordAFTC]->offset = (unsigned short)((char *)&prec->aftc - (char *)prec);
    prt->papFldDes[calcRecordAFVL]->offset = (unsigned short)((char *)&prec->afvl - (char *)prec);
    prt->papFldDes[calcRecordHYST]->offset = (unsigned short)((char *)&prec->hyst - (char *)prec);
    prt->papFldDes[calcRecordADEL]->offset = (unsigned short)((char *)&prec->adel - (char *)prec);
    prt->papFldDes[calcRecordMDEL]->offset = (unsigned short)((char *)&prec->mdel - (char *)prec);
    prt->papFldDes[calcRecordA]->offset = (unsigned short)((char *)&prec->a - (char *)prec);
    prt->papFldDes[calcRecordB]->offset = (unsigned short)((char *)&prec->b - (char *)prec);
    prt->papFldDes[calcRecordC]->offset = (unsigned short)((char *)&prec->c - (char *)prec);
    prt->papFldDes[calcRecordD]->offset = (unsigned short)((char *)&prec->d - (char *)prec);
    prt->papFldDes[calcRecordE]->offset = (unsigned short)((char *)&prec->e - (char *)prec);
    prt->papFldDes[calcRecordF]->offset = (unsigned short)((char *)&prec->f - (char *)prec);
    prt->papFldDes[calcRecordG]->offset = (unsigned short)((char *)&prec->g - (char *)prec);
    prt->papFldDes[calcRecordH]->offset = (unsigned short)((char *)&prec->h - (char *)prec);
    prt->papFldDes[calcRecordI]->offset = (unsigned short)((char *)&prec->i - (char *)prec);
    prt->papFldDes[calcRecordJ]->offset = (unsigned short)((char *)&prec->j - (char *)prec);
    prt->papFldDes[calcRecordK]->offset = (unsigned short)((char *)&prec->k - (char *)prec);
    prt->papFldDes[calcRecordL]->offset = (unsigned short)((char *)&prec->l - (char *)prec);
    prt->papFldDes[calcRecordLA]->offset = (unsigned short)((char *)&prec->la - (char *)prec);
    prt->papFldDes[calcRecordLB]->offset = (unsigned short)((char *)&prec->lb - (char *)prec);
    prt->papFldDes[calcRecordLC]->offset = (unsigned short)((char *)&prec->lc - (char *)prec);
    prt->papFldDes[calcRecordLD]->offset = (unsigned short)((char *)&prec->ld - (char *)prec);
    prt->papFldDes[calcRecordLE]->offset = (unsigned short)((char *)&prec->le - (char *)prec);
    prt->papFldDes[calcRecordLF]->offset = (unsigned short)((char *)&prec->lf - (char *)prec);
    prt->papFldDes[calcRecordLG]->offset = (unsigned short)((char *)&prec->lg - (char *)prec);
    prt->papFldDes[calcRecordLH]->offset = (unsigned short)((char *)&prec->lh - (char *)prec);
    prt->papFldDes[calcRecordLI]->offset = (unsigned short)((char *)&prec->li - (char *)prec);
    prt->papFldDes[calcRecordLJ]->offset = (unsigned short)((char *)&prec->lj - (char *)prec);
    prt->papFldDes[calcRecordLK]->offset = (unsigned short)((char *)&prec->lk - (char *)prec);
    prt->papFldDes[calcRecordLL]->offset = (unsigned short)((char *)&prec->ll - (char *)prec);
    prt->papFldDes[calcRecordLALM]->offset = (unsigned short)((char *)&prec->lalm - (char *)prec);
    prt->papFldDes[calcRecordALST]->offset = (unsigned short)((char *)&prec->alst - (char *)prec);
    prt->papFldDes[calcRecordMLST]->offset = (unsigned short)((char *)&prec->mlst - (char *)prec);
    prt->papFldDes[calcRecordRPCL]->offset = (unsigned short)((char *)&prec->rpcl - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(calcRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_calcRecord_H */
