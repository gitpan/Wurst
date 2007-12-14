/*
 * 23 Jan 2004
 * rcsid = $Id: scor_set.h,v 1.2 2007/06/22 09:15:54 torda Exp $
 * This defines the structures for annotating an alignment with
 * local score (like) numbers.
 * This structure is defined for safety, rather than trust the 
 * user to keep track of un-typed floatPtr in their perl code.
 */
#ifndef SCOR_SET_H
#define SCOR_SET_H

struct scor_set {
    float *scores;
    size_t n;
};

#endif
