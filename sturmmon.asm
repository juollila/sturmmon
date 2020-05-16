; SturmMon - Machine language monitor for 6502
; Coded by Juha Ollila
;
; Aug 6  2017 - Initial version
; Oct 14 2017 - Defines were moved to a separate file
; Oct 28 2017 - Modified unit test interface
; Nov 11 2017 - VIC-20 autostart support
; Jan 7  2018 - Atari 8-bit support
; Jun 24 2019 - Apple II support
; Jul 11 2019 - Commodore 64's cartridge support
;

.ifndef UNITTEST
	.setcpu	"6502"
.endif

.ifdef VICROM
	COMMODORE = 20
	.org	$a000
.endif

.ifdef C64
	COMMODORE = 64
.ifdef	ROM
	.org	$8000
.else
	.org	$8000-2
	.word	*+2	; start address
.endif
.endif

.ifdef ATARI
	; dos compound file headers
	.org	$2e0-6	; run address - 6
	.word	$ffff
	.word	$2e0
	.word	$2e1
	.word	$8000	; start address

	.org	$8000-6 ; start address - 6
	.word	$ffff
	.word	_mainvec
	.word	_endaddr
.endif

.ifdef APPLE
	.org	$7600
	CMOS	= 1
.endif


.ifdef	UNITTEST
	.include "define.asm"
.endif
.ifdef	COMMODORE
	.include "define.asm"
.endif
.ifdef	ATARI
	.include "atari-define.asm"
.endif
.ifdef	APPLE
	.include "apple-define.asm"
.endif
	

; for unit tests
.ifdef UNITTEST
	.export _memcmpvec
	.export _memcpyvec
	.export	_memsetvec
	.export	_findvec
	.export	_dumpvec
	.export _loadvec
	.export _savevec
.endif

.ifdef C64
.ifdef ROM
	.word	@autostart
	.word	brkroutine
	.byte	$c3, $c2, $cd, "80"	; CBM8O
@autostart:
	stx	$d016	; set up screen control register 2
	jsr	$fda3	; initialize I/O devices
	jsr	$fd50	; RAM test and find RAM end
	jsr	$fd15	; restore default I/O vectors
	jsr	$ff5b	; initialize screen
	cli		; enable interrupts
.endif
.endif

.ifdef VICROM
	.word	@autostart
	.word	brkroutine
	.byte	"A0",$c3,$c2,$cd	; A0CBM
@autostart:
	jsr	$fd8d		; initialise and test RAM
	jsr	$fd52		; restore default I/O vectors
	jsr	$fdf9		; initialize I/O registers
	jsr	$e518		; initialise hardware
	cli			; enable interrupts
.endif

; jump table

.ifndef	UNITTEST
_mainvec:
	jmp	main
_disvec:
	jmp	disasm
_asmvec:
	jmp	asm
.endif
_memcmpvec:
	jmp	memcmp
_memcpyvec:
	jmp	memcpy
_memsetvec:
	jmp	memset
_findvec:
	jmp	hunt
_dumpvec:
	jmp	dump
_loadvec:
	jmp	loadfile
_savevec:
	jmp	savefile

.ifndef UNITTEST
main:
.ifndef APPLE
	; install brk vector
	jsr	installbrk
.endif
	; set registers
	jsr	initregisters
	jsr	primm
	.byte	eol,"STURMMON V0.14",eol,0
main2:
	cld
.endif

.ifdef COMMODORE
	; enable kernal messages
	lda	#$80
	jsr	setmsg
.endif

.ifdef ATARI
	lda	#0	; set text margins
	sta	lmargn
	lda	#39
	sta	rmargn
.endif

.ifndef UNITTEST
	jsr	showregisters
	jmp	commandloop	
.endif
	

.ifndef UNITTEST	
	.include "memcmp.asm"
	.include "memcpy.asm"
	.include "memset.asm"
	.include "find.asm"
	.include "dump.asm"
	.include "dis.asm"
	.include "asm.asm"
	.include "petscii.asm"
	.include "go.asm"
	.include "register.asm"
	.include "parser.asm"
.ifdef	CMOS
	.include "65c02.asm"
.else
	.include "6502.asm"
.endif
.else
	.include "memcmp.asm"
	.include "memcpy.asm"
	.include "memset.asm"
	.include "find.asm"
	.include "dump.asm"
	.include "petscii.asm"
	.include "file.asm"
.endif

.ifdef	COMMODORE
	.include "file.asm"
.endif
.ifdef	ATARI
	.include "atari-io.asm"
	.include "atari-file.asm"
.endif
.ifdef	APPLE
	.include "apple-io.asm"
	.include "apple-file.asm"
.endif
_endaddr:	.byte 0

