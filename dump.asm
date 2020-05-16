; Memory dump routines
; Coded by Juha Ollila
;
; Aug 05 2017 Initial version
; Nov 07 2017 Bug fix: Quote character requires special handling.
;             Otherwise garbage is printed.
; Nov 08 2017 Bug fix: Line should be ended with carriage return
;             instead of space. Otherwise modify memory does not
;             work as expected (lines are combined).
; Nov 11 2017 Initial support for VIC-20
; Jan 07 2018 Atari support
; Jun 24 2019 Apple support


; dump routine prints a content of memory in hex dump
; and string format starting from start address to end
; address.
;

dump:
	; check if end address is reached
	lda	start+1
	cmp	end+1
	beq	@dump1
	bcs	@exit
	bcc	@line
@dump1: lda	start
	cmp	end
	beq	@line
	bcs	@exit
	; print address
@line:	lda	#'>'
	jsr	chrout
	ldy	start+1
	lda	start
	jsr	printword
	; print next 8 bytes in hex format
	ldy	#0
@byte:	jsr	printspc
	lda	(start),y
	jsr	printbyte
	iny
.ifdef	VICROM
	cpy	#5
.else
	cpy	#8
.endif
	bne	@byte
	; print next 8 bytes in string format
.ifndef VICROM
@string:
	jsr	printspc
	lda	#':'
	jsr	chrout
.ifdef COMMODORE
	lda	#$12	; rvs on
	jsr	chrout
.endif
	ldy	#0
@string1:
	lda	(start),y
	and	#$7f
.ifdef COMMODORE
	cmp	#'"'
	beq	@string2
.endif
.ifdef ATARI
	cmp	#$7d
	bcs	@string2
.endif
.ifdef APPLE
	cmp	#$7f
	bcs	@string2
.endif
	cmp	#$20
	bcs	@string3 ; branch if not special character
@string2:
	lda	#'.'
@string3:
	jsr	chrout
	iny
	cpy	#8
	bne	@string1
.ifdef COMMODORE
	lda	#$92	; rvs off
	jsr	chrout
.endif
.endif
	jsr	printcr

	clc
	lda	start
.ifdef	VICROM
	adc	#5
.else
	adc	#8
.endif
	sta	start
	lda	start+1
	adc	#0
	sta	start+1
	sec
	bcs	dump
@exit:
	rts


