[BITS    16]

return:
        mov     ax, 0x1000
        mov     ds, ax
        mov     es, ax

        jmp     0x1000:0x0003
