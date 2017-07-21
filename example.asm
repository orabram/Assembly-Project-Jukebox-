; Simple version of SHELL.ASM with the dumb comments removed (except this one)

		.xlist
		include 	stdlib.a
		includelib	stdlib.lib
		.list

		.386			;Comment out these two statements
		option	segment:use16	; if you are not using an 80386 (or later).

dseg		segment	para public 'data'
STR1 DB "ENTER YOUR STRING HERE ->$"
        STR3 DB "YOUR STRING IS ->$"
        STR2 DB 80 DUP("$")
        NEWLINE DB 10,13,"$"
        N DB 5
dseg		ends

cseg		segment	para public 'code'
		assume	cs:cseg, ds:dseg

Main		proc
		mov	ax, dseg
		mov	ds, ax
		mov	es, ax
		meminit
LEA SI,STR2
        MOV CL,N
        mov ch, 0

        MOV AH,09H
        LEA DX,STR1
        INT 21H

        MOV AH,0AH
        MOV DX,SI
        INT 21H


    L1: MOV AH,09H
        LEA DX,NEWLINE
        INT 21H

        MOV AH,09H
        LEA DX,STR3
        INT 21H

        MOV AH,09H
        LEA DX,STR2+2
        INT 21H

        LOOP L1
        
        MOV AH,4CH
        INT 21H

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
