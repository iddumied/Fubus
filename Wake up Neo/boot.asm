[bits 16]
[org 0x7c00]

mov ax, 0x0000
mov ds, ax
start:
mov si, wakeup_str
call print_str

mov cx, 0x0098   ; sleep 10s
mov dx, 0x9680
call sleep

call clear_line
mov si, matrix_str
call print_str

mov cx, 0x001e   ; sleep 2s
mov dx, 0x8480
call sleep

call clear_line
mov si, rabit_str
call print_str

mov cx, 0x001e   ; sleep 2s
mov dx, 0x8480
call sleep

call clear_line
mov si, knock_str
call print_str_fast

mov cx, 0x001e   ; sleep 2s
mov dx, 0x8480
call sleep

call clear_line
mov cx, 0x001e   ; sleep 2s
mov dx, 0x8480
call sleep

jmp start             ; main loop

print_char:       ; print one char from al register
mov ah, 0x0E      ; info register for the bios interupt
                  ; it says that we want to print an char
mov bh, 0x00      ; Page number 0
mov bl, 0x07      ; Text atribute lightgray font on black background

int 0x10          ; call bios interupt
ret               

print_str:        ; print an String, start pointer is in si register
next_char:
mov al, [si]
inc si
or al, al         ; check if zero (end of str)
jz exit_print_str
call print_char
mov cx, 0x0001
mov dx, 0x86a0
call sleep
jmp next_char
exit_print_str:
ret

print_str_fast:        ; print an String, start pointer is in si register
next_char_fast:
mov al, [si]
inc si
or al, al         ; check if zero (end of str)
jz exit_print_str_fast
call print_char
jmp next_char_fast
exit_print_str_fast:
ret

clear_line:
mov al, 0x0d      ; "\r" to start of line
call print_char
mov al, 0x20      ; space
mov si, 40
next_space:
call print_char
dec si
or si, si
jz exit_clear
jmp next_space
exit_clear:
mov al, 0x0d      ; "\r" to start of line
call print_char
ret



sleep:            ; expect mumber of miliseconsd in CX (High) and Dx (Low)
mov ah, 0x86
int 0x15
ret

wakeup_str: db 'Wake up, Neo...', 0 ; string null terminated
matrix_str: db 'The Matrix has you...', 0
rabit_str:  db 'Follow the white rabbit.',0
knock_str:  db 'Knock, knock, Neo.',0
times 510 - ($ - $$) db 0
dw 0xAA55
