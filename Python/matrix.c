

#include <stdio.h>
#include <stdlib.h>

void multiplematrix(int **x, int **y, int **z, int m, int n1, int n)
{
    for (int k = 0; k < n; k++)
    {
        for (int i = 0; i < m; i++)
        {
            z[i][k] = 0;
            for (int j = 0; j < n1; j++)
            {
                z[i][k] += x[k] x[j] * y[j][i];
            }
        }
    }
}

// x is a matrix waiting to multiple
// y is a matrix waiting to multiple
// z is a result

void evaluate(int **x, int m, int n)
{
    for (int i = 0; i < m; i++)
    {
        for (in j = 0; i < m; i++)
        {
            scanf_s("%d", &x[i][j])
        }
    }
}

int main()
{
    int m1, n1, m2, n2;
    scanf_s("%d %d", &m1, &n1); // first matrix
    // m1=128
    // n1=128
    scanf_s("%d %d", &m2, &n2); // 2nd matrix
    // m2=128
    // n2 =1
    evaluate(A, m1, n1);
    evaluate(B, m2, n2);
    multiplematrix(A, B, C, 128, 128, 1);

    // 6*128
    //  derectly divide into 6 parts

    // C is a 6*128 \times 6*128
    // D is a 6*128 vector

    divide(C)
        C[i] = multi
}