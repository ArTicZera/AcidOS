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

LoadRootDir:
        ;RootDirSize (AX) = Entries * 32 (Entry size)
        xor     dx, dx
        mov     ax, 0x20
        mul     word [RootDirEntries]

        ;RootDirSectors (AX) = RootDirSize / BytesPerSectors
        xor     dx, dx
        div     word [BytesPerSectors]

        ;CX = Root Dir Sectors
        xchg    ax, cx

        ret
