; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386 (or later).

dseg		segment	para public 'data'
PPI_B equ 61h
PIT_CW equ 43h
PIT_Ch2 equ 42h
dseg		ends

cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg

Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
in al, PPI_B ;PPI_B is equated to 61h
or al, 3 ;Set bits zero and one.
out PPI_B, al
mov al, 0B6h ;Control word code.
out PIT_CW, al ;Write control word (port 43h).
mov al, 98h ;2712 is 0A98h.
out PIT_Ch2, al ;Write L.O. byte (port 42h).
mov al, 0Ah
out PIT_Ch2, al ;Write H.O. byte (port 42h).


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
