#!/bin/sh
# mkgmp.sh GMP-SRC PREFIX -- GMP 6.3 for the CMS host (generic C, 32-bit
# limbs), which GCC's cc1/cc1plus need (with MPFR and MPC, mktoolchain.sh).
set -e
H=$(cd "$(dirname "$0")" && pwd); SRC=$(cd "$1" && pwd); P=$2
B=$(mktemp -d); cd $B
$SRC/configure --host=s390-ibm-linux --build=x86_64-linux-gnu --prefix=$P \
  --disable-shared --disable-assembly ABI=32 CC=$H/../runtime/cmscc CFLAGS=-O2 >/dev/null
make -j8 >/dev/null; make install >/dev/null; rm -rf $B
ls -l $P/lib/libgmp.a
