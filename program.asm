.MODEL small
.DATA
    ; define the index arrays
    startIndex db 20 dup(?) ; the array that's used to store the start index of each word in the input string
    endIndex db 20 dup(?) ; the array that's used to store the end index of each word in the input string
    lowestIndex db 20 dup(?) ; the array that's used to eliminate the indexes in the findLowestWord proc, until the lowest word is found.
    
    ;define the lowest index var
    lowestWordIndex db ? ; here the lowest word's index in the index arrays is stored after the findLowestWord runs.
    
    ; define the string
    strMaxLen equ 151 ; The max length of the input string.
    numOfWords db 1 ; The number of words is saved here in setIndexes
    str db strMaxLen dup(0) ; the definition of the string
    
    ; special ascii chars
    commaAscii equ ',' ; a char that's used to indicate the end of a word in the input string.
    dotAscii equ '.' ; a char that's used to indicate the end of the input string.
    elimCharAscii equ 127d ; a number thats used to indicate that a word is not the lowest word in findLowestWord
    
    ; different string outputs
    inputPrompt1 db "Enter a list of up to 20 lowercase words, and up to 150 chars.", '$' ; prompt string n1
    inputPrompt2 db 13, 10, "Separate words with commas, without spaces. End the list with a dot.", 13, 10, '$' ; prompt string n2
    finalMsg db 13,10,"The words in alphabetical order: ",13,10,'$' ; A string that's displayed before the final output
    crlf db 13, 10, '$' ; new line
    
.CODE
    proc takeStringInput
        ; CALL this function in order: offset str. 
        
        ; This function take string input from the user, char by char, - >
        ; until a dot is entered, or the maximum string length was reached.
        ; The function 'returns' an input string. 
        
        ; this folowing code helps us accsses values that were put in the stack ->
        ; using the relative address to bp.
        push bp
        mov bp, sp
        
        push ax
        push dx
        push bx
        
        mov bx, [bp+4]
        mov ah, 01h
        mov cl, 1
        charInputLoop:
            int 21h
            
            cmp al, dotAscii
            je exitWithEndString
            
            mov [bx], al
            inc bx
            
            inc cl
            cmp cl, strMaxLen
            jna charInputLoop
            jmp exitProcTakeInput      
        
        exitWithEndString:
            mov [bx], al

        ; exit the proc
        exitProcTakeInput:
            pop bx     
            pop dx
            pop ax
            
            pop bp
            ret 2
    endp takeStringInput 

    proc setIndexes
        ; CALL this function in order: offset numOfWords, offset startIndex, offset endIndex, offset string
        
        ; This function iterates through the chars in a string and ->
        ; sets the start & end index for each word in it, in the index arraays. ->
        ; It also counts the number of words and stores it in the numOfWords variable.
        ; The function 'returns' 2 arrays that store the start and end index of each word in a string. ->
        ;  It also returns the number of words in numOfWords.
        
        ; this folowing code helps us accsses values that were put in the stack ->
        ; using the relative address to bp.
        push bp
        mov bp, sp
        
        ; push the registers into the stack
        push ax
        push bx
        push dx
        push si
        push di
        
        xor ax, ax ; used to search for the special chars
        xor bx, bx  
        xor dx, dx ; the index which will be entered into the start/end arrays
        xor si, si ; the index that is used to iterate through the string chars
        xor di, di ; the index of where the start/end indexs will be put at
        
        mov bx, [bp+8]  ; mov the offset of startIndex into bx
        mov [bx], 0d ; set a start index of 0, in the first index of startIndex
        setIndexesLoop:
            ; check whether a comma was found
            mov al, commaAscii
            mov bx, [bp+4] ; mov the offset of the string into bx
            cmp [bx+si], al
            jne SetIndexes_continue

            setANewWord:
                mov bx, [bp+10] ; mov the offset of numOfWords into bx
                inc [bx]
                setStart:
                    ;set a new start
                    mov dx, si
                    inc dx ; dl is the actual index
                    mov bx, [bp+8] ; mov the offset of startIndex into bx
                    mov [bx+di+1], dl
                    
                setEnd:
                    ; set a new end
                    mov dx, si
                    dec dx ; dl is the actual index
                    mov bx, [bp+6] ; mov the offset of endIndex into bx
                    mov [bx+di], dl
                
                inc di
            
            SetIndexes_continue:
                ; check whether the dot was found. if it was, then exit the loop
                mov al, dotAscii
                mov bx, [bp+4] ; mov the offset of the string into bx
                cmp [bx+si], al
                je exitLoop
                jne nextIter
                
                exitLoop:
                    ; Set an end for the last word
                    xor dx, dx
                    mov dx, si
                    dec dx
                    mov bx, [bp+6] ; mov the offset of endIndex into bx
                    mov [bx+di], dl
                    
                    ; exit the proc
                    ; pop the registers back from the stack
                    pop di
                    pop si
                    pop dx
                    pop bx
                    pop ax
                    
                    pop bp
                    ret 8
                        
                
                nextIter:
                    ;prepare for the next iteration
                    inc si
                    jmp setIndexesLoop
        
    endp setIndexes
    
    
    proc findLowestWord
        ; CALL this function in order: ->
        ; offset lowestWordIndex, offset testStr, numOfWords, intial si value for findLowestLoop, ->
        ; offset startIndex, offset endIndex, offset lowestIndex
        
        ; This function takes the index arrays as parameters and finds ->
        ; the lowest word alphabetically from the index it's given as a parameter.
        ; The function 'returns' thelowestWordIndex variable with the index if the lowest word alphabetically.
        
        ; this folowing code helps us accsses values that were put in the stack ->
        ; using the relative address to bp.
        push bp
        mov bp, sp    
        
        ; push the registers into the stack
        push si
        push ax
        push dx
        push di
        push bx
        push cx
        
        
        ;xor cx, cx
        ;mov cx, [bp+12]
        xor dx, dx
        ; make a copy of startIndex in lowestIndex
        xor si, si
        mov si, [bp+10] ; initial si 
        copyToLowestLoop:
            mov bx, [bp+8] ; offset startIndex
            mov al, [bx+si] ; start of si-word (value)
            
            xor bx, bx    
            mov bx, [bp+4] ; offset lowestIndex
            mov [bx+si], al ; set the si index in lowestWord to al
                
            inc si
            mov dl, byte ptr [bp+12]
            cmp si, dx ; cmp si to the number of words
            jb copyToLowestLoop
        
        
        xor di, di
        xor ax, ax
        xor dx, dx
        xor bx, bx
        xor cx, cx
        ; This loop iterates over each char using di as the char index
        charLoop:
            mov dl, 'z'
            xor si, si
            mov si, [bp+10]
            xor cx, cx
            mov cl, byte ptr [bp+12] ; numOfWords value
            ; This loop iterates over each word, and operates on the char in place di+1  
            findLowestLoop:
                ; get the offset of the word in lowestIndex, ->
                ; and add si so bx has the offset of the currnet word in lowestIndex.
                mov bx, [bp+4]
                add bx, si
                
                ; Check if the current index in lowestIndex has the elimination char. ->
                ; If so, then continue to the next operation.
                cmp [bx], elimCharAscii
                je findLowestLoop_continue
                
                ; Store the start index of the current word in al ->
                ; and add di to ax, so al has the index of the di char, in the string.
                mov al, [bx]
                add ax, di
                
                ; Store the offset of endIndex in bx, and add si, ->
                ; so bx has the offset of the current word in endIndex.
                xor bx, bx
                mov bx, [bp+6]
                add bx, si
                ; Check if al(the index of the word + di) is bigger than the end index of the word. ->
                ; If so, than the word is the shortest and is equal in it's alphabetical order, meaning its the lowest word. ->
                ; Therefore, set the index of this word in startIndex as the lowest, then exit the proc.
                cmp al, [bx]
                ja exitWithLowest
                
                ; These lines store the offset of the di char in bx
                xor bx, bx
                mov bx, [bp+14]
                add bx, ax
                
                ; Compare the char in index di, with the lowest char in index di(dl)
                ;mov bx, [bx]
                cmp byte ptr [bx], dl
                jb foundLower
                jmp findLowestLoop_continue
                
                ; Set a new lowest char in dl
                foundLower:
                    mov dl, [bx]      
                
                findLowestLoop_continue:
                    inc si
                    cmp si, cx ; numOfWords
                    jb findLowestLoop
            
            xor si, si
            mov si, [bp+10]
            xor cx, cx
            mov cl, byte ptr [bp+12] ; numOfWords value
            eliminateNonLowestLoop:
                ; get the offset of the word in startIndex
                mov bx, [bp+4]
                add bx, si
                
                ; store the index in ax and add di
                mov al, [bx]
                add ax, di
                
                xor bx, bx
                mov bx, [bp+14]
                add bx, ax
                
                ; compare the di char with the lowest char(di)
                cmp byte ptr [bx], dl
                jne markNonLowest
                jmp setLowest
                
                ; Mark words, that their di char is not the lowestChar as eliminated using the special char(127d)
                markNonLowest:
                    mov bx, [bp+4]
                    add bx, si
                    mov [bx], elimCharAscii
                    
                    dec cl ; dec the number of words left
                    jmp eliminateContinue  
                
                ; save the index(in startIndex) of the lowest word lowestWordIndex
                setLowest:
                    xor ax, ax
                    mov ax, si
                    mov bx, [bp+16]
                    mov [bx], al
                    
                eliminateContinue:
                    cmp cx, 0 ; because we dec before cmp
                    ;cmp cl, 1 ; check if the we have only the lowest word left
                    je exitProcFindLowest
                              
                    inc si
                    xor ax, ax
                    mov al, byte ptr [bp+12]
                    cmp si, ax
                    jb eliminateNonLowestLoop

            inc di
            cmp di, 45 ; 45 is a constant, that represents the longest word in the English alphabet
            jb charLoop
            jmp exitProcFindLowest
            
        ; If the last word is the lowest, than jmp here and set ->
        ; lowestWordIndex with the index(in startIndex) of the last word    
        exitWithLowest:
            xor ax, ax
            mov ax, si
            mov bx, [bp+16]
            mov [bx], al
                  
        exitProcFindLowest:
            ; exit the proc
            ; pop the registers back from the stack
            pop cx
            pop bx
            pop di 
            pop dx 
            pop ax
            pop si
            pop bp
            ret 12
    endp findLowestWord
    
    
    proc switchByteSize
        ; CALL this function in order: offset var1, offset var2
        
        ; This function takes 2 offsets and switches the values between those.
        ; The function returns the 2 offsets with their switched values. 
        
        push bp
        mov bp, sp
        
        ; push the registers into the stack
        push bx
        push ax
        push dx
        
        xor ax, ax
        xor bx, bx
        xor dx, dx
        
        mov bx, [bp+6] ; offset of var1
        mov al, [bx] ; value of var1
        
        xor bx, bx
        mov bx, [bp+4] ; offset of var2
        mov dl, [bx] ; value of var2
        
        ; Switch the values
        mov [bx], al
        mov bx, [bp+6]
        mov [bx], dl
        
        exitProcSwitch:
            ; exit the proc
            ; pop the registers back from the stack
            pop dx
            pop ax
            pop bx
            pop bp    
            ret 4
    endp switchByteSize
    
    
    proc Alphabetize
        ; CALL this function in order: ->
        ; poffset lowestWordIndex, offset lowestIndex, offset startIndex, ->
        ; offset endIndex, offset testStr, offset numOfWords
        
        ; This is the sorting function. It uses the other functions in order to sort the word list alphabetically.
        ; The function returns the index arrays in the order of sorted list of words.
        
        push bp
        mov bp, sp
        
        push si
        push bx
        push ax
        
        xor si, si
        xor bx, bx
        xor ax, ax
                
        alphaLoop:
            ;Find the lowest word from si on
            push [bp+14] ; offset lowestWordIndex
            push [bp+6] ; offset str
            
            mov bx, [bp+4] 
            push [bx] ; numOfWords(value)
            
            push si ;intial si value for findLowestLoop
            push [bp+10] ; offset startIndex
            push [bp+8] ; offset endIndex
            push [bp+12] ; offset lowestIndex
            call findLowestWord
            
            ; Switch the lowest word with the word in index si (switch in startIndex)
            mov bx, [bp+14] ; offset lowestWordIndex
            mov al, [bx] ; lowestWordIndex value
            mov bx, [bp+10] ; offset startIndex
            add ax, bx ; ax has the offset of the lowest word (in startIndex)
            
            xor bx, bx
            mov bx, [bp+10] ; offset startIndex
            add bx, si ; bx has the offset of the word in index si (in startIndex)
            
            push ax
            push bx
            call switchByteSize
            
            ; Switch the lowest word with the word in index si (switch in endIndex)
            mov bx, [bp+14] ; offset lowestWordIndex
            mov al, [bx] ; lowestWordIndex value
            mov bx, [bp+8] ; offset endIndex
            add ax, bx ; ax has the offset of the lowest word (in endIndex)
            
            xor bx, bx
            mov bx, [bp+8] ; offset endIndex
            add bx, si ; bx has the offset of the word in index si (in endIndex)
            
            push ax
            push bx
            call switchByteSize
            
            ; loop continues 
            inc si
            xor bx, bx
            mov bx, [bp+4]
            xor ax, ax
            mov al, byte ptr [bx]
            dec al ; now al has the number of words that the loop needs to iterate through
            cmp si, ax
            jb alphaLoop
        
        exitProcAlpha:
            pop ax
            pop bx
            pop si
            pop bp
            
            jmp testPrintW
            ;ret x ; check what is x ===================issue!!!!!!=============================== 
    endp Alphabetize
    
    proc printWords
        ; CALL this function in order: ->
        ; offset startIndex, offset endIndex, offset string, value numOfWords
        
        ; This function prints the words as a list, in the order their index occur in the index arrays.
        ; The function doesn't return a value, but prints the output to the console.
        
        push bp
        mov bp, sp
        
        
        xor di, di
        xor bx, bx
        xor si, si
        ; this loop iterates through each word in the string
        printWordsLoop:
            ; Store the start char offset in si
            mov bx, [bp+10] ; startIndex offset
            add bx, di ; bx has the offset of the word in startIndex
            
            xor ax, ax  
            xor si, si
            mov al, byte ptr [bx]
            mov si, ax ; si has the start index
            
            ; Store the end char offset in cx
            mov bx, [bp+8] ; endIndex offset
            add bx, di ; bx has the offset of the word in endIndex
            
            xor cx, cx
            mov cl, byte ptr [bx] ; cx has the end index
            
            ; this loop prints each char in the current word
            printCharsLoop:
                mov bx, [bp+6]
                add bx, si
                
                mov ah, 02h
                mov dl, [bx]
                int 21h 
                
                
                inc si
                cmp si, cx
                jbe printCharsLoop    
            
            printWordsLoopContinue:
                inc di
                mov dx, [bp+4]
                cmp di, [bp+4]
                jae exitProcPrintWords
                
                ; print a comma to separate the words
                mov ah, 02h
                mov dl, commaAscii
                int 21h 
                jmp printWordsLoop
        
        
        exitProcPrintWords:
            ; print a dot
            mov ah, 02h
            mov dl, dotAscii
            int 21h        
                
            pop bp
            ret 8
    endp printWords
    
    
    start:
        ; initialize
        mov ax, @data
        mov ds, ax  ;point ds to data segment
        
        ; Take string input
        lea dx, inputPrompt1
        mov ah, 09h
        int 21h
        
        lea dx, inputPrompt2
        mov ah, 09h
        int 21h
        
        push offset str
        call takeStringInput
        
        ; Set the indexes for each word in the input string
        push offset numOfWords
        push offset startIndex
        push offset endIndex
        push offset str
        call setIndexes
        
        ; Sort the words from the input string in alphabetical order
        push offset lowestWordIndex
        push offset lowestIndex 
        push offset startIndex
        push offset endIndex 
        push offset str 
        push offset numOfWords
        call Alphabetize
        
        ; Print the sorted string
        testPrintW:
        lea dx, crlf
        mov ah, 09h
        int 21h
        
        lea dx, finalMsg
        mov ah, 09h
        int 21h
        
        push offset startIndex 
        push offset endIndex
        push offset str
        
        xor bx, bx
        mov bl, numOfWords
        push bx
        call printWords        
          
    end:
        mov ax, 4c00h   ;exit program
        int 21h
END start
