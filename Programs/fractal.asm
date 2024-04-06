[BITS    16]
[ORG 0x0100]

%define WSCREEN 320
%define HSCREEN 200

ProgramMain:
        mov     ah, 0x0C

        xor     cx, cx
        xor     dx, dx

        .palette:
                push    cx

                xor     cx, dx
                mov     al, cl
                shr     al, 0x01

                pop     cx

        .draw:
                cmp     cx, WSCREEN
                jae     .nextLine

                cmp     dx, HSCREEN
                jae     .end

                int     0x10

                inc     cx
                
                jmp     .palette

        .nextLine:
                xor     cx, cx
                inc     dx

                jmp     .palette

.end:
        jmp     0x0000:0x7C00
