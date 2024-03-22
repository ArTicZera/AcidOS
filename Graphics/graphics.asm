[BITS    16]

ClearScreen:
        push    ax

        mov     ax, 0x13
        int     0x10

        pop     ax

        ret
