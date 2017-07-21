; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386.

dseg		segment	para public 'data'
		org 100h
		a db 1,2,3,4,5,6,7,8
		org 200h
		b db 2,5,6,7,8,9,10,11
		org 0h
		c db 0,0,0,0,0,0,0,0
dseg		ends

cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg

Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
;Code here:
lea bx, a
lea si, b
lea di, c
again: 
mov ax, [bx]
mov cx, [si]
cmp ax, cx
jne toagain
mov [di], [bx]
inc di
toagain:
inc bx
inc si
cmp bx, 108
je Quit
jmp again


		
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
