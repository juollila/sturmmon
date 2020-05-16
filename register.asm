; Register file routines
; Coded by Juha Ollila
;
; Oct 29 2017 Initial version
; Jan 07 2018 Atari support

showregisters:
	jsr	primm
	.byte	eol,"   PC  SR AC XR YR SP",eol,"; ",$0
	ldy	regs+6
	lda	regs+5
	jsr	printword
	ldx	#4
@show1:	jsr	printspc
	lda	regs,x
	jsr	printbyte
	dex
	bpl	@show1
	jsr	printcr
	rts

changeregisters:
	rts

initregisters:
	tsx
	inx		; performed from subroutine so sp must be adjusted
	inx
	stx	regs
	lda	#0
	sta	regs+1
	sta	regs+2
	sta	regs+3
	sta	regs+4
	lda	#<_mainvec
	sta	regs+5
	lda	#>_mainvec
	sta	regs+6
	rts

modifyregisters:
	rts
