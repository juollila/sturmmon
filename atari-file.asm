; Atari file routines
; Coded by Juha Ollila
;
; Jan 08 2018 Initial version
; Jul 02 2019 "loaded xxxx bytes to xxxx" message was added to the load routine.
; Jul 03 2019 Bug fix: A file should be closed also in the error situation.

; Loads a file into the memory
loadfile:
	lda	#readmode
	jsr	openfile
	ldx	#iocb1
	lda	#getcmd		; set get characters command
	sta	iccmd,x
	lda	#<buffer	; set buffer for the dos header
	sta	icbal,x
	lda	#>buffer
	sta	icbah,x
	lda	#6		; set the length of the header
	sta	icbll,x
	lda	#0
	sta	icblh,x

	jsr	ciov		; read the header
	bmi	@loaderror

	lda	buffer+2	; set start address
	sta	icbal,x
	lda	buffer+3
	sta	icbah,x

	sec			; set length of data
	lda	buffer+4
	sbc	buffer+2
	sta	icbll,x
	lda	buffer+5
	sbc	buffer+3
	sta	icblh,x
	inc	icbll,x
	bne	@loadfile1
	inc	icblh,x

@loadfile1:
	jsr	ciov		; read the data (i.e. body) part of the file
	bmi	@loaderror
	jsr	closefile
	jsr	primm
	.byte	"LOADED $",0
	ldx	#iocb1
	lda	icbll,x
	ldy	icblh,x
	jsr	printword
	jsr	primm
	.byte	" BYTES TO $",0
	lda	icbal,x
	ldy	icbah,x
	jsr	printword
	jsr	printcr
	rts

@loaderror:
	jsr	closefile
	jsr	primm
	.byte	"CANNOT READ THE FILE.",eol,0
	rts

; Saves a file from the memory
savefile:
	lda	#writemode
	jsr	openfile

	ldx	#iocb1
	lda	#putcmd		; set put characters command
	sta	iccmd,x
	lda	#<buffer	; set buffer address for the dos header
	sta	icbal,x
	lda	#>buffer
	sta	icbah,x
	lda	#6		; set the length of the header
	sta	icbll,x
	lda	#0
	sta	icblh,x
	lda	#$ff		; prepare the header
	sta	buffer
	sta	buffer+1
	lda	start
	sta	buffer+2
	lda	start+1
	sta	buffer+3
	lda	end
	sta	buffer+4
	lda	end+1
	sta	buffer+5
	dec	buffer+4
	bne	@savefile1
	dec	buffer+5
@savefile1:
	jsr	ciov		; write the header
	bmi	@saveerror

	lda	start		; set start of the data
	sta	icbal,x
	lda	start+1
	sta	icbah,x
	sec			; calculate the length of data
	lda	end
	sbc	start
	sta	icbll,x
	lda	end+1
	sbc	start+1
	sta	icblh,x

	jsr	ciov		; write the data (i.e. body of the file)
	bmi	@saveerror
	jsr	closefile
	rts

@saveerror:
	jsr	closefile
	jsr	primm
	.byte	"CANNOT WRITE THE FILE.",eol,0
	rts

; Opens the file
; Input: A = mode
openfile:
	ldx	#iocb1		; iocb number 1
	sta	icax1,x		; save mode
	lda	#0		; clear aux2
	sta	icax2,x
	lda	#opencmd	; open command
	sta	iccmd,x
	lda	#<fname		; set file name
	sta	icbal,x
	lda	#>fname
	sta	icbah,x
	ldy	cnt		; last character should be eol
	lda	#eol
	sta	fname,y

	jsr	ciov		; open the file
	bmi	openerror

	rts

openerror:
	jsr	closefile
	jsr	primm
	.byte	"CANNOT OPEN THE FILE.",eol,0
	pla
	pla
	rts

; Closes the file
;
closefile:
	ldx	#iocb1
	lda	#closecmd
	sta	iccmd,x
	jsr	ciov
	rts

