; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386 (or later).

dseg		segment	para public 'data'
a db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
b db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
hoursa db 0
minutesa db 0
secondsa db 0
msa db 0
hoursb db 0
minutesb db 0
secondsb db 0
msb db 0

dseg		ends

cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg
input proc
mov ah, 1
int 21h
mov [si], al

	Ret
input EndP
Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
		
mov cx, 25
mov si, offset a
xor ax, ax
loopa:
call input
mov bx, [si]
cmp bx, '$'
je continue
inc si
loop loopa
continue:
mov cx, 25
mov si, offset b
loopb:
call input
mov bx, [si]
cmp bx, '$'
je continue2
inc si
loop loopb
continue2:
mov ah, 2ch
int 21h
mov hoursa, ch
mov minutesa, cl
mov secondsa, dh
mov msa, dl
mov cx, 25
mov si, offset a
loopc:
mov ax, [si]
cmp ax, '$'
je continue3
inc si
loop loopc
continue3:
mov ah, 2ch
int 21h
sub ch, hoursa
sub cl, minutesa
sub dh, secondsa
sub dl, msa
mov hoursa, ch
mov minutesa, cl
mov secondsa, dh
mov msa, dl
mov ah, 2ch
int 21h
mov hoursb, ch
mov minutesb, cl
mov secondsb, dh
mov msb, dl
mov cx, 25
mov si, offset b
loopf:
mov ax, [si]
cmp ax, '$'
je continue5
inc si
loop loopf
continue5:
mov ah, 2ch
int 21h
sub ch, hoursb
sub cl, minutesb
sub dh, secondsb
sub dl, msb
mov hoursb, ch
mov minutesb, cl
mov secondsb, dh
mov msb, dl
mov al, hoursb
mov ah, hoursa
cmp al, ah
jne sof1
mov al, minutesb
mov ah, minutesa
cmp al, ah
jne sof2
mov al, secondsb
mov ah, secondsa
cmp al, ah
jne sof3
mov al, msb
mov ah, msa
cmp al, ah
jne sof7
mov dl, 'N'
mov ah, 2
int 21h
jmp quit
sof1:
cmp al, ah
jg sof5
mov dl, '1'
mov ah, 2
int 21h
jmp quit
sof5:
mov dl, '2'
mov ah, 2
int 21h
jmp quit
sof2:
cmp al, ah
jg sof4
mov dl, '1' 
mov ah, 2
int 21h
jmp quit
sof4:
mov dl, '2'
mov ah, 2
int 21h
jmp quit
sof3:
cmp al, ah
jg sof6
mov dl, '1'
mov ah, 2
int 21h
jmp quit
sof6:
mov dl, '2'
mov ah, 2
int 21h
jmp quit
sof7:
cmp al, ah
jg sof8
mov dl, '1'
mov ah, 2
int 21h
jmp quit
sof8:
mov dl, '2'
mov ah, 2
int 21h
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
