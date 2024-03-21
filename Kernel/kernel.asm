[BITS    16]
[ORG 0x0000]

call    SetupVESA

KernelMain:
        mov     si, welcomemsg
        mov     bl, 0x47
        call    printstr

        jmp     $

welcomemsg: db "Welcome to AcidOS!", 0x0A, 0x0A, 0x0D, 0x00

%include "Graphics/print.asm"
%include "Graphics/vesa.asm"

times (510 * 60) - ($ - $$) db 0x00
