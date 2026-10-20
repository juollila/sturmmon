#include "lcut.h"
#include "stdio.h"
#include "string.h"

#include "asmtest-65c02.h"

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

unsigned char testSuite[11] = {'*', '*', '*', '*', '*', '*', '*', '*', '*', '*', '*'};

void main() {
   int tcindex;
   char tctitle[64];
   lcut_ts_t *suiteZPM = NULL;
   lcut_ts_t *suiteBIT = NULL;
   lcut_ts_t *suiteDEC = NULL;
   lcut_ts_t *suiteJMP = NULL;
   lcut_ts_t *suiteBRA = NULL;
   lcut_ts_t *suitePHX = NULL;
   lcut_ts_t *suiteSTZ = NULL;
   lcut_ts_t *suiteTRB = NULL;
   lcut_ts_t *suiteTSB = NULL;
   lcut_ts_t *suiteRMB = NULL;
   lcut_ts_t *suiteSMB = NULL;
   unsigned char key = NULL;
   LCUT_TEST_BEGIN("SturmMON - 65c02", NULL, NULL);

   if(testSuite[0]=='*') {
      LCUT_TS_INIT(suiteZPM, "(ZP) mode", NULL, NULL);
      tcindex = 0;
      while (zpmdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "(ZP) mode %d", (tcindex+1));
         LCUT_TC_ADD(suiteZPM, tctitle, tc_assembler_test1, (void *)&zpmdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteZPM);
   }

   if(testSuite[1]=='*') {
      LCUT_TS_INIT(suiteBIT, "BIT", NULL, NULL);
      tcindex = 0;
      while (bitdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "BIT %d", (tcindex+1));
         LCUT_TC_ADD(suiteBIT, tctitle, tc_assembler_test1, (void *)&bitdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteBIT);
   }

   if(testSuite[2]=='*') {
      LCUT_TS_INIT(suiteDEC, "DEC & INC A", NULL, NULL);
      tcindex = 0;
      while (decdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "DEC & INC A %d", (tcindex+1));
         LCUT_TC_ADD(suiteDEC, tctitle, tc_assembler_test1, (void *)&decdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteDEC);
   }

   if(testSuite[3]=='*') {
      LCUT_TS_INIT(suiteJMP, "JMP (abs,X)", NULL, NULL);
      tcindex = 0;
      while (jmpdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "JMP (abs,X) %d", (tcindex+1));
         LCUT_TC_ADD(suiteJMP, tctitle, tc_assembler_test1, (void *)&jmpdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteJMP);
   }

   if(testSuite[4]=='*') {
      LCUT_TS_INIT(suiteBRA, "BRA", NULL, NULL);
      tcindex = 0;
      while (bradata[tcindex].input[0]!='*') {
         sprintf(tctitle, "BRA %d", (tcindex+1));
         LCUT_TC_ADD(suiteBRA, tctitle, tc_assembler_test2, (void *)&bradata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteBRA);
   }

   if(testSuite[5]=='*') {
      LCUT_TS_INIT(suitePHX, "Push & Pull X,Y", NULL, NULL);
      tcindex = 0;
      while (phxdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "Push & Pull X,Y %d", (tcindex+1));
         LCUT_TC_ADD(suitePHX, tctitle, tc_assembler_test1, (void *)&phxdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suitePHX);
   }

   if(testSuite[6]=='*') {
      LCUT_TS_INIT(suiteSTZ, "STZ", NULL, NULL);
      tcindex = 0;
      while (stzdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "STZ %d", (tcindex+1));
         LCUT_TC_ADD(suiteSTZ, tctitle, tc_assembler_test1, (void *)&stzdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteSTZ);
   }

   if(testSuite[7]=='*') {
      LCUT_TS_INIT(suiteTRB, "TRB", NULL, NULL);
      tcindex = 0;
      while (trbdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "TRB %d", (tcindex+1));
         LCUT_TC_ADD(suiteTRB, tctitle, tc_assembler_test1, (void *)&trbdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteTRB);
   }

   if(testSuite[8]=='*') {
      LCUT_TS_INIT(suiteTSB, "TSB", NULL, NULL);
      tcindex = 0;
      while (tsbdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "TSB %d", (tcindex+1));
         LCUT_TC_ADD(suiteTSB, tctitle, tc_assembler_test1, (void *)&tsbdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteTSB);
   }

   if(testSuite[9]=='*') {
      LCUT_TS_INIT(suiteRMB, "RMB", NULL, NULL);
      tcindex = 0;
      while (rmbdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "RMB %d", (tcindex+1));
         LCUT_TC_ADD(suiteRMB, tctitle, tc_assembler_test1, (void *)&rmbdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteRMB);
   }

   if(testSuite[10]=='*') {
      LCUT_TS_INIT(suiteSMB, "SMB", NULL, NULL);
      tcindex = 0;
      while (smbdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "SMB %d", (tcindex+1));
         LCUT_TC_ADD(suiteSMB, tctitle, tc_assembler_test1, (void *)&smbdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteSMB);
   }

   LCUT_TEST_RUN();
   LCUT_TEST_REPORT();
   LCUT_TEST_END();

   LCUT_TEST_RESULT();
}
