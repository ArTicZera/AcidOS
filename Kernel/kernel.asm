[BITS    16]
[ORG 0x0000]

KernelMain:
        ;Set VGA Mode 13h
        mov     ax, 0x13
        int     0x10

        mov     si, welcomemsg
        mov     bl, 0x47
        call    printstr

        jmp     $

welcomemsg: db "Welcome to AcidOS!", 0x0A, 0x0A, 0x0D, 0x00

%include "Graphics/print.asm"

times (510 * 60) - ($ - $$) db 0x00
