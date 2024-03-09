[BITS    16]
[ORG 0x7C00]

jmp short bootmain
nop

;BIOS Parameter Block
OEMIdentifier:       db "MSWIN4.1"
BytesPerSectors:     dw 512
SectorsPerClusters:  db 0x01
ReservedSectors:     dw 0x01
TotalFATs:           db 0x02
RootDirEntries:      dw 224
LogicalSectors:      dw 2880
MediaDescriptorType: db 0xF0
SectorsPerFAT:       dw 0x09
SectorsPerTrack:     dw 0x12
HeadsOrSides:        dw 0x02
HiddenSectors:       dd 0x00
LargeSectorCount:    dd 0x00

;Extended Boot Record - FAT 12
DriveNumber: db 0x00
Reserved:    db 0x00
Signature:   db 0x29
VolumeID:    dd 0x00
VolumeLabel: db "ACIDOS     "
FileSystem:  db "FAT12   "

bootmain:
        mov [DriveNumber], dl

        ;Setup Data Segments
        xor     ax, ax
        mov     ds, ax
        mov     es, ax

        ;Setup Stack (SP, SS)
        mov     sp, 0x7C00
        mov     ss, ax

        ;Set VESA 1920x1080
        mov     ax, 0x4F02
        mov     bx, 0x4117
        int     0x10

        ;"[+] Booted from floppy..."
        mov     si, bootmsg
        mov     ax, DONE
        mov     bl, 0x0A
        mov     bh, 0x0F
        call    debug

        jmp     $

%include "Graphics/print.asm"
%include "Bootloader/disk.asm"
%include "Bootloader/fat.asm"

bootmsg: db "Booted from floppy...", 0x0A, 0x0A, 0x0D, 0x00

times 510 - ($ - $$) db 0x00
dw 0xAA55
