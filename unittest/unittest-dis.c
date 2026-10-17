#include "lcut.h"
#include "stdio.h"
#include "string.h"

#include "distest.h"

unsigned int __fastcall__ init_ut_chrout(void);

char petscii(unsigned char code) {
   if(code<0x20) return code+0x40;
   if(code<0x40) return code;
   if(code<0x60) return code+0x80;
   if(code<0x80) return code+0x40;
   if(code<0xa0) return code-0x80;
   if(code<0xe0) return code-0xc0;
   return code;
}

/* generic test case for addressing modes */
void tc_dis_test1(lcut_tc_t *tc, void *data) {
   int i, length;

   length = ((struct param_struct *)data)->length;
   strcpy(BUFFER, ((struct param_struct *)data)->input);

   init_ut_chrout();
   distest();

   // check a number of bytes in output
   // LCUT_INT_EQUAL(tc, length, *PC-start);
   // check object code
   for(i=0; i<length; i++) LCUT_INT_EQUAL(tc, ((struct param_struct *)data)->result[i], SCREEN[i]);
   LCUT_INT_EQUAL(tc, ((struct param_struct *)data)->pc, *PC);
}

unsigned char testSuite[1] = {'*'};

void main() {
   int tcindex;
   char tctitle[64];
   lcut_ts_t *suiteDIS = NULL;
   unsigned char key = NULL;
   LCUT_TEST_BEGIN("SturmMON - disassembly", NULL, NULL);

   if(testSuite[0]=='*') {
      LCUT_TS_INIT(suiteDIS, "Addressing modes", NULL, NULL);
      tcindex = 0;
      while (disdata[tcindex].input[0]!='*') {
         sprintf(tctitle, "addressing mode %d", (tcindex+1));
         LCUT_TC_ADD(suiteDIS, tctitle, tc_dis_test1, (void *)&disdata[tcindex], NULL, NULL);
         tcindex++;
      }
      LCUT_TS_ADD(suiteDIS);
   }

   LCUT_TEST_RUN();
   LCUT_TEST_REPORT();
   LCUT_TEST_END();

   LCUT_TEST_RESULT();
}
