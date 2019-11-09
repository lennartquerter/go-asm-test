global start

; Create variables to play with
section .data
    x:      equ     100
    y:      equ     50
    total:  equ     50

    correct_label:      db      "correct!", 10
    .len:               equ     $ - correct_label

    wrong_label:        db      "its wrong!", 10
    .len:               equ     $ - wrong_label

section .text

; start the function by jumping directly to the sum label
start:
    jmp .sum

; sum function where we move x to the RAX register and y into the RBX register
.sum:
    mov     rax, x
    mov     rbx, y

    ; add rax to rbx, the result is stored in rax
    add     rax, rbx

    ; compare rax to the total
    cmp     rax, total
    ; if not equal jump to label wrong reguls
    jne     .wrong
    ; else call the right result
    call     right
    jmp     .exit

.wrong:
    call wrong
    jmp .exit

.exit:
      mov     rax, 0x2000001 ; exit
      mov     rdi, 0
      syscall

; print out wrong label
wrong:
    mov     rsi, wrong_label
    mov     rdx, wrong_label.len
    call    print
    ret

; print out the correct label
right:
    mov     rsi, correct_label
    mov     rdx, correct_label.len
    call    print
    ret

; print function
print:
    mov     rax, 0x2000004      ; write
    mov     rdi, 1              ; stdout
    syscall
    ret