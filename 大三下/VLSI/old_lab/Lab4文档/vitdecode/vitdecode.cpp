#include <cmath>
#include <ctime>
#include <fstream>
#include <iostream>
using namespace std;

//�ⲿ���ߺ�������
extern int pow(int i, int mi);
extern void dect2bin(int state, int *out);
extern int bin2dect(int *data, int len);
extern int findmin(int array[], int len);
extern void convec(double *input, double *encoded, int nd);

const int L = 71;      //�������
const int state = 64;  //����״̬
//����׼������
void prepare(int expect_out[][4], int next_state[][2], int regpos[][2]) {
  for (int i = 0; i < 64; i++) {
    int encoder_1[7], encoder_2[7];
    int st_1[6], st_2[6];

    //��״̬��ת��Ϊ�����ƣ�������1-6Ϊ
    dect2bin(i, encoder_1);
    dect2bin(i, encoder_2);

    //����������λ���룬0λbit
    encoder_1[0] = 0;
    encoder_2[0] = 1;

    //ÿ��״̬����������bit��Ҳ���������bit
    expect_out[i][0] = (int)(encoder_1[0] + encoder_1[2] + encoder_1[3] +
                             encoder_1[5] + encoder_1[6]) %
                       2;
    expect_out[i][1] = (int)(encoder_1[0] + encoder_1[1] + encoder_1[2] +
                             encoder_1[3] + encoder_1[6]) %
                       2;
    expect_out[i][2] = (int)(encoder_2[0] + encoder_2[2] + encoder_2[3] +
                             encoder_2[5] + encoder_2[6]) %
                       2;
    expect_out[i][3] = (int)(encoder_2[0] + encoder_2[1] + encoder_2[2] +
                             encoder_2[3] + encoder_2[6]) %
                       2;

    //��ǰ״̬�ĺ�һ���ڵķ�֧״̬����Ӧ������Ϊ0,1��״̬����״̬��Ӧ������Ϊ0,1�ķ�֧����
    int state_0, state_1;
    for (int m = 0; m < 6; m++) {
      st_1[m] = encoder_1[m];
      st_2[m] = encoder_2[m];
    }
    state_0 = bin2dect(st_1, 6);
    state_1 = bin2dect(st_2, 6);
    next_state[i][0] = state_0;
    next_state[i][1] = state_1;
  }
  //��¼��һ״̬�ļĴ�������Դ״̬
  for (int i = 0; i < state; i++) {
    int st = 0;
    for (int j = 0; j < state; j++) {
      if (next_state[j][0] == i) {
        regpos[i][0] = j;
        break;
      }
      if (next_state[j][1] == i) {
        regpos[i][0] = j;
        break;
      }
      st += 1;
    }
    for (int j = st + 1; j < state; j++) {
      if (next_state[j][0] == i) {
        regpos[i][1] = j;
        break;
      }
      if (next_state[j][1] == i) {
        regpos[i][1] = j;
        break;
      }
    }
  }
}

//���յ����뺯��
void decode(double *input, double *output, int *receive, int *pm_last,
            int *pm_curr, int next_state[][2], int bm[][2], int expect_out[][4],
            int reg[][L], int regtmp[][L], int regpos[][2], int nd, int &cnt,
            int &tic_now, int &outcount) {
  int bm0 = 0, bm1 = 0;  //��֧������ֵ
  int st0 = 0, st1 = 0;  //״̬��ѡ��
  int pos = 0;           //λ�õļ�¼
  int cycle = 0;
  while (cnt <= nd) {
    //�������
    receive[0] = input[cnt];
    receive[1] = input[cnt + 1];
    //��ÿ��״̬����PM�����ҽ��佫�����ļĴ���ֵ�����м����
    for (int i = 0; i < state; i++) {
      st0 = regpos[i][0];
      st1 = regpos[i][1];  //��ǰ״̬��������Ӧ״̬��Դ
      bm[0][0] = 0;
      bm[0][1] = 0;
      bm[1][0] = 0;
      bm[1][1] = 0;
      for (int j = 0; j < 2; j++) {
        if (receive[j] != expect_out[st0][j])
          bm[0][0] += 1;  //״̬st0����0ʱ��bm0ֵ
        if (receive[j] != expect_out[st0][j + 2])
          bm[0][1] += 1;  //״̬st0����1ʱ��bm1ֵ

        if (receive[j] != expect_out[st1][j])
          bm[1][0] += 1;  //״̬st1����0ʱ��bm0ֵ
        if (receive[j] != expect_out[st1][j + 2])
          bm[1][1] += 1;  //״̬st1����1ʱ��bm1ֵ
      }

      //��ȡ��״̬����������BM
      if (next_state[st0][0] == i) bm0 = bm[0][0];
      if (next_state[st0][1] == i) bm0 = bm[0][1];
      if (next_state[st1][0] == i) bm1 = bm[1][0];
      if (next_state[st1][1] == i) bm1 = bm[1][1];

      //����PM
      if ((pm_last[st0] + bm0) == (pm_last[st1] + bm1)) {
        if (st1 > st0)
          pos = st0;
        else
          pos = st1;
      } else {
        pos = (pm_last[st0] + bm0 > pm_last[st1] + bm1) ? st1 : st0;
      }
      pm_curr[i] = ((pm_last[st0] + bm0) >= (pm_last[st1] + bm1))
                       ? (pm_last[st1] + bm1)
                       : (pm_last[st0] + bm0);
      //���Ĵ����������м����
      for (int j = 0; j < tic_now; j++) regtmp[i][j] = reg[pos][j];
    }

    //�м������ֵ��register,�����о�����
    for (int i = 0; i < state; i++) {
      for (int j = 0; j < tic_now; j++) reg[i][j] = regtmp[i][j];
      //�о�bit�Ĵ洢
      if (i >= 32)
        reg[i][tic_now] = 1;
      else
        reg[i][tic_now] = 0;
    }

    //����о�
    if (tic_now == L - 1) {
      int min = findmin(pm_curr, state);
      for (int i = 0; i < tic_now; i++) output[outcount++] = reg[min][i];
      for (int i = 0; i < state; i++) reg[i][0] = reg[i][tic_now];
      tic_now = 0;
    } else {
      if (cnt == nd) {
        int pos = findmin(pm_curr, state);
        cout << endl;
        for (int j = 0; j < tic_now; j++) {
          output[outcount++] = reg[pos][j];
        }
        cout << endl;
      }
    }

    //������һ״̬
    for (int i = 0; i < state; i++) pm_last[i] = pm_curr[i];
    cnt += 2;
    if (tic_now < L - 1) tic_now++;
  }
}

int main() {
  int receive[2] = {0};   //�洢���յ�2bit��Ϣ
  int bm[2][2] = {0};     //����״̬��������֧����
  int pm_last[64] = {0};  //����ÿ��״̬��һʱ���Ҵ�·���Ķ���
  int pm_curr[64] = {0};  //����ÿ��״̬��ǰʱ�̵��Ҵ�·���Ķ���
  int reg[64][L] = {0};     //�о�bit�洢�Ĵ���
  int regtmp[64][L] = {0};  //�Ĵ����м���������ڽ����洢
  int expect_out[64][4] = {
      0};  //���ڴ洢���������0-1������0���������,2-3������1ʱ���������
  int next_state[64][2] = {
      0};  //ÿ��״̬�����������0��Ӧ����Ϊ1ʱ����һ״̬��1��Ӧ������Ϊ1ʱ����һ״̬
  int regpos[64][2] = {0};  //��¼�Ĵ��������Ķ�Ӧ��ϵ
  int tic_now = 0;          //��ǰ״̬��ʱ����
  int cnt = 0;              //ͳ�������bit��
  int outcount = 0;         //ͳ�������bit��

  srand(time(NULL));

  const int ND = 5000;
  double *input = new double[ND];
  double *encoded = new double[ND * 2];
  double *output = new double[2 * ND];
  for (int i = 0; i < ND; i++) output[i] = 0;

  cout << "����Bit��" << endl;
  for (int i = 0; i < ND; i++) {
    // double tmp= rand() % 3;
    // input[i] = tmp / 2;
    input[i] = rand() % 2;
    cout << input[i];
  }
  convec(input, encoded, ND);
  prepare(expect_out, next_state, regpos);
  decode(encoded, output, receive, pm_last, pm_curr, next_state, bm, expect_out,
         reg, regtmp, regpos, 2 * ND, cnt, tic_now, outcount);

  cout << "���Bit:" << endl;
  for (int i = 0; i < ND; i++) cout << output[i];

  int count = 0;
  cout << endl;
  for (int i = 0; i < ND; i++) {
    if (input[i] != output[i]) {
      if (input[i] != 0.5) count++;
      // cout << i<<'\t'<<input[i] << '\t' << output[i];
      // cout << endl;
    }
  }

  cout << "\n������Bit����" << ND << endl;
  cout << "\n�������Bit����" << count << endl;
  system("pause");
}