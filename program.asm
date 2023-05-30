.MODEL small
.DATA
    ; special ascii chars
    commaAscii equ ','
    dotAscii equ '.'
    elimCharAscii equ 127d  
    
    ; define the string
    strMaxLen equ 150
    ;str db strMaxLen dup('$')
    numOfWords db 1
    
    ; define the index arrays
    startIndex db 20 dup(?)
    endIndex db 20 dup(?)
    
    ; define the lowest chars array
    lowestIndex db 20 dup(?)
    lowestWordIndex db ?
    
    ;TEMP variables, for testing
    testStr db "real,radio,chaos,railing."
.CODE
    proc takeStringInput
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
                cmp [bx], dl
                jl foundLower
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
                cmp [bx], dl
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
                    
;                    mov bx, [bp+16]
;                    mov [bx], si
                eliminateContinue:
                    ;cmp cx, 0 ; because we dec before cmp
                    cmp cl, 1 ; check if the we have only the lowest word left
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
            
;            mov bx, [bp+16]
;            mov [bx], si        
;        
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
        ;   01 34 67 910 1213 1516
        ; | dd,nn,oo,bb, aa,  cc.
        ;  aa, | nn,oo,bb,dd,cc.
        ;  aa,bb | oo,nn,dd,cc.
        ;  aa,bb,cc | nn,dd,oo.
        ;  aa,bb,cc,dd | nn,oo.
        ;  aa,bb,cc,dd,nn | oo.
        ;  aa,bb,cc,dd,nn,oo.
        push bp
        mov bp, sp
        
        push si
        push bx
        push ax
        
        xor si, si
        xor bx, bx
        xor ax, ax
        
        push [bp+4] ; offset numOfWords
        push [bp+10] ; offset startIndex
        push [bp+8] ; offset endIndex
        push [bp+6] ; offset str
        call setIndexes
        
        xor si, si
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
            
           ; push offset lowestWordIndex ; [bp+14]
;            push offset lowestIndex ; [bp+12]
;            push offset startIndex ; [bp+10]
;            push offset endIndex ; [bp+8]
;            push offset testStr ; [bp+6]
;            push offset numOfWords ; [bp+4]
            
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
        push bp
        mov bp, sp
        
        
        xor di, di
        xor bx, bx
        xor si, si
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
            ret
    endp printWords
    
    
    start:
        ; initialize
        mov ax, @data
        mov ds, ax  ;point ds to data segment
        
        ; Take string input
        ;push offset str ; [bp+4]
        ;call takeStringInput
        
;        ; Set the indexes
;        push offset numOfWords ; [bp+10]
;        push offset startIndex ; [bp+8]
;        push offset endIndex ; [bp+6]
;        push offset testStr ; [bp+4]
;        call setIndexes
;        
;        ; Find the lowest word
;        push offset lowestWordIndex ; [bp+16]
;        push offset testStr ; [bp+14] -
;        push word ptr numOfWords ; [bp+12] -
;        push 0 ; [bp+10]
;        push offset startIndex ; [bp+8] -
;        push offset endIndex ; [bp+6]   -
;        push offset lowestIndex ; [bp+4] -
;        call findLowestWord
;        
;        ; Switch variable values
;        push offset startIndex ;[bp+6]
;        mov dl, lowestWordIndex
;        mov bx, offset startIndex
;        add bx, dx
;        push bx ;[bp+4]
;        call switchByteSize
        
        ; Alpha
        
        push offset lowestWordIndex ; [bp+14]
        push offset lowestIndex ; [bp+12]
        push offset startIndex ; [bp+10]
        push offset endIndex ; [bp+8]
        push offset testStr ; [bp+6]
        push offset numOfWords ; [bp+4]
        call Alphabetize
        
        testPrintW:
        mov bl, numOfWords
        push offset startIndex ; [bp+10]
        push offset endIndex ; [bp+8]
        push offset testStr ; [bp+6]
        push bx ; [bp+4]
        call printWords
        
        
          
    end:
        mov ax, 4c00h   ;exit program
        int 21h
END start
