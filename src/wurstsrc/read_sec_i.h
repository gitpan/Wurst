/*
 * 26 February 2002
 * Public interface to sec struct data reading routines.
 * $Id: read_sec_i.h,v 1.2 2007/09/28 12:11:58 torda Exp $
 */
#ifndef READ_SEC_I_H
#define READ_SEC_I_H

struct sec_s_data;
struct sec_s_data *sec_s_data_read (const char *fname);
char * sec_s_data_string (struct sec_s_data *sec_s_data);
void   sec_s_data_destroy ( struct sec_s_data *sec_s_data);
#endif /* READ_SEC_I_H */
