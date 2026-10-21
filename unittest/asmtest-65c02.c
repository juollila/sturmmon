/*
   65c02 test data
   Coded by Juha Ollila

   Jun 26 2019 Initial version.
   Oct 20 2026 Unit tests for RMB and SMB instructions
   Oct 21 2026 Unit tests for WAI and STP instructions
   Oct 21 2026 Unit tests for BBR and BBS instructions
*/

#include "asmtest-65c02.h"

param_struct zpmdata[] = {
  {"ADC ($12)\r", 2, "\x72\x12"},
  {"AND ($CD)\r", 2, "\x32\xCD"},
  {"CMP ($12)\r", 2, "\xD2\x12"},
  {"EOR ($CD)\r", 2, "\x52\xCD"},
  {"LDA ($12)\r", 2, "\xB2\x12"},
  {"ORA ($CD)\r", 2, "\x12\xCD"},
  {"SBC ($12)\r", 2, "\xF2\x12"},
  {"STA ($CD)\r", 2, "\x92\xCD"},
  {"*",0,""}
};

param_struct bitdata[] = {
  {"BIT #$12\r",    2, "\x89\x12"},
  {"BIT $12,X\r",   2, "\x34\x12"},
  {"BIT $1234,X\r", 3, "\x3C\x34\x12"},
  {"*",0,""}
};

param_struct decdata[] = {
  {"DEC\r", 1, "\x3A"},
  {"INC\r", 1, "\x1A"},
  {"*",0,""}
};


param_struct jmpdata[] = {
  {"JMP ($1234,X)\r", 3, "\x7C\x34\x12"},
  {"*",0,""}
};

param_struct bradata[] = {
  {"BRA $CE02\r", 2, "\x80\x00"},
  {"BRA $CE01\r", 2, "\x80\xFF"},
  {"*",0,""}
};

param_struct phxdata[] = {
  {"PHX\r", 1, "\xDA"},
  {"PHY\r", 1, "\x5A"},
  {"PLX\r", 1, "\xFA"},
  {"PLY\r", 1, "\x7A"},
  {"*",0,""}
};

param_struct stzdata[] = {
  {"STZ $12\r",     2, "\x64\x12"},
  {"STZ $00,X\r",   2, "\x74\x00"},
  {"STZ $3456\r",   3, "\x9C\x56\x34"},
  {"STZ $BCDE,X\r", 3, "\x9E\xDE\xBC"},
  {"*",0,""}
};

param_struct trbdata[] = {
  {"TRB $78\r",   2, "\x14\x78"},
  {"TRB $3456\r", 3, "\x1C\x56\x34"},
  {"*",0,""}
};

param_struct tsbdata[] = {
  {"TSB $78\r",   2, "\x04\x78"},
  {"TSB $3456\r", 3, "\x0C\x56\x34"},
  {"*",0,""}
};

param_struct rmbdata[] = {
  {"RMB0 $12\r", 2, "\x07\x12"},
  {"RMB1 $12\r", 2, "\x17\x12"},
  {"RMB2 $12\r", 2, "\x27\x12"},
  {"RMB3 $12\r", 2, "\x37\x12"},
  {"RMB4 $12\r", 2, "\x47\x12"},
  {"RMB5 $12\r", 2, "\x57\x12"},
  {"RMB6 $12\r", 2, "\x67\x12"},
  {"RMB7 $12\r", 2, "\x77\x12"},
  {"*",0,""}
};

param_struct smbdata[] = {
  {"SMB0 $EF\r", 2, "\x87\xef"},
  {"SMB1 $EF\r", 2, "\x97\xef"},
  {"SMB2 $EF\r", 2, "\xa7\xef"},
  {"SMB3 $EF\r", 2, "\xb7\xef"},
  {"SMB4 $EF\r", 2, "\xc7\xef"},
  {"SMB5 $EF\r", 2, "\xd7\xef"},
  {"SMB6 $EF\r", 2, "\xe7\xef"},
  {"SMB7 $EF\r", 2, "\xf7\xef"},
  {"*",0,""}
};

param_struct waistpdata[] = {
  {"WAI\r", 1, "\xcb"},
  {"STP\r", 1, "\xdb"},
  {"*",0,""}
};

param_struct bbrdata[] = {
  {"BBR0 $DA,$CE05\r", 3, "\x0f\xda\x02"},
  {"BBR1 $DA,$CE05\r", 3, "\x1f\xda\x02"},
  {"BBR2 $DA,$CE05\r", 3, "\x2f\xda\x02"},
  {"BBR3 $DA,$CE05\r", 3, "\x3f\xda\x02"},
  {"BBR4 $DA,$CDF0\r", 3, "\x4f\xda\xed"},
  {"BBR5 $DA,$CDF0\r", 3, "\x5f\xda\xed"},
  {"BBR6 $DA,$CDF0\r", 3, "\x6f\xda\xed"},
  {"BBR7 $DA,$CDF0\r", 3, "\x7f\xda\xed"},
  {"*",0,""}
};

param_struct bbsdata[] = {
  {"BBS0 $DA,$CE05\r", 3, "\x8f\xda\x02"},
  {"BBS1 $DA,$CE05\r", 3, "\x9f\xda\x02"},
  {"BBS2 $DA,$CE05\r", 3, "\xaf\xda\x02"},
  {"BBS3 $DA,$CE05\r", 3, "\xbf\xda\x02"},
  {"BBS4 $DA,$CDF0\r", 3, "\xcf\xda\xed"},
  {"BBS5 $DA,$CDF0\r", 3, "\xdf\xda\xed"},
  {"BBS6 $DA,$CDF0\r", 3, "\xef\xda\xed"},
  {"BBS7 $DA,$CDF0\r", 3, "\xff\xda\xed"},
  {"*",0,""}
};

