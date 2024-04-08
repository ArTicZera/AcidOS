[BITS    16]

;----------------------------------------

;Detect Extended Memory
DetectXMS:
        pusha
        
        clc

        ;Get XMS information
        mov     eax, 0xE801
        int     0x15

        jc      xmsfailed

        mov     ax, bx
        call    PrintDec

        popa

        ret

xmsfailed:
        mov     si, XMSFAIL
        mov     al, 40
        call    PrintString

        popa

        ret

;----------------------------------------

XMSOK: db "Total extended memory (kb): ", 0x00
XMSFAIL: db "Failed to detect extended memory!", 0x00
