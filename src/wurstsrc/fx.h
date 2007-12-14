/*
 * 10 January 2002
 * rcsid = $Id: fx.h,v 1.2 2007/09/28 11:39:24 torda Exp $
 */

#ifndef FX_H
#define FX_H

typedef struct FXParam {
    size_t nr_groups, nr_inst, nr_dbins;
    float  *cw;
    float  **Ijk, **Ijk_nbr, **Ijk_psi, *Ijk_dist;
    float  ***paa, ***pna;
    float  **psi, **dpsi, *pdav, *pdsig;
    float  *dbin;
} FXParam;

#endif /* FX_H */
