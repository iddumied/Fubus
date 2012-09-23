[bits 16]
[org 0x7c00]

; create a stack
cli                     ; disable interrupts
mov   ax, 0x9000        ; stack address
mov   ss, ax            ; start of Stack
mov   sp, 0             ; stackpointer
sti                     ; allow interrupts

; save bootdevice from dl
mov   [bootdev], dl

; reset bootdevice
reset:
mov   ax, 0x0          ; interrupts option 0 = reset device
mov   dl, [bootdev]    ; device is bootdevice
int   0x13             ; call bios interupt 13h
jc    reset            ; fail? try again


; load the Kernel from Bootdevice
read_sector:
mov   ax, 0x1000        ;
mov   es, ax            ; Adress of readbuffer = ES:BX = 0x1000
mov   bx, 0x0           ;

; interrupts pareameters 
mov   ah, 0x2           ; read Sector 
mov   al, 0xA           ; read 10 sectors
mov   cx, 0x2           ; Cylinder 0 (ch), Sector 2 (cl)
mov   dh, 0             ; Head 0
mov   dl, [bootdev]     ; bootdevice           
int   0x13              ; call bios interupt 13h
jc    read_sector       ; fail? try again

; print boot message
mov   si, loadmsg       ; load str address
call  print_str         ; 
mov   cx, 0x001e        ; sleep 2s
mov   dx, 0x8480        ;
call  sleep             ;

; jump to kernel code
mov   ax, 0x1000        ; start adress of the kernel code
mov   es, ax            ; update extra data pointer
mov   ds, ax            ; update data pointer
jmp   0x1000:0x0000     ; jump to kernel code


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

bootdev db 0            ; the bootdevice
loadmsg db 'Kernel loaded starting ...', 0 ; load message

times 510 - ($ - $$) db 0
dw 0xAA55
