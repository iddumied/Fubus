[bits 16]
[org 0x7c00]

mov ax, 0x0000
mov ds, ax
mov si, hello_world_str
call print_str
jmp $             ; main loop

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
jmp next_char
exit_print_str:
ret

hello_world_str: db 'Hello World', 0 ; string null terminated
times 510 - ($ - $$) db 0
dw 0xAA55
