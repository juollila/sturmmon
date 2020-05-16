/*
   Assembler test data
   Coded by Juha Ollila

   Oct 21 2017 Test data was defined for ADC, AND, ASL, branches,
               BIT, and implied mode.
   Oct 22 2017 Test data was defined for CMP, CPX, CPY, DEC, EOR,
               INC, jumps, LDA, LDX, LDY, LSR, ORA, ROL, ROR, SBC,
               STA, STX, and STY.
*/

#include "asmtest.h"

param_struct adcdata[] = {
  {"ADC #$FF\r",    2, "\x69\xFF"},
  {"ADC $ABCD\r",   3, "\x6D\xCD\xAB"},
  {"ADC $00\r",     2, "\x65\x00"},
  {"ADC ($12,X)\r", 2, "\x61\x12"},
  {"ADC ($BC),Y\r", 2, "\x71\xBC"},
  {"ADC $EF,X\r",   2, "\x75\xEF"},
  {"ADC $0001,X\r", 3, "\x7D\x01\x00"},
  {"ADC $FFFE,Y\r", 3, "\x79\xFE\xFF"},
  {"*",0,""}
};

param_struct anddata[] = {
  {"AND #$00\r",    2, "\x29\x00"},
  {"AND $1234\r",   3, "\x2D\x34\x12"},
  {"AND $FF\r",     2, "\x25\xFF"},
  {"AND ($12,X)\r", 2, "\x21\x12"},
  {"AND ($BC),Y\r", 2, "\x31\xBC"},
  {"AND $EF,X\r",   2, "\x35\xEF"},
  {"AND $ABCD,X\r", 3, "\x3D\xCD\xAB"},
  {"AND $DEF0,Y\r", 3, "\x39\xF0\xDE"},
  {"*",0,""}
};

param_struct asldata[] = {
  {"ASL $0034\r",   3, "\x0E\x34\x00"},
  {"ASL $AB\r",     2, "\x06\xAB"},
  {"ASL\r",         1, "\x0A"},
  {"ASL $EF,X\r",   2, "\x16\xEF"},
  {"ASL $AB00,X\r", 3, "\x1E\x00\xAB"},
  {"*",0,""}
};

/*
param_struct bradata[] = {
  {"BCC $C002\r",   2, "\x90\x00"},
  {"BCS $C001\r",   2, "\xB0\xFF"},
  {"BEQ $C081\r",   2, "\xF0\x7F"},
  {"BMI $BF82\r",   2, "\x30\x80"},
  {"BNE $C002\r",   2, "\xD0\x00"},
  {"BPL $C001\r",   2, "\x10\xFF"},
  {"BVC $C081\r",   2, "\x50\x7F"},
  {"BVS $BF82\r",   2, "\x70\x80"},
  {"*",0,""}
};
*/
param_struct bradata[] = {
  {"BCC $CE02\r",   2, "\x90\x00"},
  {"BCS $CE01\r",   2, "\xB0\xFF"},
  {"BEQ $CE81\r",   2, "\xF0\x7F"},
  {"BMI $CD82\r",   2, "\x30\x80"},
  {"BNE $CE02\r",   2, "\xD0\x00"},
  {"BPL $CE01\r",   2, "\x10\xFF"},
  {"BVC $CE81\r",   2, "\x50\x7F"},
  {"BVS $CD82\r",   2, "\x70\x80"},
  {"*",0,""}
};

param_struct bitdata[] = {
  {"BIT $1234\r",   3, "\x2C\x34\x12"},
  {"BIT $AB\r",     2, "\x24\xAB"},
  {"*",0,""}
};

param_struct impdata[] = {
  {"BRK\r",   1, "\x00"},
  {"CLC\r",   1, "\x18"},
  {"CLD\r",   1, "\xD8"},
  {"CLI\r",   1, "\x58"},
  {"CLV\r",   1, "\xB8"},
  {"DEX\r",   1, "\xCA"},
  {"DEY\r",   1, "\x88"},
  {"INX\r",   1, "\xE8"},
  {"INY\r",   1, "\xC8"},
  {"NOP\r",   1, "\xEA"},
  {"PHA\r",   1, "\x48"},
  {"PHP\r",   1, "\x08"},
  {"PLA\r",   1, "\x68"},
  {"PLP\r",   1, "\x28"},
  {"RTI\r",   1, "\x40"},
  {"RTS\r",   1, "\x60"},
  {"SEC\r",   1, "\x38"},
  {"SED\r",   1, "\xF8"},
  {"SEI\r",   1, "\x78"},
  {"TAX\r",   1, "\xAA"},
  {"TAY\r",   1, "\xA8"},
  {"TSX\r",   1, "\xBA"},
  {"TXA\r",   1, "\x8A"},
  {"TXS\r",   1, "\x9A"},
  {"TYA\r",   1, "\x98"},
  {"*",0,""}
};

param_struct cmpdata[] = {
  {"CMP #$12\r",    2, "\xC9\x12"},
  {"CMP $3456\r",   3, "\xCD\x56\x34"},
  {"CMP $78\r",     2, "\xC5\x78"},
  {"CMP ($00,X)\r", 2, "\xC1\x00"},
  {"CMP ($FF),Y\r", 2, "\xD1\xFF"},
  {"CMP $9A,X\r",   2, "\xD5\x9A"},
  {"CMP $BCDE,X\r", 3, "\xDD\xDE\xBC"},
  {"CMP $F012,Y\r", 3, "\xD9\x12\xF0"},
  {"*",0,""}
};

param_struct cpxdata[] = {
  {"CPX #$12\r",    2, "\xE0\x12"},
  {"CPX $3456\r",   3, "\xEC\x56\x34"},
  {"CPX $78\r",     2, "\xE4\x78"},
  {"*",0,""}
};

param_struct cpydata[] = {
  {"CPY #$12\r",    2, "\xC0\x12"},
  {"CPY $3456\r",   3, "\xCC\x56\x34"},
  {"CPY $78\r",     2, "\xC4\x78"},
  {"*",0,""}
};

param_struct decdata[] = {
  {"DEC $1234\r",   3, "\xCE\x34\x12"},
  {"DEC $56\r",     2, "\xC6\x56"},
  {"DEC $78,X\r",   2, "\xD6\x78"},
  {"DEC $9ABC,X\r", 3, "\xDE\xBC\x9A"},
  {"*",0,""}
};

param_struct eordata[] = {
  {"EOR #$12\r",    2, "\x49\x12"},
  {"EOR $3456\r",   3, "\x4D\x56\x34"},
  {"EOR $78\r",     2, "\x45\x78"},
  {"EOR ($00,X)\r", 2, "\x41\x00"},
  {"EOR ($FF),Y\r", 2, "\x51\xFF"},
  {"EOR $9A,X\r",   2, "\x55\x9A"},
  {"EOR $BCDE,X\r", 3, "\x5D\xDE\xBC"},
  {"EOR $F012,Y\r", 3, "\x59\x12\xF0"},
  {"*",0,""}
};

param_struct incdata[] = {
  {"INC $1234\r",   3, "\xEE\x34\x12"},
  {"INC $56\r",     2, "\xE6\x56"},
  {"INC $78,X\r",   2, "\xF6\x78"},
  {"INC $9ABC,X\r", 3, "\xFE\xBC\x9A"},
  {"*",0,""}
};

param_struct jmpdata[] = {
  {"JMP $1234\r",   3, "\x4C\x34\x12"},
  {"JMP ($5678)\r", 3, "\x6C\x78\x56"},
  {"JSR $1234\r",   3, "\x20\x34\x12"},
  {"*",0,""}
};

param_struct ldadata[] = {
  {"LDA #$12\r",    2, "\xA9\x12"},
  {"LDA $3456\r",   3, "\xAD\x56\x34"},
  {"LDA $78\r",     2, "\xA5\x78"},
  {"LDA ($00,X)\r", 2, "\xA1\x00"},
  {"LDA ($FF),Y\r", 2, "\xB1\xFF"},
  {"LDA $9A,X\r",   2, "\xB5\x9A"},
  {"LDA $BCDE,X\r", 3, "\xBD\xDE\xBC"},
  {"LDA $F012,Y\r", 3, "\xB9\x12\xF0"},
  {"*",0,""}
};

param_struct ldxdata[] = {
  {"LDX #$12\r",    2, "\xA2\x12"},
  {"LDX $3456\r",   3, "\xAE\x56\x34"},
  {"LDX $78\r",     2, "\xA6\x78"},
  {"LDX $F012,Y\r", 3, "\xBE\x12\xF0"},
  {"LDX $9A,Y\r",   2, "\xB6\x9A"},
  {"*",0,""}
};

param_struct ldydata[] = {
  {"LDY #$12\r",    2, "\xA0\x12"},
  {"LDY $3456\r",   3, "\xAC\x56\x34"},
  {"LDY $78\r",     2, "\xA4\x78"},
  {"LDY $9A,X\r",   2, "\xB4\x9A"},
  {"LDY $BCDE,X\r", 3, "\xBC\xDE\xBC"},
  {"*",0,""}
};

param_struct lsrdata[] = {
  {"LSR $0034\r",   3, "\x4E\x34\x00"},
  {"LSR $AB\r",     2, "\x46\xAB"},
  {"LSR\r",         1, "\x4A"},
  {"LSR $EF,X\r",   2, "\x56\xEF"},
  {"LSR $AB00,X\r", 3, "\x5E\x00\xAB"},
  {"*",0,""}
};

param_struct oradata[] = {
  {"ORA #$12\r",    2, "\x09\x12"},
  {"ORA $3456\r",   3, "\x0D\x56\x34"},
  {"ORA $78\r",     2, "\x05\x78"},
  {"ORA ($00,X)\r", 2, "\x01\x00"},
  {"ORA ($FF),Y\r", 2, "\x11\xFF"},
  {"ORA $9A,X\r",   2, "\x15\x9A"},
  {"ORA $BCDE,X\r", 3, "\x1D\xDE\xBC"},
  {"ORA $F012,Y\r", 3, "\x19\x12\xF0"},
  {"*",0,""}
};

param_struct roldata[] = {
  {"ROL $0034\r",   3, "\x2E\x34\x00"},
  {"ROL $AB\r",     2, "\x26\xAB"},
  {"ROL\r",         1, "\x2A"},
  {"ROL $EF,X\r",   2, "\x36\xEF"},
  {"ROL $AB00,X\r", 3, "\x3E\x00\xAB"},
  {"*",0,""}
};

param_struct rordata[] = {
  {"ROR $0034\r",   3, "\x6E\x34\x00"},
  {"ROR $AB\r",     2, "\x66\xAB"},
  {"ROR\r",         1, "\x6A"},
  {"ROR $EF,X\r",   2, "\x76\xEF"},
  {"ROR $AB00,X\r", 3, "\x7E\x00\xAB"},
  {"*",0,""}
};

param_struct sbcdata[] = {
  {"SBC #$12\r",    2, "\xE9\x12"},
  {"SBC $3456\r",   3, "\xED\x56\x34"},
  {"SBC $78\r",     2, "\xE5\x78"},
  {"SBC ($00,X)\r", 2, "\xE1\x00"},
  {"SBC ($FF),Y\r", 2, "\xF1\xFF"},
  {"SBC $9A,X\r",   2, "\xF5\x9A"},
  {"SBC $BCDE,X\r", 3, "\xFD\xDE\xBC"},
  {"SBC $F012,Y\r", 3, "\xF9\x12\xF0"},
  {"*",0,""}
};

param_struct stadata[] = {
  {"STA $3456\r",   3, "\x8D\x56\x34"},
  {"STA $78\r",     2, "\x85\x78"},
  {"STA ($00,X)\r", 2, "\x81\x00"},
  {"STA ($FF),Y\r", 2, "\x91\xFF"},
  {"STA $9A,X\r",   2, "\x95\x9A"},
  {"STA $BCDE,X\r", 3, "\x9D\xDE\xBC"},
  {"STA $F012,Y\r", 3, "\x99\x12\xF0"},
  {"*",0,""}
};

param_struct stxdata[] = {
  {"STX $3456\r",   3, "\x8E\x56\x34"},
  {"STX $78\r",     2, "\x86\x78"},
  {"STX $12,Y\r",   2, "\x96\x12"},
  {"*",0,""}
};

param_struct stydata[] = {
  {"STY $3456\r",   3, "\x8C\x56\x34"},
  {"STY $78\r",     2, "\x84\x78"},
  {"STY $9A,X\r",   2, "\x94\x9A"},
  {"*",0,""}
};


