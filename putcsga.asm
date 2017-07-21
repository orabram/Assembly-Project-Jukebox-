; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386 (or later).

dseg		segment	para public 'data'
dseg		ends

cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg
				Fibonacci	proc 	near
		cmp al, ah
		jg Scenario2
		add al, ah
		puti
		Scenario2: mov bl, ah
		mov ah, al
		mov al, bl
		add al, ah
		puti
		ret
Fibonacci	endp

Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
mov al, 1
puti
puti
mov ah, 1
mov al, 0
		mov cx, 10
		Loopprint:call 	Fibonacci
		putcr
		loop 	Loopprint
		

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
