[bits 16]
[org 0x7C00]

mov al, 65
call print_char
jmp $             ; main loop

print_char:       ; print one char from al register
mov ah, 0x0E     ; info register for the bios interupt
                  ; it says that we want to print an char
mov bh, 0x00     ; Page number 0
mov bl, 0x07     ; Text atribute lightgray font on black background

int 0x10          ; call bios interupt
ret               


times 510 - ($ - $$) db 0
dw 0xAA55
