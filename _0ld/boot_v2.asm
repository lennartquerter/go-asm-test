[org 0x7c00]

mov si, STR
call printf

jmp $

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
        add si, 1               ; we add a value to si (memory location), so we increase one memLoc to continue with next char (e)
        jmp str_loop


readDisk:
    pusha
    mov ad, 0x02
    mov dl, 0x80
    mov ch, 0 ; cylinder
    mov dh, 0 ; header
    mov al, 1 ; sector to read
    mov cl, 2 ; 1 -- boot loader, 2 -- next ???
    ; address pointer, where to store the disk information
    ; es:bx
    push bx
    mov bx, 0
    mov es, bx
    pop bx
    mov bx, 0x7c00 + 512 ; store one above our bootloader

    jc disk_err
    popa
    ret

    disk_err:



STR: db "Hello World", 0

; padding and magic number
times 510-($-$$) db 0
dw 0xaa55