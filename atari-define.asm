; zero page memory locations in use
	src	= $cb	; (2 bytes)
	start	= src
	dst	= $cd	; (2 bytes)
	pc	= dst
	opcode	= dst
	src2	= dst
	lmargn	= $52
	rmargn	= $53
	rowcrs	= $54
	colcrs	= $55
	bufcnt	= $6b
; iocb
	iccmd	= $342	; command byte
	icsta	= $343	; status
	icbal	= $344	; buffer address
	icbah	= icbal+1
	icptl	= $346	; put address
	icpth	= icptl+1
	icbll	= $348	; buffer length
	icblh	= icbll+1
	icax1	= $34a	; aux1
	icax2	= $34b	; aux2
	ciov	= $e456
; other memory locations
	buffer	= $480	; input buffer
	fname	= $4c0	; fname
	regs	= $4e0	; registers (sp,y,x,a,sr,pc) 7 bytes
	quote	= $4e7	; quote mode
	brkvec	= $206	; break vector
	end	= $4e7	; end address (2 bytes)
	mode	= $4e9	; addressing mode / empty parameter
	cnt	= $4ea  ; counter (2 bytes)
	value	= $4ec  ; used by memset routine and parser
	value2	= $4ed	; used by parser
; constants
	eol		= $9b
	iocb0		= $0
	iocb1		= $10
	readmode	= $4
	writemode	= $8
	opencmd		= $3
	closecmd	= $c
	getcmd		= $7
	getrecordcmd	= $5
	putcmd		= $b
	statuscmd	= $d
	lines		= 11
