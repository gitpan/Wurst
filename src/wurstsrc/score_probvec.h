/*
 * 14 June 2005
 * rcsid = $Id: score_probvec.h,v 1.4 2006/02/22 14:06:49 torda Exp $
 */

#ifndef SCORE_PROBVEC_H
#define SCORE_PROBVEC_H

struct score_mat;
struct prob_vec;
int
score_pvec (struct score_mat *score_mat,
            struct prob_vec *p_v1, struct prob_vec *p_v2);

#endif /* SCORE_PROBVEC_H */
