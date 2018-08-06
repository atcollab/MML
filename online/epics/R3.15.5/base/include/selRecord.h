/* selRecord.h generated from selRecord.dbd */

#ifndef INC_selRecord_H
#define INC_selRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef enum {
    selSELM_Specified               /* Specified */,
    selSELM_High_Signal             /* High Signal */,
    selSELM_Low_Signal              /* Low Signal */,
    selSELM_Median_Signal           /* Median Signal */
} selSELM;
#define selSELM_NUM_CHOICES 4

typedef struct selRecord {
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
    epicsEnum16         selm;       /* Select Mechanism */
    epicsUInt16         seln;       /* Index value */
    epicsInt16          prec;       /* Display Precision */
    DBLINK              nvl;        /* Index Value Location */
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
    epicsUInt16         nlst;       /* Last Index Monitored */
} selRecord;

typedef enum {
	selRecordNAME = 0,
	selRecordDESC = 1,
	selRecordASG = 2,
	selRecordSCAN = 3,
	selRecordPINI = 4,
	selRecordPHAS = 5,
	selRecordEVNT = 6,
	selRecordTSE = 7,
	selRecordTSEL = 8,
	selRecordDTYP = 9,
	selRecordDISV = 10,
	selRecordDISA = 11,
	selRecordSDIS = 12,
	selRecordMLOK = 13,
	selRecordMLIS = 14,
	selRecordDISP = 15,
	selRecordPROC = 16,
	selRecordSTAT = 17,
	selRecordSEVR = 18,
	selRecordNSTA = 19,
	selRecordNSEV = 20,
	selRecordACKS = 21,
	selRecordACKT = 22,
	selRecordDISS = 23,
	selRecordLCNT = 24,
	selRecordPACT = 25,
	selRecordPUTF = 26,
	selRecordRPRO = 27,
	selRecordASP = 28,
	selRecordPPN = 29,
	selRecordPPNR = 30,
	selRecordSPVT = 31,
	selRecordRSET = 32,
	selRecordDSET = 33,
	selRecordDPVT = 34,
	selRecordRDES = 35,
	selRecordLSET = 36,
	selRecordPRIO = 37,
	selRecordTPRO = 38,
	selRecordBKPT = 39,
	selRecordUDF = 40,
	selRecordUDFS = 41,
	selRecordTIME = 42,
	selRecordFLNK = 43,
	selRecordVAL = 44,
	selRecordSELM = 45,
	selRecordSELN = 46,
	selRecordPREC = 47,
	selRecordNVL = 48,
	selRecordINPA = 49,
	selRecordINPB = 50,
	selRecordINPC = 51,
	selRecordINPD = 52,
	selRecordINPE = 53,
	selRecordINPF = 54,
	selRecordINPG = 55,
	selRecordINPH = 56,
	selRecordINPI = 57,
	selRecordINPJ = 58,
	selRecordINPK = 59,
	selRecordINPL = 60,
	selRecordEGU = 61,
	selRecordHOPR = 62,
	selRecordLOPR = 63,
	selRecordHIHI = 64,
	selRecordLOLO = 65,
	selRecordHIGH = 66,
	selRecordLOW = 67,
	selRecordHHSV = 68,
	selRecordLLSV = 69,
	selRecordHSV = 70,
	selRecordLSV = 71,
	selRecordHYST = 72,
	selRecordADEL = 73,
	selRecordMDEL = 74,
	selRecordA = 75,
	selRecordB = 76,
	selRecordC = 77,
	selRecordD = 78,
	selRecordE = 79,
	selRecordF = 80,
	selRecordG = 81,
	selRecordH = 82,
	selRecordI = 83,
	selRecordJ = 84,
	selRecordK = 85,
	selRecordL = 86,
	selRecordLA = 87,
	selRecordLB = 88,
	selRecordLC = 89,
	selRecordLD = 90,
	selRecordLE = 91,
	selRecordLF = 92,
	selRecordLG = 93,
	selRecordLH = 94,
	selRecordLI = 95,
	selRecordLJ = 96,
	selRecordLK = 97,
	selRecordLL = 98,
	selRecordLALM = 99,
	selRecordALST = 100,
	selRecordMLST = 101,
	selRecordNLST = 102
} selFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int selRecordSizeOffset(dbRecordType *prt)
{
    selRecord *prec = 0;

    assert(prt->no_fields == 103);
    prt->papFldDes[selRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[selRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[selRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[selRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[selRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[selRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[selRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[selRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[selRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[selRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[selRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[selRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[selRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[selRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[selRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[selRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[selRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[selRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[selRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[selRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[selRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[selRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[selRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[selRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[selRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[selRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[selRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[selRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[selRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[selRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[selRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[selRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[selRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[selRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[selRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[selRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[selRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[selRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[selRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[selRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[selRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[selRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[selRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[selRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[selRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[selRecordSELM]->size = sizeof(prec->selm);
    prt->papFldDes[selRecordSELN]->size = sizeof(prec->seln);
    prt->papFldDes[selRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[selRecordNVL]->size = sizeof(prec->nvl);
    prt->papFldDes[selRecordINPA]->size = sizeof(prec->inpa);
    prt->papFldDes[selRecordINPB]->size = sizeof(prec->inpb);
    prt->papFldDes[selRecordINPC]->size = sizeof(prec->inpc);
    prt->papFldDes[selRecordINPD]->size = sizeof(prec->inpd);
    prt->papFldDes[selRecordINPE]->size = sizeof(prec->inpe);
    prt->papFldDes[selRecordINPF]->size = sizeof(prec->inpf);
    prt->papFldDes[selRecordINPG]->size = sizeof(prec->inpg);
    prt->papFldDes[selRecordINPH]->size = sizeof(prec->inph);
    prt->papFldDes[selRecordINPI]->size = sizeof(prec->inpi);
    prt->papFldDes[selRecordINPJ]->size = sizeof(prec->inpj);
    prt->papFldDes[selRecordINPK]->size = sizeof(prec->inpk);
    prt->papFldDes[selRecordINPL]->size = sizeof(prec->inpl);
    prt->papFldDes[selRecordEGU]->size = sizeof(prec->egu);
    prt->papFldDes[selRecordHOPR]->size = sizeof(prec->hopr);
    prt->papFldDes[selRecordLOPR]->size = sizeof(prec->lopr);
    prt->papFldDes[selRecordHIHI]->size = sizeof(prec->hihi);
    prt->papFldDes[selRecordLOLO]->size = sizeof(prec->lolo);
    prt->papFldDes[selRecordHIGH]->size = sizeof(prec->high);
    prt->papFldDes[selRecordLOW]->size = sizeof(prec->low);
    prt->papFldDes[selRecordHHSV]->size = sizeof(prec->hhsv);
    prt->papFldDes[selRecordLLSV]->size = sizeof(prec->llsv);
    prt->papFldDes[selRecordHSV]->size = sizeof(prec->hsv);
    prt->papFldDes[selRecordLSV]->size = sizeof(prec->lsv);
    prt->papFldDes[selRecordHYST]->size = sizeof(prec->hyst);
    prt->papFldDes[selRecordADEL]->size = sizeof(prec->adel);
    prt->papFldDes[selRecordMDEL]->size = sizeof(prec->mdel);
    prt->papFldDes[selRecordA]->size = sizeof(prec->a);
    prt->papFldDes[selRecordB]->size = sizeof(prec->b);
    prt->papFldDes[selRecordC]->size = sizeof(prec->c);
    prt->papFldDes[selRecordD]->size = sizeof(prec->d);
    prt->papFldDes[selRecordE]->size = sizeof(prec->e);
    prt->papFldDes[selRecordF]->size = sizeof(prec->f);
    prt->papFldDes[selRecordG]->size = sizeof(prec->g);
    prt->papFldDes[selRecordH]->size = sizeof(prec->h);
    prt->papFldDes[selRecordI]->size = sizeof(prec->i);
    prt->papFldDes[selRecordJ]->size = sizeof(prec->j);
    prt->papFldDes[selRecordK]->size = sizeof(prec->k);
    prt->papFldDes[selRecordL]->size = sizeof(prec->l);
    prt->papFldDes[selRecordLA]->size = sizeof(prec->la);
    prt->papFldDes[selRecordLB]->size = sizeof(prec->lb);
    prt->papFldDes[selRecordLC]->size = sizeof(prec->lc);
    prt->papFldDes[selRecordLD]->size = sizeof(prec->ld);
    prt->papFldDes[selRecordLE]->size = sizeof(prec->le);
    prt->papFldDes[selRecordLF]->size = sizeof(prec->lf);
    prt->papFldDes[selRecordLG]->size = sizeof(prec->lg);
    prt->papFldDes[selRecordLH]->size = sizeof(prec->lh);
    prt->papFldDes[selRecordLI]->size = sizeof(prec->li);
    prt->papFldDes[selRecordLJ]->size = sizeof(prec->lj);
    prt->papFldDes[selRecordLK]->size = sizeof(prec->lk);
    prt->papFldDes[selRecordLL]->size = sizeof(prec->ll);
    prt->papFldDes[selRecordLALM]->size = sizeof(prec->lalm);
    prt->papFldDes[selRecordALST]->size = sizeof(prec->alst);
    prt->papFldDes[selRecordMLST]->size = sizeof(prec->mlst);
    prt->papFldDes[selRecordNLST]->size = sizeof(prec->nlst);
    prt->papFldDes[selRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[selRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[selRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[selRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[selRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[selRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[selRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[selRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[selRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[selRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[selRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[selRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[selRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[selRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[selRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[selRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[selRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[selRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[selRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[selRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[selRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[selRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[selRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[selRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[selRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[selRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[selRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[selRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[selRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[selRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[selRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[selRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[selRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[selRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[selRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[selRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[selRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[selRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[selRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[selRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[selRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[selRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[selRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[selRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[selRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[selRecordSELM]->offset = (unsigned short)((char *)&prec->selm - (char *)prec);
    prt->papFldDes[selRecordSELN]->offset = (unsigned short)((char *)&prec->seln - (char *)prec);
    prt->papFldDes[selRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[selRecordNVL]->offset = (unsigned short)((char *)&prec->nvl - (char *)prec);
    prt->papFldDes[selRecordINPA]->offset = (unsigned short)((char *)&prec->inpa - (char *)prec);
    prt->papFldDes[selRecordINPB]->offset = (unsigned short)((char *)&prec->inpb - (char *)prec);
    prt->papFldDes[selRecordINPC]->offset = (unsigned short)((char *)&prec->inpc - (char *)prec);
    prt->papFldDes[selRecordINPD]->offset = (unsigned short)((char *)&prec->inpd - (char *)prec);
    prt->papFldDes[selRecordINPE]->offset = (unsigned short)((char *)&prec->inpe - (char *)prec);
    prt->papFldDes[selRecordINPF]->offset = (unsigned short)((char *)&prec->inpf - (char *)prec);
    prt->papFldDes[selRecordINPG]->offset = (unsigned short)((char *)&prec->inpg - (char *)prec);
    prt->papFldDes[selRecordINPH]->offset = (unsigned short)((char *)&prec->inph - (char *)prec);
    prt->papFldDes[selRecordINPI]->offset = (unsigned short)((char *)&prec->inpi - (char *)prec);
    prt->papFldDes[selRecordINPJ]->offset = (unsigned short)((char *)&prec->inpj - (char *)prec);
    prt->papFldDes[selRecordINPK]->offset = (unsigned short)((char *)&prec->inpk - (char *)prec);
    prt->papFldDes[selRecordINPL]->offset = (unsigned short)((char *)&prec->inpl - (char *)prec);
    prt->papFldDes[selRecordEGU]->offset = (unsigned short)((char *)&prec->egu - (char *)prec);
    prt->papFldDes[selRecordHOPR]->offset = (unsigned short)((char *)&prec->hopr - (char *)prec);
    prt->papFldDes[selRecordLOPR]->offset = (unsigned short)((char *)&prec->lopr - (char *)prec);
    prt->papFldDes[selRecordHIHI]->offset = (unsigned short)((char *)&prec->hihi - (char *)prec);
    prt->papFldDes[selRecordLOLO]->offset = (unsigned short)((char *)&prec->lolo - (char *)prec);
    prt->papFldDes[selRecordHIGH]->offset = (unsigned short)((char *)&prec->high - (char *)prec);
    prt->papFldDes[selRecordLOW]->offset = (unsigned short)((char *)&prec->low - (char *)prec);
    prt->papFldDes[selRecordHHSV]->offset = (unsigned short)((char *)&prec->hhsv - (char *)prec);
    prt->papFldDes[selRecordLLSV]->offset = (unsigned short)((char *)&prec->llsv - (char *)prec);
    prt->papFldDes[selRecordHSV]->offset = (unsigned short)((char *)&prec->hsv - (char *)prec);
    prt->papFldDes[selRecordLSV]->offset = (unsigned short)((char *)&prec->lsv - (char *)prec);
    prt->papFldDes[selRecordHYST]->offset = (unsigned short)((char *)&prec->hyst - (char *)prec);
    prt->papFldDes[selRecordADEL]->offset = (unsigned short)((char *)&prec->adel - (char *)prec);
    prt->papFldDes[selRecordMDEL]->offset = (unsigned short)((char *)&prec->mdel - (char *)prec);
    prt->papFldDes[selRecordA]->offset = (unsigned short)((char *)&prec->a - (char *)prec);
    prt->papFldDes[selRecordB]->offset = (unsigned short)((char *)&prec->b - (char *)prec);
    prt->papFldDes[selRecordC]->offset = (unsigned short)((char *)&prec->c - (char *)prec);
    prt->papFldDes[selRecordD]->offset = (unsigned short)((char *)&prec->d - (char *)prec);
    prt->papFldDes[selRecordE]->offset = (unsigned short)((char *)&prec->e - (char *)prec);
    prt->papFldDes[selRecordF]->offset = (unsigned short)((char *)&prec->f - (char *)prec);
    prt->papFldDes[selRecordG]->offset = (unsigned short)((char *)&prec->g - (char *)prec);
    prt->papFldDes[selRecordH]->offset = (unsigned short)((char *)&prec->h - (char *)prec);
    prt->papFldDes[selRecordI]->offset = (unsigned short)((char *)&prec->i - (char *)prec);
    prt->papFldDes[selRecordJ]->offset = (unsigned short)((char *)&prec->j - (char *)prec);
    prt->papFldDes[selRecordK]->offset = (unsigned short)((char *)&prec->k - (char *)prec);
    prt->papFldDes[selRecordL]->offset = (unsigned short)((char *)&prec->l - (char *)prec);
    prt->papFldDes[selRecordLA]->offset = (unsigned short)((char *)&prec->la - (char *)prec);
    prt->papFldDes[selRecordLB]->offset = (unsigned short)((char *)&prec->lb - (char *)prec);
    prt->papFldDes[selRecordLC]->offset = (unsigned short)((char *)&prec->lc - (char *)prec);
    prt->papFldDes[selRecordLD]->offset = (unsigned short)((char *)&prec->ld - (char *)prec);
    prt->papFldDes[selRecordLE]->offset = (unsigned short)((char *)&prec->le - (char *)prec);
    prt->papFldDes[selRecordLF]->offset = (unsigned short)((char *)&prec->lf - (char *)prec);
    prt->papFldDes[selRecordLG]->offset = (unsigned short)((char *)&prec->lg - (char *)prec);
    prt->papFldDes[selRecordLH]->offset = (unsigned short)((char *)&prec->lh - (char *)prec);
    prt->papFldDes[selRecordLI]->offset = (unsigned short)((char *)&prec->li - (char *)prec);
    prt->papFldDes[selRecordLJ]->offset = (unsigned short)((char *)&prec->lj - (char *)prec);
    prt->papFldDes[selRecordLK]->offset = (unsigned short)((char *)&prec->lk - (char *)prec);
    prt->papFldDes[selRecordLL]->offset = (unsigned short)((char *)&prec->ll - (char *)prec);
    prt->papFldDes[selRecordLALM]->offset = (unsigned short)((char *)&prec->lalm - (char *)prec);
    prt->papFldDes[selRecordALST]->offset = (unsigned short)((char *)&prec->alst - (char *)prec);
    prt->papFldDes[selRecordMLST]->offset = (unsigned short)((char *)&prec->mlst - (char *)prec);
    prt->papFldDes[selRecordNLST]->offset = (unsigned short)((char *)&prec->nlst - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(selRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_selRecord_H */
