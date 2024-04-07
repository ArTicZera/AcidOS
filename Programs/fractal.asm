[BITS    16]
[ORG 0x0100]

[EXTERN retaddr]

%define WSCREEN 320
%define HSCREEN 200

ProgramMain:
        mov     ah, 0x0C

        xor     cx, cx
        xor     dx, dx

        .palette:
                push    cx

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

                inc     cx
                
                jmp     .palette

        .nextLine:
                xor     cx, cx
                inc     dx

                jmp     .palette

.end:
        xor     ax, ax
        int     0x16

        mov     ax, 0x13
        int     0x10

        jmp     return

%include "Include/acidos.asm"
