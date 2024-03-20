[BITS    16]
[ORG 0x0000]

KernelMain:
        mov     si, krnlmsg
        mov     al, 0x0F
        call    printstr

%include "Graphics/print.asm"
