ORG 0x7C00

PIT_COMMAND equ 0x43

PIT_CHANNEL_0 equ 0x40

PIT_FREQUENCY equ 1193180

DESIRED_FREQ equ 60

DIVISOR equ PIT_FREQUENCY / DESIRED_FREQ

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov al, 0x13 ; 320x200 256 color mode
    int 0x10

    mov edi, (DRAW_START + 5000)
    call Timer_Setup

    jmp $


draw_pixel:
    mov byte [edi], COLOR_RED
    inc edi
    ret

draw_box:
    mov edi, DRAW_START
    mov eax, [sq_y]
    mov ebx, 320
    mul ebx
    add eax, edi
    mov edi, eax
    add edi, [sq_x]


    jmp .put_pixel

.move_down:
    add edi, 320
    sub edi, [sq_width]
    xor ecx, ecx


.put_pixel:
    mov byte [edi], COLOR_RED
    inc edi
    inc ecx
    cmp ecx, [sq_width]
    jl .put_pixel

    inc edx
    cmp edx, [sq_height]
    jl .move_down

.done:
    ret

Timer_Event:
    call draw_pixel
    ret

timer_interrupt:
    call Timer_Event
    mov al, 0x20
    out 0x20, al
    iret

Timer_Setup:
    cli
    mov al, 00110100b ; Channel 0, lobyte/hibyte, rate generator
    out PIT_COMMAND, al
    ; Set divisor
    mov ax, DIVISOR
    out PIT_CHANNEL_0, al ; low byte
    ; mov al, ah
    out PIT_CHANNEL_0, al ; high byte
    ; Set up the timer ISR
    mov word [0x0020], timer_interrupt
    mov word [0x0022], 0x0000 ; Enable interrupts

    sti
    ret


begin_draw dd 0

sq_x dd 100

sq_y dd 50

sq_width dd 40

sq_height dd 70

DRAW_START equ 0xA0000 ; VGA memory

COLOR_RED equ 0x04

times 510-($-$$) db 0

dw 0xAA55