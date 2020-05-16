
all: apple atari vic20rom c64 c64rom

apple:
	ca65 sturmmon.asm -t none -DAPPLE=1
	ld65 sturmmon.o -t none -o sturmmon.iic

atari:
	ca65 sturmmon.asm -t none -DATARI=1
	ld65 sturmmon.o -t none -o sturmmon.xex
	#cp sturmmon.exe /Applications/Atari800MacX/AtariExeFiles/
	atr sturmmon.atr put sturmmon.xex autorun.sys

vic20rom:
	ca65 sturmmon.asm -t none -DVICROM=1
	ld65 sturmmon.o -t none -o sturmmon.bin
	dd if=sturmmon.bin ibs=8k count=1 of=sturmmon-vic.bin conv=sync

c64:
	ca65 sturmmon.asm -t none -DC64=1
	ld65 sturmmon.o -t none -o sturmmon
c64rom:
	ca65 sturmmon.asm -t none -DC64=1 -DROM=1
	ld65 sturmmon.o -t none -o sturmmon.bin
	dd if=sturmmon.bin ibs=8k count=1 of=sturmmon-c64.bin conv=sync

clean:
	rm *.o sturmmon.iic sturmmon.xex sturmmon.bin sturmmon-vic.bin sturmmon-c64.bin sturmmon

