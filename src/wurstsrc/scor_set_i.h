/*
 * 23 Jan 2004
 * Functions operating with score set.
 * rcsid = $Id: scor_set_i.h,v 1.3 2007/06/22 09:17:41 torda Exp $
 */
#ifndef SCOR_SET_I_H
#define SCOR_SET_I_H

struct scor_set;
struct pair_set;
struct score_mat;
struct scor_set *scor_set_simpl (struct pair_set *pair_set, const struct score_mat *smat);
struct scor_set *scor_set_fromvec ( size_t n, double *v );
int              scor_set_scale(struct scor_set *ss, float scale);
void             scor_set_destroy ( struct scor_set *x);

#endif

