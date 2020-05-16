; zero page memory locations in use
	src	= $3	; (2 bytes)
	start	= src
	dst	= $5	; (2 bytes)
	pc	= dst
	opcode	= dst
	src2	= dst
	kblen	= $c6	; keyboard buffer length
; other memory locations
	buffer	= $200	; input buffer
	fname	= $240	; fname
	kbuffer	= $277	; keyboard buffer
	regs	= $2f0	; registers (sp, y,x,a,sr,pc) 7 bytes
	quote	= $2f7	; quote mode
	brkvec	= $316	; break vector
	end	= $334	; end address (2 bytes)
	mode	= $336	; addressing mode / empty parameter
	cnt	= $337  ; counter (2 bytes)
        device  = $339  ; device number
	value	= $33a  ; used by memset routine and parser
	value2	= $33b	; used by parser
;constants
	eol	= $0d
	lines	= 11
; kernal functions
	setlfs	= $ffba
	setnam	= $ffbd
	open	= $ffc0
	close	= $ffc3
	chkin	= $ffc6
	clrchn	= $ffcc
	chrin	= $ffcf
	chrout	= $ffd2
	load	= $ffd5
	save	= $ffd8
	setmsg	= $ff90
	plot	= $fff0
