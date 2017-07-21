
		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386.
read macro amitpic
local printm1
local EOF
local fr
local nfr
mov counter, 0
xor al, al
mov ah,3dh 
lea dx, amitpic 
int 21h ;
jc EOF ; If there's a problem, close the file
mov filehandle, ax
printm1:
mov ah, 3fh
lea dx, buffer ; The data will be saved in the memory from this address
cmp counter, 0
je fr ;if it's the first reading, move on
mov cx, counter ;if not, move the amount of readings into cx
nfr:
add dx, 0ffh ;move the storage location further
loop nfr 
fr:
inc counter
mov cx, 0FFh ;Reading 255 characters
mov bx, filehandle ; moving the file handle into bx
int 21h ;reading the file
jc EOF ;if there are problems with the reading, close the file
cmp ax, cx ;check if there are characters left in the file
jne EOF ;if there are none, close the file
jmp printm1 ;if there are more characters, read another 256 characters
EOF:
mov bx, filehandle ;move the file handle into bx
mov ah, 3eh
int 21h ;close the file
endm
    
dseg		segment	para public 'data'
filehandle dw ?
counter dw ?
key dw 0
newpic db 'NP.bmp',0
eod db 'Welcome to DVC! Do You wish to encrypt or decrypt?', '$'
opt1 db '(1)Encrypt  (2)Decrypt', '$'
eis db 'Ok, encrypt it is! Now, would you like to hide your message?', '$'
opt2 db '(1)Mona Lisa  (2)The Last Supper','$'
eym db 'Ok. Please enter your message', '$'
eoe db 'The encrypted file is now in the "bin".', '$'
opt3 db ' (3)Leave', '$'
dis db 'Ok, decrypt it is! Enter your encrypted file into the "bin" folder, change its name to "NP" and click anywhere to continue."', '$'
dio db 'What do you wish to do now?', '$'
supper db 'tls.bmp',0
keytxt db 'key: ','$'
frontpic db 'fp.bmp',0
mona db 'ml.bmp',0
room db 10, 13, '$'
buffer db ?
db 65078 dup(0); 
dseg ends

sseg		segment	para stack 'stack'
    dw   128  dup(0)
sseg ends

cseg		segment	para public 'code'       
   assume cs:cseg, ds:dseg
leaveprog proc
mov ah, 4Ch
int 21h
	Ret
leaveprog EndP
   rpal proc
mov si, 499;si is the pointer, and it's located after the header.
mov cx, 256 ;there are 256 colors in the pallete
mov dx, 3C8h
mov al, 0
out dx, al ;the number of the first color in the palette that will be sent(0)
inc dx	;the rest of the colors will go to port 3C9h
sndLoop:
; Note: Colors in a BMP file are saved as BGR values and not RGB.
mov     al,[si+2] ; Get red value.
shr     al,2  ; The max value is 255, but video only allows values of up to 63.  Dividing by 4 gives a good value.                    
out     dx,al                   ; Send it.
mov     al,[si+1]               ; Get green value.
shr     al,2
out     dx,al                   ; Send it.
mov     al,[si]                 ; Get blue value.
shr     al,2
out     dx,al                   ; Send it.
add     si,4                   ; move to the next colors to next color.
loop    sndLoop
ret
	Ret
rpal EndP
paint proc
mov cx, 32000 ;there are 64K pixels in the photo. I'm reading 2 at a time, so I only have to do it 32000 times.
mov si, 1522 ;moving the starting position into si
mov di, 0 ;moving the starting position in the video memory into di
rep movsw ;moving the image data
	Ret
paint EndP
pixelchanger proc
xor si, si
xor ah, ah
mov cx, key
add cx, counter
mulloop:
add si, 320
loop mulloop
add si, ax
mov al, buffer[si]
dec al
mov buffer[si], al
inc counter
	Ret
pixelchanger EndP
segmentxor proc
mov si, 1522
xor ax, ax
xor bx, bx
xor di, di
mov cx, 64000
xorloop:
mov bl, es:[di]
mov al, ds:[si]
xor bl, al
cmp bl, 0
je continue
push si
push cx
xor dx, dx
mov bx, key
add bx, counter
mov cx, bx
xor bx, bx
mulloop2:
add bx, 320
loop mulloop2
sub si, bx
sub si, 20h
mov dx, si
mov ah, 2
int 21h
inc counter
pop cx
pop si
continue:
inc di
inc si
loop xorloop
	Ret
segmentxor EndP
newfile proc
lea dx, newpic
mov ah, 3ch
mov cx, 0
int 21h
mov filehandle, ax
mov ah, 40h
mov bx, filehandle
mov cx, 65078
lea dx, buffer
int 21h
	Ret
newfile EndP
printm proc
mov ah, 9
int 21h
	Ret
printm EndP
write proc
mov ah, 7
int 21h
	Ret
write EndP
space proc
lea dx, room
call printm
	Ret
space EndP
Main		proc
    mov ax, dseg
    mov ds, ax
    mov ax, 0013h
    int 10h
read frontpic
call rpal
mov ax, 0A000h
mov es, ax
call paint
xor ax, ax
int 16h
lea dx, eod
call printm
call space
lea dx, opt1
call printm
call space
read1:
call write
cmp al, "1"
je encrypt
cmp al, "2"
je decrypt
jne read1
encrypt:
lea dx, eis
call printm
call space
lea dx, opt2
call printm
pictime:
call write
cmp al, "1"
jne jemeal
je rml
jemeal: cmp al, "2"
jne pictime
je rlm
rml:
read mona 
call rpal
call paint
jmp next
rlm:
read supper
call rpal
call paint
next:
xor ax, ax
int 16h
mov ax, 3
int 10h
xor ax, ax
lea dx, keytxt
call printm
mov ah, 1
int 21h
mov key, ax
call space
mov counter, 0
stread:
mov ah, 1
int 21h
cmp al, ' '
je continue
call pixelchanger
jmp stread
continue:
mov ax, 13h
int 10h
call rpal
call paint
xor ax, ax
int 16h
mov ax, 6299h
mov es, ax
call paint
call newfile
mov ax, 3
int 10h
lea dx, eoe
call printm
call space
lea dx, dio
call printm
call space
lea dx, opt1
call printm
lea dx, opt3
call printm
stay:
call write
cmp al, "1"
je encrypt
cmp al, "2"
je decrypt
cmp al, "3"
jne stay
call leaveprog
decrypt:
read newpic
mov ax, 6299h
mov es, ax
call paint
mov ax, 0A000h
mov es, ax
call space
lea dx, dis
call printm
call space
lea dx, opt2
call printm
justpickone:
call write
cmp al, "1"
je rml2
cmp al, "2"
jne justpickone
je rlm2
rlm2:
read supper
call rpal
call paint
jmp next2
rml2:
read mona
call rpal
call paint
next2:
xor ax, ax
lea dx, keytxt
call printm
mov ah, 1
int 21h
mov key, ax
mov counter, 0
call segmentxor
call space
lea dx, dio
call printm
lea dx, opt1
call printm
lea dx, opt3
call printm
mov ax, 0A000h
mov es, ax
yrepeat:
call write
cmp al, "1"
je decrypt
cmp al, "2"
je encrypt
cmp al, "3"
jne yrepeat
jmp leaveprog


Quit:		ExitPgm			;DOS macro to quit program.
Main		endp

cseg		ends  
end	Main