; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386 (or later).

dseg		segment	para public 'data'
dseg		ends
100h
a db 1,2,3,-1,5,6
cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg
		numfinder proc
		mov dx, [bx]
		cmp ax, dx
		jne continue
		mov ax, dx
		putc 
		jmp quit
		continue:
		inc bx
	Ret
numfinder EndP

Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
lea bx, a
mov ax, 5
mov cx, 6
search:
call numfinder
loop search
mov ax, -1
putc
jmp quit

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
