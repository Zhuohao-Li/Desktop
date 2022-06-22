#include <cmath>
#include <ctime>
#include <fstream>
#include <iostream>
using namespace std;

//外部工具函数引用
extern int pow(int i, int mi);
extern void dect2bin(int state, int *out);
extern int bin2dect(int *data, int len);
extern int findmin(int array[], int len);
extern void convec(double *input, double *encoded, int nd);

const int L = 71;      //译码深度
const int state = 64;  //所有状态
//数据准备函数
void prepare(int expect_out[][4], int next_state[][2], int regpos[][2]) {
  for (int i = 0; i < 64; i++) {
    int encoder_1[7], encoder_2[7];
    int st_1[6], st_2[6];

    //将状态数转换为二进制，保存在1-6为
    dect2bin(i, encoder_1);
    dect2bin(i, encoder_2);

    //编码器的首位输入，0位bit
    encoder_1[0] = 0;
    encoder_2[0] = 1;

    //每个状态的期望编码bit，也即期望输出bit
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

    //当前状态的后一周期的分支状态，对应于输入为0,1的状态，此状态对应于输入为0,1的分支度量
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
  //记录下一状态的寄存器的来源状态
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

//最终的译码函数
void decode(double *input, double *output, int *receive, int *pm_last,
            int *pm_curr, int next_state[][2], int bm[][2], int expect_out[][4],
            int reg[][L], int regtmp[][L], int regpos[][2], int nd, int &cnt,
            int &tic_now, int &outcount) {
  int bm0 = 0, bm1 = 0;  //分支度量的值
  int st0 = 0, st1 = 0;  //状态的选择
  int pos = 0;           //位置的记录
  int cycle = 0;
  while (cnt <= nd) {
    //获得输入
    receive[0] = input[cnt];
    receive[1] = input[cnt + 1];
    //对每个状态计算PM，并且将其将交换的寄存器值存入中间变量
    for (int i = 0; i < state; i++) {
      st0 = regpos[i][0];
      st1 = regpos[i][1];  //当前状态的两个对应状态来源
      bm[0][0] = 0;
      bm[0][1] = 0;
      bm[1][0] = 0;
      bm[1][1] = 0;
      for (int j = 0; j < 2; j++) {
        if (receive[j] != expect_out[st0][j])
          bm[0][0] += 1;  //状态st0输入0时的bm0值
        if (receive[j] != expect_out[st0][j + 2])
          bm[0][1] += 1;  //状态st0输入1时的bm1值

        if (receive[j] != expect_out[st1][j])
          bm[1][0] += 1;  //状态st1输入0时的bm0值
        if (receive[j] != expect_out[st1][j + 2])
          bm[1][1] += 1;  //状态st1输入1时的bm1值
      }

      //获取该状态的两个输入BM
      if (next_state[st0][0] == i) bm0 = bm[0][0];
      if (next_state[st0][1] == i) bm0 = bm[0][1];
      if (next_state[st1][0] == i) bm1 = bm[1][0];
      if (next_state[st1][1] == i) bm1 = bm[1][1];

      //计算PM
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
      //将寄存器交换至中间变量
      for (int j = 0; j < tic_now; j++) regtmp[i][j] = reg[pos][j];
    }

    //中间变量赋值给register,并且判决译码
    for (int i = 0; i < state; i++) {
      for (int j = 0; j < tic_now; j++) reg[i][j] = regtmp[i][j];
      //判决bit的存储
      if (i >= 32)
        reg[i][tic_now] = 1;
      else
        reg[i][tic_now] = 0;
    }

    //输出判决
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

    //进入下一状态
    for (int i = 0; i < state; i++) pm_last[i] = pm_curr[i];
    cnt += 2;
    if (tic_now < L - 1) tic_now++;
  }
}

int main() {
  int receive[2] = {0};   //存储接收的2bit信息
  int bm[2][2] = {0};     //保存状态的期望分支度量
  int pm_last[64] = {0};  //保存每个状态上一时刻幸存路径的度量
  int pm_curr[64] = {0};  //保存每个状态当前时刻的幸存路径的度量
  int reg[64][L] = {0};     //判决bit存储寄存器
  int regtmp[64][L] = {0};  //寄存器中间变量，用于交换存储
  int expect_out[64][4] = {
      0};  //用于存储期望输出，0-1是输入0的期望输出,2-3是输入1时的期望输出
  int next_state[64][2] = {
      0};  //每个状态的期望输出，0对应输入为1时的下一状态，1对应于输入为1时的下一状态
  int regpos[64][2] = {0};  //记录寄存器交换的对应关系
  int tic_now = 0;          //当前状态的时钟数
  int cnt = 0;              //统计译码的bit数
  int outcount = 0;         //统计译码的bit数

  srand(time(NULL));

  const int ND = 5000;
  double *input = new double[ND];
  double *encoded = new double[ND * 2];
  double *output = new double[2 * ND];
  for (int i = 0; i < ND; i++) output[i] = 0;

  cout << "输入Bit：" << endl;
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

  cout << "输出Bit:" << endl;
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

  cout << "\n总输入Bit数：" << ND << endl;
  cout << "\n译码错误Bit数：" << count << endl;
  system("pause");
}