/*
 * 16 Nov 2005
 * $Id: score_rand.h,v 1.2 2007/09/28 12:11:57 torda Exp $
 */
#ifndef SCORE_RAND_H
#define SCORE_RAND_H

struct score_mat;
void
score_rand (struct score_mat *score_mat, const float mean, const float std_dv);

#endif /* SCORE_RAND_H */
