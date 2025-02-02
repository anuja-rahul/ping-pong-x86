org 0x7E00

Colors.Black equ 0x0          ;Black
Colors.Blue equ 0x1           ;Blue
Colors.Green equ 0x2          ;Green
Colors.Cyan equ 0x3           ;Cyan
Colors.Red equ 0x4            ;Red
Colors.Magenta equ 0x5        ;Magenta
Colors.Brown equ 0x6          ;Brown
Colors.LightGrey equ 0x7      ;LightGrey
Colors.Grey equ 0x8           ;Grey
Colors.LightBlue equ 0x9      ;LightBlue
Colors.LightGreen equ 0xA     ;LightGreen
Colors.LightCyan equ 0xB      ;LightCyan
Colors.LightRed equ 0xC       ;LightRed
Colors.LightMagenta equ 0xD   ;LightMagenta
Colors.Yellow equ 0xE         ;Yellow
Colors.White equ 0xF          ;White

PIT_COMMAND equ 0x43
PIT_CHANNEL_0 equ 0x40
PIT_FREQUENCY equ 1193180
DESIRED_FREQ equ 60

DIVISOR equ PIT_FREQUENCY / DESIRED_FREQ

start:

    call Timer_Setup
    call SetupKeyboardInterrupt

    jmp $

SetupKeyboardInterrupt:
    cli
    mov word [0x0024], keyboard_handler
    mov [es:0x0026], cs
    sti
    ret

key_prep:
    xor bx, bx
    mov bl, al
    mov al, [scan_code_table + bx]
    mov [keyval], al
    ret

keyboard_handler:
    in al, 0x60
    test al, 0x80
    jz .Key_Down

    ; key up
    and al, 0x7F
    call key_prep
    call Key_Up

    jmp .done


.Key_Down:
    call key_prep
    call Key_Down
.done:
    mov al, 0x20
    out 0x20, al
    iret

Key_Up:
;     cmp byte [keyval], 's'
;     je .s_press

;     cmp byte [keyval], 'w'
;     je .w_press
;     jmp .done

; .w_press:
    ; mov byte [w_down], 0
;     jmp .done
; .s_press:
    ; mov byte [s_down], 0
    ; jmp .done
; .done:
    ; ret

    ; call write_char

    cmp byte [keyval], 's'
    je .s_press

    cmp byte [keyval], 'w'
    je .w_press

    cmp byte [keyval], 'i'
    je .i_press

    cmp byte [keyval], 'k'
    je .k_press

    jmp .done

.w_press:
    mov byte [w_down], 0
    jmp .done
.s_press:
    mov byte [s_down], 0
    jmp .done
.i_press:
    mov byte [i_down], 0
    jmp .done
.k_press:
    mov byte [k_down], 0
    jmp .done
.done:
    ret

Key_Down:
    ; call write_char

    cmp byte [keyval], 's'
    je .s_press

    cmp byte [keyval], 'w'
    je .w_press

    cmp byte [keyval], 'i'
    je .i_press

    cmp byte [keyval], 'k'
    je .k_press

    jmp .done

.w_press:
    mov byte [w_down], 'w'
    jmp .done
.s_press:
    mov byte [s_down], 's'
    jmp .done
.i_press:
    mov byte [i_down], 'i'
    jmp .done
.k_press:
    mov byte [k_down], 'k'
    jmp .done
.done:
    ret

move_box_down:
    cmp dword [left_y_paddle], 120
    jge .done
    mov eax, [left_y_paddle]
    add eax, 3
    mov [left_y_paddle], eax
.done:
    ret

move_box_up:
    cmp dword [left_y_paddle], 0
    jle .done
    mov eax, [left_y_paddle]
    sub eax, 3
    mov [left_y_paddle], eax
.done:
    ret

move_right_box_down:
    cmp dword [right_y_paddle], 120
    jge .done
    mov eax, [right_y_paddle]
    add eax, 3
    mov [right_y_paddle], eax
.done:
    ret

move_right_box_up:
    cmp dword [right_y_paddle], 0
    jle .done
    mov eax, [right_y_paddle]
    sub eax, 3
    mov [right_y_paddle], eax
.done:
    ret

; write_char:
;     mov ah, 0x0E
;     mov bl, Colors.LightBlue
;     int 0x10
;     ret

; fill_pixel:
;     mov byte [edi], Colors.LightRed
;     inc edi
;     ret

draw_box:
    mov edi, DRAW_START
    mov eax, [sq_y]
    cmp eax, 0
    jge .proceed
    mov eax, 0
.proceed:
    mov ebx, 320
    mul ebx
    add eax, edi
    mov edi, eax
    add edi, [sq_x]
    xor ecx, ecx
    jmp .put_pixel

.move_down:
    add edi, 320
    sub edi, [sq_width]
    xor ecx, ecx


.put_pixel:
    mov al, [colorDraw]
    cmp edi, DRAW_START
    jl .continue
    mov byte [edi], al
.continue:
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

    call ball_move_x
    call ball_move_y

    cmp byte [s_down], 's'
    jne .check
    call move_box_down
.check:
    cmp byte [w_down], 'w'
    jne .skip_next
    call move_box_up
.skip_next:
    cmp byte [i_down], 'i'
    jne .check_right
    call move_right_box_up ; possibly fked up
.check_right:
    cmp byte [k_down], 'k'
    jne .skip
    call move_right_box_down ; possibly fked up again !

.skip:
    call clear_screen

    call draw_paddles
    call draw_ball
    call is_right_paddle_collision
    call is_left_paddle_collision
    ret

draw_paddles:
    mov al, Colors.Green
    mov [colorDraw], al

    mov eax, 20
    mov [sq_x], eax
    mov eax, [left_y_paddle]
    mov [sq_y], eax

    mov eax, 10
    mov [sq_width], eax
    mov eax, 80
    mov [sq_height], eax

    call draw_box

    mov eax, 290
    mov [sq_x], eax
    mov eax, [right_y_paddle]
    mov [sq_y], eax

    call draw_box
    ret


clear_screen:
    mov al, Colors.Black
    mov [colorDraw], al

    mov eax, 0
    mov [sq_x], eax
    mov eax, 0
    mov [sq_y], eax

    mov eax, SCREEN_WIDTH
    mov [sq_width], eax
    mov eax, SCREEN_HEIGHT
    mov [sq_height], eax

    call draw_box
    ret

draw_ball:
    mov al, Colors.Green
    mov [colorDraw], al

    mov eax, [ball_x]
    mov [sq_x], eax
    mov eax, [ball_y]
    mov [sq_y], eax

    mov eax, 10
    mov [sq_width], eax
    mov eax, 10
    mov [sq_height], eax

    call draw_box
    ret

reset_ball:
    mov dword [ball_x], 160
    mov dword [ball_y], 90

    ret

switch_direct_to_zero:
    mov al, 0
    mov [ball_direction], al

    ret

switch_direct_to_one:
    mov al, 1
    mov [ball_direction], al

    ret

is_left_paddle_collision:
    cmp dword [ball_x], 30
    jg .done

    call check_left_paddle
.done:
    ret

is_right_paddle_collision:
    cmp dword [ball_x], 280
    jl .done

    call check_right_paddle
.done:
    ret

check_left_paddle:
    mov eax, [left_y_paddle]
    cmp eax, [ball_y]
    jg .done

    add eax, 80

    cmp eax, [ball_y]
    jl .done

    call switch_direct_to_zero
.done:
    ret

check_right_paddle:
    mov eax, [right_y_paddle]
    cmp eax, [ball_y]
    jg .done

    add eax, 80

    cmp eax, [ball_y]
    jl .done

    call switch_direct_to_one
.done:
    ret

ball_move_x:

    cmp dword [ball_x], 310
    jge .switch_dir_zero
    cmp dword [ball_x], 0
    jle .switch_dir_one
    jmp .update_pos

.switch_dir_zero:
    call reset_ball
    ; mov al, 1
    ; mov [ball_direction], al
    jmp .update_pos

.switch_dir_one:
    call reset_ball
    ; mov al, 0
    ; mov [ball_direction], al

.update_pos:
    mov eax, [ball_x]
    mov ebx, 2
    cmp byte [ball_direction], 0
    je .add
    sub eax, ebx
    mov [ball_x], eax
    jmp .done
.add:
    add eax, ebx
    mov [ball_x], eax
.done:
    ret

ball_move_y:

    cmp dword [ball_y], 190
    jge .switch_dir_zero
    cmp dword [ball_y], 0
    jle .switch_dir_one
    jmp .update_pos

.switch_dir_zero:
    mov al, 1
    mov [ball_updown], al
    jmp .update_pos

.switch_dir_one:
    mov al, 0
    mov [ball_updown], al

.update_pos:
    mov eax, [ball_y]
    mov ebx, 2
    cmp byte [ball_updown], 0
    je .add
    sub eax, ebx
    mov [ball_y], eax
    jmp .done
.add:
    add eax, ebx
    mov [ball_y], eax
.done:
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

scan_code_table:
    db 0, 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0, 0
    db 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 0, 0
    db 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", '`', 0, '\'
    db 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' '


begin_draw dd 0

w_down dd 0
s_down dd 0

i_down dd 0
k_down dd 0

keyval db 0

colorDraw db 0

sq_x dd 10

sq_y dd 50

sq_width dd 40

sq_height dd 70

;; user drawing

left_y_paddle dd 60
right_y_paddle dd 60

ball_x dd 160
ball_y dd 90
ball_direction db 0
spacer dd 0

ball_updown db 0

;;;;;;;;;;;;;;;

DRAW_START equ 0xA0000 ; VGA memory

SCREEN_HEIGHT equ 200

SCREEN_WIDTH equ 320