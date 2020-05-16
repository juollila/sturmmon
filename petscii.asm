; PETSCII conversion and printing routines
; Coded by Juha Ollila
;
; Aug 06 2017 Initial version, routines copied from other files
; Oct 29 2017 Primm and printspc routines were add
; Jan 07 2018 Atari support

printcr:
	lda	#eol
	jsr	chrout
	rts

printspc:
	lda	#' '
	jsr	chrout
	rts

; primm routine
; copied from c128 kernal but modified so that it does not tamper
; any zero page location
primm:
	; save registers
	pha
	txa
	pha
	tya
	pha

	lda	src
	pha
	lda	src+1
	pha

	; update return address
@primm1:
	ldy	#0
	tsx
	inc	$106,x
	bne	@primm2
	inc	$107,x
	; print character
@primm2:
	lda	$106,x
	sta	src
	lda	$107,x
	sta	src+1
	lda	(src),y
	beq	@primm3		; exit if 0 byte
	jsr	chrout
	bcc	@primm1		; if no error get next character
@primm3:
	pla
	sta	src+1
	pla
	sta	src

	pla
	tay
	pla
	tax
	pla
	rts


; pet2byte routine converts two hexadecimal characters (petscii) to
; 8-bit byte value.
; input  a = first hex digit
;        y = second hex digit
; output a = 8-bit byte value
; changes all registers
;

pet2byte:
	; convert bits 4-7
	jsr	@cnvbyte
	asl
	asl
	asl
	asl
	pha
	; convert bits 0-3
	tya
	jsr	@cnvbyte
	; combine all 8 bits to one byte
	tsx
	ora	$101,x
	; clean the stack before returning
	tax
	pla
	txa
	rts

@cnvbyte:
	cmp	#'A'
	bcc	@cnvbyte1	; branch if 0-9
	sec
	sbc	#$37
	rts
@cnvbyte1:
	sec
	sbc	#'0'
	rts

; byte2pet routine converts 8-bit byte value to printable
; hexadecimal string (petscii).
;
; input	 a = 8-bit byte value
; output a = first hex digit
;        y = second hex digit
; changes all registers
;

byte2pet:
	pha
	and	#$0f
	tax
	lda	@hex,x
	tay
	pla
	ror
	ror
	ror
	ror
	and	#$0f
	tax
	lda	@hex,x
	rts

@hex:	.byte	"0123456789ABCDEF"

; printbyte routine prints 8-bit byte in hex format.
; input a = byte
; does not change registers
;

printbyte:
	; save registers
	pha
	txa
	pha
	tya
	pha
	; get byte back
	tsx
	lda	$103,x
	; print byte
	jsr	byte2pet
	jsr	chrout
	tya
	jsr	chrout
	; load registers
	pla
	tay
	pla
	tax
	pla
	rts

; printword routine prints 16-bit word (low endian) in hex format.
;
; input  a = low byte
;	 y = high byte
; does not change registers
printword:
	pha
	tya		; print high byte
	jsr	printbyte
	pla		; print low byte
	jsr	printbyte
	rts

