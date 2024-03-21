[BITS    16]
[ORG 0x7C00]

%define KERNELOFFSET 0x0000
%define KERNELSEG    0x1000

jmp short BootMain
nop

;BIOS Parameter Block
OEMIdentifier:       db "MSWIN4.1"
BytesPerSectors:     dw 512
SectorsPerClusters:  db 0x01
ReservedSectors:     dw 0x01
TotalFATs:           db 0x02
RootDirEntries:      dw 0xE0
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

BootMain:
        ;Save Drive's number
        mov     [DriveNumber], dl

        ;Setup Data Segments
        xor     ax, ax
        mov     ds, ax
        mov     es, ax

        ;Setup Stack
        mov     sp, 0x7C00
        mov     ss, ax

        call    ReadDrive
        call    LoadRootDir
        call    FindKernel

        jmp     LoadKernel

%include "Bootloader/disk.asm"
%include "Bootloader/fat.asm"

kernelbin:     db 'KERNEL  BIN'
kernelcluster: dw 0x00

times 510 - ($ - $$) db 0x00
dw 0xAA55

RootDirBuffer:
