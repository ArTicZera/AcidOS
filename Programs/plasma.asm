[BITS    16]
[ORG 0x0100]

%define WSCREEN 320
%define HSCREEN 200

ProgramMain:
        push    0xA000
        pop     es

        fninit

.reset:
        xor     bp, bp
        xor     dx, dx
        xor     di, di

        inc     word [time]

        cmp     word [time], 750
        je      .end

        .palette:
                push    bp

                add     bp, [time]
                mov     word [zx], bp
                mov     word [zy], dx

                shr     word [zx], 0x03
                shr     word [zy], 0x03

                pop     bp

                ;pr3 = = 128.0 + (128.0 * sin(zx / 8.0)) 
                fild    dword [zx]
                fdiv    dword [pr4]
                fsin
                fdiv    dword [pr1]
                fmul    dword [pr1]
                fadd    dword [pr1]
                fstp    dword [pr3]

                ;pr2 = (128.0 + (128.0 * sin(zy / 8.0))) + pr3
                fild    dword [zy]
                fdiv    dword [pr4]
                fsin
                fdiv    dword [pr1]
                fmul    dword [pr1]
                fadd    dword [pr1]
                fadd    dword [pr3]
                fstp    dword [pr2]

                mov     al, [pr2]
                sub     al, [time]
                shr     al, 0x03

                call    VGAPalette

        .draw:
                cmp     bp, WSCREEN
                jae     .nextLine

                cmp     dx, HSCREEN
                jae     .reset

                stosb

                inc     bp
                
                jmp     .palette

        .nextLine:
                xor     bp, bp
                inc     dx

                jmp     .palette

.end:
        call    ReadKey

        mov     ax, 0x13
        int     0x10

        jmp     return

time: dw 0x00

zx: dd 0.0
zy: dd 0.0

pr1: dw 8.0
pr2: dw 0.0
pr3: dw 0.0
pr4: dd 12.0

%include "Drivers/keyboard.asm"
%include "Include/acidos.asm"
%include "Include/vga.asm"
