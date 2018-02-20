TITLE Program #3     (Project3.asm)

;Author: Tida Sooreechine
;Email: sooreect@oregonstate.edu
;Course: CS271-400
;Project ID: Program #3                
;Assignment Due Date: July 24, 2016
;Description: Program calculates composite numbers from user input.

INCLUDE Irvine32.inc


LOWERLIMIT = 1
UPPERLIMIT = 400

.data

userNum		DWORD	?
divisor		DWORD	?	
curNum		DWORD	4		;start with lowest composite number possible
numCount	DWORD	0
title1		BYTE	"Composite Numbers", 0
title2		BYTE	"Programmed by Tida Sooreechine", 0
direction1	BYTE	"Enter the number of composite numbers you would like to see.", 0
direction2	BYTE	"I will accept orders for up to 400 composites.", 0
prompt		BYTE	"Enter the number of composites to display [1 . . 400]: ", 0
error		BYTE	"Out of range. Try again.", 0
goodbye		BYTE	"Results certified by Tida Sooreechine. Goodbye.", 0
space		BYTE	"     ", 0


.code

main PROC
	call	introduction
	call	getUserData
	call showComposites
	call	farewell

	exit	; exit to operating system
main ENDP

;----------------------------------------------------------------------------------------
;Procedure: To introduce the program to the user
;Receives: None
;Returns: None
;Preconditions: None 
;Registers Changed: EDX
;----------------------------------------------------------------------------------------
introduction PROC
;print introduction messages
	mov		edx, OFFSET title1
	call	WriteString
	call	crlf
	mov		edx, OFFSET title2
	call	WriteString
	call	crlf
	call	crlf
;print user instructions
	mov		edx, OFFSET direction1
	call	WriteString
	call	crlf
	mov		edx, OFFSET direction2
	call	WriteString
	call	crlf
	call	crlf
	ret
introduction ENDP

;----------------------------------------------------------------------------------------
;Procedure: To get an integer input from the user
;Receives: None
;Returns: User input value as global variable userNum
;Preconditions: None 
;Registers Changed: EAX & EDX
;----------------------------------------------------------------------------------------
getUserData PROC
;print prompt and get integer input from data
	mov		edx, OFFSET prompt
	call	WriteString
	call	ReadInt
	mov		userNum, eax
;call subprocedure to validate user input
	call	validateUserData
	ret
getUserData ENDP

;----------------------------------------------------------------------------------------
;Procedure: To validate user input
;Receives: User input value
;Returns: User input value as global variable userNum, if the value is within boundary, 
;	or an error message, otherwise.
;Preconditions: User input is an integer
;Registers Changed: EDX
;----------------------------------------------------------------------------------------
;check that user input is within range
validateUserData PROC
	cmp		userNum, LOWERLIMIT		;compare user input to lower limit of 1
	jl		errorMessage			;proceed to display error if value is out of bound
	cmp		userNum, UPPERLIMIT		;compare user input to upper limit of 400
	jg		errorMessage			;proceed to display error if value is out of bound
	jmp		validNumber				;continue with calculation otherwise
;if value is out of range, print error message and get new value
errorMessage:
	mov		edx, OFFSET error
	call	WriteString
	call	crlf
	call	crlf
	call	getUserData	
;if value is valid, return to main			
validNumber:
	ret
validateUserData ENDP

;----------------------------------------------------------------------------------------
;Procedure: To print a series of composite numbers
;Receives: User input as global variable, userNum
;Returns: A series of composite numbers
;Preconditions: User input is within range 
;Registers Changed: EAX, EBX, ECX & EDX
;----------------------------------------------------------------------------------------
showComposites PROC
	mov		ecx, userNum	
L1:
	mov		ebx, curNum
	dec		ebx
	mov		divisor, ebx
	call	isComposite			;check if value is composite
	call	WriteDec	
	inc		eax
	mov		curNum, eax		
	inc		numCount
	cmp		numCount, 10
	jge		nextLine
	mov		edx, OFFSET space
	call	WriteString
	jmp		sameLine
nextLine:
	call	crlf
	mov		numCount, 0
sameLine:
	loop	L1
	call	crlf
	call	crlf
	ret
showComposites ENDP

;----------------------------------------------------------------------------------------
;Procedure: To find the next composite number
;Receives: Global variables curNum and divisor
;Returns: The next composite number
;Preconditions: Variables curNum and divisor are correct 
;Registers Changed: EAX & EBX
;----------------------------------------------------------------------------------------
isComposite PROC
L2:
	mov		edx, 0				;preload edx register with 0 to clear dividend
	mov		eax, curNum
	div		ebx					;current/divisor 
	cmp		edx, 0				;check if modulus = 0
	je		compositeNumber	
	dec		ebx
	cmp		ebx, 1
	je		primeNumber
	jmp		L2
compositeNumber:
	mov		eax, curNum
	ret
primeNumber:	
	mov		eax, curNum
	inc		eax
	mov		curNum, eax 
	jmp		L2
isComposite ENDP
;----------------------------------------------------------------------------------------
;Procedure: To say good-bye to the user
;Receives: None
;Returns: None
;Preconditions: None 
;Registers Changed: EDX
;----------------------------------------------------------------------------------------
farewell PROC
	mov		edx, OFFSET goodbye
	call	WriteString
	call	crlf
	call	crlf
	ret
farewell ENDP

END main
