[BITS    16]

DetectXMS:
        pusha
        
        clc

        ;Get XMS information
        mov     eax, 0xE801
        int     0x15

        jc      xmsfailed

        mov     si, XMSOK
        mov     al, 74
        call    PrintString

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

XMSOK: db "Total extended memory (kb): ", 0x00
XMSFAIL: db "Failed to detect extended memory!", 0x00
