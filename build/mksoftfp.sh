#!/bin/sh
# mksoftfp.sh -- runtime/softfp/libsoftfp.a: GCC's soft-fp routines for
# 31-bit S/390 without hardware floating point in the program's code.
set -e
cd "$(dirname "$0")/../runtime/softfp"
for f in *.c; do
  s390x-linux-gnu-gcc -m31 -mesa -march=z900 -msoft-float -O2 -fno-pic -fno-pie -fno-stack-protector \
    -fno-asynchronous-unwind-tables -I. -c $f -o ${f%.c}.o
done
rm -f libsoftfp.a; s390x-linux-gnu-ar rcs libsoftfp.a *.o; rm -f *.o
ls -l libsoftfp.a
