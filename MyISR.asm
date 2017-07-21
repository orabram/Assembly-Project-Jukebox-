; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386 (or later).

dseg		segment	para public 'data'
seconds db 0
dseg		ends

cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg

NumPrint		PROC
		mov ah, 2ch
		int 21h
		mov seconds, dh
		mov bl, '1'
		mov cx, 9
		mov si, 9
		loopa: 
		mov ah, 2ch
		int 21h
		cmp dh, seconds
		je loopA
		mov	ah, 2
		mov dl, bl
		int	21h
		inc bl
		inc seconds
		mov cx, si
		dec si
		loop loopa
	iRet
NumPrint EndP

Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
		
		mov		ah, 25h
		mov		al, 43 
		mov		dx, offset NumPrint
		mov		bx, seg NumPrint
		push	bx
		pop 	ds
		int		21h
		mov	ax, dseg
		mov	ds, ax
		int		02Bh		

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


