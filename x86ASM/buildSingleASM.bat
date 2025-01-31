@echo off

nasm -f bin %1.asm -o %1.bin
qemu-system-x86_64 -fda %1.bin