; zero page memory locations in use
	src	= $6	; (2 bytes)
	start	= src
	dst	= $8	; (2 bytes)
	pc	= dst
	opcode	= dst
	src2	= dst
	colcrs	= $24
	rowcrs	= $25
; other memory locations
	buffer	= _endaddr	; input buffer
	fname	= buffer+$80	; fname
	regs	= fname+$80	; registers (sp,y,x,a,sr,pc) 7 bytes
	end	= regs+7	; end address (2 bytes)
	mode	= end+2		; addressing mode / empty parameter
	cnt	= mode+1  	; counter (2 bytes)
	value	= cnt+2  	; used by memset routine and parser
	value2	= value+1	; used by parser
	quote	= value2+1	; quote mode
; prodos routines
	doscmd	= $be03
	prerr	= $be0c
; other prodos addresses
	cmdbuf	= $200
	bitmap	= $bf58
	bitmaplen = $18	
; monitor routines
	vtab	= $fc22
	rdkey	= $fd0c
	getlnz	= $fd67
	cout	= $fded
; constants
	backspace = $08
	eol	= $0d
	rubout	= $7f
	lines	= 11

