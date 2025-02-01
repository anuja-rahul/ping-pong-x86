ORG 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov al, 0x13 ; 320x200 256 color mode
    int 0x10

    call JumpToSectorTwo

    jmp $

PrepSectorTwo:
    mov ah, 0x02    ; BIOS read sector
    mov al, 6       ; No of sectors
    mov ch, 0       ; Cylinder number
    mov dh, 0       ; Head number
    mov cl, 2       ; Sector number
    mov bx, 0x7E00  ; load address
    int 0x13
    ret

JumpToSectorTwo:
    call PrepSectorTwo
    jmp 0x7E00
    ret



times 510-($-$$) db 0

dw 0xAA55