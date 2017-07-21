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
filename byte 'useless.txt'
filehandle word ?
buffer byte ?
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
mov ax, RTC
loopa: cmp ax, RTC
je loopa
Dloop: call	Delay
loop	Dloop
	Ret
Note EndP
aprint proc
mov al, buffer[si]
putc
inc si
	Ret
aprint EndP
Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
mov ah, 3dh
mov al, 0
lea dx, filename
int 21h
jc quit
mov filehandle, ax
print1:
mov ah, 3fh
lea dx, buffer
mov cx, 256
mov bx, filehandle
int 21h
jc EOF
cmp ax, cx
jne EOF
mov si, 0
Ploop:call aprint
loop Ploop
jmp print1
EOF:
mov cx, ax
cmp cx, 0
je EOF2
Ploop2:
call aprint
loop Ploop2
EOF2: 
mov bx, filehandle
mov ah, 3eh
int 21h






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
