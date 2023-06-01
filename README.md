# Alphabetizing Program
***
## Table of contents
- [Details about the project](#details)
- [What is the purpose of the project?](#purpose)
- [How does it work?](#how)
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
`add runtime samples, pictures and explanations here`
### Runtime Samples
#### Sample 1
word index (si)|     init      |   0  |  1  
 ------------- | ------------- | ---- | -----
inputString | bike,call,aisle. | bike,call,aisle. | bike,call,aisle.
startIndex | 0, 5, 10 | 10, 5, 0 | 10, 0, 5
endIndex | 3, 8, 14 | 14, 8, 3 | 14, 3, 8
expected output | bike,call,aisle. | aisle,call,bike. | aisle,bike,call.

#### Sample 2
word index (si)|     init      |   0  |  1  
 ------------- | ------------- | ---- | -----
inputString | arch,quite,alien,play,warrior. | arch,quite,alien,play,warrior. | arch,quite,alien,play,warrior.
startIndex | 0, 5, 11, 17, 22 | 11, 5, 0, 17, 22 | 11, 17, 0, 5, 22
endIndex | 3, 9, 15, 20, 28 | 15, 9, 3, 20, 28 | 15, 20, 3, 9, 28
expected output | arch,quite,alien,play,warrior. | alien,quite,arch,play,warrior. | alien,play,arch,quite,warrior.

## How to use the program?
When running the program, the console will be opened, and a prompt will be shown on the screen.
Then, the user will be required to enter words, following these instructions:
1. The words are separated by commas.<br/>
2. There are no spaces between words and commas.<br/>
3. The list ends with a dot. Then the program will continue.<br/>

After entering the list of words, the program  will sort the words in alphabetical order.
Then the sorted list will be printed onto the console.

## The production process
### Writing the setIndexes proc
In this step, I wrote a proc that sets the indexes for each word, in the index arrays.<br/><br/>
This is the assembly code for the proc.<br/>
I'll explain the code in detail in the next few lines.<br>
```assembly
mov ax, bx
```
### Writing the findLowestWord proc
Writing a proc that finds the index of the lowest word alphabetically, in the index arrays.
### Writing the takeStringInput proc
Writing a proc that takes string input.
### Writing the printWords proc
Writing a proc that prints the words from the input string, according to the order of the indexes in the index arrays.
### Writing the switchByteSize proc
Writing a proc that takes two memory addresses and switches the values in these addresses between each other.
### Putting all the pieces together
Writing a proc that sorts the words alphabetically, using the procs defined in the previous steps.

## What's next? Plans ahead
After I completed the project, I noticed that  the program was working properly. Unfortunately though, the time complexity of the program is not great. I believe that there is no actual use to the program, mainly because there are other much faster programs that can be used online, without the need to download the program file.
<br/><br/>
Apart from that, I think there are some improvements that are not necessary, but can make the user experience much better.
The input is the main user-involved component  of the program, and I believe it can be drastically improved. Some of my suggestions are handling spaces in the input string, or creating a gui for the user to input the words in. Overall, I think that the user experience can be improved by following these suggestions.

## Reflection
Looking back, I haven't approached this project properly. I have started working on it barely a week before the submission deadline. Therefore, I had a lot of pressure in completing the project in time. That resulted in some difficulty in several parts in the production.<br/>
With that said, I completed the project in time, and I did it will in my opinion.
At the end, I have found the project interesting and I enjoyed the thinking process that was involved in it.
