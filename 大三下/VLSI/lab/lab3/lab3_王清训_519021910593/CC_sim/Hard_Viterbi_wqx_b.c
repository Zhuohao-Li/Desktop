/*Wang Qingxun's Viterbi decoder*/

#include <matrix.h>
#include <omp.h>
#include <stdlib.h>
#include <string.h>

#include "math.h"
#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  /*input data*/
  double *rx_bits;    /*receive bits*/
  double *next, *out; /*the parameters of CC trellis*/
  int tblen;          /*length of tb*/

  double *puncturing_pattern; /*puncturing_pattern: for example, [1 1 1 0]
                                 represents the last bit of every four coded
                                 bits is dropped*/

  /*output data*/
  mxLogical *info_bits_hat;  // mxLogical is a mex data type, similar to bool in
                             // C99, logical in matlab
  mxLogical *windows_out;
  /*temporary use*/
  int i, j, l, x, nextstate0, nextstate1, output0, output1, count, q, b, state,
      count_y;
  int *windows, *windows_copy, *F, *transfer, *input, *y;

  /*read all inputs*/
  rx_bits = mxGetPr(prhs[0]);
  next = mxGetPr(prhs[1]);
  out = mxGetPr(prhs[2]);
  tblen = (int)(*mxGetPr(prhs[3]));
  puncturing_pattern = mxGetPr(prhs[4]);
  /*dynamic memory allocation*/
  windows = (int *)mxCalloc(2160 * 64, sizeof(int));
  windows_copy = (int *)mxCalloc(2160 * 64, sizeof(int));
  F = (int *)mxCalloc(64, sizeof(int));
  transfer = (int *)mxCalloc(64 * 64, sizeof(int));
  input = (int *)mxCalloc(64 * 64, sizeof(int));
  y = (int *)mxCalloc(2, sizeof(int));
  /*output*/
  plhs[0] = mxCreateLogicalMatrix(2160, 1);
  info_bits_hat = mxGetLogicals(plhs[0]);

  /*******main part*******/

  if (!puncturing_pattern[1])  // bit rate = 1/2
  {
    /*******initialization*******/
    for (i = 0; i < 64; i++) {
      for (j = 0; j < tblen; j++) windows[j + i * tblen] = 0;
    }
    memcpy(windows_copy, windows, tblen * 64 * sizeof(int));
    for (i = 1; i < 64; i++) F[i] = -1;
    F[0] = 0;
    for (l = 0; l < 2160; l++) {
      for (i = 0; i < 64; i++) {
        for (j = 0; j < 64; j++) {
          transfer[j + i * 64] = 100000;
          input[j + i * 64] = -1;
        }
      }

      for (x = 0; x < 64; x++) {
        if (F[x] >= 0) {  //根据input获得nextstate和output
          nextstate0 = (int)(next[x]);
          nextstate1 = (int)(next[x + 64]);
          output0 = (int)(out[x]);
          output1 = (int)(out[x + 64]);

          switch (output0)  //计算路径度量（=分支度量+先前状态的路径度量）
          {
            case 0:
              transfer[x + nextstate0 * 64] =
                  (int)(!(rx_bits[l * 2] == 0)) +
                  (int)(!(rx_bits[l * 2 + 1] == 0)) + F[x];
              input[x + nextstate0 * 64] = 0;
              break;
            case 1:
              transfer[x + nextstate0 * 64] =
                  (int)(!(rx_bits[l * 2] == 0)) +
                  (int)(!(rx_bits[l * 2 + 1] == 1)) + F[x];
              input[x + nextstate0 * 64] = 0;
              break;
            case 2:
              transfer[x + nextstate0 * 64] =
                  (int)(!(rx_bits[l * 2] == 1)) +
                  (int)(!(rx_bits[l * 2 + 1] == 0)) + F[x];
              input[x + nextstate0 * 64] = 0;
              break;
            case 3:
              transfer[x + nextstate0 * 64] =
                  (int)(!(rx_bits[l * 2] == 1)) +
                  (int)(!(rx_bits[l * 2 + 1] == 1)) + F[x];
              input[x + nextstate0 * 64] = 0;
              break;
            default:
              transfer[x + nextstate0 * 64] = 100000;
              break;
          }
          if (l < 2154)  //最后六个input为0
            switch (output1) {
              case 0:
                transfer[x + nextstate1 * 64] =
                    (int)(!(rx_bits[l * 2] == 0)) +
                    (int)(!(rx_bits[l * 2 + 1] == 0)) + F[x];
                input[x + nextstate1 * 64] = 1;
                break;
              case 1:
                transfer[x + nextstate1 * 64] =
                    (int)(!(rx_bits[l * 2] == 0)) +
                    (int)(!(rx_bits[l * 2 + 1] == 1)) + F[x];
                input[x + nextstate1 * 64] = 1;
                break;
              case 2:
                transfer[x + nextstate1 * 64] =
                    (int)(!(rx_bits[l * 2] == 1)) +
                    (int)(!(rx_bits[l * 2 + 1] == 0)) + F[x];
                input[x + nextstate1 * 64] = 1;
                break;
              case 3:
                transfer[x + nextstate1 * 64] =
                    (int)(!(rx_bits[l * 2] == 1)) +
                    (int)(!(rx_bits[l * 2 + 1] == 1)) + F[x];
                input[x + nextstate1 * 64] = 1;
                break;
              default:
                transfer[x + nextstate1 * 64] = 100000;
                break;
            }
        }
      }
      memcpy(windows_copy, windows, tblen * 64 * sizeof(int));
      for (x = 0; x < 64; x++) {
        /*partly initialization*/
        q = 10000000;
        b = -1;
        state = -1;
        count_y = 0;
        for (j = 0; j < 2; j++) {
          y[j] = -100;
        }
        for (j = 0; j < 64; j++)  //找到所有指向此状态的上一状态（最多两个）
        {
          if (count_y > 1) break;
          if (transfer[j + x * 64] != 100000) {
            y[count_y] = j;
            count_y++;
          }
        }
        if (count_y == 1) {
          state = y[0];
          q = transfer[state + x * 64];
          b = input[state + x * 64];
        } else if (count_y ==
                   2)  //若有两条可行路径，比较路径度量并选择更小的一条路径
        {
          int a1 = y[0];
          int a2 = y[1];
          int t1 = transfer[a1 + 64 * x];
          int t2 = transfer[a2 + 64 * x];
          if (t1 > t2) {
            q = t2;
            b = input[a2 + 64 * x];
            state = a2;
          } else {
            q = t1;
            b = input[a1 + 64 * x];
            state = a1;
          }
        }
        if (state >= 0)  //将幸存路径保存下来
        {
          if (l == 0) {
            windows[tblen * x] = b;
          } else {
            windows[l + tblen * x] = b;
            memcpy(windows + x * tblen, windows_copy + state * tblen,
                   l * sizeof(int));
          }
        }
        if (q < 10000000)  //更新以x状态为结尾的路径的度量
          F[x] = q;
      }
    }
    for (x = 0; x < 2160; x++) {
      info_bits_hat[x] = (mxLogical)(windows[x]);
    }
  } else if (!puncturing_pattern
                 [2])  // bit rate =
                       // 2/3（除了路径度量的计算其他和1/2码率完全一样）
  {
    for (i = 0; i < 64; i++) {
      for (j = 0; j < tblen; j++) windows[j + i * tblen] = 0;
    }
    memcpy(windows_copy, windows, tblen * 64 * sizeof(int));

    for (i = 1; i < 64; i++) F[i] = -1;
    F[0] = 0;

    for (l = 0; l < 2160; l++) {
      for (i = 0; i < 64; i++) {
        for (j = 0; j < 64; j++) {
          transfer[j + i * 64] = 100000;
          input[j + i * 64] = -1;
        }
      }

      for (x = 0; x < 64; x++) {
        if (F[x] >= 0) {
          nextstate0 = (int)(next[x]);
          nextstate1 = (int)(next[x + 64]);
          output0 = (int)(out[x]);
          output1 = (int)(out[x + 64]);

          switch (output0) {
            case 0:
              if ((l + 1) % 2 ==
                  0)  //偶数个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 0)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - (int)((l + 1) / 2)] == 0)) +
                    (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 0)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              }
              break;
            case 1:
              if ((l + 1) % 2 ==
                  0)  //偶数个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 0)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - (int)((l + 1) / 2)] == 0)) +
                    (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 1)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              }
              break;
            case 2:
              if ((l + 1) % 2 ==
                  0)  //偶数个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 1)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - (int)((l + 1) / 2)] == 1)) +
                    (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 0)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              }
              break;
            case 3:
              if ((l + 1) % 2 ==
                  0)  //偶数个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 1)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - (int)((l + 1) / 2)] == 1)) +
                    (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 1)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              }
              break;
            default:
              transfer[x + nextstate0 * 64] = 100000;
              break;
          }
          if (l < 2154) switch (output1) {
              case 0:
                if ((l + 1) % 2 ==
                    0)  //偶数个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 0)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - (int)((l + 1) / 2)] == 0)) +
                      (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 0)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                }
                break;
              case 1:
                if ((l + 1) % 2 ==
                    0)  //偶数个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 0)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - (int)((l + 1) / 2)] == 0)) +
                      (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 1)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                }
                break;
              case 2:
                if ((l + 1) % 2 ==
                    0)  //偶数个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 1)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - (int)((l + 1) / 2)] == 1)) +
                      (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 0)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                }
                break;
              case 3:
                if ((l + 1) % 2 ==
                    0)  //偶数个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 1)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - (int)((l + 1) / 2)] == 1)) +
                      (int)(!(rx_bits[l * 2 + 1 - (int)((l + 1) / 2)] == 1)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                }
                break;
              default:
                transfer[x + nextstate1 * 64] = 100000;
                break;
            }
        }
      }
      memcpy(windows_copy, windows, tblen * 64 * sizeof(int));
      for (x = 0; x < 64; x++) {
        q = 10000000;
        b = -1;
        state = -1;
        count_y = 0;
        for (j = 0; j < 2; j++) {
          y[j] = -100;
        }
        for (j = 0; j < 64; j++) {
          if (count_y > 1) break;
          if (transfer[j + x * 64] != 100000) {
            y[count_y] = j;
            count_y++;
          }
        }
        if (count_y == 1) {
          state = y[0];
          q = transfer[state + x * 64];
          b = input[state + x * 64];
        } else if (count_y == 2) {
          int a1 = y[0];
          int a2 = y[1];
          int t1 = transfer[a1 + 64 * x];
          int t2 = transfer[a2 + 64 * x];
          if (t1 > t2) {
            q = t2;
            b = input[a2 + 64 * x];
            state = a2;
          } else {
            q = t1;
            b = input[a1 + 64 * x];
            state = a1;
          }
        }
        if (state >= 0) {
          if (l == 0) {
            windows[tblen * x] = b;
          } else {
            windows[l + tblen * x] = b;
            memcpy(windows + x * tblen, windows_copy + state * tblen,
                   l * sizeof(int));
          }
        }
        if (q < 10000000) F[x] = q;
      }
    }
    for (x = 0; x < 2160; x++) {
      info_bits_hat[x] = (mxLogical)(windows[x]);
    }
  } else if (!puncturing_pattern
                 [3])  // bit rate =
                       // 3/4（除了路径度量的计算其他和1/2码率完全一样）
  {
    for (i = 0; i < 64; i++) {
      for (j = 0; j < tblen; j++) windows[j + i * tblen] = 0;
    }
    memcpy(windows_copy, windows, tblen * 64 * sizeof(int));

    for (i = 1; i < 64; i++) F[i] = -1;
    F[0] = 0;

    for (l = 0; l < 2160; l++) {
      for (i = 0; i < 64; i++) {
        for (j = 0; j < 64; j++) {
          transfer[j + i * 64] = 100000;
          input[j + i * 64] = -1;
        }
      }
      //#pragma omp parallel for
      for (x = 0; x < 64; x++) {
        if (F[x] >= 0) {
          nextstate0 = (int)(next[x]);
          nextstate1 = (int)(next[x + 64]);
          output0 = (int)(out[x]);
          output1 = (int)(out[x + 64]);

          switch (output0) {
            case 0:
              if ((l + 1) % 3 ==
                  2)  //每三个bit的第二个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 0)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else if (
                  (l + 1) % 3 ==
                  0)  //每三个bit的第三个bit编码后的对应2bits被删掉了前面一个bit，因此只能用后一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] == 0)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 0)) +
                    (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] == 0)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              }
              break;
            case 1:
              if ((l + 1) % 3 ==
                  2)  //每三个bit的第二个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 0)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else if (
                  (l + 1) % 3 ==
                  0)  //每三个bit的第三个bit编码后的对应2bits被删掉了前面一个bit，因此只能用后一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] == 1)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 0)) +
                    (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] == 1)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              }
              break;
            case 2:
              if ((l + 1) % 3 ==
                  2)  //每三个bit的第二个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 1)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else if (
                  (l + 1) % 3 ==
                  0)  //每三个bit的第三个bit编码后的对应2bits被删掉了前面一个bit，因此只能用后一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] == 0)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 1)) +
                    (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] == 0)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              }
              break;
            case 3:
              if ((l + 1) % 3 ==
                  2)  //每三个bit的第二个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 1)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else if (
                  (l + 1) % 3 ==
                  0)  //每三个bit的第三个bit编码后的对应2bits被删掉了前面一个bit，因此只能用后一个bit计算路径度量
              {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] == 1)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              } else {
                transfer[x + nextstate0 * 64] =
                    (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 1)) +
                    (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] == 1)) +
                    F[x];
                input[x + nextstate0 * 64] = 0;
              }
              break;
            default:
              transfer[x + nextstate0 * 64] = 100000;
              break;
          }
          if (l < 2154) switch (output1) {
              case 0:
                if ((l + 1) % 3 ==
                    2)  //每三个bit的第二个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 0)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else if (
                    (l + 1) % 3 ==
                    0)  //每三个bit的第三个bit编码后的对应2bits被删掉了前面一个bit，因此只能用后一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] ==
                              0)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 0)) +
                      (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] ==
                              0)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                }
                break;
              case 1:
                if ((l + 1) % 3 ==
                    2)  //每三个bit的第二个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 0)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else if (
                    (l + 1) % 3 ==
                    0)  //每三个bit的第三个bit编码后的对应2bits被删掉了前面一个bit，因此只能用后一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] ==
                              1)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 0)) +
                      (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] ==
                              1)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                }
                break;
              case 2:
                if ((l + 1) % 3 ==
                    2)  //每三个bit的第二个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 1)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else if (
                    (l + 1) % 3 ==
                    0)  //每三个bit的第三个bit编码后的对应2bits被删掉了前面一个bit，因此只能用后一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] ==
                              0)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 1)) +
                      (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] ==
                              0)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                }
                break;
              case 3:
                if ((l + 1) % 3 ==
                    2)  //每三个bit的第二个bit编码后的对应2bits被删掉了后面一个bit，因此只能用前一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 1)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else if (
                    (l + 1) % 3 ==
                    0)  //每三个bit的第三个bit编码后的对应2bits被删掉了前面一个bit，因此只能用后一个bit计算路径度量
                {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] ==
                              1)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                } else {
                  transfer[x + nextstate1 * 64] =
                      (int)(!(rx_bits[l * 2 - 2 * (int)((l + 1) / 3)] == 1)) +
                      (int)(!(rx_bits[l * 2 + 1 - 2 * (int)((l + 1) / 3)] ==
                              1)) +
                      F[x];
                  input[x + nextstate1 * 64] = 1;
                }
                break;
              default:
                transfer[x + nextstate1 * 64] = 100000;
                break;
            }
        }
      }
      memcpy(windows_copy, windows, tblen * 64 * sizeof(int));
      for (x = 0; x < 64; x++) {
        q = 10000000;
        b = -1;
        state = -1;
        count_y = 0;
        for (j = 0; j < 2; j++) {
          y[j] = -100;
        }
        for (j = 0; j < 64; j++) {
          if (count_y > 1) break;
          if (transfer[j + x * 64] != 100000) {
            y[count_y] = j;
            count_y++;
          }
        }
        if (count_y == 1) {
          state = y[0];
          q = transfer[state + x * 64];
          b = input[state + x * 64];
        } else if (count_y == 2) {
          int a1 = y[0];
          int a2 = y[1];
          int t1 = transfer[a1 + 64 * x];
          int t2 = transfer[a2 + 64 * x];
          if (t1 > t2) {
            q = t2;
            b = input[a2 + 64 * x];
            state = a2;
          } else {
            q = t1;
            b = input[a1 + 64 * x];
            state = a1;
          }
        }
        if (state >= 0) {
          if (l == 0) {
            windows[tblen * x] = b;
          } else {
            windows[l + tblen * x] = b;
            memcpy(windows + x * tblen, windows_copy + state * tblen,
                   l * sizeof(int));
          }
        }
        if (q < 10000000) F[x] = q;
      }
    }
    //#pragma omp parallel for
    for (x = 0; x < 2160; x++) {
      info_bits_hat[x] = (mxLogical)(windows[x]);
    }
  }

  /*free the memory*/
  mxFree(windows);
  mxFree(windows_copy);
  mxFree(F);
  mxFree(transfer);
  mxFree(input);
  mxFree(y);
  return;
}
