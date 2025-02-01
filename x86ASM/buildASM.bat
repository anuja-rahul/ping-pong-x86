@echo off

nasm -f bin %1.asm -o %1.bin
nasm -f bin %2.asm -o %2.bin
type %1.bin %2.bin > pong.bin
qemu-system-x86_64 -fda pong.bin