;https://stackoverflow.com/questions/54280828/making-a-mouse-handler-in-x86-assembly

[BITS    16]

%define WCURSOR 8
%define HCURSOR 11

InitMouse:
        ;Get equipment list
        int     0x11

        ;Test PS/2
        test    ax, 0x04
        jz      noMouse

        ;Init mouse
        mov     ax, 0xC205
        mov     bh, 0x03
        int     0x15
        jc      noMouse

        ;Set resolution
        mov     ax, 0xC203
        mov     bh, 0x03
        int     0x15
        jc      noMouse

        ret

EnableMouse:
        call    DisableMouse

        ;Set mouse callback
        mov     ax, 0xC207
        mov     bx, MouseCallback
        int     0x15

        ;Enable mouse
        mov     ax, 0xC200
        mov     bh, 0x01
        int     0x15

        ret

DisableMouse:
        mov     ax, 0xC200
        mov     bh, 0x00 
        int     0x15

        mov     ax, 0xC207
        int     0x15

        ret

;-----------------------------------------

MouseCallback:
        push    bp                     ; Function prologue
        mov     bp, sp
        
        pusha

        push    cs
        pop     ds                      ; DS = CS, CS = where our variables are stored

	    call    HideCursor

        mov     al,[bp + 12]
        mov     bl, al
        mov     cl, 3
        shl     al, cl

        sbb     dh, dh
        cbw
        mov     dl, [bp + 8]
        mov     al, [bp + 10]

        neg     dx
        mov     cx, [MouseY]
        add     dx, cx
        mov     cx, [MouseX]
        add     ax, cx

        mov     [ButtonStatus], bl
        mov     [MouseX], ax
        mov     [MouseY], dx

        mov     si, mousebmp
        mov     al, 0x0F
        call	DrawCursor

        popa

        pop bp

mouse_callback_dummy: retf

;-----------------------------------------

DrawCursor:
	pusha

        mov     ah, 0x0C
        mov     bx, [si]

        mov     cx, [MouseX]
        mov     dx, [MouseY]

        jmp     .loopX

        .loopY:
                inc     si
		        mov     bx, [si]
                
                mov     cx, [MouseX]
                inc     dx

		        mov	di, HCURSOR
		        add	di, [MouseY]

                cmp     dx, di
                jae     .end

                .loopX:

                        test    bx, 0x80
                        jz      .continue

                        int     0x10

                .continue:
                        inc     cx
                        inc     di

                        shl     bx, 0x01

			            mov     bp, WCURSOR
			            add	bp, [MouseX]

                        cmp     cx, bp
                        jae     .loopY

                        jmp     .loopX

.end:
        popa

        ret

HideCursor:
        pusha

        mov     si, mousebmp
        mov     al, 0x00
        call    DrawCursor

        popa

        ret
        
;-----------------------------------------

noMouse:
        cli
        hlt

        jmp     noMouse

;-----------------------------------------

MOUSEFAIL: db "An unexpected error happened!", 0x00
MOUSEINITOK: db "Mouse initialized!", 0x0F, 0x00

ButtonStatus: dw 0
MouseX: dw 0
MouseY: dw 0

mousebmp:
db 0b10000000
db 0b11000000
db 0b11100000
db 0b11110000
db 0b11111000
db 0b11111100
db 0b11111110
db 0b11111000
db 0b11011100
db 0b10001110
db 0b00000110