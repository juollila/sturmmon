#define BUFFER ((unsigned char*)0x200)
#define PC ((unsigned int*)0x05)
typedef struct param_struct {
   char *input;
   unsigned int length;
   char *result;
}param_struct;

unsigned int __fastcall__ asmtest(void);

extern param_struct zpmdata[];
extern param_struct bitdata[];
extern param_struct decdata[];
extern param_struct jmpdata[];
extern param_struct bradata[];
extern param_struct phxdata[];
extern param_struct stzdata[];
extern param_struct trbdata[];
extern param_struct tsbdata[];

