[BITS    16]

;SI = String
;BL = Color
VGAPrint:
        pusha

        mov     ah, 0x0E
        mov     al, [si]

        VGAPrint.loop:
                int     0x10

                inc     si
                mov     al, [si]

                cmp     al, 0x00
                jne     VGAPrint.loop

        popa

        ret

;---------------------------------------------

VGAPrintDec:
        pusha

        xor     cx, cx
        xor     dx, dx

        .printDecLoop:
                ;AX = AX / BX
                ;DX = REMAINDER
                cmp     ax, 0x00
                je      .printDec

                mov     bx, 0x0A
                div     bx

                ;Save number
                push    dx

                inc     cx

                xor     dx, dx
                jmp     .printDecLoop

        .printDec:
                cmp     cx, 0x00
                je      VGAPrintDec.end

                pop     dx

                ;Converts to ASCII
                add     dx, '0'
                        
                ;Print number
                mov     ah, 0x0E
                mov     al, dl
                mov     bl, 0x0F
                int     0x10

                dec     cx

                jmp     .printDec
        
VGAPrintDec.end:
        popa

        ret

;---------------------------------------------

VGAPalette:
        cmp     al, 32
        jb      addcolor

        cmp     al, 55
        ja      subcolor

        ret

addcolor:
        add     al, 16
        jmp     VGAPalette

subcolor:
        sub     al, 32
        jmp     VGAPalette

;---------------------------------------------

;DH = Row
;DL = Column
VGASetCursor:
        pusha

        mov     ah, 0x02
        mov     bh, 0x00
        int     0x10

        popa

        ret
