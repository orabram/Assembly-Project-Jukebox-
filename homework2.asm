; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386.

dseg		segment	para public 'data'
org 100h
		a dw 10 dup
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
		get
		again:
		cmp [bx], 1
		je left
		left:
		mov cx, [bx]
		cmp cx, 100
		jne scenario3
		mov bx, 110
		scenario3:
		mov [bx], cx
		dec bx
		cmp bx, 100
		je quit
		jmp again
		right:
		mov cx, [bx]
		inc bx
		cmp bx, 110
		je scenario2
		mov [bx], cx
		scenario2: 
		mov bx, 100
		mov cx, [bx]
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
