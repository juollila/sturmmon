#define BUFFER ((unsigned char*)0x200)
#define SCREEN ((unsigned char*)0x400)
#define PC ((unsigned int*)0x03)
typedef struct param_struct {
   char *input;
   unsigned int length;
   char *result;
   unsigned int pc;
}param_struct;

unsigned int __fastcall__ distest(void);

extern param_struct disdata[];

