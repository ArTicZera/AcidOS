[BITS    16]

RunCommand:
        pusha
        
        mov     si, cmdbuffer
        mov     di, clear
        mov     cx, 0x06
        repe    cmpsb
        jcxz    .exeClear

        mov     si, cmdbuffer
        mov     di, waitkey
        mov     cx, 0x08
        repe    cmpsb
        jcxz    .exeWaitKey

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
        mov     di, showmem
        mov     cx, 0x08
        repe    cmpsb
        jcxz    .exeShowMem

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
    
.exeWaitKey:
        call    ReadKey

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

.exeShowMem:
        call    NextLine
        call    DetectXMS

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

clear:    db "clear"
waitkey:  db "waitkey"
echo:     db "echo"
reboot:   db "reboot"
dir:      db "dir"
showmem:  db "showmem"
help:     db "help"
shutdown: db "shutdown"
run:      db "run"

commands: db "clear    - Clear Screen", 0x0F
          db "waitkey  - Wait for key", 0x0F
          db "echo     - Shows a text", 0x0F
          db "reboot   - Reboot the machine", 0x0F
          db "dir      - Show root directory files", 0x0F
          db "shutdown - Shutdown the machine", 0x0F
          db "showmem  - Show extended memory", 0x0F
          db "run      - Run a program", 0x00

data:
