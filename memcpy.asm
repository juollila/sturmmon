; Memory copy routines
; Coded by Juha Ollila Jul 31 2017

; memcpy copies cnt bytes from src to dst.
; cnt, src, dst are words in zero page.
memcpy:
	ldy	#0
	lda	src+1
	cmp	dst+1
	bcs	@copy1 ; branch if high(src) >= high(dst)
	bcc	@copy3 ; branch if high(src) < high(dst)

@copy1:
	bne	@copy2 ; branch if high(src) > high(dst)
	lda	src
	cmp	dst
	bcs	@copy2 ; branch if low(src) >= low(dst)
	bcc	@copy3 ; branch if low(src < low(dst)

	lda	#'A'
	jsr	chrout
	rts

@copy2:
@copy2a:
	lda	cnt
	ora	cnt+1
	beq	@exit
	lda	(src),y
	sta	(dst),y
	inc	src
	bne	@copy2b
	inc	src+1
@copy2b:
	inc	dst
	bne	@copy2c
	inc	dst+1
@copy2c:
	dec	cnt
	lda	cnt
	cmp	#$ff
	bne	@copy2d
	dec	cnt+1
@copy2d:
	sec
	bcs	@copy2a
		
@copy3:
	clc
	lda	src
	adc	cnt
	sta	src
	lda	src+1
	adc	cnt+1
	sta	src+1
	clc
	lda	dst
	adc	cnt
	sta	dst
	lda	dst+1
	adc	cnt+1
	sta	dst+1
@copy3a:
	lda	cnt
	ora	cnt+1
	beq	@exit

	dec	src
	lda	src
	cmp	#$ff
	bne	@copy3b
	dec	src+1
@copy3b:
	dec	dst
	lda	dst
	cmp	#$ff
	bne	@copy3c
	dec	dst+1
@copy3c:
	lda	(src),y
	sta	(dst),y
	dec	cnt
	lda	cnt
	cmp	#$ff
	bne	@copy3d
	dec	cnt+1
@copy3d:
	sec
	bcs	@copy3a

@exit:
	rts
