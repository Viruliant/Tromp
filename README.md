In order to quickly test & play with all the examples from

you simply clone this repo with:

    git clone https://github.com/Viruliant/Tromp.git

Compile the Lambda interpreters with:

    cd /path/to/clonedDir/
    bash ./LC.sh

and test all the examples from the `test.sh` by either reading them and manually typing each of them in or

    bash ./test.sh

either way if you're not confident in your abilities in the LC you should definitely read AND edit them AND answer the following Questions John Tromp listed [when he won the IOCC with the `./tromp.c` file](http://www.ioccc.org/2012/tromp/hint.html)

1. Which of the term space codes 0,1,2,3 serves multiple purposes?

2. Why is the environment pointer pointing into the term space?

3. What does the test u+m&1? do?

4. How does the program reach exit code 0?

5. And how do any of those blc programs work?

___
# Program Input
If  the  input  doesn’t  start  with  a  valid  program,  that  is,  if  the
interpreter reaches end-of-file during program parsing,  it  will  crash  in
some way. Furthermore, the interpreter requires the initial  encoded  lambda
term to be closed, that is, variable n can only appear  within  at  least  n
enclosing lambdas. For instance the term \ 5  is  not  closed,  causing  the
interpreter to crash when looking into a null-pointer environment.
