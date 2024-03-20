[BITS    16]

;SI = String (end with 0x00)
;BL = Color
printstr:
        pusha

        mov     ah, 0x0E
        mov     al, [si]

        printstr.loop:
                int     0x10

                inc     si
                mov     al, [si]
                
                cmp     al, 0x00
                jne     printstr.loop

        popa

        ret

;AX = Value
printdec:
        pusha
                xor cx, cx
                xor dx, dx

                printdec.loop:
                        ;AX = AX / BX
                        ;DX = REMAINDER
                        cmp ax, 0x00
                        je printdec.print

                        mov bx, 0x0A
                        div bx

                        ;Save number
                        push dx

                        inc cx

                        xor dx, dx
                        jmp printdec.loop

                printdec.print:
                        cmp cx, 0x00
                        je printdec.exit

                        pop dx

                        ;Converts to ASCII
                        add dx, '0'

                        ;Print number
                        mov ah, 0x0E
                        mov bl, 0x0F
                        mov al, dl
                        int 0x10

                        dec cx

                        jmp printdec.print

printdec.exit:
        popa

        ret

;AX = Debug string
;SI = Message
;BL = Debug color
;BH = Message color
debug:
        push    bx
        push    si

        ;Print Debug Char
        mov     si, ax
        call    printstr

        pop     si

        ;Print Message
        mov     bl, bh
        call    printstr

        pop     bx

        ret

DONE: db "[+] ", 0x00
FAIL: db "[-] ", 0x00
HOLD: db "[?] ", 0x00
