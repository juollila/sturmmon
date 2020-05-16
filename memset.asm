; Memset routine
; Coded by Juha Ollila
; Aug 2  2017 Initial version
; Nov 2	 2017 Corrected bug (uninitialized y register)

memset:
@memset1:
	ldy	#0
	lda	cnt
	ora	cnt+1
	beq	@exit
	lda	value
	sta	(dst),y
@memset2:
	inc	dst
	bne	@memset3
	inc	dst+1
@memset3:
	dec	cnt
	lda	cnt
	cmp	#$ff
	bne	@memset4
	dec	cnt+1
@memset4:
	sec
	bcs	@memset1
@exit:
	rts

