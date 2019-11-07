global start

section .text

start:
    jmp .sum

.sum:
    mov     rax, x
    mov     rbx, y

    add     rax, rbx

    cmp     rax, total
    jne     .wrong
    jmp     .right

.right:
    mov     rax, 0x2000004      ; write
    mov     rdi, 1              ; stdout
    mov     rsi, correct
    mov     rdx, correct.len
    syscall
    jmp     .exit

.wrong:
    mov     rax, 0x2000004      ; write
    mov     rdi, 1              ; stdout
    mov     rsi, wrong
    mov     rdx, wrong.len
    syscall
    jmp     .exit

.exit:
      mov     rax, 0x2000001 ; exit
      mov     rdi, 0
      syscall


section .data
    x:      equ     100
    y:      equ     50
    total:  equ     150

    correct:    db      "correct!", 10
    .len:       equ     $ - correct

    wrong:      db      "its wrong!", 10
    .len:       equ     $ - wrong
