# Alphabetizing Program
***
## Table of contents
- [Details about the project](#details)
- [What is the purpose of the project?](#purpose)
- [How does it work?](#how)
- [How to use the program?](#use)
- [The production process](#production)
- [What's next? Plans ahead](#plans)
- [Reflection](#reflection)
***

<a name="details"></a>
## Details about the project
**Project Name:** Alphabetizing Program.<br/>
**Programmar:** Ethan Miller.<br/>
**Grade:** 10.<br/>
**Class:** Computer Science. Taught by Barak Suberri.<br/>
**School:** Yeshivat Bnei Aquiva Givat Shmuel.<br/>
**Year Of Submission:** 2023.<br/>
**Project Status:** Production/`Completed`/Submitted

<a name="purpose"></a>
## What is the purpose of the project?
The project was written copletely in assembly language 8086, and consists of one .asm file( see [program.asm](https://github.com/baraksu/SortDictionary/blob/main/program.asm)).
The purpose of the program is to take an input string, which consists of words separated by commas,
process it and return a new alphabeticaly sorted list of words.

<a name="how"></a>
## How does it work?
In this segment, we'll discuss how the program works in general.<br/>
As mentioned before, this project was written completely in assembly language 8086.
<br/><br/>
The program consists of 5 major parts:<br/>
1. Taking string input.<br/>
2. Setting the start & end indexes for each word in the input string.<br/>
3. Finding the lowest word alphabetically.<br/>
4. Switching the indexes of the lowest word, and the indexes of the word in index `si`(see [the Alphabetize proc](#alpha)).<br/>
5. Printing the alphabetically sorted list.<br/>
> **Note:** parts 3-4 are not independent parts of the program, but they are significant parts of [the Alphabetize proc](#alpha), which is the main part of the program.

When running the program, a propmt will show on the console, asking the user to enter a list of words into an input field.
Then, after the list was fully submmited, the program will iterate throught the input string, saving each start & end index for each word in the index arrays(for further information, please check out the [Writing the setIndexes proc](#setIndexes) segment).<br/>
After setting the indexes, the program will iterate through the first `numOfWords-1` words in the input string, using the `alphaLoop` loop. At first, the `alphaLoop` loop\`s index is initialized with 0.<br/>
In each iteration, the program will iterate through the words using 2 indexes, `di` and `si`.<br/>
The register and index `si` is first initialized with the index of the `alphaLoop` loop.
The register `di` will serve as an index for the char the program is currently reviewing in each word. The register `si` on the other hand, will serve as an index for the word the program is currently reviewing it's `di`-indexed char. Using these indexes, the program is iterating through the words, and comparing the chars to insure the index of the word put in `lowestWordIndex`, is truly the index of the lowest word alphabetically(for further information, please check out the [Writing the findLowestWord proc](#findLowestWord) segment).<br/>
After finding the index of the lowest word alphabetically, the program will than switch the indeexes of the word in index `lowestWordIndex`, and the indexes of the word in the index of the `alphaLoop` loop(for further information, please check out the [Writing the switchByteSize proc](#switch) segment).<br/>
Then, when the indexes are finally switched, the program will complete its iteration, increase `alphaLoop`\`s index by 1, and move on to the next iteration.
It should be noted that now that the index is increased, the program will now find the index of the lowest word from the `alphaLoop`\`s index on, meaning that the previously switched indexes will remain untouched. Because of that, in every iteration of `alphaLoop`, the indexes of lowest word from it's index on, will be placed at the lowest index avaliable, after placing the indexes of lower words aheah of that one. Then, after `numOfWords-1` iterations, the indexes will be finally sorted alphabetically.
At the end, a proc is used to print the words of the input string in the order of the indexes in the index arrays, meaning that the new alphabetically sorted list of words will be printed onto the console.

### Runtime Samples
#### Sample 1
word index (si)|     init      |   0  |     1   |             2                     |   3   | 
 ------------- | ------------- | ---- | ------- | --------------------------------- | -----
inputString | slime,string,worth,pity,twilight. | slime,string,worth,pity,twilight. | slime,string,worth,pity,twilight. | slime,string,worth,pity,twilight.
startIndex |     0, 6, 13, 19, 24  |  19, 6, 13, 0, 24 |  19, 0, 13, 6, 24 | 19, 0, 6, 13, 24  | 19, 0, 6, 24, 13
endIndex |       4, 11, 17, 22, 31 | 22, 11, 17, 4, 31 | 22, 4, 17, 11, 31 | 22, 4, 11, 17, 31 | 22, 4, 11, 31, 17
expected output | slime,string,worth,pity,twilight. | pity,string,worth,slime,twilight. | pity,slime,worth,string,twilight. | pity,slime,string,worth,twilight. | pity,slime,string,twilight,worth.

>**Note:** notice that in each iteration, the `si` index is only switched with indexes from the `si` index on, and the previous indexes remain untouched.

#### Other Image Samples
![inputSample](https://github.com/baraksu/SortDictionary/blob/main/assets/outputSample.png)
![inputSample](https://github.com/baraksu/SortDictionary/blob/main/assets/outputSample2.png)

<a name="use"></a>
## How to use the program?
When running the program, the console will be opened, and a prompt will be shown on the screen.
![inputSample](https://github.com/baraksu/SortDictionary/blob/main/assets/inputSample.png)

Then, the user will be required to enter words, following these instructions:
1. The words are separated by commas.<br/>
2. There are no spaces between words and commas.<br/>
3. The list ends with a dot. Then the program will continue.
<br/>![inputEnteredSample](https://github.com/baraksu/SortDictionary/blob/main/assets/inputEnteredSample.png)

After entering the list of words, the program  will sort the words in alphabetical order.
Then the sorted list will be printed onto the console.
![outputSample](https://github.com/baraksu/SortDictionary/blob/main/assets/outputSample.png)

<a name="production"></a>
## The production process
In this segment, we'll discuss the steps I have taken during the production procces, and how everything works in detail.
>**Note:** This is not a complete review of the code. This only a review for several main ideas as part of the production.

<a name="setIndexes"></a>
### Writing the setIndexes proc
In this step, I wrote a proc that sets the indexes for each word, in the index arrays.<br/><br/>
The proc consists of one loop, named `setIndexesLoop`. This loop iterates through the input string's chars and compars them to the ascii of a the comma(`,`) symbol. It does so by using the `si` register as an index.<br/>
```assembly
; check whether a comma was found
mov al, commaAscii
mov bx, [bp+4] ; mov the offset of the string into bx
cmp [bx+si], al
jne SetIndexes_continue
```
If a comma is found, then a new word must be entered after it. Therfore the start index of the next word is `si+1`.<br/>
```assembly
setStart:
    ;set a new start
    mov dx, si
    inc dx ; dl is the actual index
    mov bx, [bp+8] ; mov the offset of startIndex into bx
    mov [bx+di+1], dl
```
If a comma was found, then the previous word ended. Therefore the end index of the previous word is `si-1`.
```assembly
setEnd:
    ; set a new end
    mov dx, si
    dec dx ; dl is the actual index
    mov bx, [bp+6] ; mov the offset of endIndex into bx
    mov [bx+di], dl
```
As exampled in the previous blocks of code, the program then stores these values in the index arrays.<br/><br/>
While iterating, the loop will also search for the dot(`.`) symbol. If one is found, than the list was fully entered, the loop teriminates and the proc exits.<br/>
```assembly
SetIndexes_continue:
    ; check whether the dot was found. if it was, then exit the loop
    mov al, dotAscii
    mov bx, [bp+4] ; mov the offset of the string into bx
    cmp [bx+si], al
    je exitLoop
    jne nextIter
```
<br/><br/>
The `setIndexes` has an improtant role in the program. Using it, the program can map the input string, and 'know' where every word starts and ends.

<a name="findLowestWord"></a>
### Writing the findLowestWord proc
In this step, I wrote a proc that finds the index of the lowest word alphabetically, in the index arrays.<br/>
This proc is complicated, so hold on tight, and I'll do my best to explain everything clearly.<br/>
At the start of the proc, the program makes a copy of the values in the startIndex array, in the lowestIndex array, using the following code:
```assembly
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
```
This code helps the program iterate through updated indexes, given to the startIndex array in [the Alphabetize proc](#alpha).<br/><br/>

Moving on, the program uses two loops to find the lowest char value possible in index `di`, which is the index that helps access individual chars in each word.
The first loop is `charLoop`. This loop, uses di to iterate through individual chars in each word. It does that using the second loop - `findLowestLoop`.<br/>
The `findLowestLoop` loop iterates through the indexes of each word in the index arrays, using `si` as an index.<br/>
These two indexes are used to access individual chars in each word, in aim to find the lowest char value in index di in the words.<br/>
The following code does this process:<br/>
```assembly
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
```
<br/>
After finding the lowest char value in char-index `di`, the program eliminates all the other indexes in the lowestIndex array, that doesn't have this char value in their `di` index. It does that by placing a special char in the indexes of these words in lowestIndex.<br/>
In addition, the program sets the `lowestWordIndex` to the index of each word that it's `di` index is the lowest char value.<br/>
The following code, achives that task:<br/>
```assembly
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
```

The char loop runs until only one lowest index is left, or until a word has no more letters, but it's last char matches the lowest char value(then it would be considered the lowest word, and its index will be saved, and the proc will exit). In the first case, at the end, only one word-index will be left, which is the the start index of the lowest word alphabetically.
Therefore, this words' index is saved into `lowestWordIndex` and the proc exits.

### Writing the takeStringInput proc
In this step, I wrote a proc that takes string input from the user.
The proc works this way:<br/>
First, when calling the proc, an offset of an array(a buffer for a string) is passed as a pramater on the stack.
Then, the program takes this offset, and uses it as a way to access each individual address in the array, by increasing the offset by 1 in every iteration of a loop, that takes a char input and stores it in the current offset. Additionally, in every iteration of the loop, the program will check if the dot symbol(that represents the end of the input string) occurs or if the string is full, meaning the loop has reached the max length of the string. If any of those happen to be true, then the loop exits, and the proc is finished.
The following code is the main part of the proc:
```assembly
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
```

### Writing the printWords proc
In this step, I wrote a proc that prints the words from the input string, according to the order of the indexes in the index arrays.<br/>
The code for the proc is fairly simple. There are two loops. One that iterates through the startIndex array, 
and another one that iterates through the chars of each word for each start index.
The following code is the main part of the proc:<br/>
```assembly
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
```
As explained before, there are two loops in this proc, one that iterates on the words - `printWordsLoop`, and another one that iterates on the chars of each word - `printCharsLoop`.

<a name="switch"></a>
### Writing the switchByteSize proc
In this step, I wrote a proc that takes two byte-sized memory addresses and switches the values in these addresses between each other.
I have done that by storing each address' value in a register, using bx to access these value.
Then, using bx again, the program stores each value in the other address.<br/>
The following code is the main part of the proc:<br/>
```assembly
mov bx, [bp+6] ; offset of var1
mov al, [bx] ; value of var1

xor bx, bx
mov bx, [bp+4] ; offset of var2
mov dl, [bx] ; value of var2

; Switch the values
mov [bx], al
mov bx, [bp+6]
mov [bx], dl
```
As you can tell, the `al` and `dl` registers hold the values of the two addresses, than `bx` is used to switch their 'places'.

### Putting all the pieces together
In this step, I wrote a proc that sorts the words alphabetically, using the procs defined in the previous steps.
<a name="alpha"><a/>
#### The Alphabetize proc
The Alphabetize proc is the most significant component of the program. It combines all the other procedures defined before to one proc, that sorts the words alphabetically.<br/>
The following code makes up the proc:<br/>
```assembly
proc Alphabetize 
     ; CALL this function in order: -> 
     ; offset lowestWordIndex, offset lowestIndex, offset startIndex, -> 
     ; offset endIndex, offset testStr, offset numOfWords 

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
```
I'll break up the lines line by line.<br/>
First, the main component of the proc is the `alphaLoop` loop. The loop is done using `si` as an index, while iterating through the first `numOfWords-1` words.<br/><br/>

In each iteration, there are 2 parts:
1. Find the index(in the index arrays) of the lowest word alphabetically.<br/>
The following lines of code call a proc that finds the index of the lowest word alphabetically and enters it into `lowestWordIndex`(see [Writing the findLowestWord proc](#findLowestWord)).<br/>
```assembly
push [bp+14] ; offset lowestWordIndex 
push [bp+6] ; offset str 
              
mov bx, [bp+4]  
push [bx] ; numOfWords(value) 
              
push si ;intial si value for findLowestLoop 
push [bp+10] ; offset startIndex 
push [bp+8] ; offset endIndex 
push [bp+12] ; offset lowestIndex 
call findLowestWord 
```
2. Switch the indexes of the word in index si, and the indexes of the lowest word alphabetically.<br/>
The following lines of code call a proc that switces the value of 2 byte-sized memory addresses(see [Writing the switchByteSize proc](#switch)).<br/>
```assembly
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
```
     

<a name="plans"></a>
## What's next? Plans ahead
After I completed the project, I noticed that  the program was working properly. Unfortunately though, the time complexity of the program is not great. I believe that there is no actual use to the program, mainly because there are other much faster programs that can be used online, without the need to download the program file.
<br/><br/>
Apart from that, I think there are some improvements that are not necessary, but can make the user experience much better.
The input is the main user-involved component  of the program, and I believe it can be drastically improved. Some of my suggestions are handling spaces in the input string, or creating a gui for the user to input the words in. Overall, I think that the user experience can be improved by following these suggestions.

<a name="reflection"></a>
## Reflection
Looking back, I haven't approached this project properly. I have started working on it barely a week before the submission deadline. Therefore, I had a lot of pressure in completing the project in time. That resulted in some difficulty in several parts in the production.<br/>
With that said, I completed the project in time, and I did it will in my opinion.
At the end, I have found the project interesting and I enjoyed the thinking process that was involved in it.
