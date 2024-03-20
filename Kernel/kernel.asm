[BITS    16]
[ORG 0x0000]

KernelMain:
        mov     si, krnlmsg
        mov     al, 0x0F
        call    printstr

krnlmsg: db "Welcome to AcidOS!", 0x0A, 0x0A, 0x0D, 0x00

%include "Graphics/print.asm"
