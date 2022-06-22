/*
 * @Author: [Zhuohao Lee]
 * @Date: 2014-06-06 18:30:50
 * @LastEditors: [Zhuohao Lee]
 * @LastEditTime: 2022-05-28 21:09:16
 * @FilePath:
 * /undefined/Users/edith_lzh/Desktop/大三下/VLSI/old_lab/Lab4文档/vitdecode/toolfunct.cpp
 * /undefined/Users/edith_lzh/Desktop/大三下/VLSI/lab/lab3/CC_sim/vitdecode/toolfunct.cpp
 * /undefined/Users/edith_lzh/Desktop/大三下/VLSI/old_lab/Lab4文档/vitdecode/toolfunct.cpp
 * @Description: edith_lzh@sjtu.edu.cn
 * yes
 * Copyright (c) 2022 by Zhuohao Lee, All Rights Reserved.
 */
//编码函数
void convec(double *input, double *encoded, int nd) {
  int encoder[7] = {0};  //编码器

  for (int i = 0; i < nd; i++) {
    for (int j = 6; j >= 1; j--) encoder[j] = encoder[j - 1];  //进行寄存器移位
    encoder[0] = input[i];
    int outA =
        (int)(encoder[0] + encoder[2] + encoder[3] + encoder[5] + encoder[6]) %
        2;
    int outB =
        (int)(encoder[0] + encoder[1] + encoder[2] + encoder[3] + encoder[6]) %
        2;

    encoded[2 * i] = outA;
    encoded[2 * i + 1] = outB;
  }
}

//指数运算
int pow(int i, int mi) {
  int data = 1;
  if (mi != 0) {
    for (int j = 0; j < mi; j++) data *= i;
  }
  return data;
}

//进行二进制到十进制的转换
int bin2dect(int *data, int len) {
  int state = 0;
  for (int j = len - 1; j >= 0; j--) {
    state += data[len - 1 - j] * pow(2, j);
  }
  return state;
}

//十进制到二进制的转换
void dect2bin(int data, int *out) {
  for (int i = 0; i < 7; i++) {
    if (data % 2 == 0)
      out[6 - i] = 0;
    else
      out[6 - i] = 1;
    data /= 2;
  }
}

//最小路径查找函数，便于时刻到达的时候进行输出
int findmin(int array[], int len) {
  int min = array[0];
  int position = 0;
  for (int i = 1; i < len; i++) {
    if (min > array[i]) {
      min = array[i];
      position = i;
    }
  }
  return position;
}
