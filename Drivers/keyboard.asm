[BITS    16]

;OUT: AL = Key pressed
ReadKey:
        mov     ax, 0x00
        int     0x16

        ret
