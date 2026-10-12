# C and C++ for VM/370plus: CMS and Linux/390

GCC 13.3 and GNU binutils 2.42 for [VM/370plus](https://github.com/mikebeer/vm370plus),
the 31-bit ESA/390 VM/370:

* **On CMS, natively.** `cc1`, `cc1plus`, `as`, `ld` and `ar` run on CMS
  itself, together with newlib, a CMS runtime (`cmsrt`) and libstdc++ 13.3.
  `CC fn` compiles `fn C` (or `fn CPP`) to `fn MODULE`.
* **For CMS, from the PC.** `runtime/cmscc` and `runtime/cmsc++` cross-compile
  C and C++ to CMS TEXT decks or to XIMAGEs for programs above 16 MB. This is
  how the native compilers, and every other language on the VM/370plus
  language disk (Python, SQLite, COBOL, PL/I and others), are built.
* **For Linux/390 (the Debian 7 guest).** `linux/wcc` is GCC 13 `-m31`
  against Debian wheezy's glibc 2.13, so its programs run on the guest
  unchanged. The guest also has its own gcc 4.6.

## Using it on CMS

The compilers are on the VM/370plus language disk (MAINT 19F, volume
VMLANG, kit b8 onward).

```
IPL 290                      EC-mode CMS
CP DEFINE STORAGE 256M
LANG                         link and access the language disk as L
CC HELLO                     HELLO C   -> HELLO MODULE
CC SHAPES CPP                SHAPES CPP -> SHAPES MODULE (C++17)
HELLO
```

| CC EXEC option | Effect |
|---|---|
| `OPT -O0` … `-O2` | optimization (default `-O2`) |
| `CPP` | C++ for any file type |
| `NOLINK` | stop after `fn O` |
| `LIB name` | also link `/usr/lib/libname.a` from SYSROOT TAR |

The CMS files are listed in [docs/CMS-TOOLCHAIN.md](docs/CMS-TOOLCHAIN.md).
`CC1 XIMAGE` and `CC1PLUS XIMAGE` run from above 16 MB under the XL loader.
Headers and libraries come from `SYSROOT TAR` and `CXXROOT TAR`, which
programs see as a read-only `/usr`.

Programs are ASCII inside and EBCDIC (IBM-1047) at the CMS boundary:
- terminal I/O and text files are converted;
- binary file types (`O`, `TEXT`, `TAR`, `DB`, …) are not;
- the runtime's file-name rules are in [docs/RUNTIME.md](docs/RUNTIME.md).

Not yet supported: C++ exceptions (a `throw` ends the program), threads, and
locales other than "C".

## Cross-compiling for CMS on the PC

Needs Ubuntu 24.04's `gcc-13-s390x-linux-gnu`, `g++-13-s390x-linux-gnu` and
`binutils-s390x-linux-gnu`.

```
build/mknewlib.sh newlib-4.4.0.20231231 nlbuild         # NEWLIB=nlbuild
build/mksoftfp.sh                                       # runtime/softfp/libsoftfp.a
gcc -O2 -o e2c elf_to_cms.c                             # with elf_to_cms/*.patch
NEWLIB=$PWD/nlbuild NLSRC=$PWD/newlib-4.4.0.20231231/newlib E2C=$PWD/e2c \
  runtime/crt.sh hello.text tests/hello31.c             # TEXT deck: LOAD, GENMOD
runtime/cmscc -O2 -o prog.elf prog.c                    # ELF; then e2c prog.elf prog.text
CMSCC_XL=1 runtime/cmscc -O2 -o big.elf big.c           # above 16 MB:
python3 runtime/mkximage.py big.elf big.ximage          #   XL BIG on CMS
```

**Don't install `gcc-multilib`.** On Ubuntu it removes the s390x cross
compiler.

## Building the native CMS compilers

```
build/mkgmp.sh gmp-6.3.0 WORK/gmp-cms
build/mktoolchain.sh WORK OUT    # also runs mklibstdcxx.sh and mkcxxroot.sh
```

`WORK` needs:
- `binutils-2.42/` and `gcc-13.3.0/` (Ubuntu `binutils-source`, `gcc-13-source`);
- `mpfr-4.2.1/` and `mpc-1.3.1/`;
- `elf_to_cms.c`, with the two patches applied.

`OUT` receives `cc1.ximage`, `cc1plus.ximage`, `as.text`, `ld.text`,
`ar.text`, `elf2cms.ximage`, `xl.text`, `sysroot.tar` and `cxxroot.tar`.
These go onto a CMS EDF disk:
1. TEXT decks: `LOAD x (CLEAR NOMAP`, then `GENMOD x`.
2. XIMAGEs and tar files: as they are, binary F 80.

## Linux/390

```
linux/mkwheezy.sh DEBS wsys     # libc6, libc6-dev, linux-libc-dev of wheezy (s390)
WHEEZY=$PWD/wsys linux/wcc -O2 -o prog prog.c
```

## Layout

| Directory | Contents |
|---|---|
| `cms/` | CC EXEC (the driver on CMS), LANG EXEC |
| `runtime/` | cmsrt (the CMS C runtime), entry code, linker scripts, XL loader, cmscc/cmsc++, cxxrt (C++ support), soft float |
| `build/` | newlib, soft-fp, GMP, libstdc++, the native toolchain and the C++ root |
| `elf_to_cms/` | patches to Adrian Sutherland's ELF-to-CMS exporter (mainframe-lab `tools/elf_to_cms.c`) |
| `linux/` | wcc and the wheezy sysroot |
| `tests/` | hello31.c, libctest.c, cpptest.cpp, iostest.cpp |
| `docs/` | CMS toolchain and runtime notes |

## Binaries and sources

`bin/cms-gcc13-1.tar.gz` contains the CMS files built by `mktoolchain.sh`.
`sources/` holds the exact sources of the GNU and library parts in them:
GCC 13.3.0 (in two parts), binutils 2.42, newlib 4.4.0, GMP 6.3.0, MPFR
4.2.1 and MPC 1.3.1, each with its checksum. Those parts are under their own
licences:
- GCC, libgcc and libstdc++: GPL v3 with the GCC Runtime Library Exception;
- binutils: GPL v3;
- GMP, MPFR and MPC: LGPL;
- newlib: BSD-style licences.

The ELF-to-CMS exporter is Adrian Sutherland's (mainframe-lab
`tools/elf_to_cms.c`); this repository carries only the two patches to it.
