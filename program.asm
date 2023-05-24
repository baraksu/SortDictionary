.MODEL small
.DATA
    ; special ascii chars
    commaAscii equ ','
    dotAscii equ '.'
    elimCharAscii equ 127d  
    
    ; define the string
    testStr db "we,i,want,is,to,jat,pizza."
    ;str db 101 dup('$')
    numOfWords dw 1
    
    ; define the index arrays
    startIndex db 15 dup(?)
    endIndex db 15 dup(?)
    
    ; define the lowest chars array
    lowestIndex db 15 dup(?)
    lowestWordIndex db ?
    
.CODE
    proc takeStringInput ;; ======fix this func==================
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
            cmp cl, 100
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
            ret
    endp takeStringInput
 
    proc setIndexes
        ; CALL this function in order: offset startIndex, offset endIndex, offset string
        
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
                    ret
                        
                
                nextIter:
                    ;prepare for the next iteration
                    inc si
                    jmp setIndexesLoop
        
    endp setIndexes
    
    proc findLowestWord
        ; this folowing code helps us accsses values that were put in the stack ->
        ; using the relative address to bp.
        push bp
        mov bp, sp    
        
        push si
        push ax
        push dx
        push di
        push bx
        
       
        xor si, si
        copyToLowestLoop:
            mov bx, [bp+8]
            mov ax, [bx+si]
                
            mov bx, [bp+4]
            mov [bx+si], ax
                
            inc si
            cmp si, [bp+12]
            jb copyToLowestLoop
        
        xor di, di
        xor ax, ax
        xor dx, dx
        xor bx, bx
        charLoop:
            mov dl, 'z'
            xor si, si
            mov si, [bp+10] 
            findLowestLoop:
                ; get the offset of the word in startIndex
                mov bx, [bp+4]
                add bx, si
                
                cmp [bx], elimCharAscii
                je findLowestLoop_continue
                ; store the index in ax and add di
                mov al, [bx]
                add ax, di
                
                xor bx, bx
                mov bx, [bp+6]
                add bx, si
                mov cl, [byte ptr bx]
                cmp al, [byte ptr bx]
                ja exitWithLowest
                
                xor bx, bx
                mov bx, [bp+14]
                add bx, ax
                
                ; compare the char in index di, with the lowest char in index di
                cmp [byte ptr bx], dl
                jl foundLower
                jmp findLowestLoop_continue
                
                foundLower:
                    mov dl, [byte ptr bx]      
                
                findLowestLoop_continue:
                    inc si
                    cmp si, [bp+12]
                    jb findLowestLoop
            
            xor si, si
            mov si, [bp+10]
            mov cx, [bp+12]
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
                
                cmp [bx], dl
                jne markNonLowest
                jmp setLowest
                
                markNonLowest:
                    mov bx, [bp+4]
                    add bx, si
                    mov [bx], elimCharAscii
                    
                    dec cx
                    jmp eliminateContinue  
                
                setLowest:
                    mov bx, [bp+16]
                    mov [bx], si
                
                eliminateContinue:
                    cmp cx, 0 ; because we dec before cmp
                    je exitProcFindLowest
                              
                    inc si
                    cmp si, [bp+12]
                    jb eliminateNonLowestLoop

            inc di
            cmp di, 10
            jb charLoop
            jmp exitProcFindLowest
            
            
        exitWithLowest:
            mov bx, [bp+16]
            mov [bx], si        
        
        exitProcFindLowest:
            pop bx
            pop di 
            pop dx 
            pop ax
            pop si
            pop bp
            ret
    endp findLowestWord
    
    start:
        ; initialize
        mov ax, @data
        mov ds, ax  ;point ds to data segment
        
        ; Take string input
        ;push offset str ; [bp+4]
        ;call takeStringInput
        
        ; Set the indexes
        ;push offset numOfWords ; [bp+10]
        push offset startIndex ; [bp+8]
        push offset endIndex ; [bp+6]
        push offset testStr ; [bp+4]
        call setIndexes
        
        ; Find the lowest word
        push offset lowestWordIndex ; [bp+16]
        push offset testStr ; [bp+14]
        push numOfWords ; [bp+12]
        push 0 ; [bp+10]
        push offset startIndex ; [bp+8]
        push offset endIndex ; [bp+6]
        push offset lowestIndex ; [bp+4]
        call findLowestWord
          
    end:
        mov ax, 4c00h   ;exit program
        int 21h
END start
