[BITS    16]

SectorsPerTrack: dw 63
HeadsOrSides:    dw 16

LBAtoCHS:
        push    ax
        push    dx

        xor     dx, dx
        div     word [SectorsPerTrack]

        ;Sector (CX) = (LBA % SectorsPerTrack) + 1
        inc     dx
        mov     cx, dx

        xor     dx, dx
        div     word [HeadsOrSides]

        ;Head (DH) = (LBA / SectorsPerTrack) % HeadsOrSides
        mov     dh, dl

        ;Compute lower 8 bits cylinder
        mov     ch, al
        shl     ah, 0x06
        or      cl, ah

        pop     ax

        ;Restore DL value
        mov     dl, al

        pop     ax

        ret

;-------------------------------------------------------------

;IN:
;AX = LBA Address
;CL = Sectors to read
;DL = Drive number
;ES:BX = Buffer
DiskRead:
        pusha

        push    cx

        call    LBAtoCHS

        pop     ax

        mov     ah, 0x02
        int     0x13

        popa

        ret
