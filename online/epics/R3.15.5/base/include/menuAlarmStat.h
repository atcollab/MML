/* menuAlarmStat.h generated from menuAlarmStat.dbd */

#ifndef INC_menuAlarmStat_H
#define INC_menuAlarmStat_H

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


#endif /* INC_menuAlarmStat_H */
