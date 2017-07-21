; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386.

dseg		segment	para public 'data'
dseg		ends

cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg
		printsgav proc
push ax
mov al, 'S'
putc
cmp bl, 10
jng b
putcr
b:  mov al, 'g'
putc
jng e
putcr
e: mov al, 'a'
putc
jng d
putcr
d: mov al, 'v'
putc
putcr
pop ax
	Ret
printsgav EndP

Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
mov al, 15
a: mov bl, al
call printsgav
dec al
cmp al, 5
jne a



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
