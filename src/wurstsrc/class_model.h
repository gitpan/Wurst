/*
 * $Id: class_model.h,v 1.7 2007/09/28 12:12:02 torda Exp $
 */
#ifndef CLASS_MODEL_H
#define CLASS_MODEL_H
#endif
#include <stdlib.h>

/* ---------------- Structures -------------------------------- */
struct clssfcn { /* a structure to store a classification */
    enum {
        SINGLE_NORMAL, /* gaussian normal distribution            */
        MULTI_NORMAL,  /* correlated gaussian normal distribution */
        UNKNOWN        /* unknown distribution                    */
    } **classmodel;      /* which kinds of models are used              */
    double ***param;     /* parameters for each class in each dimension */
    double **cov_matrix; /* (1-dim) covariance matrix of each class     */
    float *class_weight; /* relative population of each class           */
    size_t n_class;      /* number of classes                           */
    size_t dim;          /* dimension of feature space (input-vector)   */
    float abs_error;     /* absolut error in (input) measurement        */
};

struct clssfcn * get_clssfcn(const char *influence_report_filename,
                             const float abs_error);
void clssfcn_destroy(struct clssfcn * c);
float * computeMembership(float *mship, const float* test_vec,
                          const struct clssfcn *cmodel);
/* 28 MAR 2006 TStehr */
float * computeMembershipStrct (float *mship, const float * test_vec,
                                const struct clssfcn *cmodel);
