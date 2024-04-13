[BITS    16]
[ORG 0x0100]

ProgramMain:
        mov     ax, 0x13
        int     0x10

        call    InitMouse
        call    EnableMouse

ProgramLoop:
        cmp     word [ButtonStatus], 0x09
        je      paint

        jmp     ProgramLoop

paint:
        mov     ah, 0x0C
        mov     al, 0x0F

        mov     cx, [MouseX]
        mov     dx, [MouseY]

        sub     dx, 2

        int     0x10

        jmp     ProgramLoop

%include "Include/acidos.asm"
%include "Drivers/mouse.asm"
%include "Include/vga.asm"