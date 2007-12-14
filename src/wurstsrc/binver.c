/*
 * 30 May 2002
 * $Id: binver.c,v 1.11 2007/09/28 11:26:30 torda Exp $
 * We need a version marker on our coordinate files.
 * We want a revision number, but if we include the string in our
 * file, coord.c, the version control system will grab hold of
 * it.
 */

#include "binver.h"

/* ---------------- bin_version   -----------------------------
 */
const char *
bin_version ( void )
{
    return "wurst Revision: 1.10 $ version\n";
}
