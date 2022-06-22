/*
 * @Author: [Zhuohao Lee]
 * @Date: 2014-06-06 18:30:50
 * @LastEditors: [Zhuohao Lee]
 * @LastEditTime: 2022-05-28 21:09:30
 * @FilePath:
 * /undefined/Users/edith_lzh/Desktop/大三下/VLSI/lab/lab3/CC_sim/vitdecode/toolfunct.cpp
 * /undefined/Users/edith_lzh/Desktop/大三下/VLSI/lab/lab3/CC_sim/vitdecode/toolfunct.cpp
 * /undefined/Users/edith_lzh/Desktop/大三下/VLSI/old_lab/Lab4文档/vitdecode/toolfunct.cpp
 * @Description: edith_lzh@sjtu.edu.cn
 * yes
 * Copyright (c) 2022 by Zhuohao Lee, All Rights Reserved.
 */
void convec(double *input, double *encoded, int nd) {
  int encoder[7] = {0};

  for (int i = 0; i < nd; i++) {
    for (int j = 6; j >= 1; j--)
      encoder[j] = encoder[j - 1];  // register shifting
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

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  int numofdata;  // input array's size
  numofdata = mxGetN(prhs[0]);
  plhs[0] = mxCreateDoubleMatrix(1, 2 * numofdata, mxREAL);
  double *output = mxGetPr(plhs[0]);
  double *input = mxGetPr(prhs[0]);
  convec(input, output, num ofdata);
}
