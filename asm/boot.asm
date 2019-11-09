[org 0x7c00]
[bits 16]

section .data           ; does not work with bootloader, puts this section behind the magic number
section .bss            ; mutable variables / vars
section .text           ; code! hoera

    global main

main:
    cli                 ; gets rid of interrupts
    jmp 0x0000:ZeroSeg  ; insures the bios is not doing segmenting after load

    ZeroSeg:
        xor ax, ax          ; set ax to 0 by using xor --> xor is only 1 byte code compared to mov ax, 0
        mov ss, ax
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov sp, main
        cld                 ; clear direction flag = 0 (controls the order of strings (from left to right), some bios have default value of 1
    sti                     ; enables interrupts

    ; reset the disk
    push ax
    xor ax, ax
    int 0x13
    pop ax

    ; print welcome message
    mov si, OS_WELCOME_MSG
    call printf

    ; changing the sector we want to read
    mov al, 1 ; # sector to read
    mov cl, 2 ; # sector start
    ; read the second sector into memory
    call readDisk

    ; print loaded message
    mov si, OS_START_MSG
    call printf

    call sector_2

    jmp $

%include './asm/printf.asm'
%include './asm/readDisk.asm'

; 0x0a carriage return, 0x0d reset x space
OS_WELCOME_MSG: db "Os is starting!", 0x0a, 0x0d, 0
OS_START_MSG: db "Os has loaded!", 0x0a, 0x0d, 0

; padding and magic number
times 510-($-$$) db 0
dw 0xaa55

; Here starts sector 2
sector_2:
    mov si, TEST_STR
    call printf
    ret

TEST_STR: db "You are in a second sector", 0x0a, 0x0d, 0
times 512 db 0