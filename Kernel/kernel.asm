[BITS    16]
[ORG 0x0000]

KernelMain:
        ;Set VGA Mode 13h
        mov     ax, 0x13
        int     0x10

        mov     si, welcomemsg
        mov     al, 0x0E
        call    PrintString

        jmp     Shell

welcomemsg: db "Welcome to AcidOS!", 0x0F, 0x0F, 0x00

%include "Graphics/graphics.asm"
%include "Font/ProggyCleanTT.asm"
%include "Font/font.asm"
%include "Drivers/keyboard.asm"
%include "Shell/shell.asm"
%include "Shell/commands.asm"
