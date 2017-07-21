stop		macro	duration
local Sloop
		in	al, PPI_B
		and	al, 0FCh
		out	PPI_B, al ;turning off the speaker using the B port
		mov	cx, duration ; getting the amount of time that the delay procedure will run
Sloop:	mov duration1, cx ;enter the updated value of runs into duration1
        call delay ;using the delay procedure
        mov cx, duration1 ;getting the correct value of runs back into cx
		loop	Sloop
		endm
read        macro   song, notes
local songloop, print1, EOF, fr, nfr, notasong
mov ah, 3dh 
mov al, 0 ; I want to only read the file, without editing it
lea dx, song ; moving the file's offset in the memory into dx
int 21h ; opening the file
jc EOF ; If there's a problem, close the file
mov filehandle, ax ; saving the file handle for later
print1:
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
jmp print1 ;if there are more characters, read another 256 characters
EOF:
mov bx, filehandle ;move the file handle into bx
mov ah, 3eh
int 21h ;close the file
mov counter, 0
mov cx, notes ;do this routine(songloop) according to the notes in the file
cmp cx, 0FFh
je notasong
mov di, 0 ;di will be used for memory access, so I have to reset it
songloop:
call songproc
loop songloop
notasong:
mov ax, 13h
EndM
		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386 (or later).

dseg		segment	para public 'data'
buffer2 byte ? ;this buffer will be used in order to get the note's value
A dw 2712;1
Ash dw 2560;2
B dw 2415;3
CN dw 2281;4
CSH dw 2153;5
D dw 2029;6
DSH dw 1918;7
E dw 1808;8
F dw 1709;9
FSH dw 1612;A
G dw 1522;B
GSH dw 1437;C - Those are the notes that are being used in the program
PPI_B equ 61h 
PIT_CW equ 43h
PIT_Ch2 equ 42h ;setting the ports
amazinggrace byte 'amazing.txt', 0 
photo db 'juke.bmp'
timesaver word ? ;timesaver will contain the miliseconds for the delay procedure
twinkle byte 'star.txt', 0
duration1 word ? ;duration1 will be stored here
littlej byte 'lij.txt', 0
filehandle word ? ;filehandle will be used to save the filehandle value
counter dw ?
bday db 'bday.txt', 0
joy db 'OdeToJoy.txt', 0
nas db 'Ok. Have a nice day!$'
buffer byte ?
db 65078 dup(0); the space where the songs will be stored
dseg		ends

cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg
songproc proc
push cx ;save the runs of that loop
mov al, buffer[di] ; get the first character
sub al, "0" ; turn it into a number
cmp al, 0 ;if al = 1, the program will play a note. If it's 0, it will not
jne proceed ;proceed if you need to play a note
call notnote ;call the rest procedure
proceed:
inc di ; proceed to the note value
push di ;save di value
mov bl, buffer[di] ;get the next character(the note) into bl
sub bl, "0" ; turn it from a character into a number
mov bh, 0 ;in order to make sure that bx = bl, bh must be equal to zero
cmp bx, 10h ; if the notes are above 9, they are represented as letters(A, B, C), and when you turn them into a number, you get 11h, 12h and 13h and not A, B and C, so I need to  substract them by 7 to get the correct note
jng nothex ;if it's smaller, continue
sub bl, 7 ; if it's larger, substract it by 7
nothex:
mov di, bx ; move the note into di
add di, di ; multiply it by 2 and decrease it by 1 in order to get the location of the note's divisor
dec di 
mov al, buffer2[di] ; move into al the lower half of the note
inc di ; move to the next byte, because the divisor is a word(2 bytes)
mov ah, buffer2[di] ; move into ah the higher half of the note
pop di ; restore the previous value of di
inc di ; proceed to the octave
mov bl, buffer[di] ; move the next character into bl 
sub bl, "0" ; turn it into a number(the value that will move to the macro is bx, but because bh is already equal to 0 there's no need to do it again)
inc di ; continue to the duration
mov cl, buffer[di] ; move the duration into 
sub cl, "0" ; turn it into a number
mov ch, 0 ; I need to use cx, so I must reset ch
mov dx, 5 ; dx will contain the duration, so I need to reset it(with 5, because the value from the text can be 0 so dx needs to contain the minimum duration)
cmp cx, 0 
je zerodur ;if cx = 0, don't enter the loop(because it will be infinite loop), and instead proceed with the current value of dx
durloop: 
add dx, dx ; the possible durations are 5, 10, 20 and 40, which are all the result of the number before them doubled. The number that I get from the text tells me how many times do I have to double this number.
loop durloop
zerodur:
push di ;save the place in the memory, because the macro can change it
mov duration1, dx
call Note ; call the play macro. ax contain the note, bx contain the octave and dx contain the duration
pop di ;restore the previous value
inc di ;move to the next note
pop cx ;return the first value of cx(that belongs to songloop)
	Ret
songproc EndP
delay proc
mov ah, 2ch
		int 21h ;getting the time using int 21h
		mov dh, 0 ;I want the miliseconds, which are in dl. Therefore, I must reset dh in order to be able to use dx as dl.
		mov timesaver, dx ;saving the miliseconds
		loopb:
		int 21h ;getting the time again
		mov dh, 0 ;make sure that only the miliseconds are in dx
		cmp dx, timesaver ;check if the miliseconds have changed
		je loopb ;while it's even, check again.
	Ret
delay EndP
rpal proc
mov si, 167 ;si is the pointer, and it's located after the header.
mov cx, 256 ;there are 256 colors in the pallete
mov dx, 3C8h
mov al, 0
out dx, al ;the number of the first color in the palette that will be sent(0)
inc dx	;the rest of the colors will go to port 3C9h
sndLoop:
; Note: Colors in a BMP file are saved as BGR values and not RGB.
mov al,[si+2] ; Get red value.
shr al, 2  ; The max value is 255, but video only allows values of up to 63.  Dividing by 4 gives a good value.                    
out dx, al; Send it.
mov al,[si+1]; Get green value.
shr al, 2
out dx,al; Send it.
mov al ,[si]; Get blue value.
shr al, 2
out dx, al; Send it.
add si, 4; move to the next colors to next color.
loop sndLoop
    Ret
rpal EndP
paint proc
mov cx, 32000 ;there are 64K pixels in the photo. I'm reading 2 at a time, so I only have to do it 32000 times.
mov si, 1191 ;moving the starting position into si
mov di, 0 ;moving the starting position in the video memory into di
mov ax, 0A000h 
mov es, ax ;mounting the video memory in es
rep movsw ;moving the image data
	Ret
paint EndP
Note proc
cmp bx, 0 ; checking if the octave is 0
jne continue ; if it's not, continue 
add ax, ax ; if it's 0, multiply the divisor by 4
add ax, ax
continue: 
cmp bx, 1 ; checking if the octave is 1
jne continue2 ; if it's not, continue
add ax, ax ; if it's 1, multiply the divisor by 2
continue2: ;if it's 2, there's no need to change it, because the notes are already in this octave.
push ax ; save the divisor
in al, PPI_B 
or al, 3 
out PPI_B, al ; turn on the speaker using the B port
mov al, 0B6h 
out PIT_CW, al ; move the "magic value" into 43h, in order to be able to produce notes
pop ax ; getting the divisor value
out PIT_Ch2, al ;moving the first half of the note into the port
xchg al, ah ;exchanging between ah and al, because this port can only work with al
out PIT_Ch2, al ;moving the second half into the port.
mov cx, duration1 ;getting the amount of times that the delay procedure will run
Dloop: mov duration1, cx ;moving the updated value 
call delay; Delaying the program until the note has done playing
mov cx, duration1 ;moving the correct value of the runs back into cx
loop	Dloop 
	Ret
Note EndP
notnote proc
push cx ;save the runs of the loop
inc di ; proceed to the duration
mov cl, buffer[di] ; move the duration into cl
sub cl, "0" ; turn it into a number
mov ch, 0 ; I need to use cx, so I need to reset ch
mov dx, 5 ;dx will contain the duration, so I need to reset it(with 5, because the value from the text can be 0 so dx needs to contain the minimum duration)
cmp cx, 0
je zerodur2
durloop2: 
add dx, dx ; the possible durations are 5, 10, 20 and 40, which are all the result of the number before them doubled. The number that I get from the text tells me how many times do I have to do double the duration.
loop durloop2
zerodur2:
stop dx ; calling the stop macro. dx contain the duration of the pause
inc di ;proceed to the next character
pop cx ; restore the first value of cx(the one that belongs to songloop)
	Ret
notnote EndP
Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax

read photo, 0FFh
int 10h ;Enter video mode (320x200 256 color graphics)
call rpal ;proccesing the color pallete
call paint ;Paint the music machine
call delay; reset the clock so the notes will be in the correct length
mov ah, 07h
int 21h ;getting the song's number
newsong:
sub al, 30h ;turning the character into a number
cmp al, 1 ;checking if it's "Amazing Grace"
jne notag ;if it's not, move to the next option
read amazinggrace, 34 ;if it's "Amazing Grace", read and play it.
jmp rotp ;moving to the next part
notag:
cmp al, 2 ;checking if it's "Twinkle Twinkle Little Star"
jne nott; if it's not, move to the next option
read twinkle, 24 ; if it is "Twinkle Twinkle Little Star", read and play it
jmp rotp ;moving to the next part
nott:
cmp al, 3 ;checking if it's "Little Jonathan"
jne notlj ;if it's not, move to the next option
read littlej, 39 ;if it is "Little Jonathan", read and play it
jmp rotp ;moving to the next part
notlj:
cmp al, 4 ;checking if it's "Happy Birthday"
jne notbd ;if it's not, move to the next option
read bday, 22 ;if it is "Happy Birthday", read and play it
jmp rotp ;moving to the next part
notbd:
cmp al, 5 ;checking if it's "Ode to Joy"
jne rotp ;since we covered all the options, the character that the user entered must be invalid, so I need to ask him to enter another character
read joy, 25 ;if it is "Ode to Joy", read and play it
jmp rotp ;moving to the next part
rotp:
stop 1
mov ah, 07h
xor al, al ;resetting al for later use
int 21h ;getting a character
mov ah, 09h
cmp al, "n" ;checking if the user doesn't want another song
jne newsong ;if it's false, move to the next option
lea dx, nas
int 21h ;printing the message in nas
xor ax, ax
int 16h ;wait for the user to press a button
mov ax, 3
int 10h ;return to text mode
mov	ax, 4C00h
int 21h ;closing the program
Main		endp

cseg		ends

sseg		segment	para stack 'stack'
stk		byte	1024 dup ("stack   ")
sseg		ends
		end	Main
