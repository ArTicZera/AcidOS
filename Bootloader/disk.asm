[BITS    16]

;AL = Sectors to read
;CH = Cylinder
;DH = Head
;CL = Sector
;ES:BX = Point to buffer
ReadSectors:
        push    ax
        push    cx
        push    dx

        call    LBAtoCHS

        mov     ah, 0x02
        int     0x13

        pop     dx
        pop     cx
        pop     ax

        ret

;in: AX = LBA Address
;out: CL, CH, DH = S, C, H
LBAtoCHS:
        push    ax
        push    dx

        xor     dx, dx
        div     word [SectorsPerTrack]
        
        ;S (CX) = (LBA % SPT) + 1
        mov     cx, dx
        inc     cx

        xor     dx, dx
        div     word [HeadsOrSides]

        ;H (DH) = (LBA % SPT) % HPC
        mov     dh, dl

        ;C (CH) = (LBA % SPT) / HPC
        mov     ch, al
        shl     ah, 0x06
        or      cl, ah

        pop     ax

        mov     dl, al

        pop     dx

        ret
