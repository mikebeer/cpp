# Prebuilt CMS files

`cms-gcc13-1.tar.gz` contains what `build/mktoolchain.sh` makes:
- CC1 and CC1PLUS XIMAGE;
- AS, LD, AR and XL TEXT;
- ELF2CMS XIMAGE;
- SYSROOT and CXXROOT TAR;
- the CC and LANG EXECs.

`FILES.txt` inside says how to put them on a CMS disk. The VM/370plus
language disk (MAINT 19F, kit b8) already carries them.

The sources of the GNU and library parts are in `../sources/`.
