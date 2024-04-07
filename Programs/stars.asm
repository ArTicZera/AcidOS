[BITS    16]
[ORG 0x0100]

%define WSCREEN 320

%define STARS 200

ProgramMain:
        mov     ax, 0x13
        int     0x10

        ;Set pixel function
        mov     ah, 0x0C
        mov     al, 0x0F

        xor     cx, cx
        xor     dx, dx

        ;Stars index
        xor     bx, bx

.starsLoop:
        push    ax
        push    bx
        push    dx

        ;Linear congruential generator
        mov     ax, [seed]
        add     ax, [seed]
        add     ax, [seed]
        mov     [seed], ax

        ;Index = seed % WSCREEN
        xor     dx, dx
        mov     bx, WSCREEN
        div     bx

        ;X = Random position
        mov     cx, dx

        pop     dx
        pop     bx
        pop     ax

        ;Set Pixel
        int     0x10

        ;Next Index
        inc     bx

        ;Next line
        inc     dx

        ;Checks if it reached the max index
        cmp     bx, STARS
        jb      .starsLoop

        ;Wait key
        xor     ax, ax
        int     0x16

        jmp     return

seed: dw 0x01

%include "Include/acidos.asm"
