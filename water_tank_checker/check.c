#include <stdio.h>
#include <math.h>

#define PRECISION     ( 1000 )

int main(int argc, char *argv[])
{
  FILE *in1, *in2;
  double d1, d2, e;
  int ret1, ret2, ac, line;

  if (argc != 3)
  {
    fprintf(stderr, "usage: %s <file1> <file2>\n", argv[0]);
    return 0;
  }


  in1 = fopen(argv[1], "r");
  in2 = fopen(argv[2], "r");

  for (ac = line = 1; ; line++)
  {
    ret1 = fscanf(in1, "%lf", &d1);
    ret2 = fscanf(in2, "%lf", &d2);
    if (ret1 == EOF || ret2 == EOF)
    {
      if (ret1 != ret2)
      {
        printf("different number of lines.\n");
        ac = 0;
      }
      break;
    }
    e = (int)(fabs(d1 - d2) * PRECISION);
    if (1 <= e)
    {
      printf("mismatch at line %d.\n", line);
      ac = 0;
    }
  }

  fclose(in1);
  fclose(in2);

  printf("\x1B[%s\x1B[39m\n", ac ? "32mAC" : "31mWA");
  return 0;
}
