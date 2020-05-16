; Go and brk related routines
; Coded by Juha Ollila
;
; Oct 29 2017 Initial version.
; Nov 02 2017 Jump to subroutine was modified.
; Jan 07 2018 Atari support.
; Jan 12 2018 Atari's breakroutine was fixed.
; Jun 24 2019 Apple support.
; Jun 26 2019 Bug fix: AC and SR were mixed up in @jsrmem2.

; go into the memory
;
gomem:
	lda	regs
	tax
	txs
	ldx	#6
@go1:	lda	regs,x
	pha
	dex
	bne	@go1
	pla
	tay
	pla
	tax
	pla
	rti

.ifndef APPLE
; install the break vector
;
installbrk:
	lda	#<brkroutine
	sta	brkvec
	lda	#>brkroutine
	sta	brkvec+1
	rts

; brk exception
;
brkroutine:
.ifdef COMMODORE
	; save registers (sp,y,x,a,sr,pc) 7 bytes
	ldx	#1
.endif
.ifdef ATARI
	sty	regs+1
	stx	regs+2
	ldx	#3
.endif
@brk1:	pla
	sta	regs,x
	inx
	cpx	#7
	bne	@brk1
	tsx
	stx	regs
	; enable interrupts
	cli
	jsr	primm
	.byte	eol,"BREAK",eol,$0
	jmp	main2
.endif

; jump to subroutine
;
jsrmem:
	; save return address
	lda	#>(@jsrmem2-1)
	pha
	lda	#<(@jsrmem2-1)
	pha
	; override stack pointer
	; otherwise rts would not work
	tsx
	stx	regs
	; jump
	jmp	gomem
@jsrmem2: ; do not remove this line!!!
	php
	sta	regs+3
	pla
	sta	regs+4
	txa
	sta	regs+2
	tya
	sta	regs+1
	tsx
	stx	regs
	jsr	primm
	.byte	eol,"RTS",eol,$0
	jsr	showregisters
	jmp	commandloop	
