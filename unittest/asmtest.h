#define BUFFER ((unsigned char*)0x200)
#define PC ((unsigned int*)0x05)
typedef struct param_struct {
   char *input;
   unsigned int length;
   char *result;
}param_struct;

unsigned int __fastcall__ asmtest(void);

extern param_struct adcdata[];
extern param_struct anddata[];
extern param_struct asldata[];
extern param_struct bradata[];
extern param_struct bitdata[];
extern param_struct impdata[];
extern param_struct cmpdata[];
extern param_struct cpxdata[];
extern param_struct cpydata[];
extern param_struct decdata[];
extern param_struct eordata[];
extern param_struct incdata[];
extern param_struct jmpdata[];
extern param_struct ldadata[];
extern param_struct ldxdata[];
extern param_struct ldydata[];
extern param_struct lsrdata[];
extern param_struct oradata[];
extern param_struct roldata[];
extern param_struct rordata[];
extern param_struct sbcdata[];
extern param_struct stadata[];
extern param_struct stxdata[];
extern param_struct stydata[];
