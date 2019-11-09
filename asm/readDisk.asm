readDisk:
    pusha
    mov ah, 0x02            ; command to read from disk
    mov dl, 0x80            ; set the drive to read from, qemu uses 0x80 for floppy? (or something like that)
    mov ch, 0               ; cylinder
    mov dh, 0               ; header
    ; mov al, 1               ; sector to read
    ; mov cl, 2               ; starting sector
                            ; address pointer, where to store the disk information
                            ; es:bx
    push bx
    mov bx, 0
    mov es, bx              ; segment register --> you can not set es directly to 0
    pop bx
    mov bx, 0x7c00 + 512    ; store one above our bootloader

    int 0x13                ; interrupt for disk read

    jc disk_err
    popa
    ret

    disk_err:
        mov si, DISK_ERR_MSG
        call printf
        jmp $


DISK_ERR_MSG: db "Error Loading Disk.", 0x0a, 0x0d,0