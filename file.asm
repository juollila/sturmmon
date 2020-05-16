; File routines
; Coded by Juha Ollila
;
; Oct 28 2017 Initial version.
; Nov 7  2017 Bug fix: Accumulator was uninitialized before load was called.
;             Error handling was added.

; load a file
;
; fname contains the filename
; cnt = length of file name
; device = device number
loadfile:
	lda	#1	; file number
	ldx	device
	ldy	#1	; secondary address
	jsr	setlfs

	lda	cnt
	ldx	#<fname
	ldy	#>fname
	jsr	setnam

	lda	#0	; load
	jsr	load
	bcs	readerror

	rts

; save a file
;
; start = start address
; end = end address
; fname contains the filename
; cnt = length of the file name
; device = device number
savefile:
	;lda	#$80
	;jsr	setmsg

	lda	#1	; file number
	ldx	device
	ldy	#0	; secondary address
	jsr	setlfs

	lda	cnt
	ldx	#<fname
	ldy	#>fname
	jsr	setnam

	lda	#start
	ldx	end
	ldy	end+1
	jsr	save
	bcs	readerror

	rts

; read a string from error channel and print it
;
readerror:
	jsr	printcr

	jsr	@opencommandchannel

	ldx	#15	; logical file
	jsr	chkin

@prterr:
	jsr	chrin
	cmp	#13
	beq	@readerror2
	jsr	chrout
	jmp	@prterr
@readerror2:
	jsr	chrout
	;lda	#5
	lda	#15
	jsr	close
	jsr	clrchn	
@readerrorexit:
	rts

; open error channel
;
@opencommandchannel:
	lda	#15	; logical file
	ldx	device	; device number
	ldy	#15	; command channel
	jsr	setlfs

	lda	#0	; length of name
	jsr	setnam

	jsr	open
	bcs	@opencommandexit
	rts

@opencommandexit:
	; file must be also closed when opening fails
	lda	#15	
	jsr	close
	rts


