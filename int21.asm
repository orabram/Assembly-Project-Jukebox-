; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386 (or later).

dseg		segment	para public 'data'
hourtxt db 'Hour: ', '$'
mintxt db 'Mins: ','$'
sectxt db 'Secs: ', '$'
mstxt db '1/100 sec: ', '$'
dseg		ends

cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg

Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
mov dx, 0
mov ah, 2ch
int 21h
mov bx, dx
xor ax, ax

mov dx, offset hourtxt
mov ah, 9
int 21h
xor ax, ax
mov al, ch
puti
putcr

mov dx, offset mintxt
mov ah, 9
int 21h
mov al, cl
puti
putcr

mov dx, offset sectxt
mov ah, 9
int 21h
xor ax, ax
mov al, bh
puti
putcr

mov dx, offset mstxt
mov ah, 9
int 21h
xor ax, ax
mov al, bl
puti
putcr

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
