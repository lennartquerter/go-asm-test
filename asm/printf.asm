printf:
    pusha
    str_loop:
        mov al, [si]            ; brackets denote the memory location (starts with H)
        cmp al, 0
        jne print_char
        popa
        ret

    print_char:
        mov ah, 0x0e
        int 0x10
        add si, 1           ; we add a value to si (memory location), so we increase one memLoc to continue with next char (e)
        jmp str_loop
