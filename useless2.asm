; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386 (or later).


dseg		segment	para public 'data'
buffer2 byte ?
A dw 2712
Ash dw 2560
B dw 2415
CN dw 2281
CSH dw 2153
D dw 2029
DSH dw 1918
E dw 1808
F dw 1709
FSH dw 1612
G dw 1522
GSH dw 1437
PPI_B equ 61h
PIT_CW equ 43h
PIT_Ch2 equ 42h
RTC textequ <es:[6ch]>
filename byte 'useless.txt'
filehandle word ?
buffer byte ?
dseg		ends

cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg

Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
lea bx, buffer2
lea bx, FSH
lea bx, G
lea bx, GSH
Quit:		ExitPgm			;DOS macro to quit program.
Main		endp

cseg		ends

sseg		segment	para stack 'stack'
stk		byte	1024 dup ("stack   ")
sseg		ends

zzzzzzseg	segment	para public 'zzzzzz'
LastBytes	byte	16 dup (?)
zzzzzzseg	ends
		end	Main
