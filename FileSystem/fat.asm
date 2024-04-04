[BITS    16]

LoadRootDir:
        pusha

        mov     ax, 19
        mov     cl, al
        mov     bx, RootDirBuffer
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
