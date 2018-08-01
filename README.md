# genPrimeNumbers
imnplementation of a  openmp code to generate prime numbers from 2 to N and a report that contains the speedup relative to the running time with 1 thread; the table will have number of threads = 2, 5, 10, 20, 40, 80, and 100. \n
Example:
Suppose N = 20
floor of (20+1)/2 = 10 <= where we stop.
Initially we have:
2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
Let’s cross all multiple of 2 (but leave 2):
2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
Next number is 3, so we cross all multiple of 3 that have not been crossed:
2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
Next number that has not been crossed is 5, so we will cross multiple of 5 (i.e. 10, 15, and 20).
As you see below, they are all already crossed.
2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
Next number that has not been crossed is 7, so we will cross multiple of 7 (i.e. 14). As you see
below, they are all already crossed.
2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
The next number that has not been crossed is 11. This is bigger than 10, so we stop here.
The numbers that have not been crossed are the prime numbers:
2, 3, 5, 7, 11, 13, 17, 19
### Compiling
```
gcc -g -Wall -fopenmp -std=c99 -o genprime genprimes.c
```

### Running
```
./genprime N t
```
Where:
N is a positive number bigger than 2 and less than or equal to 100,000
t is the number of threads and is a positive integer that does not exceed 100..

