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

        mov     ah, 0x02
        int     0x13

        pop     dx
        pop     cx
        pop     ax

        ret

;in: AX = LBA Address
;out: CH, DH, CL, DL = C, H, S, Device
LBAtoCHS:
        push    ax
        push    dx
        
                ;AX = LBA / Sectors per track
                ;DX = LBA % Sectors per track
                xor     dx, dx
                div     word [SectorsPerTrack]

                ;CL = Sectors = DL + 1
                mov     cl, dl
                inc     cl

                ;AX = (LBA / Sectors per track) / Heads
                ;DX = (LBA / Sectors per track) % Heads
                xor     dx, dx
                div     word [HeadsOrSides]

                mov     ah, dl ;Save DL (Head)
                mov     ch, al ;AL = Cylinder
        
        pop     dx

                mov     dh, ah ;DH = Head
        
        pop     ax

        mov     dl, [DriveNumber]

        ret

CHStoLBA:
        ret
