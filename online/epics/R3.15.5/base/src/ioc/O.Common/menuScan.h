/* menuScan.h generated from menuScan.dbd */

#ifndef INC_menuScan_H
#define INC_menuScan_H

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


#endif /* INC_menuScan_H */
