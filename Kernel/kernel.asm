[BITS    16]
[ORG 0x0000]

KernelMain:
        mov     [DriveNumber], dl

        ;Set VGA Mode 13h
        mov     ax, 0x13
        int     0x10

        call    GetCPUInfo

        ;Reset Cursor
        mov     word [cursorX], 0x00
        mov     word [cursorY], 0x00

        mov     si, welcomemsg
        mov     al, 0x0E
        call    PrintString

        call    LoadRootDir

        jmp     Shell

welcomemsg: db "Welcome to AcidOS!", 0x0F, 0x0F, 0x00

%include "Graphics/graphics.asm"
%include "Font/isoFont.asm"
%include "Graphics/print.asm"
%include "Drivers/keyboard.asm"
%include "Memory/mem.asm"
%include "FileSystem/disk.asm"
%include "FileSystem/fat.asm"
%include "CPU/cpu.asm"
%include "Shell/shell.asm"
%include "Shell/commands.asm"

RootDirBuffer:
