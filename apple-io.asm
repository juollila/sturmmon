; Apple input/output routines
; Coded by Juha Ollila
;
; Jun 24 2019 Initial version

; Get one byte from the screen editor
chrin:
	pha			; will be overwritten later in the routine
	txa
	pha
	tya
	pha

	jsr	rdkey
	and	#$7f
;	cmp	#$61		; check if lower case
;	bcc	@chrin1
;	cmp	#$7b
;	bcs	@chrin1
;	and	#$5f		; to upper case
;@chrin1:
	tsx
	sta	$103,x
	cmp	#rubout
	bne	@chrin2
	lda	#backspace
@chrin2:
	cmp	#eol
	beq	@chrin3
	jsr	chrout
@chrin3:

	pla
	tay
	pla
	tax
	pla			; pull modified byte

	clc
	rts

; Write one byte to the screen editor
chrout:
	ora	#$80
	jsr	cout
	clc
	rts


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
	jsr	vtab
	rts

; To upper case
upper:
	cmp	#$61		; check if lower case
	bcc	@upper1
	cmp	#$7b
	bcs	@upper1
	and	#$5f		; to upper case
@upper1:
	rts
