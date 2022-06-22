#include "mex.h"

//对输入数组进行编码，nd为输入数据
void convec(double *input,double *encoded,int nd)
{
	double encoder[7] = { 0 };//编码器
	
	for (int i = 0; i < nd; i++)
	{

		for (int j = 6; j >= 1; j--)encoder[j] = encoder[j - 1];//进行寄存器移位
        encoder[0] = input[i];
		double outA = (int)(encoder[0] + encoder[2] + encoder[3] + encoder[5] + encoder[6]) % 2;
		double outB = (int)(encoder[0] + encoder[1] + encoder[2] + encoder[3] + encoder[6]) % 2;

		encoded[2 * i] = outA;
		encoded[2 * i + 1] = outB;
	}
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	int numofdata;                                          //输入数组的大小
	numofdata = mxGetN(prhs[0]);
    
    plhs[0]=mxCreateDoubleMatrix(1,2*numofdata,mxREAL);
    double *output=mxGetPr(plhs[0]);
    double *input=mxGetPr(prhs[0]);
    convec(input,output,numofdata);
}