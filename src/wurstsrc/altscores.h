/* 29 Mar 05
 * $Id: altscores.h,v 1.4 2007/09/28 11:24:58 torda Exp $
 * Gundolf Schenk
 */
#ifndef ALTSCORES_H
#define ALTSCORES_H

struct score_mat;
struct pair_set;
float
find_alt_path_score (const struct score_mat * score_mat,
		     const size_t * random_row_index_vec,
                     const size_t vec_length,
		     const struct pair_set * pair_set);

float
find_alt_path_score_simple (const struct score_mat * score_mat,
                            const struct pair_set * pair_set);

#endif /* ALTSCORES_H */
