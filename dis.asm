; Disassembler routines
; Coded by Juha Ollila
;
; Aug 05 2017 Initial version
; Aug 06 2017 Modified to be used with the main program
; Oct 30 2017 Disassembly mode was added.
; Oct 31 2017 Disassembly output was modified so that hex dump bytes
;             can be discarded when assembled with "." or A command.
; Jan 07 2018 Atari support.
; Jan 12 2018 Fixed a bug in the handling of absolute y mode.
; Jun 24 2019 Apple support.
; Jun 26 2019 65c02 support.
; Jun 26 2019 Bug fix: In indirect mode, PC was not incremented.
; Jun 28 2019 Partial unit test support.
; Jun 29 2019 Opcode parsing was a little bit optimized.
; Jun 30 2019 If no end address then fixed number of lines are shown.

.ifdef UNITTEST
	.export	_distest
        .include "define.asm"
	.include "65c02.asm"
	.include "petscii.asm"
.endif

; disasm disassembles memory from start address to end address
;
disasm:
	lda	cnt
	beq	@disasm0
	dec	cnt
	beq	@exit
	bne	@line
@disasm0:
	; check if end address is reached
	lda	src+1
	cmp	end+1
	beq	@disasm1
	bcs	@exit
	bcc	@line
@disasm1:
	lda	src
	cmp	end
	beq	@line
	bcs	@exit
@line:	; print mode (A=assembly, .=disassembly)
	lda	mode
	jsr	chrout
	jsr	printspc
	; print address
	ldy	src+1
	lda	src
	jsr	printword
	; copy opcode + upto 2 parameter bytes
	ldy	#0
	lda	(src),y
	pha
	iny
	lda	(src),y
	pha
	iny
	lda	(src),y
	tay
	pla
	tax
	pla
	jsr	disopcode
	jsr	printcr
	sec
	bcs	disasm
@exit:
	rts

; disopcode disassembles the opcode + operand and prints it
; a = opcode
; x = operand (first byte)
; y = operand (second byte)
; does not change registers

.ifdef UNITTEST
_distest:
	lda	#0	; set pc
	sta	src
	sta	src+1
	lda	#$93	; clear screen
	jsr	chrout
	lda	$200	; set parameters
	ldx	$201
	ldy	$202
.endif

disopcode:
	; save registers
	pha
	txa
	pha
	tya
	pha
	lda	#0
	sta	opcode+1
	; opcode = opcode * 4
	tsx
	lda	$103,x
	sta	opcode
	asl	opcode
	rol	opcode+1
	asl	opcode
	rol	opcode+1
	; address = opcode table + opcode
	clc
	lda	#<opcodes
	adc	opcode
	sta	opcode
	lda	#>opcodes
	adc	opcode+1
	sta	opcode+1
	; print hex dump for opcode and operands
.ifdef C64
	jsr	@printdump
.endif
.ifdef ATARI
	jsr	@printdump
.endif
.ifdef APPLE
	jsr	@printdump
.endif
.ifndef UNITTEST
	jsr	printspc
.endif
	; print opcode
	ldy	#0
@disopcode1:
	lda	(opcode),y
	jsr	chrout
	iny
	cpy	#3
	bne	@disopcode1
	jsr	printspc
	; pc = pc + 1
	jsr	@updatepc1
	; get addressing mode
	lda	(opcode),y
.ifdef CMOS
	cmp	#14
.else
	cmp	#12
.endif
	bcs	@exit
	asl
	tay
	lda	@addrmodes+1,y
	pha
	lda	@addrmodes,y
	pha
	rts
@addrmodes:
	.word	@exit-1, @immediate-1, @zp-1, @zpx-1, @zpy-1
	.word	@absolute-1, @absolutex-1, @absolutey-1, @relative-1
	.word	@indx-1, @indy-1, @indirect-1
.ifdef CMOS
	.word	@zpindirect-1, @absindirectx-1
.endif
@exit:
.ifdef UNITTEST
	jsr	printcr
.endif
	; load registers
	pla
	tay
	pla
	tax
	pla
	rts

; handle immediate mode
@immediate:
	lda	#'#'
	jsr	chrout
	jsr	@printusd
	jsr	@printbyte
	jsr	@updatepc1
	jmp	@exit

; handle zero page mode
@zp:
	jsr	@printusd
	jsr	@printbyte
	jsr	@updatepc1
	jmp	@exit

; handle zero page x mode
@zpx:
	jsr	@printusd
	jsr	@printbyte
	jsr	@printx
	jsr	@updatepc1
	jmp	@exit

; handle zero page y mode
@zpy:
	jsr	@printusd
	jsr	@printbyte
	jsr	@printy
	jsr	@updatepc1
	jmp	@exit

; handle absolute mode
@absolute:
	jsr	@printusd
	jsr	@printword
	jsr	@updatepc2
	jmp	@exit

; handle absolute, x
@absolutex:
	jsr	@printusd
	jsr	@printword
	jsr	@printx
	jsr	@updatepc2
	jmp	@exit

; handle absolute, y
@absolutey:
	jsr	@printusd
	jsr	@printword
	jsr	@printy
	jsr	@updatepc2
	jmp	@exit

; handle relative
@relative:
	jsr	@printusd
	jsr	@updatepc1
	; calculate address
	tsx
	lda	$102,x
	cmp	#$80
	bcc	@pos
	clc
	adc	src
	tax
	lda	#$ff
	adc	src+1
	tay
	txa
	jsr	printword
	jmp	@exit
@pos:	clc
	adc	src
	tax
	lda	#0
	adc	src+1
	tay
	txa
	jsr	printword
	jmp	@exit

; handle indirect x
@indx:
	jsr	@printopen
	jsr	@printusd
	jsr	@printbyte
	jsr	@printx
	jsr	@printclose
	jsr	@updatepc1
	jmp	@exit

; handle indirect y
@indy:
	jsr	@printopen
	jsr	@printusd
	jsr	@printbyte
	jsr	@printclose
	jsr	@printy
	jsr	@updatepc1
	jmp	@exit

; handle indirect
@indirect:
	jsr	@printopen
	jsr	@printusd
	;jsr	@printabs
	jsr	@printword
	jsr	@printclose
	jsr	@updatepc2
	jmp	@exit

; handle zp indirect
@zpindirect:
	jsr	@printopen
	jsr	@printusd
	jsr	@printbyte
	jsr	@printclose
	jsr	@updatepc1
	jmp	@exit

; handle absolute indirect x
@absindirectx:
	jsr	@printopen
	jsr	@printusd
	jsr	@printword
	jsr	@printx
	jsr	@printclose
	jsr	@updatepc2
	jmp	@exit

.ifndef VICROM
; print hex dump for opcode and parameters
@printdump:
	jsr	printspc
.ifdef C64
	lda	#18		; rvs on
	jsr	chrout
	lda	#$a0		; shift+space
	jsr	chrout
.else
	lda	#$5b		; [
	jsr	chrout
.endif
	ldy	#3
	lda	(opcode),y
	beq	@printhex1	; branch if addressing mode = 0
	cmp	#5
	bcc	@printhex2	; branch if addressing mode <5 (i.e. 1-4)
	cmp	#8
	bcc	@printhex3	; branch if addressing mode <8 (i.e. 5-7)
	cmp	#11
	bcc	@printhex2	; branch if addressing mode <11 (i.e. 8-10)
	beq	@printhex3	; branch if addressing mode =11
	cmp	#12
	beq	@printhex2	; branch if addressing mode = 12
	cmp	#13
	beq	@printhex3	; branch if addressing mode = 13
	bne	@printhex1	; branch if addressing mode other than 13
;	bcs	@printhex1	; branch if addressing mode >=11 (i.e. 12)

@printhex1:
	ldy	#0
	lda	(src),y
	jsr	printbyte
	ldx	#4
	jmp	@printspaces

@printhex2:
	ldy	#0
	lda	(src),y
	jsr	printbyte
	iny
	lda	(src),y
	jsr	printbyte
	ldx	#2
	jmp	@printspaces

@printhex3:
	ldy	#0
	lda	(src),y
	jsr	printbyte
	iny
	lda	(src),y
	jsr	printbyte
	iny
	lda	(src),y
	jsr	printbyte
	jmp	@printspaces2

@printspaces:
	jsr	printspc
	dex
	bne	@printspaces
@printspaces2:
.ifdef C64
	lda	#$a0		; shift + space
	jsr	chrout
	lda	#146		; rvs off
	jsr	chrout
.else
	lda	#$5d		; ]
	jsr	chrout
.endif
	rts
.endif	
	
@printusd:
	lda	#'$'
	jsr	chrout
	rts

@printbyte:
	tsx
	lda	$104,x
	jsr	printbyte
	rts

@printword:
	tsx
	lda	$103,x
	tay
	lda	$104,x
	jsr	printword
	rts

@printx:
	lda	#','
	jsr	chrout
	lda	#'X'
	jsr	chrout
	rts

@printy:
	lda	#','
	jsr	chrout
	lda	#'Y'
	jsr	chrout
	rts

@printopen:
	lda	#'('
	jsr	chrout
	rts

@printclose:
	lda	#')'
	jsr	chrout
	rts

@updatepc1:
	lda	#1
	.byte	$2c
@updatepc2:
	lda	#2
	clc
	adc	src
	sta	src
	lda	src+1
	adc	#0
	sta	src+1
	rts
