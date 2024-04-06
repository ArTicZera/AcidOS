[BITS    16]

%define PROGRAMSEGMNT 0x9000
%define PROGRAMOFFSET 0x0100

LoadRootDir:
        pusha

        mov     ax, 19
        mov     cl, al
        mov     bx, RootDirBuffer
        mov     dl, [DriveNumber]
        call    DiskRead

        popa

        ret

;This part was made by Leo Ono
;But I did some changes
PrintRoot:
        call    NextLine

        xor     bx, bx ;File counter
        xor     si, si ;Buffer index

        nextEntry:
                mov     dl, 0x00

                ;Name (8) + Extension (3) = 11
                mov     cx, 11

                ;AL = Attribute
                mov     al, [RootDirBuffer + si + 11]

                ;See if it's an empty entry or a final list
                cmp     al, 0x0F
                jz      skipToNextEntry

        printFile:
                ;Load the actual char in AL
                mov     al, [RootDirBuffer + si]

                ;Checks if its the first 
                ;iteration of this file
                cmp     dl, 0x01
                jz      printFileChar

                ;Iteration done
                mov     dl, 0x01

                ;Check if its '\0' (end)
                cmp     al, 0x00
                jz      PrintRoot.end

        printFileChar:
                push    bx

                ;Print Char
                mov     bl, 0x32
                call    PrintChar

                pop     bx

                ;Next char
                inc     si

                ;Check if processed every char
                cmp     cl, 0x04
                jnz     continuePrint

                ;Space between chars
                mov     al, ' '
                call    PrintChar

        continuePrint:
                loop    printFile

                call    NextLine

        checkDirEnd:
                ;Next file
                inc     bx

                cmp     bx, 128
                jz      PrintRoot.end

                add     si, 21
                jmp     nextEntry

        skipToNextEntry:
                add     si, 11
                jmp     checkDirEnd

PrintRoot.end:
        ret

;---------------------------------------------------

FindProgram:
        xor     bx, bx
        mov     di, RootDirBuffer

        .searchProgram:
                mov     si, argbuffer
                mov     cx, 8
                push    di
                repe    cmpsb
                pop     di

                je      .programFound

                add     di, 0x20
                inc     bx

                cmp     bx, 0xE0
                jl      .searchProgram

                jmp     .programFail

        .programFound:
                ;Get first cluster
                mov     ax, [di + 26]
                mov     [programcluster], ax

                ;Read FAT
                mov     ax, 0x01
                mov     bx, RootDirBuffer
                mov     cl, 0x09
                mov     dl, [DriveNumber]
                call    DiskRead

                call    RunProgram

                ret

.programFail:
        call    NextLine

        mov     si, PROGRAMFAIL
        mov     al, 0x0C
        call    PrintString

        ret

;---------------------------------------------------

RunProgram:
        ;Read Kernel and process FAT chain
        mov     bx, PROGRAMSEGMNT
        mov     es, bx
        mov     bx, PROGRAMOFFSET

        .kernelLoop:
                ;Read next cluster
                mov     ax, [programcluster]

                mov     dl, [DriveNumber]
                add     ax, 0x1F
                mov     cl, 0x01
                call    DiskRead

                add     bx, 512

                ;Get the location of the next cluster
                mov     ax, [programcluster]
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
                mov     [programcluster], ax
                jmp     .kernelLoop

        .end:
                mov     dl, [DriveNumber]

                mov     ax, PROGRAMSEGMNT
                mov     ds, ax
                mov     es, ax

                jmp     PROGRAMSEGMNT:PROGRAMOFFSET

                cli
                hlt

;---------------------------------------------------

PROGRAMFAIL: db "This program doesn't exist!", 0x00

programcluster: dw 0x00

retaddr: dd 0x00
