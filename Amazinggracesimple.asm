; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list
play		macro	divisor, octave, duration
		mov	ax, divisor
		mov	cx, duration
		mov bx, octave
		call	Note
		endm
stop		macro	duration
local Sloop
		in	al, PPI_B
		and	al, 0FCh
		out	PPI_B, al
		mov	cx, duration
Sloop:	call	Delay
		loop	Sloop
		endm

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386 (or later).

dseg		segment	para public 'data'
A dw 2712
Ash dw 2560
B dw 2415
CN dw 2281
CSH dw 2153
D dw 2029
DSH dw 1918
E dw 1808
F dw 1709
FSH dw 1612
G dw 1522
GSH dw 1437
PPI_B equ 61h
PIT_CW equ 43h
PIT_Ch2 equ 42h
RTC textequ <es:[6ch]>
dseg		ends

cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg
		Delay proc
		mov si, RTC
		loopb: cmp si, RTC
		je loopb
	Ret
Delay EndP
Note proc
cmp bx, 0
jne continue
add ax, ax
add ax, ax
continue: 
cmp bx, 1
jne continue2
add ax, ax
continue2:
push ax
in al, PPI_B 
or al, 3 
out PPI_B, al
mov al, 0B6h 
out PIT_CW, al 
pop ax
out PIT_Ch2, al 
xchg al, ah
out PIT_Ch2, al 
mov ax, 40h
mov es, ax
loopa:
mov ax, RTC 
loopb:
cmp ax, RTC
je loopb 
loop loopa

	Ret
Note EndP
Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
play CN, 1,10
play CN, 1, 10
play G, 1, 10
play G, 1, 10
play A, 1, 10
play A, 1, 10
play G, 1, 20
play F, 1, 10
play F, 1, 10
play E, 1, 10
play E, 1, 10
play D, 1, 10
play D, 1, 10
play CN, 1, 20
play G, 1, 10
play G, 1, 10
play F, 1, 10
play F, 1, 10
play E, 1, 10
play E, 1, 10
play D, 1, 20
play G, 1, 10
play G, 1, 10
play F, 1, 10
play F, 1, 10
play E, 1, 10
play E, 1, 10
play D, 1, 20
play CN, 1, 10
play CN, 1, 10
play G, 1, 10
play G, 1, 10
play A, 1, 10
play A, 1, 10
play G, 1, 20
play F, 1, 10
play F, 1, 10
play E, 1, 10
play E, 1, 10
play D, 1, 10
play D, 1, 10
play CN, 1, 20
stop 5







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
