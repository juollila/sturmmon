; Assembler routines
; Coded by Juha Ollila
;
; Aug 06 2017 Initial (unusable) version
; Aug 09 2017 Implied, immediate, zero page, zero page x, and zero page y modes were added
; Aug 10 2017 Absolute, absolute x, absolute y, relative, indirect x, indirect y and
;             absolute indirect modes were added
; Oct 15 2017 Unit test interface was added
; Oct 29 2017 Improvements to error handling
; Oct 30 2017 Mode was added for disassembly part
; Jan 07 2018 Atari support
; Jun 26 2019 65c02 support
;



asm:	lda	pc
	pha
	lda	pc+1
	pha

.ifdef UNITTEST
	.export	_asmtest
        .include "define.asm"
.ifdef CMOS
	.include "65c02.asm"
.else
        .include "6502.asm"
.endif
	.include "find.asm"
	.include "petscii.asm"
_findvec:
	jmp	hunt
_asmtest:
.endif

	jsr	@omitspc
	sec
	bcs	@process


@returnok:
.ifndef	UNITTEST
	pla
	sta	start+1
	sta	end+1
	pla
	sta	start
	sta	end
	; write disassembly from the beginnig of the line
	sec
	jsr	plot
	ldy	#0
.ifdef ATARI
	dex
.endif
	clc
	jsr	plot
	lda	#'A'
	sta	mode
	lda	#2
	sta	cnt
	jsr	_disvec
.endif
	clc
	rts

@process:
	lda	buffer
	cmp	#eol
	beq	@exit
	jsr	@implied
	bcc	@returnok
	jsr	@immediate
	bcc	@returnok
	jsr	@zero
	bcc	@returnok
	jsr	@zerox
	bcc	@returnok
	jsr	@zeroy
	bcc	@returnok
	jsr	@absolute
	bcc	@returnok
	jsr	@absolutex
	bcc	@returnok
	jsr	@absolutey
	bcc	@returnok
	jsr	@relative
	bcc	@returnok
	jsr	@indirectx
	bcc	@returnok
	jsr	@indirecty
	bcc	@returnok
	jsr	@indirect
	bcc	@returnok
	jsr	@zpindirect
	bcc	@returnok
	jsr	@absindirectx
	bcc	@returnok
	bcs	@error

@error: jsr	primm
	.byte	"?",eol,0
.ifdef UNITTEST
	rts
.endif
@exit:
	jsr	printcr
	pla
	pla
	sec
	rts

; removes all space characters
; return: x = a number of characters without spaces
;
@omitspc:
	ldy	#$ff
	ldx	#$ff
@omitspc1:
	iny
	lda	buffer,y
	cmp	#' '
	beq	@omitspc1
	inx
	sta	buffer,x
	cmp	#eol
	beq	@omitspc2
	sec
	bcs	@omitspc1
@omitspc2:
	inx
	rts

; find opcode
; input:  a = addressing mode
; return: a = opcode
;         carry set if not found
;
@findcode:
	pha	; save addressing mode
	; find mnemonic from opcode table
	lda	#<opcodes
	sta	start
	lda	#>opcodes
	sta	start+1
	lda	#<opcodes2
	sta	end
	lda	#>opcodes2
	sta	end+1
.ifdef	APPLE
	ldx	#2
@findcode0:
	lda	buffer,x
	jsr	upper
	sta	buffer,x
	dex
	bpl	@findcode0
.endif
@findcode1:
	ldy	#3
	sty	cnt
	jsr	_findvec
	bcs	@findcode4	; branch if not found
	; check addressing mode
	lda	(start),y
	tsx
	cmp	$101,x
	beq	@findcode3	; branch if addressing mode matches
	inc	start		; otherwise continue search
	bne	@findcode2
	inc	start+1
@findcode2:
	sec
	bcs	@findcode1
@findcode3:
	pla
	; calculate offset from the beginning of opcode table	
	sec
	lda	start
	sbc	#<opcodes
	sta	start
	lda	start+1
	sbc	#>opcodes
	sta	start+1
	; opcode = offset / 4
	ror	start+1
	ror	start
	ror	start+1
	ror	start
	lda	start
	;sta	$402		; debug
	clc
	rts
@findcode4:
	pla
	sec
	rts

; incpc increments program counter by one
;
@incpc:
	inc	pc
	bne	@incpc1
	inc	pc+1
@incpc1:
	rts

; checks implied and accumulator mode
; return: carry set if not this mode
;
@implied:
	txa
	pha
	cpx	#4		; e.g. nop+eol
	bne	@implied1
	lda	#0		; implied mode
	jsr	@findcode
	bcs	@implied1	; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	pla
	tax
	clc
	rts
@implied1:
	pla
	tax
	clc
	sec
	rts

; checks immediate mode
; return: carry set if not immediate
;
@immediate:
	txa
	pha
	cpx	#8		; e.g. lda#$aa+eol
	bne	@immediate1	; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'#'
	beq	@immediate2	; branch if immediate mode
@immediate1:
	pla
	tax
	sec			; carry set if not immediate
	rts
@immediate2:
	iny
	lda	buffer,y
	cmp	#'$'
	bne	@immediate1	; branch if no $
	lda	#1		; immediate mode
	jsr	@findcode
	bcs	@immediate1	; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#6
	lda	buffer,y
	tay
	ldx	#5
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store operand byte
	jsr	@incpc
	pla
	tax
	clc
	rts

; checks zero page mode
; return: carry set if not zeropage mode
;

@zero:
	txa
	pha
	cpx	#7		; e.g. lda$aa+eol
	bne	@zero1		; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'$'
	beq	@zero2		; branch if zero page mode
@zero1:
	pla
	tax
	sec			; carry set if not zero page mode
	rts
@zero2:
	lda	#2		; zero page mode
	jsr	@findcode
	bcs	@zero1		; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#5
	lda	buffer,y
	tay
	ldx	#4
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store operand byte
	jsr	@incpc
	pla
	tax
	clc
	rts

; checks zero page, x mode
; return: carry set if not zeropage mode
;

@zerox:
	txa
	pha
	cpx	#9		; e.g. lda$aa,x+eol
	bne	@zerox1		; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'$'
	bne	@zerox1		; branch if no $
	ldy	#6
	lda	buffer,y
	cmp	#','
	bne	@zerox1		; branch if no ,
	iny
	lda	buffer,y
	cmp	#'X'
	beq	@zerox2		; branch if zero page, x mode
@zerox1:
	pla
	tax
	sec			; carry set if not the zero page, x mode
	rts
@zerox2:
	lda	#3		; zero page, x mode
	jsr	@findcode
	bcs	@zerox1		; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#5
	lda	buffer,y
	tay
	ldx	#4
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store operand byte
	jsr	@incpc
	pla
	tax
	clc
	rts

; checks zero page, y mode
; return: carry set if not zeropage,y mode
;

@zeroy:
	txa
	pha
	cpx	#9		; e.g. lda$aa,y+eol
	bne	@zeroy1		; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'$'
	bne	@zeroy1		; branch if no $
	ldy	#6
	lda	buffer,y
	cmp	#','
	bne	@zeroy1		; branch if no ,
	iny
	lda	buffer,y
	cmp	#'Y'
	beq	@zeroy2		; branch if zero page, y mode
@zeroy1:
	pla
	tax
	sec			; carry set if not the zero page, y mode
	rts
@zeroy2:
	lda	#4		; zero page, y mode
	jsr	@findcode
	bcs	@zeroy1		; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#5
	lda	buffer,y
	tay
	ldx	#4
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store operand byte
	jsr	@incpc
	pla
	tax
	clc
	rts

; checks absolute mode
; return: carry set if not absolute mode
;

@absolute:
	txa
	pha
	cpx	#9		; e.g. jmp$abcd+eol
	bne	@absolute1		; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'$'
	bne	@absolute1	; branch if no $
	ldy	#6
	lda	buffer,y
	cmp	#','
	beq	@absolute1	; branch if zero page x or y mode
@absolute2:
	lda	#5		; absolute mode
	jsr	@findcode
	bcs	@absolute1	; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#7
	lda	buffer,y
	tay
	ldx	#6
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store low byte
	jsr	@incpc
	ldy	#5
	lda	buffer,y
	tay
	ldx	#4
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store high byte
	jsr	@incpc
	pla
	tax
	clc
	rts
@absolute1:
	pla
	tax
	sec			; carry set if not the absolute mode
	rts

; checks absolute x mode
; return: carry set if not absolute x mode
;

@absolutex:
	txa
	pha
	cpx	#11		; e.g. lda$abcd,x+eol
	bne	@absolutex1		; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'$'
	bne	@absolutex1	; branch if no $
	ldy	#8
	lda	buffer,y
	cmp	#','
	bne	@absolutex1	; branch if no ,
	iny
	lda	buffer,y
	cmp	#'X'
	bne	@absolutex1	; branch if no x
@absolutex2:
	lda	#6		; absolute x mode
	jsr	@findcode
	bcs	@absolutex1	; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#7
	lda	buffer,y
	tay
	ldx	#6
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store low byte
	jsr	@incpc
	ldy	#5
	lda	buffer,y
	tay
	ldx	#4
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store high byte
	jsr	@incpc
	pla
	tax
	clc
	rts
@absolutex1:
	pla
	tax
	sec			; carry set if not the absolute x mode
	rts

; checks absolute y mode
; return: carry set if not absolute y mode
;

@absolutey:
	txa
	pha
	cpx	#11		; e.g. lda$abcd,x+eol
	bne	@absolutey1		; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'$'
	bne	@absolutey1	; branch if no $
	ldy	#8
	lda	buffer,y
	cmp	#','
	bne	@absolutey1	; branch if no ,
	iny
	lda	buffer,y
	cmp	#'Y'
	bne	@absolutey1	; branch if no x
@absolutey2:
	lda	#7		; absolute y mode
	jsr	@findcode
	bcs	@absolutey1	; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#7
	lda	buffer,y
	tay
	ldx	#6
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store low byte
	jsr	@incpc
	ldy	#5
	lda	buffer,y
	tay
	ldx	#4
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store high byte
	jsr	@incpc
	pla
	tax
	clc
	rts
@absolutey1:
	pla
	tax
	sec			; carry set if not the absolute y mode
	rts


; checks relative mode
; return: carry set if not relative mode
;

@relative:
	txa
	pha
	cpx	#9		; e.g. bne$abcd+eol
	bne	@relative1	; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'$'
	bne	@relative1	; branch if no $
	ldy	#6
	lda	buffer,y
	cmp	#','
	beq	@relative1	; branch if zero page x or y mode
@relative2:
	lda	#8		; absolute mode
	jsr	@findcode
	bcs	@relative1	; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	ldy	#5
	lda	buffer,y
	tay
	ldx	#4
	lda	buffer,x
	jsr	pet2byte
	pha			; store high byte
	ldy	#7
	lda	buffer,y
	tay
	ldx	#6
	lda	buffer,x
	jsr	pet2byte
	pha			; store low byte
	tsx			; calculate offset
	ldy	#1
	sec
	lda	$101,x
	sbc	pc
	sta	$101,x		; store low byte of offset to stack
	lda	$102,x
	sbc	pc+1
	sta	$102,x		; store high byte of offset to stack 
	sec			; offset = offset - 2
	lda	$101,x
	sbc	#2
	sta	$101,x
	lda	$102,x
	sbc	#0
	sta	$102,x
	pla
	sta	(pc),y		; store low byte of offset
	pla
	cmp	#0
	beq	@relative3	; branch if offset is ok
	cmp	#$ff
	beq	@relative3	; branch if offset is ok
@relative1:
	pla
	tax
	sec			; carry set if not the relative mode
	rts
@relative3:
	jsr	@incpc
	jsr	@incpc
	pla
	tax
	clc
	rts

; checks indirect x mode
; return: carry set if not indirect x mode
;

@indirectx:
	txa
	pha
	cpx	#11		; e.g. lda($aa,x)+eol
	bne	@indirectx1	; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'('
	bne	@indirectx1	; branch if no (
	iny
	lda	buffer,y
	cmp	#'$'
	bne	@indirectx1	; branch if no $
	ldy	#7
	lda	buffer,y
	cmp	#','
	bne	@indirectx1	; branch if no ,
	iny
	lda	buffer,y
	cmp	#'X'
	beq	@indirectx2	; branch if indirect x mode
@indirectx1:
	pla
	tax
	sec			; carry set if not the indirect x mode
	rts
@indirectx2:
	lda	#9		; indirect x mode
	jsr	@findcode
	bcs	@indirectx1	; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#6
	lda	buffer,y
	tay
	ldx	#5
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store operand byte
	jsr	@incpc
	pla
	tax
	clc
	rts

; checks indirect y mode
; return: carry set if not indirect y mode
;

@indirecty:
	txa
	pha
	cpx	#11		; e.g. lda($aa),y+eol
	bne	@indirecty1	; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'('
	bne	@indirecty1	; branch if no (
	iny
	lda	buffer,y
	cmp	#'$'
	bne	@indirecty1	; branch if no $
	ldy	#8
	lda	buffer,y
	cmp	#','
	bne	@indirecty1	; branch if no ,
	iny
	lda	buffer,y
	cmp	#'Y'
	beq	@indirecty2	; branch if indirect y mode
@indirecty1:
	pla
	tax
	sec			; carry set if not the indirect y mode
	rts
@indirecty2:
	lda	#10		; indirect y mode
	jsr	@findcode
	bcs	@indirectx1	; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#6
	lda	buffer,y
	tay
	ldx	#5
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store operand byte
	jsr	@incpc
	pla
	tax
	clc
	rts

; checks indirect mode
; return: carry set if not indirect mode
;

@indirect:
	txa
	pha
	cpx	#11		; e.g. jmp($aabb)+eol
	bne	@indirect1	; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'('
	bne	@indirect1	; branch if no (
	iny
	lda	buffer,y
	cmp	#'$'
	bne	@indirect1	; branch if no $
	ldy	#7
	lda	buffer,y
	cmp	#','
	beq	@indirect1	; branch if ,
	iny
	lda	buffer,y
	cmp	#','
	beq	@indirect1	; branch if ,
	iny
	lda	buffer,y
	cmp	#')'
	beq	@indirect2	; branch if )
@indirect1:
	pla
	tax
	sec			; carry set if not the indirect mode
	rts
@indirect2:
	lda	#11		; indirect mode
	jsr	@findcode
	bcs	@indirect1	; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#8
	lda	buffer,y
	tay
	ldx	#7
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store low byte
	jsr	@incpc
	ldy	#6
	lda	buffer,y
	tay
	ldx	#5
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store high byte
	jsr	@incpc
	pla
	tax
	clc
	rts

; checks zp indirect mode
; return: carry set if not indirect mode
;

@zpindirect:
	txa
	pha
	cpx	#9		; e.g. lda($12)+eol
	bne	@zpindirect1	; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'('
	bne	@zpindirect1	; branch if no (
	iny
	lda	buffer,y
	cmp	#'$'
	bne	@zpindirect1	; branch if no $
	ldy	#7
	lda	buffer,y
	cmp	#')'
	beq	@zpindirect2	; branch if )
@zpindirect1:
	pla
	tax
	sec			; carry set if not the zp indirect mode
	rts
@zpindirect2:
	lda	#12		; zp indirect mode
	jsr	@findcode
	bcs	@zpindirect1	; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#6
	lda	buffer,y
	tay
	ldx	#5
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store low byte
	jsr	@incpc
	pla
	tax
	clc
	rts

; checks absolute indirect x mode
; return: carry set if not absolute indirect x mode
;

@absindirectx:
	txa
	pha
	cpx	#13		; e.g. jmp($5678,x)+eol
	bne	@absindirectx1	; branch if length does not match
	ldy	#3
	lda	buffer,y
	cmp	#'('
	bne	@absindirectx1	; branch if no (
	iny
	lda	buffer,y
	cmp	#'$'
	bne	@absindirectx1	; branch if no $
	ldy	#9
	lda	buffer,y
	cmp	#','
	bne	@absindirectx1	; branch if no ,
	iny
	lda	buffer,y
	cmp	#'X'
	beq	@absindirectx2	; branch if abs indirect x mode
@absindirectx1:
	pla
	tax
	sec			; carry set if not the abs indirect x mode
	rts
@absindirectx2:
	lda	#13		; abs indirect x mode
	jsr	@findcode
	bcs	@absindirectx1	; branch if opcode was not found
	ldy	#0
	sta	(pc),y		; store opcode
	jsr	@incpc
	ldy	#8
	lda	buffer,y
	tay
	ldx	#7
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store operand byte
	jsr	@incpc
	ldy	#6
	lda	buffer,y
	tay
	ldx	#5
	lda	buffer,x
	jsr	pet2byte
	ldy	#0
	sta	(pc),y		; store operand byte
	jsr	@incpc
	pla
	tax
	clc
	rts

