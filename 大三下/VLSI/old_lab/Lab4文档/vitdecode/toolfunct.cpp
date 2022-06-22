/*
 * @Author: [Zhuohao Lee]
 * @Date: 2014-06-06 18:30:50
 * @LastEditors: [Zhuohao Lee]
 * @LastEditTime: 2022-05-28 21:09:16
 * @FilePath:
 * /undefined/Users/edith_lzh/Desktop/������/VLSI/old_lab/Lab4�ĵ�/vitdecode/toolfunct.cpp
 * /undefined/Users/edith_lzh/Desktop/������/VLSI/lab/lab3/CC_sim/vitdecode/toolfunct.cpp
 * /undefined/Users/edith_lzh/Desktop/������/VLSI/old_lab/Lab4�ĵ�/vitdecode/toolfunct.cpp
 * @Description: edith_lzh@sjtu.edu.cn
 * yes
 * Copyright (c) 2022 by Zhuohao Lee, All Rights Reserved.
 */
//���뺯��
void convec(double *input, double *encoded, int nd) {
  int encoder[7] = {0};  //������

  for (int i = 0; i < nd; i++) {
    for (int j = 6; j >= 1; j--) encoder[j] = encoder[j - 1];  //���мĴ�����λ
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

//ָ������
int pow(int i, int mi) {
  int data = 1;
  if (mi != 0) {
    for (int j = 0; j < mi; j++) data *= i;
  }
  return data;
}

//���ж����Ƶ�ʮ���Ƶ�ת��
int bin2dect(int *data, int len) {
  int state = 0;
  for (int j = len - 1; j >= 0; j--) {
    state += data[len - 1 - j] * pow(2, j);
  }
  return state;
}

//ʮ���Ƶ������Ƶ�ת��
void dect2bin(int data, int *out) {
  for (int i = 0; i < 7; i++) {
    if (data % 2 == 0)
      out[6 - i] = 0;
    else
      out[6 - i] = 1;
    data /= 2;
  }
}

//��С·�����Һ���������ʱ�̵����ʱ��������
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
