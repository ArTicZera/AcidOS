[BITS    16]

%define VIDEOMODE 0x4105

%define WSCREEN 1024
%define HSCREEN 768
%define BPP     8

SetupVESA:
        call    GetModeInfo
        call    CheckMode
        call    SetMode

        ret

GetModeInfo:
        mov     di, VBEModeInfo
        mov     cx, VIDEOMODE
        mov     ax, 0x4F01
        int     0x10

        ret

CheckMode:
        ;Check if its compatible

        cmp     [XResolution], word WSCREEN
        jne     VESAError

        cmp     [YResolution], word HSCREEN
        jne     VESAError
        
        cmp     [BitsPerPixel], byte BPP
        jne     VESAError

        ret

SetMode:
        mov     ax, 0x4F02
        mov     bx, VIDEOMODE
        int     0x10

        ret
    
VESAError:
        mov     ah, 0x0E
        mov     al, 'X'
        int     0x10

        cli
        hlt

        jmp     $

VBEModeInfo:
        ModeAttributes:      dw 0
        WinAAttributes:      db 0
        WinBAttributes:      db 0
        WinGranularity:      dw 0
        WinSize:             dw 0
        WinASegment:         dw 0
        WinBSegment:         dw 0
        WinFuncPtr:          dd 0
        BytesPerScanLine:    dw 0

        XResolution:         dw 0
        YResolution:         dw 0
        XCharSize:           db 0
        YCharSize:           db 0
        NumberOfPlanes:      db 0
        BitsPerPixel:        db 0
        NumberOfBanks:       db 0
        MemoryModel:         db 0
        BankSize:            db 0
        NumberOfImagePages:  db 0
        Reserved0:           db 1

        RedMaskSize:         db 0
        RedFieldPosition:    db 0
        GreenMaskSize:       db 0
        GreenFieldPosition:  db 0
        BlueMaskSize:        db 0
        BlueFieldPosition:   db 0
        RsvdMaskSize:        db 0
        RsvdFieldPosition:   db 0
        DirectColorModeInfo: db 0

        LFBAddress:          dd 0
        OffScrMemoryOffset:  dd 0
        OffScrMemorySize:    dw 0

        times 206 db 0x00
