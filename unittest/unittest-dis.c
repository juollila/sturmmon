#include "lcut.h"
#include "conio.h"
#include "stdio.h"
#include "string.h"

#include "distest.h"

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
   int i, start, length;

   cprintf("\r\nPress any key.\r\n");
   cgetc();
   //for(i=0; i<16; i++) SCREEN[i]='*';
   // *PC = (unsigned int)&result[0];
   // start = *PC;
   length = ((struct param_struct *)data)->length;
   strcpy(BUFFER, ((struct param_struct *)data)->input);

   distest();

   // check a number of bytes in output
   // LCUT_INT_EQUAL(tc, length, *PC-start);
   // check object code
   for(i=0; i<length; i++) LCUT_INT_EQUAL(tc, ((struct param_struct *)data)->result[i], petscii(SCREEN[i]));
   LCUT_INT_EQUAL(tc, ((struct param_struct *)data)->pc, *PC);
}

unsigned char testSuite[1] = {'*'};

void printSuites() {
   clrscr();
   gotoxy(0,0);
   cprintf("Select disassembler test suites:\r\n");
   cprintf("(1) addressing modes (%c)\r\n", testSuite[0]);
   cprintf("(R)un selected test suites\r\n");
}

void main() {
   int tcindex, i;
   char tctitle[64];
   lcut_ts_t *suiteDIS = NULL;
   unsigned char key = NULL;
   LCUT_TEST_BEGIN("SturmMON - disassembly", NULL, NULL);

   printSuites();
   do{
      key = cgetc();
      if(key == '1') if(testSuite[0]==' ') testSuite[0]='*'; else testSuite[0]=' ';
      printSuites();
   }while(key!='r'&&key!='R');

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
