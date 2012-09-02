[bits 16]
[org 0x7c00]

mov ax, 0x0000
mov ds, ax
mov si, wakeup_str
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
mov cx, 0x0001
mov dx, 0x86a0
call sleep
jmp next_char
exit_print_str:
ret

sleep:            ; expect mumber of miliseconsd in CX (High) and Dx (Low)
mov ah, 0x86
int 0x15
ret

wakeup_str: db 'Wake up, Neo...', 0 ; string null terminated
times 510 - ($ - $$) db 0
dw 0xAA55
