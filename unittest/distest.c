/*
   Disassembly test data
   Coded by Juha Ollila

   Jun 28 2019 Initial version.
   Oct 21 2021 RMB, SMB, BBR and BBS instructions
*/

#include "distest.h"

param_struct disdata[] = {
  {"\x69\x12\x00", 8,  "ADC #$12", 2},      /* immediate */
  {"\x65\x12\x00", 7,  "ADC $12", 2},       /* zp */ 
  {"\x75\x12\x00", 9,  "ADC $12,X", 2},     /* zp, x */
  {"\xB6\x12\x00", 9,  "LDX $12,Y", 2},     /* zp,y */
  {"\x2D\xCD\xAB", 9,  "AND $ABCD", 3},     /* absolute */ 
  {"\x3D\xCD\xAB", 11, "AND $ABCD,X", 3},   /* absolute, x */
  {"\x39\xCD\xAB", 11, "AND $ABCD,Y", 3},   /* absolute, y */
  {"\x21\x34\x00", 10, "AND ($34,X)", 2},   /* indirect, x */
  {"\x31\x34\x00", 10, "AND ($34),Y", 2},   /* indirect, y */
  {"\x0A\x00\x00", 3,  "ASL", 1},           /* accumulator */
  {"\x10\x7D\x00", 9,  "BPL $007F", 2},     /* relative */
  {"\x6C\xCD\xAB", 11, "JMP ($ABCD)", 3},   /* indirect */
  {"\x92\x12\x00", 9,  "STA ($12)", 2},     /* zp indirect */
  {"\x7C\xCD\xAB", 13, "JMP ($ABCD,X)", 3}, /* absolute indirect x */
  {"\x17\xCD\x00", 8, "RMB1 $CD", 2},       /* rmb / smb */
  {"\xF7\xCD\x00", 8, "SMB7 $CD", 2},       /* rmb / smb */
  {"\x1F\xCD\x7C", 14, "BBR1 $CD,$007F", 3},/* bbr / bbs*/
  {"\xFF\xCD\x7C", 14, "BBS7 $CD,$007F", 3},/* bbr / bbs*/
  {"*",0,"",0}
};


