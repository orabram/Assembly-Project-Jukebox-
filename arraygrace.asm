; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386 (or later).

dseg		segment	para public 'data'
a dw 1,3,5,7,9
dseg		ends
cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg
arraysum proc
mov cx, 5
pop bx
pop bx
mov ax, [bx]
inc bx
push bx
arrayloop: 
pop bx
add ax, [bx]
inc bx
push bx
loop arrayloop
putc
	Ret
arraysum EndP
Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
lea bx, a
push bx
call arraysum

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
