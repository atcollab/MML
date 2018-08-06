/* menuConvert.h generated from menuConvert.dbd */

#ifndef INC_menuConvert_H
#define INC_menuConvert_H

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


#endif /* INC_menuConvert_H */
