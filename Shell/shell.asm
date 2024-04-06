[BITS    16]

%define PROMPTCOLOR 0x47
%define TEXTCOLOR   0x0F

%define BUFFSIZE 0x40

Shell:
        call    PrintLocalDir
        call    GetCommand
        call    RunCommand
        call    ResetBuffer
        call    PrintEndLine

        jmp     Shell

PrintLocalDir:
        pusha

        mov     si, localdir
        mov     al, PROMPTCOLOR
        call    PrintString

        popa

        ret

GetCommand:
        pusha

        call    ReadKey

        xor     si, si
        mov     bl, 0x0F

        .cmdLoop:
                mov     [cmdbuffer + si], al

                cmp     al, 0x08
                je      .backspace

        .printLetter:
                call    PrintChar
                call    ReadKey

                jmp     .compare

        .backspace:
                dec     si

                mov     [cmdbuffer + si], al

                dec     word [cursorX]

                jmp     .printLetter

        .compare:
                cmp     al, 0x20
                je      getarg

                inc     si

                cmp     al, 0x0D
                jne     .cmdLoop

        popa

        ret

getarg:
        call    PrintChar
        call    ReadKey
        
        xor     si, si
        mov     bl, 0x0F

        .argLoop:
                mov     [argbuffer + si], al

                cmp     al, 0x08
                je      .argBackspace

        .argPrintLetter:
                call    PrintChar
                call    ReadKey

                jmp     .argCompare

        .argBackspace:
                dec     si

                mov     [argbuffer + si], al

                dec     word [cursorX]

                jmp     .argPrintLetter
        
        .argCompare:
                inc     si

                cmp     al, 0x0D
                jne     .argLoop
        popa

        ret

ResetBuffer:    
        pusha

        ;Reset cmd buffer
        mov     di, cmdbuffer
        mov     cx, BUFFSIZE
        mov     al, 0x00
        rep     stosb

        ;Reset arg buffer
        mov     di, argbuffer
        mov     cx, BUFFSIZE/2
        mov     al, 0x20
        rep     stosb

        popa

        ret

PrintEndLine:
        pusha

        call    NextLine

        popa

        ret

endl: db 0x0A, 0x0A, 0x0D
localdir: db ">/", 0x00

cmdbuffer: times BUFFSIZE db 0x00
argbuffer: times BUFFSIZE / 2 db 0x20

unknowncmd: db "Unknown command, please try again!", 0x00 
