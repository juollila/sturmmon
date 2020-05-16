cc65 unittest.c -t c64
cc65 lcut.c -t c64
cc65 asmtest.c -t none

ca65 unittest.s -t c64
ca65 lcut.s -t c64
ca65 ../asm.asm -I .. -t none -DUNITTEST=1
ca65 asmtest.s -t none

ld65 unittest.o -C unittest.cfg lcut.o ../asm.o asmtest.o c64.lib -o unittest1

cc65 unittest2.c -t c64

ca65 unittest2.s -t c64
ca65 ../sturmmon.asm -I .. -t c64 -DUNITTEST=1

ld65 unittest2.o -C unittest.cfg lcut.o ../sturmmon.o c64.lib -o unittest2

# 65c02
cc65 unittest-65c02.c -t c64
cc65 asmtest-65c02.c -t none

ca65 unittest-65c02.s -t c64
ca65 asmtest-65c02.s -t none
ca65 ../asm.asm -I .. -t none -DUNITTEST=1 -DCMOS=1

ld65 unittest.o -C unittest.cfg lcut.o ../asm.o asmtest.o c64.lib -o unittest3

ld65 unittest-65c02.o -C unittest.cfg lcut.o ../asm.o asmtest-65c02.o c64.lib -o unittest4

# disassembly unit tests
cc65 unittest-dis.c -t c64
cc65 distest.c -t none

ca65 unittest-dis.s -t c64
ca65 distest.s -t none -DUNITEST=1
ca65 ../dis.asm -I .. -t none -DUNITTEST=1 -DCMOS=1

ld65 unittest-dis.o -C unittest.cfg lcut.o ../dis.o distest.o c64.lib -o unittest5
 
