#!/bin/sh
# mknewlib.sh NEWLIB-SRC BUILD -- newlib 4.4 for CMS (31-bit, soft float,
# no syscalls: cmsrt provides them).  BUILD/libc.a, BUILD/libm.a.
set -e
SRC=$(cd "$1" && pwd); mkdir -p "$2"; cd "$2"
GI=$(s390x-linux-gnu-gcc -print-file-name=include)
CC="s390x-linux-gnu-gcc -nostdinc -isystem $GI" \
CFLAGS="-O2 -m31 -mesa -march=z900 -msoft-float -mlong-double-64 -fno-pic -fno-pie \
 -fno-asynchronous-unwind-tables -fno-unwind-tables -fno-stack-protector -ffreestanding \
 -ffunction-sections -fdata-sections" \
$SRC/newlib/configure --host=s390-unknown-none --target=s390-unknown-none --disable-multilib \
  --disable-newlib-supplied-syscalls --disable-newlib-multithread --enable-newlib-io-float \
  --enable-newlib-io-c99-formats --enable-newlib-io-long-long --disable-newlib-io-long-double \
  --enable-newlib-nano-malloc --disable-newlib-wide-orient --disable-newlib-fvwrite-in-streamio \
  --disable-newlib-atexit-dynamic-alloc >/dev/null
make -j8 >/dev/null
ls -l libc.a libm.a
