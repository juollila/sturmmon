#include "lcut.h"
#include "conio.h"
#include "stdio.h"
#include "string.h"
#include "peekpoke.h"

#define SRC    ((unsigned int*)  0x03)
#define START  ((unsigned int*)  0x03)
#define SRC2   ((unsigned int*)  0x05)
#define DST    ((unsigned int*)  0x05)
#define END    ((unsigned int*)  0x334)
#define CNT    ((unsigned int*)  0x337)
#define VALUE  ((unsigned char*) 0x33A)
#define SCREEN ((unsigned char*) 0x400)
#define BUFFER ((unsigned char*) 0x200)
#define FNAME  ((unsigned char*) 0x240)
#define DEVICE ((unsigned char*) 0x339) 

unsigned int __fastcall__ memcmpvec(void);
unsigned int __fastcall__ memcpyvec(void);
unsigned int __fastcall__ memsetvec(void);
unsigned int __fastcall__ findvec(void);
unsigned int __fastcall__ loadvec(void);
unsigned int __fastcall__ savevec(void);

// char area1[512], area2[512];

void tc_memcmp1(lcut_tc_t *tc, void *data) {
   int i;
   char expected[9] = {0x43, 0x45, 0x30, 0x30, 0x20, 0x43, 0x45, 0x30, 0x46};

   /* compare starts */
   #define CMP1 ((unsigned char*)0xCE00)
   /* compare ends */
   #define CMP2 ((unsigned char*)0xCE0F)
   /* start address for comparing */
   #define CMP3 ((unsigned char*)0xCE10)

   printf("Press any key to start test.\n");
   cgetc();

   /* fill input values for the compare routine */
   *SRC  = (unsigned int)CMP1;
   *SRC2 = (unsigned int)CMP3;
   *END  = (unsigned int)CMP2;

   /* generate data to be compared */
   for(i=0; i<16; i++) {
      CMP1[i]='*';
      CMP3[i]='*';
   }
   CMP3[0] = 0;
   CMP3[15] = 0xff;

   clrscr();
   memcmpvec();

   // check the output of routine
   for(i=0; i<8; i++) LCUT_INT_EQUAL(tc, expected[i], SCREEN[i]);
}

void tc_memcmp2(lcut_tc_t *tc, void *data) {
   int i;
   char expected2[9] = {0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20};

   /* compare starts */
   #undef CMP1
   #define CMP1 ((unsigned char*)0xE000)
   /* compare ends */
   #undef CMP2
   #define CMP2 ((unsigned char*)0xEFFF)
   /* start address for comparing */
   #undef CMP3
   #define CMP3 ((unsigned char*)0xE000)

   printf("Press any key to start test.\n");
   cgetc();

   /* fill input values for the compare routine */
   *SRC  = (unsigned int)CMP1;
   *SRC2 = (unsigned int)CMP3;
   *END  = (unsigned int)CMP2;

   clrscr();
   memcmpvec();

   // check the output of routine
   for(i=0; i<9; i++) LCUT_INT_EQUAL(tc, expected2[i], SCREEN[i]);
}

void tc_memcpy1(lcut_tc_t *tc, void *data) {
   /* fill input values for the copy routine */
   *SRC = (unsigned int)0xFE01;
   *DST = (unsigned int)0xCE01;
   *CNT = (unsigned int)0x1FE;

   memset(0xCE00,0x12,0x200);

   memcpyvec();

   // compare memory areas
   LCUT_INT_EQUAL(tc, 0, memcmp(0xFE01, 0xCE01, 0x1FE));
   // check boundaries
   LCUT_INT_EQUAL(tc, 0x12, PEEK(0xCE00));
   LCUT_INT_EQUAL(tc, 0x12, PEEK(0xCFFF));

}

void tc_memcpy2(lcut_tc_t *tc, void *data) {
   /* fill input values for the copy routine */
   *SRC = (unsigned int)0xCE10;
   *DST = (unsigned int)0xCE20;
   *CNT = (unsigned int)0x10;

   POKE(0xCE0F,0x12);
   POKE(0xCE30,0x12);

   memcpyvec();

   // compare memory areas
   LCUT_INT_EQUAL(tc, 0, memcmp(0xCE10, 0xCE20, 0x10));
   // check boundaries
   LCUT_INT_EQUAL(tc, 0x12, PEEK(0xCE0F));
   LCUT_INT_EQUAL(tc, 0x12, PEEK(0xCE30));

}

void tc_memset1(lcut_tc_t *tc, void *data) {
   int i;
   /* fill input values for the set routine */
   *DST = (unsigned int)0xCE01;
   *CNT = (unsigned int)0x1FE;
   *VALUE=(unsigned char)0xAA;

   memset(0xCE00,0x12,0x200);

   memsetvec();

   // check that area was filled
   for(i=0xCE01;i<0xCFFF;i++) {
      //printf("%x\n",i);
      LCUT_INT_EQUAL(tc, 0xAA, PEEK(i));
   }
   // check boundaries
   LCUT_INT_EQUAL(tc, 0x12, PEEK(0xCE00));
   LCUT_INT_EQUAL(tc, 0x12, PEEK(0xCFFF));
}

void tc_find1(lcut_tc_t *tc, void *data) {
   int i;
   /* a string to be searched, can be found at the end of c64 kernal rom */
   char string[8] = {0xf6, 0x6c, 0x28, 0x03, 0x6c, 0x2a, 0x03, 0x6c};

   /* fill input values for the find routine */
   *START = (unsigned int)0xF000;
   *END = (unsigned int)0xFFFF;
   *CNT = (unsigned int)0x8;
   memcpy(BUFFER, &string[0], 8);

   findvec();

   // check address 
   LCUT_INT_EQUAL(tc, (unsigned int)0xFFE0, *START);
}

void tc_save1(lcut_tc_t *tc, void *data) {
   FILE *testFile;
   int i, j, length;
   char filename[8] = {'t','e','s','t','.','b','i','n'};

   /* fill input values for the save routine */
   *START = (unsigned int)0xCE00;
   *END   = (unsigned int)0xCF00;
   *CNT = (unsigned int)0x8;
   *DEVICE = (unsigned char)0x8;

   memcpy(FNAME,&filename[0],*CNT);

   j=0;
   for(i=0xCE00; i<0xCF00; i++) POKE(i, j++);

   savevec();

   /* read the saved file */
   testFile = fopen("test.bin", "rb");
   length = fread((unsigned char *)0xCF00, 1, 0x2, testFile); /* start address */
   length = fread((unsigned char *)0xCF00, 1, 0x200, testFile);
   fclose(testFile);
   // compare memory areas
   LCUT_INT_EQUAL(tc, 0, memcmp(0xCE00, 0xCF00, 0x100));
   // check length
   LCUT_INT_EQUAL(tc, 0x100, length);

}

void tc_load1(lcut_tc_t *tc, void *data) {
   FILE *testFile;
   int length;
   char filename[8] = {'t','e','s','t','.','b','i','n'};

   /* fill input values for the save routine */
   *START = (unsigned int)0xCE00;
   *CNT = (unsigned int)0x8;
   *DEVICE = (unsigned char)0x8;

   memcpy(FNAME,&filename[0],*CNT);

   memset(0xCE00,0x12,0x200);

   loadvec();

   /* read the saved file */
   testFile = fopen("test.bin", "rb");
   length = fread((unsigned char *)0xCF00, 1, 0x2, testFile); /* start address */
   length = fread((unsigned char *)0xCF00, 1, 0x200, testFile);
   fclose(testFile);

   // compare memory areas
   LCUT_INT_EQUAL(tc, 0, memcmp(0xCE00, 0xCF00, 0x100));
   // check length
   LCUT_INT_EQUAL(tc, 0x100, length);

}

unsigned char testSuite[10] = {'*', '*', '*', '*', '*', '*', '*', '*', '*', '*'};

void printSuites() {
   clrscr();
   gotoxy(0,0);
   cprintf("Select assembler test suites:\r\n");
   cprintf("(1) memcmp   (%c)\r\n", testSuite[0]);
   cprintf("(2) memcpy   (%c)\r\n", testSuite[1]);
   cprintf("(3) memset   (%c)\r\n", testSuite[2]);
   cprintf("(4) find     (%c)\r\n", testSuite[3]);
   cprintf("(5) file     (%c)\r\n", testSuite[4]);
   cprintf("(R)un selected test suites\r\n");
}

void main() {
   lcut_ts_t *suiteCmp = NULL;
   lcut_ts_t *suiteCpy = NULL;
   lcut_ts_t *suiteSet = NULL;
   lcut_ts_t *suiteFind = NULL;
   lcut_ts_t *suiteFile = NULL;
   unsigned char key = NULL;
   LCUT_TEST_BEGIN("SturmMON - Routines", NULL, NULL);

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
      printSuites();
   }while(key!='r'&&key!='R');

   if(testSuite[0]=='*') {
      LCUT_TS_INIT(suiteCmp, "memcmp", NULL, NULL);
      LCUT_TC_ADD(suiteCmp, "memcmp 1", tc_memcmp1, NULL, NULL, NULL);
      LCUT_TC_ADD(suiteCmp, "memcmp 2", tc_memcmp2, NULL, NULL, NULL);
      LCUT_TS_ADD(suiteCmp);
   }

   if(testSuite[1]=='*') {
      LCUT_TS_INIT(suiteCpy, "memcpy", NULL, NULL);
      LCUT_TC_ADD(suiteCpy, "memcpy 1", tc_memcpy1, NULL, NULL, NULL);
      LCUT_TC_ADD(suiteCpy, "memcpy 2", tc_memcpy2, NULL, NULL, NULL);
      LCUT_TS_ADD(suiteCpy);
   }

   if(testSuite[2]=='*') {
      LCUT_TS_INIT(suiteSet, "memset", NULL, NULL);
      LCUT_TC_ADD(suiteSet, "memset 1", tc_memset1, NULL, NULL, NULL);
      LCUT_TS_ADD(suiteSet);
   }

   if(testSuite[3]=='*') {
      LCUT_TS_INIT(suiteFind, "find", NULL, NULL);
      LCUT_TC_ADD(suiteFind, "find 1", tc_find1, NULL, NULL, NULL);
      LCUT_TS_ADD(suiteFind);
   }

   if(testSuite[4]=='*') {
      LCUT_TS_INIT(suiteFile, "file", NULL, NULL);
      LCUT_TC_ADD(suiteFile, "save 1", tc_save1, NULL, NULL, NULL);
      LCUT_TC_ADD(suiteFile, "load 1", tc_save1, NULL, NULL, NULL);
      LCUT_TS_ADD(suiteFile);
   }

   LCUT_TEST_RUN();
   LCUT_TEST_REPORT();
   LCUT_TEST_END();

   LCUT_TEST_RESULT();
}
