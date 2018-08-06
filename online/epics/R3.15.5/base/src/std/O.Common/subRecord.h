/* subRecord.h generated from subRecord.dbd */

#ifndef INC_subRecord_H
#define INC_subRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"
struct subRecord;
typedef long (*SUBFUNCPTR)(struct subRecord *);

typedef struct subRecord {
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
    char                inam[40];   /* Init Routine Name */
    char                snam[40];   /* Subroutine Name */
    SUBFUNCPTR sadr;                /* Subroutine Address */
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
    epicsFloat64        hopr;       /* High Operating Range */
    epicsFloat64        lopr;       /* Low Operating Range */
    epicsFloat64        hihi;       /* Hihi Alarm Limit */
    epicsFloat64        lolo;       /* Lolo Alarm Limit */
    epicsFloat64        high;       /* High Alarm Limit */
    epicsFloat64        low;        /* Low Alarm Limit */
    epicsInt16          prec;       /* Display Precision */
    epicsEnum16         brsv;       /* Bad Return Severity */
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
    epicsFloat64        mlst;       /* Last Value Monitored */
} subRecord;

typedef enum {
	subRecordNAME = 0,
	subRecordDESC = 1,
	subRecordASG = 2,
	subRecordSCAN = 3,
	subRecordPINI = 4,
	subRecordPHAS = 5,
	subRecordEVNT = 6,
	subRecordTSE = 7,
	subRecordTSEL = 8,
	subRecordDTYP = 9,
	subRecordDISV = 10,
	subRecordDISA = 11,
	subRecordSDIS = 12,
	subRecordMLOK = 13,
	subRecordMLIS = 14,
	subRecordDISP = 15,
	subRecordPROC = 16,
	subRecordSTAT = 17,
	subRecordSEVR = 18,
	subRecordNSTA = 19,
	subRecordNSEV = 20,
	subRecordACKS = 21,
	subRecordACKT = 22,
	subRecordDISS = 23,
	subRecordLCNT = 24,
	subRecordPACT = 25,
	subRecordPUTF = 26,
	subRecordRPRO = 27,
	subRecordASP = 28,
	subRecordPPN = 29,
	subRecordPPNR = 30,
	subRecordSPVT = 31,
	subRecordRSET = 32,
	subRecordDSET = 33,
	subRecordDPVT = 34,
	subRecordRDES = 35,
	subRecordLSET = 36,
	subRecordPRIO = 37,
	subRecordTPRO = 38,
	subRecordBKPT = 39,
	subRecordUDF = 40,
	subRecordUDFS = 41,
	subRecordTIME = 42,
	subRecordFLNK = 43,
	subRecordVAL = 44,
	subRecordINAM = 45,
	subRecordSNAM = 46,
	subRecordSADR = 47,
	subRecordINPA = 48,
	subRecordINPB = 49,
	subRecordINPC = 50,
	subRecordINPD = 51,
	subRecordINPE = 52,
	subRecordINPF = 53,
	subRecordINPG = 54,
	subRecordINPH = 55,
	subRecordINPI = 56,
	subRecordINPJ = 57,
	subRecordINPK = 58,
	subRecordINPL = 59,
	subRecordEGU = 60,
	subRecordHOPR = 61,
	subRecordLOPR = 62,
	subRecordHIHI = 63,
	subRecordLOLO = 64,
	subRecordHIGH = 65,
	subRecordLOW = 66,
	subRecordPREC = 67,
	subRecordBRSV = 68,
	subRecordHHSV = 69,
	subRecordLLSV = 70,
	subRecordHSV = 71,
	subRecordLSV = 72,
	subRecordHYST = 73,
	subRecordADEL = 74,
	subRecordMDEL = 75,
	subRecordA = 76,
	subRecordB = 77,
	subRecordC = 78,
	subRecordD = 79,
	subRecordE = 80,
	subRecordF = 81,
	subRecordG = 82,
	subRecordH = 83,
	subRecordI = 84,
	subRecordJ = 85,
	subRecordK = 86,
	subRecordL = 87,
	subRecordLA = 88,
	subRecordLB = 89,
	subRecordLC = 90,
	subRecordLD = 91,
	subRecordLE = 92,
	subRecordLF = 93,
	subRecordLG = 94,
	subRecordLH = 95,
	subRecordLI = 96,
	subRecordLJ = 97,
	subRecordLK = 98,
	subRecordLL = 99,
	subRecordLALM = 100,
	subRecordALST = 101,
	subRecordMLST = 102
} subFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int subRecordSizeOffset(dbRecordType *prt)
{
    subRecord *prec = 0;

    assert(prt->no_fields == 103);
    prt->papFldDes[subRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[subRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[subRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[subRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[subRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[subRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[subRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[subRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[subRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[subRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[subRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[subRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[subRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[subRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[subRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[subRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[subRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[subRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[subRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[subRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[subRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[subRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[subRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[subRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[subRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[subRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[subRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[subRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[subRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[subRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[subRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[subRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[subRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[subRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[subRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[subRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[subRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[subRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[subRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[subRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[subRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[subRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[subRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[subRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[subRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[subRecordINAM]->size = sizeof(prec->inam);
    prt->papFldDes[subRecordSNAM]->size = sizeof(prec->snam);
    prt->papFldDes[subRecordSADR]->size = sizeof(prec->sadr);
    prt->papFldDes[subRecordINPA]->size = sizeof(prec->inpa);
    prt->papFldDes[subRecordINPB]->size = sizeof(prec->inpb);
    prt->papFldDes[subRecordINPC]->size = sizeof(prec->inpc);
    prt->papFldDes[subRecordINPD]->size = sizeof(prec->inpd);
    prt->papFldDes[subRecordINPE]->size = sizeof(prec->inpe);
    prt->papFldDes[subRecordINPF]->size = sizeof(prec->inpf);
    prt->papFldDes[subRecordINPG]->size = sizeof(prec->inpg);
    prt->papFldDes[subRecordINPH]->size = sizeof(prec->inph);
    prt->papFldDes[subRecordINPI]->size = sizeof(prec->inpi);
    prt->papFldDes[subRecordINPJ]->size = sizeof(prec->inpj);
    prt->papFldDes[subRecordINPK]->size = sizeof(prec->inpk);
    prt->papFldDes[subRecordINPL]->size = sizeof(prec->inpl);
    prt->papFldDes[subRecordEGU]->size = sizeof(prec->egu);
    prt->papFldDes[subRecordHOPR]->size = sizeof(prec->hopr);
    prt->papFldDes[subRecordLOPR]->size = sizeof(prec->lopr);
    prt->papFldDes[subRecordHIHI]->size = sizeof(prec->hihi);
    prt->papFldDes[subRecordLOLO]->size = sizeof(prec->lolo);
    prt->papFldDes[subRecordHIGH]->size = sizeof(prec->high);
    prt->papFldDes[subRecordLOW]->size = sizeof(prec->low);
    prt->papFldDes[subRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[subRecordBRSV]->size = sizeof(prec->brsv);
    prt->papFldDes[subRecordHHSV]->size = sizeof(prec->hhsv);
    prt->papFldDes[subRecordLLSV]->size = sizeof(prec->llsv);
    prt->papFldDes[subRecordHSV]->size = sizeof(prec->hsv);
    prt->papFldDes[subRecordLSV]->size = sizeof(prec->lsv);
    prt->papFldDes[subRecordHYST]->size = sizeof(prec->hyst);
    prt->papFldDes[subRecordADEL]->size = sizeof(prec->adel);
    prt->papFldDes[subRecordMDEL]->size = sizeof(prec->mdel);
    prt->papFldDes[subRecordA]->size = sizeof(prec->a);
    prt->papFldDes[subRecordB]->size = sizeof(prec->b);
    prt->papFldDes[subRecordC]->size = sizeof(prec->c);
    prt->papFldDes[subRecordD]->size = sizeof(prec->d);
    prt->papFldDes[subRecordE]->size = sizeof(prec->e);
    prt->papFldDes[subRecordF]->size = sizeof(prec->f);
    prt->papFldDes[subRecordG]->size = sizeof(prec->g);
    prt->papFldDes[subRecordH]->size = sizeof(prec->h);
    prt->papFldDes[subRecordI]->size = sizeof(prec->i);
    prt->papFldDes[subRecordJ]->size = sizeof(prec->j);
    prt->papFldDes[subRecordK]->size = sizeof(prec->k);
    prt->papFldDes[subRecordL]->size = sizeof(prec->l);
    prt->papFldDes[subRecordLA]->size = sizeof(prec->la);
    prt->papFldDes[subRecordLB]->size = sizeof(prec->lb);
    prt->papFldDes[subRecordLC]->size = sizeof(prec->lc);
    prt->papFldDes[subRecordLD]->size = sizeof(prec->ld);
    prt->papFldDes[subRecordLE]->size = sizeof(prec->le);
    prt->papFldDes[subRecordLF]->size = sizeof(prec->lf);
    prt->papFldDes[subRecordLG]->size = sizeof(prec->lg);
    prt->papFldDes[subRecordLH]->size = sizeof(prec->lh);
    prt->papFldDes[subRecordLI]->size = sizeof(prec->li);
    prt->papFldDes[subRecordLJ]->size = sizeof(prec->lj);
    prt->papFldDes[subRecordLK]->size = sizeof(prec->lk);
    prt->papFldDes[subRecordLL]->size = sizeof(prec->ll);
    prt->papFldDes[subRecordLALM]->size = sizeof(prec->lalm);
    prt->papFldDes[subRecordALST]->size = sizeof(prec->alst);
    prt->papFldDes[subRecordMLST]->size = sizeof(prec->mlst);
    prt->papFldDes[subRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[subRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[subRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[subRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[subRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[subRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[subRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[subRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[subRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[subRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[subRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[subRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[subRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[subRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[subRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[subRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[subRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[subRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[subRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[subRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[subRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[subRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[subRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[subRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[subRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[subRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[subRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[subRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[subRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[subRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[subRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[subRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[subRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[subRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[subRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[subRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[subRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[subRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[subRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[subRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[subRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[subRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[subRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[subRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[subRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[subRecordINAM]->offset = (unsigned short)((char *)&prec->inam - (char *)prec);
    prt->papFldDes[subRecordSNAM]->offset = (unsigned short)((char *)&prec->snam - (char *)prec);
    prt->papFldDes[subRecordSADR]->offset = (unsigned short)((char *)&prec->sadr - (char *)prec);
    prt->papFldDes[subRecordINPA]->offset = (unsigned short)((char *)&prec->inpa - (char *)prec);
    prt->papFldDes[subRecordINPB]->offset = (unsigned short)((char *)&prec->inpb - (char *)prec);
    prt->papFldDes[subRecordINPC]->offset = (unsigned short)((char *)&prec->inpc - (char *)prec);
    prt->papFldDes[subRecordINPD]->offset = (unsigned short)((char *)&prec->inpd - (char *)prec);
    prt->papFldDes[subRecordINPE]->offset = (unsigned short)((char *)&prec->inpe - (char *)prec);
    prt->papFldDes[subRecordINPF]->offset = (unsigned short)((char *)&prec->inpf - (char *)prec);
    prt->papFldDes[subRecordINPG]->offset = (unsigned short)((char *)&prec->inpg - (char *)prec);
    prt->papFldDes[subRecordINPH]->offset = (unsigned short)((char *)&prec->inph - (char *)prec);
    prt->papFldDes[subRecordINPI]->offset = (unsigned short)((char *)&prec->inpi - (char *)prec);
    prt->papFldDes[subRecordINPJ]->offset = (unsigned short)((char *)&prec->inpj - (char *)prec);
    prt->papFldDes[subRecordINPK]->offset = (unsigned short)((char *)&prec->inpk - (char *)prec);
    prt->papFldDes[subRecordINPL]->offset = (unsigned short)((char *)&prec->inpl - (char *)prec);
    prt->papFldDes[subRecordEGU]->offset = (unsigned short)((char *)&prec->egu - (char *)prec);
    prt->papFldDes[subRecordHOPR]->offset = (unsigned short)((char *)&prec->hopr - (char *)prec);
    prt->papFldDes[subRecordLOPR]->offset = (unsigned short)((char *)&prec->lopr - (char *)prec);
    prt->papFldDes[subRecordHIHI]->offset = (unsigned short)((char *)&prec->hihi - (char *)prec);
    prt->papFldDes[subRecordLOLO]->offset = (unsigned short)((char *)&prec->lolo - (char *)prec);
    prt->papFldDes[subRecordHIGH]->offset = (unsigned short)((char *)&prec->high - (char *)prec);
    prt->papFldDes[subRecordLOW]->offset = (unsigned short)((char *)&prec->low - (char *)prec);
    prt->papFldDes[subRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[subRecordBRSV]->offset = (unsigned short)((char *)&prec->brsv - (char *)prec);
    prt->papFldDes[subRecordHHSV]->offset = (unsigned short)((char *)&prec->hhsv - (char *)prec);
    prt->papFldDes[subRecordLLSV]->offset = (unsigned short)((char *)&prec->llsv - (char *)prec);
    prt->papFldDes[subRecordHSV]->offset = (unsigned short)((char *)&prec->hsv - (char *)prec);
    prt->papFldDes[subRecordLSV]->offset = (unsigned short)((char *)&prec->lsv - (char *)prec);
    prt->papFldDes[subRecordHYST]->offset = (unsigned short)((char *)&prec->hyst - (char *)prec);
    prt->papFldDes[subRecordADEL]->offset = (unsigned short)((char *)&prec->adel - (char *)prec);
    prt->papFldDes[subRecordMDEL]->offset = (unsigned short)((char *)&prec->mdel - (char *)prec);
    prt->papFldDes[subRecordA]->offset = (unsigned short)((char *)&prec->a - (char *)prec);
    prt->papFldDes[subRecordB]->offset = (unsigned short)((char *)&prec->b - (char *)prec);
    prt->papFldDes[subRecordC]->offset = (unsigned short)((char *)&prec->c - (char *)prec);
    prt->papFldDes[subRecordD]->offset = (unsigned short)((char *)&prec->d - (char *)prec);
    prt->papFldDes[subRecordE]->offset = (unsigned short)((char *)&prec->e - (char *)prec);
    prt->papFldDes[subRecordF]->offset = (unsigned short)((char *)&prec->f - (char *)prec);
    prt->papFldDes[subRecordG]->offset = (unsigned short)((char *)&prec->g - (char *)prec);
    prt->papFldDes[subRecordH]->offset = (unsigned short)((char *)&prec->h - (char *)prec);
    prt->papFldDes[subRecordI]->offset = (unsigned short)((char *)&prec->i - (char *)prec);
    prt->papFldDes[subRecordJ]->offset = (unsigned short)((char *)&prec->j - (char *)prec);
    prt->papFldDes[subRecordK]->offset = (unsigned short)((char *)&prec->k - (char *)prec);
    prt->papFldDes[subRecordL]->offset = (unsigned short)((char *)&prec->l - (char *)prec);
    prt->papFldDes[subRecordLA]->offset = (unsigned short)((char *)&prec->la - (char *)prec);
    prt->papFldDes[subRecordLB]->offset = (unsigned short)((char *)&prec->lb - (char *)prec);
    prt->papFldDes[subRecordLC]->offset = (unsigned short)((char *)&prec->lc - (char *)prec);
    prt->papFldDes[subRecordLD]->offset = (unsigned short)((char *)&prec->ld - (char *)prec);
    prt->papFldDes[subRecordLE]->offset = (unsigned short)((char *)&prec->le - (char *)prec);
    prt->papFldDes[subRecordLF]->offset = (unsigned short)((char *)&prec->lf - (char *)prec);
    prt->papFldDes[subRecordLG]->offset = (unsigned short)((char *)&prec->lg - (char *)prec);
    prt->papFldDes[subRecordLH]->offset = (unsigned short)((char *)&prec->lh - (char *)prec);
    prt->papFldDes[subRecordLI]->offset = (unsigned short)((char *)&prec->li - (char *)prec);
    prt->papFldDes[subRecordLJ]->offset = (unsigned short)((char *)&prec->lj - (char *)prec);
    prt->papFldDes[subRecordLK]->offset = (unsigned short)((char *)&prec->lk - (char *)prec);
    prt->papFldDes[subRecordLL]->offset = (unsigned short)((char *)&prec->ll - (char *)prec);
    prt->papFldDes[subRecordLALM]->offset = (unsigned short)((char *)&prec->lalm - (char *)prec);
    prt->papFldDes[subRecordALST]->offset = (unsigned short)((char *)&prec->alst - (char *)prec);
    prt->papFldDes[subRecordMLST]->offset = (unsigned short)((char *)&prec->mlst - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(subRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_subRecord_H */
