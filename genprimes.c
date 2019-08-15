# include<string.h>
#include<time.h>
#include<stdio.h>
#include<stdlib.h>
#include<omp.h>

int* allValue;
int* prime;
int N;
int floor=0;
int counter =1;
char* fileName;
int numOfThread;

void sequential(){
int i;
int j;
prime[0] =2;
for( i=2; i<N; i++){
  if( allValue[i] !=-100){
    for( j=i; j<N; j+=i){
	allValue[j] = -100;
	} // end of inner loop
	prime[counter] = i;
	counter++;
  } //end of if statement
} // end of outer for loop 
}// end of sequential code

void parallel(){
int i;
int j;
prime[0] =2;
for( i=2; i<N; i++){
  if( allValue[i] !=-100){
	#pragma omp parallel num_threads(numOfThread)
{
	#pragma omp parallel for
    for( j=i; j<N; j+=i){
	allValue[j] = -100;
	} // end of inner loop

}// end of pragma omp parallel
	prime[counter] = i;
	counter++;
  } //end of if statement
} // end of outer for loop 
}// end of parallel code


void main( int argc, char * argv[])
{
N = atoi(argv[1]);
int k;
int i;
double tstart = 0.0, tend=0.0, ttaken;
//numOfThread = atoi(argv[2]);
allValue = (int*) malloc( N* sizeof(int));
int floor = ((N+1)/2)+1;
prime = (int*) malloc( floor* sizeof(int));


for (k=0; k<N; k++){
allValue[k] = k;
}
tstart = omp_get_wtime();
//sequential();
parallel();

ttaken = omp_get_wtime() - tstart;

printf("time taken: %f \n" , ttaken);



char* fileName = malloc(strlen(argv[1]) + 4); 
fileName[0] = '\0';
strcat(fileName, argv[1]);
strcat(fileName, ".txt");

FILE * output  = fopen(fileName,"w");

for( i=1; i<counter; i++){
fprintf(output, "%d %d %d\n", i, prime[i], prime[i]-prime[i-1]);
}

free(allValue);
free(prime);
free(fileName);
}


