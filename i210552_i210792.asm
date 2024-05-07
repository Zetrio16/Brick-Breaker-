;i210552 Fariz Ahmad
;i210792 JahanZaib Ahmed

open macro filename
mov ah,3dh
mov al,02
mov dx,offset filename
int 21h
jc exit1
mov fhandle,ax
exit1:
endm

write macro str, len
	mov bx, fhandle
	mov cx, 0
	mov dx, 0
	mov ah, 42h
	mov al, 2
	int 21h			; append

	mov ah, 40h		; write
	mov cl, len
	mov dx, offset str
	int 21h

endm

read macro filename, s
	mov ah, 3fh
	mov dx, offset s
	mov cx, 1000
	mov bx, fhandle
	int 21h
endm

close macro filename
		mov bx, 0
		mov cx, 0
		mov ax, 0
		mov dx, 0
mov ah,3eh
mov bx,fhandle
int 21h
exit3:
endm

MAKEBRICK1 MACRO p1,p2,p3,p4            	;For Bricks 

    mov ah, 6
    mov al, 0
    mov bh, p3     
    mov ch, p4      
    mov cl, p1      ;p1 decides the witdh
    mov dh, p4      ;p4 decides the row
    mov dl, p2      
    int 10h

ENDM

PADDLE MACRO p1,p2,p3,p4            		;For PADDLE 

    mov ah, 6
    mov al, 0
    mov bh, p3     
    mov ch, p4      
    mov cl, p1      ;p1 decides the col
    mov dh, p4      ;p4 decides the row
    mov dl, p2      
    int 10h

ENDM

MAKE_BLOCK MACRO p1,p2,p3,p4,p5

	mov ah, 6
    mov al, 0
    mov bh, p3     
    mov ch, p4      
    mov cl, p1      ;p1 decides the witdh
    mov dh, p5      ;p4 decides the row
    mov dl, p2      
    int 10h

ENDM

Cursor_Position MACRO PG_No, Col, Row  		;Position of cursor in middle in the start. 

  mov ah, 2			; Settings for Cursor POSITION
  mov bh, PG_No		; Contains Page Number which is 0 here
  mov dl, Col		; mid-point of columns (Total Cols = 80)
  mov dh, Row 		; mid-point of Rows (Total Rows = 25)

  int 10h

endm

Print_String MACRO str1,colour,len

	mov ah, 13h 		; function 13 - write string
	mov bp, offset str1
	mov al, 01h 		; attrib in bl,move cursor
	xor bh, bh 			; video page 0
	mov bl, colour 	
	mov cx, len			; length of string
	int 10h

endm

PrintAnyChar MACRO num

	mov dx,num
	mov ah,02
	int 21h

endm

Print_Colour_Char Macro x, y, z
	MOV AH, 09
	MOV AL, y			; heart ASCII
	MOV BX, z			; pg no. 0, colour 4
	MOV CL, x   		; no. of time to print heart
	INT 10H
ENDM

Beep MACRO
	mov cx,1
	mov al, 182
	out 43h, al
	mov ax, Freq
	
	out 42h, al
	mov al, ah
	out 42h, al
	in al, 61h
	
	or al, 3
	out 61h, al
	mov dx, 4240h
	mov ah, 86h
	int 15h
	in al, 61h
	
	and al, 11111100b
	out 61h, al
ENDM

Change_BG MACRO clear_screen,upper_row_num,left_column_num,lower_row_num,right_column_num,color

	MOV AH, 06h	
	MOV AL, clear_screen
	MOV ch, upper_row_num
	MOV CL, left_column_num
	MOV DH, lower_row_num
	MOV DL, right_column_num
	MOV BH, color
	INT 10h

ENDM

Display_Score macro T_Score

	mov dl,	T_Score
	add dl, 48 
	mov ah, 2
	int 21h

endm

Display_Main MACRO

	Repet:
	mov T_Score, 0
	mov T_Score2, 0
	mov T_Score3, 0

;******************** WELCOME PAGE **************************;
	Cursor_Position 0,0,0 					;PG_NUM,colnum,rows
	Change_BG 0,0,0,29,79,0h				;Whole background
	Change_BG 0,0,0,28,1,0fh        		;Left Line
	Change_BG 0,0,78,28,79,0fh        		;Right Line
	Change_BG 0,0,0,0,79,0fh        		;Upper Line
	Change_BG 0,26,0,29,79,0fh				;Lower Line

	MAKEBRICK1 62,71,04H,10					;Brick and balls
	MAKEBRICK1 60,61,01H,7
	MAKEBRICK1 63,64,03H,8
	MAKEBRICK1 66,67,05H,9
	MAKEBRICK1 69,70,0EH,8
	
	Cursor_Position 0,10,14 			;PG_NUM,colnum,rows
	Print_String NameInput,3,27 
	
	
	Cursor_Position 0,31,8				;PG_NUM,colnum,rows
	Print_String String1,2,17
	Cursor_Position 0,26,10 			;PG_NUM,colnum,rows
	Print_String String2,4,26
	
	Cursor_Position 0,48,18 			;PG_NUM,colnum,rows
	Print_String MadeBY,4,8
	Cursor_Position 0,55,20				;PG_NUM,colnum,rows
	Print_String Coder1,0Eh,12
	Cursor_Position 0,55,21				;PG_NUM,colnum,rows
	Print_String Coder2,0EH,16

	;Name Enter
	Cursor_Position 0,40,14
	mov AL, 03h
 	mov BL, 01h
  	int 10h

	mov cx, 0
	Name_enter:
	mov dx, 0
	mov ax, 0
	mov si, 0
	input:
	cmp counter, 16
	je Next1
	mov ah, 01
	int 21h
	cmp al, 13
	je Next1
	mov [NameI + si], ax
	mov [buffer + si], ax
	inc cl
	inc si
	inc counter
	jmp input

	Next1:
	mov counter, cl
	open filename

	
ENDM

Display_Menu MACRO 
	
	Cursor_Position 0,0,0 					;PG_NUM,colnum,rows
	Change_BG 0,0,0,29,79,0h				;Whole background
	Change_BG 0,0,0,28,1,0fh        		;Left Line
	Change_BG 0,0,78,28,79,0fh        		;Right Line
	Change_BG 0,0,0,0,79,0fh        			;Upper Line
	Change_BG 0,26,0,29,79,0fh
 	
	MAKEBRICK1 62,71,04H,10					;Brick and balls
	MAKEBRICK1 60,61,01H,7
	MAKEBRICK1 63,64,03H,8
	MAKEBRICK1 66,67,05H,9
	MAKEBRICK1 69,70,0EH,8

	Cursor_Position 0,31,4 				;PG_NUM,colnum,rows
	Print_String Main_Menu,5,18
	Cursor_Position 0,31,8				;PG_NUM,colnum,rows
	Print_String String1,2,17
	Cursor_Position 0,26,10 			;PG_NUM,colnum,rows
	Print_String String2,4,26

;;;;;;;PLay Button

	Cursor_Position 0,14,15				;Play Button
	Print_Colour_Char 1,4,0bh
	Cursor_Position 0,16,15
	Print_String Play_button,1,4
	Cursor_Position 0,21,15
	Print_Colour_Char 1,4,0bh
	Cursor_Position 0,9,17
	Print_String PlayButton,0bH,18			;Play String

;;;;;;;Manual Button

	Cursor_Position 0,35,15
	Print_Colour_Char 1,5,0EH
	Cursor_Position 0,37,15 
	Print_String Manual_Button,06H,6			;Manual Button
	Cursor_Position 0,44,15 
	Print_Colour_Char 1,5,0Eh
	Cursor_Position 0,30,17 
	Print_String Manual,0EH,23					;Manual String

;;;;;;;Quit Button
	Cursor_Position 0,58,15
	Print_Colour_Char 1,6,0AH
	Cursor_Position 0,60,15 
	Print_String Quit_button,02h,4			;Quit Button
	Cursor_Position 0,65,15
	Print_Colour_Char 1,6,0AH
	Cursor_Position 0,55,17				;Quit String
	Print_String ENDG,0AH,17
;;;;;;;Score Button

	Cursor_Position 0,35,20
	Print_Colour_Char 1,1,0cH
	Cursor_Position 0,37,20
	Print_String Score_B,04H,6
	Cursor_Position 0,44,20
	Print_Colour_Char 1,1,0CH
	Cursor_Position 0,29,21
	Print_String TS_STR,0CH,23
	
;press check

	Cursor_Position 0,5,2	
	Print_String Wel, 3, 2
	Cursor_Position 0,8,2
	Print_Name NameI,3,counter
	ENDGAME:				;Quit button press check
	mov ah, 0
	int 16h

	cmp al, 113				;Manual button press check
	je BYE1

	cmp al, 112				;Play button press check
	je BYE2

	cmp al, 109
	je BYE3

	cmp al, 115
	je Bye6

	jmp ENDGAME

ENDM

Display_Manual MACRO 

	Show:

	Cursor_Position 0,0,0 					;PG_NUM,colnum,rows
	Change_BG 0,0,0,29,79,00h				;Whole background
	Change_BG 0,0,0,28,1,0fh        		;Left Line
	Change_BG 0,0,78,28,79,0fh        		;Right Line
	Change_BG 0,0,0,0,79,0fh    			;Upper Line
	Change_BG 0,26,0,29,79,0fh				;Lower Line

	Cursor_Position 0,29,4 
	Print_String inst6,4,21
	Cursor_Position 0,4,8 
	Print_String inst1,2,55
	Cursor_Position 0,4,10 
	Print_String inst2,3,53
	Cursor_Position 0,4,12 
	Print_String inst3,5,47
	Cursor_Position 0,4,14 
	Print_String inst4,6,38
	Cursor_Position 0,4,16 
	Print_String inst7,0BH,67
	Cursor_Position 0,4,18 
	Print_String inst8,0EH,43
	Cursor_Position 0,4,20 
	Print_String inst5,0CH,39
	

	mov ah, 0
	int 16h
	cmp al, 8
	je BYE4

	jmp Show

ENDM

Display_TS MACRO

	SC:

	Cursor_Position 0,0,0 					;PG_NUM,colnum,rows
	Change_BG 0,0,0,29,79,00h				;Whole background
	Change_BG 0,0,0,28,1,0fh        		;Left Line
	Change_BG 0,0,78,28,79,0fh        		;Right Line
	Change_BG 0,0,0,0,79,0fh    			;Upper Line
	Change_BG 0,26,0,29,79,0fh				;Lower Line

	Cursor_Position 0,29,4 
	Print_String TS,4,14

	Cursor_Position 0,2,6
	read filename, buffer					;reading file
	Cursor_Position 0,11,8

	mov si, 0
	mov cnt, 0
	mov bl, 0
	mov ex, 8
	hehe:
		
		mov ax, [buffer+si]
		.if al == ' '
			inc bl
		.endif
		.if bl == 4
			add ex, 2
			Cursor_Position 0,10,ex
			mov bl, 0

		.endif
		PrintAnyChar ax
		cmp cnt, 80
		je okk
		inc si
		inc cnt

	jmp hehe

	okk:
	Cursor_Position 0,4,20 
	Print_String inst5,0CH,39
	mov ah, 0
	int 16h
	cmp al, 8
	je BYE4

	jmp SC
ENDM

ALLBRICKS MACRO

	Change_BG 0,0,0,29,79,0Fh				;Whole background

                            ;set bricks row 1
	MAKEBRICK1 1,10,C11,3
	MAKEBRICK1 12,22,C12,3
	MAKEBRICK1 24,34,C13,3
	MAKEBRICK1 36,46,C14,3
	MAKEBRICK1 48,58,C15,3
	MAKEBRICK1 60,70,C16,3
                            ;set bricks row 2
	MAKEBRICK1 1,10,C21,5
	MAKEBRICK1 12,22,C22,5
	MAKEBRICK1 24,34,C23,5
	MAKEBRICK1 36,46,C24,5
	MAKEBRICK1 48,58,C25,5
	MAKEBRICK1 60,70,C26,5
                            ;set bricks row 1
	MAKEBRICK1 1,10,C31,7
	MAKEBRICK1 12,22,C32,7
	MAKEBRICK1 24,34,C33,7
	MAKEBRICK1 36,46,C34,7
	MAKEBRICK1 48,58,C35,7
	MAKEBRICK1 60,70,C36,7
                            ;set bricks row 1
	MAKEBRICK1 1,10,C41,9
	MAKEBRICK1 12,22,C42,9
	MAKEBRICK1 24,34,C43,9
	MAKEBRICK1 36,46,C44,9
	MAKEBRICK1 48,58,C45,9
	MAKEBRICK1 60,70,C46,9

	Change_BG 0,0,73,28,79,0 
	Change_BG 0,0,0,0,79,0		

ENDM

Print_Name macro str, color ,len
	mov ah, 13h 		; function 13 - write string
	mov bp, offset str
	mov al, 01h 		; attrib in bl,move cursor
	xor bh, bh 			; video page 0
	mov bl, color 	
	mov cl, len			; length of string
	int 10h
endm

KEYSTROKE MACRO

	mov cx, 0
	mov ah, 0
	int 16h

	cmp ah, 1			;For pause press Esc
	je POS2
	jne POS3

	POS2:					;;;;;;PAUSE LOOP 

		MAKE_BLOCK 22,49,0,11,19
		Cursor_Position 0,32,12
		Print_String Break1,4,7			
		Cursor_Position 0,25,13
		Print_String Break2,5,23
		Cursor_Position 0,34,14
		Print_String Quit_button,0Eh,4			;pause options
		Cursor_Position 0,28,15
		Print_String ENDG,2,17
		Cursor_Position 0,26,17				
		Print_String resetStr,0Ch,20
		Cursor_Position 0,32,16				
		Print_String reset,1,9
		
		

		mov ah, 0
		int 16h
		cmp ah, 1				;For pause
		je POS4					
		cmp al, 113				;For Quit during game
		je BYE1
		cmp al, 114				;For Restart
		je Restart
	
	jmp POS2				;;;;;;PAUSE LOOP

	POS4:
		Change_BG 0,0,0,0,0,0fH

	POS3:
				
	cmp al, 113				;For Quit during game
	je BYE1

	cmp ah, 04dh             ;right key 
	jne NOKEY	

	mov bl, PAD2
	cmp bl, 69
	ja NOKEY1

	add PAD1,2
	add PAD2,2

	NOKEY:

	cmp ah, 04bh             ;left key 
	jne NOKEY1	

	mov bl, PAD1
	cmp bl, 2
	jb NOKEY1

	sub PAD1,2
	sub PAD2,2

	NOKEY1:

	cmp ah, 039h			;Space key for using powerup
	jne NoPower
	.if PowerUP1 > 0
		dec PowerUP1
		inc LI
	.endif

	NoPower:

ENDM

Game MACRO

	Restart:

	mov lev, 3
	
	mov ax, 1003h
	mov bx, 0 ; disable blinking.
	int 10h


	BYE5:

	mov movCx, 30	;moving ball in columns 
	mov movCx1, 31	;moving ball in columns
	mov PAD1, 25
	mov PAD2, 39

	mov movDx, 21	;moving ball in rows
	mov al, movDx
	mov movDx1, al
	inc movDx1

	mov C11, 0DH
	mov C12, 1
	mov C13, 2
	mov C14, 4
	mov C15, 3
	mov C16, 5
	mov C21, 6
	mov c22, 5
	mov C23, 4
	mov C24, 3
	mov C25, 2
	mov C26, 1
	mov C31, 0AH
	mov C32, 1
	mov C33, 2
	mov C34, 1
	mov C35, 4
	mov C36, 5
	mov C41, 6
	mov C42, 0BH
	mov C43, 1
	mov C44, 2
	mov C45, 6
	mov C46, 4

	ALLBRICKS
	MAKE_BLOCK movCx,movCx1,0Ch,movDx,movDx
	MAKEBRICK1 PAD1,PAD2,1,23			;PADDLE

	mov ax, 1003h
	mov bx, 0 ; disable blinking.
	int 10h

	Cursor_Position 0,30,0 				;PG_NUM,colnum,rows
	.if lev == 1
		Print_String level1,4,8
		mov PowerUP1,2
		mov LI, 3
		mov T_Score, 0
		mov T_Score2, 0
		mov T_Score3, 0
		mov PAD1, 25
		mov PAD2, 39
		mov C111, 0
		mov C121, 0
		mov C131, 0
		mov C141, 0
		mov C151, 0
		mov C161, 0
		mov C211, 0
		mov c221, 0
		mov C231, 0
		mov C241, 0
		mov C251, 0
		mov C261, 0
		mov C311, 0
		mov C321, 0
		mov C331, 0
		mov C341, 0
		mov C351, 0
		mov C361, 0
		mov C411, 0
		mov C421, 0
		mov C431, 0
		mov C441, 0
		mov C451, 0
		mov C461, 0
	.endif
	.if lev == 2
		Print_String level2,4,8
		mov PowerUP1,2
		mov LI, 3
		mov Xvel, 1
		mov Yvel, 1
		mov PAD1, 27
		mov PAD2, 39
		mov C111, 1
		mov C121, 1
		mov C131, 1
		mov C141, 1
		mov C151, 1
		mov C161, 1
		mov C211, 1
		mov c221, 1
		mov C231, 1
		mov C241, 1
		mov C251, 1
		mov C261, 1
		mov C311, 1
		mov C321, 1
		mov C331, 1
		mov C341, 1
		mov C351, 1
		mov C361, 1
		mov C411, 1
		mov C421, 1
		mov C431, 1
		mov C441, 1
		mov C451, 1
		mov C461, 1
	.endif
	.if lev == 3
		Print_String level3,4,8
		mov LI, 3
		mov PowerUP1,2
		mov Xvel, 1
		mov Yvel, 1
		mov PAD1, 29
		mov PAD2, 39
		mov C111, 2
		mov C121, 2
		mov C131, 2
		mov C141, 2
		mov C151, 2
		mov C161, 2
		mov C211, 2
		mov c221, 2
		mov C231, 2
		mov C241, 2
		mov C251, 2
		mov C261, 2
		mov C311, 2
		mov C321, 2
		mov C331, 2
		mov C341, 2
		mov C351, 2
		mov C361, 2
		mov C411, 2
		mov C421, 2
		mov C431, 2
		mov C441, 2
		mov C451, 2
		mov C461, 2
	.endif
	.if lev == 4
		jmp Bye1
	.endif

	Hola:		
		mov ah,0
		int 16h
		cmp al, 32
		je Hola2
	jmp Hola
	Hola2:

	POS:								;Game loop

	ALLBRICKS							;Making bricks and graphics.

	Cursor_Position 0,73,2				;Power life
	Print_Name PowerStr,04H,7
	Cursor_Position 0,76,3
	mov al, PowerUP1
	Print_Colour_Char PowerUP1,2,0AH

	Cursor_Position 0,30,0
	.if lev == 1
		Print_String level1,2,8
	.endif
	.if lev == 2
		Print_String level2,9,8
	.endif
	.if lev == 3
		Print_String level3,5,8
	.endif
	.if T_Score == 10
		inc T_Score2
		mov T_Score, 0
	.endif
	.if T_Score2 == 10
			inc T_Score3
			mov T_Score, 0
			mov T_Score2, 0
		.endif

	Cursor_Position 0,2,0 				
	Print_String Score,6,7				
	Display_Score T_Score3
	Display_Score T_Score2				;Top Lines
	Display_Score T_Score
	Cursor_Position 0,55,0
	Print_Name NameI,4,counter

	Cursor_Position 0,70,0 				
	Print_String Lives,0EH,6
	.if LI == 0							;line 651 , dec LI
		jmp Bye1
	.endif
	Print_Colour_Char LI, 3,4

	MAKEBRICK1 PAD1,PAD2,1,23					;PADDLE
	MAKE_BLOCK movCx,movCx1,0Ch,movDx,movDx 	;Ball

	

;;;;;;;;;;;;;;;;;;;;;;;;;Wall Touch;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	cmp Xvel, 1
	je check_UP
	jne check_DOWN

	check_UP:

		cmp Yvel, 1
		je check_up1
		cmp Yvel, 0
		je check_up2

	check_up1:					;x=1, y=1

		cmp movDx, 1				
		je mov_up_RightDown
		cmp movCx1, 72
		je mov_up_LeftUP 

		inc movCx
		inc movCx1
		dec movDx
		jmp e

	mov_up_RightDown:			;upper wall

		inc movCx
		inc movCx1
		inc movDx				;if moving up on right velocity when touched the upper wall, move down e.g reflection.
		mov Xvel, 1
		mov Yvel, 0
		jmp e

	mov_up_LeftUP:				;right wall

		dec movCx
		dec movCx1
		dec movDx
		mov Xvel, 0
		mov Yvel, 1
		jmp e

	check_up2:					;x=1, y=0

		cmp movDx, 24				
		je mov_up_RightUp 
		cmp movCx1, 72 
		je mov_up_LeftDown

		inc movCx
		inc movCx1
		inc movDx
		jmp e

	mov_up_RightUp:
	
		inc movCx
		inc movCx1
		dec movDx				;if moving up on right velocity when touched the upper wall, move down e.g reflection.
		mov Xvel, 1
		mov Yvel, 1
		dec LI
		jmp e

	mov_up_LeftDown:
		dec movCx
		dec movCx1
		inc movDx
		mov Xvel, 0
		mov Yvel, 0
		jmp e

	check_DOWN:

		cmp Yvel, 1
		je check_up3
		cmp Yvel, 0
		je check_up4

	check_up3:					;x=0, y=1

		cmp movDx, 1				
		je mov_up_RightUp2
		cmp movCx, 0
		je mov_up_LeftDown2 

		dec movCx
		dec movCx1
		dec movDx
		jmp e

	mov_up_RightUp2:			;upper wall

		dec movCx
		dec movCx1
		inc movDx				;if moving up on right velocity when touched the upper wall, move down e.g reflection.
		mov Xvel, 0
		mov Yvel, 0
		jmp e

	mov_up_LeftDown2:			;right wall

		inc movCx
		inc movCx1
		dec movDx
		mov Xvel, 1
		mov Yvel, 1
		jmp e

	check_up4:					;x=0, y=0

		cmp movDx, 24				
		je mov_up_RightDown2 
		cmp movCx, 0 
		je mov_up_LeftUp2

		dec movCx
		dec movCx1
		inc movDx
		jmp e

	mov_up_RightDown2:

		dec movCx
		dec movCx1
		dec movDx				;if moving up on right velocity when touched the upper wall, move down e.g reflection.
		mov Xvel, 0
		mov Yvel, 1
		dec LI
		jmp e

	mov_up_LeftUp2:

		inc movCx
		inc movCx1
		inc movDx
		mov Xvel, 1
		mov Yvel, 0
		jmp e

	e:
	mov ax, 1003h
	mov bx, 0 ; disable blinking.
	int 10h
;;;;;;;;;;;;;;;;;;;;;;;;;Wall Touch;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;Paddle Touch;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov cl, PAD1
	mov ch, PAD2
	.if movDx == 22 || movDx == 23
		.if movCx >= cl && movCx1 <= ch || movCx < cl && movCx1 == cl || movCx == ch && movCx1 > ch
			.if Yvel == 0 && Xvel == 1
			mov Xvel, 1
			mov Yvel, 1
			.endif
			.if Yvel == 0 && Xvel == 0
			mov Xvel, 0
			mov Yvel, 1
			.endif
		.endif
	.endif
;;;;;;;;;;;;;;;;;;;;;;;;;Paddle Touch;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;Brick Touch;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;Special Brick = 34
	.if (movCx>=1 && movCx1<=10)  ||  (movCx<1 && movCx1==1)  || (movCx==10 && movCx1>=10)		;1st col, 4 brick
		.if Xvel==1 && Yvel==1
			.if movDx == 10
				.if C41 != 0FH
					add C41,8 
					.if	C411 == 0
						mov C41,0Fh
					.endif
					Beep
					dec C411
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C31 != 0FH 
					add C31,8
					.if	C311 == 0
						mov C31,0Fh
					.endif
					dec C311
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C21 != 0FH
					add C21,8
					.if	C211 == 0
						mov C21,0Fh
					.endif
					dec C211
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C11 != 0FH
					add C11,8
					.if	C111 == 0
						mov C11,0Fh
					.endif
					dec C111
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif	
		.endif
		.if Xvel==0 && Yvel==1	
			.if movDx == 10
				.if C41 != 0FH
					add C41,8
					.if	C411 == 0
						mov C41,0Fh
					.endif
					dec C411
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C31 != 0FH
					add C31,8
					.if	C311 == 0
						mov C31,0Fh
					.endif
					dec C311
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C21 != 0FH
					add C21,8
					.if	C211 == 0
						mov C21,0Fh
					.endif
					dec C211
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C11 != 0FH
					add C11,8
					.if	C111 == 0
						mov C11,0Fh
					.endif
					dec C111
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==0 && Yvel==0	
			.if movDx == 8
				.if C41 != 0FH
					add C41,8
					.if	C411 == 0
						mov C41,0Fh
					.endif
					dec C411
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C31 != 0FH
					add C31,8
					.if	C311 == 0
						mov C31,0Fh
					.endif
					dec C311
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C21 != 0FH
					add C21,8
					.if	C211 == 0
						mov C21,0Fh
					.endif
					dec C211
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C11 != 0FH
					add C11,8
					.if	C111 == 0
						mov C11,0Fh
					.endif
					dec C111
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==1 && Yvel==0	
			.if movDx == 8
				.if C41 != 0FH
					add C41,8
					.if	C411 == 0
						mov C41,0Fh
					.endif
					dec C411
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C31 != 0FH
					add C31,8
					.if	C311 == 0
						mov C31,0Fh
					.endif
					dec C311
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C21 != 0FH
					add C21,8
					.if	C211 == 0
						mov C21,0Fh
					.endif
					dec C211
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C11 != 0FH
					add C11,8
					.if	C111 == 0
						mov C11,0Fh
					.endif
					dec C111
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
	.endif
	.if (movCx>=12 && movCx1<=22) || (movCx<12 && movCx1==12) || (movCx==22 && movCx1>=22)		;2nd col, 4 brick
		.if Xvel==1 && Yvel==1
			.if movDx == 10
				.if C42 != 0FH
					add C42,8
					.if	C421 == 0
						mov C42,0Fh
					.endif
					dec C421
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C32 != 0FH
					add C32,8
					.if	C321 == 0
						mov C32,0Fh
					.endif
					dec C321
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C22 != 0FH
					add C22,8
					.if	C221 == 0
						mov C22,0Fh
					.endif
					dec C221
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C12 != 0FH
					add C12,8
					.if	C121 == 0
						mov C12,0Fh
					.endif
					dec C121
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==0 && Yvel==1
			.if movDx == 10
				.if C42 != 0FH
					add C42,8
					.if	C421 == 0
						mov C42,0Fh
					.endif
					dec C421
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C32 != 0FH
					add C32,8
					.if	C321 == 0
						mov C32,0Fh
					.endif
					dec C321
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C22 != 0FH
				add C31,8
					.if	C221 == 0
						mov C22,0Fh
					.endif
					dec C221
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C12 != 0FH
				add C12,8
					.if	C121 == 0
						mov C12,0Fh
					.endif
					dec C121
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==0 && Yvel==0
			.if movDx == 8
				.if C42 != 0FH
					add C42,8
					.if	C421 == 0
						mov C42,0Fh
					.endif
					dec C421
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C32 != 0FH
					add C32,8
					.if	C321 == 0
						mov C32,0Fh
					.endif
					Beep
					dec C321
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C22 != 0FH
					add C22,8
					.if	C221 == 0
						mov C22,0Fh
					.endif
					Beep
					dec C221
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C12 != 0FH
					add C12,8
					.if	C121 == 0
						mov C12,0Fh
					.endif
					Beep
					dec C121
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==1 && Yvel==0
			.if movDx == 8
				.if C42 != 0FH
					add C42,8
					.if	C421 == 0
						mov C42,0Fh
					.endif
					Beep
					dec C421
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C32 != 0FH
					add C32,8
					.if	C321 == 0
						mov C32,0Fh
					.endif
					Beep
					dec C321
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C22 != 0FH
					add C22,8
					.if	C221 == 0
						mov C22,0Fh
					.endif
					Beep
					dec C221
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C12 != 0FH
					add C12,8
					.if	C121 == 0
						mov C12,0Fh
					.endif
					Beep
					dec C121
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
	.endif
	.if (movCx>=24 && movCx1<=34) || (movCx<24 && movCx1==24) || (movCx==34 && movCx1>=34)		;3rd col, 4 brick
		.if Xvel==1 && Yvel==1
			.if movDx == 10
				.if C43 != 0FH
					add C43,8
					.if	C431 == 0
						mov C43,0Fh
					.endif
					dec C431
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C33 != 0FH
					add C33,8
					.if	C331 == 0
						mov C33,0Fh
					.endif
					dec C331
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C23 != 0FH
					add C23,8
					.if	C231 == 0
						mov C23,0Fh
					.endif
					Beep
					dec C231
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C13 != 0FH
					add C13,8
					.if	C131 == 0
						mov C13,0Fh
					.endif
					dec C131
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==0 && Yvel==1	
			.if movDx == 10
				.if C43 != 0FH
					add C43,8
					.if	C431 == 0
						mov C43,0Fh
					.endif
					dec C431
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C33 != 0FH
					add C33,8
					.if	C331 == 0
						mov C33,0Fh
					.endif
					Beep
					dec C331
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C23 != 0FH
					add C23,8
					.if	C231 == 0
						mov C23,0Fh
					.endif
					Beep
					dec C231
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C13 != 0FH
					add C13,8
					.if	C131 == 0
						mov C13,0Fh
					.endif
					Beep
					dec C131
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==0 && Yvel==0	
			.if movDx == 8
				.if C43 != 0FH
					add C43,8
					.if	C431 == 0
						mov C43,0Fh
					.endif
					Beep
					dec C431
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C33 != 0FH
					add C33,8
					.if	C331 == 0
						mov C33,0Fh
					.endif
					dec C331
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C23 != 0FH
					add C23,8
					.if	C231 == 0
						mov C23,0Fh
					.endif
					dec C231
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C13 != 0FH
					add C13,8
					.if	C131 == 0
						mov C13,0Fh
					.endif
					Beep
					dec C131
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==1 && Yvel==0	
			.if movDx == 8
				.if C43 != 0FH
					add C43,8
					.if	C431 == 0
						mov C43,0Fh
					.endif
					Beep
					dec C431
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C33 != 0FH
					add C33,8
					.if	C331 == 0
						mov C33,0Fh
					.endif
					Beep
					dec C331
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C23 != 0FH
					add C23,8
					.if	C231 == 0
						mov C23,0Fh
					.endif
					dec C231
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C13 != 0FH
					add C13,8
					.if	C131 == 0
						mov C13,0Fh
					.endif
					Beep
					dec C131
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
	.endif
	.if (movCx>=36 && movCx1<=46) || (movCx<36 && movCx1==36) || (movCx==46 && movCx1>=46)		;4th col, 4 brick
		.if Xvel==1 && Yvel==1
			.if movDx == 10
				.if C44 != 0FH
					add C44,8
					.if	C441 == 0
						mov C44,0Fh
					.endif
					Beep
					dec C441
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C34 != 0FH
					add C34,8
					.if	C341 == 0
						.if lev == 3			;Special Brick
							mov C15, 0fh
							mov C25, 0fh
							mov C36, 0fh
							mov C42, 0fH
							mov C13, 0fh
						.endif
						mov C34,0Fh
					.endif
					dec C341
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C24 != 0FH
					add C24,8
					.if	C241 == 0
						mov C24,0Fh
					.endif
					Beep
					dec C241
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C14 != 0FH
					add C14,8
					.if	C141 == 0
						mov C14,0Fh
					.endif
					Beep
					dec C141
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==0 && Yvel==1	
			.if movDx == 10
				.if C44 != 0FH
					add C44,8
					.if	C441 == 0
						mov C44,0Fh
					.endif
					Beep
					dec C441
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C34 != 0FH
					add C34,8
					.if	C341 == 0
						mov C34,0Fh
						.if lev == 3			;Special Brick
							mov C15, 0fh
							mov C25, 0fh
							mov C36, 0fh
							mov C42, 0fH
							mov C13, 0fh
						.endif
					.endif
					dec C341
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C24 != 0FH
					add C24,8
					.if	C241 == 0
						mov C24,0Fh
					.endif
					dec C241
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C14 != 0FH
					add C14,8
					.if	C141 == 0
						mov C14,0Fh
					.endif
					dec C141
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==0 && Yvel==0	
			.if movDx == 8
				.if C44 != 0FH
					add C44,8
					.if	C441 == 0
						mov C44,0Fh
					.endif
					dec C441
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C34 != 0FH
					add C34,8
					.if	C341 == 0
						mov C34,0Fh
						.if lev == 3			;Special Brick
							mov C15, 0fh
							mov C25, 0fh
							mov C36, 0fh
							mov C42, 0fH
							mov C13, 0fh
						.endif
					.endif
					dec C341
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C24 != 0FH
					add C24,8
					.if	C241 == 0
						mov C24,0Fh
					.endif
					dec C241
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C14 != 0FH
					add C14,8
					.if	C141 == 0
						mov C14,0Fh
					.endif
					dec C141
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==1 && Yvel==0	
			.if movDx == 8
				.if C44 != 0FH
					add C44,8
					.if	C441 == 0
						mov C44,0Fh
					.endif
					dec C441
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C34 != 0FH
					add C34,8
					.if	C341 == 0
						.if lev == 3			;Special Brick
							mov C15, 0fh
							mov C25, 0fh
							mov C36, 0fh
							mov C42, 0fH
							mov C13, 0fh
						.endif
						mov C34,0Fh
					.endif
					dec C341
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C24 != 0FH
					add C24,8
					.if	C241 == 0
						mov C24,0Fh
					.endif
					dec C241
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C14 != 0FH
					add C14,8
					.if	C141 == 0
						mov C14,0Fh
					.endif
					dec C141
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
	.endif
	.if (movCx>=48 && movCx1<=58) || (movCx<48 && movCx1==48) || (movCx==58 && movCx1>=58)		;5th col, 4 brick
		.if Xvel==1 && Yvel==1
			.if movDx == 10
				.if C45 != 0FH
					add C45,8
					.if	C451 == 0
						mov C45,0Fh
					.endif
					dec C451
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C35 != 0FH
					add C35,8
					.if	C351 == 0
						mov C35,0Fh
					.endif
					dec C351
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C25 != 0FH
					add C25,8
					.if	C251 == 0
						mov C25,0Fh
					.endif
					dec C251
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C15 != 0FH
					add C15,8
					.if	C151 == 0
						mov C15,0Fh
					.endif
					dec C151
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==0 && Yvel==1	
			.if movDx == 10
				.if C45 != 0FH
					add C45,8
					.if	C451 == 0
						mov C45,0Fh
					.endif
					dec C451
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C35 != 0FH
					add C35,8
					.if	C351 == 0
						mov C35,0Fh
					.endif
					dec C351
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C25 != 0FH
					add C25,8
					.if	C251 == 0
						mov C25,0Fh
					.endif
					dec C251
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C15 != 0FH
					add C15,8
					.if	C151 == 0
						mov C15,0Fh
					.endif
					dec C151
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==0 && Yvel==0	
			.if movDx == 8
				.if C45 != 0FH
					add C45,8
					.if	C451 == 0
						mov C45,0Fh
					.endif
					dec C451
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C35 != 0FH
					add C35,8
					.if	C351 == 0
						mov C35,0Fh
					.endif
					dec C351
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C25 != 0FH
					add C25,8
					.if	C251 == 0
						mov C25,0Fh
					.endif
					dec C251
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C15 != 0FH
					add C15,8
					.if	C151 == 0
						mov C15,0Fh
					.endif
					dec C151
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==1 && Yvel==0	
			.if movDx == 8
				.if C45 != 0FH
					add C45,8
					.if	C451 == 0
						mov C45,0Fh
					.endif
					dec C451
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C35 != 0FH
					add C35,8
					.if	C351 == 0
						mov C35,0Fh
					.endif
					dec C351
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C25 != 0FH
					add C25,8
					.if	C251 == 0
						mov C25,0Fh
					.endif
					dec C251
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C15 != 0FH
					add C15,8
					.if	C151 == 0
						mov C15,0Fh
					.endif
					dec C151
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
	.endif
	.if (movCx>=60 && movCx1<=70) || (movCx<60 && movCx1==60) || (movCx==70 && movCx1>=70)		;6th col, 4 brick
		.if Xvel==1 && Yvel==1
			.if movDx == 10
				.if C46 != 0FH
					add C46,8
					.if	C461 == 0
						mov C46,0Fh
					.endif
					dec C461
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C36 != 0FH
					add C36,8
					.if	C361 == 0
						mov C36,0Fh
					.endif
					dec C361
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C26 != 0FH
					add C26,8
					.if	C261 == 0
						mov C26,0Fh
					.endif
					dec C261
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C16 != 0FH
					add C16,8
					.if	C161 == 0
						mov C16,0Fh
					.endif
					dec C161
					Beep
					mov Xvel, 1
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==0 && Yvel==1	
			.if movDx == 10
				.if C46 != 0FH
					add C46,8
					.if	C461 == 0
						mov C46,0Fh
					.endif
					dec C461
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 8
				.if C36 != 0FH
					add C36,8
					.if	C361 == 0
						mov C36,0Fh
					.endif
					dec C361
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C26 != 0FH
					add C26,8
					.if	C261 == 0
						mov C26,0Fh
					.endif
					dec C261
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C16 != 0FH
					add C16,8
					.if	C161 == 0
						mov C16,0Fh
					.endif
					dec C161
					Beep
					mov Xvel, 0
					mov Yvel, 0
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==0 && Yvel==0	
			.if movDx == 8
				.if C46 != 0FH
					add C46,8
					.if	C461 == 0
						mov C46,0Fh
					.endif
					dec C461
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C36 != 0FH
					add C36,8
					.if	C361 == 0
						mov C36,0Fh
					.endif
					dec C361
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C26 != 0FH
					add C26,8
					.if	C261 == 0
						mov C26,0Fh
					.endif
					dec C261
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C16 != 0FH
					add C16,8
					.if	C161 == 0
						mov C16,0Fh
					.endif
					dec C161
					Beep
					mov Xvel, 0
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
		.if Xvel==1 && Yvel==0	
			.if movDx == 8
				.if C46 != 0FH
					add C46,8
					.if	C461 == 0
						mov C46,0Fh
					.endif
					dec C461
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 6
				.if C36 != 0FH
					add C36,8
					.if	C361 == 0
						mov C36,0Fh
					.endif
					dec C361
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 4
				.if C26 != 0FH
					add C26,8
					.if	C261 == 0
						mov C26,0Fh
					.endif
					dec C261
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
			.if movDx == 2
				.if C16 != 0FH
					add C16,8
					.if	C161 == 0
						mov C16,0Fh
					.endif
					dec C161
					Beep
					mov Xvel, 1
					mov Yvel, 1
					inc T_Score
				.endif
			.endif
		.endif
	.endif
	.if C11==0fH && C12==0fH && C13==0fH && C14==0fH && C15==0fH && C16 ==0fH					;Next level
		.if C21==0fH && C22==0fH && C23==0fH && C24==0fH && C25==0fH && C26 ==0fH
			.if C31==0fH && C32==0fH && C33==0fH && C34==0fH && C35==0fH && C36 ==0fH
				.if C41==0fH && C42==0fH && C43==0fH && C44==0fH && C45==0fH && C46 ==0fH
					inc lev
					jmp BYE5
				.endif
			.endif
		.endif
	.endif

	mov ax, 1003h
	mov bx, 0 ; disable blinking.
	int 10h

;;;;;;;;;;;;;;;;;;;;;;;;;Brick Touch;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov cx, 0h
	.if lev == 1
		mov dx, 0FFFFh
	.endif
	.if lev == 2
		mov dx, 0E6E8h
	.endif
	.if lev == 3
		mov dx, 0D6D8h
	.endif
	
	mov ah, 86H
	int 15h
	mov ah, 1
	int 16h
	jz skip
	
	KEYSTROKE			;checks key presses

	skip:

	mov ax, 1003h
	mov bx, 0 ; disable blinking.
	int 10h

	jmp POS					;MOST OUTER LOOP

ENDM

include a1.lib
.model small
.stack 100h
.data

	NameI dw 8 dup(0)
	T_Score3 db 0
	T_Score2 db 0
	T_Score db 0
	ScoreArr db 3 dup(0), '$'
	Khali db ' $'
	Wel db 'Hi$'
	ex db 0
	cnt db 0
	NameInput db 'Enter Your Name To Start : $'
	String1 db  '|<<< WELCOME >>>|','$'
	String2 db '|<<< To Brick Breaker >>>|','$'
	MadeBY db 'Made by:$'
	Coder1 db '>Fariz Ahmad','$'
	Coder2 db '>Jahanzaib Ahmad','$'
    Main_Menu db "*** MAIN MENU ****",'$'
	filename db 'Project_Files.txt',0
	fhandle dw 0
	buffer dw 5000 dup(0)
	counter db 0
	Play_button db 'PLAY$'
	PlayButton db '|Press P to Start|$'
	Manual_Button db 'MANUAL$'
	Manual db '|Press M to see Manual|$'
	Quit_button db 'QUIT$'
	ENDG db 4,'Press Q to Quit',4,'$'
	Break1 db 4,'PAUSE',4,'$'
	Break2 db 5,'Press Esc to Continue',5,'$'
	resetStr db 6,'Press R to Restart',6,'$'
	reset db 4,'RESTART',4,'$'
	PowerStr db 4,'Power',4,'$'
	PowerUP1 db 2
	Won db 'Congratulations! You Won the Game ',1,'$'
	Freq dw 2280
	Wanna db 'Do You Want To Continue? [Y/N]'
	Score db "Score: $"
	Lives db "Lives:$"
	LI db 3
	TS db '*** SCORES ***$'
	Score_B db 'SCORES$'
	TS_STR db '|Press S to See Scores|$'
	Done_lev2 db 'Congratulations! You completed Level 1.',1,'$'
	Done_lev3 db 'Congratulations! You completed Level 2.',1,'$'
	luck db 'Better luck next time!',2,'$'
	level1 db "Level 1 $"
	level2 db "Level 2 $"
	level3 db "Level 3 $"
	lev db 1
	value db 10
	GAME_ENDED1 db "GAME ENDED!$"
	
	inst1 db '1)Press right button -> to move pad in right direction.$'
	inst2 db '2)Press left button <- to move pad in left direction.$'
	inst3 db '3)Press Space to start every level during game.$'
	inst4 db '4)Press Esc during game to pause game.$'
	inst5 db '=>Press Backspace to move back to Menu.$'
	inst6 db '**** Manual Page ****'
	inst7 db '5)You have extra power. Press space during game to gain extra life.$'
	inst8 db '6)Press Q during game to directly end game.$'
	PAD1 db 0
	PAD2 db 0
	movCX db 0
	movCx1 db 0
	movDx db 0
	movDx1 db 0
	Xvel db 1
	Yvel db 1 
	C11 DB 0
	C12 DB 0
	C13 DB 0
	C14 DB 0
	C15 DB 0
	C16 DB 0
	C21 DB 0
	c22 DB 0
	C23 DB 0
	C24 DB 0
	C25 DB 0
	C26 DB 0
	C31 DB 0
	C32 DB 0
	C33 DB 0
	C34 DB 0
	C35 DB 0
	C36 DB 0
	C41 DB 0
	C42 DB 0
	C43 DB 0
	C44 DB 0
	C45 DB 0
	C46 DB 0
	C111 DB 0
	C121 DB 0
	C131 DB 0
	C141 DB 0
	C151 DB 0
	C161 DB 0
	C211 DB 0
	c221 DB 0
	C231 DB 0
	C241 DB 0
	C251 DB 0
	C261 DB 0
	C311 DB 0
	C321 DB 0
	C331 DB 0
	C341 DB 0
	C351 DB 0
	C361 DB 0
	C411 DB 0
	C421 DB 0
	C431 DB 0
	C441 DB 0
	C451 DB 0
	C461 DB 0

.code
mov ax, @data
mov ds, ax
mov es, ax
mov ax, 0

mov AH, 00h							;text video mode
mov AL, 10h
mov bh, 00h
int 10h

Display_Main
BYE4:
Display_Menu
jmp BYE2
BYE3:
Display_Manual
Bye6:
Display_TS
BYE2:
Game

BYE1:
	Change_BG 0,0,0,30,80,0h			;Whole background
		
		Cursor_Position 0,34,8		;SCORE PRINT
		Print_String Score,2,7
		Display_Score T_Score3
		Display_Score T_Score2		
		Display_Score T_Score		
		Cursor_Position 0,34,12
		Print_String GAME_ENDED1,1,11
		
;writing score in array.
		add T_Score, 48
		add T_Score2, 48
		add T_Score3, 48

		mov si, offset ScoreArr
		mov al, T_Score3
		mov [si], al
		inc si
		mov al, T_Score2
		mov [si], al
		inc si
		mov al, T_Score
		mov [si], al
		inc si
		mov bx, offset ScoreArr
		mov al, counter
		mov si, ax
		mov cl, 3

		go:

		mov ax, [bx]
		mov [buffer+si], ax
		inc bx
		inc si
		loop go
		
;writing score in array.

		write buffer, counter
		write Khali, 1
		write ScoreArr, 3
		write Khali, 1
		.if lev == 1
			write level1, 8
		.endif
		.if lev == 2
			write level2, 8
		.endif
		.if lev == 3 || lev == 4
			write level3, 8
		.endif
		;read filename
		close filename
		.if lev == 1
			Cursor_Position 0,27,5
			Print_String luck,04H,23
		.endif
		.if lev == 2
			Cursor_Position 0,27,5
			Print_String luck,04H,23
			Cursor_Position 0,21,3
			Print_String Done_lev2,04H,40
		.endif
		.if lev == 3			
			Cursor_Position 0,27,5
			Print_String luck,04H,23	
			Cursor_Position 0,21,3
			Print_String Done_lev3,04H,40
		.endif
		.if lev == 4				;Win Screen
			Cursor_Position 0,21,3
			Print_String Won,03H,35
		.endif

		Cursor_Position 0,23,19		
		Print_String Wanna,0Dh,30

		mov ax, 0
		Want:

		int 16h
		cmp al, 121
		je Repet
		cmp al, 110
		je yoo
		
		loop Want		
yoo:
mov ah,4ch
int 21h
end