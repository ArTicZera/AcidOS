[BITS    16]

%define PROMPTCOLOR 0x47
%define TEXTCOLOR   0x0F

%define BUFFSIZE 0x20

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

        .cmdLoop:
                mov     [cmdbuffer + si], al

                cmp     al, 0x08
                je      .backspace

        .printLetter:
                push    si

                xor     bx, bx
                mov     bl, al
                shl     bx, 0x03

                mov     si, ProggyFont
                add     si, bx

                mov     al, TEXTCOLOR

                call    DrawChar

                pop     si

                call    ReadKey

                jmp     .compare

        .backspace:
                dec     si

                mov     [cmdbuffer + si], al

                dec     word [cursorX]

                jmp     .printLetter

        .compare:

                inc     si

                cmp     al, 0x0D
                jne     .cmdLoop

        popa

        ret

ResetBuffer:    
        pusha

        mov     di, cmdbuffer
        mov     cx, BUFFSIZE
        mov     al, 0x00
        rep     stosb

        popa

        ret

PrintEndLine:
        pusha

        mov     word [cursorX], 0x00
        add     word [cursorY], 0x01

        popa

        ret

endl: db 0x0A, 0x0A, 0x0D
localdir: db ">/", 0x00

cmdbuffer: times BUFFSIZE db 0x00

unknowncmd: db "Unknown command, please try again!", 0x00 
