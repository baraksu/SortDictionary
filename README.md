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
Then, after the list was fully submmited, the program will iterate throught the input string, saving each start & end index for each word in the index arrays.<br/>
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

#### Sample 2
word index (si)|     init      |   0  |  1  
 ------------- | ------------- | ---- | -----
inputString | quotation,situation,necklace. | quotation,situation,necklace. | quotation,situation,necklace.
startIndex | 0, 10, 20 | 11, 5, 0, 17, 22 | 11, 17, 0, 5, 22
endIndex | 8, 18, 27 | 15, 9, 3, 20, 28 | 15, 20, 3, 9, 28
expected output | arch,quite,alien,play,warrior. | alien,quite,arch,play,warrior. | alien,play,arch,quite,warrior.

<a name="use"></a>
## How to use the program?
When running the program, the console will be opened, and a prompt will be shown on the screen.
Then, the user will be required to enter words, following these instructions:
1. The words are separated by commas.<br/>
2. There are no spaces between words and commas.<br/>
3. The list ends with a dot. Then the program will continue.<br/>

After entering the list of words, the program  will sort the words in alphabetical order.
Then the sorted list will be printed onto the console.

<a name="production"></a>
## The production process
### Writing the setIndexes proc
In this step, I wrote a proc that sets the indexes for each word, in the index arrays.<br/><br/>
This is the assembly code for the proc.<br/>
I'll explain the code in detail in the next few lines.<br>
```assembly
mov ax, bx
```
<a name="findLowestWord"></a>
### Writing the findLowestWord proc
Writing a proc that finds the index of the lowest word alphabetically, in the index arrays.

### Writing the takeStringInput proc
Writing a proc that takes string input.

### Writing the printWords proc
Writing a proc that prints the words from the input string, according to the order of the indexes in the index arrays.

<a name="switch"></a>
### Writing the switchByteSize proc
Writing a proc that takes two memory addresses and switches the values in these addresses between each other.

### Putting all the pieces together
Writing a proc that sorts the words alphabetically, using the procs defined in the previous steps.
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
I'll break up the lines step by step.<br/>
First, the main part of the proc is the `alphaLoop` loop. The loop is done using `si` as an index, while iterating through the first `numOfWords-1` words.<br/><br/>

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
