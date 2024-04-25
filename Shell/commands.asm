[BITS    16]

RunCommand:
        pusha
        
        mov     si, cmdbuffer
        mov     di, clear
        mov     cx, 0x06
        repe    cmpsb
        jcxz    .exeClear

        mov     si, cmdbuffer
        mov     di, echo
        mov     cx, 0x05
        repe    cmpsb
        jcxz    .exeEcho

        mov     si, cmdbuffer
        mov     di, reboot
        mov     cx, 0x07
        repe    cmpsb
        jcxz    .exeReboot

        mov     si, cmdbuffer
        mov     di, dir
        mov     cx, 0x04
        repe    cmpsb
        jcxz    .exeDir

        mov     si, cmdbuffer
        mov     di, help
        mov     cx, 0x05
        repe    cmpsb
        jcxz    .exeHelp

        mov     si, cmdbuffer
        mov     di, shutdown
        mov     cx, 0x09
        repe    cmpsb
        jcxz    .exeShutdown

        mov     si, cmdbuffer
        mov     di, run
        mov     cx, 4
        repe    cmpsb
        jcxz    .exeRun

        mov     si, cmdbuffer
        mov     di, neofetch
        mov     cx, 0x09
        repe    cmpsb
        jcxz    .exeNeofetch

        call    NextLine

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

.exeEcho:
        call    NextLine

        mov     si, argbuffer
        mov     al, 0x0F
        call    PrintString

        popa

        ret

.exeReboot:
        mov     al, 0xFE
        out     0x64, al

        cli
        hlt

        jmp     $

.exeDir:
        call   PrintRoot

        dec     word [cursorY]

        popa

        ret

.exeHelp:
        call    NextLine

        mov     si, commands
        mov     al, 0x0F
        call    PrintString

        popa

        ret

.exeShutdown:
        ;Shutdown by APM (Advanced Power Management)
        mov     ax, 0x5307
        mov     bx, 0x01
        mov     cx, 0x03

        int     0x15

        cli
        hlt

        jmp     $

.exeRun:
        call    FindProgram
        
.exeRunReturn:
        popa

        ret

.exeNeofetch:
        call    NextLine

        mov     si, fetch
        mov     al, 0x2B
        call    PrintString

        mov     al, 0x0F

        sub     word [cursorY], 0x05
        mov     word [cursorX], 0x08

        ;System: AcidOS
        mov     si, system
        call    PrintString

        inc     word [cursorY]
        mov     word [cursorX], 0x08

        mov     si, kernel
        call    PrintString

        inc     word [cursorY]
        mov     word [cursorX], 0x08

        mov     si, resolu
        call    PrintString

        inc     word [cursorY]
        mov     word [cursorX], 0x08

        mov     si, memory
        call    PrintString

        call    DetectXMS

        inc     word [cursorY]
        mov     word [cursorX], 0x08

        mov     si, vendor
        call    PrintString

        mov     word [cursorX], 0x00
        add     word [cursorY], 0x01

        popa

        ret

clear:    db "clear"
echo:     db "echo"
reboot:   db "reboot"
dir:      db "dir"
help:     db "help"
shutdown: db "shutdown"
run:      db "run"
neofetch: db "neofetch"

commands: db "clear    - Clear Screen", 0x0F
          db "echo     - Shows a text", 0x0F
          db "reboot   - Reboot the machine", 0x0F
          db "dir      - Show root directory files", 0x0F
          db "shutdown - Shutdown the machine", 0x0F
          db "neofetch - Show system informations", 0x0F
          db "run      - Run a program", 0x00

fetch: db "   #   ", 0x0F
       db "  # #  ", 0x0F
       db " #   # ", 0x0F
       db "#     #", 0x0F
       db " #   # ", 0x0F
       db "  ###", 0x00

system: db "System: AcidOS", 0x00
kernel: db "Kernel version: 1.0", 0x00
resolu: db "Resolution: 320x200", 0x00
memory: db "Memory (kb): ", 0x00
