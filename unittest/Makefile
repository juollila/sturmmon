CC = cc65
CA = ca65
LD = ld65
STURMSIM ?= ../../sturmsim/sturmsim

.PHONY: all test clean

all: test

test: unittest1 unittest2 unittest3 unittest4 unittest5
	$(STURMSIM) --lower-case --execution-address=0x80d unittest1
	$(STURMSIM) --lower-case --execution-address=0x80d unittest2
	$(STURMSIM) --lower-case --execution-address=0x80d unittest3
	$(STURMSIM) --lower-case --execution-address=0x80d unittest4
	$(STURMSIM) --lower-case --execution-address=0x80d unittest5

unittest1: unittest1.c lcut.c asmtest.c ../sturmmon.asm
	$(CC) unittest1.c -t c64
	$(CC) lcut.c -t c64
	$(CC) asmtest.c -t none
	$(CA) unittest1.s -t c64
	$(CA) lcut.s -t c64
	$(CA) ../sturmmon.asm -I .. -t none -DUNITTEST=1
	$(CA) asmtest.s -t none
	$(LD) unittest1.o -C unittest.cfg lcut.o ../sturmmon.o asmtest.o c64.lib -o unittest1

unittest2: unittest2.c lcut.c ../sturmmon.asm
	$(CC) unittest2.c -t c64
	$(CC) lcut.c -t c64
	$(CA) unittest2.s -t c64
	$(CA) lcut.s -t c64
	$(CA) ../sturmmon.asm -I .. -t none -DUNITTEST=1
	$(LD) unittest2.o -C unittest.cfg lcut.o ../sturmmon.o c64.lib -o unittest2

# 65c02
unittest3: unittest1.c lcut.c asmtest.c ../sturmmon.asm
	$(CC) unittest1.c -t c64
	$(CC) lcut.c -t c64
	$(CC) asmtest.c -t none
	$(CA) unittest1.s -t c64
	$(CA) lcut.s -t c64
	$(CA) asmtest.s -t none
	$(CA) ../sturmmon.asm -I .. -t none -DUNITTEST=1 -DCMOS=1 # 65C02
	$(LD) unittest1.o -C unittest.cfg lcut.o ../sturmmon.o asmtest.o c64.lib -o unittest3

unittest4: unittest-65c02.c lcut.c asmtest-65c02.c ../sturmmon.asm
	$(CC) unittest-65c02.c -t c64
	$(CC) lcut.c -t c64
	$(CC) asmtest-65c02.c -t none
	$(CA) unittest-65c02.s -t c64
	$(CA) lcut.s -t c64
	$(CA) asmtest-65c02.s -t none
	$(CA) ../sturmmon.asm -I .. -t none -DUNITTEST=1 -DCMOS=1
	$(LD) unittest-65c02.o -C unittest.cfg lcut.o ../sturmmon.o asmtest-65c02.o c64.lib -o unittest4

# disassembly unit tests
unittest5: unittest-dis.c lcut.c distest.c ../sturmmon.asm
	$(CC) unittest-dis.c -t c64
	$(CC) lcut.c -t c64
	$(CC) distest.c -t none
	$(CA) unittest-dis.s -t c64
	$(CA) lcut.s -t c64
	$(CA) distest.s -t none -DUNITEST=1
	$(CA) ../sturmmon.asm -I .. -t none -DUNITTEST=1 -DCMOS=1
	$(LD) unittest-dis.o -C unittest.cfg lcut.o ../sturmmon.o distest.o c64.lib -o unittest5

clean:
	rm -f *.s *.o unittest1 unittest2 unittest3 unittest4 unittest5
