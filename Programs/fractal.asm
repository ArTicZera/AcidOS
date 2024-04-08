[BITS    16]
[ORG 0x0100]

%define WSCREEN 320
%define HSCREEN 200

ProgramMain:
        push    0xA000
        pop     es

        xor     bp, bp
        xor     dx, dx
        xor     di, di

        .palette:
                push    bp

                xor     bp, dx
                mov     bx, bp
                mov     al, bl
                shr     al, 0x01

                pop     bp

        .draw:
                cmp     bp, WSCREEN
                jae     .nextLine

                cmp     dx, HSCREEN
                jae     .end

                stosb

                inc     bp
                
                jmp     .palette

        .nextLine:
                xor     bp, bp
                inc     dx

                jmp     .palette

.end:
        xor     ax, ax
        int     0x16

        mov     ax, 0x13
        int     0x10

        jmp     return

%include "Include/acidos.asm"
