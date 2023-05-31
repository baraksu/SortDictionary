# Alphabetizing Program
***
## Details about the project
**Project Name:** Alphabetizing Program<br/>
**Programmar:** Ethan Miller.<br/>
**Grade:** 10.<br/>
**Class:** Computer Science. Taught by Barak Suberri.<br/>
**School:** Yeshivat Bnei Aquiva Givat Shmuel.<br/>
**Year Of Submission:** 2023.<br/>
**Project Status:** Production/`Completed`/Submitted

## What is the purpose of the project?
The project was written copletely in assembly language 8086, and consists of one .asm file( see [program.asm](https://github.com/baraksu/SortDictionary/blob/main/program.asm)).
The purpose of the program is to take an input string, which consists of words separated by commas,
procces it and return a new alphabeticaly sorted list of words.

## How does it work?
`add runtime samples, pictures and explanations here`
### Runtime Samples
word index (si)| 0
:---: | :---:
input | aisle,bike,alone
--- | ---
startIndex | 0, 6, 11
--- | ---
endIndex | 4, 9, 15

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
Writing a proc that sets the indexes for each word, in the index arrays.
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

## Reflection

