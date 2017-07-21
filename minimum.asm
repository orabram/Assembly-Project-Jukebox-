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
min proc
pop ax
mov cx, 5
minloop: 
pop bx
cmp ax, bx
jng mini
mov ax, bx
mini:
loop minloop
putc
	Ret
min EndP
Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
mov ax, 2
push ax
mov ax, 4
push ax
mov ax, 6
push ax
mov ax, 5
push ax
mov ax, 3
push ax
call min
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
