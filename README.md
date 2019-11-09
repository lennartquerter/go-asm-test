## Setup
Write your assembly code in main.asm.

## nasm
Install nasm:

`brew update && brew install nasm` 

## Qemu

Install qemu:

`brew update && brew install qemu` 

## Compile

`nasm -fbin -o bin/main.bin asm/boot.asm`

(or run go code)

## run code

`qemu-system-x86_64 bin/main.bin  -nographic`