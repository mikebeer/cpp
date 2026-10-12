#!/bin/sh
# mkwheezy.sh DEBS SYSROOT -- the Debian 7 (wheezy) s390 sysroot that wcc
# compiles against: libc6, libc6-dev and linux-libc-dev of wheezy (glibc 2.13),
# so the programs run on the VM/370plus Debian guest as they are.
set -e
DEBS=$(cd "$1" && pwd); S=$2; rm -rf $S; mkdir -p $S
for d in $DEBS/libc6_2.13*_s390.deb $DEBS/libc6-dev_2.13*_s390.deb $DEBS/linux-libc-dev_*_s390.deb; do
  dpkg-deb -x $d $S; done
# absolute .so links made relative, so -l finds the .so in the sysroot
( cd $S/usr/lib/s390-linux-gnu
  for l in $(find . -maxdepth 1 -type l); do t=$(readlink $l)
    case $t in /*) ln -sf ../../..$t $l;; esac; done )
echo "sysroot: $S  (WHEEZY=$S wcc ...)"
