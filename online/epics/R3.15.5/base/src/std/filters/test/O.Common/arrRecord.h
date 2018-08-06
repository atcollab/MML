/* arrRecord.h generated from arrRecord.dbd */

#ifndef INC_arrRecord_H
#define INC_arrRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef enum {
    menuPriorityLOW                 /* LOW */,
    menuPriorityMEDIUM              /* MEDIUM */,
    menuPriorityHIGH                /* HIGH */
} menuPriority;
#define menuPriority_NUM_CHOICES 3

typedef enum {
    menuPost_OnChange               /* On Change */,
    menuPost_Always                 /* Always */
} menuPost;
#define menuPost_NUM_CHOICES 2

typedef enum {
    menuConvertNO_CONVERSION        /* NO CONVERSION */,
    menuConvertSLOPE                /* SLOPE */,
    menuConvertLINEAR               /* LINEAR */,
    menuConverttypeKdegF            /* typeKdegF */,
    menuConverttypeKdegC            /* typeKdegC */,
    menuConverttypeJdegF            /* typeJdegF */,
    menuConverttypeJdegC            /* typeJdegC */,
    menuConverttypeEdegF            /* typeEdegF(ixe only) */,
    menuConverttypeEdegC            /* typeEdegC(ixe only) */,
    menuConverttypeTdegF            /* typeTdegF */,
    menuConverttypeTdegC            /* typeTdegC */,
    menuConverttypeRdegF            /* typeRdegF */,
    menuConverttypeRdegC            /* typeRdegC */,
    menuConverttypeSdegF            /* typeSdegF */,
    menuConverttypeSdegC            /* typeSdegC */
} menuConvert;
#define menuConvert_NUM_CHOICES 15

typedef enum {
    menuYesNoNO                     /* NO */,
    menuYesNoYES                    /* YES */
} menuYesNo;
#define menuYesNo_NUM_CHOICES 2

typedef enum {
    menuScanPassive                 /* Passive */,
    menuScanEvent                   /* Event */,
    menuScanI_O_Intr                /* I/O Intr */,
    menuScan10_second               /* 10 second */,
    menuScan5_second                /* 5 second */,
    menuScan2_second                /* 2 second */,
    menuScan1_second                /* 1 second */,
    menuScan_5_second               /* .5 second */,
    menuScan_2_second               /* .2 second */,
    menuScan_1_second               /* .1 second */
} menuScan;
#define menuScan_NUM_CHOICES 10

typedef enum {
    menuAlarmStatNO_ALARM           /* NO_ALARM */,
    menuAlarmStatREAD               /* READ */,
    menuAlarmStatWRITE              /* WRITE */,
    menuAlarmStatHIHI               /* HIHI */,
    menuAlarmStatHIGH               /* HIGH */,
    menuAlarmStatLOLO               /* LOLO */,
    menuAlarmStatLOW                /* LOW */,
    menuAlarmStatSTATE              /* STATE */,
    menuAlarmStatCOS                /* COS */,
    menuAlarmStatCOMM               /* COMM */,
    menuAlarmStatTIMEOUT            /* TIMEOUT */,
    menuAlarmStatHWLIMIT            /* HWLIMIT */,
    menuAlarmStatCALC               /* CALC */,
    menuAlarmStatSCAN               /* SCAN */,
    menuAlarmStatLINK               /* LINK */,
    menuAlarmStatSOFT               /* SOFT */,
    menuAlarmStatBAD_SUB            /* BAD_SUB */,
    menuAlarmStatUDF                /* UDF */,
    menuAlarmStatDISABLE            /* DISABLE */,
    menuAlarmStatSIMM               /* SIMM */,
    menuAlarmStatREAD_ACCESS        /* READ_ACCESS */,
    menuAlarmStatWRITE_ACCESS       /* WRITE_ACCESS */
} menuAlarmStat;
#define menuAlarmStat_NUM_CHOICES 22

typedef enum {
    menuSimmNO                      /* NO */,
    menuSimmYES                     /* YES */,
    menuSimmRAW                     /* RAW */
} menuSimm;
#define menuSimm_NUM_CHOICES 3

typedef enum {
    menuOmslsupervisory             /* supervisory */,
    menuOmslclosed_loop             /* closed_loop */
} menuOmsl;
#define menuOmsl_NUM_CHOICES 2

typedef enum {
    menuFtypeSTRING                 /* STRING */,
    menuFtypeCHAR                   /* CHAR */,
    menuFtypeUCHAR                  /* UCHAR */,
    menuFtypeSHORT                  /* SHORT */,
    menuFtypeUSHORT                 /* USHORT */,
    menuFtypeLONG                   /* LONG */,
    menuFtypeULONG                  /* ULONG */,
    menuFtypeFLOAT                  /* FLOAT */,
    menuFtypeDOUBLE                 /* DOUBLE */,
    menuFtypeENUM                   /* ENUM */
} menuFtype;
#define menuFtype_NUM_CHOICES 10

typedef enum {
    menuAlarmSevrNO_ALARM           /* NO_ALARM */,
    menuAlarmSevrMINOR              /* MINOR */,
    menuAlarmSevrMAJOR              /* MAJOR */,
    menuAlarmSevrINVALID            /* INVALID */
} menuAlarmSevr;
#define menuAlarmSevr_NUM_CHOICES 4

typedef enum {
    menuPiniNO                      /* NO */,
    menuPiniYES                     /* YES */,
    menuPiniRUN                     /* RUN */,
    menuPiniRUNNING                 /* RUNNING */,
    menuPiniPAUSE                   /* PAUSE */,
    menuPiniPAUSED                  /* PAUSED */
} menuPini;
#define menuPini_NUM_CHOICES 6

typedef enum {
    menuIvoaContinue_normally       /* Continue normally */,
    menuIvoaDon_t_drive_outputs     /* Don't drive outputs */,
    menuIvoaSet_output_to_IVOV      /* Set output to IVOV */
} menuIvoa;
#define menuIvoa_NUM_CHOICES 3

typedef struct arrRecord {
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
    void *val;                      /* Value */
    epicsUInt32         nelm;       /* Number of Elements */
    epicsEnum16         ftvl;       /* Field Type of Value */
    epicsUInt32         nord;       /* Number elements read */
    epicsUInt32         off;        /* Offset into array */
    void *bptr;                     /* Buffer Pointer */
} arrRecord;

typedef enum {
	arrRecordNAME = 0,
	arrRecordDESC = 1,
	arrRecordASG = 2,
	arrRecordSCAN = 3,
	arrRecordPINI = 4,
	arrRecordPHAS = 5,
	arrRecordEVNT = 6,
	arrRecordTSE = 7,
	arrRecordTSEL = 8,
	arrRecordDTYP = 9,
	arrRecordDISV = 10,
	arrRecordDISA = 11,
	arrRecordSDIS = 12,
	arrRecordMLOK = 13,
	arrRecordMLIS = 14,
	arrRecordDISP = 15,
	arrRecordPROC = 16,
	arrRecordSTAT = 17,
	arrRecordSEVR = 18,
	arrRecordNSTA = 19,
	arrRecordNSEV = 20,
	arrRecordACKS = 21,
	arrRecordACKT = 22,
	arrRecordDISS = 23,
	arrRecordLCNT = 24,
	arrRecordPACT = 25,
	arrRecordPUTF = 26,
	arrRecordRPRO = 27,
	arrRecordASP = 28,
	arrRecordPPN = 29,
	arrRecordPPNR = 30,
	arrRecordSPVT = 31,
	arrRecordRSET = 32,
	arrRecordDSET = 33,
	arrRecordDPVT = 34,
	arrRecordRDES = 35,
	arrRecordLSET = 36,
	arrRecordPRIO = 37,
	arrRecordTPRO = 38,
	arrRecordBKPT = 39,
	arrRecordUDF = 40,
	arrRecordUDFS = 41,
	arrRecordTIME = 42,
	arrRecordFLNK = 43,
	arrRecordVAL = 44,
	arrRecordNELM = 45,
	arrRecordFTVL = 46,
	arrRecordNORD = 47,
	arrRecordOFF = 48,
	arrRecordBPTR = 49
} arrFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int arrRecordSizeOffset(dbRecordType *prt)
{
    arrRecord *prec = 0;

    assert(prt->no_fields == 50);
    prt->papFldDes[arrRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[arrRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[arrRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[arrRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[arrRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[arrRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[arrRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[arrRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[arrRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[arrRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[arrRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[arrRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[arrRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[arrRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[arrRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[arrRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[arrRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[arrRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[arrRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[arrRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[arrRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[arrRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[arrRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[arrRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[arrRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[arrRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[arrRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[arrRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[arrRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[arrRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[arrRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[arrRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[arrRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[arrRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[arrRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[arrRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[arrRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[arrRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[arrRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[arrRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[arrRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[arrRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[arrRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[arrRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[arrRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[arrRecordNELM]->size = sizeof(prec->nelm);
    prt->papFldDes[arrRecordFTVL]->size = sizeof(prec->ftvl);
    prt->papFldDes[arrRecordNORD]->size = sizeof(prec->nord);
    prt->papFldDes[arrRecordOFF]->size = sizeof(prec->off);
    prt->papFldDes[arrRecordBPTR]->size = sizeof(prec->bptr);
    prt->papFldDes[arrRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[arrRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[arrRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[arrRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[arrRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[arrRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[arrRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[arrRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[arrRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[arrRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[arrRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[arrRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[arrRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[arrRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[arrRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[arrRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[arrRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[arrRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[arrRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[arrRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[arrRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[arrRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[arrRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[arrRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[arrRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[arrRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[arrRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[arrRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[arrRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[arrRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[arrRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[arrRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[arrRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[arrRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[arrRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[arrRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[arrRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[arrRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[arrRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[arrRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[arrRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[arrRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[arrRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[arrRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[arrRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[arrRecordNELM]->offset = (unsigned short)((char *)&prec->nelm - (char *)prec);
    prt->papFldDes[arrRecordFTVL]->offset = (unsigned short)((char *)&prec->ftvl - (char *)prec);
    prt->papFldDes[arrRecordNORD]->offset = (unsigned short)((char *)&prec->nord - (char *)prec);
    prt->papFldDes[arrRecordOFF]->offset = (unsigned short)((char *)&prec->off - (char *)prec);
    prt->papFldDes[arrRecordBPTR]->offset = (unsigned short)((char *)&prec->bptr - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(arrRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_arrRecord_H */
