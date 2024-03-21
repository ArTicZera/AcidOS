[BITS    16]

;FAT size (sectors) = FAT sectors * FAT tables
;FAT size (bytes) = FAT sectors * FAT tables * Bytes per sector

;---------------------------------------------------------------------

;Root entry = 32 bytes
;Root directory size = (Dir entry count * Root entry + Bytes per sector - 1) / Bytes per sectors
;Bytes per sector - 1 makes that any parcial part of an sector be rounded up to the next sector

;FILE NAME (always 11 chars) ex: "KERNEL  BIN" (uses first low cluster since its FAT12)

;---------------------------------------------------------------------

;Logical Block Address for a cluster
;LBA = Data region begin + (cluster-2) * Sectors per cluster
;Data region begin = Reserved + FAT tables + Root directory
;Data region begin = LBA address of the begin of data section in our FAT
;Cluster-2 = Storage unit since cluster 0 is reserved and cluster 1 is our FAT

;---------------------------------------------------------------------

;MicroOS File System
;FAT size (sectors) = 9 * 2 = 18
;FAT size (bytes) = 18 * 512 = 9216
;Data region begin = 19
;Root dir size = (224 * 32 + 511) / 512 = 14
;LBA = 1+18+14 + (3-2) * 1 = 33

;---------------------------------------------------------------------

;Reading files from directories

;1 - Slit path into components and convert to FAT file naming scheme

;2 - Read first directory from root directory, using same procedure as reading files.

;3 - Search the next component from the path in the directory, and read it

;4 - Repeat until reaching and reading the file

;-------------------------------------------------------------

LoadRootDir:
        ;Clear for division and multiplication
        xor     dx, dx
        xor     bx, bx

        ;Compute the Root Directory Size
        ;RootDirSize = (Entries * 32) / BytesPerSectors
        mov     ax, [RootDirEntries]
        shl     ax, 0x05
        div     word [BytesPerSectors]

        ;Compute the Root Directory's LBA
        ;RootDirLBA = (TotalFATs * SectorsPerFAT) + ReservedSectors
        mov     ax, [SectorsPerFAT]
        mov     bl, [TotalFATs]
        mul     bx
        add     ax, [ReservedSectors]

        ;Read the Root Directory
        mov     cl, al
        mov     dl, [DriveNumber]
        mov     bx, RootDirBuffer
        call    DiskRead

        ret

;-------------------------------------------------------------

FindKernel:
        ;BX is a counter in the loop
        ;DI is the RootDirBuffer to compare
        xor     bx, bx
        mov     di, RootDirBuffer

        .searchKernel:
                ;Compare up to 11 chars
                mov     si, kernelbin
                mov     cx, 11
                push    di
                repe    cmpsb
                pop     di

                je      .foundKernel
                
                ;Go to the next file
                add     di, 0x20
                inc     bx
                
                ;If it didn't found, then check again
                cmp     bx, [RootDirEntries]
                jl      .searchKernel

                ;Everything was checked but didn't found
                jmp     .failedKernel
        
        .foundKernel:
                ;Gets kernel first logical cluster
                mov     ax, [di + 26]
                mov     [kernelcluster], ax

                ;Load FAT to memory
                mov     ax, [ReservedSectors]
                mov     bx, RootDirBuffer
                mov     cl, [SectorsPerFAT]
                mov     dl, [DriveNumber]
                call    DiskRead 

        ret

.failedKernel:
        mov     ah, 0x0E
        mov     al, 'X'
        int     0x10

        cli
        hlt

;-------------------------------------------------------------

LoadKernel:
        ;Read Kernel and process FAT chain
        mov     bx, KERNELSEG
        mov     es, bx
        mov     bx, KERNELOFFSET

        .kernelLoop:
                ;Read next cluster
                mov     ax, [kernelcluster]

                mov     dl, [DriveNumber]
                add     ax, 0x1F
                mov     cl, 0x01
                call    DiskRead

                add     bx, [BytesPerSectors]

                ;Get the location of the next cluster
                mov     ax, [kernelcluster]
                mov     cx, 0x03
                mul     cx

                mov     cx, 0x02
                div     cx

                ;AX = Index of entry in FAT
                ;DX = Cluster % 2

                ;Read entry from FAT table at index AX
                mov     si, RootDirBuffer
                add     si, ax
                mov     ax, [ds:si]

                or      dx, dx
                jz      .even
        
        .odd:
                shr     ax, 0x04
                jmp     .nextCluster

        .even:
                and     ax, 0x0FFF

        .nextCluster:
                ;End of chain
                cmp     ax, 0x0FF8
                jae     .end

                ;Loops again
                mov     [kernelcluster], ax
                jmp     .kernelLoop

        .end:
                mov     dl, [DriveNumber]

                mov     ax, KERNELSEG
                mov     ds, ax
                mov     es, ax

                jmp     KERNELSEG:KERNELOFFSET

                cli
                hlt
