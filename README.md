SturmMon
========

SturmMon is a machine language monitor for VIC-20, Commodore 64, Atari 8-bit and Apple II computers.

It supports following commands:

```
A - Assemble a machine language instruction to the object code. Multiple lines can be assembled one by one. Input is terminated using the enter.
   A <address> <command> [<operand>]

C - Compare two memory areas.
   C <start adress> <end adress> <start adress for comparing>

D - Disassemble the object code.
   D [<start adress > [<end adress>]]

F - Fill up a memory area with the byte value.
   F <start adress> <end adress> <byte>

G - Go to the memory adress. The routine must end with the BRK instruction. This command is not supported in Apple computers.
   G <adress>

H - Hunt a byte sequence in the memory area.
   H <start adress> <end adress> <byte> [<byte>] ... [<byte>]
   H <start adress> <end adress> '<string>

J - Jump to a subroutine. The subroutine must end with the RTS instruction.
   J <adress>

L - Load an object code from a device into the memory.
   In Commodore computers: L "<filename>" device (e.g. L "FILENAME" 8)
   In Atari computers: L "<device>:<filename>" (e.g. L "D:FILENAME")
   In Apple computers: L "[<prefix>]<filename>[,A<start address>]" (e.g. L "/BIN/FILENAME,A$2000")

M - Show a memory dump in hexadecimal.
   M [<start adress> [<end adress>]]

R - Show registers.

S - Save a memory area into a file.
   In Commodore computers: S "<filename>" <device> <start adress> <end adress+1>
   In Atari computers: S "<device>:<filename>" <start address> <end address+1>
   In Apple computers: S "[<prefix>]<filename>,A<start address>,L<length>"

T - Copy (transfer) a memory area.
   T <start adress> <end adress> <destination adress>

X - Exit SturmMon into BASIC. In Atari Computers, BASIC ROM is required.

> - Modify the content of memory.
   > <adress> <byte> [<byte>] ... [<byte>]

. - Works same like the A command

; - Change the content of registers.
```
