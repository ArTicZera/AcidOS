[BITS    16]

RunCommand:
        pusha

        ;"clear" command
        mov     si, cmdbuffer
        mov     di, clear
        mov     cx, 0x06
        repe    cmpsb
        jcxz    .exeClear

        ;"waitkey" command
        mov     si, cmdbuffer
        mov     di, waitkey
        mov     cx, 0x08
        repe    cmpsb
        jcxz    .exeWaitKey

        ;In case of unknown commands
        mov     word [cursorX], 0x00
        inc     word [cursorY]

        mov     si, unknowncmd
        mov     al, 0x0C
        call    PrintString

        popa

        ret

.exeClear:
        mov     word [cursorX], 0x00
        mov     word [cursorY], 0x00

        call    ClearScreen

        popa

        ret
    
.exeWaitKey:
        call    ReadKey

        popa

        ret

clear: db "clear"
waitkey: db "waitkey"
