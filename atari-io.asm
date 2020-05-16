; Atari input/output routines
; Coded by Juha Ollila
;
; Jan 07 2018 Initial version
; Jan 12 2018 Optimizations

; Get one byte from the screen editor
chrin:
	pha			; will be overwritten later in the routine
	txa
	pha
	tya
	pha

	ldx	#iocb0
	lda	#getcmd
	sta	iccmd

	;jsr	setbuffer
	lda	#0		; set buffer length
	sta	icbll
	sta	icblh

	jsr	ciov
	tsx
	sta	$103,x	

	pla
	tay
	pla
	tax
	pla			; pull modified byte

	clc
	rts

; Write one byte to the screen editor
chrout:
	pha
	txa
	pha
	tya
	pha

	lda	#putcmd		; set put characters command
	sta	iccmd
	;jsr	setbuffer
	lda	#0		; set buffer length
	sta	icbll
	sta	icblh

	tsx
	lda	$103,x		; get byte from the stack

	ldx	#iocb0
	jsr	ciov

	pla
	tay
	pla
	tax
	pla

	clc

	rts

;setbuffer:
;	lda	#<iobyte	; set buffer address
;	sta	icbal
;	lda	#>iobyte
;	sta	icbah
;	lda	#1		; set buffer length
;	sta	icbll
;	lda	#0
;	sta	icblh
;	rts

; Plot routine
; Set the cursor position if the carry flag is clear.
; Read cursor position if the carry flag is set.
plot:
	bcc	@set
	ldx	rowcrs
	ldy	colcrs
@set:
	stx	rowcrs
	sty	colcrs
	rts
