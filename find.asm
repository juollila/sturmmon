; Find routines
; Coded by Juha Ollila
;
; Aug 3 2017 Initial version
; Aug 6 2017 Modified so that can be used with the main program

; hunt routine try to find a byte or string.
; Memory is scanned from start address to end address.
; Carry is clear if found, carry is set if not found.
;

hunt:	pha
	txa
	pha
	tya
	pha
	inc	end	; end address = end address + 1
	bne	@hunt1
	inc	end+1
@hunt1:	lda	start	; is end address reached?
	cmp	end
	bne	@hunt2
	lda	start+1
	cmp	end+1
	beq	@nomatch
@hunt2: ldy	#0	; find string
	ldx	#0
@hunt3:	lda	(start),y
	cmp	buffer,x
	bne	@hunt4	; branch if no match
	iny
	inx
	cpx	cnt
	beq	@match
	sec
	bcs	@hunt3	; check next character in the string
@hunt4: inc	start	; start address = start address + 1
	bne	@hunt5
	inc	start+1
@hunt5:	sec
	bcs	@hunt1
@nomatch:
	pla
	tay
	pla
	tax
	pla
	sec
	rts
@match:
	pla
	tay
	pla
	tax
	pla
	clc
	rts

