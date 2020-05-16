/*
   65c02 test data
   Coded by Juha Ollila

   Jun 26 2019 Initial version.
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

