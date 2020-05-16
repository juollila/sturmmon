#include "lcut.h"
#include "conio.h"
#include "stdio.h"
#include "string.h"

#include "asmtest.h"

char result[16];

/* generic test case for mnemonics */
void tc_assembler_test1(lcut_tc_t *tc, void *data) {
   int i, start, length;

   for(i=0; i<16; i++) result[i]='*';
   *PC = (unsigned int)&result[0];
   start = *PC;
   length = ((struct param_struct *)data)->length;
   strcpy(BUFFER, ((struct param_struct *)data)->input);

   asmtest();

   // check a number of bytes in output
   LCUT_INT_EQUAL(tc, length, *PC-start);
   // check object code
   for(i=0; i<length; i++) LCUT_INT_EQUAL(tc, ((struct param_struct *)data)->result[i], result[i]);
}

/* generic test case for branches */
void tc_assembler_test2(lcut_tc_t *tc, void *data) {
   int i, start, length;

   /* object code starts at $CE00 (fixed location) */
   #define CODE ((unsigned char*)0xCE00)

   for(i=0; i<16; i++) *(CODE+i)='*';
   *PC = (unsigned int)CODE;
   start = *PC;
   length = ((struct param_struct *)data)->length;
   strcpy(BUFFER, ((struct param_struct *)data)->input);

   asmtest();

   // check a number of bytes in output
   LCUT_INT_EQUAL(tc, length, *PC-start);
   // check object code
   for(i=0; i<length; i++) LCUT_INT_EQUAL(tc, ((struct param_struct *)data)->result[i], *(CODE+i));
}

unsigned char testSuite[18] = {'*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*'};

void printSuites() {
   clrscr();
   gotoxy(0,0);
   cprintf("Select assembler test suites:\r\n");
   cprintf("(1) ADC      (%c)\r\n", testSuite[0]);
   cprintf("(2) AND      (%c)\r\n", testSuite[1]);
   cprintf("(3) ASL      (%c)\r\n", testSuite[2]);
   cprintf("(4) Branches (%c)\r\n", testSuite[3]);
   cprintf("(5) BIT      (%c)\r\n", testSuite[4]);
   cprintf("(6) Implied  (%c)\r\n", testSuite[5]);
   cprintf("(7) Compares (%c)\r\n", testSuite[6]);
   cprintf("(8) DEC      (%c)\r\n", testSuite[7]);
   cprintf("(9) EOR      (%c)\r\n", testSuite[8]);
   cprintf("(0) INC      (%c)\r\n", testSuite[9]);
   cprintf("(A) Jumps    (%c)\r\n", testSuite[10]);
   cprintf("(B) Loads    (%c)\r\n", testSuite[11]);
   cprintf("(C) LSR      (%c)\r\n", testSuite[12]);
   cprintf("(D) ORA      (%c)\r\n", testSuite[13]);
   cprintf("(E) ROL      (%c)\r\n", testSuite[14]);
   cprintf("(F) ROR      (%c)\r\n", testSuite[15]);
   cprintf("(G) SBC      (%c)\r\n", testSuite[16]);
   cprintf("(H) Stores   (%c)\r\n", testSuite[17]);
   cprintf("(R)un selected test suites\r\n");
}

void main() {
   int tcindex, i;
   char tctitle[64];
   lcut_ts_t *suiteADC = NULL;
   lcut_ts_t *suiteAND = NULL;
   lcut_ts_t *suiteASL = NULL;
   lcut_ts_t *suiteBRA = NULL;
   lcut_ts_t *suiteBIT = NULL;
   lcut_ts_t *suiteIMP = NULL;
   lcut_ts_t *suiteCMP = NULL;
   lcut_ts_t *suiteDEC = NULL;
   lcut_ts_t *suiteEOR = NULL;
   lcut_ts_t *suiteINC = NULL;
   lcut_ts_t *suiteJMP = NULL;
   lcut_ts_t *suiteLDA = NULL;
   lcut_ts_t *suiteLSR = NULL;
   lcut_ts_t *suiteORA = NULL;
   lcut_ts_t *suiteROL = NULL;
   lcut_ts_t *suiteROR = NULL;
   lcut_ts_t *suiteSBC = NULL;
   lcut_ts_t *suiteSTA = NULL;
   unsigned char key = NULL;
   //char string[]= "ABC\r";
   //struct param_struct param;
   LCUT_TEST_BEGIN("SturmMON - Assembler", NULL, NULL);

   printSuites();
   do{
      key = cgetc();
      /*
      for(i=0;i<10;i++) {
         if(key == i+1) if(testSuite[i]==' ') testSuite[i]='*'; else testSuite[i]=' ';
      } */
      if(key == '1') if(testSuite[0]==' ') testSuite[0]='*'; else testSuite[0]=' ';
      if(key == '2') if(testSuite[1]==' ') testSuite[1]='*'; else testSuite[1]=' ';
      if(key == '3') if(testSuite[2]==' ') testSuite[2]='*'; else testSuite[2]=' ';
      if(key == '4') if(testSuite[3]==' ') testSuite[3]='*'; else testSuite[3]=' ';
      if(key == '5') if(testSuite[4]==' ') testSuite[4]='*'; else testSuite[4]=' ';
      if(key == '6') if(testSuite[5]==' ') testSuite[5]='*'; else testSuite[5]=' ';
      if(key == '7') if(testSuite[6]==' ') testSuite[6]='*'; else testSuite[6]=' ';
      if(key == '8') if(testSuite[7]==' ') testSuite[7]='*'; else testSuite[7]=' ';
      if(key == '9') if(testSuite[8]==' ') testSuite[8]='*'; else testSuite[8]=' ';
      if(key == '0') if(testSuite[9]==' ') testSuite[9]='*'; else testSuite[9]=' ';
      if(key == 'a'||key == 'A') if(testSuite[10]==' ') testSuite[10]='*'; else testSuite[10]=' ';
      if(key == 'b'||key == 'B') if(testSuite[11]==' ') testSuite[11]='*'; else testSuite[11]=' ';
      if(key == 'c'||key == 'C') if(testSuite[12]==' ') testSuite[12]='*'; else testSuite[12]=' ';
      if(key == 'd'||key == 'D') if(testSuite[13]==' ') testSuite[13]='*'; else testSuite[13]=' ';
      if(key == 'e'||key == 'E') if(testSuite[14]==' ') testSuite[14]='*'; else testSuite[14]=' ';
      if(key == 'f'||key == 'F') if(testSuite[15]==' ') testSuite[15]='*'; else testSuite[15]=' ';
      if(key == 'g'||key == 'G') if(testSuite[16]==' ') testSuite[16]='*'; else testSuite[16]=' ';
      if(key == 'h'||key == 'H') if(testSuite[17]==' ') testSuite[17]='*'; else testSuite[17]=' ';
      printSuites();
   }while(key!='r'&&key!='R');

   if(testSuite[0]=='*') {
      LCUT_TS_INIT(suiteADC, "Assembler - ADC", NULL, NULL);
      tcindex = 0;
      while (adcdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "ADC %d", (tcindex+1));
         LCUT_TC_ADD(suiteADC, tctitle, tc_assembler_test1, (void *)&adcdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteADC);
   }

   if(testSuite[1]=='*') {
      LCUT_TS_INIT(suiteAND, "Assembler - AND", NULL, NULL);
      tcindex = 0;
      while (anddata[tcindex].input[0]!='*') {
         sprintf(tctitle, "AND %d", (tcindex+1));
         LCUT_TC_ADD(suiteAND, tctitle, tc_assembler_test1, (void *)&anddata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteAND);
   }

   if(testSuite[2]=='*') {
      LCUT_TS_INIT(suiteASL, "Assembler - ASL", NULL, NULL);
      tcindex = 0;
      while (asldata[tcindex].input[0]!='*') {
         sprintf(tctitle, "ASL %d", (tcindex+1));
         LCUT_TC_ADD(suiteASL, tctitle, tc_assembler_test1, (void *)&asldata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteASL);
   }

   if(testSuite[3]=='*') {
      LCUT_TS_INIT(suiteBRA, "Assembler - branches", NULL, NULL);
      tcindex = 0;
      while (bradata[tcindex].input[0]!='*') {
         sprintf(tctitle, "Branch %d", (tcindex+1));
         LCUT_TC_ADD(suiteBRA, tctitle, tc_assembler_test2, (void *)&bradata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteBRA);
   }

   if(testSuite[4]=='*') {
      LCUT_TS_INIT(suiteBIT, "Assembler - BIT", NULL, NULL);
      tcindex = 0;
      while (bitdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "BIT %d", (tcindex+1));
         LCUT_TC_ADD(suiteBIT, tctitle, tc_assembler_test1, (void *)&bitdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteBIT);
   }

   if(testSuite[5]=='*') {
      LCUT_TS_INIT(suiteIMP, "Assembler - Implied", NULL, NULL);
      tcindex = 0;
      while (impdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "Implied %d", (tcindex+1));
         LCUT_TC_ADD(suiteIMP, tctitle, tc_assembler_test1, (void *)&impdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteIMP);
   }

   if(testSuite[6]=='*') {
      LCUT_TS_INIT(suiteCMP, "Assembler - Compares", NULL, NULL);
      tcindex = 0;
      while (cmpdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "CMP %d", (tcindex+1));
         LCUT_TC_ADD(suiteCMP, tctitle, tc_assembler_test1, (void *)&cmpdata[tcindex], NULL, NULL);
         tcindex++;
      }
      tcindex = 0;
      while (cpxdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "CPX %d", (tcindex+1));
         LCUT_TC_ADD(suiteCMP, tctitle, tc_assembler_test1, (void *)&cpxdata[tcindex], NULL, NULL);
         tcindex++;
      }
      tcindex = 0;
      while (cpydata[tcindex].input[0]!='*') {
         sprintf(tctitle, "CPY %d", (tcindex+1));
         LCUT_TC_ADD(suiteCMP, tctitle, tc_assembler_test1, (void *)&cpydata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteCMP);
   }

   if(testSuite[7]=='*') {
      LCUT_TS_INIT(suiteDEC, "Assembler - DEC", NULL, NULL);
      tcindex = 0;
      while (decdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "DEC %d", (tcindex+1));
         LCUT_TC_ADD(suiteDEC, tctitle, tc_assembler_test1, (void *)&decdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteDEC);
   }

   if(testSuite[8]=='*') {
      LCUT_TS_INIT(suiteEOR, "Assembler - EOR", NULL, NULL);
      tcindex = 0;
      while (eordata[tcindex].input[0]!='*') {
         sprintf(tctitle, "EOR %d", (tcindex+1));
         LCUT_TC_ADD(suiteEOR, tctitle, tc_assembler_test1, (void *)&eordata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteEOR);
   }

   if(testSuite[9]=='*') {
      LCUT_TS_INIT(suiteINC, "Assembler - INC", NULL, NULL);
      tcindex = 0;
      while (incdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "INC %d", (tcindex+1));
         LCUT_TC_ADD(suiteINC, tctitle, tc_assembler_test1, (void *)&incdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteINC);
   }

   if(testSuite[10]=='*') {
      LCUT_TS_INIT(suiteJMP, "Assembler - Jumps", NULL, NULL);
      tcindex = 0;
      while (jmpdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "Jump %d", (tcindex+1));
         LCUT_TC_ADD(suiteJMP, tctitle, tc_assembler_test1, (void *)&jmpdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteJMP);
   }

   if(testSuite[11]=='*') {
      LCUT_TS_INIT(suiteLDA, "Assembler - Loads", NULL, NULL);
      tcindex = 0;
      while (ldadata[tcindex].input[0]!='*') {
         sprintf(tctitle, "LDA %d", (tcindex+1));
         LCUT_TC_ADD(suiteLDA, tctitle, tc_assembler_test1, (void *)&ldadata[tcindex], NULL, NULL);
         tcindex++;
      }
      tcindex = 0;
      while (ldxdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "LDX %d", (tcindex+1));
         LCUT_TC_ADD(suiteLDA, tctitle, tc_assembler_test1, (void *)&ldxdata[tcindex], NULL, NULL);
         tcindex++;
      }
      tcindex = 0;
      while (ldydata[tcindex].input[0]!='*') {
         sprintf(tctitle, "LDY %d", (tcindex+1));
         LCUT_TC_ADD(suiteLDA, tctitle, tc_assembler_test1, (void *)&ldydata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteLDA);
   }

   if(testSuite[12]=='*') {
      LCUT_TS_INIT(suiteLSR, "Assembler - LSR", NULL, NULL);
      tcindex = 0;
      while (lsrdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "LSR %d", (tcindex+1));
         LCUT_TC_ADD(suiteLSR, tctitle, tc_assembler_test1, (void *)&lsrdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteLSR);
   }

   if(testSuite[13]=='*') {
      LCUT_TS_INIT(suiteORA, "Assembler - ORA", NULL, NULL);
      tcindex = 0;
      while (oradata[tcindex].input[0]!='*') {
         sprintf(tctitle, "ORA %d", (tcindex+1));
         LCUT_TC_ADD(suiteORA, tctitle, tc_assembler_test1, (void *)&oradata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteORA);
   }

   if(testSuite[14]=='*') {
      LCUT_TS_INIT(suiteROL, "Assembler - ROL", NULL, NULL);
      tcindex = 0;
      while (roldata[tcindex].input[0]!='*') {
         sprintf(tctitle, "ROL %d", (tcindex+1));
         LCUT_TC_ADD(suiteROL, tctitle, tc_assembler_test1, (void *)&roldata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteROL);
   }

   if(testSuite[15]=='*') {
      LCUT_TS_INIT(suiteROR, "Assembler - ROR", NULL, NULL);
      tcindex = 0;
      while (rordata[tcindex].input[0]!='*') {
         sprintf(tctitle, "ROR %d", (tcindex+1));
         LCUT_TC_ADD(suiteROR, tctitle, tc_assembler_test1, (void *)&rordata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteROR);
   }

   if(testSuite[16]=='*') {
      LCUT_TS_INIT(suiteSBC, "Assembler - SBC", NULL, NULL);
      tcindex = 0;
      while (sbcdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "SBC %d", (tcindex+1));
         LCUT_TC_ADD(suiteSBC, tctitle, tc_assembler_test1, (void *)&sbcdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteSBC);
   }

   if(testSuite[17]=='*') {
      LCUT_TS_INIT(suiteSTA, "Assembler - Stores", NULL, NULL);
      tcindex = 0;
      while (stadata[tcindex].input[0]!='*') {
         sprintf(tctitle, "STA %d", (tcindex+1));
         LCUT_TC_ADD(suiteSTA, tctitle, tc_assembler_test1, (void *)&stadata[tcindex], NULL, NULL);
         tcindex++;
      }
      tcindex = 0;
      while (stxdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "STX %d", (tcindex+1));
         LCUT_TC_ADD(suiteSTA, tctitle, tc_assembler_test1, (void *)&stxdata[tcindex], NULL, NULL);
         tcindex++;
      }
      tcindex = 0;
      while (stydata[tcindex].input[0]!='*') {
         sprintf(tctitle, "STY %d", (tcindex+1));
         LCUT_TC_ADD(suiteSTA, tctitle, tc_assembler_test1, (void *)&stydata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteSTA);
   }

   LCUT_TEST_RUN();
   LCUT_TEST_REPORT();
   LCUT_TEST_END();

   LCUT_TEST_RESULT();
}
