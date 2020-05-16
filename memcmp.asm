; Compare memory routines
; Coded by Juha Ollila
; Oc 28 2017 Initial version

memcmp:
	; check if end address is reached
	lda	src+1
	cmp	end+1
	beq	@memcmp1
	bcs	@exit
	bcc	@memcmp2	; compare byte
@memcmp1:
	lda	src
	cmp	end
	beq	@memcmp2	; compare byte
	bcs	@exit
	; compare byte
@memcmp2:
	ldy	#0
	lda	(src),y
	cmp	(src2),y
	beq	@memcmp3	; branch if bytes are same
	; print address
	ldy	src+1
	lda	src
	jsr	printword
	lda	#' '
	jsr	chrout
	; update start address
@memcmp3:
	inc	src
	bne	@memcmp4
	inc	src+1
	; update compare address
@memcmp4:
	inc	src2
	bne	@memcmp5
	inc	src2+1
@memcmp5:
	sec
	bcs	memcmp
@exit:
	jsr	printcr
	rts
