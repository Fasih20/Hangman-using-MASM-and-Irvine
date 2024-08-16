include Irvine32.inc

.data

    ; Words to guess
    word1 BYTE "ball", 0
    word2 BYTE "tall", 0
    word3 BYTE "hall", 0
    word4 BYTE "tree", 0
    word5 BYTE "book", 0
    word6 BYTE "flower", 0
    word7 BYTE "garden", 0
    word8 BYTE "library", 0
    word9 BYTE "mountain", 0

    ; Array of pointers to each string
    wordArray DWORD OFFSET word1, OFFSET word2, OFFSET word3, OFFSET word4, OFFSET word5, OFFSET word6, OFFSET word7, OFFSET word8, OFFSET word9
    
    
    len Dword 0
    cmpcheck DWORD 0
    secretWord  BYTE 50 DUP(0)
    guessedWord BYTE 50 DUP(0)
    charToCmp BYTE ?
    
    CurrChoc BYTE 1
    handlecn DWORD ?
    colorAttr WORD 0Eh
    nooftrys DWORD 1
    ;wordInd DWORD 0
    
    ; Prompts
    bgprompt1 BYTE "Welcome To Hangman",0
    bgprompt2 BYTE "==================",0
    bgprompt3 BYTE "Guess the word in 7 tries, or the man dies!",0
    Hint BYTE "       Psst.... A little hint, try to start with vowels",0
    tg BYTE "Try again, Be careful...", 0
    gameover BYTE "He Died.....Game over", 0
    w BYTE "You won!", 0
    pgmsg BYTE "Press 1 to play again.....", 0
    winprompt BYTE "YAY!!! You Guessed the word!!!", 0
    guswi BYTE "                Guessed word is: ", 0
    vWord BYTE "The word was: ",0
    spacesToClearTryAgainMsg BYTE "                                   ", 0
    wordIndex DWORD 0
    
    stickmanHead BYTE "O", 0
    stickmanBody BYTE "/", 0
    stickmanBody1 BYTE "|", 0
    stickmanBody2 BYTE "\", 0
    stickmanLegs BYTE "/", 0
    stickmanLegs1 BYTE "\", 0
    
    ; First Stage
    s1line1 BYTE "= ['''+---+" ,0
    s1line2 BYTE "  |   |" ,0
    s1line3 BYTE "      |" ,0
    s1line4 BYTE "      |" ,0
    s1line5 BYTE "      |" ,0
    s1line6 BYTE "      |" ,0
    s1line7 BYTE "      |" ,0
    

.code
main proc
Start:
    call Clrscr
    mov nooftrys, 1
    mov eax, 0
    mov edx, 0
    mov ecx,0
    mov ebx, 0
    mov esi, 0
    mov len, eax
    mov cmpcheck, 0              
    call ResetGuessArray            
    call ResetSecretArray           
    call SetWord
    mov ecx, 1
   
    
    
    mov edx, OFFSET bgprompt1
    call WriteString
    call Crlf
    mov edx, OFFSET bgprompt2
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET bgprompt3
    call WriteString
    call Crlf
    call Crlf
    
     
    Call Crlf
    mov edx, OFFSET s1line1
    call WriteString
    call Crlf
    mov edx, OFFSET s1line2
    call WriteString
    call Crlf
    mov edx, OFFSET s1line3
    call WriteString
    mov edx, OFFSET guswi
    call WriteString
    mov edx, OFFSET guessedWord
	call WriteString
    call Crlf
    mov edx, OFFSET s1line4
    call WriteString
    call Crlf
    mov edx, OFFSET s1line5
    call WriteString
    call Crlf
    mov edx, OFFSET s1line6
    call WriteString
    call Crlf
    mov edx, OFFSET s1line7
    call WriteString
    call Crlf
    
    GameLoop:
        call DrawScreen
        
        mov al, 0
        mov charToCmp, 0
        mov esi, OFFSET secretWord
        cmp nooftrys, 7
        je GameEnd    
        call ReadChar
        mov charToCmp, al
        jmp CheckLoop
                    
    CheckLoop:
		mov al, [esi]                 
		cmp al, 0
		je WrongGuess
		cmp al, charToCmp
		je CorrectGuess
		inc esi
		jmp CheckLoop
    
	CorrectGuess:
		mov CurrChoc, 1
		mov ebx, esi       
		sub ebx, OFFSET secretWord 
		mov esi, OFFSET guessedWord 
		add esi, ebx       
		mov [esi], al
		
		add cmpcheck, 1
		mov esi, OFFSET secretWord
		add esi, ebx
		mov byte ptr [esi], 45
		mov dl, 40   
		mov dh, 8    
		call Gotoxy
		mov edx, OFFSET guessedWord
		call WriteString
		mov dl, 0
		mov dh, 14
		call Gotoxy

		mov edx, OFFSET spacesToClearTryAgainMsg
		call WriteString

		mov ebx, cmpcheck
		cmp ebx, len
		je WordGuessed
		jmp GameLoop
		
	WrongGuess:
		mov CurrChoc, 0
		inc nooftrys
		mov dl, 0
		mov dh, 14
		call Gotoxy
		mov edx, OFFSET tg
		call WriteString
		jmp GameLoop
    
	WordGuessed:
		call DrawScreen
		mov edx, OFFSET winprompt
		call Crlf
		call WriteString
		jmp GameEnd
        
    GameEnd:
		mov dl, 0
		mov dh, 16
		call Gotoxy
		mov edx, OFFSET vWord
		call WriteString
		mov ebx, wordIndex
		mov edx, wordArray[ebx*4]
		mov eax, wordIndex  
		call WriteString
		call Crlf
        mov edx, OFFSET pgmsg
        call Crlf
        call Crlf
        call WriteString
        Call ReadDec
        cmp al, 1
        je start
        jne w1
        w1:
			exit
main endp

DrawScreen PROC					;this method checks how many mistakes the player has made and draws the hangman on the screen
    mov edx, 0					;according to it
    cmp nooftrys, 2
    je Stage2
    cmp nooftrys, 3
    je Stage3
    cmp nooftrys, 4
    je Stage4
    cmp nooftrys, 5
    je Stage5
    cmp nooftrys, 6
    je Stage6
    cmp nooftrys, 7
    je Stage7
    jmp ext
    
    Stage2:
        mov dl, 0
        mov dh, 14
        call Gotoxy
        cmp CurrChoc, 0
        jne ct
        mov edx, OFFSET tg
        call WriteString
        call Crlf
        mov dl, 2   
        mov dh, 8      
        call Gotoxy
        mov edx, OFFSET stickmanHead
        call WriteString
        ct:
			jmp ext
    
    Stage3:
		mov dl, 0
		mov dh, 14
		call Gotoxy
        cmp CurrChoc, 0
        jne ct1
        mov edx, OFFSET tg
        call WriteString
        call Crlf
		mov dl, 1
		mov dh, 9
		call Gotoxy
		mov edx, OFFSET stickmanBody
		call WriteString
        ct1:
			jmp ext
    
    Stage4:
		mov dl, 0
		mov dh, 14
		call Gotoxy
        cmp CurrChoc, 0
        jne ct2
        mov edx, OFFSET tg
        call WriteString
        call Crlf
        mov dl, 2
		mov dh, 9
		call Gotoxy
		mov edx, OFFSET stickmanBody1
		call WriteString
        ct2:
			jmp ext
    
    Stage5:
        mov dl, 0
        mov dh, 14
        call Gotoxy
        cmp CurrChoc, 0
        jne ct3
        mov edx, OFFSET tg
        call WriteString
        call Crlf
        mov dl, 3
        mov dh, 9
        call Gotoxy
        mov edx, OFFSET stickmanBody2
        call WriteString
        ct3:
			jmp ext
    
    Stage6:
        mov dl, 0
        mov dh, 14
        call Gotoxy
        cmp CurrChoc, 0
        jne ct4
        mov edx, OFFSET tg
        call WriteString
        call Crlf
        mov dl, 1
        mov dh, 10
        call Gotoxy
        mov edx, OFFSET stickmanLegs
        call WriteString
        ct4:
            jmp ext
    
    Stage7:
        mov dl, 0
        mov dh, 14
        call Gotoxy
        mov edx, OFFSET gameover
        call WriteString
        call Crlf
        mov dl, 3
        mov dh, 10
        call Gotoxy
        mov edx, OFFSET stickmanLegs1
        call WriteString
    
        jmp ext
    
    ext:
        ret
    DrawScreen ENDP
    
SetWord PROC
    ifSame:
        call Randomize              
        mov eax, 20                 ;the reason I've ste the number higher then the actual number of words is because then it will
        call RandomRange            ;have a higher chance of generating more randomized numbers.
        mov ebx, eax
        cmp ebx, wordIndex
        je ifSame
		cmp ebx, 9
		jg ifSame
        mov wordIndex, ebx              
        mov edx, wordArray[ebx*4]   
        mov esi, edx               
        mov edi, OFFSET secretWord  
        mov ecx, 0                 

    Copy:
        mov al, [esi]               
        cmp al, 0                   
        je Done                       
        mov [edi], al               
        mov byte ptr [OFFSET guessedWord + ecx], '_'  
        inc esi                     
        inc edi                     
        inc ecx                     
        jmp Copy                    

    Done:
        mov len, ecx                
        mov byte ptr [edi], 0       

    ret
SetWord EndP


ResetGuessArray PROC				;this method empties the array that stores the guesses of the player
    mov esi, [OFFSET guessedWord]
    mov ecx, 50                        

	zGuessArray:
		mov byte ptr [esi], 0
		inc esi
		loop zGuessArray
    
    ret
ResetGuessArray ENDP

ResetSecretArray PROC				;this method empties the array that stores the correct guesses of the player
    mov esi, [OFFSET secretWord]
    mov ecx, 50                        

	zSecretArray:
		mov byte ptr [esi], 0
		inc esi
		loop zSecretArray

    ret
ResetSecretArray ENDP

end main