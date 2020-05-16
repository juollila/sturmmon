; Apple file routines
; Coded by Juha Ollila
;
; Jun 25 2019 Initial version.

loadfile:
	; disable prodos memory protection
	lda	#0
	ldx	#0
@disable:
	sta	bitmap,x
	inx
	cpx	#bitmaplen
	bne	@disable
	;
	ldx	#0
@load1:	lda	@loadcommand,x	; copy BLOAD
	beq	loadfile2
	ora	#$80
	sta	cmdbuf,x
	inx
	bne	@load1
	beq	loadfile2
@loadcommand:
	.byte	"BLOAD",0

savefile:
	ldx	#0
@save1:	lda	@savecommand,x	; copy BSAVE
	beq	loadfile2
	ora	#$80
	sta	cmdbuf,x
	inx
	bne	@save1
	beq	loadfile2
@savecommand:
	.byte	"BSAVE",0

loadfile2:
@save2:	ldy	#0
@save3:	lda	fname,y		; copy file name and parameters
	ora	#$80
	sta	cmdbuf,x
	inx
	iny
	cpy	cnt
	bne	@save3
	lda	#eol
	ora	#$80
	sta	cmdbuf,x
	jsr	doscmd
	bcc	@noerror
	jsr	prerr
@noerror:
	rts
