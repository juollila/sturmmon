; Opcodes for 65c02
; Coded by Juha Ollila Aug 5 2017
;
; Jun 25 2019 65c02 opcodes were added.


; format:
; mnemonic, addressing mode e.g. "BRK", 0
;
; addressing mode:				(opcode + operand length in bytes)
; 0 = none (none, accumulator and implied) 	(1)
; 1 = immediate					(2)
; 2 = zero page					(2)
; 3 = zero page, x				(2)
; 4 = zero page, y				(2)
; 5 = absolute					(3)
; 6 = absolute, x				(3)
; 7 = absolute, y				(3)
; 8 = relative					(2)
; 9 = (indirect, x)				(2)
; 10 = (indirect), y				(2)
; 11 = absolute indirect			(3)
; 12 = zero page indirect			(2)
; 13 = (absolute indirect, x)			(3)
; 99 = invalid

opcodes:
; 0
	.byte "BRK", 0,  "ORA", 9,  "***", 99, "***", 99, "TSB", 2,  "ORA", 2,  "ASL", 2,  "***", 99
; 8
	.byte "PHP", 0,  "ORA", 1,  "ASL", 0,  "***", 99, "TSB", 5,  "ORA", 5,  "ASL", 5,  "***", 99
; $10
	.byte "BPL", 8,  "ORA", 10, "ORA", 12, "***", 99, "TRB", 2,  "ORA", 3,  "ASL", 3,  "***", 99
; $18
	.byte "CLC", 0,  "ORA", 7,  "INC", 0,  "***", 99, "TRB", 5,  "ORA", 6,  "ASL", 6,  "***", 99
; $20
	.byte "JSR", 5,  "AND", 9,  "***", 99, "***", 99, "BIT", 2,  "AND", 2,  "ROL", 2,  "***", 99
; $28
	.byte "PLP", 0,  "AND", 1,  "ROL", 0,  "***", 99, "BIT", 5,  "AND", 5,  "ROL", 5,  "***", 99
; $30
	.byte "BMI", 8,  "AND", 10, "AND", 12, "***", 99, "BIT", 3,  "AND", 3,  "ROL", 3,  "***", 99
; $38
	.byte "SEC", 0,  "AND", 7,  "DEC", 0,  "***", 99, "BIT", 6,  "AND", 6,  "ROL", 6,  "***", 99
; $40
	.byte "RTI", 0,  "EOR", 9,  "***", 99, "***", 99, "***", 99, "EOR", 2,  "LSR", 2,  "***", 99
; $48
	.byte "PHA", 0,  "EOR", 1,  "LSR", 0,  "***", 99, "JMP", 5,  "EOR", 5,  "LSR", 5,  "***", 99
; $50
	.byte "BVC", 8,  "EOR", 10, "EOR", 12, "***", 99, "***", 99, "EOR", 3,  "LSR", 3,  "***", 99
; $58
	.byte "CLI", 0,  "EOR", 7,  "PHY", 0,  "***", 99, "***", 99, "EOR", 6,  "LSR", 6,  "***", 99
; $60
	.byte "RTS", 0,  "ADC", 9,  "***", 99, "***", 99, "STZ", 2,  "ADC", 2,  "ROR", 2,  "***", 99
; $68
	.byte "PLA", 0,  "ADC", 1,  "ROR", 0,  "***", 99, "JMP", 11, "ADC", 5,  "ROR", 5,  "***", 99
; $70
	.byte "BVS", 8,  "ADC", 10, "ADC", 12, "***", 99, "STZ", 3,  "ADC", 3,  "ROR", 3,  "***", 99
; $78
	.byte "SEI", 0,  "ADC", 7,  "PLY", 0,  "***", 99, "JMP", 13, "ADC", 6,  "ROR", 6,  "***", 99
; $80
	.byte "BRA", 8,  "STA", 9,  "***", 99, "***", 99, "STY", 2,  "STA", 2,  "STX", 2,  "***", 99
; $88
	.byte "DEY", 0,  "BIT", 1,  "TXA", 0,  "***", 99, "STY", 5,  "STA", 5,  "STX", 5,  "***", 99
; $90
	.byte "BCC", 8,  "STA", 10, "STA", 12, "***", 99, "STY", 3,  "STA", 3,  "STX", 4,  "***", 99
; $98
	.byte "TYA", 0,  "STA", 7,  "TXS", 0,  "***", 99, "STZ", 5,  "STA", 6,  "STZ", 6,  "***", 99
; $A0
	.byte "LDY", 1,  "LDA", 9,  "LDX", 1,  "***", 99, "LDY", 2,  "LDA", 2,  "LDX", 2,  "***", 99
; $A8
	.byte "TAY", 0,  "LDA", 1,  "TAX", 0,  "***", 99, "LDY", 5,  "LDA", 5,  "LDX", 5,  "***", 99
; $B0
	.byte "BCS", 8,  "LDA", 10, "LDA", 12, "***", 99, "LDY", 3,  "LDA", 3,  "LDX", 4,  "***", 99
; $B8
	.byte "CLV", 0,  "LDA", 7,  "TSX", 0,  "***", 99, "LDY", 6,  "LDA", 6,  "LDX", 7,  "***", 99
; $C0
	.byte "CPY", 1,  "CMP", 9,  "***", 99, "***", 99, "CPY", 2,  "CMP", 2,  "DEC", 2,  "***", 99
; $C8
	.byte "INY", 0,  "CMP", 1,  "DEX", 0,  "***", 99, "CPY", 5,  "CMP", 5,  "DEC", 5,  "***", 99
; $D0
	.byte "BNE", 8,  "CMP", 10, "CMP", 12, "***", 99, "***", 99, "CMP", 3,  "DEC", 3,  "***", 99
; $D8
	.byte "CLD", 0,  "CMP", 7,  "PHX", 0,  "***", 99, "***", 99, "CMP", 6,  "DEC", 6,  "***", 99
; $E0
	.byte "CPX", 1,  "SBC", 9,  "***", 99, "***", 99, "CPX", 2,  "SBC", 2,  "INC", 2,  "***", 99
; $E8
	.byte "INX", 0,  "SBC", 1,  "NOP", 0,  "***", 99, "CPX", 5,  "SBC", 5,  "INC", 5,  "***", 99
; $F0
	.byte "BEQ", 8,  "SBC", 10, "SBC", 12, "***", 99, "***", 99, "SBC", 3,  "INC", 3,  "***", 99
; $F8
	.byte "SED", 0,  "SBC", 7,  "PLX", 0,  "***", 99, "***", 99, "SBC", 6,  "INC", 6,  "***", 99 
; $100
opcodes2:
