/*
soft-input soft-output log-MAP BCJR decoding algorithm for Convolutional Code codes

developed by
       Jiaxin Lyu
       {ljx981120@sjtu.edu.cn}
       

Summary:    Computing the exact a-posteriori LLRs by forward-backward message passing
 *           giving a-priori LLRs and the parameter of the trellis of Convolutional Code codes
 * 
How to use:
 *      [LLR_D,bit_output]=BCJR(LLR_A, numInputSymbols,numOutputSymbols,numStates,nextStates,outputs)
 *
Input:  LLR_A,             a vector of a-priori LLRs
 *      numInputSymbols,   number of input symbols, 2^k
 *      numOutputSymbols,  number of output symbols, 2^n
 *      numStates,         number of states
 *      nextStates,        next state matrix
 *      outputs,           output matrix
        
Output: LLR_D is the exact a-posteriori LLRs.
        bit_output is the final hard decision of the info_bits
         
Statement:
This algorithm may be used freely for VLSI and Digital Communication Course.
*/
#include "mex.h" 
#include <float.h>
#include "math.h"
#include <matrix.h>
#include <string.h>
#include <stdlib.h>
#include <omp.h>

#define max(a,b) ((a) > (b) ? (a) : (b))

double ln_sum_exp(double a, double b) 
{
    /*calculate ln(exp(a) + exp(b)), more numerically stable*/
    return max(a,b) + log(1+exp(-fabs(a-b)));
}

int log2floor(int x) 
{
    /*calculate floor(log2(x))*/
    int result=0;    
    while((1 << result) < x)  result++;
    return result;
}

mxLogical bit_sign(double a, double b)
{
    if (a>b)
        return 1;
    else
        return 0;
}



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
    /*input data*/
    double *LLR_A; /*a-priori LLRs*/
    int numInputSymbols,numOutputSymbols,numStates; /*the parameters of CC trellis*/
    double *nextStatesArr,*outSymbolsArr;                    /*the parameters of CC trellis*/
    
    /*output data*/
    double *LLR_D;
    mxLogical *bit_output; //mxLogical is a mex data type, similar to bool in C99

    /*temporary use*/
    int i,j,k,tmp,p,q,b,BitIdx;
    int numInputBits,numOutputBits,numBits,numSymbols,nextState,numInfoBits;
    double *LLR_A_copy,*BMVector,*alphaArr,*betaVector,*oldbetaVector,prevAlpha,curMetric,outputMetric;
    double *xhat0,*xhat1,*llr_0,*llr_1;


    if((nrhs!=6) || (nlhs!=2))
        mexErrMsgTxt("USAGE: [LLR_D,bit_output]=BCJR(LLR_A, numInputSymbols,numOutputSymbols,numStates,nextStates,outputs)\n"); 

    /*read all inputs*/
    LLR_A                = mxGetPr(prhs[0]);
    numBits              = mxGetM(prhs[0]);
    numInputSymbols      = (int)(*mxGetPr(prhs[1]));
    numOutputSymbols     = (int)(*mxGetPr(prhs[2]));
    numStates            = (int)(*mxGetPr(prhs[3]));
    nextStatesArr        = mxGetPr(prhs[4]);
    outSymbolsArr        = mxGetPr(prhs[5]);

    /*calculate some dimensions*/
    numInputBits         = log2floor(numInputSymbols); // numInputSymbols=2^numInputBits;
    numOutputBits        = log2floor(numOutputSymbols); // numOutputSymbols=2^numOutputBits;
    numSymbols           = numBits/numOutputBits;
    numInfoBits          = numInputBits*numSymbols;
  
  
    /*dynamic memory allocation*/
    LLR_A_copy = (double *)mxCalloc(numBits,sizeof(double));
    memcpy(LLR_A_copy,LLR_A,numBits*sizeof(double)); /*copy LLR_A to LLR_A_copy*/

    BMVector = (double *)mxCalloc(numOutputSymbols,sizeof(double));
    alphaArr = (double *)mxCalloc(numStates*(numSymbols+1),sizeof(double));
    betaVector = (double *)mxCalloc(numStates,sizeof(double));
    oldbetaVector = (double *)mxCalloc(numStates,sizeof(double));
    xhat0 = (double *)mxCalloc(numInfoBits,sizeof(double));
    xhat1 = (double *)mxCalloc(numInfoBits,sizeof(double));
    llr_0 = (double *)mxCalloc(numBits,sizeof(double));
    llr_1 = (double *)mxCalloc(numBits,sizeof(double));
   

    /*output*/
    plhs[0]             = mxCreateDoubleMatrix(numBits,1,mxREAL);
    plhs[1]             = mxCreateLogicalMatrix(numInfoBits,1);
    LLR_D               = mxGetPr(plhs[0]);
    bit_output          = mxGetLogicals(plhs[1]);

    /*We use eight parallel threads for speeding up*/
    omp_set_num_threads(8); 

    #pragma omp parallel for
    for (i = 0; i<numBits; i++)
        LLR_A_copy[i] *= 0.5;


    /* ------------------------------------------------------------------- */
    /* Alpha-Metric (Forward Iteration)                                    */
    /* ------------------------------------------------------------------- */
    /* By definition, we start in state 0 */
    #pragma omp parallel for private(j)
    for(i = 0; i<numSymbols; i++)
    {
        for(j = 0;j<numStates; j++)
            alphaArr[j+i*numStates] = -DBL_MAX;
    }
    alphaArr[0] = 99999999;

    for (i = 0; i<numSymbols; i++)
    {
        /* precompute the Branch Metric for each output Symbol, based on the 0.5*LLR_A */
        for (q = 0; q<numOutputSymbols; q++)
        {
            BMVector[q] = 0;
            tmp = q;
            for (b = numOutputBits-1; b>=0; b--)
            {
                if(tmp>=(1 << b))
                {
                    tmp = tmp - (1 << b);
                    BMVector[q] += LLR_A_copy[i*numOutputBits+numOutputBits-1-b]; /* first bit is MSB */
                }
                else   
                    BMVector[q] -= LLR_A_copy[i*numOutputBits+numOutputBits-1-b]; /* first bit is MSB */
            }
        }

        /* ------------------ carry out one trellis step ------------------------- */
        for (j = 0;j<numStates; j++) 
        {                            
            /* for each to-state */
            prevAlpha = alphaArr[j+i*numStates];
            /* for each branch */
            for (p = 0; p <numInputSymbols; p++) 
            {                  
                /* for each branch */
	            k = (int)outSymbolsArr[j+p*numStates];
                curMetric = prevAlpha + BMVector[k];
                nextState = (int)nextStatesArr[j+p*numStates];

                alphaArr[nextState+(i+1)*numStates]=ln_sum_exp(curMetric, alphaArr[nextState+(i+1)*numStates]);
            }
        }
    }

    /* ------------------------------------------------------------------- */
    /* Beta-Metric (Backward Iteration)                                    */
    /* ------------------------------------------------------------------- */
    #pragma omp parallel for
    for(j = 0; j<numStates; j++) 
        oldbetaVector[j] = -DBL_MAX;

    oldbetaVector[0] = 9999999; /* Termination */

    for (i = numSymbols; i>0; i--) 
    {
        /* precompute the Branch Metric for each output Symbol, based on the LLRs */
        for(q = 0; q<numOutputSymbols; q++) 
        {
            BMVector[q]=0;
            tmp = q;
            for(b = numOutputBits-1; b>=0; b--)
            {
                if(tmp>=(1 << b))
                {
                    tmp = tmp - (1 << b);
                    BMVector[q] += LLR_A_copy[i*numOutputBits-1-b];  /* first bit is MSB */
                }
                else
                    BMVector[q] -= LLR_A_copy[i*numOutputBits-1-b];  /* first bit is MSB */
            }
        }

        /* ------------------ carry out one trellis step ------------------------- */
        for (j = 0; j<numStates; j++) 
        {
            /* for each state */
            for (p = 0; p <numInputSymbols; p++)  
            { 
                /* for each branch */
                /* ---- Beta ------------- */
                k = (int)outSymbolsArr[j+p*numStates];
                nextState = (int)nextStatesArr[j+p*numStates];
                curMetric = oldbetaVector[nextState]+BMVector[k];
        
                /***************************************************/
        
                if (p==0) betaVector[j] = curMetric;
                else betaVector[j] = ln_sum_exp(curMetric,betaVector[j]);

                /* ---- output metric of current state ---- */
                outputMetric = curMetric + alphaArr[j+(i-1)*numStates]; 
          
                /* ---- LLR output of input bits ---- */
                for (b = numInputBits-1; b>=0; b--) 
                {
                    BitIdx = numInputBits*i-1-b;
                    if (p & (1<<b)) 
                    { /* bit is +1 */
                        xhat1[BitIdx] = ln_sum_exp(outputMetric,xhat1[BitIdx]);
                    } 
                    else /* bit is -1 */   
                        xhat0[BitIdx] = ln_sum_exp(outputMetric,xhat0[BitIdx]);
                }
                                  
                /* ---- a posteriori LLR output calculation ---- */         
                for (b = numOutputBits-1; b>=0; b--)
                {
                    BitIdx = i*numOutputBits-1-b; 
                    if (k >= (1 << b))
                    {
                        /* bit is +1 */
                        k = k - (1<<b);
                        llr_1[BitIdx] = ln_sum_exp(outputMetric,llr_1[BitIdx]);
                    }
                    else /* bit is -1 */
                        llr_0[BitIdx] = ln_sum_exp(outputMetric,llr_0[BitIdx]);
                }                  
      
            } 
        } 
        /* copy the beta state metric */
        memcpy(oldbetaVector,betaVector,numStates*sizeof(double));
    } 

    /* compute the sliced systematic output bits */
    #pragma omp parallel for
    for (i = 0; i<numInfoBits; i++)
        bit_output[i] = bit_sign(xhat1[i],xhat0[i]);

    /* compute the a posteriori LLRs*/
    #pragma omp parallel for
    for (i = 0; i<numBits; i++) 
        LLR_D[i] = llr_1[i]-llr_0[i];

    

    mxFree(LLR_A_copy);
    mxFree(BMVector);
    mxFree(alphaArr);
    mxFree(betaVector);
    mxFree(oldbetaVector);
    mxFree(xhat0);
    mxFree(xhat1);
    mxFree(llr_1);
    mxFree(llr_0);
    
    return;    
} 
