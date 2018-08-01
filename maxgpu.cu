#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>


// Thread block size
#define BLOCK_SIZE 512

int SOA;



int i;
void randomInit(int* data, int size)
{	
    for( i = 0; i < size; i++){
       data[i] = rand()  % size;   
   }
}
 

__global__ void ReductionMax2(int *input, int *results, int n)    //take thread divergence into account
{	
	extern __shared__ int sdata[];
	//sdata[blockIdx.x] =0;
	unsigned int i = blockIdx.x * blockDim.x + threadIdx.x; // thread Id for particular block
	unsigned int tx = threadIdx.x;// thread Id for current block
	 //load input into __shared__ memory 
	int x; 
	int j;
	//printf("%d " , i);
	__syncthreads();

for(x=blockIdx.x*512; x<(blockIdx.x*512)+512; x++){
if(x < n && tx==0){ 
	//printf("blockIdx = %d and x = %d\n", blockIdx.x,x);
if(input[x]> results[blockIdx.x]){
	results[blockIdx.x] = input[x];
	//printf("results = %d", results[blockIdx.x]);
	}
	}
}
__syncthreads();
if(threadIdx.x==0 && blockIdx.x==0){
for(j=0; j<(blockDim.x/512)+1; j++){
//printf("results[j] = %d\n", results[j]);
}
}


}// end of kernel




int main(int argc, char* argv[]) 
{ 

int counter =0;
int gpuMax=0;
int cpuMax=0;

SOA = atol(argv[1]);


if( SOA >= 10000000){
counter = SOA/1000000;
}

if( counter==0){
		int num_blocks = SOA / BLOCK_SIZE;
		//allocate host memory for array a
		unsigned int mem_size_a = sizeof(int) * SOA;
		int* h_a = (int*)malloc(mem_size_a);
		
		//initialize host memory
		randomInit(h_a,SOA);

		//allocate device memory
		int* d_a;
		cudaMalloc((void**) &d_a, mem_size_a);

		//copy host memory to device
		cudaMemcpy(d_a, h_a, mem_size_a, cudaMemcpyHostToDevice);


		unsigned int mem_size_b = sizeof(int) * SOA;
		int* d_b;

		cudaMalloc((void**) &d_b, mem_size_b);
	

	
	 int mem_size_c = sizeof(int) * SOA;
		int* h_c = (int*)malloc(mem_size_c);

		//setup execution parameters
		dim3 block(512);
		dim3 grid(num_blocks+1);

		//execute the kernel
		ReductionMax2<<<grid, block>>>(d_a,d_b,SOA);
		cudaMemcpy(h_c, d_b, mem_size_c, cudaMemcpyDeviceToHost);

		int i;
	for(i=0; i<num_blocks+1;i++){
		if(h_c[i] > gpuMax){
		gpuMax = h_c[i];
		}
		}
	
 printf(" The maximum number in the array is: %d\n", gpuMax);

		//clean up memory
		free(h_a);
		free(h_c);
		cudaFree(d_a);
		cudaFree(d_b);

		cudaThreadExit();
}// end of if
else{
int gpuMax=0;
int tempMax=0;
unsigned int mem_size_a = sizeof(int) * SOA;
int* h_a = (int*)malloc(mem_size_a);
//initialize host memory
randomInit(h_a,SOA);
int i;
int j;
SOA = SOA/counter;
int num_blocks = SOA / BLOCK_SIZE;
printf("SOA is %d\n", SOA);
for (i=0; i<counter; i++){
int * h_b = (int*) malloc(sizeof(int)*SOA);
for(j= i*SOA; j<i*SOA+SOA; j++){
	h_b[j] = h_a[j];
}// end of initiating random array 
	int* d_a;
	cudaMalloc((void**) &d_a, mem_size_a);
	cudaMemcpy(d_a, h_b, (sizeof(int)*SOA), cudaMemcpyHostToDevice);
	
	int* d_b;
	cudaMalloc((void**) &d_b, mem_size_a);

	 int mem_size_c = sizeof(int) * SOA;
	int* h_c = (int*)malloc(mem_size_c);
		dim3 block(512);
		dim3 grid(num_blocks);

		//execute the kernel
		//first reduce per-block partial maxs
		ReductionMax2<<<grid, block>>>(d_a,d_b,SOA);
		cudaMemcpy(h_c, d_b, mem_size_c, cudaMemcpyDeviceToHost);
		for(i=0; i<num_blocks+1;i++){
		if(h_c[i] > tempMax){
		tempMax = h_c[i];
		}
		}
if (tempMax>gpuMax){
gpuMax = tempMax;
}
} //end of for loop
 printf(" The maximum number in the array is: %d\n", gpuMax);
}// end else
}// end of main