[bits 16]
;[org 0x1000]    ; not neddedt, because loader sets data pointer

;print message and HALT
mov   si, kernelmsg
call  print_str
mov   si, addressmsg
call  print_str
mov   si, addressmsg
call  print_binar

mov   al, 0x20
call  print_char
mov   si, addressmsg
call  print_hex
mov   al, 0x20
call  print_char
lea   si, [hex]
call  print_hex
loop: jmp loop


; +---------------------+
; | Values and Fuctions |
; +---------------------+

; print one char from al register
print_char:             
mov   ah, 0x0E          ; info register for the bios interupt
                        ; it says that we want to print an char
mov   bh, 0x00          ; Page number 0
mov   bl, 0x07          ; Text atribute lightgray font on black background
int   0x10              ; call bios interupt
ret               

; print a String, start pointer is in si register
print_str:              
next_char:              ;
mov   al, [si]          ; start adress to al 
inc   si                ; let si point to next char
or    al, al            ; check if zero (end of str)
jz exit_print_str       ; exit if end of string is reatched
call print_char         ; else print current char
jmp next_char           ; load next char
exit_print_str:         ;
ret                     ; exit print_str

; expect mumber of miliseconsd in CX (High) and Dx (Low)
sleep:            
mov   ah, 0x86          ; Wait function
int   0x15              ; call bios interupt 15h
ret                     ; return

; print an 16 bit value from si
print_binar:
print_binar_next_chr:
mov   ax, 0x8000        ; MSB of 16 bit = 1
and   ax, si            ; if si[0] == 0 
jz    print_binar0      ; 
mov   al, 0x31          ; print 1    
call  print_char        ;
jmp   print_binar_next  ; 

print_binar0:           ;
mov   al, 0x30          ; print 0
call  print_char        ;

print_binar_next:
shl   si, 1             ; si << 1 (shift si left)
or    si, si            ; if si == 0 return
jz    print_binar_exit
jmp   print_binar_next_chr
print_binar_exit:
ret

; print an 16 bit value from si
print_hex:
mov   ax, 0xF000
mov   [hex], ax            ; first the highest 4 Bits
and   [hex], si            ;             
mov   ax, [hex]
shr   ax, 12
mov   [hex], ax
call  print_hex_chr

mov   ax, 0x0F00
mov   [hex], ax
and   [hex], si
mov   ax, [hex]
shr   ax, 8
mov   [hex], ax
call  print_hex_chr

mov   ax, 0x00F0
mov   [hex], ax
and   [hex], si
shr   [hex], 4
call  print_hex_chr

mov   ax, 0x000F
mov   [hex], ax
and   [hex], si
call  print_hex_chr
ret


; prints an hex value from [hex]
print_hex_chr:
mov   ax, [hex]
and   ax, 0x000F
mov   [hex], ax

mov   ax, 0xA     
cmp   [hex], ax         ; if hex >= 0xA
jge   print_hex_chr_A   ;

mov   ax, 0x30          ; else, al = '0'
add   ax, [hex]         ; al + ax
call print_char         ;
jmp print_hex_chr_exit  ;

print_hex_chr_A:        
mov   ax, 0x41          ; start bei al = 'A'
sub   ax, 0xA    
add   ax, [hex]         
call  print_char

print_hex_chr_exit:     ; return
ret                     ;

tmp        dw  0
hex        dw  0
kernelmsg  db 'Kernel succesfull started', 0x0A, 0x0D, 0
addressmsg db 'This String is at Address: ', 0
