#include "mex.h"

//���뺯��
void convec(double *input, double *encoded, int nd)
{
	int encoder[7] = { 0 };//������

	for (int i = 0; i < nd; i++)
	{

		for (int j = 6; j >= 1; j--)encoder[j] = encoder[j - 1];//���мĴ�����λ
		encoder[0] = input[i];
		int outA = (int)(encoder[0] + encoder[2] + encoder[3] + encoder[5] + encoder[6]) % 2;
		int outB = (int)(encoder[0] + encoder[1] + encoder[2] + encoder[3] + encoder[6]) % 2;

		encoded[2 * i] = outA;
		encoded[2 * i + 1] = outB;
	}
}
//ָ������
int pow(int i, int mi)
{
	int data = 1;
	if (mi != 0)
	{
		for (int j = 0; j<mi; j++)data *= i;
	}
	return data;
}
//���ж����Ƶ�ʮ���Ƶ�ת��
int bin2dect(int *data, int len)
{
	int state = 0;
	for (int j = len - 1; j >= 0; j--)
	{
		state += data[len - 1 - j] * pow(2, j);
	}
	return state;
}
//ʮ���Ƶ������Ƶ�ת��
void dect2bin(int data, int *out)
{
	for (int i = 0; i < 7; i++)
	{
		if (data % 2 == 0)out[6 - i] = 0;
		else out[6 - i] = 1;
		data /= 2;
	}
}
//��С·�����Һ���������ʱ�̵����ʱ��������
int findmin(int array[], int len)
{
	int min = array[0];
	int    position = 0;
	for (int i = 1; i<len; i++)
	{
		if (min > array[i])
		{
			min = array[i];position = i;
		}
	}
	return position;
}

const  int L = 71;                        //�������
const  int state = 64;                    //����״̬
//����׼������
void prepare(int expect_out[][4], int next_state[][2],int regpos[][2])
{
	for (int i = 0; i < 64; i++)
	{
		int encoder_1[7], encoder_2[7];
		int st_1[6], st_2[6];

		//��״̬��ת��Ϊ�����ƣ�������1-6Ϊ
		dect2bin(i, encoder_1); dect2bin(i, encoder_2);

		//����������λ���룬0λbit
		encoder_1[0] = 0; encoder_2[0] = 1;

		//ÿ��״̬����������bit��Ҳ���������bit
		expect_out[i][0] =(int) (encoder_1[0] + encoder_1[2] + encoder_1[3] + encoder_1[5] + encoder_1[6]) % 2;
		expect_out[i][1] =(int) (encoder_1[0] + encoder_1[1] + encoder_1[2] + encoder_1[3] + encoder_1[6]) % 2;
		expect_out[i][2] =(int) (encoder_2[0] + encoder_2[2] + encoder_2[3] + encoder_2[5] + encoder_2[6]) % 2;
		expect_out[i][3] =(int) (encoder_2[0] + encoder_2[1] + encoder_2[2] + encoder_2[3] + encoder_2[6]) % 2;

		//��ǰ״̬�ĺ�һ���ڵķ�֧״̬����Ӧ������Ϊ0,1��״̬����״̬��Ӧ������Ϊ0,1�ķ�֧����
		int state_0, state_1;
		for (int m = 0; m < 6; m++)
		{
			st_1[m] = encoder_1[m];
			st_2[m] = encoder_2[m];
		}
		state_0 = bin2dect(st_1, 6); state_1 = bin2dect(st_2, 6);
		next_state[i][0] = state_0; next_state[i][1] = state_1;
	}
	//��¼��һ״̬�ļĴ�������Դ״̬
	for (int i = 0; i<state; i++)
	{
		int st= 0;
		for (int j = 0; j<state; j++)
		{
			if (next_state[j][0] == i)
			{
				regpos[i][0] = j; break;
			}
			if (next_state[j][1] == i)
			{
				regpos[i][0] = j; break;
			}
			st += 1;
		}
		for (int j = st + 1; j<state; j++)
		{
			if (next_state[j][0] == i)
			{
				regpos[i][1] = j; break;
			}
			if (next_state[j][1] == i)
			{
				regpos[i][1] = j; break;
			}
		}
 	}
}

//���յ����뺯��
void decode(double *input, double *output, int nd)
{
    /*=====��������===============*/
    int    receive[2] = { 0 };                //�洢���յ�2bit��Ϣ
    int    bm[2][2] = { 0 };                  //����״̬��������֧����
    int    pm_last[64] = { 0 };               //����ÿ��״̬��һʱ���Ҵ�·���Ķ���
    int    pm_curr[64] = { 0 };               //����ÿ��״̬��ǰʱ�̵��Ҵ�·���Ķ���
    int    reg[64][L] = { 0 };                //�о�bit�洢�Ĵ���
    int    regtmp[64][L] = { 0 };             //�Ĵ����м���������ڽ����洢
    int    expect_out[64][4] = { 0 };         //���ڴ洢���������0-1������0���������,2-3������1ʱ���������
    int    next_state[64][2] = { 0 };         //ÿ��״̬�����������0��Ӧ����Ϊ1ʱ����һ״̬��1��Ӧ������Ϊ1ʱ����һ״̬
    int    regpos[64][2] = { 0 };             //��¼�Ĵ��������Ķ�Ӧ��ϵ
    int    tic_now = 0;                       //��ǰ״̬��ʱ����
    int    cnt = 0;                           //ͳ�������bit��
    int    outcount = 0;                      //ͳ�������bit��
    prepare(expect_out,next_state,regpos);
    /*=====��ʱ����===============*/
	int bm0 = 0, bm1 = 0;     //��֧������ֵ
	int st0 = 0, st1 = 0;     //״̬��ѡ��
	int pos = 0;              //λ�õļ�¼
	int cycle = 0;
	while (cnt<=nd)
	{
		//�������
		receive[0] = input[cnt]; receive[1] = input[cnt + 1];
		//��ÿ��״̬����PM�����ҽ��佫�����ļĴ���ֵ�����м����
		for (int i = 0; i < state; i++)
		{
			st0 = regpos[i][0]; st1 = regpos[i][1];    //��ǰ״̬��������Ӧ״̬��Դ
			bm[0][0] = 0; bm[0][1] = 0;
			bm[1][0] = 0; bm[1][1] = 0;
            
            for (int j = 0; j < 2; j++)
            {
                if (receive[j] != expect_out[st0][j])    bm[0][0] += 1;     //״̬st0����0ʱ��bm0ֵ
				if (receive[j] != expect_out[st0][j + 2])bm[0][1] += 1;     //״̬st0����1ʱ��bm1ֵ

				if (receive[j] != expect_out[st1][j])    bm[1][0] += 1;     //״̬st1����0ʱ��bm0ֵ
				if (receive[j] != expect_out[st1][j + 2])bm[1][1] += 1;     //״̬st1����1ʱ��bm1ֵ
            }

			//��ȡ��״̬����������BM
			if (next_state[st0][0] == i)bm0 = bm[0][0];
			if (next_state[st0][1] == i)bm0 = bm[0][1];

			if (next_state[st1][0] == i)bm1 = bm[1][0];
			if (next_state[st1][1] == i)bm1 = bm[1][1];

			//����PM
			if ((pm_last[st0]+bm0 )== (pm_last[st1]+bm1))
			{
				if (st1 > st0)pos = st0;
				else pos = st1;
			}
			else
			{
				pos = (pm_last[st0]+bm0 > pm_last[st1]+bm1) ? st1 : st0;
			}
			pm_curr[i] = ((pm_last[st0]+bm0 )>=(pm_last[st1]+bm1)) ? (pm_last[st1]+bm1) : (pm_last[st0]+bm0);
			//���Ĵ����������м����
			for (int j = 0; j < tic_now; j++)regtmp[i][j] = reg[pos][j];
		}

		//�м������ֵ��register,�����о�����
		for (int i = 0; i < state; i++)
		{
			for (int j = 0; j <tic_now; j++)reg[i][j] = regtmp[i][j];
			//�о�bit�Ĵ洢
			if (i >= 32)reg[i][tic_now] = 1;
			else reg[i][tic_now] = 0;
		}

		//����о�
		if (tic_now == L - 1)
		{
			int min = findmin(pm_curr, state);
			for (int i = 0; i < tic_now; i++)output[outcount++] = reg[min][i];
			for (int i = 0; i < state; i++)reg[i][0] = reg[i][tic_now];
			tic_now = 0;
		}
		else
		{
			if (cnt== nd)
			{
				int pos = findmin(pm_curr, state);
				for (int j = 0; j < tic_now; j++)output[outcount++] = reg[pos][j];
                return;
			}
		}
		//������һ״̬
		for (int i = 0; i < state; i++)pm_last[i] = pm_curr[i];
		cnt += 2;
		if (tic_now < L - 1)tic_now++;
	}
}

void mexFunction( int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
  double *output;
  double *input;
  int    nd; //�������Ҫ�����bit��
  
  nd=(mxGetN(prhs[0]));
  
  plhs[0]=mxCreateDoubleMatrix(1,nd/2,mxREAL);
  output=mxGetPr(plhs[0]);
  input =mxGetPr(prhs[0]);
  decode(input,output,nd);
}