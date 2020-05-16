; Parser and main command loop
; Coded by Juha Ollila
;
; Oct 29 2017 Initial version.
; Nov 01 2017 Command loop was heavily modified.
;             Compare and fill were added.
; Nov 02 2017 Parsego was modified so that address can be omitted.
;             Hunt and jsr were added.
; Nov 07 2017 Parsestring, parseload, parsemem, parsesave, and
;             parsecpy were added.
; Nov 08 2017 Modify memory and modify registers were added.
;             Bug fix: The last byte was not filled by fill command.
; Dec 09 2017 Bug fix: Plain return does not cause anymore an error.
;             Bug fix: Modify memory and modify register commands
;             crashed if no address was given.
;             Bug fix: Assembler command did not require address.
; Jan 07 2018 Atari support.
; Jan 11 2018 Parseasm was modified for Atari.
; Jun 24 2019 Initial Apple support.
; Jun 25 2019 Save and load for Apple.
; Jun 26 2019 Special version of getlne for Apple.
; Jun 30 2019 D command shows always 11 lines if no end address specified.
; Jul 01 2019 H command was enhanced to support '.

; Main command loop
commandloop:
	jsr	@getline
	bcs	commandloop
	jsr	@getcommand
	ldx	#$ff
@commandloop1:
	inx
	cpx	#17		; max number of commands
	bne	@commandloop2
	jmp	@error2		; error if no command was found
@commandloop2:
	cmp	@commands,x
	bne	@commandloop1	; branch if a command does not match
	lda	@cmdhigh,x
	pha
	lda	@cmdlow,x
	pha
	rts			; jump to command

; Handle assembler command
@parseasm:
	jsr	@getword	; get start address
	bcs	@parseasm2
	lda	value
	sta	pc
	lda	value+1
	sta	pc+1
@parseasm1:
	jsr	@omithexdump	; discard any hexdump
	jsr	_asmvec
	bcs	commandloop	; branch if error
	; insert "A <address>" into the keyboard buffer
.ifdef COMMODORE
	lda	#'A'
	sta	kbuffer
	lda	#' '
	sta	kbuffer+1
	sta	kbuffer+6
	lda	src+1
	jsr	byte2pet
	sta	kbuffer+2
	sty	kbuffer+3
	lda	src
	jsr	byte2pet
	sta	kbuffer+4
	sty	kbuffer+5
	lda	#7
	sta	kblen
.else
	lda	#'A'
	jsr	chrout
	jsr	printspc
	lda	src+1
	sta	pc+1
	jsr	byte2pet
	jsr	chrout
	tya
	jsr	chrout
	lda	src
	sta	pc
	jsr	byte2pet
	jsr	chrout
	tya
	jsr	chrout
	jsr	printspc
	jsr	@getline
	lda	buffer
	cmp	#eol
	bne	@parseasm1
.endif
.ifdef	APPLE
	jsr	printcr
.endif
	jmp	commandloop
@parseasm2:
	jmp	@error2

; Handle compare command
@parsecmp:
	jsr	@getword	; get start address
	bcs	@parsecmp1
	lda	value
	sta	src
	lda	value+1
	sta	src+1
	jsr	@getword	; get end address
	bcs	@parsecmp1
	lda	value
	sta	end
	lda	value+1
	sta	end+1
	jsr	@getword	; get compare address
	bcs	@parsecmp1
	lda	value
	sta	src2
	lda	value+1
	sta	src2+1
	jsr	printcr
	jsr	_memcmpvec
	jmp	commandloop
@parsecmp1:
	jmp	@error2
	

; Handle disassembler command
@parsedis:
	jsr	@getword	; get start address
	;rol	mode
	bcs	@parsedis1
	; set start address if it is specified
	lda	value
	sta	start
	lda	value+1
	sta	start+1
@parsedis1:
	jsr	@getword	; get end address
	bcs	@parsedis3	; branch if no end address was specified
	; set end address if it was specified
	lda	value
	sta	end
	lda	value+1
	sta	end+1
	; set line count
	lda	#0
	sta	cnt
	; perform disassembly
@parsedis2:
	jsr	printcr
	lda	#'.'
	sta	mode
	jsr	_disvec
	sec
	jmp	commandloop
	; calculate end address
@parsedis3:
	lda	#lines
	sta	cnt
	inc	cnt
	sec
	bcs	@parsedis2

; Handle fill command
@parsefill:
	jsr	@getword	; get start address
	bcs	@parsefill2
	lda	value
	sta	dst
	lda	value+1
	sta	dst+1
	jsr	@getword	; get end address
	bcs	@parsefill2
	sec
	lda	value
	sbc	dst
	sta	cnt
	lda	value+1
	sbc	dst+1
	sta	cnt+1
	;lda	value+1
	;sec
	;sbc	dst+1
	;sta	cnt+1
	;lda	value
	;sbc	dst
	;sta	cnt
	inc	cnt
	bne	@parsefill1
	inc	cnt+1
@parsefill1:
	jsr	@getbyte	; get value to be filled
	bcs	@parsefill2
	jsr	printcr
	jsr	_memsetvec
	jmp	commandloop
@parsefill2:
	jmp	@error2

; Handle go command
@parsego:
.ifdef APPLE
	jmp	@noimp
.else
	jsr	@getword	; get address
	bcs	@parsego1	; branch if no address specified
	lda	value
	sta	regs+5
	lda	value+1
	sta	regs+6
@parsego1:
	jmp	gomem
.endif

; Handle hunt e.g. find command
@parsehunt:
	jsr	@getword	; get start address
	bcs	@parsehunt3
	lda	value
	sta	start
	lda	value+1
	sta	start+1
	jsr	@getword	; get end address
	bcs	@parsehunt3
	lda	value
	sta	end
	lda	value+1
	sta	end+1
	lda	#$27		; '
	sta	quote
	jsr	@getstring	; get string
	bcc	@parsehunt8
	lda	#0
	sta	cnt
	jsr	@getbyte	; get first byte
	bcs	@parsehunt3
	lda	value
	pha
	inc	cnt
@parsehunt1:
	jsr	@getbyte	; get next byte
	bcs	@parsehunt2
	lda	value
	pha
	inc	cnt
	sec
	bcs	@parsehunt1
@parsehunt2:			; copy bytes (to be searched) from stack to buffer
	ldx	cnt
@parsehunt2a:
	pla
	sta	buffer-1,x
	dex
	bne	@parsehunt2a
	jsr	printcr
@parsehunt2b:
	jsr	_findvec
	bcs	@parsehunt2c	; branch if not found
	lda	start		; print address where bytes were found
	ldy	start+1
	jsr	printword
	inc	start		; increment starting address so that same bytes are not found again.
	bne	@parsehunt2d
	inc	start+1
@parsehunt2d:
	jsr	printspc
	sec
	bcs	@parsehunt2b
@parsehunt2c:
	jsr	printcr
	jmp	commandloop
@parsehunt3:
	jmp	@error2
@parsehunt8:			; copy string to buffer
	ldx	#0
@parsehunt9:
	lda	fname,x
.ifdef APPLE
	ora	#$80
.endif
	sta	buffer,x
	inx
	cpx	cnt
	bne	@parsehunt9
	jsr	printcr
	jmp	@parsehunt2b

; Handle jump to subroutine command
;
@parsejsr:
	jsr	@getword	; get address
	bcs	@parsejsr1	; branch if no address specified
	lda	value
	sta	regs+5
	lda	value+1
	sta	regs+6
@parsejsr1:
	jmp	jsrmem
	jmp	commandloop

; Handle load command
;
@parseload:
	lda	#'"'
	sta	quote
	jsr	@getstring
	bcs	@parseload1	; branch if no file name specified
.ifdef COMMODORE
	jsr	@getbyte
	bcs	@parseload1
	lda	value
	sta	device
.endif
	jsr	loadfile
	jsr	printcr
	jmp	commandloop
@parseload1:
	jmp	@error2


; Handle mem dump command
@parsemem:
	jsr	@getword	; get start address
	bcs	@parsemem1
	; set start address if it is specified
	lda	value
	sta	start
	lda	value+1
	sta	start+1
@parsemem1:
	jsr	@getword	; get end address
	bcs	@parsemem3	; branch if no end address was specified
	; set end address if it was specified
	lda	value
	sta	end
	lda	value+1
	sta	end+1
	; perform disassembly
@parsemem2:
	jsr	printcr
	jsr	_dumpvec
	sec
	jmp	commandloop
	; calculate end address
@parsemem3:
	clc
	lda	start
	adc	#80
	sta	end
	lda	start+1
	adc	#0
	sta	end+1
	sec
	bcs	@parsemem2

; Handle register command
;
@parsereg:
	jsr	showregisters
	jmp	commandloop

; Handle save command
;
@parsesave:
	lda	#'"'
	sta	quote
	jsr	@getstring
	bcs	@parsesave1	; branch if no file name specified
.ifdef COMMODORE
	jsr	@getbyte	; get device
	bcs	@parsesave1
	lda	value
	sta	device
.endif
.ifndef APPLE
	jsr	@getword	; get start address
	bcs	@parsesave1
	lda	value
	sta	start
	lda	value+1
	sta	start+1
	jsr	@getword	; get end address + 1 
	bcs	@parsesave1
	lda	value
	sta	end
	lda	value+1
	sta	end+1
.endif
	jsr	savefile
	jsr	printcr
	jmp	commandloop
@parsesave1:
	jmp	@error2

; Handle transfer / copy command
@parsecpy:
	jsr	@getword	; get start address
	bcs	@parsecpy2
	lda	value
	sta	src
	lda	value+1
	sta	src+1
	jsr	@getword	; get end address
	bcs	@parsecpy2
	sec			; calculate a number of bytes to be transferred
	lda	value
	sbc	src
	sta	cnt
	lda	value+1
	sbc	src+1
	sta	cnt+1
	inc	cnt
	bne	@parsecpy1
	inc	cnt+1
@parsecpy1:
	jsr	@getword	; get destination address
	bcs	@parsecpy2
	lda	value
	sta	dst
	lda	value+1
	sta	dst+1
	jsr	printcr
	jsr	_memcpyvec
	jmp	commandloop
@parsecpy2:
	jmp	@error2

		


; Handle exit command
;
@parseexit:
.ifdef VICROM
	jmp	($c000)		; go to basic
.endif

.ifdef C64
.ifdef ROM
	jmp	($a000)		; go to basic
.endif
.endif

.ifdef ATARI
	jmp	($bffa)		; go to basic
.endif
	rts			; exit from the sturmmon

; Handle modify memory
;
@parsemod:
	jsr	@getword	; get start address
	bcs	@parsemod3	; branch if no word
	lda	value
	sta	start
	sta	end
	lda	value+1
	sta	start+1
	sta	end+1
	lda	#0		; init index to 0
	sta	cnt
@parsemod1:
	jsr	@getbyte	; get next byte
	bcs	@parsemod2	; branch if no byte
	ldy	cnt
	lda	value
	sta	(start),y
	;inc	$d020
	inc	cnt
	lda	cnt
	cmp	#8
	bne	@parsemod1
@parsemod2:
	; write mem dump from the beginnig of the line
	sec
	jsr	plot
	ldy	#0
	clc
.ifdef ATARI
	dex
.endif
	jsr	plot
	jsr	_dumpvec
	;lda	#'A'
	;sta	mode
	;jsr	_disvec
	;clc
	;jsr	printcr
	jmp	commandloop
@parsemod3:
	jmp	@error2

; Handle change register
; sp,y,x,a,sr,pc
@parsechg:
	;jmp	@parsechg
	jsr	@getword	; get pc
	bcs	@parsechg3	; branch if no pc
	lda	value+1
	sta	regs+6
	lda	value
	sta	regs+5
	lda	#4
	sta	cnt
@parsechg1:
	jsr	@getbyte	; get byte
	bcs	@parsechg2
	lda	value
	ldy	cnt
	sta	regs,y
	dec	cnt
	cpy	#0
	bne	@parsechg1
@parsechg2:
	jsr	printcr
	jmp	commandloop
@parsechg3:
	jmp	@error2


; Handle return
;
@parsenop:
	jsr	printcr
	jmp	commandloop
	
; Feature is not implemented
@noimp:
	jsr	primm
	.byte	eol,"NO IMPLEMENTATION.",eol,$0
	jmp	commandloop

; Get command
;
@getcommand:
	jsr	@omitspc
	lda	buffer
	pha
	cmp	#eol
	beq	@get2
	ldx	#0
	ldy	#0
	inx
@get1:
	lda	buffer,x
	sta	buffer,y
	inx
	iny
	cmp	#eol
	bne	@get1
@get2:
	pla
.ifdef APPLE
	jsr	upper
.endif
	rts
	

; Get input line
;
@getline:
	ldx	#0
@getline1:
	jsr	chrin
.ifdef APPLE
	cmp	#rubout
	beq	@getline2
	cmp	#backspace
	bne	@getline3
@getline2:
	cpx	#0
	beq	@getline4
	dex
	jmp	@getline4
@getline3:
	sta	buffer,x
	inx
@getline4:
.else
	sta	buffer,x
	inx
.endif
	;cpx	#$28		; check length of string
	cpx	#$40		; check length of string
	beq	@error
	cmp	#eol
	bne	@getline1
;.endif
	clc
	rts

@error:
	jsr	primm
	.byte	"?",eol,$0
	sec
	rts

@error2:
	jsr	primm
	.byte	"?",eol,$0
	jmp	commandloop

; Get byte
;
@getbyte:
	lda	#1
	sta	mode
	lda	#0
	sta	value
	jsr	@omitspc
	jsr	@omitcomma
	jsr	@omitspc
	jsr	@omitsign
	ldy	#$ff
@getbyte1:
	iny
	lda	buffer,y
.ifdef	APPLE
	jsr	upper
.endif
	cmp	#' '
	beq	@getbyte3
	cmp	#','
	beq	@getbyte3
	cmp	#eol
	beq	@getbyte3
	cmp	#':'
	beq	@getbyte3
	asl	value
	bcs	@getbyte6	; error if byte > 255
	asl	value
	bcs	@getbyte6	; error if byte > 255
	asl	value
	bcs	@getbyte6	; error if byte > 255
	asl	value
	bcs	@getbyte6	; error if byte > 255
	sec
	sbc	#'0'
	bcc	@getbyte6	; error if byte < 0
	cmp	#10
	bcc	@getbyte2	; branch if byte < 10
	sec
	sbc	#7
	cmp	#16
	bcs	@getbyte6	; error if hex digit >16
@getbyte2:
	clc
	adc	value
	sta	value
	lda	#0		; indicate that the parameter exists
	sta	mode
	sec
	bcs	@getbyte1
@getbyte3:
	ldx	#0
@getbyte4:
	lda	buffer,y
	sta	buffer,x
	cmp	#eol
	beq	@getbyte5
	iny
	inx
	bne	@getbyte4
@getbyte5:
	ror	mode		; set carry if parameter does not exist
	rts
@getbyte6:
	jmp	@error



; Get word (2 bytes)
;
@getword:
	lda	#1
	sta	mode
	lda	#0
	sta	value
	sta	value+1
	jsr	@omitspc
	jsr	@omitcomma
	jsr	@omitspc
	jsr	@omitsign
	ldy	#$ff
@getword1:
	iny
	lda	buffer,y
.ifdef	APPLE
	jsr	upper
.endif
	cmp	#' '
	beq	@getword3
	cmp	#','
	beq	@getword3
	cmp	#eol
	beq	@getword3
	asl	value
	rol	value+1
	bcs	@getword6	; error if word > 65535
	asl	value
	rol	value+1
	bcs	@getword6	; error if word > 65535
	asl	value
	rol	value+1
	bcs	@getword6	; error if word > 65535
	asl	value
	rol	value+1
	bcs	@getword6	; error if word > 65535
	sec
	sbc	#'0'
	bcc	@getword6	; error if hex digit < 0
	cmp	#10
	bcc	@getword2	; branch if hex digit < 10
	sec
	sbc	#7
	cmp	#16
	bcs	@getword6	; error if hex digit >16
@getword2:
	clc
	adc	value
	sta	value
	lda	value+1
	adc	#0
	sta	value+1
	lda	#0		; indicate that the parameter exists
	sta	mode
	sec
	bcs	@getword1
@getword3:
	ldx	#0
@getword4:
	lda	buffer,y
	sta	buffer,x
	cmp	#eol
	beq	@getword5
	iny
	inx
	bne	@getword4
@getword5:
	ror	mode		; set carry if parameter does not exist
	rts
@getword6:
	jmp	@error

; Get string
;
@getstring:
	jsr	@omitspc
	jsr	@omitcomma
	jsr	@omitspc
	lda	buffer
	cmp	quote
	bne	@getstring5
	jsr	@omitquote
	ldy	#0
@getstring1:
	lda	buffer,y
	cmp	quote
	beq	@getstring2
	cmp	#eol
	beq	@getstring2
	sta	fname,y		; store char
	iny
	sec
	bcs	@getstring1
@getstring2:
	sty	cnt		; store number of chars
	ldx	#0
@getstring3:
	lda	buffer,y
	sta	buffer,x
	cmp	#eol
	beq	@getstring4
	inx
	iny
	bne	@getstring3
@getstring4:
	jsr	@omitquote
	clc
	rts
@getstring5:
	sec
	rts
	
; Omit leading comma sign
;
@omitcomma:
	ldx	#0
	ldy	#0
	lda	buffer,x
	cmp	#','
	bne	@omitcomma2
	inx
@omitcomma1:
	lda	buffer,x
	sta	buffer,y
	inx
	iny
	cmp	#eol
	bne	@omitcomma1
@omitcomma2:
	rts

; Omit leading dollar sign
;
@omitsign:
	ldx	#0
	ldy	#0
	lda	buffer,x
	cmp	#'$'
	bne	@omitsign2
	inx
@omitsign1:
	lda	buffer,x
	sta	buffer,y
	inx
	iny
	cmp	#eol
	bne	@omitsign1
@omitsign2:
	rts

; Omit leading quote
;
@omitquote:
	ldx	#0
	ldy	#0
	lda	buffer,x
	cmp	quote
	bne	@omitquote2
	inx
@omitquote1:
	lda	buffer,x
	sta	buffer,y
	inx
	iny
	cmp	#eol
	bne	@omitquote1
@omitquote2:
	rts


; Omit leading spaces
;
@omitspc:
	ldx	#$ff
	ldy	#0
@omitspc1:
	inx
	lda	buffer,x
	cmp	#' '
	bne	@omitspc2
	sec
	bcs	@omitspc1
@omitspc2:
	lda	buffer,x
	sta	buffer,y
	inx
	iny
	cmp	#eol
	bne	@omitspc2
	rts

; Omit hex dump listing
@omithexdump:
	ldx	#$ff
	ldy	#0
	; check starting shift+space
@omithexdump1:
	inx
	lda	buffer,x
.ifdef COMMODORE
	cmp	#$a0
	bne	@omithexdump3 ; branch to copy the byte
.else
	cmp	#$5b
	bne	@omithexdump3
.endif
	; omit bytes
@omithexdump2:
	inx
	lda	buffer,x
	cmp	#eol
	beq	@omithexdump3
.ifdef COMMODORE
	cmp	#$a0
	bne	@omithexdump2 ; branch if not ending shift+space
.else
	cmp	#$5d
	bne	@omithexdump2 ; branch if not ending shift
.endif
	inx
	; copy byte
@omithexdump3:
	lda	buffer,x
	sta	buffer,y
	iny
	cmp	#eol
	bne	@omithexdump1
	rts

@commands:
	.byte	"ACDF","GHJL","MRST","X>.;",eol
@cmdhigh:
	.byte >(@parseasm-1),  >(@parsecmp-1),  >(@parsedis-1),  >(@parsefill-1)
	.byte >(@parsego-1),   >(@parsehunt-1), >(@parsejsr-1),  >(@parseload-1)
	.byte >(@parsemem-1),  >(@parsereg-1),  >(@parsesave-1), >(@parsecpy-1)
	.byte >(@parseexit-1), >(@parsemod-1),  >(@parseasm-1),  >(@parsechg-1)
	.byte >(@parsenop-1)
@cmdlow:
	.byte <(@parseasm-1),  <(@parsecmp-1),  <(@parsedis-1),  <(@parsefill-1)
	.byte <(@parsego-1),   <(@parsehunt-1), <(@parsejsr-1),  <(@parseload-1)
	.byte <(@parsemem-1),  <(@parsereg-1),  <(@parsesave-1), <(@parsecpy-1)
	.byte <(@parseexit-1), <(@parsemod-1),  <(@parseasm-1),  <(@parsechg-1)
	.byte <(@parsenop-1)


