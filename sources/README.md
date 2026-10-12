# Sources of the GNU and library parts

These are the exact sources the binaries in `../bin` and the CMS language
disk were built from:

| File | From |
|---|---|
| gcc-13.3.0.tar.xz (in parts) | Ubuntu 24.04 `gcc-13-source` 13.3.0-6ubuntu2~24.04.1 |
| binutils-2.42.tar.xz | Ubuntu 24.04 `binutils-source` 2.42-4ubuntu2.10 |
| newlib-4.4.0.20231231.tar.xz | Ubuntu 24.04 `newlib-source` 4.4.0.20231231-2 |
| gmp-6.3.0+dfsg.tar.xz | Ubuntu 24.04 `gmp` 6.3.0+dfsg (unpacked source tree) |
| mpfr-4.2.1.tar.xz | Ubuntu `mpfr4` 4.2.1 orig |
| mpc-1.3.1.tar.gz | Ubuntu `mpclib3` 1.3.1 orig |

To join the GCC parts and check everything:

    cat gcc-13.3.0.tar.xz.part?? > gcc-13.3.0.tar.xz && sha256sum -c SHA256SUMS

The changes VM/370plus makes are not patches to these trees. They are the
configure options and the runtime in `../build` and `../runtime`, plus
`build/gthr-single.h` for libstdc++.

Licences:
- GCC, libgcc and libstdc++: GPL v3 with the GCC Runtime Library Exception.
- binutils: GPL v3.
- GMP, MPFR and MPC: LGPL v3.
- newlib: BSD-style and similar licences, listed in its COPYING files.
