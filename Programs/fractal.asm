[BITS    16]
[ORG 0x0100]

[EXTERN retaddr]

%define WSCREEN 320
%define HSCREEN 200

ProgramMain:
        ;Set Pixel Function
        mov     ah, 0x0C

        ;X = 0, Y = 0
        xor     cx, cx
        xor     dx, dx

        .palette:
                push    cx

                ;AL = (X ^ Y) / 2
                xor     cx, dx
                mov     al, cl
                shr     al, 0x01

                pop     cx

        .draw:
                cmp     cx, WSCREEN
                jae     .nextLine

                cmp     dx, HSCREEN
                jae     .end

                int     0x10

                ;Next pixel
                inc     cx
                
                jmp     .palette

        .nextLine:
                ;X = 0, Y++
                xor     cx, cx
                inc     dx

                jmp     .palette

.end:
        ;Wait for key
        xor     ax, ax
        int     0x16

        ;Clear Screen
        mov     ax, 0x13
        int     0x10

        jmp     return

%include "Include/acidos.asm"
