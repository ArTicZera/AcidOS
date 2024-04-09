[BITS    16]
[ORG 0x0100]

ProgramMain:
        mov     ax, 0x13
        int     0x10

        ;10 numbers
        mov     cx, 15

        ;First number
        mov     ax, 1

        ;Last number
        xor     bx, bx

        call    VGAPrintDec
        call    PrintSpace  

        dec     cx

        jz      ProgramEnd

NextNumber:
        add     ax, bx
        call    VGAPrintDec
        
        call    PrintSpace

        xchg    ax, bx
        
        dec     cx        ; Decrementa o contador
        
        jnz NextNumber; Continua se ainda houver números a gerar

ProgramEnd:
        call    ReadKey

        mov     ax, 0x13
        int     0x10

        jmp     return

;------------------------------------------

PrintSpace:
        push    ax

        mov     ah, 0x0E
        mov     al, ' '
        int     0x10

        pop     ax 

        ret

teststr: db "Hello World!", 0x00

%include "Drivers/keyboard.asm"
%include "Include/acidos.asm"
%include "Include/vga.asm"
