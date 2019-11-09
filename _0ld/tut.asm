global start

; RAX	EAX	AX	AH	AL	Accumulator
; RBX	EBX	BX	BH	BL	Base
; RCX	ECX	CX	CH	CL	Counter
; RDX	EDX	DX	DH	DL	Data (commonly extends the A register)

section .text

; start the function by jumping directly to the sum label
start:
    ; move 13 to register rax
    mov rax, 13
    ; stack --> reserved registers
    ; localizes ax
    ; seems like we can bring this value into our system without really changing the value of the register
    ; like we could mov 10 into RAX, then push RAX, mov other values into RAX, change values and do stuff,when we pop RAX, RAX will be 10 again
    push ax
    ; move
    mov ax, 0xa4
    ; do something
    pop ax

    push bx
    ; do stuff
    push ax
    ; do more stuff
    ; first we have to pop as, before we can pop bx
    pop ax
    pop bx

    mov     rax, 0x2000001 ; exit
    mov     rdi, 0
    syscall


; syscall or bios interrupt
; function that the bios can execute

; 0x0e // causes the cursor to move in bios
; 0x10 // prints to the screen ! (hoera)


; boot sector

; should be 512 bytes
; times 510-($-$$) db 0
; always has a magic number at the end to tell the computer to run it as a boot sector --> load into kernel
; dw 0xaa55

; $ - current location in the boot sector
; $$ - start location in the boot sector
; 510-($-$$) is the total values still left


